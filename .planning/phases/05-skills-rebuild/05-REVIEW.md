---
phase: 05-skills-rebuild
reviewed: 2026-08-24T04:52:23Z
depth: standard
files_reviewed: 5
files_reviewed_list:
  - docs/main.tex
  - docs/verify/manifest.txt
  - Makefile
  - scripts/verify-phase3-regressions.sh
  - scripts/verify-phase5-regressions.sh
findings:
  critical: 1
  warning: 2
  info: 2
  total: 5
status: issues_found
---

# Phase 5: Code Review Report

**Reviewed:** 2026-08-24T04:52:23Z
**Depth:** standard
**Files Reviewed:** 5
**Status:** issues_found

## Summary

Phase 5 rebuilt the Technical Skills block into a 3-tier taxonomy, landed 4 exact-match
keywords (ONNX Runtime, H100, CUDA graphs, Iceberg), promoted them in the manifest, flipped
P3.44/P3.65 to the H100-promotion pairing, and added `scripts/verify-phase5-regressions.sh`
wired into the Makefile.

Verified empirically under `/bin/bash` 3.2.57 (the target interpreter) against the committed
PDF: the Phase-5 net is green (25/25, exit 0), the Phase-3 net is green (72/72, IDs preserved,
P3.44 and P3.65 correctly flipped to H100), and `make verify-regressions` runs all four nets
(27+72+38+25). Page-1 of `main.tex` is byte-frozen — the only diff hunk is at the Skills block
(`@@ -289,8 +289,9 @@`, 3 insertions / 2 deletions). The Skills block renders in exactly 3
lines with C++ present. The manifest promotion is correct: the four keywords moved from
`KEYWORDS_TARGET` (which is now empty) into `KEYWORDS_REQUIRED` with the `:phase` suffix
stripped. All documented negative controls fire as claimed.

The rebuild is high quality and heavily documented. However, the reused `assert_promoted`
helper — copied from the Phase-3 net, which only ever handled whitespace-free tokens — is now
applied to the multi-word literal `CUDA graphs`, and its conjunct-1 presence check runs against
the RAW extraction stream rather than the squeezed stream. This is a genuine violation of the
net's own two-stream contract and produces a false FAIL on a correct-but-wrapped document
(proven with a fixture). Two lower-severity issues concern gate strength and a stale comment.

## Critical Issues

### CR-01: `assert_promoted` conjunct 1 checks the RAW stream for the multi-word literal `CUDA graphs` (broken two-stream check → false FAIL on wrap)

**File:** `scripts/verify-phase5-regressions.sh:296` (conjunct 1), invoked at `scripts/verify-phase5-regressions.sh:463`

**Issue:**
`assert_promoted` resolves conjunct 1 (presence in the text layer) with
`_apr_gate=$(gcount -Fc "$2" "$GATE")`, where `$GATE` is the RAW, form-feed-normalized,
multi-line stream. This helper was grafted verbatim from the Phase-3 net, where every promoted
literal is whitespace-free (`torch.compile`, `A100`, `H100`, `Triton`) and so is immune to
pdftotext line wrapping. Phase 5 now calls it with the multi-word literal `CUDA graphs`
(`scripts/verify-phase5-regressions.sh:463`), which contains a space and can be broken across a
wrap point — exactly the failure mode this net's own header (lines 54-60) cites as the
STATE.md `[Phase 04 / close]` BLOCKER and the whole reason the squeezed stream exists.

The literal is mid-line in the rendered Skills row (`..., CUDA graphs, A100, H100`), so a wrap
is realistic if any future edit reflows Tier 1. When that happens, the squeezed-stream presence
check (P5.2) correctly stays green while the promotion pairing (P5.24) fails conjunct 1,
reporting `'CUDA graphs' is ABSENT from the extracted text layer, so there is nothing to
promote yet` — a false failure on a document whose Skills block is perfectly correct, and the
whole net exits 1.

Proven with a fixture that wraps the literal (simulating a pdftotext break):
```
sed 's/CUDA graphs/CUDA\ngraphs/' raw.txt > fx.txt
/bin/bash scripts/verify-phase5-regressions.sh --gate-text fx.txt
# RESULT P5.2  PASS  ... 'CUDA graphs' present (1 match(es)) in the whitespace-squeezed text layer
# RESULT P5.24 FAIL  ... conjunct 1 FAILS -- 'CUDA graphs' is ABSENT from the extracted text layer ...
# !! FAIL: 1 of 25 ... failed: P5.24   (exit 1)
```
It is green today only because the current layout keeps `CUDA graphs` on one raw line
(measured: 1 match). This is a latent gate defect, not a passing gate.

**Fix:** Resolve conjunct 1 against the squeezed stream for multi-word literals (single tokens
can stay on `$GATE`). Minimal change: check both streams so a wrapped multi-word literal still
counts as present.
```sh
# conjunct 1: present in the text layer -- wrap-safe for multi-word literals
_apr_gate=$(gcount -Fc "$2" "$GATE")
_apr_sq=$(gcount -Fc "$2" "$SQUEEZED")
if [ "$_apr_gate" -ge 0 ] && [ "$_apr_sq" -ge 0 ] && [ "$_apr_gate" -lt "$_apr_sq" ]; then
    _apr_gate="$_apr_sq"   # the raw stream wrapped the literal; the squeezed stream is authoritative
fi
```
(Or add a dedicated `assert_promoted_multiword` and route `CUDA graphs` to it, mirroring the
raw/squeezed split the presence assertions already use.) Add a negative control that wraps
`CUDA graphs` and asserts P5.24 stays green, so the two-stream fix is itself failable.

## Warnings

### WR-01: Promoting the multi-word `CUDA graphs` into `KEYWORDS_REQUIRED` makes the harness G6.5 gate wrap-fragile too

**File:** `docs/verify/manifest.txt:61` (consumed by `scripts/verify-resume.sh:1736`)

**Issue:**
The in-scope manifest change adds `CUDA graphs` to `KEYWORDS_REQUIRED`. The harness G6.5 loop
counts each required keyword with `N=$(LC_ALL=C grep -oF "$KW" "$WORK/gate.txt" | wc -l ...)`
against the RAW `gate.txt` (`scripts/verify-resume.sh:1736`) — no squeezed fallback. So the
harness now has its own wrap-fragile required-keyword check for `CUDA graphs`: a reflow that
splits the literal makes `make verify` (G6.5) FAIL a correct document, with the misleading
remedy "restore it, or move it back to KEYWORDS_TARGET." The same latent fragility already
exists for the pre-existing multi-word required keyword `Flash Attention`; Phase 5 extends the
exposure rather than introducing the pattern. Green today for the same reason as CR-01 (current
layout keeps both literals on one line). This is the harness-side twin of CR-01 and shares the
root cause: multi-word keyword presence must not be measured on the raw stream.

**Fix:** Out of the direct file scope (lives in `scripts/verify-resume.sh`), but the manifest
change is what activates it. Either teach G6.5 to fall back to a whitespace-squeezed stream for
keywords containing a space, or keep multi-word entries out of `KEYWORDS_REQUIRED` and gate
their ATS presence only via the wrap-safe squeezed assertions in the Phase-5 net. At minimum,
record the coupling so a future reflow failure is diagnosable.

### WR-02: Single-token presence assertions for multi-carrier keywords cannot detect a Skills-block regression, yet the FAIL remedy claims Skills-tier scope

**File:** `scripts/verify-phase5-regressions.sh:428-438` (and the `assert_present` FAIL text at line 234)

**Issue:**
The raw single-token assertions (`A100`, `Rust`, `Triton`, `KEDA`, `vLLM`, `Spark`, `Ray`,
`FSDP`, `Kubernetes`) plus the multi-word `Flash Attention`/`PyTorch Lightning` squeezed
assertions are document-wide presence checks. But those tokens have other carriers in the
finalized page-1 Experience block (measured in source: Rust×5, vLLM×4, Kubernetes×3, KEDA×3,
Ray×3, FSDP×2, Triton×2, Spark×2, A100×2, Flash Attention×2, PyTorch Lightning×2). A
Skills-block-only deletion of any of these leaves the assertion green because the page-1
carrier still matches — so for these tokens the assertion cannot catch the regression its own
FAIL message names: `a Skills tier token Plan 05-01 landed was shortened, merged or dropped.
Restore the literal` (line 234). Only `H100`, `Iceberg`, `ONNX`, and `CUDA graphs` are truly
Skills-owned single carriers, and only those are genuinely failable on a Skills-block edit
(verified: `H100`×1, `Iceberg`×1, `ONNX`×1, `CUDA graphs`×1). The header's per-class
anti-tautology proof uses global deletions (e.g. `sed 's/FSDP//g'` over the whole stream),
which proves the grep works but not that the gate catches a Skills-scoped regression. There is
also duplication: Phase-3 Group 1 already asserts `Rust`, `FSDP`, `Flash Attention`, `A100`
document-wide.

This is a WARNING rather than a BLOCKER because the net's actual PG2-04 contract is
ATS/document-wide keyword survival, which these assertions do satisfy; the defect is that the
FAIL remedy overclaims Skills-tier scope and reads as coverage it does not provide.

**Fix:** Either scope the multi-carrier assertions to the rendered Skills region (slice by the
`TECHNICAL SKILLS` heading, as the Phase-3 net slices the governance region), or soften the
FAIL remedy for multi-carrier tokens to state it asserts document-wide ATS presence, not
Skills-block retention — reserving the "Skills tier token dropped" wording for the four genuine
single-carrier keywords.

## Info

### IN-01: Stale `SKILLS_MAX_LINES` comment — Skills now renders 3 lines, not "4 today"

**File:** `docs/verify/manifest.txt:49`

**Issue:** The comment reads `SKILLS_MAX_LINES=3  # measures 4 today; owner Phase 5 -> WARN
until then`. Phase 5's rebuild is the fix: the Skills block now renders in exactly 3 lines
(verified via pdftotext), so G6.14 should pass at the `=3` threshold and the "measures 4 today"
note is stale.

**Fix:** Update the comment to reflect the post-Phase-5 state (e.g. `# Phase 5 rebuild brought
this to 3`), so a reader does not mistake the gate for a still-open WARN.

### IN-02: Phase-5 H100 content is gated inside the Phase-3 net (cross-phase coupling)

**File:** `scripts/verify-phase3-regressions.sh:886` (P3.44), `scripts/verify-phase3-regressions.sh:1017` (P3.65)

**Issue:** The H100 promotion/presence gates for the Phase-5 Skills content live in the
Phase-3 net (to preserve the P3.44/P3.65 ids). This is deliberate and well-documented (id
stability), and both are chained via `make verify-regressions`, so coverage holds. Worth
recording only so a future reader of the Phase-5 net does not conclude H100's promotion is
ungated — it is, by P3.44 — and so that removing/renumbering the Phase-3 net would silently
drop a Phase-5 invariant.

**Fix:** None required. Optionally add a one-line pointer comment near the Phase-5 promotion
block noting H100's gate is P3.44 (the header already says this).

---

_Reviewed: 2026-08-24T04:52:23Z_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: standard_
