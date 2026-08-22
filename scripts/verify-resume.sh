#!/usr/bin/env bash
# verify-resume.sh -- read-only verification harness for the resume PDF.
#
# Machine-first output contract, one line per assertion, stable order:
#   RESULT <id> <PASS|FAIL|WARN|INFO|SKIP> <human message>
#
# Exit vocabulary (load-bearing -- Plan 03 asserts on it):
#   0 = every BLOCKER passed
#   1 = at least one BLOCKER failed (the document is wrong)
#   2 = the harness could not run (missing tool, missing artifact, stale PDF)
# Note: GNU Make 3.81 exits 2 for ANY failed recipe, so the 1-vs-2 distinction is
# observable only when this script is invoked directly, not through a Make target.
#
# Implemented here: G0.1-G0.4 (preconditions), G1-G3 (structural page gates).
# G4-G6 land later in Plan 02; G7-G8 land in Plan 03.
#
# Written for bash 3.2.57 (a clean macOS box ships nothing newer). That rules out
# associative arrays, the bash-4 line-slurp read builtins, case-converting parameter
# expansion, and recursive glob expansion. Lookups use `case` or an on-demand grep.
#
# The harness is READ-ONLY. It never writes inside docs/, never invokes the build,
# and never updates a file's timestamp -- mutating the thing under test is exactly
# how a stale artifact gets blessed.

# No errexit on purpose: the harness must run every assertion and aggregate into
# BLOCKERS, so a single failing grep may not abort the run. Deliberately omitting
# -e here is the V7 control; -u and pipefail still apply.
set -uo pipefail

# ---------------------------------------------------------------------------
# Defaults and environment fallbacks
# ---------------------------------------------------------------------------

PDF="${VERIFY_PDF:-docs/AshutoshTiwari.pdf}"
TEX="${VERIFY_TEX:-docs/main.tex}"
MANIFEST="docs/verify/manifest.txt"
FROZEN="docs/verify/baseline-frozen.txt"

SKIP_FRESHNESS=0
MODE="verify"
CENSUS_FILE=""
BLOCKERS=0
WORK=""

# ---------------------------------------------------------------------------
# Usage
# ---------------------------------------------------------------------------

usage() {
    cat <<'USAGE'
Usage: verify-resume.sh [options]

Read-only verification harness for the resume PDF. Prints one
"RESULT <id> <status> <message>" line per assertion and exits
0 (all blockers pass), 1 (a blocker failed), or 2 (cannot verify).

Options:
  --pdf PATH          PDF under test          (default docs/AshutoshTiwari.pdf)
  --tex PATH          LaTeX source            (default docs/main.tex)
  --manifest PATH     Mutable manifest        (default docs/verify/manifest.txt)
  --frozen PATH       Honesty freeze          (default docs/verify/baseline-frozen.txt)
  --skip-freshness    Waive the G0.3 freshness proof: G0.3 emits SKIP and the run
                      CONTINUES instead of refusing. G0.1, G0.2 and G0.4 still run.
                      A run carrying this flag is NOT a verification pass. No build
                      target may pass it; it exists only for a negative control that
                      must mutate the source to prove a content gate fires.
  --selftest          Probe-build self-test               (implemented in Plan 03)
  --write-baseline    Regenerate the mutable manifest     (implemented in Plan 03)
  --census TEXTFILE   Glyph-class census over a raw text fixture. Runs G0.1 only;
                      skips G0.2/G0.3/G0.4 because no PDF and no TEX are read.
  -h, --help          Show this help and exit 0

Environment:
  VERIFY_PDF, VERIFY_TEX   Path fallbacks for --pdf / --tex
  VERIFY_TMPDIR            Parent directory for the scratch workspace

Remedies printed by this harness name the command to run; the harness never
runs a build itself.
USAGE
    return 0
}

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

while [ $# -gt 0 ]; do
    case "$1" in
        --pdf)            [ $# -ge 2 ] || { printf '!! --pdf needs a PATH\n' >&2; exit 2; }; PDF="$2"; shift 2 ;;
        --tex)            [ $# -ge 2 ] || { printf '!! --tex needs a PATH\n' >&2; exit 2; }; TEX="$2"; shift 2 ;;
        --manifest)       [ $# -ge 2 ] || { printf '!! --manifest needs a PATH\n' >&2; exit 2; }; MANIFEST="$2"; shift 2 ;;
        --frozen)         [ $# -ge 2 ] || { printf '!! --frozen needs a PATH\n' >&2; exit 2; }; FROZEN="$2"; shift 2 ;;
        --census)         [ $# -ge 2 ] || { printf '!! --census needs a TEXTFILE\n' >&2; exit 2; }; MODE="census"; CENSUS_FILE="$2"; shift 2 ;;
        --skip-freshness) SKIP_FRESHNESS=1; shift ;;
        --selftest)       MODE="selftest"; shift ;;
        --write-baseline) MODE="write-baseline"; shift ;;
        -h|--help)        usage; exit 0 ;;
        *)                printf '!! unknown option: %s (try --help)\n' "$1" >&2; exit 2 ;;
    esac
done

# ---------------------------------------------------------------------------
# Emitters. FAIL is the only status that moves the exit code.
# Each returns 0 so it can never abort a caller under pipefail.
# ---------------------------------------------------------------------------

result() {  # result <id> <PASS|FAIL|WARN|INFO|SKIP> <message>
    printf 'RESULT %-6s %-5s %s\n' "$1" "$2" "$3"
    if [ "$2" = FAIL ]; then
        BLOCKERS=$((BLOCKERS + 1))
    fi
    return 0
}

# warn <id> <owner> <message> -- the owner token is read from the manifest's
# WARN_OWNERS key, never hardcoded. A numeric owner prints as "Phase N"; the
# sentinels none/unassigned/any print verbatim so an owner-less corroborating
# check does not read as "Phase none". WARN never touches BLOCKERS, which is
# what makes this a visible deferral rather than a silent excuse.
warn() {
    case "$2" in
        ''|*[!0-9]*) printf 'RESULT %-6s %-5s %s (owner: %s)\n' "$1" WARN "$3" "$2" ;;
        *)           printf 'RESULT %-6s %-5s %s (owner: Phase %s)\n' "$1" WARN "$3" "$2" ;;
    esac
    return 0
}

info() {  # info <id> <message>
    printf 'RESULT %-6s %-5s %s\n' "$1" INFO "$2"
    return 0
}

# die2 <message> -- "cannot verify", exit 2. It deliberately emits NO RESULT
# line, so any assertion that refuses must emit its own
# `result <id> FAIL <message>` immediately BEFORE calling die2.
die2() {
    printf '!! %s\n' "$1" >&2
    exit 2
}

# ---------------------------------------------------------------------------
# Manifest readers. V5 control: the manifest is DATA, never code. It is read
# line-wise with grep and never sourced, never eval'd, and no command string is
# ever built from a value -- so a manifest line containing $(...), backticks or
# a semicolon is inert text. Values are interpolated only inside quoted args.
# ---------------------------------------------------------------------------

manifest_get() {  # manifest_get <KEY> -> single value, trailing "# annotation" stripped
    if [ ! -f "$MANIFEST" ]; then
        die2 "manifest not found: $MANIFEST"
    fi
    grep -m1 "^$1=" "$MANIFEST" 2>/dev/null \
        | sed -e "s/^$1=//" -e 's/[[:space:]]*#.*$//' -e 's/[[:space:]]*$//'
    return 0
}

manifest_list() {  # manifest_list <KEY> -> one pipe-separated item per line
    manifest_get "$1" | tr '|' '\n'
    return 0
}

# warn_owner <ID> -> the owner token the manifest records for a WARN-tier
# assertion. Never hardcode a phase number in an assertion: a promotion must be
# a one-line manifest edit, not a script change. An ID with no entry degrades to
# the "unassigned" sentinel so a WARN can never print an empty owner.
warn_owner() {
    _wo=$(manifest_list WARN_OWNERS | grep -m1 "^$1:" | sed "s/^$1://")
    if [ -z "$_wo" ]; then
        printf 'unassigned\n'
    else
        printf '%s\n' "$_wo"
    fi
    return 0
}

# emit_row <id> <status> <message> -- dispatches one "ID|STATUS|MESSAGE" row
# produced by an inlined python block onto the right emitter, so the RESULT
# contract and the BLOCKERS tally stay in one place. Callers MUST feed this from
# a file redirect, never a pipe: a pipe would run result() in a subshell and the
# BLOCKERS increment would be lost.
emit_row() {
    case "$2" in
        WARN) warn "$1" "$(warn_owner "$1")" "$3" ;;
        INFO) info "$1" "$3" ;;
        *)    result "$1" "$2" "$3" ;;
    esac
    return 0
}

# emit_rows <ID> <rowfile> -- emit every row in <rowfile> whose ID field is <ID>.
# Lets a single parse pass buffer rows and still print them in stable ID order.
emit_rows() {
    LC_ALL=C grep "^$1|" "$2" > "$2.sel" 2>/dev/null
    while IFS='|' read -r _ri _rs _rm; do
        [ -n "$_ri" ] || continue
        emit_row "$_ri" "$_rs" "$_rm"
    done < "$2.sel"
    return 0
}

# frozen_section <[section]> -> the non-blank value lines of one honesty-freeze
# section. Comment lines and every other section are dropped, so a caller can
# never accidentally match the [geometry-sha256] value against the text layer.
frozen_section() {
    awk -v want="$1" '
        /^[[:space:]]*#/ { next }
        /^\[/            { inside = ($0 == want) ? 1 : 0; next }
        inside && NF     { print }
    ' "$FROZEN"
    return 0
}

# ---------------------------------------------------------------------------
# Scratch workspace. V12 control: always from mktemp -d, never from user input,
# and removed only after proving the variable is non-empty and is a directory.
# Nothing is ever written under docs/.
# ---------------------------------------------------------------------------

if [ -n "${VERIFY_TMPDIR:-}" ]; then
    WORK=$(mktemp -d "${VERIFY_TMPDIR%/}/verify-resume.XXXXXX") || die2 "cannot create scratch dir under $VERIFY_TMPDIR"
else
    WORK=$(mktemp -d) || die2 "cannot create scratch dir"
fi

cleanup() {
    if [ -n "${WORK:-}" ] && [ -d "${WORK:-}" ]; then
        rm -rf "$WORK"
    fi
    return 0
}
trap cleanup EXIT

# ---------------------------------------------------------------------------
# G0.1 -- required tools. Exit 2, not 1: "cannot verify" is semantically
# distinct from "the document is wrong".
# ---------------------------------------------------------------------------

MISSING=""
for t in pdfinfo pdftotext python3; do
    command -v "$t" >/dev/null 2>&1 || MISSING="$MISSING $t"
done

if [ -n "$MISSING" ]; then
    result G0.1 FAIL "required tool(s) not on PATH:$MISSING"
    die2 "missing tool(s):$MISSING -- install the poppler binaries with 'brew install poppler'"
fi
result G0.1 PASS "pdfinfo, pdftotext and python3 present"

# ---------------------------------------------------------------------------
# Census mode short-circuits HERE, immediately after G0.1 and before G0.2
# resolves or stats the PDF and TEX. Census reads a text fixture, not the
# document, so G0.2/G0.3/G0.4 do not apply to it. This ordering is part of the
# pinned contract; Plan 03's negative control depends on it.
# ---------------------------------------------------------------------------

if [ "$MODE" = census ]; then
    if [ ! -f "$CENSUS_FILE" ] || [ ! -r "$CENSUS_FILE" ]; then
        die2 "census fixture not found or not readable: $CENSUS_FILE"
    fi
    result G6.1 SKIP "glyph-class census over '$CENSUS_FILE' is implemented in Plan 03 (G6.1-G6.4)"
    printf '>> Census mode: argument surface only in this plan; gate lands in Plan 03.\n'
    exit 0
fi

# ---------------------------------------------------------------------------
# G0.2 -- artifacts exist and are non-empty
# ---------------------------------------------------------------------------

if [ ! -f "$PDF" ] || [ ! -s "$PDF" ]; then
    result G0.2 FAIL "PDF missing or empty: $PDF"
    die2 "PDF missing or empty: $PDF -> run 'make build'"
fi
if [ ! -f "$TEX" ] || [ ! -s "$TEX" ]; then
    result G0.2 FAIL "LaTeX source missing or empty: $TEX"
    die2 "LaTeX source missing or empty: $TEX"
fi
if [ ! -f "$MANIFEST" ] || [ ! -s "$MANIFEST" ]; then
    result G0.2 FAIL "manifest missing or empty: $MANIFEST"
    die2 "manifest missing or empty: $MANIFEST"
fi
if [ ! -f "$FROZEN" ] || [ ! -s "$FROZEN" ]; then
    result G0.2 FAIL "honesty freeze missing or empty: $FROZEN"
    die2 "honesty freeze missing or empty: $FROZEN"
fi
result G0.2 PASS "artifacts present and non-empty: $PDF, $TEX, $MANIFEST, $FROZEN"

# ---------------------------------------------------------------------------
# Extraction, done once. Every content assertion in Plans 02 and 03 reads
# gate.txt; nothing reads raw.txt except the INFO-only -raw divergence report.
#
# The form-feed translation is load-bearing, not cosmetic. Measured: in the
# default whole-document extraction the page-1 form feed is glued to the first
# token of page 2, so the extracted line is a form feed immediately followed by
# PUBLICATIONS. A whole-line search for PUBLICATIONS against raw.txt therefore
# returns 0 and would fire a spurious BLOCKER on day one, tempting an
# implementer to weaken grep -Fx to grep -F -- which silently destroys the
# honesty freeze's substring-collision protection. After translation it returns
# 1, and all 15 frozen strings still return 1. Do not remove this step.
# ---------------------------------------------------------------------------

pdftotext "$PDF" "$WORK/raw.txt" 2>/dev/null || die2 "pdftotext failed to extract a text layer from $PDF"
tr '\f' '\n' < "$WORK/raw.txt" > "$WORK/gate.txt" || die2 "form-feed normalization failed"

# ---------------------------------------------------------------------------
# G0.3 -- freshness proof: was the PDF provably built from the current source?
#
# L1 (primary): compare the source's MD5 against the MD5 latexmk recorded for it.
# The digest MUST be MD5 to be comparable with latexmk's own record, so shasum is
# not a substitute. `md5 -q` is BSD/macOS and `md5sum` is GNU/Linux, hence the
# explicit fallback rather than an implicit tool choice.
#
# The record is located by anchoring on the dependency line whose FIRST field is
# the quoted filename -- pinned form: awk '$1=="\"main.tex\""{print $4; exit}'.
# Matching the token anywhere on the line is WRONG: the .fdb_latexmk carries
# "main.tex" on two lines, and the earlier one is the rule line
#   ["pdflatex"] <ts> "main.tex" "AshutoshTiwari.pdf" "AshutoshTiwari" <ts> 0
# whose fourth field is the OUTPUT FILENAME, not a digest. A first-match-anywhere
# awk therefore compares "AshutoshTiwari.pdf" against a real MD5 and makes G0.3
# FAIL against pristine artifacts. The $1== test skips the rule line for free
# because its first field is the bracketed rule name. The dependency record is
# indented, so this relies on awk's default field splitting collapsing leading
# whitespace -- do not set FS to a single space.
# ---------------------------------------------------------------------------

tex_md5() {
    md5 -q "$1" 2>/dev/null || md5sum "$1" 2>/dev/null | awk '{print $1}'
    return 0
}

# L2 arbiter -- escalation only, never the default path. Rebuilds the current
# source in the scratch dir under a different jobname (so the committed artifact
# is unreachable by both directory and jobname) and compares the two documents
# through pdftotext -bbox with the only two nondeterministic lines filtered out.
# PDF bytes always differ between builds of identical source (embedded
# CreationDate and /ID), so comparing the files themselves is not a freshness
# test. Prints FRESH, STALE, or SKIP when latexmk is unavailable.
l2_arbiter() {
    if ! command -v latexmk >/dev/null 2>&1; then
        printf 'SKIP\n'
        return 0
    fi
    cp "$TEX" "$WORK/arb.tex" 2>/dev/null || { printf 'SKIP\n'; return 0; }
    ( cd "$WORK" && latexmk -pdf -interaction=nonstopmode -halt-on-error -jobname=fresh arb.tex >/dev/null 2>&1 )
    if [ ! -s "$WORK/fresh.pdf" ]; then
        printf 'SKIP\n'
        return 0
    fi
    pdftotext -bbox "$WORK/fresh.pdf" "$WORK/a.xml" 2>/dev/null
    pdftotext -bbox "$PDF" "$WORK/b.xml" 2>/dev/null
    sed -e 's/fresh\.pdf/X/' -e 's/arb\.pdf/X/' -e "s@$(basename "$PDF" | sed 's/[.[\*^$]/\\&/g')@X@" "$WORK/a.xml" \
        | grep -v 'name="\(Creation\|Mod\)Date"' > "$WORK/a.n"
    sed -e 's/fresh\.pdf/X/' -e 's/arb\.pdf/X/' -e "s@$(basename "$PDF" | sed 's/[.[\*^$]/\\&/g')@X@" "$WORK/b.xml" \
        | grep -v 'name="\(Creation\|Mod\)Date"' > "$WORK/b.n"
    if cmp -s "$WORK/a.n" "$WORK/b.n"; then
        printf 'FRESH\n'
    else
        printf 'STALE\n'
    fi
    return 0
}

if [ "$SKIP_FRESHNESS" -eq 1 ]; then
    # The single documented override. G0.3 runs before every content assertion,
    # so without this flag any run whose --tex differs from the recorded digest
    # exits 2 before a content assertion can report -- correct for a real
    # verification, wrong for a negative control that must mutate the source to
    # prove a content gate fires. No build target may pass this flag, and it must
    # NOT be widened into "auto-skip whenever --tex is overridden": a separate
    # control depends on an overridden --tex still being refused.
    result G0.3 SKIP "freshness proof waived by explicit request (--skip-freshness); this run's content results do NOT certify the committed artifact"
else
    FDB="${PDF%.pdf}.fdb_latexmk"
    TEX_BASE=$(basename "$TEX")
    SRC_MD5=$(tex_md5 "$TEX")
    FDB_MD5=""
    if [ -f "$FDB" ]; then
        FDB_MD5=$(awk -v f="\"$TEX_BASE\"" '$1==f {print $4; exit}' "$FDB" 2>/dev/null)
    fi

    if [ -z "$SRC_MD5" ]; then
        result G0.3 FAIL "no MD5 tool available (need 'md5 -q' or 'md5sum') so freshness cannot be proven"
        die2 "cannot compute an MD5 of $TEX -- install coreutils or run on a host providing md5"
    elif [ -z "$FDB_MD5" ]; then
        # Absent record means the aux files were cleaned. Freshness is UNKNOWN,
        # never assumed fresh, so escalate to the rebuild arbiter.
        ARB=$(l2_arbiter)
        case "$ARB" in
            FRESH)
                result G0.3 PASS "no latexmk record for $TEX_BASE; L2 scratch rebuild proves the PDF matches the current source"
                ;;
            STALE)
                result G0.3 FAIL "no latexmk record for $TEX_BASE and the L2 scratch rebuild DIVERGES from $PDF -> run 'make build'"
                die2 "PDF does not match the current source (L2 arbiter) -> run 'make build'"
                ;;
            *)
                result G0.3 SKIP "no latexmk record for $TEX_BASE and latexmk is unavailable, so freshness degrades to L1-only and could not be proven"
                ;;
        esac
    elif [ "$SRC_MD5" != "$FDB_MD5" ]; then
        # The RESULT line comes FIRST and is not optional: die2 emits only the
        # !! banner, which is not machine-readable, and a downstream control
        # greps for this exact RESULT G0.3 FAIL line. die2 then overrides the
        # BLOCKERS-derived exit code with 2 on purpose, because "cannot verify"
        # outranks "the document is wrong".
        result G0.3 FAIL "PDF is stale: built from md5 $FDB_MD5, but $TEX is now md5 $SRC_MD5 -> run 'make build'"
        die2 "refusing to verify a stale artifact: $PDF was built from md5 $FDB_MD5, $TEX is now md5 $SRC_MD5 -> run 'make build'"
    else
        result G0.3 PASS "PDF provably built from current $TEX_BASE (latexmk md5 $SRC_MD5)"
    fi
fi

# ---------------------------------------------------------------------------
# G0.4 -- mtime relationship, reported and never gated. Measured: a fresh
# checkout stamps every file at checkout time, so both artifacts can carry an
# identical mtime and a newer-than test is indeterminate on a provably fresh
# artifact. This is INFO by construction.
# ---------------------------------------------------------------------------

mtime_of() {
    stat -f %m "$1" 2>/dev/null || stat -c %Y "$1" 2>/dev/null
    return 0
}

PDF_MT=$(mtime_of "$PDF")
TEX_MT=$(mtime_of "$TEX")
if [ -z "$PDF_MT" ] || [ -z "$TEX_MT" ]; then
    info G0.4 "mtime unavailable on this host; freshness rests on G0.3 (never on mtime)"
elif [ "$PDF_MT" = "$TEX_MT" ]; then
    info G0.4 "mtimes identical (pdf=$PDF_MT tex=$TEX_MT) -- newer-than is indeterminate, as expected after a checkout; not gated"
elif [ "$PDF_MT" -gt "$TEX_MT" ]; then
    info G0.4 "PDF mtime newer than source (pdf=$PDF_MT tex=$TEX_MT); not gated"
else
    info G0.4 "PDF mtime older than source (pdf=$PDF_MT tex=$TEX_MT) -- suggestive only, G0.3 is authoritative; not gated"
fi

# ---------------------------------------------------------------------------
# Deferred modes. The argument surface is stable now so later plans can fill in
# behaviour without restructuring the entry path. These short-circuit BEFORE the
# content assertions so a --selftest or --write-baseline run never pays for the
# extra extractions.
# ---------------------------------------------------------------------------

if [ "$MODE" = selftest ]; then
    result G7.1 SKIP "probe-build self-test is implemented in Plan 03 (G7.1-G7.4)"
    printf '>> Self-test argument surface only in this plan; probe build lands in Plan 03.\n'
    exit 0
fi

if [ "$MODE" = write-baseline ]; then
    result G7.5 SKIP "manifest regeneration (and the ALLOW_FROZEN_UPDATE guard on the honesty freeze) is implemented in Plan 03"
    printf '>> Baseline writer argument surface only in this plan; writer lands in Plan 03.\n'
    exit 0
fi

# ===========================================================================
# CONTENT ASSERTIONS
#
# Everything below runs only after G0 proved the artifacts exist and (unless
# explicitly waived) that the PDF was built from the current source. The extra
# extractions live here rather than next to the whole-document one so a
# --selftest or --write-baseline run never pays for them.
# ===========================================================================

pdftotext -f 1 -l 1 "$PDF" "$WORK/p1.txt" 2>/dev/null
pdftotext -f 2 -l 2 "$PDF" "$WORK/p2.txt" 2>/dev/null
pdftotext -bbox "$PDF" "$WORK/bbox.xml" 2>/dev/null || die2 "pdftotext -bbox failed to measure $PDF"

# A 1-page artifact makes the page-2 extraction empty rather than fatal: G2.1
# must be able to report a moved boundary as a FAIL, not be pre-empted by an
# exit 2 that would read as "cannot verify".
[ -f "$WORK/p1.txt" ] || : > "$WORK/p1.txt"
[ -f "$WORK/p2.txt" ] || : > "$WORK/p2.txt"
tr '\f' '\n' < "$WORK/p1.txt" > "$WORK/p1gate.txt" || die2 "page-1 form-feed normalization failed"
tr '\f' '\n' < "$WORK/p2.txt" > "$WORK/p2gate.txt" || die2 "page-2 form-feed normalization failed"

# ---------------------------------------------------------------------------
# G1 -- page count. This is the PRIMARY fit gate and it reads the PDF page tree.
#
# Do not substitute a fill or headroom measurement for it, and do not read the
# LaTeX log. Measured four times against this document: a build whose content
# spills onto a third page still exits 0 and emits no warning at all -- TeX has
# no page-spill diagnostic, and \raggedbottom (main.tex:46) suppresses the
# vertical-underfill complaint that would otherwise hint at it. The page count is
# the only reliable signal, which is also why G4.5 reports \raggedbottom.
#
# The threshold comes from the manifest (PAGES), never a literal. Note that
# docs/transcript.pdf is NOT a usable negative control for this gate: measured
# with pdfinfo it is itself 2 pages, so the gate PASSES on it. The real
# discrimination proof is Plan 03's G7.3 overflow probe, which builds a genuine
# 3-page artifact in a scratch directory.
# ---------------------------------------------------------------------------

PAGES_WANT=$(manifest_get PAGES)
PAGES_GOT=$(pdfinfo "$PDF" 2>/dev/null | awk '/^Pages:/ {print $2; exit}')

if [ -z "$PAGES_GOT" ]; then
    result G1.1 FAIL "could not read a page count from the page tree of $PDF"
elif [ "$PAGES_GOT" = "$PAGES_WANT" ]; then
    result G1.1 PASS "page tree reports $PAGES_GOT page(s), manifest PAGES=$PAGES_WANT"
else
    result G1.1 FAIL "page tree reports $PAGES_GOT page(s) but manifest PAGES=$PAGES_WANT -- content no longer fits the page budget; cut content or raise PAGES in $MANIFEST"
fi

# pdftotext emits one form feed per page INCLUDING the last, so the raw count
# equals the page count -- do not add one. Cross-check only, never a gate.
FF_COUNT=$(tr -cd '\f' < "$WORK/raw.txt" | wc -c | tr -d ' ')
if [ "$FF_COUNT" = "$PAGES_GOT" ]; then
    info G1.2 "form-feed cross-check agrees with the page tree ($FF_COUNT == $PAGES_GOT)"
else
    info G1.2 "form-feed count $FF_COUNT diverges from the page tree $PAGES_GOT -- reported only, G1.1 is authoritative"
fi

# ---------------------------------------------------------------------------
# G2 -- page-1 boundary. G2.1 is a POSITIVE assertion, which is the whole point.
# \scshape round-trips to real uppercase, so the match is anchored and
# case-insensitive. Per-page extraction reads clean, so this does not need the
# form-feed-normalized whole-document text.
# ---------------------------------------------------------------------------

PAGE2_OPENS=$(manifest_get PAGE2_OPENS_WITH)
P2_FIRST=$(grep -m1 . "$WORK/p2gate.txt" 2>/dev/null)

if [ -z "$P2_FIRST" ]; then
    result G2.1 FAIL "page 2 has no extractable text, so the page-1 boundary cannot be confirmed to open at '$PAGE2_OPENS'"
elif printf '%s\n' "$P2_FIRST" | LC_ALL=C grep -Fxqi -- "$PAGE2_OPENS"; then
    result G2.1 PASS "page 2 opens at '$P2_FIRST' as required by manifest PAGE2_OPENS_WITH=$PAGE2_OPENS"
else
    result G2.1 FAIL "page 2 opens at '$P2_FIRST', expected '$PAGE2_OPENS' -- the page-1 boundary moved; content spilled past the \\newpage"
fi

EXP_HEADING=$(manifest_get EXPERIENCE_HEADING)
N=$(LC_ALL=C grep -Fxc "$EXP_HEADING" "$WORK/p1gate.txt")
if [ "$N" != 0 ]; then
    result G2.2 PASS "page 1 carries the experience heading '$EXP_HEADING'"
else
    result G2.2 FAIL "page 1 does not carry the experience heading '$EXP_HEADING' as a whole extracted line"
fi

LAST_EMPLOYER=$(manifest_get LAST_EXPERIENCE_EMPLOYER)
N=$(LC_ALL=C grep -Fxc "$LAST_EMPLOYER" "$WORK/p1gate.txt")
if [ "$N" != 0 ]; then
    result G2.3 PASS "page 1 carries the last experience employer '$LAST_EMPLOYER'"
else
    result G2.3 FAIL "page 1 does not carry the last experience employer '$LAST_EMPLOYER' -- the experience section no longer fits page 1"
fi

# G2.4 is INFO and must NEVER become a gate. Testing for the ABSENCE of company
# names on page 2 returns a false OK, reproduced independently: a +4-line probe
# produced a 3-page document whose page 2 began with a role TITLE rather than an
# employer; a +5-line probe's page 2 opened with the sentence fragment "Groupon
# operates."; a third recorded probe opened with "Breakdown.", matching no
# company name at all. The spill fragment is a function of the injection point
# and cannot be enumerated, so a negative test passes on a broken document.
# G2.1's positive assertion discriminated correctly on every probe state
# measured. Do not "strengthen" this into a gate.
frozen_section '[employers]' > "$WORK/employers.txt"
P2_EMP=0
while IFS= read -r EMP; do
    [ -n "$EMP" ] || continue
    C=$(LC_ALL=C grep -Fc "$EMP" "$WORK/p2gate.txt")
    P2_EMP=$((P2_EMP + C))
done < "$WORK/employers.txt"
info G2.4 "experience employer names appearing on page 2: $P2_EMP (reported only -- absence is a false OK as a gate; G2.1 is the real boundary assertion)"

# ---------------------------------------------------------------------------
# G3 -- fill and headroom, from pdftotext -bbox parsed with stdlib xml.etree.
#
# G3.1 alone can NEVER replace G1.1: measured on the 3-page artifact, page-1
# headroom reads POSITIVE, because once content spills page 1 is no longer the
# binding page. G3.1 is the "did anything cross the text-block ceiling" gate;
# G1.1 is the "did the document still fit" gate. Both are required.
#
# Manifest-derived values are passed as argv, never interpolated into the
# heredoc body, so a manifest value can never become python source.
# ---------------------------------------------------------------------------

CEILING_PT=$(manifest_get CEILING_PT)
LINE_PT=$(manifest_get LINE_PT)
P1_WS_PT=$(manifest_get P1_BOTTOM_WS_PT)

python3 - "$WORK/bbox.xml" "$CEILING_PT" "$LINE_PT" "$P1_WS_PT" <<'PY' > "$WORK/bbox.rows"
import sys
import xml.etree.ElementTree as ET


def localname(elem):
    # pdftotext -bbox emits a namespaced document; strip the namespace before
    # comparing tag names so the parse does not depend on poppler's URI.
    return elem.tag.split('}')[-1]


xml_path, ceil_s, line_s, ws_s = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
CEIL, LINE, WSBASE = float(ceil_s), float(line_s), float(ws_s)

root = ET.parse(xml_path).getroot()
pages = []
for page in [p for p in root.iter() if localname(p) == 'page']:
    width, height = float(page.get('width')), float(page.get('height'))
    words = [w for w in page.iter() if localname(w) == 'word']
    if not words:
        continue
    pages.append({
        'w': width,
        'h': height,
        'top': min(float(w.get('yMin')) for w in words),
        'bottom': max(float(w.get('yMax')) for w in words),
        'outside': sum(1 for w in words
                       if float(w.get('xMin')) < 0 or float(w.get('yMin')) < 0
                       or float(w.get('xMax')) > width or float(w.get('yMax')) > height),
        'n': len(words),
    })

rows = []
if not pages:
    rows.append(('G3.1', 'FAIL', 'no positioned words in the bbox extraction; page fill cannot be measured'))
    rows.append(('G3.4', 'FAIL', 'no positioned words in the bbox extraction; the page box cannot be checked'))
else:
    deepest = max(p['bottom'] for p in pages)
    per_page = ', '.join('p%d %.1fpt' % (i + 1, p['bottom']) for i, p in enumerate(pages))
    rows.append(('G3.1', 'FAIL' if deepest > CEIL else 'PASS',
                 'deepest content bottom %.1fpt vs ceiling %.1fpt (%s)' % (deepest, CEIL, per_page)))

    headroom = ', '.join(
        'p%d %+.1fpt (%+.2f lines)' % (i + 1, CEIL - p['bottom'], (CEIL - p['bottom']) / LINE)
        for i, p in enumerate(pages))
    rows.append(('G3.2', 'INFO', 'headroom at %.1fpt/line: %s' % (LINE, headroom)))

    first = pages[0]
    rows.append(('G3.3', 'INFO',
                 'page-1 bottom whitespace %.1fpt vs baseline %.1fpt -- the same measurement as G3.1 '
                 'read from the physical page edge, kept for traceability only'
                 % (first['h'] - first['bottom'], WSBASE)))

    outside = sum(p['outside'] for p in pages)
    total = sum(p['n'] for p in pages)
    rows.append(('G3.4', 'FAIL' if outside else 'PASS',
                 '%d words outside the page box, of %d positioned words across %d page(s)'
                 % (outside, total, len(pages))))

    rows.append(('META', 'p1top', '%.1f' % first['top']))

for row in rows:
    print('%s|%s|%s' % row)
PY

# Read the rows from a FILE, not a pipe: result() must run in this shell or the
# BLOCKERS tally silently stays at zero.
P1_TOP_MEASURED=""
while IFS='|' read -r ROW_ID ROW_STATUS ROW_MSG; do
    [ -n "$ROW_ID" ] || continue
    if [ "$ROW_ID" = META ]; then
        case "$ROW_STATUS" in
            p1top) P1_TOP_MEASURED="$ROW_MSG" ;;
        esac
        continue
    fi
    emit_row "$ROW_ID" "$ROW_STATUS" "$ROW_MSG"
done < "$WORK/bbox.rows"

# ---------------------------------------------------------------------------
# G4 -- geometry and spacing freeze. G4.1 is the HARD MARGIN GATE.
#
# The observation point is the LaTeX source, not the PDF: pdfinfo reports only
# paper size and cannot see \textheight, so a margin change is invisible from
# the artifact. Line numbers are not usable either -- they shift in every later
# phase -- so the declarations are pattern-extracted, whitespace-normalized,
# sorted and hashed, which makes the hash line-number independent.
#
# Observing drift end-to-end needs --skip-freshness alongside --tex: a mutated
# copy no longer matches the .fdb_latexmk record, so G0.3 refuses at exit 2
# before G4 runs. That flag is the SINGLE documented override; do not add a
# second bypass and do not reorder G0.3 behind G4.
# ---------------------------------------------------------------------------

# geom_hash <texfile> -> normalized sha256 over two sorted streams. shasum is
# preferred over a BSD-only hash tool so the check also works on Linux.
geom_hash() {
    _gk=$(manifest_get GEOMETRY_KEYS)
    # Matched inside the braces so trailing content on the line cannot leak in.
    _gre='\\addtolength\{\\('"$_gk"')\}\{[^}]*\}'
    {
        LC_ALL=C grep -hoE "$_gre" "$1" | sort
        python3 - "$1" <<'PY'
import re
import sys

source = open(sys.argv[1], encoding='utf-8').read()
# Brace-balanced on purpose: the \setlist[itemize] declaration spans two source
# lines, and a per-line grep would capture only half of it -- silently dropping
# half the list-spacing contract out of the hash.
pattern = r"\\setlist(\[[^\]]*\])?\{(?:[^{}]|\{[^{}]*\})*\}"
print("\n".join(sorted(" ".join(m.group(0).split()) for m in re.finditer(pattern, source))))
PY
    } | shasum -a 256 | awk '{print $1}'
    return 0
}

GEOM_WANT=$(frozen_section '[geometry-sha256]' | grep -m1 .)
GEOM_GOT=$(geom_hash "$TEX")

if [ -z "$GEOM_WANT" ]; then
    result G4.1 FAIL "no [geometry-sha256] value in $FROZEN, so margin and list-spacing drift cannot be detected"
elif [ "$GEOM_GOT" = "$GEOM_WANT" ]; then
    result G4.1 PASS "geometry and setlist declarations hash to the frozen value $GEOM_GOT"
else
    result G4.1 FAIL "geometry drift: $TEX now hashes to $GEOM_GOT but $FROZEN freezes $GEOM_WANT -- a margin or list-spacing declaration changed; revert it, or make a reviewed edit to the frozen file"
fi

# Paper size only. A margin change leaves this untouched, which is exactly why
# G4.1 above carries the real gate.
PAGE_SIZE_WANT=$(manifest_get PAGE_SIZE)
PAGE_SIZE_GOT=$(pdfinfo "$PDF" 2>/dev/null | sed -n 's/^Page size:[[:space:]]*//p' | head -1 | sed 's/[[:space:]]*$//')
if [ "$PAGE_SIZE_GOT" = "$PAGE_SIZE_WANT" ]; then
    result G4.2 PASS "page size is $PAGE_SIZE_GOT as required by manifest PAGE_SIZE"
else
    result G4.2 FAIL "page size is '$PAGE_SIZE_GOT' but manifest PAGE_SIZE='$PAGE_SIZE_WANT' -- the paper size changed"
fi

# Corroborating only, hence the 'none' owner sentinel read from WARN_OWNERS.
P1_TOP_WANT=$(manifest_get P1_TOP_PT)
if [ -z "$P1_TOP_MEASURED" ]; then
    warn G4.3 "$(warn_owner G4.3)" "page-1 top content extent unavailable from the bbox parse, so \\topmargin could not be corroborated"
else
    TOP_DELTA=$(awk -v a="$P1_TOP_MEASURED" -v b="$P1_TOP_WANT" 'BEGIN { d = a - b; if (d < 0) d = -d; printf "%.2f", d }')
    TOP_VERDICT=$(awk -v d="$TOP_DELTA" 'BEGIN { print (d <= 1.0) ? "within" : "outside" }')
    warn G4.3 "$(warn_owner G4.3)" "page-1 top content extent ${P1_TOP_MEASURED}pt is $TOP_VERDICT 1.0pt of manifest P1_TOP_PT=${P1_TOP_WANT}pt (delta ${TOP_DELTA}pt) -- corroborates \\topmargin; G4.1 carries the real margin gate"
fi

# The ATS switch. Its removal would make the extracted text layer unreliable and
# would invalidate every G5 and G6 assertion, so this is a BLOCKER.
ATS_MISSING=""
LC_ALL=C grep -Fq '\input{glyphtounicode}' "$TEX" || ATS_MISSING="$ATS_MISSING \\input{glyphtounicode}"
LC_ALL=C grep -Fq '\pdfgentounicode=1' "$TEX" || ATS_MISSING="$ATS_MISSING \\pdfgentounicode=1"
if [ -z "$ATS_MISSING" ]; then
    result G4.4 PASS "ATS text-layer switch intact in $TEX: \\input{glyphtounicode} and \\pdfgentounicode=1"
else
    result G4.4 FAIL "ATS text-layer switch broken in $TEX -- missing:$ATS_MISSING; restore it, or every G5/G6 text-layer assertion is void"
fi

# Reported because its presence is the reason G1.1 has to exist at all.
if LC_ALL=C grep -Fq '\raggedbottom' "$TEX"; then
    info G4.5 "$TEX declares \\raggedbottom -- vertical slack is absorbed silently, which is why the page count (G1.1) is the primary fit gate"
else
    info G4.5 "$TEX no longer declares \\raggedbottom -- vertical-fit diagnostics may behave differently; G1.1 remains authoritative"
fi

# ---------------------------------------------------------------------------
# G5 -- honesty freeze. Three matcher properties are load-bearing, each measured:
#
#   -x  (whole line) resolves a real substring collision: "Software Development
#       Engineer" (Groupon) is a substring of "Software Development Engineer
#       (Search Relevance)" (Flipkart), so a substring count returns 2 for the
#       bare form and would report PASS even if Groupon's title were deleted.
#       Whole-line counts return exactly 1 for both.
#   -F  (fixed string) keeps the parentheses and ampersands inside titles from
#       being read as regex.
#   LC_ALL=C gives byte semantics, so the UTF-8 EN DASH inside the frozen date
#       strings matches byte-exactly.
#
# The input is gate.txt, never raw.txt. The comparison is exact-count (== 1),
# never an at-least-one test -- an at-least-one test cannot detect a duplicate.
# The [geometry-sha256] value is deliberately skipped: it belongs to G4.1, and
# grepping a sha256 against the text layer would report a spurious FAIL.
# ---------------------------------------------------------------------------

: > "$WORK/frozen.rows"
FROZEN_SECT=""
while IFS= read -r FLINE; do
    case "$FLINE" in
        '')   continue ;;
        '#'*) continue ;;
        '['*) FROZEN_SECT="$FLINE"; continue ;;
    esac
    case "$FROZEN_SECT" in
        '[dates]')     FID=G5.1 ;;
        '[titles]')    FID=G5.2 ;;
        '[employers]') FID=G5.5 ;;
        *)             continue ;;
    esac
    N=$(LC_ALL=C grep -Fxc "$FLINE" "$WORK/gate.txt")
    if [ "$N" = 1 ]; then
        printf '%s|PASS|frozen string appears exactly once as a whole extracted line: %s\n' \
            "$FID" "$FLINE" >> "$WORK/frozen.rows"
    else
        printf '%s|FAIL|frozen string count=%s (want exactly 1): %s -- an employment date, printed title or employer changed; revert the document, or make a reviewed edit to %s\n' \
            "$FID" "$N" "$FLINE" "$FROZEN" >> "$WORK/frozen.rows"
    fi
done < "$FROZEN"

emit_rows G5.1 "$WORK/frozen.rows"
emit_rows G5.2 "$WORK/frozen.rows"

STAFF_N=$(LC_ALL=C grep -Fc 'Staff' "$WORK/gate.txt")
HEDGE_N=$(LC_ALL=C grep -cE '(/(Staff|Senior|Principal|Lead))|((Staff|Senior|Principal|Lead)/)' "$WORK/gate.txt")
if [ "$STAFF_N" = 0 ] && [ "$HEDGE_N" = 0 ]; then
    result G5.3 PASS "no title inflation in the text layer: 'Staff' x0, slash-hedged seniority lines x0"
else
    result G5.3 FAIL "title inflation in the text layer: 'Staff' x$STAFF_N, slash-hedged seniority lines x$HEDGE_N -- the printed title must stay truthful"
fi

# Crude on purpose and therefore WARN, not a gate: a rewording that moves a
# number onto a wrapped continuation line trips it spuriously. It exists to make
# compression that silently eats quantified claims visible.
BULLET_FLOOR=$(manifest_get DIGIT_BULLET_FLOOR)
BULLET_N=$(LC_ALL=C grep -cE '^[[:space:]]*(•|▪|◦|·|–|—|\*|-).*[0-9]' "$WORK/p1gate.txt")
if [ "$BULLET_N" -lt "$BULLET_FLOOR" ]; then
    warn G5.4 "$(warn_owner G5.4)" "page-1 digit-bearing bullet lines: $BULLET_N, BELOW manifest DIGIT_BULLET_FLOOR=$BULLET_FLOOR -- compression may have removed quantified claims"
else
    warn G5.4 "$(warn_owner G5.4)" "page-1 digit-bearing bullet lines: $BULLET_N against manifest DIGIT_BULLET_FLOOR=$BULLET_FLOOR -- crude metric, kept non-gating"
fi

emit_rows G5.5 "$WORK/frozen.rows"

# ---------------------------------------------------------------------------
# Human summary. Machine-readable RESULT lines come first; this block uses the
# repo's >> progress and !! error prefixes.
# ---------------------------------------------------------------------------

printf '>> Manifest: %s (pages=%s, page 2 opens with %s, %s sections)\n' \
    "$MANIFEST" "$(manifest_get PAGES)" "$(manifest_get PAGE2_OPENS_WITH)" \
    "$(manifest_list SECTIONS | grep -c .)"
printf '>> Honesty freeze: %s\n' "$FROZEN"
printf '>> G0 preconditions complete. Content assertions G1-G6 land in Plan 02; G7-G8 in Plan 03.\n'

if [ "$BLOCKERS" -eq 0 ]; then
    printf '>> PASS: 0 blocking failures.\n'
    exit 0
fi

printf '!! FAIL: %s blocking failure(s). The document is wrong; see the RESULT lines above.\n' "$BLOCKERS"
exit 1
