---
phase: 5
slug: skills-rebuild
# status lifecycle: draft (seeded by plan-phase) → validated (set by validate-phase §6)
# audit-milestone §5.5 distinguishes NOT-VALIDATED (draft) from PARTIAL (validated + nyquist_compliant: false) (#2117)
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-08-24
---

# Phase 5 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | LaTeX build + bash verification harness (no pytest/jest — this is a resume artifact) |
| **Config file** | `docs/verify/manifest.txt` (keywords, thresholds, gate params) |
| **Quick run command** | `make build && bash scripts/verify-resume.sh` |
| **Full suite command** | `bash scripts/verify-resume.sh && bash scripts/verify-phase2-regressions.sh && bash scripts/verify-phase3-regressions.sh && bash scripts/verify-phase4-regressions.sh && bash scripts/verify-phase5-regressions.sh && make verify-selftest` |
| **Estimated runtime** | ~5–15 seconds (LaTeX build + greps) |

> Gate on the scripts **directly** (exit 0), never on `make verify` alone — GNU Make 3.81 collapses exit 1 and exit 2 into its own exit 2, so it cannot distinguish "document is wrong" from "cannot verify" (standing rule from Phases 1–4).

---

## Sampling Rate

- **After every task commit:** `make build && bash scripts/verify-resume.sh` (read the RESULT lines; re-measure `G3.2` page-2 headroom + `G6.14` skills-line count)
- **After every plan wave:** run the full suite command above (all regression nets + self-test)
- **Before the per-item approval checkpoint:** full suite must be green (green-first, per the EXP-08 model)
- **Max feedback latency:** ~15 seconds

---

## Per-Task Verification Map

*Seed — the planner populates one row per task from PLAN.md frontmatter. Every task that edits `docs/main.tex` or a harness surface maps to a harness gate or a P5.x regression assertion.*

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 5-01-01 | 01 | 1 | PG2-04 | — | N/A (static document) | harness | `bash scripts/verify-resume.sh` (G6.5 keywords, G6.14 ≤3 lines) | ✅ | ⬜ pending |
| 5-01-02 | 01 | 1 | PG2-04/05/06 | — | N/A | regression | `bash scripts/verify-phase5-regressions.sh` (new net, --gate-text failable) | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `scripts/verify-phase5-regressions.sh` — the new Phase-5 content regression net (P5.x): multi-word literals (`CUDA graphs`, `Flash Attention`, `ONNX Runtime`, `PyTorch Lightning`) asserted on `$SQUEEZED`; single tokens (`A100`, `H100`, `Triton`, `Rust`, `KEDA`, `Iceberg`, `vLLM`) on `$GATE`; the 5 concept-vocab items; `speculative decoding`/`Go` absence; each assertion class proven failable with `--gate-text`. Wired into `make`.

*The core harness (`verify-resume.sh`, `manifest.txt`, self-test) and the P2/P3/P4 nets already exist from Phases 1–4 — no new framework install. The only new validation artifact is the P5 net above.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Per-item interview-defensibility of each stretch skill (5 Concepts, Iceberg, H100, CUDA graphs, ONNX Runtime, PyTorch Lightning) | PG2-04, PG2-05 (criterion 5) | Interview-defensibility is human judgment the harness cannot assert; a blanket "looks good" is the documented failure mode | Blocking `checkpoint:decision` (EXP-08 model): present each stretch item + its proposed evidence tier (built/operated/evaluated) against the rendered PDF; record one verdict per item; no auto-advance |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify (harness gate / P5.x assertion) or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references (the P5 net)
- [ ] No watch-mode flags
- [ ] Feedback latency < 15s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
