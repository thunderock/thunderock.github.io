#!/usr/bin/env bash
# verify-phase3-regressions.sh -- standing content-regression net for Phase 3's
# own locked literals, none of which scripts/verify-resume.sh or
# scripts/verify-phase2-regressions.sh asserts.
#
# WHAT THIS NET ASSERTS. The harness gates page fit, the page-1 boundary, glyph
# hygiene, the honesty freeze and keyword PRESENCE. The Phase-2 net gates Phase
# 2's career-break removal and its locked descriptor literals. Neither says a
# word about any of the following, which is the whole defect this file fixes:
#
#   EXP-02a  the Adobe block's LEAD line opens in fault-tolerant / distributed
#            inference voice -- measured on the extracted lead line, not on the
#            document as a whole, because a topic heading further down must not
#            be what earns the anchor.
#   EXP-02b  the Training-Data Governance topic landed, carries its evidenced
#            figures, and is framed as fault-tolerant distributed systems in
#            Rust -- never as inference optimization (CODEBASE-EVIDENCE.md:12).
#   D-04     the fault-tolerance mechanisms are named inline where they occurred.
#   EXP-03   the torch.compile production claim landed, AND every keyword the
#            phase lands was PROMOTED in the same commit (moved out of
#            KEYWORDS_TARGET into KEYWORDS_REQUIRED with its ':phase' suffix
#            stripped). The harness's G6.6 calls warn unconditionally with no
#            branch on the count, so a commit that adds a target keyword and
#            forgets to promote it leaves the harness at exit 0: until this net
#            existed the promotion rule had zero machine backing.
#   EXP-04   the two unprovenanced figures are RETIRED -- the rendered EN DASH
#            form in the text layer AND the ASCII source form in docs/main.tex --
#            their evidenced replacements landed, and D-05's attribution rule
#            holds (no 'achiev*' anywhere: his module was BENCHMARKED ON the Ray
#            Data engine, he did not achieve anything with it).
#   EXP-07   the Flipkart closure clause landed.
#   EXP-08   the provisional cost/mentoring draft literals are ABSENT BY DEFAULT
#            -- asserted absent in the SOURCE as well as the text layer, so a
#            '%'-commented draft is caught too. They flip to assert_present only
#            on a recorded approval (D-14).
#
# WHY A SEPARATE FILE rather than new gates inside the harness. 02-02-PLAN.md
# criterion 11 pinned scripts/verify-resume.sh at 83 RESULT lines and 39 distinct
# IDs, and the harness's own G7/G8 self-test controls COUNT both numbers.
# Assertions added there would move figures a reviewed plan froze. This is the
# same reasoning scripts/verify-phase2-regressions.sh gives in its own header.
#
# Output contract, one line per assertion, stable order:
#   RESULT P3.<n> <PASS|FAIL> <human message>
# The P3. prefix cannot collide with the harness's G-series IDs or with the
# Phase-2 net's own sequential IDs, so all three streams can be concatenated and
# grepped together. Keeping the prefix distinct is a CORRECTNESS property, not
# cosmetics -- the Phase-2 header says so explicitly. IDs are sequential in
# emission order and the order is fixed by this file, so they are stable run to
# run and one run's output diffs cleanly against another's. Nothing in this file
# may contain the Phase-2 prefix literal: 03-01-PLAN.md Task 1 gates on a
# whole-file grep for it returning 0, which is the mechanical catch for a copy
# that renamed the counter but forgot the emit printf or the failed-ID append.
#
# Exit vocabulary, the same three-way split both siblings use:
#   0 = every assertion passed
#   1 = at least one assertion failed: the document regressed, OR a Phase-3
#       deliverable has not landed yet (see RED ON ARRIVAL below)
#   2 = cannot verify (missing tool, missing artifact, unreadable input) -- never
#       reported as a pass, and never conflated with "the document is wrong"
#
# RED ON ARRIVAL, by design. This net is written BEFORE the content it gates, so
# every later plan in Phase 3 is verified against it. Group 1 (retention) ships
# in the first commit and passes today. The new-content, retirement, promotion
# and draft-absence groups arrive in the next commit and are RED on the committed
# artifact on purpose: each FAIL message names the plan that owns the fix, so the
# FAIL census is an auditable contract that 03-04, 03-05 and 03-06 drive to zero.
# That red state is also the anti-tautology control for those classes -- an
# assertion never observed failing is not a gate (Phase 1's rule, STATE.md).
#
# WHY TWO TEXT STREAMS. pdftotext breaks a multi-word literal at whatever wrap
# point the renderer chose, so a raw whole-line grep for a phrase returns 0 on a
# perfectly correct document. Multi-word literals are therefore matched against a
# whitespace-SQUEEZED stream; whitespace-free short tokens are matched against the
# RAW lines as well, so the normalization can never be the thing that makes an
# assertion pass. The rule proves itself on one measured needle: 'millions every
# day' is x0 in the raw stream and x1 in the squeezed stream, because it wraps at
# "every / day". Assert what pdftotext EMITS, not what the source writes: the
# source's 'Llama~2~70B' extracts as 'Llama 2 70B', and its '10--50' extracts as
# the EN DASH form '10-50' (U+2013) -- which is why a retirement assertion needs
# BOTH the rendered form against the text layer and the ASCII form against the
# source.
#
# Written for bash 3.2.57, like both siblings: no arrays, no mapfile, no
# case-converting parameter expansion, no `local`, no double-bracket tests.
# /bin/bash on this machine is 3.2.57 while PATH bash is 5.x, so an idiom that
# works interactively can still break the gate. Temporaries are `_`-prefixed.
# Every grep runs under LC_ALL=C so U+2013 / U+00D7 / U+2192 match byte-exactly.
#
# This script is read-only: it never writes inside docs/ and never rebuilds.

# No errexit on purpose: every assertion must run and aggregate into FAILURES, so
# a single zero-count grep (which exits 1) may not abort the run. -u and pipefail
# still apply.
set -uo pipefail

# ---------------------------------------------------------------------------
# Defaults and environment fallbacks. Same variable names both siblings honour.
# ---------------------------------------------------------------------------

PDF="${VERIFY_PDF:-docs/AshutoshTiwari.pdf}"
TEX="${VERIFY_TEX:-docs/main.tex}"
FROZEN="docs/verify/baseline-frozen.txt"
MANIFEST="docs/verify/manifest.txt"
GATE_TEXT=""

FAILURES=0
FAILED_IDS=""
P3_SEQ=0
WORK=""

usage() {
    cat <<'USAGE'
Usage: verify-phase3-regressions.sh [options]

Standing content-regression net for Phase 3's locked literals: the Adobe lead-line
voice (EXP-02a), the Training-Data Governance topic and its honest framing
(EXP-02b), the D-04 fault-tolerance mechanisms, the torch.compile claim plus the
keyword-promotion pairing (EXP-03), the EXP-04 retirement/replacement set and the
D-05 attribution rule, the EXP-07 Flipkart closure, and the EXP-08 draft literals
that must stay ABSENT until a recorded approval. Prints one
"RESULT P3.<n> <PASS|FAIL> <message>" line per assertion and exits 0 (all
passed), 1 (a regression, or a Phase-3 deliverable has not landed yet), or 2
(cannot verify).

Options:
  --pdf PATH        PDF under test            (default docs/AshutoshTiwari.pdf)
  --tex PATH        LaTeX source              (default docs/main.tex)
  --frozen PATH     Honesty freeze, read as a (default docs/verify/baseline-frozen.txt)
                    precondition only
  --manifest PATH   Verification manifest,    (default docs/verify/manifest.txt)
                    read as DATA by the
                    keyword-promotion pairing
                    assertions, and the input
                    a promotion negative
                    control varies
  --gate-text FILE  Read the extracted text layer from FILE instead of running
                    pdftotext over --pdf. For a negative control over a crafted
                    fixture ONLY: a run carrying this flag proves nothing about
                    the committed artifact, and it says so on stdout. No build
                    target may pass it.
  -h, --help        Show this help and exit 0

Environment:
  VERIFY_PDF, VERIFY_TEX   Path fallbacks for --pdf / --tex
  VERIFY_TMPDIR            Parent directory for the scratch workspace

This script is read-only. It never writes inside docs/ and never rebuilds the
artifact under test.
USAGE
    return 0
}

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

while [ $# -gt 0 ]; do
    case "$1" in
        --pdf)       [ $# -ge 2 ] || { printf '!! --pdf needs a PATH\n' >&2; exit 2; }; PDF="$2"; shift 2 ;;
        --tex)       [ $# -ge 2 ] || { printf '!! --tex needs a PATH\n' >&2; exit 2; }; TEX="$2"; shift 2 ;;
        --frozen)    [ $# -ge 2 ] || { printf '!! --frozen needs a PATH\n' >&2; exit 2; }; FROZEN="$2"; shift 2 ;;
        --manifest)  [ $# -ge 2 ] || { printf '!! --manifest needs a PATH\n' >&2; exit 2; }; MANIFEST="$2"; shift 2 ;;
        --gate-text) [ $# -ge 2 ] || { printf '!! --gate-text needs a FILE\n' >&2; exit 2; }; GATE_TEXT="$2"; shift 2 ;;
        -h|--help)   usage; exit 0 ;;
        *)           printf '!! unknown option: %s (try --help)\n' "$1" >&2; exit 2 ;;
    esac
done

# ---------------------------------------------------------------------------
# Emitters. FAIL is the only status that moves the exit code. Each returns 0 so
# it can never abort a caller under pipefail.
#
# emit() mutates FAILURES, FAILED_IDS and P3_SEQ, so it must only ever be called
# from the current shell -- never from inside a pipeline or a command
# substitution, where the increments would be lost in a subshell. Every loop
# below therefore feeds `while read` from a redirect or a here-doc, never a pipe.
# ---------------------------------------------------------------------------

emit() {  # emit <PASS|FAIL> <message>
    P3_SEQ=$((P3_SEQ + 1))
    printf 'RESULT %-6s %-5s %s\n' "P3.$P3_SEQ" "$1" "$2"
    if [ "$1" = FAIL ]; then
        FAILURES=$((FAILURES + 1))
        FAILED_IDS="$FAILED_IDS P3.$P3_SEQ"
    fi
    return 0
}

# die2 <message> -- "cannot verify", exit 2. Deliberately emits no RESULT line:
# a group that could not RUN is UNKNOWN, and UNKNOWN is never a pass.
die2() {
    printf '!! %s\n' "$1" >&2
    exit 2
}

# gcount <grep-flags> <needle> <file> -- fixed-string count as an integer.
#
# The normalization is load-bearing, not defensive. `grep -Fc` exits 1 on zero
# matches but still prints "0", which is a real measurement. A MISSING or
# unreadable file prints NOTHING, and an empty string fed to `[ -eq ]` makes the
# test error out and return 2 -- which, with no errexit, would sail past as
# neither PASS nor FAIL. An unusable measurement becomes the sentinel -1 instead,
# and every caller reports that as FAIL/unmeasurable.
gcount() {
    _gc=$(LC_ALL=C grep "$1" -- "$2" "$3" 2>/dev/null)
    case "$_gc" in
        ''|*[!0-9]*) printf '%s\n' '-1' ;;
        *)           printf '%s\n' "$_gc" ;;
    esac
    return 0
}

# display_of <path> -- a stable human label for one of the input streams. The two
# text streams live under a mktemp scratch directory, so printing their paths
# verbatim would make every RESULT line differ between runs and defeat diffing
# one run's output against another's. The MANIFEST arm exists for the same
# reason: a promotion negative control points --manifest at a scratch copy, and
# the RESULT text must stay identical to the default run's.
display_of() {
    case "$1" in
        "${GATE:-}")     printf '%s\n' 'the extracted text layer' ;;
        "${SQUEEZED:-}") printf '%s\n' 'the whitespace-squeezed text layer' ;;
        "${MANIFEST:-}") printf '%s\n' 'the verification manifest' ;;
        *)               printf '%s\n' "$1" ;;
    esac
    return 0
}

# assert_present <label> <needle> <file> -- the fixed string must appear at least
# once. Used for retained true claims, for the phase's new evidenced figures, and
# for the keywords the phase lands.
assert_present() {
    _ap=$(gcount -Fc "$2" "$3")
    _apd=$(display_of "$3")
    if [ "$_ap" -ge 1 ]; then
        emit PASS "$1: '$2' present ($_ap match(es)) in $_apd"
    elif [ "$_ap" -eq 0 ]; then
        emit FAIL "$1: '$2' is ABSENT from $_apd -- either the owning plan has not landed this content yet, or locked content was shortened, merged or dropped. Restore the literal verbatim; do not relax this assertion and do not substitute a synonym (03-01-PLAN.md <locked_literals>)"
    else
        emit FAIL "$1: '$2' could not be measured against $_apd (unreadable or missing input) -- the verdict is UNKNOWN, which is never a pass"
    fi
    return 0
}

# assert_present_i <label> <needle> <file> -- case-insensitive variant. Needed
# where a phrase may legitimately render sentence-initial or title-cased, so
# casing is not part of the claim being asserted.
#
# First caller lands with Group 2 in the next commit of this plan; defined now so
# the whole helper set is reviewable in one place, per 03-01-PLAN.md Task 1.
# shellcheck disable=SC2329
assert_present_i() {
    _api=$(gcount -Fic "$2" "$3")
    _apid=$(display_of "$3")
    if [ "$_api" -ge 1 ]; then
        emit PASS "$1: '$2' present case-insensitively ($_api match(es)) in $_apid"
    elif [ "$_api" -eq 0 ]; then
        emit FAIL "$1: '$2' is ABSENT from $_apid even case-insensitively -- the owning plan has not landed this wording. Restore it; do not relax this assertion (03-01-PLAN.md <locked_literals>)"
    else
        emit FAIL "$1: '$2' could not be measured against $_apid (unreadable or missing input) -- the verdict is UNKNOWN, which is never a pass"
    fi
    return 0
}

# assert_absent <label> <needle> <file> <remedy> -- the fixed string must not
# appear at all. Used for the retired EXP-04 figures (both text streams AND the
# source) and for the EXP-08 draft literals that stay absent until approved.
#
# First caller lands with Group 6 in the next commit of this plan.
# shellcheck disable=SC2329
assert_absent() {
    _aa=$(gcount -Fc "$2" "$3")
    _aad=$(display_of "$3")
    if [ "$_aa" -eq 0 ]; then
        emit PASS "$1: '$2' is absent from $_aad (count 0)"
    elif [ "$_aa" -ge 1 ]; then
        emit FAIL "$1: '$2' appears $_aa time(s) in $_aad -- want 0. $4"
    else
        emit FAIL "$1: '$2' could not be measured against $_aad (unreadable or missing input) -- the verdict is UNKNOWN, which is never a pass"
    fi
    return 0
}

# assert_whole_line_once <label> <needle> <file> <remedy> -- exactly one whole
# extracted line equals the needle. Whole-line (-Fx) and exact-count (== 1) for
# the same two reasons the honesty freeze uses them: a substring test cannot tell
# a real line from a longer one containing it, and an at-least-one test cannot
# detect a duplicate.
#
# The `${4:-...}` default is a FIX, not a style choice (03-PATTERNS.md T-1). The
# Phase-2 net documents this helper as 3-arg but its FAIL branch dereferences
# $4, so under /bin/bash 3.2.57 with `set -u` a 3-arg call whose assertion FAILS
# aborts the whole script with an unbound-variable error: no RESULT line, no
# FAILURES increment, every remaining assertion skipped -- while exiting 1, which
# reads in a log as "the document is wrong" rather than "the net stopped
# running". Reproduced live. The default makes the failure mode impossible; the
# signature is documented as 4-arg here, which is what it always was.
#
# Kept from the template so the T-1 fix travels with the copy even before a P3
# clause needs a whole-line count -- T-1 is invisible until the day it fires.
# shellcheck disable=SC2329
assert_whole_line_once() {
    _awl=$(gcount -Fxc "$2" "$3")
    _awld=$(display_of "$3")
    if [ "$_awl" -eq 1 ]; then
        emit PASS "$1: '$2' appears exactly once as a whole extracted line in $_awld"
    elif [ "$_awl" -lt 0 ]; then
        emit FAIL "$1: '$2' could not be measured against $_awld (unreadable or missing input) -- the verdict is UNKNOWN, which is never a pass"
    else
        emit FAIL "$1: '$2' appears $_awl time(s) as a whole extracted line in $_awld (want exactly 1) -- ${4:-see the locked-literal table in .planning/phases/03-adobe-rebuild-staff-signal-bullets/03-01-PLAN.md}"
    fi
    return 0
}

# assert_promoted <label> <literal> -- the keyword-promotion pairing rule, all
# three conjuncts resolved into ONE verdict (03-RESEARCH.md E-5):
#
#   1. the literal is present in the extracted text layer ($GATE, fixed string)
#   2. it is a WHOLE pipe-field of KEYWORDS_REQUIRED -- pipes translated to
#      newlines, then matched whole-line fixed. Whole-field, never substring:
#      a substring test would let 'A100' pass on an 'A100-40GB' field, which is
#      the same reasoning assert_whole_line_once gives for whole-line matching.
#   3. no KEYWORDS_TARGET field still begins with "<literal>:" -- the ':phase'
#      suffix must be STRIPPED on promotion, because a suffix-intact promotion
#      makes the harness's G6.5 grep the text layer for 'torch.compile:3' and
#      FAIL, and a keyword left in both tiers is counted twice.
#
# The FAIL message names WHICH conjunct failed, because the three have different
# remedies. Nothing here is measurable from the text layer alone: this is the
# only assertion in the net that reads the verification manifest as DATA to
# cross-check rather than as configuration, which is why --manifest exists.
#
# First caller lands with Group 5 in the next commit of this plan.
# shellcheck disable=SC2329
assert_promoted() {
    _apr_gate=$(gcount -Fc "$2" "$GATE")
    if [ -s "$WORK/kw-required.txt" ]; then
        _apr_req=$(gcount -Fxc "$2" "$WORK/kw-required.txt")
    else
        _apr_req=-1
    fi
    _apr_sfx=''
    while IFS= read -r _apr_f; do
        [ -n "$_apr_f" ] || continue
        case "$_apr_f" in
            "$2":*) _apr_sfx="$_apr_sfx '$_apr_f'" ;;
        esac
    done < "$WORK/kw-target.txt"
    _apr_md=$(display_of "$MANIFEST")

    if [ "$_apr_gate" -lt 0 ] || [ "$_apr_req" -lt 0 ]; then
        emit FAIL "$1: the promotion pairing for '$2' could not be measured (unreadable text layer, or $_apr_md carries no KEYWORDS_REQUIRED key) -- the verdict is UNKNOWN, which is never a pass"
    elif [ "$_apr_gate" -eq 0 ]; then
        emit FAIL "$1: conjunct 1 FAILS -- '$2' is ABSENT from the extracted text layer, so there is nothing to promote yet. Land the keyword in docs/main.tex and move it from KEYWORDS_TARGET to KEYWORDS_REQUIRED in the SAME commit, ':phase' suffix stripped"
    elif [ "$_apr_req" -ne 1 ]; then
        emit FAIL "$1: conjunct 2 FAILS -- '$2' is in the extracted text layer ($_apr_gate match(es)) but appears $_apr_req time(s) as a WHOLE pipe-field of KEYWORDS_REQUIRED in $_apr_md (want exactly 1). Promote it in the SAME commit that adds the keyword, ':phase' suffix stripped -- a suffix-intact promotion makes the harness's G6.5 grep the text layer for '$2:<phase>' and FAIL"
    elif [ -n "$_apr_sfx" ]; then
        emit FAIL "$1: conjunct 3 FAILS -- '$2' is promoted into KEYWORDS_REQUIRED but KEYWORDS_TARGET still carries$_apr_sfx in $_apr_md. Remove the target entry in the same commit: a keyword left in both tiers is counted twice, and its ':phase' suffix still wins over WARN_OWNERS"
    else
        emit PASS "$1: '$2' is present in the extracted text layer ($_apr_gate match(es)), is a whole pipe-field of KEYWORDS_REQUIRED, and no KEYWORDS_TARGET field is left carrying a '$2:' prefix"
    fi
    return 0
}

# gate_line_of <string> -- first line number in the gate stream whose WHOLE
# content equals <string>, or empty when absent.
#
# First caller lands with Group 2 in the next commit of this plan.
# shellcheck disable=SC2329
gate_line_of() {
    LC_ALL=C grep -n -Fx -m1 -- "$1" "$WORK/gate.txt" 2>/dev/null | cut -d: -f1
    return 0
}

# region_line_of <start> <end> <string> -- absolute gate line number of the first
# whole-line match INSIDE the inclusive range, or empty. An inverted or empty
# range yields empty.
#
# First caller lands with Group 3 in the next commit of this plan.
# shellcheck disable=SC2329
region_line_of() {
    if [ "$1" -lt 1 ] || [ "$1" -gt "$2" ]; then
        return 0
    fi
    _rl=$(sed -n "$1,$2p" "$WORK/gate.txt" | LC_ALL=C grep -n -Fx -m1 -- "$3" | cut -d: -f1)
    if [ -n "$_rl" ]; then
        printf '%s\n' "$(($1 + _rl - 1))"
    fi
    return 0
}

# region_first_nonempty <start> <end> -- the absolute gate.txt line number of the
# first non-blank line inside the range, or empty. Ported from
# scripts/verify-resume.sh:405-414, where it is what lets G6.12's ordering clause
# be ANCHOR-FREE. Phase 3 needs the same property for a different reason: "the
# Adobe block's OPENING line" is a property of the region, so it needs no second
# needle to compare against -- and a needle that went absent would degrade into
# grep -Fx on the empty string, which matches the region's first BLANK line.
#
# The leading `case` is the guard a SECOND caller needs (NT-02): the ported
# original is only ever reached with numbers a resolved heading produced, but
# here `start` is derived from an anchor lookup that can come back EMPTY, and an
# empty or non-numeric operand reaching `[ -lt ]` errors out and returns 2 --
# which, with no errexit, would sail past as neither PASS nor FAIL. Bailing to
# "no line" here makes the caller's unmeasurable branch fire instead.
#
# First caller lands with Group 2 in the next commit of this plan.
# shellcheck disable=SC2329
region_first_nonempty() {
    case "$1$2" in
        ''|*[!0-9]*) return 0 ;;
    esac
    if [ "$1" -lt 1 ] || [ "$1" -gt "$2" ]; then
        return 0
    fi
    _rfn=$(sed -n "$1,$2p" "$WORK/gate.txt" | LC_ALL=C grep -n -m1 '[^[:space:]]' | cut -d: -f1)
    if [ -n "$_rfn" ]; then
        printf '%s\n' "$(($1 + _rfn - 1))"
    fi
    return 0
}

# ---------------------------------------------------------------------------
# Preconditions. Every one of these is "cannot verify" (exit 2), never a FAIL:
# an absent tool or artifact says nothing about whether the document regressed.
# ---------------------------------------------------------------------------

if [ -z "$GATE_TEXT" ]; then
    command -v pdftotext >/dev/null 2>&1 \
        || die2 "required tool not on PATH: pdftotext -- install the poppler binaries with 'brew install poppler'"
    [ -f "$PDF" ] && [ -s "$PDF" ] \
        || die2 "PDF missing or empty: $PDF -> run 'make build'"
else
    [ -f "$GATE_TEXT" ] && [ -s "$GATE_TEXT" ] \
        || die2 "gate-text fixture missing or empty: $GATE_TEXT"
fi

[ -f "$TEX" ] && [ -s "$TEX" ] || die2 "LaTeX source missing or empty: $TEX"
[ -f "$FROZEN" ] && [ -s "$FROZEN" ] || die2 "honesty freeze missing or empty: $FROZEN"
[ -f "$MANIFEST" ] && [ -s "$MANIFEST" ] || die2 "verification manifest missing or empty: $MANIFEST"

# The honesty freeze is a PRECONDITION only here, deliberately: nothing in
# D-01..D-15 changes a frozen date, title, employer or geometry value
# (03-PATTERNS.md section 6 lists the freeze as immutable this phase), so no
# section of it is extracted and no P3 assertion reads it. The flag and the
# readability check are kept so a future P3 clause has the stream available and
# so a run against a broken freeze reports "cannot verify" rather than passing.

# Scratch workspace: always from mktemp -d, never from user input, and removed
# only after proving the variable is non-empty and is a directory. Nothing is
# ever written under docs/. The cleanup is an inline single-quoted trap rather
# than a function so it expands at signal time, not now.
if [ -n "${VERIFY_TMPDIR:-}" ]; then
    WORK=$(mktemp -d "${VERIFY_TMPDIR%/}/verify-phase3.XXXXXX") || die2 "cannot create scratch dir under $VERIFY_TMPDIR"
else
    WORK=$(mktemp -d) || die2 "cannot create scratch dir"
fi
trap 'if [ -n "${WORK:-}" ] && [ -d "${WORK:-}" ]; then rm -rf "$WORK"; fi' EXIT

# ---------------------------------------------------------------------------
# The two text streams.
#
# gate.txt is the repo's pinned extraction convention: pdftotext default mode,
# form feeds translated to newlines. The translation is not cosmetic -- without
# it the page-1 form feed is glued to the first token of page 2 and whole-line
# matches near the page boundary silently return 0.
#
# squeezed.txt is the whole text layer as ONE whitespace-normalized line, so a
# multi-word literal that pdftotext broke across a wrap point still matches.
# ---------------------------------------------------------------------------

if [ -z "$GATE_TEXT" ]; then
    pdftotext "$PDF" "$WORK/raw.txt" 2>/dev/null \
        || die2 "pdftotext failed to extract a text layer from $PDF"
else
    cp "$GATE_TEXT" "$WORK/raw.txt" 2>/dev/null \
        || die2 "cannot read the gate-text fixture: $GATE_TEXT"
fi

tr '\f' '\n' < "$WORK/raw.txt" > "$WORK/gate.txt" || die2 "form-feed normalization failed"
[ -s "$WORK/gate.txt" ] || die2 "the extracted text layer is empty -- refusing to report a verdict measured against nothing"
tr -s ' \t\n' ' ' < "$WORK/gate.txt" > "$WORK/squeezed.txt" || die2 "whitespace normalization failed"
[ -s "$WORK/squeezed.txt" ] || die2 "the whitespace-squeezed text layer is empty -- refusing to report a verdict measured against nothing"

GATE="$WORK/gate.txt"
SQUEEZED="$WORK/squeezed.txt"

# The two keyword tiers, split into one field per line so conjuncts 2 and 3 can
# match WHOLE fields. Read line-wise and never sourced or eval'd, so a value
# containing shell metacharacters stays inert data. A trailing "# annotation" is
# stripped the way the harness's manifest_get strips it; an absent key yields an
# empty file, which assert_promoted reports as unmeasurable rather than as "not
# promoted" -- a missing key is a broken manifest, not a document regression.
LC_ALL=C grep '^KEYWORDS_REQUIRED=' "$MANIFEST" 2>/dev/null \
    | sed -e 's/^KEYWORDS_REQUIRED=//' -e 's/[[:space:]]*#.*$//' -e 's/[[:space:]]*$//' \
    | tr '|' '\n' > "$WORK/kw-required.txt"
LC_ALL=C grep '^KEYWORDS_TARGET=' "$MANIFEST" 2>/dev/null \
    | sed -e 's/^KEYWORDS_TARGET=//' -e 's/[[:space:]]*#.*$//' -e 's/[[:space:]]*$//' \
    | tr '|' '\n' > "$WORK/kw-target.txt"

printf '>> Inputs: pdf=%s tex=%s frozen=%s manifest=%s\n' "$PDF" "$TEX" "$FROZEN" "$MANIFEST"
if [ -n "$GATE_TEXT" ]; then
    printf '>> NOTE: the text layer was read from the fixture %s, NOT extracted from %s. This run does NOT certify the committed artifact.\n' "$GATE_TEXT" "$PDF"
fi

# ---------------------------------------------------------------------------
# GROUP 1 -- Class C retention guards (EXP-02c). These all PASS today and must
# stay green forever: they are the true claims Phase 3 is REVISING AROUND, not
# replacing. 03-RESEARCH.md Pitfall 12 names rebuilding from CODEBASE-EVIDENCE.md
# alone as this phase's signature failure -- anything the evidence file does not
# restate looks like it was never there. Falcon-40B, Llama 2 70B,
# Source -> Transform -> Sink and KEDA-on-SQS-depth are unverified-BY-THAT-PASS,
# not false, and D-03 mandates retain-and-revise. These assertions are what makes
# "retain" checkable instead of a hope.
#
# Every label carries its requirement and its owning plan (form
# "EXP-02c/03-01 retained true claim") so a FAIL census is readable without
# opening a plan file. Group 1's owner is this plan because it is already green:
# a Group 1 FAIL means a LATER plan deleted something it was supposed to keep,
# and the remedy is to restore it, never to relax the assertion.
# ---------------------------------------------------------------------------

# Multi-word literals against the whitespace-squeezed stream: pdftotext breaks
# every one of these at whatever wrap point the renderer chose. Fed from a
# here-doc rather than a pipe, because emit mutates FAILURES in the current shell
# and a subshell would lose the increment.
while IFS= read -r LIT; do
    [ -n "$LIT" ] || continue
    assert_present "EXP-02c/03-01 retained true claim (whitespace-squeezed text layer)" "$LIT" "$SQUEEZED"
done <<'LITERALS'
Falcon-40B
Llama 2 70B
SQS queue depth
Flash Attention
FSDP
Rust
fault isolation across clusters
backpressure-aware scheduling
sustained low P99
18M+
4Bn rows
10K QPS
first workflow at Flipkart
validations
LITERALS

# The whitespace-FREE subset again, against the RAW extracted lines, so the
# squeeze can never be the thing that makes an assertion pass: each must be
# readable on a single extracted line, which is what a text-only parser sees.
#
# Honest scope note so a later reader does not over-trust these five. None
# contains whitespace, and squeezing newlines into spaces can neither create nor
# destroy a match for a whitespace-free needle -- so for any given document the
# raw and squeezed verdicts on these five are logically EQUIVALENT. They guard
# the tr pipeline itself, not the document. Kept because the Phase-2 net
# established the two-stream check as the house pattern and because they cost
# nothing.
while IFS= read -r TOK; do
    [ -n "$TOK" ] || continue
    assert_present "EXP-02c/03-01 retained true claim (raw extracted lines, normalization-proof)" "$TOK" "$GATE"
done <<'TOKENS'
Falcon-40B
FSDP
Rust
18M+
validations
TOKENS

# The dual-stream rule proving itself on a measured needle. 'millions every day'
# is x0 in the RAW stream and x1 in the SQUEEZED stream (measured 2026-08-22
# against the committed artifact) because the renderer wraps it at "every /
# day". Asserted against the squeezed stream ONLY: a raw assertion here would
# FAIL on a perfectly correct document, which is exactly the false alarm the
# two-stream convention exists to prevent. If a later reflow ever puts the
# phrase on one raw line this assertion still passes -- squeezing cannot destroy
# a match.
assert_present "EXP-02c/03-01 retained true claim (whitespace-squeezed text layer; wraps at 'every / day', so the raw stream legitimately has 0)" \
    'millions every day' "$SQUEEZED"

# ---------------------------------------------------------------------------
# Human summary. Machine-readable RESULT lines come first; this block uses the
# repo's >> progress and !! error prefixes.
# ---------------------------------------------------------------------------

printf '>> Groups run: 1 EXP-02c retention guards. Content only -- freshness is the harness G0.3.\n'

if [ "$FAILURES" -eq 0 ]; then
    printf '>> PASS: %s Phase-3 regression assertion(s), 0 failures.\n' "$P3_SEQ"
    exit 0
fi

printf '!! FAIL: %s of %s Phase-3 regression assertion(s) failed:%s\n' "$FAILURES" "$P3_SEQ" "$FAILED_IDS"
printf '!! Every RESULT ... FAIL line above names its owning plan and its remedy.\n'
exit 1
