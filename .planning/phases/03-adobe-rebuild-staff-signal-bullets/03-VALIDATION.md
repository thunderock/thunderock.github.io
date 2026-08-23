---
phase: 3
slug: adobe-rebuild-staff-signal-bullets
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-08-22
---

# Phase 3 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | bash gates (no pytest/jest): `scripts/verify-resume.sh` (G0–G8, 83 RESULT lines / 39 IDs) + `make verify-selftest` (10 G7/G8 inverted controls) + `scripts/verify-phase2-regressions.sh` (P2.1–P2.27) + Wave-0 `scripts/verify-phase3-regressions.sh` (P3.x) |
| **Config file** | `docs/verify/manifest.txt` + `docs/verify/baseline-frozen.txt` |
| **Quick run command** | `make build && bash scripts/verify-resume.sh && bash scripts/verify-phase2-regressions.sh` |
| **Full suite command** | quick command + `bash scripts/verify-phase3-regressions.sh && make verify-selftest` |
| **Estimated runtime** | quick ~5s · full ~20s |

Never gate on `make verify` (Make 3.81 collapses exit 1/2); never `make clean` (deletes G0.3 record); `--skip-freshness`/`--gate-text` never enter a Makefile recipe. Read order after each build: G1.1 → G2.1 → record G3.2 p1 headroom → G5.4/G6.5/G6.6/G6.4.

---

## Sampling Rate

- **After every task commit:** Run the quick run command (+ P3 net once it exists)
- **After every plan wave:** Run the full suite command; check G7.2 margin = 57.5pt − G3.2 p1 slack (spending grows the margin; net-freeing ≥1 line reddens it)
- **Before `/gsd-verify-work`:** Full suite must be green
- **Max feedback latency:** 25 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| TBD (planner fills) | — | 0 | IG-01/IG-03 wiring | — | regressions target added without weakening any gate | make + bash | `make verify-regressions` | ❌ W0 | ⬜ pending |
| TBD (planner fills) | — | — | EXP-02 | — | frozen Adobe title/date/employer byte-identical (G5) | gate | `bash scripts/verify-resume.sh` | ✅ | ⬜ pending |
| TBD (planner fills) | — | — | EXP-03 | — | no unevidenced accel claims (honesty rules) | gate + regression | `bash scripts/verify-resume.sh` (G6.5 after promotion) + P3.x | ❌ W0 | ⬜ pending |
| TBD (planner fills) | — | — | EXP-04 | — | retired figures == 0; replacements evidence-traced | regression | P3.x forbidden/required literal assertions | ❌ W0 | ⬜ pending |
| TBD (planner fills) | — | — | EXP-07 | — | digit-bearing bullets ≥ 8; frozen strings intact | gate + regression | `bash scripts/verify-resume.sh` (G5.4) + P3.x | ✅/❌ W0 | ⬜ pending |
| TBD (planner fills) | — | — | EXP-08 | — | drafts absent from main.tex pre-approval; per-bullet record | checkpoint + regression | P3.x absence assertion + checkpoint:decision gate | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky. The planner replaces TBD rows with concrete task IDs from the plans; RESEARCH.md §Validation Architecture carries the full 20-row requirement→test map this table condenses.*

---

## Wave 0 Requirements

- [ ] `Makefile` — `verify-regressions` target (PHONY) exposing `scripts/verify-phase2-regressions.sh` (IG-01)
- [ ] `docs/verify/manifest.txt` — `WARN_OWNERS` `G6.13:unassigned` → `G6.13:3` (IG-03/WR-01 claim)
- [ ] `scripts/verify-phase3-regressions.sh` — P3.x standing net mirroring the P2 pattern (dual gate/squeezed streams, bash-3.2-safe, shellcheck-clean, negative controls per class)

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| D-08 CUDA-graphs config read | EXP-03 | Evidence lives in the user's ~/code/genie checkout, not this repo | Confirm `glimmer/modules/dp/content_type_classifier/module.py:76-77` compile config carries no `max-autotune-no-cudagraphs` / `triton.cudagraphs=False`; record outcome; fallback = bridge-minus-CUDA-graphs wording |
| EXP-08 per-bullet sign-off | EXP-08 | Honesty gate requires explicit human approval | Blocking checkpoint:decision after Adobe rebuild verified green; review drafts against rendered PDF; per-bullet approve/reject recorded in SUMMARY |
| Criterion-2 qualitative half | EXP-02 | "Opens on fault-tolerance/distributed-inference language rather than job-description voice" is a judgment call | Read the rendered lead bullet at the checkpoint; literals are machine-asserted, voice is not |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 25s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
