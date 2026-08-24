#!/usr/bin/env bash
# verify-site-regressions.sh -- standing regression net for the PUBLIC site
# (index.html) that Phase 6 Plan 02 resynced against the rebuilt resume, and that
# nothing re-runnable otherwise guards.
#
# The P2/P3/P4/P5 nets and scripts/verify-resume.sh gate the PDF resume only. The
# public portfolio at index.html is published to GitHub Pages by
# .github/workflows/jekyll.yml on push to master, so a silent regression there --
# a retired throughput figure creeping back, the career-break entry resurrected, a
# pruned grad-era section returning -- would ship publicly on the next push with no
# gate. This file is the site twin of the P2/P3/P4/P5 nets (06-CONTEXT.md D-11).
#
#   S6 (invariants)      The durable site-sync invariants over the RAW index.html
#                        source: the two retired page-1 figures absent, the
#                        career-break entry absent, rollout + graph_ml present, the
#                        dropped GPAs absent, Bloomington absent, the two pruned
#                        grad-era sections absent, torch.compile present (the Adobe
#                        rewrite landed), and the retired grad-project titles absent.
#   S6 (D-08/D-09)       The public-register honesty boundary the resume nets
#                        enforce, now wired on the public side: the retired
#                        throughput register absent (`images/sec`, `32 GPUs`) and
#                        the fabricated / no-evidence terms absent
#                        (`speculative decoding`, `TensorRT-LLM`, `TRT-LLM`). This
#                        is the boundary 06-02 could only flag-unverified;
#                        machine-gated here.
#
# WHY RAW HTML, NO $SQUEEZED. Unlike the resume nets, this net greps the RAW
# index.html source byte-exact under LC_ALL=C grep -F. HTML source is NOT reflowed
# the way pdftotext wraps a PDF text layer across line boundaries, so the resume
# nets' "multi-word literals -> whitespace-squeezed stream" rule does NOT carry
# over (06-CONTEXT.md D-11). Every needle -- including the multi-word ones like
# `Competitive D.S. Experience` -- is matched directly against the source bytes.
#
# ENCODING. The retired-figure needles carry non-ASCII bytes: `3-8K images/sec`
# uses an en dash (U+2013) and `10-50x` a multiplication sign (U+00D7). The source
# is UTF-8 and is not reflowed, so both are matched BYTE-EXACT under LC_ALL=C
# grep -F -- the fixed-string, C-locale matching is what makes the multibyte
# literals compare byte-for-byte (SITE-01/encoding edge, resolved into the net).
#
# Output contract, one line per assertion, stable order:
#   RESULT S6.<n> <PASS|FAIL> <human message>
# The S6. prefix cannot collide with the harness G-series IDs or the P2./P3./P4./
# P5. prefixes, so all streams can be concatenated and grepped together. IDs are
# sequential in emission order; the order is fixed by this file.
#
# Exit vocabulary, the same three-way split scripts/verify-resume.sh uses:
#   0 = every assertion passed
#   1 = at least one assertion failed (the site regressed)
#   2 = cannot verify (missing artifact, unreadable input) -- never reported as a
#       pass, and never conflated with "the site is wrong"
#
# Written for bash 3.2.57, like the harness and the P2/P3/P4/P5 nets: no
# associative arrays, no mapfile, no case-converting parameter expansion, no
# `local`, no double-bracket tests. Temporaries are `_`-prefixed. Every grep runs
# under LC_ALL=C so the UTF-8 bytes inside literals match byte-exactly. This script
# is READ-ONLY: it never writes into the working tree.
#
# NEGATIVE CONTROLS -- the record that no assertion here is a tautology (the
# project rule, recorded in .planning/STATE.md: an assertion never observed
# FAILING is not a gate). This net is GREEN on arrival, so each class is proven
# failable by a crafted fixture passed via --html over a scratch copy of
# index.html. A run carrying --html prints a "does NOT certify the committed
# index.html" disclaimer and certifies nothing; NO build target (make verify /
# make verify-regressions) may pass --html.
#
#   retired figures (S6 retired-figure class)
#       cp index.html "$SC/fx.html"
#       printf '<li>achieving 3-8K images/sec on 32 GPUs (10-50x faster image loading)</li>\n' >> "$SC/fx.html"
#       bash scripts/verify-site-regressions.sh --html "$SC/fx.html"   # FAILs the retired-figure S6.x, exit 1
#     (the two non-ASCII dashes/signs shown ASCII-ized here for the header; the
#      real fixture line re-inserts the exact en-dash / multiplication-sign bytes)

# No errexit on purpose: every assertion must run and aggregate into FAILURES, so
# a single zero-count grep (which exits 1) may not abort the run. -u and pipefail
# still apply.
set -uo pipefail

# ---------------------------------------------------------------------------
# Defaults. The default target is the committed index.html at the repo root.
# ---------------------------------------------------------------------------

HTML="${VERIFY_HTML:-index.html}"
HTML_FIXTURE=""

FAILURES=0
FAILED_IDS=""
S6_SEQ=0

usage() {
    cat <<'USAGE'
Usage: verify-site-regressions.sh [options]

Standing regression net for the PUBLIC site (index.html) Phase 6 Plan 02
resynced against the rebuilt resume: the durable sync invariants AND the
D-08/D-09 public-register honesty boundary (retired throughput register +
fabricated/no-evidence terms absent). Prints one "RESULT S6.<n> <PASS|FAIL>
<message>" line per assertion and exits 0 (all passed), 1 (a regression), or 2
(cannot verify).

Options:
  --html FILE   Read the site source from FILE instead of the committed
                index.html. For a negative control over a crafted fixture ONLY:
                a run carrying this flag proves nothing about the committed
                index.html, and it says so on stdout. No build target may pass it.
  -h, --help    Show this help and exit 0

Environment:
  VERIFY_HTML   Path fallback for the site source (default index.html)

This net greps the RAW index.html source byte-exact under LC_ALL=C grep -F -- no
pdftotext, no whitespace-squeezed reflow (HTML source is not reflowed). It is
read-only and never writes into the working tree.
USAGE
    return 0
}

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

while [ $# -gt 0 ]; do
    case "$1" in
        --html)    [ $# -ge 2 ] || { printf '!! --html needs a FILE\n' >&2; exit 2; }; HTML_FIXTURE="$2"; shift 2 ;;
        -h|--help) usage; exit 0 ;;
        *)         printf '!! unknown option: %s (try --help)\n' "$1" >&2; exit 2 ;;
    esac
done

# ---------------------------------------------------------------------------
# Emitters. FAIL is the only status that moves the exit code. Each returns 0 so
# it can never abort a caller under pipefail.
#
# emit() mutates FAILURES, FAILED_IDS and S6_SEQ, so it must only ever be called
# from the current shell -- never from inside a pipeline or a command
# substitution, where the increments would be lost in a subshell.
# ---------------------------------------------------------------------------

emit() {  # emit <PASS|FAIL> <message>
    S6_SEQ=$((S6_SEQ + 1))
    printf 'RESULT %-6s %-5s %s\n' "S6.$S6_SEQ" "$1" "$2"
    if [ "$1" = FAIL ]; then
        FAILURES=$((FAILURES + 1))
        FAILED_IDS="$FAILED_IDS S6.$S6_SEQ"
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
# `grep -Fc` exits 1 on zero matches but still prints "0", which is a real
# measurement. A MISSING or unreadable file prints NOTHING, and an empty string
# fed to `[ -eq ]` would make the test error out -- which, with no errexit, would
# sail past as neither PASS nor FAIL. An unusable measurement becomes the sentinel
# -1 instead, and every caller reports that as FAIL/unmeasurable.
gcount() {
    _gc=$(LC_ALL=C grep "$1" -- "$2" "$3" 2>/dev/null)
    case "$_gc" in
        ''|*[!0-9]*) printf '%s\n' '-1' ;;
        *)           printf '%s\n' "$_gc" ;;
    esac
    return 0
}

# display_of <path> -- a stable human label for the site source. A negative
# control points --html at a scratch copy, and the RESULT text must stay identical
# to the default run's, so the fixture path is never printed verbatim.
display_of() {
    case "$1" in
        "${HTML:-}") printf '%s\n' 'the raw index.html source' ;;
        *)           printf '%s\n' "$1" ;;
    esac
    return 0
}

# assert_present <label> <needle> <file> -- the fixed string must appear at least
# once. Its absence is the regression (a synced site invariant was dropped).
assert_present() {
    _ap=$(gcount -Fc "$2" "$3")
    _apd=$(display_of "$3")
    if [ "$_ap" -ge 1 ]; then
        emit PASS "$1: '$2' present ($_ap match(es)) in $_apd"
    elif [ "$_ap" -eq 0 ]; then
        emit FAIL "$1: '$2' is ABSENT from $_apd -- a synced site invariant was dropped. Restore it in index.html (Plan 06-02); do not relax this assertion (06-CONTEXT.md D-05..D-11)"
    else
        emit FAIL "$1: '$2' could not be measured against $_apd (unreadable or missing input) -- the verdict is UNKNOWN, which is never a pass"
    fi
    return 0
}

# assert_absent <label> <needle> <file> <remedy> -- the fixed string must not
# appear at all. Used for retired figures, career break, GPAs, pruned sections,
# retired project titles, and the D-08/D-09 register/honesty terms.
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

# ---------------------------------------------------------------------------
# Precondition. A missing/unreadable site source is "cannot verify" (exit 2),
# never a FAIL: an absent artifact says nothing about whether the site regressed.
# ---------------------------------------------------------------------------

if [ -n "$HTML_FIXTURE" ]; then
    HTML="$HTML_FIXTURE"
fi
[ -f "$HTML" ] && [ -s "$HTML" ] || die2 "site source missing or empty: $HTML"

printf '>> Inputs: html=%s\n' "$HTML"
if [ -n "$HTML_FIXTURE" ]; then
    printf '>> NOTE: the site source was read from the fixture %s, NOT the committed index.html. This run does NOT certify the committed index.html.\n' "$HTML_FIXTURE"
fi

# ---------------------------------------------------------------------------
# S6 -- retired page-1 figures absent (D-08). The two throughput/latency figures
# the resume retired and 06-02 deletes from the Adobe block: `3-8K images/sec`
# (en dash U+2013) and `10-50x` (multiplication sign U+00D7). Matched byte-exact
# under LC_ALL=C grep -F against the raw source.
# ---------------------------------------------------------------------------

assert_absent "S6 retired figure absent (raw source)" \
    '3–8K images/sec' "$HTML" \
    "A retired throughput figure is back on the public site. D-08 removes it. Fix index.html (Plan 06-02), never this needle."
assert_absent "S6 retired figure absent (raw source)" \
    '10–50×' "$HTML" \
    "A retired latency figure is back on the public site. D-08 removes it. Fix index.html (Plan 06-02), never this needle."

# ---------------------------------------------------------------------------
# Human summary. Machine-readable RESULT lines come first; this block uses the
# repo's >> progress and !! error prefixes.
# ---------------------------------------------------------------------------

printf '>> Groups run: S6 retired page-1 figures absent (3-8K images/sec, 10-50x). Raw index.html source, byte-exact LC_ALL=C grep -F.\n'

if [ "$FAILURES" -eq 0 ]; then
    printf '>> PASS: %s site-sync assertion(s), 0 failures.\n' "$S6_SEQ"
    exit 0
fi

printf '!! FAIL: %s of %s site-sync assertion(s) failed:%s\n' "$FAILURES" "$S6_SEQ" "$FAILED_IDS"
printf '!! A site-sync invariant regressed. Every RESULT ... FAIL line above names its remedy.\n'
exit 1
