#!/usr/bin/env bash
# verify-phase2-regressions.sh -- standing regression net for the two Phase 2
# invariants that no assertion in scripts/verify-resume.sh covers.
#
# Both invariants HELD when Phase 2 closed, but they were proven by one-time
# greps inside plan execution, not by anything a later phase re-runs. Nothing
# re-running is the whole defect this file fixes.
#
#   EXP-01a (02-01 Task 2)  the career-break entry is gone from source and text
#                           layer, Work Experience runs ADOBE FIREFLY -> SWIGGY
#                           with no employer between, and the master's dates
#                           still extract from Education.
#   EXP-05b (02-01 Task 3)  every locked D-05/D-06 descriptor literal survives in
#                           the text layer. ROADMAP Phase 5 criterion 4 rests on
#                           the C++/Network-on-Chip anchor living in the NetSpeed
#                           descriptor, so losing it has to be a BLOCKER here,
#                           not a silent diff three phases later.
#
# Deliberately a SEPARATE script rather than new gates inside the harness: the
# harness's own controls count its RESULT lines (83) and its distinct IDs (39),
# and 02-02-PLAN.md criterion 11 pins both, so assertions added there would move
# numbers a reviewed plan froze. docs/verify/{manifest,baseline-frozen}.txt are
# likewise out of bounds under this phase's threat model (T-02-02, T-02-10), so
# the literal sets below live here.
#
# Output contract, one line per assertion, stable order:
#   RESULT P2.<n> <PASS|FAIL> <human message>
# The P2. prefix cannot collide with the harness's G-series IDs, so the two
# streams can be concatenated and grepped together. IDs are sequential in
# emission order; the order is fixed by this file, so it is stable run to run.
#
# Exit vocabulary, the same three-way split scripts/verify-resume.sh uses:
#   0 = every assertion passed
#   1 = at least one assertion failed (the document regressed)
#   2 = cannot verify (missing tool, missing artifact, unreadable input) -- never
#       reported as a pass, and never conflated with "the document is wrong"
#
# This net asserts CONTENT only. It does not re-prove that the PDF was built from
# the current source; that is the harness's G0.3, and this script reads whatever
# artifact is on disk. Run both.
#
# Why two text streams. Both folded descriptors render on TWO lines (measured:
# 02-01-SUMMARY.md "Rendered wrap points"), so pdftotext breaks every multi-word
# literal mid-phrase -- a raw whole-line grep for 'live in every Groupon country'
# returns 0 on a perfectly correct document. Multi-word literals are therefore
# matched against a whitespace-squeezed stream. The five SHORT tokens are then
# matched against the RAW lines as well, so the normalization can never be the
# thing that makes an assertion pass (02-01-SUMMARY.md patterns-established).
#
# Written for bash 3.2.57, like the harness: no associative arrays, no mapfile,
# no case-converting parameter expansion, no `local`. Temporaries are
# `_`-prefixed. Every grep runs under LC_ALL=C so the UTF-8 EN DASH inside the
# frozen date matches byte-exactly.

# No errexit on purpose: every assertion must run and aggregate into FAILURES, so
# a single zero-count grep (which exits 1) may not abort the run. -u and pipefail
# still apply.
set -uo pipefail

# ---------------------------------------------------------------------------
# Defaults and environment fallbacks. Same variable names the harness honours.
# ---------------------------------------------------------------------------

PDF="${VERIFY_PDF:-docs/AshutoshTiwari.pdf}"
TEX="${VERIFY_TEX:-docs/main.tex}"
FROZEN="docs/verify/baseline-frozen.txt"
GATE_TEXT=""

FAILURES=0
FAILED_IDS=""
P2_SEQ=0
WORK=""

usage() {
    cat <<'USAGE'
Usage: verify-phase2-regressions.sh [options]

Standing regression net for the two Phase 2 invariants (EXP-01a career-break
removal, EXP-05b locked descriptor literals) that scripts/verify-resume.sh does
not assert. Prints one "RESULT P2.<n> <PASS|FAIL> <message>" line per assertion
and exits 0 (all passed), 1 (a regression), or 2 (cannot verify).

Options:
  --pdf PATH        PDF under test            (default docs/AshutoshTiwari.pdf)
  --tex PATH        LaTeX source              (default docs/main.tex)
  --frozen PATH     Honesty freeze, read for  (default docs/verify/baseline-frozen.txt)
                    its [employers] section
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
        --gate-text) [ $# -ge 2 ] || { printf '!! --gate-text needs a FILE\n' >&2; exit 2; }; GATE_TEXT="$2"; shift 2 ;;
        -h|--help)   usage; exit 0 ;;
        *)           printf '!! unknown option: %s (try --help)\n' "$1" >&2; exit 2 ;;
    esac
done

# ---------------------------------------------------------------------------
# Emitters. FAIL is the only status that moves the exit code. Each returns 0 so
# it can never abort a caller under pipefail.
#
# emit() mutates FAILURES, FAILED_IDS and P2_SEQ, so it must only ever be called
# from the current shell -- never from inside a pipeline or a command
# substitution, where the increments would be lost in a subshell. Every loop
# below therefore feeds `while read` from a redirect or a here-doc, never a pipe.
# ---------------------------------------------------------------------------

emit() {  # emit <PASS|FAIL> <message>
    P2_SEQ=$((P2_SEQ + 1))
    printf 'RESULT %-6s %-5s %s\n' "P2.$P2_SEQ" "$1" "$2"
    if [ "$1" = FAIL ]; then
        FAILURES=$((FAILURES + 1))
        FAILED_IDS="$FAILED_IDS P2.$P2_SEQ"
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
# one run's output against another's.
display_of() {
    case "$1" in
        "${GATE:-}")     printf '%s\n' 'the extracted text layer' ;;
        "${SQUEEZED:-}") printf '%s\n' 'the whitespace-squeezed text layer' ;;
        *)               printf '%s\n' "$1" ;;
    esac
    return 0
}

# assert_present <label> <needle> <file> -- the fixed string must appear at least
# once. Used for the locked descriptor literals: their absence is the regression.
assert_present() {
    _ap=$(gcount -Fc "$2" "$3")
    _apd=$(display_of "$3")
    if [ "$_ap" -ge 1 ]; then
        emit PASS "$1: '$2' present ($_ap match(es)) in $_apd"
    elif [ "$_ap" -eq 0 ]; then
        emit FAIL "$1: '$2' is ABSENT from $_apd -- locked content was shortened, merged or dropped. Restore the literal in the descriptor; do not relax this assertion (02-01-PLAN.md Task 3, D-05/D-06)"
    else
        emit FAIL "$1: '$2' could not be measured against $_apd (unreadable or missing input) -- the verdict is UNKNOWN, which is never a pass"
    fi
    return 0
}

# assert_present_i <label> <needle> <file> -- case-insensitive variant, needed
# only where the phrase is sentence-initial in the shipped descriptor.
assert_present_i() {
    _api=$(gcount -Fic "$2" "$3")
    _apid=$(display_of "$3")
    if [ "$_api" -ge 1 ]; then
        emit PASS "$1: '$2' present case-insensitively ($_api match(es)) in $_apid"
    elif [ "$_api" -eq 0 ]; then
        emit FAIL "$1: '$2' is ABSENT from $_apid even case-insensitively -- locked content was dropped. Restore it; do not relax this assertion (02-01-PLAN.md Task 3, D-05)"
    else
        emit FAIL "$1: '$2' could not be measured against $_apid (unreadable or missing input) -- the verdict is UNKNOWN, which is never a pass"
    fi
    return 0
}

# assert_absent <label> <needle> <file> <remedy> -- the fixed string must not
# appear at all. Used for the deleted career-break row and for the two forbidden
# ladder rungs 02-01-PLAN.md Task 3 names as scope reductions.
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

# assert_whole_line_once <label> <needle> <file> -- exactly one whole extracted
# line equals the needle. Whole-line (-Fx) and exact-count (== 1) for the same
# two reasons the honesty freeze uses them: a substring test cannot tell a real
# line from a longer one containing it, and an at-least-one test cannot detect a
# duplicate.
assert_whole_line_once() {
    _awl=$(gcount -Fxc "$2" "$3")
    _awld=$(display_of "$3")
    if [ "$_awl" -eq 1 ]; then
        emit PASS "$1: '$2' appears exactly once as a whole extracted line in $_awld"
    elif [ "$_awl" -lt 0 ]; then
        emit FAIL "$1: '$2' could not be measured against $_awld (unreadable or missing input) -- the verdict is UNKNOWN, which is never a pass"
    else
        emit FAIL "$1: '$2' appears $_awl time(s) as a whole extracted line in $_awld (want exactly 1) -- $4"
    fi
    return 0
}

# gate_line_of <string> -- first line number in the gate stream whose WHOLE
# content equals <string>, or empty when absent.
gate_line_of() {
    LC_ALL=C grep -n -Fx -m1 -- "$1" "$WORK/gate.txt" 2>/dev/null | cut -d: -f1
    return 0
}

# region_line_of <start> <end> <string> -- absolute gate line number of the first
# whole-line match INSIDE the inclusive range, or empty. An inverted or empty
# range yields empty, which the adjacency clause reads as "nothing between".
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

# Scratch workspace: always from mktemp -d, never from user input, and removed
# only after proving the variable is non-empty and is a directory. Nothing is
# ever written under docs/. The cleanup is an inline single-quoted trap rather
# than a function so it expands at signal time, not now.
if [ -n "${VERIFY_TMPDIR:-}" ]; then
    WORK=$(mktemp -d "${VERIFY_TMPDIR%/}/verify-phase2.XXXXXX") || die2 "cannot create scratch dir under $VERIFY_TMPDIR"
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

# The frozen employer set, read from the honesty freeze rather than hardcoded, so
# a later phase that legitimately adds or renames an employer updates ONE file.
# Comment lines and every other section are dropped, so the [geometry-sha256]
# value can never be matched against the text layer.
awk '
    /^[[:space:]]*#/ { next }
    /^\[/            { inside = ($0 == "[employers]") ? 1 : 0; next }
    inside && NF     { print }
' "$FROZEN" > "$WORK/employers.txt"

printf '>> Inputs: pdf=%s tex=%s frozen=%s\n' "$PDF" "$TEX" "$FROZEN"
if [ -n "$GATE_TEXT" ]; then
    printf '>> NOTE: the text layer was read from the fixture %s, NOT extracted from %s. This run does NOT certify the committed artifact.\n' "$GATE_TEXT" "$PDF"
fi

# ---------------------------------------------------------------------------
# EXP-01a -- the career-break entry is gone, and Work Experience runs
# ADOBE FIREFLY -> SWIGGY with nothing between them.
#
# Three literals made up the deleted \resumeSubheading: its title
# ('Career Break for Master's Degree'), its employer cell
# ('Indiana University, Bloomington') and its domain line
# ('MASTER OF SCIENCE IN COMPUTATIONAL DATA SCIENCE'). All three are asserted --
# checking only the title would let the row return under a reworded heading.
# ---------------------------------------------------------------------------

assert_absent "EXP-01a career-break row absent from the text layer" \
    'Career Break' "$GATE" \
    "The career-break entry is back in the published text layer. Delete the \\resumeSubheading again (02-01-PLAN.md Task 2, D-10: no replacement row, no summary line)."

assert_absent "EXP-01a career-break row absent from the source" \
    'Career Break' "$TEX" \
    "The career-break entry is back in the source. Delete the \\resumeSubheading again (02-01-PLAN.md Task 2, D-10)."

assert_absent "EXP-01a career-break domain line absent from the text layer" \
    'MASTER OF SCIENCE IN COMPUTATIONAL DATA SCIENCE' "$GATE" \
    "This all-caps domain line belonged to the deleted career-break row; the degree itself is carried by the Education section in mixed case. Remove the page-1 row."

# --- Adjacency, measured rather than assumed ------------------------------
# The clause: between the ADOBE FIREFLY line and the SWIGGY line, no OTHER frozen
# employer may appear. Both anchors are frozen strings in the freeze's
# [employers] section, and the harness's G5.5 independently asserts each of them
# extracts exactly once -- so this script's anchors cannot drift away from the
# freeze without G5.5 going red first. Membership is re-checked here anyway,
# because an anchor that silently left the freeze would make the range
# meaningless.
ADJ_A='ADOBE FIREFLY'
ADJ_B='SWIGGY'
EMP_N=$(LC_ALL=C grep -c '[^[:space:]]' "$WORK/employers.txt")
ADJ_A_IN=$(gcount -Fxc "$ADJ_A" "$WORK/employers.txt")
ADJ_B_IN=$(gcount -Fxc "$ADJ_B" "$WORK/employers.txt")
ADJ_A_AT=$(gate_line_of "$ADJ_A")
ADJ_B_AT=$(gate_line_of "$ADJ_B")
ADJ_FOUND=""

if [ "$EMP_N" -lt 3 ]; then
    emit FAIL "EXP-01a Work Experience adjacency: the [employers] section of $FROZEN yields $EMP_N entries, too few to have anything to exclude between '$ADJ_A' and '$ADJ_B' -- adjacency is unmeasurable, and unmeasurable is never a pass"
elif [ "$ADJ_A_IN" -ne 1 ] || [ "$ADJ_B_IN" -ne 1 ]; then
    emit FAIL "EXP-01a Work Experience adjacency: the anchors are no longer frozen employers ('$ADJ_A' x$ADJ_A_IN, '$ADJ_B' x$ADJ_B_IN in the [employers] section of $FROZEN) -- the range they bound is meaningless, so adjacency is unmeasurable"
elif [ -z "$ADJ_A_AT" ] || [ -z "$ADJ_B_AT" ]; then
    emit FAIL "EXP-01a Work Experience adjacency: '$ADJ_A' (line '${ADJ_A_AT:-absent}') or '$ADJ_B' (line '${ADJ_B_AT:-absent}') does not extract as a whole line, so adjacency is unmeasurable -- check the harness's G5.5 first"
elif [ "$ADJ_A_AT" -ge "$ADJ_B_AT" ]; then
    emit FAIL "EXP-01a Work Experience adjacency: '$ADJ_A' extracts at line $ADJ_A_AT, at or AFTER '$ADJ_B' at line $ADJ_B_AT -- the role order a text-only parser reads is inverted"
else
    while IFS= read -r EMP; do
        [ -n "$EMP" ] || continue
        [ "$EMP" != "$ADJ_A" ] || continue
        [ "$EMP" != "$ADJ_B" ] || continue
        EMP_AT=$(region_line_of "$((ADJ_A_AT + 1))" "$((ADJ_B_AT - 1))" "$EMP")
        if [ -n "$EMP_AT" ]; then
            ADJ_FOUND="$ADJ_FOUND '$EMP'@line$EMP_AT"
        fi
    done < "$WORK/employers.txt"

    if [ -z "$ADJ_FOUND" ]; then
        emit PASS "EXP-01a Work Experience adjacency: '$ADJ_A' (line $ADJ_A_AT) is followed by '$ADJ_B' (line $ADJ_B_AT) with none of the other $((EMP_N - 2)) frozen employer(s) on any line between them"
    else
        emit FAIL "EXP-01a Work Experience adjacency: frozen employer(s) extract BETWEEN '$ADJ_A' (line $ADJ_A_AT) and '$ADJ_B' (line $ADJ_B_AT):$ADJ_FOUND -- a role was inserted into or reordered out of the Adobe -> Swiggy sequence"
    fi
fi

# The deleted career-break row's EMPLOYER CELL. Hardcoded on purpose: this is a
# historical string that must stay off page 1, not a live document contract, so
# it is safe in the way FORBIDDEN_LITERAL is safe -- it can only ever be too
# strict about a string that has no business appearing in Work Experience. Its
# one legitimate occurrence is in the Education region on page 2, which is after
# the SWIGGY line, so the range check does not touch it.
CB_EMPLOYER='Indiana University, Bloomington'
if [ -z "$ADJ_A_AT" ] || [ -z "$ADJ_B_AT" ] || [ "$ADJ_A_AT" -ge "$ADJ_B_AT" ]; then
    emit FAIL "EXP-01a career-break employer cell: the '$ADJ_A' -> '$ADJ_B' range could not be established, so '$CB_EMPLOYER' cannot be excluded from it -- the verdict is UNKNOWN, which is never a pass"
else
    CB_AT=$(region_line_of "$((ADJ_A_AT + 1))" "$((ADJ_B_AT - 1))" "$CB_EMPLOYER")
    if [ -z "$CB_AT" ]; then
        emit PASS "EXP-01a career-break employer cell: '$CB_EMPLOYER' does not extract anywhere between '$ADJ_A' (line $ADJ_A_AT) and '$ADJ_B' (line $ADJ_B_AT), so the deleted row has not returned under a reworded heading"
    else
        emit FAIL "EXP-01a career-break employer cell: '$CB_EMPLOYER' extracts at line $CB_AT, between '$ADJ_A' (line $ADJ_A_AT) and '$ADJ_B' (line $ADJ_B_AT) -- the career-break row is back on page 1 even though its heading text changed. Delete it (D-10); the institution belongs to the Education section only"
    fi
fi

# EXP-01's second clause: deleting the row must not delete the dates. The
# separator is EN DASH U+2013 -- pdftotext's rendering of the source's `--` -- and
# LC_ALL=C makes that a byte-exact match. This range is NOT in the honesty
# freeze's [dates] section (which covers the five EMPLOYMENT dates only), so
# without this line nothing asserts it.
assert_whole_line_once "EXP-01a master's dates still extract from Education" \
    'Aug. 2021 – May 2023' "$GATE" \
    "EXP-01's second clause is that removing the career-break row leaves the master's dates visible via Education. Restore the date cell (02-02-PLAN.md Task 1 ships it as \\resumeSubheading #4)."

# ---------------------------------------------------------------------------
# EXP-05b -- every locked D-05/D-06 descriptor literal survives in the text
# layer. Matched against the whitespace-squeezed stream, because both descriptors
# render on two lines and pdftotext breaks them mid-phrase.
#
# 'C++ graph algorithms' is the DESCRIPTOR-UNIQUE anchor, and it is why the bare
# 'C++' check further down is corroborating only. Bare 'C++' already extracts
# three times from page 2 (the Continuous Dominant Set project line and the
# Skills line), so a bare presence test would PASS even if the NetSpeed
# descriptor lost its C++ evidence entirely. 'C++ graph algorithms' measured 0
# before Phase 2 wrote the descriptor, so it can only come from there. ROADMAP
# Phase 5 criterion 4 depends on exactly this anchor.
# ---------------------------------------------------------------------------

while IFS= read -r LIT; do
    [ -n "$LIT" ] || continue
    assert_present "EXP-05b locked descriptor literal (whitespace-squeezed text layer)" "$LIT" "$SQUEEZED"
done <<'LITERALS'
Virtual Channel Arbitration
Polarity-based Arbitration
Multi-Cast Filtering
Structural Latency Breakdown
Network-on-Chip
C++ graph algorithms
NSVD
Neo4j
Cyclops
customer-service platform
live in every Groupon country
LITERALS

# Case-insensitive for this one only: the phrase is sentence-initial in the
# shipped Groupon descriptor, so it renders as 'Customer segmentation'.
assert_present_i "EXP-05b locked descriptor literal (whitespace-squeezed text layer)" \
    'customer segmentation' "$SQUEEZED"

# The five short tokens again, against the RAW extracted lines, so the whitespace
# normalization can never be the thing that makes an assertion pass: each must be
# readable on a single extracted line, which is what a text-only parser sees.
#
# Honest scope note, so a later reader does not over-trust these five. None of
# them contains whitespace, and squeezing newlines into spaces can neither create
# nor destroy a match for a whitespace-free needle -- so for any given document
# the raw and squeezed verdicts on these five are logically EQUIVALENT. They are a
# guard on the squeeze step itself, not an independent statement about the
# document: if the tr pipeline above were ever broken or widened, these would
# still hold the line. Kept because 02-01-SUMMARY.md records the two-stream check
# as the established pattern and because they cost nothing.
#
# 'C++' is corroborating only, deliberately: it already extracts three times (the
# page-2 Continuous Dominant Set project line and the Skills line), so on its own
# it would PASS with the NetSpeed descriptor's C++ evidence entirely gone. The
# descriptor-unique 'C++ graph algorithms' above is the assertion that actually
# holds ROADMAP Phase 5 criterion 4 up.
while IFS= read -r TOK; do
    [ -n "$TOK" ] || continue
    assert_present "EXP-05b locked descriptor token (raw extracted lines, normalization-proof)" "$TOK" "$GATE"
done <<'TOKENS'
Cyclops
NSVD
Neo4j
C++
Network-on-Chip
TOKENS

# The two ladder rungs 02-01-PLAN.md Task 3 names as scope reductions and
# forbids. Asserted absent in BOTH the text layer and the source: a merge done in
# the source is the regression, and the text layer is where a reader sees it.
assert_absent "EXP-05b forbidden merged form absent from the text layer" \
    'Virtual Channel and Polarity-based Arbitration' "$SQUEEZED" \
    "Merging the two names dissolves two of D-06's four locked module names. Restore 'Virtual Channel Arbitration, Polarity-based Arbitration' verbatim; a wrap onto a second rendered line is the sanctioned outcome, not a reason to shorten."

assert_absent "EXP-05b forbidden merged form absent from the source" \
    'Virtual Channel and Polarity-based Arbitration' "$TEX" \
    "Merging the two names dissolves two of D-06's four locked module names (02-01-PLAN.md Task 3, explicitly forbidden)."

assert_absent "EXP-05b forbidden shortened form absent from the text layer" \
    'Cyclops service platform' "$SQUEEZED" \
    "This form drops D-05's 'customer-service' and 'live' elements. Restore 'Cyclops customer-service platform live in every Groupon country' verbatim."

assert_absent "EXP-05b forbidden shortened form absent from the source" \
    'Cyclops service platform' "$TEX" \
    "This form drops D-05's 'customer-service' and 'live' elements (02-01-PLAN.md Task 3, explicitly forbidden)."

# ---------------------------------------------------------------------------
# Human summary. Machine-readable RESULT lines come first; this block uses the
# repo's >> progress and !! error prefixes.
# ---------------------------------------------------------------------------

printf '>> Groups run: EXP-01a career-break removal and Adobe -> Swiggy adjacency; EXP-05b locked D-05/D-06 descriptor literals. Content only -- freshness is the harness G0.3.\n'

if [ "$FAILURES" -eq 0 ]; then
    printf '>> PASS: %s Phase-2 regression assertion(s), 0 failures.\n' "$P2_SEQ"
    exit 0
fi

printf '!! FAIL: %s of %s Phase-2 regression assertion(s) failed:%s\n' "$FAILURES" "$P2_SEQ" "$FAILED_IDS"
printf '!! A Phase-2 invariant regressed. Every RESULT ... FAIL line above names its remedy.\n'
exit 1
