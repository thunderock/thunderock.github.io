#!/usr/bin/env bash
# verify-phase5-regressions.sh -- standing regression net for the Technical Skills
# block that Phase 5 Plan 01 rebuilt, and for the keyword promotions that rebuild
# forced. Nothing re-runnable otherwise guards this content.
#
# scripts/verify-resume.sh gates geometry, freshness, the honesty freeze, the
# Skills line count (G6.14, WARN-tier) and keyword PRESENCE (G6.5, raw stream).
# But G6.5 is a presence convention, not a promotion gate, and no re-running
# assertion pins the Skills tier CONTENT or the same-commit promotion pairing that
# STATE.md records as the ONLY machine backing for a promotion. This file is the
# Skills twin of the P2/P3/P4 nets.
#
#   PG2-04 (tiers)       The three functional tiers carry their exact-match forms:
#                        the multi-word inference/framework keywords (ONNX Runtime,
#                        CUDA graphs, Flash Attention, PyTorch Lightning) survive on
#                        the whitespace-squeezed stream despite any pdftotext wrap,
#                        and the whitespace-free tokens (A100, H100, Triton, Rust,
#                        KEDA, Iceberg, vLLM, Spark, Ray, FSDP, Kubernetes) survive
#                        on the raw gate stream.
#   PG2-04 (promotion)   ONNX, CUDA graphs and Iceberg were PROMOTED in the same
#                        commit that landed them -- moved out of KEYWORDS_TARGET
#                        into KEYWORDS_REQUIRED with the ':phase' suffix stripped.
#                        This net OWNS those three promotion gates (option A); H100's
#                        promotion is machine-gated by the P3.44 flip in the Phase-3
#                        net and is deliberately NOT duplicated here.
#   PG2-05 (concepts)    The Concepts tier carries the five concept phrases as a
#                        vocabulary list, and the two prohibited terms
#                        ('speculative decoding' phrase, 'Go' whole word) stay ZERO
#                        whole-document (belt-and-suspenders beside the harness's
#                        own G6.7 gates).
#
# Deliberately a SEPARATE script rather than new gates inside the harness, for the
# same reasons the P2/P3/P4 nets are separate: the harness counts its own RESULT
# lines and IDs, and docs/verify/{manifest,baseline-frozen}.txt are out of bounds
# under the phase threat model, so the Skills literal set + promotion gate live here.
#
# Output contract, one line per assertion, stable order:
#   RESULT P5.<n> <PASS|FAIL> <human message>
# The P5. prefix cannot collide with the harness G-series IDs or the P2./P3./P4.
# prefixes, so all streams can be concatenated and grepped together. IDs are
# sequential in emission order; the order is fixed by this file.
#
# Exit vocabulary, the same three-way split scripts/verify-resume.sh uses:
#   0 = every assertion passed
#   1 = at least one assertion failed (the document, or the promotion ledger,
#       regressed)
#   2 = cannot verify (missing tool, missing artifact, unreadable input) -- never
#       reported as a pass, and never conflated with "the document is wrong"
#
# This net asserts CONTENT and the promotion ledger only. It does not re-prove that
# the PDF was built from the current source; that is the harness's G0.3, and this
# script reads whatever artifact is on disk. Run both.
#
# Why two text streams. Multi-word Skills literals render across pdftotext wrap
# points, so a raw whole-phrase grep can return 0 on a perfectly correct document
# (STATE.md [Phase 04 / close] BLOCKER). Multi-word literals are therefore matched
# against a whitespace-squeezed stream; whitespace-free tokens are matched against
# the RAW gate stream, so the normalization can never be the thing that makes an
# assertion pass. The raw stream is also what the harness's case-sensitive G6.5
# keyword scan reads, so a single-token needle here mirrors what G6.5 sees.
#
# Written for bash 3.2.57, like the harness and the P2/P3/P4 nets: no associative
# arrays, no mapfile, no case-converting parameter expansion, no `local`, no
# double-bracket tests. Temporaries are `_`-prefixed. Every grep runs under
# LC_ALL=C so the UTF-8 bytes inside literals match byte-exactly. Every `while
# read` loop is fed from a redirect or a here-doc, never a pipe, so emit's counter
# increments are never lost in a subshell.
#
# NEGATIVE CONTROLS -- the record that no assertion here is a tautology (Phase 1's
# rule, recorded in .planning/STATE.md: an assertion never observed FAILING is not
# a gate). This net is GREEN on arrival, so each class is proven failable by a
# crafted fixture. All fixture runs happen under a caller's mktemp scratch and
# nothing is ever written into the working tree.
#
#   multi-word literal (squeezed stream)
#       pdftotext docs/AshutoshTiwari.pdf "$SC/raw.txt"
#       sed 's/CUDA graphs//g' "$SC/raw.txt" > "$SC/fx.txt"
#       bash scripts/verify-phase5-regressions.sh --gate-text "$SC/fx.txt"   # FAILs the CUDA graphs P5.x, exit 1
#
#   single token (raw stream)
#       sed 's/FSDP//g' "$SC/raw.txt" > "$SC/fx.txt"
#       bash scripts/verify-phase5-regressions.sh --gate-text "$SC/fx.txt"   # FAILs the FSDP P5.x, exit 1
#
#   honesty absence (a prohibited term INSERTED)
#       cp "$SC/raw.txt" "$SC/fx.txt"; printf 'speculative decoding Go\n' >> "$SC/fx.txt"
#       bash scripts/verify-phase5-regressions.sh --gate-text "$SC/fx.txt"   # FAILs both honesty P5.x, exit 1
#
#   promotion pairing (a scratch manifest that leaves a keyword in KEYWORDS_TARGET)
#       sed 's/^KEYWORDS_TARGET=$/KEYWORDS_TARGET=ONNX:5/' docs/verify/manifest.txt > "$SC/m.txt"
#       bash scripts/verify-phase5-regressions.sh --manifest "$SC/m.txt"     # FAILs the ONNX assert_promoted (conjunct 3), exit 1
#     --gate-text/--tex cannot vary the manifest, which is why --manifest exists.
#     A --gate-text run prints the "does NOT certify the committed artifact"
#     disclaimer on stdout and certifies nothing. No build target may pass either
#     waiver flag.

# No errexit on purpose: every assertion must run and aggregate into FAILURES, so
# a single zero-count grep (which exits 1) may not abort the run. -u and pipefail
# still apply.
set -uo pipefail

# ---------------------------------------------------------------------------
# Defaults and environment fallbacks. Same variable names the harness honours.
# ---------------------------------------------------------------------------

PDF="${VERIFY_PDF:-docs/AshutoshTiwari.pdf}"
TEX="${VERIFY_TEX:-docs/main.tex}"
MANIFEST="docs/verify/manifest.txt"
GATE_TEXT=""

FAILURES=0
FAILED_IDS=""
P5_SEQ=0
WORK=""

usage() {
    cat <<'USAGE'
Usage: verify-phase5-regressions.sh [options]

Standing regression net for the Technical Skills tiers Phase 5 Plan 01 rebuilt
(PG2-04 keyword tiers + same-commit promotions, PG2-05 concept vocabulary and the
zero-prohibited-terms honesty boundary) that scripts/verify-resume.sh does not
assert. Prints one "RESULT P5.<n> <PASS|FAIL> <message>" line per assertion and
exits 0 (all passed), 1 (a regression), or 2 (cannot verify).

Options:
  --pdf PATH        PDF under test            (default docs/AshutoshTiwari.pdf)
  --tex PATH        LaTeX source              (default docs/main.tex)
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
# emit() mutates FAILURES, FAILED_IDS and P5_SEQ, so it must only ever be called
# from the current shell -- never from inside a pipeline or a command
# substitution, where the increments would be lost in a subshell. Every loop
# below therefore feeds `while read` from a redirect or a here-doc, never a pipe.
# ---------------------------------------------------------------------------

emit() {  # emit <PASS|FAIL> <message>
    P5_SEQ=$((P5_SEQ + 1))
    printf 'RESULT %-6s %-5s %s\n' "P5.$P5_SEQ" "$1" "$2"
    if [ "$1" = FAIL ]; then
        FAILURES=$((FAILURES + 1))
        FAILED_IDS="$FAILED_IDS P5.$P5_SEQ"
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
# one run's output against another's. The MANIFEST arm exists for the same reason:
# a promotion negative control points --manifest at a scratch copy, and the RESULT
# text must stay identical to the default run's.
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
# once. Its absence is the regression (a locked Skills tier token was dropped).
assert_present() {
    _ap=$(gcount -Fc "$2" "$3")
    _apd=$(display_of "$3")
    if [ "$_ap" -ge 1 ]; then
        emit PASS "$1: '$2' present ($_ap match(es)) in $_apd"
    elif [ "$_ap" -eq 0 ]; then
        emit FAIL "$1: '$2' is ABSENT from $_apd -- a Skills tier token Plan 05-01 landed was shortened, merged or dropped. Restore the literal verbatim; do not relax this assertion (05-CONTEXT.md D-01..D-05)"
    else
        emit FAIL "$1: '$2' could not be measured against $_apd (unreadable or missing input) -- the verdict is UNKNOWN, which is never a pass"
    fi
    return 0
}

# assert_absent <label> <needle> <file> <remedy> -- the fixed string must not
# appear at all. Used for the prohibited PHRASE 'speculative decoding'.
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

# assert_absent_word <label> <needle> <file> <remedy> -- the fixed string must not
# appear as a WHOLE WORD. Used for the prohibited WORD 'Go', which is a substring
# of legitimate words in this document (e.g. 'Governance' on page 1), so a
# substring -Fc absence check would false-FAIL. This mirrors the harness's own
# G6.7 prohibited-WORD gate, which is word-boundary (-w). The -w and -F flags
# combine, so 'Go' matches 'Go' but never 'Google', 'Going' or 'Governance'. A
# zero from -wFc means zero matching LINES, which is all an absence check needs.
assert_absent_word() {
    _aw=$(gcount -wFc "$2" "$3")
    _awd=$(display_of "$3")
    if [ "$_aw" -eq 0 ]; then
        emit PASS "$1: '$2' is absent as a whole word from $_awd (word-boundary count 0)"
    elif [ "$_aw" -ge 1 ]; then
        emit FAIL "$1: '$2' appears as a whole word in $_aw line(s) of $_awd -- want 0. $4"
    else
        emit FAIL "$1: '$2' could not be measured against $_awd (unreadable or missing input) -- the verdict is UNKNOWN, which is never a pass"
    fi
    return 0
}

# assert_promoted <label> <literal> -- the keyword-promotion pairing rule, all
# three conjuncts resolved into ONE verdict (grafted from the Phase-3 net,
# 03-RESEARCH.md E-5). This net OWNS the ONNX / CUDA graphs / Iceberg promotions
# (Plan 05-01 option A); H100's promotion stays gated by the Phase-3 net's P3.44
# flip and is not duplicated here.
#
#   1. the literal is present in the extracted text layer ($GATE, fixed string)
#   2. it is a WHOLE pipe-field of KEYWORDS_REQUIRED -- pipes translated to
#      newlines, then matched whole-line fixed. Whole-field, never substring:
#      a substring test would let 'ONNX' pass on an 'ONNX Runtime' field.
#   3. no KEYWORDS_TARGET field still begins with "<literal>:" -- the ':phase'
#      suffix must be STRIPPED on promotion, because a suffix-intact promotion
#      makes the harness's G6.5 grep the text layer for '<literal>:<phase>' and
#      FAIL, and a keyword left in both tiers is counted twice.
#
# The FAIL message names WHICH conjunct failed, because the three have different
# remedies. This is the only assertion in the net that reads the verification
# manifest as DATA to cross-check rather than as configuration, which is why
# --manifest exists.
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
[ -f "$MANIFEST" ] && [ -s "$MANIFEST" ] || die2 "verification manifest missing or empty: $MANIFEST"

# Scratch workspace: always from mktemp -d, never from user input, and removed
# only after proving the variable is non-empty and is a directory. Nothing is
# ever written under docs/. The cleanup is an inline single-quoted trap rather
# than a function so it expands at signal time, not now.
if [ -n "${VERIFY_TMPDIR:-}" ]; then
    WORK=$(mktemp -d "${VERIFY_TMPDIR%/}/verify-phase5.XXXXXX") || die2 "cannot create scratch dir under $VERIFY_TMPDIR"
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

printf '>> Inputs: pdf=%s tex=%s manifest=%s\n' "$PDF" "$TEX" "$MANIFEST"
if [ -n "$GATE_TEXT" ]; then
    printf '>> NOTE: the text layer was read from the fixture %s, NOT extracted from %s. This run does NOT certify the committed artifact.\n' "$GATE_TEXT" "$PDF"
fi

# ---------------------------------------------------------------------------
# PG2-04 -- multi-word inference/framework keywords on the SQUEEZED stream. Each
# contains whitespace, so pdftotext may wrap it across a line and a raw-stream
# check would false-pass a deletion regression (STATE.md [Phase 04 / close]).
# ---------------------------------------------------------------------------

assert_present "PG2-04 Tier 1 multi-word keyword (whitespace-squeezed text layer)" 'ONNX Runtime'      "$SQUEEZED"
assert_present "PG2-04 Tier 1 multi-word keyword (whitespace-squeezed text layer)" 'CUDA graphs'       "$SQUEEZED"
assert_present "PG2-04 Tier 2 multi-word keyword (whitespace-squeezed text layer)" 'Flash Attention'   "$SQUEEZED"
assert_present "PG2-04 Tier 2 multi-word keyword (whitespace-squeezed text layer)" 'PyTorch Lightning' "$SQUEEZED"

# ---------------------------------------------------------------------------
# PG2-05 -- the Concepts tier's five concept phrases as a vocabulary list. All are
# multi-word -> SQUEEZED.
# ---------------------------------------------------------------------------

assert_present "PG2-05 Concepts vocabulary (whitespace-squeezed text layer)" 'tensor parallelism'       "$SQUEEZED"
assert_present "PG2-05 Concepts vocabulary (whitespace-squeezed text layer)" 'pipeline parallelism'     "$SQUEEZED"
assert_present "PG2-05 Concepts vocabulary (whitespace-squeezed text layer)" 'Mixture of Experts (MoE)' "$SQUEEZED"
assert_present "PG2-05 Concepts vocabulary (whitespace-squeezed text layer)" 'KV-cache management'      "$SQUEEZED"
assert_present "PG2-05 Concepts vocabulary (whitespace-squeezed text layer)" 'continuous batching'      "$SQUEEZED"

# ---------------------------------------------------------------------------
# PG2-04 -- whitespace-free single-token keywords on the RAW gate stream. This is
# also what the harness's case-sensitive G6.5 keyword scan reads, so each must be
# readable on a single extracted line.
# ---------------------------------------------------------------------------

assert_present "PG2-04 single-token keyword (raw extracted lines)" 'A100'       "$GATE"
assert_present "PG2-04 single-token keyword (raw extracted lines)" 'H100'       "$GATE"
assert_present "PG2-04 single-token keyword (raw extracted lines)" 'Triton'     "$GATE"
assert_present "PG2-04 single-token keyword (raw extracted lines)" 'Rust'       "$GATE"
assert_present "PG2-04 single-token keyword (raw extracted lines)" 'KEDA'       "$GATE"
assert_present "PG2-04 single-token keyword (raw extracted lines)" 'Iceberg'    "$GATE"
assert_present "PG2-04 single-token keyword (raw extracted lines)" 'vLLM'       "$GATE"
assert_present "PG2-04 single-token keyword (raw extracted lines)" 'Spark'      "$GATE"
assert_present "PG2-04 single-token keyword (raw extracted lines)" 'Ray'        "$GATE"
assert_present "PG2-04 single-token keyword (raw extracted lines)" 'FSDP'       "$GATE"
assert_present "PG2-04 single-token keyword (raw extracted lines)" 'Kubernetes' "$GATE"

# ---------------------------------------------------------------------------
# PG2-05 -- honesty boundary. The prohibited PHRASE 'speculative decoding' must be
# absent whole-document (squeezed catches it even if wrapped); the prohibited WORD
# 'Go' must be absent as a WHOLE WORD (it is a substring of 'Governance' on page 1,
# so this must be word-boundary, not substring). Both mirror the manifest's
# PROHIBITED_PHRASES / PROHIBITED_WORDS and the harness's own G6.7 gate.
# ---------------------------------------------------------------------------

assert_absent "PG2-05 prohibited phrase absent whole-document (whitespace-squeezed text layer)" \
    'speculative decoding' "$SQUEEZED" \
    "'speculative decoding' is back in the document. CODEBASE-EVIDENCE.md forbids it (no such claim is defensible). Remove it; do not relax this assertion."
assert_absent_word "PG2-05 prohibited word absent whole-document (raw extracted lines, word-boundary)" \
    'Go' "$GATE" \
    "'Go' (the language) is back in the document as a whole word. It is prohibited (manifest PROHIBITED_WORDS). Remove it; do not relax this assertion."

# ---------------------------------------------------------------------------
# PG2-04 -- promotion pairing. This net OWNS the ONNX / CUDA graphs / Iceberg
# promotions (option A): each must be present in the text layer AND a whole pipe-
# field of KEYWORDS_REQUIRED AND absent from KEYWORDS_TARGET. H100's promotion is
# gated by the Phase-3 net's P3.44 flip and is deliberately NOT duplicated here.
# ---------------------------------------------------------------------------

assert_promoted "PG2-04 keyword promoted in the same commit that landed it" 'ONNX'
assert_promoted "PG2-04 keyword promoted in the same commit that landed it" 'CUDA graphs'
assert_promoted "PG2-04 keyword promoted in the same commit that landed it" 'Iceberg'

# ---------------------------------------------------------------------------
# Human summary. Machine-readable RESULT lines come first; this block uses the
# repo's >> progress and !! error prefixes.
# ---------------------------------------------------------------------------

printf '>> Groups run: PG2-04 multi-word keywords on the squeezed stream (ONNX Runtime, CUDA graphs, Flash Attention, PyTorch Lightning); PG2-05 Concepts vocabulary (5 phrases, squeezed); PG2-04 single-token keywords on the raw stream (A100, H100, Triton, Rust, KEDA, Iceberg, vLLM, Spark, Ray, FSDP, Kubernetes); PG2-05 honesty absence (speculative decoding phrase, Go word-boundary); PG2-04 promotion pairing (ONNX, CUDA graphs, Iceberg -- H100 gated by the P3.44 flip). Content + promotion ledger only -- freshness is the harness G0.3.\n'

if [ "$FAILURES" -eq 0 ]; then
    printf '>> PASS: %s Phase-5 Skills content assertion(s), 0 failures.\n' "$P5_SEQ"
    exit 0
fi

printf '!! FAIL: %s of %s Phase-5 Skills content assertion(s) failed:%s\n' "$FAILURES" "$P5_SEQ" "$FAILED_IDS"
printf '!! A Phase-5 Skills invariant or promotion regressed. Every RESULT ... FAIL line above names its remedy.\n'
exit 1
