#!/usr/bin/env bash
# verify-phase4-regressions.sh -- standing regression net for the PAGE 2 content
# that Phase 4 Plan 01 landed and that nothing re-runnable guards.
#
# The P2/P3 nets guard the frozen PAGE 1 only; scripts/verify-resume.sh gates
# geometry, freshness, the honesty freeze and the Education ORDERING (G6.12), but
# no re-running assertion pins the page-2 CONTENT Plan 04-01 restructured. That
# gap has real future value to close: Phase 5 edits page 2 (Skills rebuild at
# \section{Technical Skills}), so a silent page-2 regression there would land
# unnoticed. This file is the page-2 twin of the P2/P3 nets.
#
#   PG2-01 (Projects)     Selected Projects is exactly rollout + graph_ml, both
#                         featured repos linked; the seven retired grad-school
#                         entries are gone from the text layer AND cannot come
#                         back commented-out in source; the C++/Cython anchor
#                         Phase 5 (PG2-06) rests on survives; \resumeProjectHeading
#                         occurs exactly 3x (1 preamble definition + 2 uses).
#   PG2-02 (Publication)  The first-author NetSci/IC2S2 citation + venue + Poster
#                         links survive with one fairness-aware-graph-ML
#                         contribution line; the cut abstract's opening clause is
#                         gone from both text layer and source.
#   PG2-03 (Research)     The one-line Research item covers IUNI / paid-RA / NLP-Lab
#                         TieML threads.
#   PG2-03 (Education)    Institution-first, GPA-free, city-free; both date ranges
#                         retained.
#   PG2-03 (Teaching)     D-05 OWNER OVERRIDE, machine-recorded: Teaching still
#                         carries its THREE TA items (NOT compressed to one line) --
#                         the override is a gate, not merely prose.
#
# Deliberately a SEPARATE script rather than new gates inside the harness, for the
# same reasons the P2/P3 nets are separate: the harness counts its own RESULT
# lines and IDs, and docs/verify/{manifest,baseline-frozen}.txt are out of bounds
# under the phase threat model, so the page-2 literal set lives here.
#
# Output contract, one line per assertion, stable order:
#   RESULT P4.<n> <PASS|FAIL> <human message>
# The P4. prefix cannot collide with the harness G-series IDs or the P2./P3.
# prefixes, so all streams can be concatenated and grepped together. IDs are
# sequential in emission order; the order is fixed by this file.
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
# Why two text streams. Multi-word page-2 literals render across pdftotext wrap
# points, so a raw whole-phrase grep can return 0 on a perfectly correct document.
# Multi-word literals are therefore matched against a whitespace-squeezed stream;
# whitespace-free tokens are matched against the RAW gate stream, so the
# normalization can never be the thing that makes an assertion pass.
#
# Written for bash 3.2.57, like the harness and the P2/P3 nets: no associative
# arrays, no mapfile, no case-converting parameter expansion, no `local`.
# Temporaries are `_`-prefixed. Every grep runs under LC_ALL=C so the UTF-8 bytes
# inside literals match byte-exactly.

# No errexit on purpose: every assertion must run and aggregate into FAILURES, so
# a single zero-count grep (which exits 1) may not abort the run. -u and pipefail
# still apply.
set -uo pipefail

# ---------------------------------------------------------------------------
# Defaults and environment fallbacks. Same variable names the harness honours.
# ---------------------------------------------------------------------------

PDF="${VERIFY_PDF:-docs/AshutoshTiwari.pdf}"
TEX="${VERIFY_TEX:-docs/main.tex}"
GATE_TEXT=""

FAILURES=0
FAILED_IDS=""
P4_SEQ=0
WORK=""

usage() {
    cat <<'USAGE'
Usage: verify-phase4-regressions.sh [options]

Standing regression net for the PAGE 2 content Phase 4 Plan 01 landed
(PG2-01 Projects, PG2-02 Publication, PG2-03 Education/Research, and the D-05
Teaching owner override) that scripts/verify-resume.sh does not assert. Prints
one "RESULT P4.<n> <PASS|FAIL> <message>" line per assertion and exits 0 (all
passed), 1 (a regression), or 2 (cannot verify).

Options:
  --pdf PATH        PDF under test            (default docs/AshutoshTiwari.pdf)
  --tex PATH        LaTeX source              (default docs/main.tex)
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
        --gate-text) [ $# -ge 2 ] || { printf '!! --gate-text needs a FILE\n' >&2; exit 2; }; GATE_TEXT="$2"; shift 2 ;;
        -h|--help)   usage; exit 0 ;;
        *)           printf '!! unknown option: %s (try --help)\n' "$1" >&2; exit 2 ;;
    esac
done

# ---------------------------------------------------------------------------
# Emitters. FAIL is the only status that moves the exit code. Each returns 0 so
# it can never abort a caller under pipefail.
#
# emit() mutates FAILURES, FAILED_IDS and P4_SEQ, so it must only ever be called
# from the current shell -- never from inside a pipeline or a command
# substitution, where the increments would be lost in a subshell. Every loop
# below therefore feeds `while read` from a redirect or a here-doc, never a pipe.
# ---------------------------------------------------------------------------

emit() {  # emit <PASS|FAIL> <message>
    P4_SEQ=$((P4_SEQ + 1))
    printf 'RESULT %-6s %-5s %s\n' "P4.$P4_SEQ" "$1" "$2"
    if [ "$1" = FAIL ]; then
        FAILURES=$((FAILURES + 1))
        FAILED_IDS="$FAILED_IDS P4.$P4_SEQ"
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
# test error out -- which, with no errexit, would sail past as neither PASS nor
# FAIL. An unusable measurement becomes the sentinel -1 instead, and every caller
# reports that as FAIL/unmeasurable.
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
# once. Its absence is the regression (locked page-2 content was dropped).
assert_present() {
    _ap=$(gcount -Fc "$2" "$3")
    _apd=$(display_of "$3")
    if [ "$_ap" -ge 1 ]; then
        emit PASS "$1: '$2' present ($_ap match(es)) in $_apd"
    elif [ "$_ap" -eq 0 ]; then
        emit FAIL "$1: '$2' is ABSENT from $_apd -- page-2 content Plan 04-01 landed was shortened, merged or dropped. Restore the literal; do not relax this assertion (04-CONTEXT.md D-01..D-06)"
    else
        emit FAIL "$1: '$2' could not be measured against $_apd (unreadable or missing input) -- the verdict is UNKNOWN, which is never a pass"
    fi
    return 0
}

# assert_absent <label> <needle> <file> <remedy> -- the fixed string must not
# appear at all. Used for the seven retired project names, the dropped GPAs/city,
# and the cut abstract clause.
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

# assert_count <label> <needle> <file> <N> -- the fixed string must occur EXACTLY
# N times. An at-least-one test cannot catch a dropped duplicate (Teaching
# compressed 3 TA items -> fewer) and an absence test cannot catch an added one,
# so the D-05 override and the \resumeProjectHeading structure both need an exact
# count. The -1 sentinel (missing/unreadable input) reports FAIL/unmeasurable.
assert_count() {
    _ac=$(gcount -Fc "$2" "$3")
    _acd=$(display_of "$3")
    if [ "$_ac" -lt 0 ]; then
        emit FAIL "$1: '$2' could not be measured against $_acd (unreadable or missing input) -- the verdict is UNKNOWN, which is never a pass"
    elif [ "$_ac" -eq "$4" ]; then
        emit PASS "$1: '$2' occurs exactly $4 time(s) in $_acd"
    else
        emit FAIL "$1: '$2' occurs $_ac time(s) in $_acd -- want exactly $4. Content count drifted; restore the exact structure (do not relax this assertion)"
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

# Scratch workspace: always from mktemp -d, never from user input, and removed
# only after proving the variable is non-empty and is a directory. Nothing is
# ever written under docs/. The cleanup is an inline single-quoted trap rather
# than a function so it expands at signal time, not now.
if [ -n "${VERIFY_TMPDIR:-}" ]; then
    WORK=$(mktemp -d "${VERIFY_TMPDIR%/}/verify-phase4.XXXXXX") || die2 "cannot create scratch dir under $VERIFY_TMPDIR"
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

printf '>> Inputs: pdf=%s tex=%s\n' "$PDF" "$TEX"
if [ -n "$GATE_TEXT" ]; then
    printf '>> NOTE: the text layer was read from the fixture %s, NOT extracted from %s. This run does NOT certify the committed artifact.\n' "$GATE_TEXT" "$PDF"
fi

# ---------------------------------------------------------------------------
# PG2-01 -- Selected Projects is exactly rollout + graph_ml, both featured and
# linked; the seven retired grad-school entries are gone from the text layer and
# cannot resurrect commented-out in source; the C++/Cython anchor survives; and
# \resumeProjectHeading occurs exactly 3x (preamble definition + two uses).
#
# The two repo names and both URLs are whitespace-free -> RAW gate stream.
# 'C++/Cython' renders inside the graph_ml bullet and may wrap -> squeezed stream;
# it is the Phase-5 PG2-06 anchor, so losing it must be a FAIL here, not a silent
# diff a phase later.
# ---------------------------------------------------------------------------

assert_present "PG2-01 featured project rollout (text layer)"  'rollout'  "$GATE"
assert_present "PG2-01 featured project graph_ml (text layer)" 'graph_ml' "$GATE"
assert_present "PG2-01 rollout repo link (text layer)"  'github.com/thunderock/rollout'  "$GATE"
assert_present "PG2-01 graph_ml repo link (text layer)" 'github.com/thunderock/graph_ml' "$GATE"
assert_present "PG2-01 graph_ml C++/Cython anchor (whitespace-squeezed text layer)" 'C++/Cython' "$SQUEEZED"

# The seven retired grad-school project names, absent from the published text
# layer. Whitespace-free names match the raw gate stream; multi-word names would
# only ever fail to match if broken, so absence there is conservative-safe.
while IFS= read -r RETIRED; do
    [ -n "$RETIRED" ] || continue
    assert_absent "PG2-01 retired project name absent from the text layer" "$RETIRED" "$GATE" \
        "A retired 2017-2022 grad-school project is back on page 2. Selected Projects is exactly rollout + graph_ml (04-CONTEXT.md D-01). Remove the resurrected entry."
done <<'RETIRED_NAMES'
BiasNet
DeepFoodie
BlindNet
Continuous Dominant Set
Humana
AnalyticsVidhya
Bias Manifolds
RETIRED_NAMES

# A representative subset asserted absent in SOURCE too, to catch a commented-out
# resurrection the text layer would never show.
while IFS= read -r SRC_RETIRED; do
    [ -n "$SRC_RETIRED" ] || continue
    assert_absent "PG2-01 retired project name absent from the source" "$SRC_RETIRED" "$TEX" \
        "A retired project name is back in docs/main.tex (possibly commented out). Selected Projects is exactly rollout + graph_ml (04-CONTEXT.md D-01)."
done <<'SRC_RETIRED_NAMES'
BiasNet
Continuous Dominant Set
AnalyticsVidhya
SRC_RETIRED_NAMES

# Structure guard: \resumeProjectHeading is defined once in the preamble and used
# exactly twice (rollout + graph_ml). Exactly 3 in source; a 4th use means a third
# project heading crept in, a count of 2 means a use was dropped.
assert_count "PG2-01 \\resumeProjectHeading structure (source)" '\resumeProjectHeading' "$TEX" 3

# ---------------------------------------------------------------------------
# PG2-02 -- the first-author NetSci/IC2S2 citation + venue + Poster links survive,
# one fairness-aware-graph-ML contribution line is present, and the cut abstract's
# distinctive opening clause is gone from both the text layer and the source.
# ---------------------------------------------------------------------------

assert_present "PG2-02 first-author citation (text layer)" 'first author' "$GATE"
assert_present "PG2-02 NetSci 2023 venue (text layer)"     'NetSci 2023'  "$GATE"
assert_present "PG2-02 IC2S2 2023 venue (text layer)"      'IC2S2 2023'   "$GATE"
assert_present "PG2-02 Poster link (text layer)"           'Poster'       "$GATE"
assert_present "PG2-02 fairness-aware contribution line (whitespace-squeezed text layer)" \
    'fairness-aware graph representation learning' "$SQUEEZED"

assert_absent "PG2-02 cut abstract clause absent from the text layer" \
    'In this work, we propose' "$SQUEEZED" \
    "The abstract paragraph is back on page 2. D-03 cuts it, keeping only the citation + one contribution line. Remove the abstract paragraph."
assert_absent "PG2-02 cut abstract clause absent from the source" \
    'In this work, we propose' "$TEX" \
    "The abstract paragraph is back in docs/main.tex. D-03 cuts it (citation + one contribution line only)."

# ---------------------------------------------------------------------------
# PG2-03 (Research) -- the one-line Research item covers all three threads: IUNI
# independent study, the paid RA "User Intent as a Network", and NLP-Lab TieML.
# ---------------------------------------------------------------------------

assert_present "PG2-03 Research IUNI thread (text layer)" 'IUNI' "$GATE"
assert_present "PG2-03 Research paid-RA thread (whitespace-squeezed text layer)" \
    'User Intent as a Network' "$SQUEEZED"
assert_present "PG2-03 Research TieML thread (text layer)" 'TieML' "$GATE"
assert_present "PG2-03 Research NLP-Lab thread (whitespace-squeezed text layer)" \
    'NLP Lab' "$SQUEEZED"

# ---------------------------------------------------------------------------
# PG2-03 (Education) -- institution-first, GPA-free, city-free; both date ranges
# retained. GPAs asserted absent in BOTH text layer and source; the city dropped
# from the institution cell; the bare institution name still present.
# ---------------------------------------------------------------------------

assert_absent "PG2-03 Education GPA 3.87/4.0 absent from the text layer" \
    '3.87/4.0' "$GATE" \
    "A dropped GPA is back on page 2. D-06 drops both GPAs. Remove it from the Education entry."
assert_absent "PG2-03 Education GPA 3.87/4.0 absent from the source" \
    '3.87/4.0' "$TEX" \
    "A dropped GPA is back in docs/main.tex. D-06 drops both GPAs."
assert_absent "PG2-03 Education GPA 8.32/10.0 absent from the text layer" \
    '8.32/10.0' "$GATE" \
    "A dropped GPA is back on page 2. D-06 drops both GPAs. Remove it from the Education entry."
assert_absent "PG2-03 Education GPA 8.32/10.0 absent from the source" \
    '8.32/10.0' "$TEX" \
    "A dropped GPA is back in docs/main.tex. D-06 drops both GPAs."
assert_absent "PG2-03 Education city dropped from the institution cell (text layer)" \
    'Indiana University, Bloomington' "$GATE" \
    "The Bloomington city is back on the institution cell. D-06 renders 'Indiana University' city-free (manifest EDU_INSTITUTION synced, D-07)."
assert_present "PG2-03 Education institution name retained (text layer)" \
    'Indiana University' "$GATE"
assert_present "PG2-03 Education master's date range retained (whitespace-squeezed text layer)" \
    'Aug. 2021' "$SQUEEZED"
assert_present "PG2-03 Education bachelor's date range retained (whitespace-squeezed text layer)" \
    'Aug. 2011' "$SQUEEZED"

# ---------------------------------------------------------------------------
# PG2-03 / D-05 (Teaching -- OWNER OVERRIDE, UNCHANGED). This is the machine record
# that Teaching was deliberately NOT compressed to one line (an intentional
# deviation from ROADMAP Phase-4 criterion 4). Exactly three TA items must remain,
# and the two distinctive course codes must survive. If a later edit compresses
# Teaching, this count flips and the override reasserts itself as a gate.
# ---------------------------------------------------------------------------

assert_count "PG2-03 D-05 Teaching three TA items retained (text layer)" \
    'Teaching Assistant' "$GATE" 3
assert_present "PG2-03 D-05 Teaching course INFO-I 606 (text layer)" 'INFO-I 606' "$GATE"
assert_present "PG2-03 D-05 Teaching course CSCI-B 555 (text layer)" 'CSCI-B 555' "$GATE"

# ---------------------------------------------------------------------------
# Human summary. Machine-readable RESULT lines come first; this block uses the
# repo's >> progress and !! error prefixes.
# ---------------------------------------------------------------------------

printf '>> Groups run: PG2-01 Selected Projects (rollout + graph_ml, retired names gone, C++/Cython anchor, heading count); PG2-02 Publication (citation + contribution line, abstract cut); PG2-03 Research one-line, Education institution-first GPA/city-free, and the D-05 Teaching three-TA override. Content only -- freshness is the harness G0.3.\n'

if [ "$FAILURES" -eq 0 ]; then
    printf '>> PASS: %s Phase-4 page-2 content assertion(s), 0 failures.\n' "$P4_SEQ"
    exit 0
fi

printf '!! FAIL: %s of %s Phase-4 page-2 content assertion(s) failed:%s\n' "$FAILURES" "$P4_SEQ" "$FAILED_IDS"
printf '!! A Phase-4 page-2 invariant regressed. Every RESULT ... FAIL line above names its remedy.\n'
exit 1
