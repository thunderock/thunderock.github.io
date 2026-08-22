#!/usr/bin/env bash
# verify-resume.sh -- read-only verification harness for the resume PDF.
#
# Machine-first output contract, one line per assertion, stable order:
#   RESULT <id> <PASS|FAIL|WARN|INFO|SKIP> <human message>
#
# Exit vocabulary (load-bearing -- Plan 03 asserts on it):
#   0 = every BLOCKER passed
#   1 = at least one BLOCKER failed (the document is wrong)
#   2 = the harness could not run (missing tool, missing artifact, stale PDF, or a
#       measurement block that failed -- see die_group: an assertion group that could
#       not RUN is UNKNOWN, and UNKNOWN is never reported as a pass)
# Note: GNU Make 3.81 exits 2 for ANY failed recipe, so the 1-vs-2 distinction is
# observable only when this script is invoked directly, not through a Make target.
#
# Implemented here: G0.1-G0.4 (preconditions), G1-G3 (structural page gates),
# G4-G5 (geometry and honesty freezes), G6 (ATS text-layer integrity).
# G7 (probe self-test) and G8 (harness controls) land in Plan 03.
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
FAILED_IDS=""
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
        # Each failing ID is recorded once so the closing summary can name the
        # failing assertions without the reader parsing the whole RESULT stream.
        case " $FAILED_IDS " in
            *" $1 "*) : ;;
            *)        FAILED_IDS="$FAILED_IDS $1" ;;
        esac
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

# die_group <first-id> <group label> <exit status> <stderr file> -- an assertion
# GROUP that could not RUN, which is the harness's one false-PASS channel and the
# reason every inlined measurement block below is exit-status checked.
#
# Measured: a crashed python block emits NO rows, so every ID in its group
# silently disappears from the RESULT stream while BLOCKERS stays untouched -- a
# malformed NONASCII_ALLOW deletes G6.1-G6.4, an empty CEILING_PT deletes
# G3.1-G3.4, and on a document with no other defect the run then exits 0. A run
# that reports success because an assertion never executed is worse than no
# assertion at all.
#
# So a failed measurement block is INFRASTRUCTURE failure -- "cannot verify",
# exit 2 -- never "the document is wrong" (exit 1) and never silence. Same
# ordering rule as G0.3: the machine-readable RESULT line is emitted FIRST,
# because die2's banner is only a human banner. The block's own stderr is echoed
# verbatim so the python traceback survives into the operator's terminal.
die_group() {
    _dg_err=$(LC_ALL=C grep -v '^[[:space:]]*$' "$4" 2>/dev/null \
        | tail -3 | tr '\n' ' ' | sed -e 's/  */ /g' -e 's/^ *//' -e 's/ *$//')
    [ -n "$_dg_err" ] || _dg_err="no diagnostic on stderr"
    result "$1" FAIL "the $2 assertion group could NOT RUN: its measurement block exited $3 -- $_dg_err. The group's verdict is UNKNOWN, which is never a pass"
    if [ -s "$4" ]; then
        sed 's/^/!!   /' "$4" >&2
    fi
    die2 "$2 could not be measured (measurement block exit $3): $_dg_err -- refusing to report a verdict for an assertion group that never ran"
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
#
# Zero matching rows is a FAILURE, not an empty loop: every call site expects at
# least one row for the ID it asks for, so an empty selection means the producing
# block emitted nothing for it. This closes the same channel die_group closes,
# from the other side -- die_group catches a block that exited non-zero, this
# catches a block that exited 0 without producing the row it owes.
emit_rows() {
    LC_ALL=C grep "^$1|" "$2" > "$2.sel" 2>/dev/null
    if [ ! -s "$2.sel" ]; then
        result "$1" FAIL "no $1 row was produced by its measurement block (row file $2) -- the assertion did not run, so its verdict is UNKNOWN, which is never a pass"
        die2 "$1 produced no result row -- refusing to report a verdict for an assertion that never ran"
    fi
    while IFS='|' read -r _ri _rs _rm; do
        [ -n "$_ri" ] || continue
        emit_row "$_ri" "$_rs" "$_rm"
    done < "$2.sel"
    return 0
}

# glyph_census <textfile> -> "ID|STATUS|MESSAGE" rows for the four-class glyph
# gate. All four rules live in THIS one block, so there is exactly one
# implementation of each:
#   RESULT G6.1  ligature codepoints U+FB00-U+FB06
#   RESULT G6.2  private-use codepoints U+E000-U+F8FF
#   RESULT G6.3  U+FFFD replacement characters
#   RESULT G6.4  every non-ASCII codepoint declared in NONASCII_ALLOW
#
# The input file is a PARAMETER, deliberately not $WORK/gate.txt: --census FILE
# drives this same gate over a crafted fixture, and a hardcoded path would force
# that mode to duplicate the logic.
#
# Four classes, not the five ligature glyphs: private-use and replacement
# characters are the classes that actually appear when the ToUnicode mapping
# breaks, and neither is caught by looking for ligature glyphs.
#
# The block's exit status is the function's exit status, deliberately NOT masked
# with a trailing `return 0`: every caller redirects this stdout into a rows file,
# so a crash here produces an EMPTY rows file and would delete G6.1-G6.4 from the
# run. stderr is captured rather than discarded so the caller's die_group can name
# the python error. The function itself never emits a RESULT line -- its stdout
# belongs to the rows file, so the emitter has to stay at the call site.
glyph_census() {
    python3 - "$1" "$(manifest_get NONASCII_ALLOW)" 2>"$WORK/census.err" <<'PY'
import collections
import sys
import unicodedata

text = open(sys.argv[1], encoding='utf-8').read()
declared = {int(x, 16) for x in sys.argv[2].split(',') if x.strip()}
census = collections.Counter(ord(ch) for ch in text if ord(ch) > 0x7F)

ligature = sum(n for cp, n in census.items() if 0xFB00 <= cp <= 0xFB06)
private = sum(n for cp, n in census.items() if 0xE000 <= cp <= 0xF8FF)
replacement = census.get(0xFFFD, 0)

rows = [
    ('G6.1', 'PASS' if not ligature else 'FAIL',
     'ligature codepoints U+FB00-U+FB06: %d' % ligature),
    ('G6.2', 'PASS' if not private else 'FAIL',
     'private-use codepoints U+E000-U+F8FF: %d' % private),
    ('G6.3', 'PASS' if not replacement else 'FAIL',
     'U+FFFD replacement characters: %d' % replacement),
]

undeclared = [(cp, n) for cp, n in sorted(census.items()) if cp not in declared]
if undeclared:
    for cp, n in undeclared:
        rows.append(('G6.4', 'WARN',
                     'non-ASCII codepoint U+%04X x%d (%s) is absent from manifest NONASCII_ALLOW'
                     ' -- add it there if intentional'
                     % (cp, n, unicodedata.name(chr(cp), 'UNNAMED'))))
else:
    summary = ', '.join('U+%04X x%d' % (cp, n) for cp, n in sorted(census.items()))
    rows.append(('G6.4', 'PASS',
                 'every non-ASCII codepoint is declared in manifest NONASCII_ALLOW -- census: %s'
                 % (summary or 'no non-ASCII characters')))

for row in rows:
    print('%s|%s|%s' % row)
PY
}

# gate_line_of <string> -> the first line number in gate.txt whose WHOLE content
# equals <string>, or empty when absent.
gate_line_of() {
    LC_ALL=C grep -n -Fx -m1 -- "$1" "$WORK/gate.txt" 2>/dev/null | cut -d: -f1
    return 0
}

# section_region <heading> -> "<start> <end>", the gate.txt line range holding the
# BODY of one manifest SECTIONS heading. "0 0" when the heading is absent.
#
# The end is the smallest line number among all OTHER SECTIONS headings that
# occur after the located heading, minus one. It is computed over the whole
# SECTIONS set rather than the manifest's key order, because nothing guarantees
# the manifest lists headings in document order.
#
# The terminal-section fallback is explicit and load-bearing. The Skills heading
# is the LAST entry in SECTIONS, so no following heading exists to bound it. A
# helper that returned an empty range there would make G6.14 count 0 rendered
# lines -- and 0 is under SKILLS_MAX_LINES, so the assertion would report a
# silent false OK in place of today's real deviation. When no following heading
# exists the region therefore runs from the line after the heading through EOF.
#
# Bounding instead on "the next line that looks like a heading" would be wrong:
# it would stop at any body line that happens to be written in all caps.
section_region() {
    if [ ! -f "$WORK/sections.txt" ]; then
        manifest_list SECTIONS > "$WORK/sections.txt"
    fi
    _sr_head=$(gate_line_of "$1")
    if [ -z "$_sr_head" ]; then
        printf '0 0\n'
        return 0
    fi
    _sr_end=$(grep -c '' "$WORK/gate.txt")
    while IFS= read -r _sr_other; do
        if [ -z "$_sr_other" ] || [ "$_sr_other" = "$1" ]; then
            continue
        fi
        _sr_at=$(gate_line_of "$_sr_other")
        if [ -z "$_sr_at" ]; then
            continue
        fi
        if [ "$_sr_at" -gt "$_sr_head" ] && [ "$_sr_at" -le "$_sr_end" ]; then
            _sr_end=$((_sr_at - 1))
        fi
    done < "$WORK/sections.txt"
    printf '%s %s\n' "$((_sr_head + 1))" "$_sr_end"
    return 0
}

# region_line_of <start> <end> <string> -> the absolute gate.txt line number of
# the first whole-line match INSIDE the range, or empty. Scoping matters: some
# frozen strings occur more than once in the extraction.
region_line_of() {
    if [ "$1" -lt 1 ] || [ "$1" -gt "$2" ]; then
        return 0
    fi
    _rlo=$(sed -n "$1,$2p" "$WORK/gate.txt" | LC_ALL=C grep -n -Fx -m1 -- "$3" | cut -d: -f1)
    if [ -n "$_rlo" ]; then
        printf '%s\n' "$(($1 + _rlo - 1))"
    fi
    return 0
}

# region_nonempty_count <start> <end> -> non-blank line count inside the range.
region_nonempty_count() {
    if [ "$1" -lt 1 ] || [ "$1" -gt "$2" ]; then
        printf '0\n'
        return 0
    fi
    sed -n "$1,$2p" "$WORK/gate.txt" | grep -c '[^[:space:]]'
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

# geom_hash <texfile> -> normalized sha256 over two sorted streams. shasum is
# preferred over a BSD-only hash tool so the check also works on Linux.
#
# Defined here in the helper block rather than beside G4.1 because the baseline
# writer runs from a mode short-circuit above the content assertions and needs
# the SAME implementation -- a second copy of the hash rule is how a writer and
# a gate silently drift apart.
#
# The exit status is NOT masked (see die_group): under pipefail a failed python
# block makes the whole pipeline non-zero, and both callers check it. Unchecked,
# a crashed block would hash the grep stream alone -- which makes G4.1 FAIL for a
# fabricated reason, and would let --write-baseline freeze a hash covering half
# the geometry contract.
geom_hash() {
    _gk=$(manifest_get GEOMETRY_KEYS)
    # Matched inside the braces so trailing content on the line cannot leak in.
    _gre='\\addtolength\{\\('"$_gk"')\}\{[^}]*\}'
    {
        LC_ALL=C grep -hoE "$_gre" "$1" | sort
        python3 - "$1" 2>"$WORK/geom.err" <<'PY'
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
    # The same glyph_census used against the real text layer, driven over a
    # crafted fixture. This is what lets the four-class codepoint gate be proven
    # discriminating without building a deliberately corrupted PDF -- there is
    # exactly one implementation of the rules, so the control cannot drift away
    # from the assertion it is validating.
    glyph_census "$CENSUS_FILE" > "$WORK/census.rows"
    CENSUS_EC=$?
    [ "$CENSUS_EC" -eq 0 ] || die_group G6.1 "glyph census (G6.1-G6.4)" "$CENSUS_EC" "$WORK/census.err"
    emit_rows G6.1 "$WORK/census.rows"
    emit_rows G6.2 "$WORK/census.rows"
    emit_rows G6.3 "$WORK/census.rows"
    emit_rows G6.4 "$WORK/census.rows"
    printf '>> Census mode: glyph classes only, over %s. No PDF and no source were read, so G0.2-G0.4 and every other assertion group are deliberately absent from this run.\n' "$CENSUS_FILE"
    if [ "$BLOCKERS" -eq 0 ]; then
        printf '>> PASS: 0 blocking failures in the glyph census.\n'
        exit 0
    fi
    printf '!! FAIL: %s blocking failure(s) in:%s\n' "$BLOCKERS" "$FAILED_IDS"
    exit 1
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
# Self-test and baseline modes. Both short-circuit BEFORE the content
# assertions so neither pays for the extra extractions.
#
# G7 -- the overflow self-test. Its success condition is INVERTED relative to
# intuition: --selftest passes when the harness FAILS on the probe. A self-test
# that reported success because verification of a deliberately broken document
# came back clean would be worse than no self-test at all.
#
# An assertion that has never been observed failing is not a gate. G7 builds a
# document that today's build accepts warning-free, proves that premise
# numerically, proves the probe is a genuine overflow, and only then proves the
# page gates catch it -- naming the specific assertion IDs, because a probe that
# failed only on a pre-existing defect would otherwise count as a pass.
# ---------------------------------------------------------------------------

# p1_headroom -> page-1 headroom in pt against the manifest ceiling, measured on
# the artifact under test. Used only by the G7.2 rot guard's failure message, so
# the remedy carries the number that explains why the probe stopped overflowing.
p1_headroom() {
    pdftotext -bbox "$PDF" "$WORK/headroom.xml" 2>/dev/null
    python3 - "$WORK/headroom.xml" "$(manifest_get CEILING_PT)" 2>/dev/null <<'PY' > "$WORK/headroom.pt"
import sys
import xml.etree.ElementTree as ET


def localname(elem):
    return elem.tag.split('}')[-1]


root = ET.parse(sys.argv[1]).getroot()
ceiling = float(sys.argv[2])
for page in [p for p in root.iter() if localname(p) == 'page']:
    words = [w for w in page.iter() if localname(w) == 'word']
    if not words:
        continue
    print('%+.1f' % (ceiling - max(float(w.get('yMax')) for w in words)))
    break
else:
    print('unknown')
PY
    # This one feeds a remedy MESSAGE, never a gate, so a failed measurement
    # degrades to the same 'unknown' token the block prints when no page carries
    # positioned words -- an empty rows file yields no first line and grep falls
    # through. It must not die2: this runs inside a command substitution in a
    # message argument, where an exit would end only the subshell and leave the
    # caller printing a truncated remedy.
    grep -m1 . "$WORK/headroom.pt" 2>/dev/null || printf 'unknown\n'
    return 0
}

if [ "$MODE" = selftest ]; then
    # Re-invocation path. Resolved to an absolute path so the inner runs do not
    # depend on the caller's working directory.
    SELF="$0"
    case "$SELF" in
        /*) : ;;
        *)  SELF="$PWD/$SELF" ;;
    esac

    PROBE_LINES=$(manifest_get PROBE_LINES)
    PAGES_BUDGET=$(manifest_get PAGES)

    # Captured BEFORE anything is built, so G7.4 can prove the probe never
    # reached the committed artifact or the working tree.
    PDF_SHA_BEFORE=$(shasum -a 256 "$PDF" | awk '{print $1}')
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        GIT_OK=1
        git status --porcelain > "$WORK/tree.before" 2>/dev/null
    else
        GIT_OK=0
        : > "$WORK/tree.before"
    fi

    if ! command -v latexmk >/dev/null 2>&1; then
        # Loud SKIP for the whole group, then exit 2: the self-test could not
        # run, which is "cannot verify", never a pass.
        result G7.1 SKIP "latexmk is not on PATH so the overflow probe cannot be built"
        result G7.2 SKIP "latexmk is not on PATH so the probe page count cannot be measured"
        result G7.3 SKIP "latexmk is not on PATH so the page gates cannot be exercised against a probe"
        result G7.4 SKIP "latexmk is not on PATH so no probe ran; nothing to assert about the committed artifact"
        die2 "self-test cannot run: latexmk not found -> run 'make install'"
    fi

    # The probe scratch lives UNDER $WORK, so it is created by mktemp -d and is
    # released by the one guarded-removal path that already exists. The
    # committed artifact is structurally unreachable from here on two counts: a
    # different directory and a different jobname.
    PROBE_DIR=$(mktemp -d "$WORK/probe.XXXXXX") || die2 "cannot create the probe scratch directory"
    cp "$TEX" "$PROBE_DIR/probe.tex" || die2 "cannot copy $TEX into the probe scratch directory"

    # Structural anchor, never a content anchor: the page-1 region is bounded by
    # the document-begin and page-break tokens, and the insertion point is the
    # last list-end token inside it. An English-phrase anchor would break as soon
    # as a later phase rewrites the section it keys on.
    PROBE_ANCHOR=$(python3 - "$PROBE_DIR/probe.tex" "$PROBE_LINES" <<'PY' 2>&1
import sys

path, count = sys.argv[1], int(sys.argv[2])
lines = open(path, encoding='utf-8').read().split('\n')


def find(token, lo=0, hi=None):
    hi = len(lines) if hi is None else hi
    # Skipping the macro-definition form is ESSENTIAL, not defensive: the list-end
    # token is first defined near the top of the file via \newcommand, so a naive
    # first match resolves to the definition rather than the Experience usage --
    # measured, it crashed the first attempt with an index error.
    return [i for i in range(lo, hi) if token in lines[i] and '\\newcommand' not in lines[i]]


doc = find(r'\begin{document}')
if not doc:
    sys.exit('no document-begin token in %s' % path)
brk = find(r'\newpage', doc[0])
if not brk:
    sys.exit('no page-break token after the document-begin token in %s' % path)
at = find(r'\resumeItemListEnd', doc[0], brk[0])
if not at:
    sys.exit('no list-end token inside the page-1 region of %s' % path)

anchor = at[-1]
lines[anchor:anchor] = [
    r'        \resumeItem{VERIFY SELFTEST probe filler line %d --- must overflow page 1.}' % i
    for i in range(1, count + 1)
]
open(path, 'w', encoding='utf-8').write('\n'.join(lines))
print('begin=%d break=%d insert=%d' % (doc[0] + 1, brk[0] + 1, anchor + 1))
PY
    ) || die2 "probe injection failed: $PROBE_ANCHOR"

    # latexmk is called directly with its own flags. The Makefile's build flag
    # variable is deliberately NOT reused: it pins the repo jobname, and the
    # separate jobname is half of what keeps the committed artifact unreachable.
    ( cd "$PROBE_DIR" && latexmk -pdf -interaction=nonstopmode -halt-on-error -jobname=probe probe.tex ) \
        > "$PROBE_DIR/build.out" 2>&1
    PROBE_EC=$?
    PROBE_WARN=$(cat "$PROBE_DIR/probe.log" "$PROBE_DIR/build.out" 2>/dev/null \
        | LC_ALL=C grep -ciE 'overfull|underfull')

    # G7.1 establishes the premise the whole self-test rests on: today's build
    # ACCEPTS the injection, silently. If this ever fails, the premise is gone --
    # say so plainly instead of papering over it.
    if [ "$PROBE_EC" -eq 0 ] && [ "$PROBE_WARN" -eq 0 ]; then
        result G7.1 PASS "the build accepts +$PROBE_LINES injected line(s) silently: latexmk exit code $PROBE_EC with $PROBE_WARN overfull/underfull warning(s) ($PROBE_ANCHOR)"
    else
        result G7.1 FAIL "the premise that today's build accepts +$PROBE_LINES injected line(s) warning-free no longer holds: latexmk exit code $PROBE_EC with $PROBE_WARN overfull/underfull warning(s) ($PROBE_ANCHOR) -- the probe now trips a build diagnostic, so ROADMAP criterion 1's silent-overflow premise must be re-measured, not assumed"
    fi

    # G7.2 is the anti-rot guard and MUST run before G7.3. Concretely: 5 lines at
    # 11.5pt is about 57.5pt and today's page-1 slack is a fraction of a point, so
    # the probe overflows massively. But a later fold frees roughly 90-98pt, so if
    # content is not added back, page-1 headroom could exceed the probe's height
    # and a fixed-size probe would stop overflowing -- silently turning the whole
    # self-test into a no-op that reports success.
    PROBE_PAGES=$(pdfinfo "$PROBE_DIR/probe.pdf" 2>/dev/null | awk '/^Pages:/ {print $2; exit}')
    if [ -z "$PROBE_PAGES" ]; then
        result G7.2 FAIL "cannot read a page count from the probe PDF at $PROBE_DIR/probe.pdf -- the probe build produced no measurable page tree (latexmk exit code $PROBE_EC)"
    elif [ "$PROBE_PAGES" -gt "$PAGES_BUDGET" ]; then
        result G7.2 PASS "the probe PDF is $PROBE_PAGES page(s), above the manifest PAGES=$PAGES_BUDGET budget, so the +$PROBE_LINES probe is a genuine overflow"
    else
        result G7.2 FAIL "the probe PDF is only $PROBE_PAGES page(s) against manifest PAGES=$PAGES_BUDGET, so a +$PROBE_LINES probe NO LONGER overflows page 1 and the self-test would prove nothing -- page-1 headroom is now $(p1_headroom)pt against manifest CEILING_PT; raise PROBE_LINES in $MANIFEST until the probe exceeds the page budget again"
    fi

    # G7.3 re-invokes THIS script against the probe. --tex is paired with --pdf on
    # purpose: latexmk wrote probe.fdb_latexmk beside probe.pdf recording the md5
    # of the injected copy, so the freshness proof passes on its own terms and the
    # probe run exercises it rather than skipping it. --skip-freshness is NOT
    # passed here; that override belongs to one negative control alone.
    #
    # Asserting the specific IDs is the entire point. A probe that failed only on
    # a pre-existing text-layer defect would satisfy a bare "exit non-zero" check
    # and prove nothing about the page gates.
    bash "$SELF" --pdf "$PROBE_DIR/probe.pdf" --tex "$PROBE_DIR/probe.tex" \
        > "$PROBE_DIR/inner.out" 2>&1
    INNER_EC=$?
    INNER_G11=$(LC_ALL=C grep -cE '^RESULT G1\.1 +FAIL' "$PROBE_DIR/inner.out")
    INNER_G21=$(LC_ALL=C grep -cE '^RESULT G2\.1 +FAIL' "$PROBE_DIR/inner.out")

    if [ "$INNER_EC" -ne 0 ] && [ "$INNER_G11" -ge 1 ] && [ "$INNER_G21" -ge 1 ]; then
        result G7.3 PASS "verifying the probe fails on the right gates: exit $INNER_EC with G1.1 FAIL x$INNER_G11 (page count) and G2.1 FAIL x$INNER_G21 (page-1 boundary)"
    else
        result G7.3 FAIL "verifying the probe did not fail on the expected gates: exit $INNER_EC with G1.1 FAIL x$INNER_G11 and G2.1 FAIL x$INNER_G21 -- a $PROBE_PAGES-page probe must trip BOTH the page-count and the page-1 boundary assertion; an exit code alone could come from a pre-existing defect"
    fi

    # G7.4 proves the blast radius is empty. The tree clause compares the porcelain
    # snapshot before against after: the assertion is that the SELF-TEST changed
    # nothing, which is the property under test. Asserting absolute emptiness
    # instead would conflate that with "the caller's tree happened to be clean" and
    # would fire on any unrelated edit in progress. Fail closed without git: a
    # self-test that cannot prove it left no trace has not done its job.
    PDF_SHA_AFTER=$(shasum -a 256 "$PDF" | awk '{print $1}')
    if [ "$GIT_OK" -eq 1 ]; then
        git status --porcelain > "$WORK/tree.after" 2>/dev/null
    else
        : > "$WORK/tree.after"
    fi
    TREE_N=$(LC_ALL=C grep -c '[^[:space:]]' "$WORK/tree.after")

    if [ "$PDF_SHA_BEFORE" != "$PDF_SHA_AFTER" ]; then
        result G7.4 FAIL "the committed artifact CHANGED during the self-test: $PDF was sha256 $PDF_SHA_BEFORE and is now $PDF_SHA_AFTER -- the probe escaped its scratch directory; restore the artifact from git before trusting any result above"
    elif [ "$GIT_OK" -ne 1 ]; then
        result G7.4 FAIL "$PDF is byte-unchanged (sha256 $PDF_SHA_AFTER) but this is not a git work tree, so the no-side-effect clause cannot be proven -- run the self-test inside the repository"
    elif ! cmp -s "$WORK/tree.before" "$WORK/tree.after"; then
        result G7.4 FAIL "the self-test changed the working tree: git status --porcelain went from $(LC_ALL=C grep -c '[^[:space:]]' "$WORK/tree.before") to $TREE_N path(s) -- a probe artifact leaked out of the scratch directory"
    elif [ "$TREE_N" -eq 0 ]; then
        result G7.4 PASS "$PDF byte-unchanged (sha256 $PDF_SHA_AFTER) and git status --porcelain empty before and after the probe"
    else
        result G7.4 PASS "$PDF byte-unchanged (sha256 $PDF_SHA_AFTER) and the self-test added no git status --porcelain entry ($TREE_N path(s) were already modified before the probe ran; the assertion is that the self-test changed nothing, not that the tree happened to be clean)"
    fi

    # -----------------------------------------------------------------------
    # G8 -- non-probe negative controls, one per assertion class. Each mutates
    # ONE input on a mktemp -d copy, re-invokes this script against the copy, and
    # asserts that the expected assertion ID reports FAIL. A control that does NOT
    # produce its expected failure is itself a BLOCKER failure: that is the entire
    # point of a negative control. Nothing under docs/ is ever written.
    #
    # The IDs are a separate G8.x series so they cannot collide with the document
    # assertions the inner runs emit.
    # -----------------------------------------------------------------------

    CTL_TEX_NAME=$(basename "$TEX")
    shasum -a 256 "$FROZEN" "$MANIFEST" "$TEX" > "$WORK/inputs.before" 2>/dev/null
    CTL_SUMMARY=""

    # --- G8.1 -- the honesty freeze fires on a ONE-BYTE change ---------------
    # The control for VERIFY-03's byte-identical clause: a single digit inside one
    # frozen employment date, changed digit-for-digit so the mutation really is
    # one byte, must make the whole-line matcher report count=0.
    CTL_DIR=$(mktemp -d "$WORK/ctl-frozen.XXXXXX") || die2 "cannot create the G8.1 control directory"
    cp "$FROZEN" "$CTL_DIR/frozen.txt" || die2 "cannot copy $FROZEN for the G8.1 control"
    CTL_DATE=$(frozen_section '[dates]' | grep -m1 .)
    CTL_MUTATION=$(python3 - "$CTL_DIR/frozen.txt" "$CTL_DATE" <<'PY' 2>&1
import re
import sys

path, target = sys.argv[1], sys.argv[2]
lines = open(path, encoding='utf-8').read().split('\n')
for index, line in enumerate(lines):
    if line == target:
        # Digit for digit: an ASCII digit replaced by another ASCII digit is a
        # one-byte edit, which is what the byte-identical clause is about.
        mutated = re.sub(r'\d', lambda m: str((int(m.group(0)) + 1) % 10), line, count=1)
        if mutated == line:
            sys.exit('no digit to mutate in the first frozen date: %r' % line)
        lines[index] = mutated
        open(path, 'w', encoding='utf-8').write('\n'.join(lines))
        print("'%s' -> '%s'" % (line, mutated))
        break
else:
    sys.exit('the first frozen date is not present in the copied freeze: %r' % target)
PY
    ) || die2 "G8.1 control could not mutate the frozen copy: $CTL_MUTATION"

    bash "$SELF" --frozen "$CTL_DIR/frozen.txt" > "$CTL_DIR/out" 2>&1
    if LC_ALL=C grep -qE '^RESULT G5\.1 +FAIL.*count=0' "$CTL_DIR/out"; then
        result G8.1 PASS "the honesty freeze fires on a one-byte date change: $CTL_MUTATION produced RESULT G5.1 FAIL with count=0"
        CTL_SUMMARY="$CTL_SUMMARY G8.1/G5.1"
    else
        result G8.1 FAIL "the honesty freeze did NOT fire on a one-byte date change ($CTL_MUTATION): no 'RESULT G5.1 FAIL ... count=0' line -- the matcher has been weakened from whole-line exact-count, so a changed employment date could ship unnoticed"
    fi

    # --- G8.2 -- geometry drift fires (via the single documented override) ----
    # --skip-freshness is MANDATORY here and is the one documented precedence rule
    # for the G0.3-versus-G4.1 collision: mutating the source makes its md5 diverge
    # from the latexmk record, so without the flag G0.3 refuses at exit 2 before any
    # G4 assertion can run and RESULT G4.1 FAIL could never be emitted.
    #
    # The flag exists SOLELY for this control. No Makefile target passes it, and a
    # run carrying it is not a verification pass -- G0.3 prints SKIP on every such
    # run precisely so that is visible. It must never be widened into "auto-skip
    # whenever --tex is overridden": G8.3 below depends on an overridden --tex
    # still being refused.
    CTL_DIR=$(mktemp -d "$WORK/ctl-geometry.XXXXXX") || die2 "cannot create the G8.2 control directory"
    CTL_DRIFT=$(python3 - "$TEX" "$CTL_DIR/$CTL_TEX_NAME" <<'PY' 2>&1
import re
import sys

src, dst = sys.argv[1], sys.argv[2]
source = open(src, encoding='utf-8').read()
pattern = r'(\\addtolength\{\\textheight\}\{)([0-9]*\.?[0-9]+)(in\})'
match = re.search(pattern, source)
if not match:
    sys.exit('no \\textheight addition found in %s' % src)
before = match.group(2)
after = '%.1f' % (float(before) + 0.1)
open(dst, 'w', encoding='utf-8').write(
    source[:match.start()] + match.group(1) + after + match.group(3) + source[match.end():])
print('textheight %sin -> %sin' % (before, after))
PY
    ) || die2 "G8.2 control could not write a drifted source: $CTL_DRIFT"

    bash "$SELF" --tex "$CTL_DIR/$CTL_TEX_NAME" --skip-freshness > "$CTL_DIR/out" 2>&1
    if LC_ALL=C grep -qE '^RESULT G4\.1 +FAIL' "$CTL_DIR/out"; then
        result G8.2 PASS "the geometry freeze fires on margin drift: $CTL_DRIFT produced RESULT G4.1 FAIL (reached through --skip-freshness, which G0.3 reported as SKIP)"
        CTL_SUMMARY="$CTL_SUMMARY G8.2/G4.1"
    else
        result G8.2 FAIL "the geometry freeze did NOT fire on margin drift ($CTL_DRIFT): no 'RESULT G4.1 FAIL' line -- either the hash no longer covers the geometry declarations, or the run never reached G4"
    fi

    # --- G8.3 -- the staleness REFUSAL stays distinct from a content failure --
    # Deliberately WITHOUT --skip-freshness, and the copy deliberately keeps the
    # original basename: the freshness record is looked up by source filename, so a
    # renamed copy would find no record, escalate to the L2 rebuild arbiter, and
    # come back FRESH -- a comment appended after the document end changes bytes
    # but not the rendered document. L1 (byte md5) is strictly stronger than L2
    # here, and this control depends on taking the L1 path.
    #
    # Exit code 2 is asserted exactly, not merely as non-zero: it is the
    # refuse-to-verify code, which must never be conflated with the exit code 1
    # that means the document was verified and found wrong. It has to be asserted
    # against the script, because Make reports every failed recipe as exit 2 and
    # would erase the distinction.
    CTL_DIR=$(mktemp -d "$WORK/ctl-stale.XXXXXX") || die2 "cannot create the G8.3 control directory"
    cp "$TEX" "$CTL_DIR/$CTL_TEX_NAME" || die2 "cannot copy $TEX for the G8.3 control"
    printf '%%%% verify-resume selftest G8.3 staleness control\n' >> "$CTL_DIR/$CTL_TEX_NAME"
    bash "$SELF" --tex "$CTL_DIR/$CTL_TEX_NAME" > "$CTL_DIR/out" 2>&1
    CTL_EC=$?
    CTL_G03=$(LC_ALL=C grep -cE '^RESULT G0\.3 +FAIL' "$CTL_DIR/out")
    if [ "$CTL_EC" -eq 2 ] && [ "$CTL_G03" -ge 1 ]; then
        result G8.3 PASS "a drifted source is REFUSED rather than reported wrong: exit code 2 with RESULT G0.3 FAIL x$CTL_G03, machine-readable and distinct from the exit code 1 that means the document is wrong"
    else
        result G8.3 FAIL "the staleness refusal is broken: exit code $CTL_EC (want exactly 2) with RESULT G0.3 FAIL x$CTL_G03 (want at least 1) -- a stale artifact must be refused, never verified; exit code 1 here would report a wrong document instead of an unverifiable one"
    fi
    if [ "$CTL_EC" -eq 2 ]; then
        CTL_SUMMARY="$CTL_SUMMARY G8.3/G0.3-exit2"
    fi

    # --- G8.4 -- glyph corruption fires -------------------------------------
    # A crafted text fixture, driven through --census, so the codepoint gate is
    # proven discriminating without a corrupted PDF. UTF-8 byte escapes are used
    # because bash 3.2's printf has no codepoint escape.
    #   \357\254\201 = U+FB01 LATIN SMALL LIGATURE FI
    #   \357\277\275 = U+FFFD REPLACEMENT CHARACTER
    #   \356\200\200 = U+E000 private-use area
    CTL_DIR=$(mktemp -d "$WORK/ctl-glyph.XXXXXX") || die2 "cannot create the G8.4 control directory"
    printf 'con\357\254\201guration \357\277\275 and \356\200\200 in one fixture\n' > "$CTL_DIR/glyph.txt"
    bash "$SELF" --census "$CTL_DIR/glyph.txt" > "$CTL_DIR/out" 2>&1
    CTL_EC=$?
    CTL_N=$(LC_ALL=C grep -cE '^RESULT G6\.(1|2|3) +FAIL' "$CTL_DIR/out")
    if [ "$CTL_EC" -eq 1 ] && [ "$CTL_N" -eq 3 ]; then
        result G8.4 PASS "all three glyph classes fire on a corrupted text fixture: G6.1 (ligature), G6.2 (private-use) and G6.3 (replacement character) all FAIL, census exit code 1"
        CTL_SUMMARY="$CTL_SUMMARY G8.4/G6.1-3"
    else
        result G8.4 FAIL "the glyph gate did not discriminate: census exit code $CTL_EC (want 1) with $CTL_N of 3 expected G6.1/G6.2/G6.3 FAIL lines -- a broken ToUnicode mapping would ship undetected"
    fi

    # --- G8.5 -- an absent required keyword fires ---------------------------
    # Only --manifest is overridden, so the freshness proof still passes against
    # the untouched source and no override flag is needed.
    CTL_DIR=$(mktemp -d "$WORK/ctl-keyword.XXXXXX") || die2 "cannot create the G8.5 control directory"
    CTL_TOKEN="ZZSELFTESTKEYWORDABSENTBYCONSTRUCTION"
    sed "s/^KEYWORDS_REQUIRED=.*/&|$CTL_TOKEN/" "$MANIFEST" > "$CTL_DIR/manifest.txt"
    bash "$SELF" --manifest "$CTL_DIR/manifest.txt" > "$CTL_DIR/out" 2>&1
    if LC_ALL=C grep -qE "^RESULT G6\.5 +FAIL.*$CTL_TOKEN" "$CTL_DIR/out"; then
        result G8.5 PASS "a required keyword that is absent from the text layer fires: RESULT G6.5 FAIL names '$CTL_TOKEN'"
        CTL_SUMMARY="$CTL_SUMMARY G8.5/G6.5"
    else
        result G8.5 FAIL "an absent required keyword did NOT fire: no 'RESULT G6.5 FAIL' line naming '$CTL_TOKEN' -- the keyword tier is not gating, so a regression that drops a required keyword would pass"
    fi

    # --- G8.6 -- the control group's blast radius is empty -------------------
    # The G8 analogue of G7.4, emitted on every run rather than only on failure.
    # Two clauses: the three tracked inputs the controls copy are checksum-identical,
    # and the controls added no working-tree entry.
    shasum -a 256 "$FROZEN" "$MANIFEST" "$TEX" > "$WORK/inputs.after" 2>/dev/null
    if [ "$GIT_OK" -eq 1 ]; then
        git status --porcelain > "$WORK/tree.controls" 2>/dev/null
    else
        : > "$WORK/tree.controls"
    fi

    if ! cmp -s "$WORK/inputs.before" "$WORK/inputs.after"; then
        result G8.6 FAIL "a negative control MUTATED a tracked input: $FROZEN, $MANIFEST or $TEX changed checksum during the control group -- a control wrote in place instead of on its scratch copy; restore them from git"
    elif [ "$GIT_OK" -ne 1 ]; then
        result G8.6 FAIL "the tracked inputs are checksum-identical but this is not a git work tree, so the no-side-effect clause cannot be proven -- run the self-test inside the repository"
    elif ! cmp -s "$WORK/tree.before" "$WORK/tree.controls"; then
        result G8.6 FAIL "the negative controls changed the working tree: git status --porcelain went from $(LC_ALL=C grep -c '[^[:space:]]' "$WORK/tree.before") to $(LC_ALL=C grep -c '[^[:space:]]' "$WORK/tree.controls") path(s) -- a control escaped its scratch directory"
    else
        result G8.6 PASS "every control ran on a scratch copy: $FROZEN, $MANIFEST and $TEX are checksum-identical and the controls added no git status --porcelain entry"
    fi

    printf '>> Probe: +%s line(s) injected at %s in a scratch copy, built with jobname=probe.\n' \
        "$PROBE_LINES" "$PROBE_ANCHOR"
    printf '>> Controls: each assertion class observed FAILING as well as passing --%s.\n' "$CTL_SUMMARY"
    printf '>> Self-test acceptance is INVERTED: it passes because verification FAILED on the probe and on every mutated input.\n'

    if [ "$BLOCKERS" -eq 0 ]; then
        printf '>> PASS: the gates fire. 0 blocking failures in the self-test.\n'
        exit 0
    fi
    printf '!! FAIL: %s blocking failure(s) in:%s\n' "$BLOCKERS" "$FAILED_IDS"
    printf '!! The harness is wrong, or the probe no longer overflows. Read the FAIL lines above.\n'
    exit 1
fi

# ---------------------------------------------------------------------------
# --write-baseline -- the V14 configuration control, and the ONLY code path in
# this milestone that writes a baseline file.
#
# It regenerates docs/verify/manifest.txt only. Two classes of key, and the
# distinction is the whole point:
#
#   RE-MEASURED  observation-only keys that nothing gates as a BLOCKER. Their
#                purpose IS to record what the current artifact measures, so
#                regenerating them is maintenance.
#   PRESERVED    every key a BLOCKER gates on, plus every policy and contract
#                key. These are measured and REPORTED but never written. A
#                generator that quietly raised the page budget to match a
#                three-page document, or moved the page-2 opening heading to
#                match a spilled boundary, would defeat the gate exactly the way
#                re-freezing a changed employment date defeats the honesty
#                freeze. Raising a threshold is a reviewed edit, not a
#                regeneration.
#
# The honesty freeze is refused outright without ALLOW_FROZEN_UPDATE=1, and even
# with it only the mechanically derivable geometry hash is regenerated -- the 15
# strings are hand-authored by design -- and a unified diff is printed first.
# ---------------------------------------------------------------------------

if [ "$MODE" = write-baseline ]; then
    pdftotext -bbox "$PDF" "$WORK/wb.xml" 2>/dev/null || die2 "pdftotext -bbox failed to measure $PDF"
    pdftotext -f 2 -l 2 "$PDF" "$WORK/wb.p2" 2>/dev/null
    [ -f "$WORK/wb.p2" ] || : > "$WORK/wb.p2"

    # Same %.1f formatting as G3.3 and G4.3, so a re-measured value is
    # byte-identical to the one those assertions print.
    WB_MEASURED=$(python3 - "$WORK/wb.xml" 2>"$WORK/wb.err" <<'PY'
import sys
import xml.etree.ElementTree as ET


def localname(elem):
    return elem.tag.split('}')[-1]


root = ET.parse(sys.argv[1]).getroot()
for page in [p for p in root.iter() if localname(p) == 'page']:
    words = [w for w in page.iter() if localname(w) == 'word']
    if not words:
        continue
    print('%.1f %.1f' % (min(float(w.get('yMin')) for w in words),
                         float(page.get('height')) - max(float(w.get('yMax')) for w in words)))
    break
else:
    print('unknown unknown')
PY
    )
    WB_EC=$?
    # A crashed measurement leaves WB_MEASURED empty, which is NOT the 'unknown'
    # sentinel the block prints for an unmeasurable page -- so without this check
    # the writer would stage "P1_TOP_PT=" into the manifest and every later run
    # would read an empty threshold.
    if [ "$WB_EC" -ne 0 ]; then
        [ -s "$WORK/wb.err" ] && sed 's/^/!!   /' "$WORK/wb.err" >&2
        die2 "the page-1 bbox measurement block failed (exit $WB_EC), so $MANIFEST cannot be regenerated -- nothing was written"
    fi
    WB_P1TOP=${WB_MEASURED%% *}
    WB_P1WS=${WB_MEASURED##* }
    WB_PAGES=$(pdfinfo "$PDF" 2>/dev/null | awk '/^Pages:/ {print $2; exit}')
    WB_SIZE=$(pdfinfo "$PDF" 2>/dev/null | sed -n 's/^Page size:[[:space:]]*//p' | head -1)
    WB_P2OPEN=$(tr '\f' '\n' < "$WORK/wb.p2" | grep -m1 .)

    if [ "$WB_P1TOP" = unknown ] || [ "$WB_P1WS" = unknown ]; then
        die2 "cannot measure page-1 extents from $PDF, so the manifest cannot be regenerated"
    fi

    # Rewrite line-wise, so key ORDER, blank lines, group comments and trailing
    # "#" annotations all survive untouched. The annotation column is preserved
    # explicitly rather than by luck, so a value whose length changed does not
    # shift the comment.
    : > "$WORK/manifest.new"
    while IFS= read -r WB_LINE || [ -n "$WB_LINE" ]; do
        WB_KEY=""
        case "$WB_LINE" in
            [A-Z]*=*) WB_KEY=${WB_LINE%%=*} ;;
        esac
        WB_NEW=""
        case "$WB_KEY" in
            P1_TOP_PT)       WB_NEW="$WB_P1TOP" ;;
            P1_BOTTOM_WS_PT) WB_NEW="$WB_P1WS" ;;
        esac
        if [ -z "$WB_NEW" ]; then
            printf '%s\n' "$WB_LINE" >> "$WORK/manifest.new"
            continue
        fi
        WB_ANNOT=$(printf '%s\n' "$WB_LINE" | awk '{i = index($0, "#"); if (i > 0) print substr($0, i)}')
        WB_HEAD=$(printf '%s=%s' "$WB_KEY" "$WB_NEW")
        if [ -z "$WB_ANNOT" ]; then
            printf '%s\n' "$WB_HEAD" >> "$WORK/manifest.new"
        else
            WB_COL=$(printf '%s' "$WB_LINE" | awk '{print index($0, "#")}')
            WB_PAD=$((WB_COL - 1 - ${#WB_HEAD}))
            [ "$WB_PAD" -lt 1 ] && WB_PAD=1
            printf '%s%*s%s\n' "$WB_HEAD" "$WB_PAD" "" "$WB_ANNOT" >> "$WORK/manifest.new"
        fi
    done < "$MANIFEST"

    printf '>> Re-measured (observation-only keys): P1_TOP_PT=%s P1_BOTTOM_WS_PT=%s\n' \
        "$WB_P1TOP" "$WB_P1WS"

    # Gated thresholds: reported, never written.
    WB_DRIFT=0
    for WB_PAIR in "PAGES:$WB_PAGES:G1.1" "PAGE_SIZE:$WB_SIZE:G4.2" "PAGE2_OPENS_WITH:$WB_P2OPEN:G2.1"; do
        WB_K=${WB_PAIR%%:*}
        WB_REST=${WB_PAIR#*:}
        WB_LIVE=${WB_REST%:*}
        WB_GATE=${WB_REST##*:}
        WB_HAVE=$(manifest_get "$WB_K")
        if [ "$WB_LIVE" != "$WB_HAVE" ]; then
            WB_DRIFT=$((WB_DRIFT + 1))
            printf '!! %s: the artifact now measures "%s" but the manifest records "%s". NOT rewritten -- %s gates on this key, and matching a threshold to a document that moved away from it deletes the gate. Change it only as a reviewed edit to %s.\n' \
                "$WB_K" "$WB_LIVE" "$WB_HAVE" "$WB_GATE" "$MANIFEST"
        fi
    done
    if [ "$WB_DRIFT" -eq 0 ]; then
        printf '>> Preserved (BLOCKER-gated thresholds, all still matching the artifact): PAGES, CEILING_PT, PAGE_SIZE, PAGE2_OPENS_WITH.\n'
    fi
    printf '>> Preserved verbatim (policy and contract): section structure, Education binding, geometry keys, contact literals, text-layer rules, keyword tiers, WARN owners, PROBE_LINES.\n'

    if cmp -s "$MANIFEST" "$WORK/manifest.new"; then
        printf '>> %s already matches live measurement; nothing written.\n' "$MANIFEST"
    else
        printf '>> Proposed change to %s (unified diff):\n' "$MANIFEST"
        diff -u "$MANIFEST" "$WORK/manifest.new"
        # The staging copy is a SIBLING of the target on purpose: mv is only a
        # true atomic rename within one filesystem, and $WORK lives under the
        # system temp directory. An interrupted run therefore cannot leave a
        # half-written manifest behind, only an unreferenced sibling.
        WB_TMP="$MANIFEST.regen.$$"
        if cp "$WORK/manifest.new" "$WB_TMP" && mv "$WB_TMP" "$MANIFEST"; then
            printf '>> Rewrote %s.\n' "$MANIFEST"
        else
            rm -f "$WB_TMP"
            die2 "could not write $MANIFEST"
        fi
    fi

    # The honesty freeze. Only the [geometry-sha256] value is derivable; the 15
    # frozen strings are hand-authored and are never generated from the artifact,
    # because a generated honesty baseline re-freezes whatever the document now
    # says -- which is the milestone's highest-consequence failure mode.
    WB_GEOM=$(geom_hash "$TEX")
    WB_GEOM_EC=$?
    if [ "$WB_GEOM_EC" -ne 0 ] || [ -z "$WB_GEOM" ]; then
        # Never fall through to the awk rewrite below on a failed measurement: it
        # would freeze a hash covering only part of the geometry contract, and a
        # frozen wrong hash makes G4.1 PASS forever on a gate that stopped
        # covering what it claims.
        [ -s "$WORK/geom.err" ] && sed 's/^/!!   /' "$WORK/geom.err" >&2
        die2 "the geometry hash could not be computed from $TEX (exit $WB_GEOM_EC), so the honesty freeze cannot be evaluated -- refusing to touch $FROZEN"
    fi
    awk -v want='[geometry-sha256]' -v hash="$WB_GEOM" '
        /^[[:space:]]*#/ { print; next }
        /^\[/            { inside = ($0 == want) ? 1 : 0; print; next }
        inside && NF     { print hash; next }
                         { print }
    ' "$FROZEN" > "$WORK/frozen.new"

    if [ "${ALLOW_FROZEN_UPDATE:-0}" = 1 ]; then
        printf '>> ALLOW_FROZEN_UPDATE=1 -- proposed change to %s, geometry hash only (unified diff):\n' "$FROZEN"
        if diff -u "$FROZEN" "$WORK/frozen.new" > "$WORK/frozen.diff"; then
            printf -- '--- %s\n' "$FROZEN"
            printf -- '+++ %s (regenerated)\n' "$FROZEN"
            printf '@@ no differences @@\n'
            printf '>> The frozen geometry hash already matches %s; nothing written.\n' "$TEX"
        else
            cat "$WORK/frozen.diff"
            WB_TMP="$FROZEN.regen.$$"
            if cp "$WORK/frozen.new" "$WB_TMP" && mv "$WB_TMP" "$FROZEN"; then
                printf '>> Rewrote the geometry hash in %s. The 15 frozen strings were NOT touched -- verify each one by hand.\n' "$FROZEN"
            else
                rm -f "$WB_TMP"
                die2 "could not write $FROZEN"
            fi
        fi
    elif cmp -s "$FROZEN" "$WORK/frozen.new"; then
        printf '>> %s left untouched (its geometry hash already matches %s). Regenerating it at all requires ALLOW_FROZEN_UPDATE=1.\n' "$FROZEN" "$TEX"
    else
        printf '!! REFUSING to write %s: its geometry hash would change from %s to %s.\n' \
            "$FROZEN" "$(frozen_section '[geometry-sha256]' | grep -m1 .)" "$WB_GEOM"
        printf '!! The honesty freeze is hand-authored and is never regenerated by accident. Re-run with ALLOW_FROZEN_UPDATE=1 to see the diff and write it, after confirming the geometry change was intended.\n'
    fi

    printf '>> Baseline pass complete. Run '"'"'make verify'"'"' to gate the document; this mode asserts nothing.\n'
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

python3 - "$WORK/bbox.xml" "$CEILING_PT" "$LINE_PT" "$P1_WS_PT" 2>"$WORK/bbox.err" <<'PY' > "$WORK/bbox.rows"
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
BBOX_EC=$?
# Measured: an empty or missing CEILING_PT makes float('') raise, the rows file
# comes out empty, and G3.1-G3.4 vanish from the run with BLOCKERS untouched.
[ "$BBOX_EC" -eq 0 ] || die_group G3.1 "page fill and page box (G3.1-G3.4)" "$BBOX_EC" "$WORK/bbox.err"
# This group is read by the loop below rather than by emit_rows, so it needs the
# same zero-row guard emit_rows carries: a block that exits 0 without emitting a
# row still deletes its assertions from the RESULT stream.
[ -s "$WORK/bbox.rows" ] || die_group G3.1 "page fill and page box (G3.1-G3.4)" "$BBOX_EC (no rows emitted)" "$WORK/bbox.err"

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

# geom_hash is defined once in the helper block above, because the baseline
# writer needs the same implementation from a mode that short-circuits before
# this point.

GEOM_WANT=$(frozen_section '[geometry-sha256]' | grep -m1 .)
GEOM_GOT=$(geom_hash "$TEX")
GEOM_EC=$?
[ "$GEOM_EC" -eq 0 ] || die_group G4.1 "geometry and spacing freeze (G4.1)" "$GEOM_EC" "$WORK/geom.err"

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
# G6.1-G6.4 -- the glyph gate. One reusable block, invoked here over the
# form-feed-normalized whole-document text.
# ---------------------------------------------------------------------------

glyph_census "$WORK/gate.txt" > "$WORK/census.rows"
CENSUS_EC=$?
[ "$CENSUS_EC" -eq 0 ] || die_group G6.1 "glyph census (G6.1-G6.4)" "$CENSUS_EC" "$WORK/census.err"
emit_rows G6.1 "$WORK/census.rows"
emit_rows G6.2 "$WORK/census.rows"
emit_rows G6.3 "$WORK/census.rows"
emit_rows G6.4 "$WORK/census.rows"

# ---------------------------------------------------------------------------
# G6.5 / G6.6 -- keyword tiers. Together these ARE the promotion mechanism: a
# phase that adds a keyword moves its entry from KEYWORDS_TARGET to
# KEYWORDS_REQUIRED in the same commit. Do not add any other deferral construct.
#
# Counting is CASE-SENSITIVE, and that is a correctness requirement rather than
# a preference: ATS matchers are substring-literal, so a case-insensitive count
# reports 'PyTorch' as more present than it indexably is -- the Skills line
# writes a differently-cased variant that earns nothing.
# ---------------------------------------------------------------------------

manifest_list KEYWORDS_REQUIRED > "$WORK/kw.required"
while IFS= read -r KW; do
    [ -n "$KW" ] || continue
    N=$(LC_ALL=C grep -oF "$KW" "$WORK/gate.txt" | wc -l | tr -d ' ')
    if [ "$N" != 0 ]; then
        result G6.5 PASS "required keyword present (case-sensitive): '$KW' x$N"
    else
        result G6.5 FAIL "required keyword absent from the text layer (case-sensitive): '$KW' -- restore it, or move it back to KEYWORDS_TARGET in $MANIFEST with an owning phase"
    fi
done < "$WORK/kw.required"

# Each entry carries its own ":phase" suffix and that suffix WINS over the
# categorical WARN_OWNERS entry -- three of the seven targets belong to a
# different phase than the categorical value would suggest.
manifest_list KEYWORDS_TARGET > "$WORK/kw.target"
while IFS= read -r ENTRY; do
    [ -n "$ENTRY" ] || continue
    case "$ENTRY" in
        *:*) KW=${ENTRY%:*}; KW_OWNER=${ENTRY##*:} ;;
        *)   KW="$ENTRY";    KW_OWNER=$(warn_owner G6.6) ;;
    esac
    N=$(LC_ALL=C grep -oF "$KW" "$WORK/gate.txt" | wc -l | tr -d ' ')
    warn G6.6 "$KW_OWNER" "target keyword '$KW' x$N -- promote it into KEYWORDS_REQUIRED in the same commit that adds it"
done < "$WORK/kw.target"

# ---------------------------------------------------------------------------
# G6.7 -- prohibited terms. The word-boundary flag is mandatory and measured: a
# naive substring count for 'Go' returns 1 today because it matches 'Goal' in
# the source text, while a word-boundary count returns 0. Without -w this
# assertion fails on today's document for a false reason.
# ---------------------------------------------------------------------------

PROHIB_HITS=""
manifest_list PROHIBITED_WORDS > "$WORK/prohibited.words"
while IFS= read -r PW; do
    [ -n "$PW" ] || continue
    N=$(LC_ALL=C grep -Fowc "$PW" "$WORK/gate.txt")
    if [ "$N" != 0 ]; then
        PROHIB_HITS="$PROHIB_HITS word '$PW' on $N line(s);"
    fi
done < "$WORK/prohibited.words"

manifest_list PROHIBITED_PHRASES > "$WORK/prohibited.phrases"
while IFS= read -r PP; do
    [ -n "$PP" ] || continue
    N=$(LC_ALL=C grep -Fc "$PP" "$WORK/gate.txt")
    if [ "$N" != 0 ]; then
        PROHIB_HITS="$PROHIB_HITS phrase '$PP' on $N line(s);"
    fi
done < "$WORK/prohibited.phrases"

if [ -z "$PROHIB_HITS" ]; then
    result G6.7 PASS "no prohibited term in the text layer (words counted with word boundaries, phrases as fixed strings)"
else
    result G6.7 FAIL "prohibited term(s) in the text layer:$PROHIB_HITS -- these have no commit evidence and are an interview risk; remove them"
fi

# ---------------------------------------------------------------------------
# G6.8 -- canonical section headings. This MUST read the form-feed-normalized
# text. Measured: against the raw extraction a whole-line search for the page-2
# opening heading returns 0, because the page-1 form feed is glued to that
# heading's first character; against the normalized text all headings return 1.
# ---------------------------------------------------------------------------

manifest_list SECTIONS > "$WORK/sections.txt"
while IFS= read -r SH; do
    [ -n "$SH" ] || continue
    N=$(LC_ALL=C grep -Fxc "$SH" "$WORK/gate.txt")
    if [ "$N" != 0 ]; then
        result G6.8 PASS "section heading extracts as a whole line: '$SH'"
    else
        result G6.8 FAIL "section heading does not extract as a whole line: '$SH' -- ATS parsers key on canonical headings; restore it, or update SECTIONS in $MANIFEST in the same commit that renames it"
    fi
done < "$WORK/sections.txt"

# ---------------------------------------------------------------------------
# G6.9 / G6.10 -- the two contact-literal defects, both live today.
#
# G6.9: docs/main.tex:134-136 masks the links behind display anchor text
# ('Github@thunderock', 'Homepage/Portfolio'), so the URI annotations live in
# compressed object streams that text extraction never sees. An ATS reads the
# text layer, so a masked URL is an absent URL.
#
# G6.10: LaTeX converts the source double hyphen in the handle to an EN DASH, so
# the rendered text layer carries a handle that resolves to nothing.
# ---------------------------------------------------------------------------

manifest_list CONTACT_LITERALS > "$WORK/contacts.txt"
while IFS= read -r LIT; do
    [ -n "$LIT" ] || continue
    N=$(LC_ALL=C grep -Fc "$LIT" "$WORK/gate.txt")
    if [ "$N" != 0 ]; then
        result G6.9 PASS "contact literal present in the text layer: '$LIT' on $N line(s)"
    else
        result G6.9 FAIL "contact literal missing from the text layer: '$LIT' (0 occurrences) -- the anchor at docs/main.tex:134-136 masks it behind display text; make the anchor text the literal URL. Owner: Phase 2 / EXP-06"
    fi
done < "$WORK/contacts.txt"

FORBIDDEN_LIT=$(manifest_get FORBIDDEN_LITERAL)
N=$(LC_ALL=C grep -Fc "$FORBIDDEN_LIT" "$WORK/gate.txt")
if [ "$N" = 0 ]; then
    result G6.10 PASS "corrupted handle form '$FORBIDDEN_LIT' absent from the text layer"
else
    result G6.10 FAIL "corrupted handle present in the text layer: '$FORBIDDEN_LIT' on $N line(s) (U+2013 EN DASH) -- LaTeX converted the source double hyphen; break the ligature in the anchor text at docs/main.tex:134. Owner: Phase 2 / EXP-06"
fi

# ---------------------------------------------------------------------------
# G6.11 -- -raw mode divergence. INFO only and permanently so: gating on -raw is
# provably unfixable in LaTeX, so the divergence is reported, never asserted.
# ---------------------------------------------------------------------------

pdftotext -raw "$PDF" "$WORK/rawmode.txt" 2>/dev/null
if [ -s "$WORK/rawmode.txt" ]; then
    tr -cs '[:alnum:]@.:/' '\n' < "$WORK/rawmode.txt" | LC_ALL=C sort -u > "$WORK/rawmode.tok"
    tr -cs '[:alnum:]@.:/' '\n' < "$WORK/gate.txt"    | LC_ALL=C sort -u > "$WORK/gate.tok"
    comm -23 "$WORK/rawmode.tok" "$WORK/gate.tok" > "$WORK/glued.tok"
    GLUED_N=$(grep -c . "$WORK/glued.tok")
    GLUED_SAMPLE=$(LC_ALL=C grep -E '.{12,}' "$WORK/glued.tok" | head -3 | tr '\n' ' ' | sed 's/[[:space:]]*$//')
    info G6.11 "-raw extraction diverges: $GLUED_N token(s) exist only in -raw output (word gluing), e.g. ${GLUED_SAMPLE:-none} -- reported only, never gated"
else
    info G6.11 "-raw extraction produced no text, so divergence is not measurable -- reported only, never gated"
fi

# ---------------------------------------------------------------------------
# G6.12 -- Education binding, the third live defect. SCOPED to the Education
# region, and the scoping is mandatory rather than tidy.
#
# Measured: the EDU_INSTITUTION string occurs twice in today's extraction -- once
# on page 1 inside the Career Break block and once in the Education section. A
# whole-document ordering comparison would test the page-1 occurrence against the
# Education city line, conclude the institution comes first, and return a false
# PASS -- silently un-asserting one of the three defects this harness exists to
# name. Region scoping is what makes the ordering clause real.
#
# Two clauses: the institution line must precede the city line, and the date line
# must sit within EDU_BIND_WINDOW non-empty lines of the institution line. Either
# clause failing produces the single G6.12 FAIL.
# ---------------------------------------------------------------------------

EDU_HEAD=$(manifest_get EDU_HEADING)
EDU_INST=$(manifest_get EDU_INSTITUTION)
EDU_CITY=$(manifest_get EDU_CITY)
EDU_DATE=$(manifest_get EDU_DATE)
EDU_WINDOW=$(manifest_get EDU_BIND_WINDOW)
EDU_OWNER="Owner: Phase 2 (EXP-01 already edits Education; re-asserted by Phase 4 / PG2-03)"

EDU_REGION=$(section_region "$EDU_HEAD")
EDU_START=${EDU_REGION% *}
EDU_END=${EDU_REGION#* }

if [ "$EDU_START" = 0 ]; then
    result G6.12 FAIL "Education heading '$EDU_HEAD' does not extract as a whole line, so the Education binding cannot be scoped -- $EDU_OWNER"
else
    EDU_INST_AT=$(region_line_of "$EDU_START" "$EDU_END" "$EDU_INST")
    EDU_CITY_AT=$(region_line_of "$EDU_START" "$EDU_END" "$EDU_CITY")
    EDU_DATE_AT=$(region_line_of "$EDU_START" "$EDU_END" "$EDU_DATE")

    EDU_PROBLEMS=""
    if [ -z "$EDU_INST_AT" ] || [ -z "$EDU_CITY_AT" ] || [ -z "$EDU_DATE_AT" ]; then
        result G6.12 FAIL "Education binding unmeasurable inside the '$EDU_HEAD' region (gate lines $EDU_START-$EDU_END): institution='${EDU_INST_AT:-absent}' city='${EDU_CITY_AT:-absent}' date='${EDU_DATE_AT:-absent}' -- $EDU_OWNER"
    else
        if [ "$EDU_INST_AT" -gt "$EDU_CITY_AT" ]; then
            EDU_PROBLEMS="$EDU_PROBLEMS ordering: the city line '$EDU_CITY' (line $EDU_CITY_AT) extracts BEFORE the institution line '$EDU_INST' (line $EDU_INST_AT), so a parser reads the city as the school;"
        fi
        if [ "$EDU_INST_AT" -le "$EDU_DATE_AT" ]; then
            EDU_LO=$EDU_INST_AT; EDU_HI=$EDU_DATE_AT
        else
            EDU_LO=$EDU_DATE_AT; EDU_HI=$EDU_INST_AT
        fi
        EDU_SPAN=$(($(region_nonempty_count "$EDU_LO" "$EDU_HI") - 1))
        if [ "$EDU_SPAN" -gt "$EDU_WINDOW" ]; then
            EDU_PROBLEMS="$EDU_PROBLEMS window: the date line '$EDU_DATE' (line $EDU_DATE_AT) is $EDU_SPAN non-empty line(s) from the institution line (line $EDU_INST_AT), over EDU_BIND_WINDOW=$EDU_WINDOW;"
        fi
        if [ -z "$EDU_PROBLEMS" ]; then
            result G6.12 PASS "Education binding intact inside the '$EDU_HEAD' region (gate lines $EDU_START-$EDU_END): institution line $EDU_INST_AT precedes city line $EDU_CITY_AT, date line $EDU_DATE_AT is $EDU_SPAN non-empty line(s) away (window $EDU_WINDOW)"
        else
            result G6.12 FAIL "Education binding broken inside the '$EDU_HEAD' region (gate lines $EDU_START-$EDU_END) --$EDU_PROBLEMS reorder the \\resumeSubheading arguments at docs/main.tex:240-242. $EDU_OWNER"
        fi
    fi
fi

# ---------------------------------------------------------------------------
# G6.13 -- role-block adjacency. WARN and staying WARN: no requirement owns the
# fix, so a BLOCKER here would make 'make verify' permanently red and break every
# later phase's end-to-end criterion. That is also why the window below is a
# local constant rather than a manifest key -- promoting this assertion is the
# commit that would add the key.
# ---------------------------------------------------------------------------

ROLE_BIND_WINDOW=3
frozen_section '[titles]' > "$WORK/titles.txt"
frozen_section '[dates]'  > "$WORK/dates.txt"

ROLE_IDX=0
while IFS= read -r EMP; do
    [ -n "$EMP" ] || continue
    ROLE_IDX=$((ROLE_IDX + 1))
    ROLE_TITLE=$(sed -n "${ROLE_IDX}p" "$WORK/titles.txt")
    ROLE_DATE=$(sed -n "${ROLE_IDX}p" "$WORK/dates.txt")
    EMP_AT=$(gate_line_of "$EMP")
    TITLE_AT=$(gate_line_of "$ROLE_TITLE")
    DATE_AT=$(gate_line_of "$ROLE_DATE")
    if [ -z "$EMP_AT" ] || [ -z "$TITLE_AT" ] || [ -z "$DATE_AT" ]; then
        warn G6.13 "$(warn_owner G6.13)" "role block '$EMP': one of the employer/title/date lines does not extract as a whole line, so adjacency is unmeasurable"
        continue
    fi
    ROLE_LO=$EMP_AT
    ROLE_HI=$EMP_AT
    for AT in "$TITLE_AT" "$DATE_AT"; do
        if [ "$AT" -lt "$ROLE_LO" ]; then ROLE_LO=$AT; fi
        if [ "$AT" -gt "$ROLE_HI" ]; then ROLE_HI=$AT; fi
    done
    ROLE_SPAN=$((ROLE_HI - ROLE_LO))
    ROLE_NE=$(($(region_nonempty_count "$ROLE_LO" "$ROLE_HI") - 1))
    if [ "$ROLE_SPAN" -gt "$ROLE_BIND_WINDOW" ]; then
        ROLE_VERDICT="split across non-adjacent blocks"
    else
        ROLE_VERDICT="bound together"
    fi
    warn G6.13 "$(warn_owner G6.13)" "role block '$EMP' $ROLE_VERDICT: employer line $EMP_AT, title line $TITLE_AT, date line $DATE_AT -- line span $ROLE_SPAN against a window of $ROLE_BIND_WINDOW ($ROLE_NE non-empty line(s) apart)"
done < "$WORK/employers.txt"

# ---------------------------------------------------------------------------
# G6.14 -- Skills section length. Reuses the same region helper as G6.12 and
# exercises its terminal-section fallback, because the Skills heading is the last
# entry in SECTIONS. The manifest carries no dedicated SKILLS_HEADING key, so the
# heading is resolved by name out of SECTIONS (falling back to the final entry),
# which keeps a future rename a one-line manifest edit.
# ---------------------------------------------------------------------------

SKILLS_MAX=$(manifest_get SKILLS_MAX_LINES)
SKILLS_HEADING=$(manifest_list SECTIONS | LC_ALL=C grep -i -m1 'SKILLS')
if [ -z "$SKILLS_HEADING" ]; then
    SKILLS_HEADING=$(manifest_list SECTIONS | grep . | tail -1)
fi
SKILLS_REGION=$(section_region "$SKILLS_HEADING")
SKILLS_START=${SKILLS_REGION% *}
SKILLS_END=${SKILLS_REGION#* }
SKILLS_N=$(region_nonempty_count "$SKILLS_START" "$SKILLS_END")

if [ "$SKILLS_START" = 0 ]; then
    warn G6.14 "$(warn_owner G6.14)" "skills heading '$SKILLS_HEADING' does not extract as a whole line, so its rendered line count is unmeasurable (manifest SKILLS_MAX_LINES=$SKILLS_MAX)"
elif [ "$SKILLS_N" -gt "$SKILLS_MAX" ]; then
    warn G6.14 "$(warn_owner G6.14)" "'$SKILLS_HEADING' renders $SKILLS_N non-empty line(s) against a target of $SKILLS_MAX (manifest SKILLS_MAX_LINES; gate lines $SKILLS_START-$SKILLS_END)"
else
    warn G6.14 "$(warn_owner G6.14)" "'$SKILLS_HEADING' renders $SKILLS_N non-empty line(s), within the target of $SKILLS_MAX (manifest SKILLS_MAX_LINES; gate lines $SKILLS_START-$SKILLS_END)"
fi

# ---------------------------------------------------------------------------
# G6.15 -- invisible-text scan over the LaTeX source. Near-white colours are
# flagged on USAGE, never on definition: today's source defines a 92.3%-gray
# colour that is never applied anywhere, and a definition-based rule would fire a
# false BLOCKER on day one for a colour that renders nothing. The rule stays
# generic over near-white colours rather than naming today's single instance, and
# an unused definition is reported separately as INFO.
# ---------------------------------------------------------------------------

python3 - "$TEX" 2>"$WORK/invisible.err" <<'PY' > "$WORK/invisible.rows"
import re
import sys

tex_path = sys.argv[1]
source = open(tex_path, encoding='utf-8').read()

APPLY = (r'\\(?:text|page)?color\s*(?:\[[^\]]*\])?\{\s*%(n)s\s*\}'
         r'|\\f?colorbox\s*(?:\[[^\]]*\])?\{\s*%(n)s\s*\}')

hits = []
white = re.findall(APPLY % {'n': 'white'}, source)
if white:
    hits.append('white colour applied at %d call site(s)' % len(white))
phantom = re.findall(r'\\[hv]?phantom\b', source)
if phantom:
    hits.append('phantom construct x%d' % len(phantom))
negskip = re.findall(r'\\[hv]space\*\s*\{\s*-', source)
if negskip:
    hits.append('starred negative skip x%d' % len(negskip))

unused = []
for match in re.finditer(r'\\definecolor\{([^}]*)\}\{(HTML|gray)\}\{([^}]*)\}', source):
    name, model, value = match.group(1), match.group(2), match.group(3).strip()
    if model == 'HTML':
        if not re.match(r'^[0-9A-Fa-f]{6}$', value):
            continue
        red, green, blue = (int(value[i:i + 2], 16) for i in (0, 2, 4))
        luma = (0.299 * red + 0.587 * green + 0.114 * blue) / 255.0
        shown = '#%s' % value
    else:
        try:
            luma = float(value)
        except ValueError:
            continue
        shown = 'gray %s' % value
    if luma <= 0.9:
        continue
    if re.search(APPLY % {'n': re.escape(name)}, source):
        hits.append('near-white colour %s (%s, luma %.3f) applied at a call site' % (name, shown, luma))
    else:
        unused.append('%s (%s, luma %.3f)' % (name, shown, luma))

if hits:
    print('G6.15|FAIL|invisible-text construct(s) in %s: %s -- text hidden from a human reader must not ship'
          % (tex_path, '; '.join(hits)))
else:
    print('G6.15|PASS|no invisible-text construct in %s: no white colour applied, no phantom, '
          'no starred negative skip, no near-white colour used at a call site' % tex_path)

if unused:
    print('G6.15|INFO|near-white colour(s) defined but never applied: %s -- renders nothing today so it is '
          'not an invisible-text defect; Phase 6 / VIS-01 must use it or delete it' % ', '.join(unused))
PY
INVISIBLE_EC=$?
[ "$INVISIBLE_EC" -eq 0 ] || die_group G6.15 "invisible-text scan (G6.15)" "$INVISIBLE_EC" "$WORK/invisible.err"
emit_rows G6.15 "$WORK/invisible.rows"

# ---------------------------------------------------------------------------
# Human summary. Machine-readable RESULT lines come first; this block uses the
# repo's >> progress and !! error prefixes.
# ---------------------------------------------------------------------------

printf '>> Manifest: %s (pages=%s, page 2 opens with %s, %s sections)\n' \
    "$MANIFEST" "$(manifest_get PAGES)" "$(manifest_get PAGE2_OPENS_WITH)" \
    "$(manifest_list SECTIONS | grep -c .)"
printf '>> Honesty freeze: %s\n' "$FROZEN"
printf '>> Groups run: G0 preconditions, G1 page count, G2 page-1 boundary, G3 fill, G4 geometry freeze, G5 honesty freeze, G6 ATS text layer. G7-G8 land in Plan 03.\n'

if [ "$BLOCKERS" -eq 0 ]; then
    printf '>> PASS: 0 blocking failures.\n'
    exit 0
fi

printf '!! FAIL: %s blocking failure(s) in:%s\n' "$BLOCKERS" "$FAILED_IDS"
printf '!! The document is wrong. Every RESULT ... FAIL line above names its fix owner.\n'
exit 1
