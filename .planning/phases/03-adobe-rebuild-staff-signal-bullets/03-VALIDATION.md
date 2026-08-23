---
phase: 3
slug: adobe-rebuild-staff-signal-bullets
status: planned
nyquist_compliant: true
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
| T1 net scaffold + retention group | 03-01 | 1 | EXP-02c | T-03-01/03 | assertion strengthened, never weakened; T-1 silent-death fixed | bash | `/bin/bash scripts/verify-phase3-regressions.sh` (exit 0) | ➕ created | ⬜ pending |
| T2 six new-content groups | 03-01 | 1 | EXP-02a/b, EXP-03, EXP-04, EXP-07, EXP-08 | T-03-02/04 | red on arrival, every FAIL owned; promotion whole-field match | bash | net exits 1, every FAIL tagged `/03-0[456]` | ➕ created | ⬜ pending |
| T3 crafted negative controls | 03-01 | 1 | all five | T-03-01/05 | retention, absence and promotion classes each observed failing | bash | fixture + scratch-manifest runs exit 1 | ➕ created | ⬜ pending |
| T1 make target + WARN claim | 03-02 | 1 | EXP-02, EXP-07 (IG-01/IG-03) | T-03-08/09/10 | no waiver flag in any recipe; one manifest line changed | make + bash | `make verify-regressions` (27 PASS); five `G6.13 owner: Phase 3` | ✅ | ⬜ pending |
| T2 canonical-surface record | 03-02 | 1 | EXP-02 (IG-02) | T-03-12 | site duplicate handed forward, not silently ignored | grep | `grep -F 'index.html:196' .planning/STATE.md` | ✅ | ⬜ pending |
| T1 disposition table | 03-03 | 1 | EXP-02 | T-03-13 | no true claim dropped implicitly; written before any text edit | grep + git | needle sweep over the record; `git log` ordering | ➕ created | ⬜ pending |
| T2 traceability + budget ledger | 03-03 | 1 | EXP-04, EXP-07 | T-03-14/17 | every figure cites an evidence line; ceiling and rails fixed | grep | figure/threshold needle sweep | ➕ created | ⬜ pending |
| T3 EXP-08 drafts | 03-03 | 1 | EXP-08 | T-03-15/16 | drafts absent from main.tex; magnitudes evidence-implied only | bash | `grep -Fc` per needle in `docs/main.tex` = 0; P3 EXP-08 group PASS | ➕ created | ⬜ pending |
| T1 lead-bullet voice | 03-04 | 2 | EXP-02 | T-03-18/22 | frozen cells byte-identical; 2 pages; line-neutral | gate + regression | `bash scripts/verify-resume.sh`; P3 EXP-02a PASS | ✅ | ⬜ pending |
| T2 governance topic | 03-04 | 2 | EXP-02 | T-03-19/24 | Rust ≥2; never framed as inference optimization | gate + regression | P3 EXP-02b group PASS incl. framing slice | ✅ | ⬜ pending |
| T3 mechanisms, figures, A100/H100 promotion | 03-04 | 2 | EXP-02, EXP-04 | T-03-20/23/25 | promotion suffix stripped; no line freed; glyphs declared | gate + regression | `G6.5` 15 PASS; `G6.4` PASS; `make verify-selftest` | ✅ | ⬜ pending |
| T1 D-08 config read | 03-05 | 3 | EXP-03 | T-03-26 | CUDA-graph clause only on a confirmed read; fallback pre-authorized | checkpoint | `grep -Fc '[Phase 3 / D-08]' .planning/STATE.md` = 1 | ✅ | ⬜ pending |
| T2 retire figures, land Ray benchmark | 03-05 | 3 | EXP-04 | T-03-27/28 | EN-DASH + source-form absence; attribution safety MACHINE-asserted, not reviewer judgment | gate + regression | P3 EXP-04 group PASS incl. the `EXP-04d/03-05` attribution pair; `grep -Ec '10--50\|3--8K' docs/main.tex` = 0; `grep -Fci achiev docs/main.tex` = 0 | ✅ | ⬜ pending |
| T3 torch.compile bridge + promotion | 03-05 | 3 | EXP-03 | T-03-29/30/31/32 | branch-matched wording; promotion paired in one commit; Triton unconditional | gate + regression | `G6.5 'torch.compile'` + `'Triton'` PASS, `G6.5` 17 PASS; P3 promotion triples PASS | ✅ | ⬜ pending |
| T3 branch-conditional Class E CUDA absence | 03-05 | 3 | EXP-03 | T-03-26b | on `triton-only-fallback` the bridge names no CUDA graphs — asserted, never prose; needle appended in the SAME commit as the wording and proven failable by a crafted `--gate-text` fixture | regression | `EXP-03c/03-05` pair PASS; `grep -Fci CUDA docs/main.tex` = 0; control run exits 1 naming the P3 ID | ➕ appended | ⬜ conditional |
| T1 Swiggy pass | 03-06 | 4 | EXP-07 | T-03-34/35/37 | `fault` and `Spark` survive; region line count identical | gate + regression | `G6.5 'fault'`/`'Spark'` PASS; `G5.4` ≥8 | ✅ | ⬜ pending |
| T2 Flipkart pass | 03-06 | 4 | EXP-07 | T-03-36/38/39 | closure by entailment only; no invented metric | gate + regression | `bash scripts/verify-phase3-regressions.sh` exit 0 | ✅ | ⬜ pending |
| T1 evidence packet | 03-07 | 5 | EXP-08 | T-03-42/43 | decision taken against a proven-green document | gate | all four suites green before the ask | ➕ created | ⬜ pending |
| T2 per-bullet sign-off | 03-07 | 5 | EXP-08 | T-03-40/41/44, T-03-44b | absence is the default; silence is not approval; criterion-2 judgment captured, never assumed | checkpoint | `grep -Fc '[Phase 3 / EXP-08]' .planning/STATE.md` = 1; `grep -Fc 'staff-signal:'` ≥ 1 reading `yes` or `no — <change>` | ✅ | ⬜ pending |
| T1 apply approved / assert rejected | 03-08 | 6 | EXP-08, EXP-02 | T-03-45/46/47/48/49 | both outcomes asserted; rejected pairs never deleted; Branch C bounded to the named change | regression | P3 net exit 0; P2 net 27 **anchored** `^RESULT P2\..*PASS` lines (never a bare PASS count — 28 lines match); Branch C writes the `EXP-02 tick rests on the applied revision` marker | ✅ | ⬜ pending |
| T2 wire the P3 net into make | 03-08 | 6 | EXP-02..08 | T-03-50 | Phase 3 does not recreate IG-01 for its own net | make | `make -n verify` shows both nets | ✅ | ⬜ pending |
| T3 end-state record + checkboxes | 03-08 | 6 | all five | T-03-51/52, T-03-51b | no requirement ticked without a green suite; EXP-02 never ticked against a negative read; WR-01 measured not claimed | gate + grep | all five suites green; markers singular; EXP-02 checkbox clause admits only `yes`, or `no` + gap record on BOTH STATE.md and ROADMAP, or `no` + the Branch C revision marker | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky · ⬜ conditional = fires only on one D-08 branch. `➕ created` = the file is produced by that task; `➕ appended` = added to an existing Wave-0 file by that task. The `Class E CUDA absence` row is a branch-conditional sub-obligation of 03-05 Task 3, not a 22nd task — the task count stays 21. RESEARCH.md §Validation Architecture carries the full 20-row requirement→test map this table expands on; threat refs resolve in each plan's `<threat_model>`.*

---

## Wave 0 Requirements

Wave 0 is folded into **wave 1**, which runs three plans in parallel over disjoint file sets:

- [ ] `Makefile` — `verify-regressions` target (PHONY) exposing `scripts/verify-phase2-regressions.sh`, chained first in `verify` (IG-01) → **03-02 Task 1**
- [ ] `docs/verify/manifest.txt` — `WARN_OWNERS` `G6.13:unassigned` → `G6.13:3` (IG-03/WR-01 claim) → **03-02 Task 1**
- [ ] `scripts/verify-phase3-regressions.sh` — P3.x standing net mirroring the P2 pattern (dual gate/squeezed streams plus a fourth `--manifest` stream, bash-3.2-safe, shellcheck-clean, negative controls per class) → **03-01 Tasks 1-3**
- [ ] `03-DECISION-RECORD.md` — criterion-1 disposition, figure→evidence traceability, budget ledger, EXP-08 drafts (the spend authority waves 2-4 read) → **03-03 Tasks 1-3**

The P3 net is deliberately **red on arrival**: its new-content and retirement assertions fail against the pre-rebuild artifact, which is simultaneously their anti-tautology negative control (Phase 1's proven design). Retention, EXP-08-absence and promotion classes pass on arrival and are proven failable by crafted fixtures in 03-01 Task 3. Plans 03-04, 03-05 and 03-06 drive the FAIL census to zero; the net exits 0 from the end of 03-06 onward. `scripts/verify-phase3-regressions.sh` is wired into `make` in **03-08 Task 2** — once green, so `make verify` is never red for a whole phase.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| D-08 CUDA-graphs config read | EXP-03 | Evidence lives in the user's ~/code/genie checkout, not this repo | Confirm `glimmer/modules/dp/content_type_classifier/module.py:76-77` compile config carries no `max-autotune-no-cudagraphs` / `triton.cudagraphs=False`; record outcome; fallback = bridge-minus-CUDA-graphs wording |
| EXP-08 per-bullet sign-off | EXP-08 | Honesty gate requires explicit human approval | Blocking checkpoint:decision after Adobe rebuild verified green; review drafts against rendered PDF; per-bullet approve/reject recorded in SUMMARY |
| Criterion-2 qualitative half | EXP-02 | "Opens on fault-tolerance/distributed-inference language rather than job-description voice" is a judgment call | Read the rendered lead bullet at the 03-07 T2 checkpoint and answer as a literal `staff-signal: yes` or `staff-signal: no — <what still reads as job description, and what it should say instead>` token, recorded in the `[Phase 3 / EXP-08]` STATE.md bullet. Literals are machine-asserted (P3 `EXP-02a` lead anchor); voice is not. The token is not advisory: on `no` with an actionable change, 03-08 T1 **Branch C** applies exactly that change line-neutrally and writes the `EXP-02 tick rests on the applied revision` marker; otherwise 03-08 T3 leaves EXP-02 unticked and records `EXP-02 qualitative gap` on both STATE.md and the ROADMAP Phase 3 entry |

---

## Validation Sign-Off

- [x] All tasks have `<automated>` verify or Wave 0 dependencies — 21/21 tasks carry an `<automated>` command
- [x] Sampling continuity: no 3 consecutive tasks without automated verify
- [x] Wave 0 covers all MISSING references (folded into wave 1; the P3 net is red on arrival by design)
- [x] No watch-mode flags (`latexmk -pvc` appears in no verify path)
- [x] Feedback latency < 25s (quick ~5s, full ~20s)
- [x] Every new P3 assertion class observed FAILING (03-01 Task 2 for new-content, retirement and the `EXP-04d` attribution needle — all red on arrival; 03-01 Task 3 for retention/absence/promotion; 03-05 Task 3 for the branch-conditional Class E `CUDA` needle, which passes on arrival and therefore carries its own crafted control)
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** planned — 8 plans, 6 waves, 21 tasks; 2 blocking checkpoints (D-08 config read at 03-05 T1, EXP-08 sign-off at 03-07 T2)
