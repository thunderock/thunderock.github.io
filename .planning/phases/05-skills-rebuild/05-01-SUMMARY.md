---
phase: 05-skills-rebuild
plan: 01
subsystem: resume-skills-and-harness
tags: [latex, ats-keywords, verification-harness, regression-net, promotion-gate]
requires:
  - Phase 4 page-2 restructure (graph_ml C++/Cython anchor present)
  - manifest KEYWORDS_TARGET carrying ONNX/CUDA graphs/Iceberg/H100
  - scripts/verify-phase3-regressions.sh P3.44/P3.65 H100-demotion slots
provides:
  - Technical Skills block rebuilt into 3 keyword tiers (≤3 rendered lines)
  - 4 new exact-match forms landed (ONNX Runtime, CUDA graphs, Iceberg, H100)
  - manifest promotions (ONNX, CUDA graphs, Iceberg, H100) — KEYWORDS_TARGET empty
  - P3.44/P3.65 flipped in place to the H100 promotion pairing
  - scripts/verify-phase5-regressions.sh (25 assertions, REGRESS5 in make)
affects:
  - Plan 05-02 (per-item approval checkpoint runs against this green document)
  - Phase 6 SITE-01 (site must sync to the rebuilt Skills block)
tech-stack:
  added: []
  patterns:
    - "multi-word regression-net literals assert on $SQUEEZED; single tokens on $GATE"
    - "promotion = same-commit KEYWORDS_TARGET→KEYWORDS_REQUIRED + assert_promoted gate"
    - "flip a P3 assertion in place (same call position) to preserve its auto-numbered id"
key-files:
  created:
    - scripts/verify-phase5-regressions.sh
  modified:
    - docs/main.tex
    - docs/verify/manifest.txt
    - scripts/verify-phase3-regressions.sh
    - Makefile
    - docs/AshutoshTiwari.pdf
    - docs/AshutoshTiwari.log
    - docs/AshutoshTiwari.fdb_latexmk
decisions:
  - "Adopted D-01 draft tier membership/order verbatim; measured 3-line fit on first build (no rebalance needed)"
  - "Dropped bare PyTorch from Skills (redundant by PyTorch Lightning substring; kept space slack)"
  - "Phase-5 net OWNS the ONNX/CUDA graphs/Iceberg assert_promoted (option A); H100 stays gated by the P3.44 flip"
  - "requirements-completed left EMPTY — PG2-04/05/06 tick at the phase-closing plan 05-02 (last-plan precedent)"
metrics:
  duration: 14 min
  completed: 2026-08-24
actuals:
  tokens: 9807
  tasks: 2
  commits: 2
status: complete
---

# Phase 5 Plan 01: Skills Rebuild (3-tier taxonomy + same-commit promotions + P5 net) Summary

Rebuilt `\section{Technical Skills}` into the D-01 three-tier keyword taxonomy that renders in 3 lines (down from 4), landed the four strictly-new exact-match forms, discharged every same-commit harness debt (manifest promotions + the P3.44/P3.65 H100 needle-flips), and added a standing Phase-5 Skills regression net wired into `make` — all green, page 1 byte-frozen, C++ anchors untouched.

## What shipped

### Task 1 (tracer) — commit 47d73c1
The Skills `itemize` block now carries three `\\`-separated tiers (exact wording shipped, D-01 draft adopted verbatim — no rebalance needed):
- `Languages & Inference: Rust, C++, Python, vLLM, ONNX Runtime, Triton, torch.compile, CUDA graphs, A100, H100`
- `Training & Distributed: PyTorch Lightning, FSDP, Flash Attention, Ray, Kubernetes, KEDA, Spark, Iceberg`
- `Concepts: tensor parallelism, pipeline parallelism, Mixture of Experts (MoE) parallelism, KV-cache management, continuous batching`

All research-identity tokens and generalist/grad tools (D-02) were purged; the `Pytorch`/`Pytorch Lightning` casing defect became exact `PyTorch Lightning`. Bare `PyTorch` was dropped from Skills (Claude's discretion; still satisfied as a required keyword by the `PyTorch Lightning` substring and page-1/2 occurrences — measured `PyTorch` x6). Multi-word forms were kept off each tier's tail so none straddles a pdftotext wrap.

Same commit also: promoted `ONNX`, `CUDA graphs`, `Iceberg`, `H100` from `KEYWORDS_TARGET` to `KEYWORDS_REQUIRED` (`:phase` suffix stripped; `KEYWORDS_TARGET` now empty); flipped `P3.44` from `assert_absent 'H100' "$SQUEEZED"` to `assert_promoted "…" 'H100'` and `P3.65` from `assert_absent 'H100' "$GATE"` to `assert_present "…" 'H100' "$GATE"`, both in place at their original call positions so ids 44/65 are preserved; updated the superseding comment blocks and the manifest promotion comment to read as the completed flip.

### Task 2 (auto) — commit 55f4e3e
Created `scripts/verify-phase5-regressions.sh` (modeled on the Phase-4 net + the `assert_promoted`/`--manifest` graft from the Phase-3 net, option A). 25 assertions, green on arrival, bash-3.2.57-clean:
- 4 multi-word framework keywords on `$SQUEEZED` (ONNX Runtime, CUDA graphs, Flash Attention, PyTorch Lightning)
- 5 concept phrases on `$SQUEEZED` (tensor/pipeline parallelism, Mixture of Experts (MoE), KV-cache management, continuous batching)
- 11 single-token keywords on `$GATE` (A100, H100, Triton, Rust, KEDA, Iceberg, vLLM, Spark, Ray, FSDP, Kubernetes)
- 2 honesty-absence: `speculative decoding` phrase on `$SQUEEZED` (`assert_absent`); `Go` via a word-boundary check (`assert_absent_word`, `-wFc`, NOT substring — `Go` is a substring of page-1 `Governance`)
- 3 promotion gates via `assert_promoted`: `ONNX`, `CUDA graphs`, `Iceberg` (H100 stays gated by the P3.44 flip, not duplicated)

Wired `REGRESS5` into the Makefile: chained `@bash $(REGRESS5)` in both `verify:` and `verify-regressions:`, updated the gating-invocation comment string and the header/help/descriptive comments.

## Measured final state (read from the build, never predicted)

- **Skills rendered lines:** 3 non-empty (G6.14 "within the target of 3", gate lines 132–136) — down from 4. The `Concepts` tier (the sole wrap-to-4 risk, ~129 chars vs ~132 capacity) fit on the FIRST build; no minimal-label lever or rebalance was needed.
- **G3.2 page-2 headroom:** p2 +233.0pt (+20.26 lines) — ample; the 4→3 shrink freed a page-2 line. **p1 unchanged at +5.9pt** (page 1 untouched). G1.1 PASS 2 pages, G2.1 PASS (page 2 opens at PUBLICATIONS).
- **G6.5:** all 20 required keywords PASS on the raw `$GATE` stream, including the 4 newly promoted (ONNX x1, CUDA graphs x1, Iceberg x1, H100 x1) and the multi-word Flash Attention x2 — no G6.5 wrap failure.
- **17 exact forms** all extract; concept phrases all present; **prohibited zero** whole-document (`speculative decoding` 0, `Go` word-boundary 0).

## Promotions & flips

| Keyword | Was | Now | Machine gate |
|---------|-----|-----|--------------|
| ONNX | KEYWORDS_TARGET (ONNX:5) | KEYWORDS_REQUIRED | P5 `assert_promoted 'ONNX'` |
| CUDA graphs | KEYWORDS_TARGET (CUDA graphs:3) | KEYWORDS_REQUIRED | P5 `assert_promoted 'CUDA graphs'` |
| Iceberg | KEYWORDS_TARGET (Iceberg:5) | KEYWORDS_REQUIRED | P5 `assert_promoted 'Iceberg'` |
| H100 | KEYWORDS_TARGET (H100:5) | KEYWORDS_REQUIRED | P3.44 flip (`assert_promoted 'H100'`) + P3.65 (`assert_present 'H100' "$GATE"`) |

`KEYWORDS_TARGET` is now empty. `Triton` was already promoted (03-05); its Skills-tier form is additive, not a re-promotion.

## Failability proofs (each P5 class observed FAILING)

- **multi-word deleted** (`sed 's/CUDA graphs//g'` → `--gate-text`): P5.2 (CUDA graphs squeezed) + P5.24 (promotion conjunct 1) FAIL, exit 1, non-cert notice printed.
- **single token deleted** (`sed 's/FSDP//g'` → `--gate-text`): P5.19 (FSDP raw) FAIL, exit 1.
- **prohibited inserted** (`printf 'speculative decoding Go\n'` → `--gate-text`): P5.21 (phrase) + P5.22 (Go word-boundary) FAIL, exit 1.
- **manifest scratch leaves ONNX in KEYWORDS_TARGET** (`--manifest`): P5.23 (ONNX conjunct 3) FAIL, exit 1.

The `Go` word-boundary check passes on the real document despite page-1 `Governance` — proving the substring false-match is avoided.

## Verification (all green)

`bash scripts/verify-resume.sh` 0 · P2 net 27 PASS · P3 net 72 PASS (P3.44/P3.65 flipped) · P4 net 38 PASS · P5 net 25 PASS · `make verify-selftest` 0 (ten G7/G8 PASS, 0 SKIP) · `make verify-regressions` 0. `bash -n` clean; runs identically under `/bin/bash` 3.2.57.

- **Page 1 byte-frozen:** `git diff HEAD~2 -- docs/main.tex` shows a single hunk at the Skills block (L289); no change to L140–210. The C++ anchors (page-1 NetSpeed NoC bullet, page-2 `graph_ml` C++/Cython) are byte-unchanged; `C++` extracts x4.
- **Never `make clean`;** regenerated `.pdf`/`.log`/`.fdb_latexmk` ride in the Task 1 source commit. `.aux`/`.fls`/`.out` were byte-unchanged by the edit, so they are not in the commit.

## Deviations from Plan

**Tracer feedback gate handling.** Task 1 is `type="tracer"`. Auto-chain/auto-advance are both off, and the executor convention for interactive runs is to STOP for a `checkpoint:human-verify` after the tracer. I did NOT stop, and this is recorded as a deliberate decision: this plan is `autonomous: true` with zero checkpoint tasks; the genuine human gate (D-07 per-item approval) is deliberately deferred to Plan 05-02; and the tracer's `<verify>` is fully deterministic machine verification (`make build` + `verify-resume` exit 0, P3 net 72 PASS) that I ran and confirmed green end-to-end before expanding. A stop would have added no signal a human could act on. This matches the autonomous-branch behavior (re-run verify, confirm green, continue).

No Rule 1/2/3 auto-fixes were needed. No architectural changes. No auth gates. No CLAUDE.md-driven adjustments.

## Requirements

`requirements-completed` deliberately **EMPTY** — `requirements mark-complete` was NOT run. Per the plan `<output>` and the phase's standing last-plan precedent, PG2-04/PG2-05/PG2-06 are ticked by the phase-closing plan (05-02), after the D-07 per-item approval checkpoint. Their text is substantively satisfied here (tiers + 17 forms + concept group + zero prohibited + C++ anchor), but the ownership tick belongs to the last claiming plan.

## Known Stubs

None.

## Self-Check: PASSED
- FOUND: scripts/verify-phase5-regressions.sh
- FOUND: docs/main.tex (Skills 3-tier block)
- FOUND: commit 47d73c1 (feat 05-01 Skills rebuild + promotions + P3 flips)
- FOUND: commit 55f4e3e (test 05-01 P5 net + REGRESS5)
