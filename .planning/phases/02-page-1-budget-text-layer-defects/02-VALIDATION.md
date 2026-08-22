---
phase: 02
slug: page-1-budget-text-layer-defects
status: complete
nyquist_compliant: true
wave_0_complete: true
created: 2026-08-22
reconstructed: true
reconstructed_from: [02-01-PLAN.md, 02-01-SUMMARY.md, 02-02-PLAN.md, 02-02-SUMMARY.md, 02-VERIFICATION.md]
---

# Phase 02 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.
> Reconstructed retroactively from phase artifacts (phase executed before a VALIDATION.md existed), then gap-audited and filled.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | bespoke bash gate harness (no pytest/jest) — `scripts/verify-resume.sh` (gates G0–G8, 83 RESULT lines, 39 IDs) driven by `docs/verify/manifest.txt` + `docs/verify/baseline-frozen.txt`; plus `scripts/verify-phase2-regressions.sh` (P2.1–P2.27) |
| **Config file** | `docs/verify/manifest.txt` (mutable thresholds) + `docs/verify/baseline-frozen.txt` (honesty freeze) |
| **Quick run command** | `bash scripts/verify-phase2-regressions.sh` |
| **Full suite command** | `bash scripts/verify-resume.sh && bash scripts/verify-phase2-regressions.sh && make verify-selftest` |
| **Estimated runtime** | quick <1s · harness ~3s · self-test ~14s (~18s full) |

Requires poppler (`pdftotext`, `pdfinfo`). Exit vocabulary (both scripts): 0 = pass, 1 = document wrong, 2 = cannot verify. Never gate on `make verify` — GNU Make 3.81 collapses exit 1/2 to its own 2. Never `make clean` before verifying — it deletes the `.fdb_latexmk` record `G0.3` reads.

---

## Sampling Rate

- **After every task commit:** Run `bash scripts/verify-resume.sh && bash scripts/verify-phase2-regressions.sh`
- **After every plan wave:** Run the full suite command (adds `make verify-selftest`)
- **Before `/gsd-verify-work`:** Full suite must be green
- **Max feedback latency:** 20 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 02-01-T1 | 01 | 1 | EXP-06 | T-02-05 / T-02-06 | display-text-only change; `\href` targets byte-identical; no words outside page box | gate | `bash scripts/verify-resume.sh` (G6.9 ×4, G6.10, G3.4, G4.1) | ✅ | ✅ green |
| 02-01-T2 | 01 | 1 | EXP-01a (career-break removal) | T-02-01 / T-02-02 | honesty freeze intact through deletion; `docs/verify/` untouched | gate + regression | `bash scripts/verify-resume.sh` (G5.1/G5.2/G5.5 ×15) + `bash scripts/verify-phase2-regressions.sh` (P2.1–P2.6) | ✅ | ✅ green |
| 02-01-T3 | 01 | 1 | EXP-05 (fold + locked literals) | T-02-01 / T-02-03 / T-02-06 | frozen strings extract whole-line ×1 after fold; no geometry lever (`\setlist`/`\addtolength`/`\usepackage`) | gate + regression | `bash scripts/verify-resume.sh` (G5.* ×15, G2.3, G3.4, G6.8) + `bash scripts/verify-phase2-regressions.sh` (P2.7–P2.27) | ✅ | ✅ green |
| 02-02-T1 | 02 | 2 | EXP-01b (D-09 city cells) | T-02-11 / T-02-14 | Education dates protected without a city anchor (`EDU_DATE` + `EDU_BIND_WINDOW`); nothing new published | gate | `bash scripts/verify-resume.sh` (G6.12 window clause) | ✅ | ✅ green |
| 02-02-T2 | 02 | 2 | EXP-01b (institution-first clause) | T-02-07 / T-02-08 | assertion strengthened, never weakened — anchor-free clause proven to FAIL on pre-change artifact (negative control); `EDU_CITY` key + reader removed together | gate | `bash scripts/verify-resume.sh` (G6.12 anchor-free) | ✅ | ✅ green |
| 02-02-T3 | 02 | 2 | EXP-01 (closure: green gate) | T-02-09 / T-02-12 / T-02-13 | thresholds unmoved (`PROBE_LINES=5` raise-only); freshness provable from clean checkout; `--skip-freshness` absent from Makefile | gate + self-test | `make verify-selftest` (G7.1–4 + G8.1–6 = 10 PASS) + `bash scripts/verify-resume.sh` (G0.3) | ✅ | ✅ green |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

All six tasks carried `<verify><automated>` blocks in their plans and were verified green during execution (02-VERIFICATION.md: passed, 20/20 must-haves). Statuses above re-confirmed live on 2026-08-22 (audit run): harness exit 0 / 0 FAIL, regressions 27 PASS / exit 0, self-test exit 0.

---

## Wave 0 Requirements

Phase executed before this document existed; no Wave 0 ran. Retroactive equivalent (this audit):

- [x] `scripts/verify-phase2-regressions.sh` — standing regression net for EXP-01a + EXP-05b (P2.1–P2.27)

Existing infrastructure (`scripts/verify-resume.sh` + manifest/baseline) covers all other phase requirements.

---

## Manual-Only Verifications

All phase behaviors have automated verification.

---

## Validation Sign-Off

- [x] All tasks have `<automated>` verify or Wave 0 dependencies
- [x] Sampling continuity: no 3 consecutive tasks without automated verify
- [x] Wave 0 covers all MISSING references (retroactive: P2 regression net)
- [x] No watch-mode flags
- [x] Feedback latency < 20s
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** approved 2026-08-22

---

## Validation Audit 2026-08-22

| Metric | Count |
|--------|-------|
| Gaps found | 2 |
| Resolved | 2 |
| Escalated | 0 |

**Gap detail (both MISSING-tier — invariants held but had no standing automated test, only one-time execution-phase greps):**

1. **EXP-01a** — career-break absence + ADOBE FIREFLY → SWIGGY adjacency. Harness referenced the career break only in comments; `CAREER_BREAK_PT` has zero readers; a re-inserted 48.9pt row fits inside the +50.5pt page-1 slack, so no G-gate would have fired. → Resolved by `scripts/verify-phase2-regressions.sh` P2.1–P2.6 (incl. additive P2.5: the deleted row's employer cell `Indiana University, Bloomington` must not reappear between the two anchors — the `[employers]`-driven adjacency loop alone would miss it).
2. **EXP-05b** — locked D-05/D-06 descriptor literals (4 module names, `Network-on-Chip`, descriptor-unique `C++ graph algorithms` anchor, `NSVD`, `Neo4j`, `Cyclops`, `customer-service platform`, `live in every Groupon country`, `customer segmentation`) + forbidden merged/shortened forms. ROADMAP Phase 5 criterion 4 depends on the C++/NoC anchor surviving; no standing gate asserted it. → Resolved by P2.7–P2.27 (wrap-proof: multi-word literals against a whitespace-squeezed stream, short tokens also against raw lines).

**Regression-net properties (auditor-verified):** deterministic; bash 3.2-safe; `shellcheck -f gcc` 0 findings; `P2.` ID namespace cannot collide with harness `G` gates; exit 2 ("cannot verify") on missing pdftotext/PDF/anchors with 0 RESULT lines — never a silent pass; negative controls proved every assertion class can FAIL (descriptor deletion → 7 FAIL, career-break re-insertion → 3 FAIL, date deletion → 1 FAIL, merged forms → 5 FAIL, inverted role order and absent anchors → unmeasurable FAIL, not PASS). Caveats recorded in-file: P2.19–P2.23 guard the `tr` normalization step (equivalent to squeezed counterparts for whitespace-free needles); bare `C++` (P2.22) is vacuous alone — P2.12 is the load-bearing anchor; the net asserts content only, freshness stays `G0.3`'s.
