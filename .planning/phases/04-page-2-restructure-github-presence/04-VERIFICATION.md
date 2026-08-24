---
phase: 04-page-2-restructure-github-presence
verified: 2026-08-24T00:00:00Z
status: passed
score: 7/7 must-haves verified
behavior_unverified: 0
overrides_applied: 0
owner_deferrals:  # LOCKED owner decisions (CONTEXT.md D-08 / D-05) — recorded, NOT gaps
  - id: GH-01
    decision: "privatize random_walk DEFERRED (D-08, resume-only). Repo unlinked from résumé → no click-through impact. Ready command preserved."
  - id: GH-02
    decision: "fix rollout README stale status DEFERRED (D-08, resume-only). Accepted trade-off: featured rollout link still reads 'spec / pre-implementation'. Ready fix preserved."
  - id: D-05
    decision: "Teaching kept as 3 TA items — intentional override of ROADMAP criterion 4's 'Teaching → one line'. Machine-guarded by P4.36 assert_count == 3."
---

# Phase 4: Page-2 Restructure & GitHub Presence — Verification Report

**Phase Goal:** Page 2 leads with current, click-through-safe artifacts instead of seven grad-school entries, and every repo it links to says what the resume says.
**Verified:** 2026-08-24
**Status:** passed (with GH-01/GH-02 correctly recorded as owner deferrals per D-08)
**Re-verification:** No — initial verification

## Goal Achievement

The verifiable phase deliverables are all present and enforced in the built artifact and source. The one goal clause knowingly not fully met — "every repo it links to says what the resume says" (the `rollout` README still reads the stale status) — is an explicit, documented owner deferral (D-08), not a verification failure.

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | PG2-01: Selected Projects = exactly `rollout` + `graph_ml` (spike Variant A verbatim); all seven 2017–2022 grad entries gone; `residual2vec_` not re-featured as a project; `C++/Cython` present | ✓ VERIFIED | Source: `\resumeProjectHeading` count = 3 (1 preamble def + 2 uses); block is byte-verbatim spike Variant A (only the documented `graph\_ml` display-underscore escape). Text layer: `rollout`/`graph_ml`/both `github.com/thunderock/...` URLs present, `C++/Cython`=1; BiasNet/DeepFoodie/BlindNet/Continuous Dominant Set/Humana/AnalyticsVidhya/Bias Manifolds all 0; `residual2vec` only in the Publications Poster href (not a project heading) |
| 2 | PG2-02: Publication = first-author citation + venue links + Poster link + ONE fairness-aware-graph-ML contribution line; abstract paragraph cut | ✓ VERIFIED | Text layer: `first author`/`NetSci 2023`/`IC2S2 2023`/`Poster` each =1; `fairness-aware graph representation learning`=1; `In this work, we propose`=0 in both text layer and source |
| 3 | PG2-03: Research one line (all three threads); Education institution-first, GPAs + IU city dropped, both date ranges retained, manifest synced, G6.12 green; Teaching unchanged (D-05) | ✓ VERIFIED | Research section body has exactly 1 `\resumeItem` covering IUNI/User Intent as a Network/NLP Lab/TieML (all present in text layer). Education: `3.87/4.0`=0, `8.32/10.0`=0, `Indiana University, Bloomington`=0, `Indiana University`=1, both `Aug. 2021`/`Aug. 2011` present; `EDU_INSTITUTION=Indiana University`; G6.12 PASS. Teaching: 3× `Teaching Assistant`, `INFO-I 606`/`CSCI-B 555` present; no Teaching hunk in `git diff 798c0fb` |
| 4 | Page 1 byte-identical to `798c0fb` | ✓ VERIFIED | `git diff 798c0fb -- docs/main.tex` hunks at lines 221, 232, 255, 275 — all ≥ `\newpage` (line 213); no page-1 Experience line changed |
| 5 | All five suites green; PDF exactly 2 pages, page 2 opens at PUBLICATIONS | ✓ VERIFIED | verify-resume.sh exit 0, 0 FAIL/BLOCKER, G0.3/G1.1/G2.1/G6.12 PASS; P2=27 PASS; P3=72 PASS; P4=38 PASS/0 FAIL; verify-selftest exit 0, 10 G7/G8 PASS, 0 anchored SKIP; `pdfinfo` Pages=2; PDF mtime newer than source |
| 6 | The P4 net genuinely guards page-2 content and its assertions are failable | ✓ VERIFIED | Crafted `--gate-text` controls each returned exit 1: reinserting `BiasNet` → P4.6 FAIL (absent-class); dropping `rollout` → P4.1+P4.3 FAIL (present-class); reinserting abstract clause → P4.22 FAIL; adding a 4th `Teaching Assistant` → P4.36 FAIL (count-class). `--gate-text` prints the non-certification note |
| 7 | GH-03: `rollout` capability wording confirmed ("walk me through it") and shipped | ✓ VERIFIED | rollout bullet owner-confirmed during discuss-phase (D-01), shipped verbatim in Plan 04-01 Task 3 (present in source + text layer); REQUIREMENTS.md marks GH-03 Complete; make verify passes |

**Score:** 7/7 truths verified (0 present, behavior-unverified)

### Owner Deferrals (recorded per CONTEXT.md — NOT gaps)

| ID | ROADMAP criterion | Decision | Evidence |
|----|-------------------|----------|----------|
| GH-01 | 3 (random_walk 404) | DEFERRED (D-08, resume-only) — unlinked from résumé, zero click-through impact; ready `gh api -X PATCH` command preserved | REQUIREMENTS.md line 38 "Deferred (D-08)"; ROADMAP traceability row; CONTEXT Deferred Ideas |
| GH-02 | 2 (rollout README status) | DEFERRED (D-08, resume-only) — accepted trade-off: featured link still reads "spec / pre-implementation"; ready fix preserved | REQUIREMENTS.md line 39 "Deferred (D-08)"; ROADMAP traceability row; CONTEXT Deferred Ideas |
| D-05 | 4 (Teaching → one line) | OVERRIDDEN — Teaching kept as 3 TA items; machine-guarded by P4.36 `assert_count 'Teaching Assistant' == 3` | ROADMAP Phase-4 note; 04-01-SUMMARY Deviations; P4 net |

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `docs/main.tex` | page-2 restructured, page 1 frozen | ✓ VERIFIED | All 4 edits landed; diff hunks page-2-only (≥213) |
| `docs/verify/manifest.txt` | EDU_INSTITUTION synced | ✓ VERIFIED | `EDU_INSTITUTION=Indiana University`, `EDU_DATE` unchanged |
| `docs/AshutoshTiwari.pdf` | rebuilt, 2 pages | ✓ VERIFIED | 2 pages, opens at PUBLICATIONS, newer than source, G0.3 fresh |
| `scripts/verify-phase4-regressions.sh` | NEW page-2 net (P4.x) | ✓ VERIFIED | Executable, 38 PASS/0 FAIL, failable per class |
| `Makefile` | REGRESS4 wired | ✓ VERIFIED | `REGRESS4` defined (L32); `@bash $(REGRESS4)` in `verify` (L200) + `verify-regressions` (L234) |

### Key Link Verification

| From | To | Via | Status |
|------|----|----|--------|
| manifest `EDU_INSTITUTION` | G6.12 institution-first clause | synced in same commit as D-06 edit | ✓ WIRED (G6.12 PASS, institution first non-empty EDU line) |
| rollout/graph_ml `\href` anchors | literal URLs in pdftotext layer | text-layer extraction | ✓ WIRED (both `github.com/thunderock/...` URLs present) |
| page-1 freeze (≤213) | P2/P3 nets staying green | untouched page-1 guards | ✓ WIRED (P2=27, P3=72, no page-1 hunk) |

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|----------|---------|--------|--------|
| All 5 suites green | run each net directly | resume=0, P2=27, P3=72, P4=38/0, selftest=0/10 | ✓ PASS |
| P4 net failable (absent) | `--gate-text` + BiasNet | exit 1, P4.6 FAIL | ✓ PASS |
| P4 net failable (present) | `--gate-text` − rollout | exit 1, P4.1+P4.3 FAIL | ✓ PASS |
| P4 net failable (abstract) | `--gate-text` + abstract clause | exit 1, P4.22 FAIL | ✓ PASS |
| P4 net failable (count) | `--gate-text` + 4th TA | exit 1, P4.36 FAIL | ✓ PASS |

### Requirements Coverage

| Requirement | Source Plan | Status | Evidence |
|-------------|-------------|--------|----------|
| PG2-01 | 04-01 | ✓ SATISFIED | Projects = rollout + graph_ml; seven gone; C++/Cython present |
| PG2-02 | 04-01 | ✓ SATISFIED | citation + venue/Poster + one fairness-aware line; abstract cut |
| PG2-03 | 04-01 | ✓ SATISFIED | Education tightened + G6.12 green; Research one line; Teaching kept (D-05) |
| GH-01 | 04-02 | ⏸ DEFERRED | Owner decision D-08 (recorded, not ticked) |
| GH-02 | 04-02 | ⏸ DEFERRED | Owner decision D-08 (recorded, not ticked) |
| GH-03 | 04-02 | ✓ SATISFIED | rollout wording owner-confirmed, shipped verbatim |

### Anti-Patterns Found

None. No fabricated perf/throughput numbers in the rollout/graph_ml bullets (claims are structural tree facts: crate/test-file counts, algorithm names, C++/Cython kernels). No debt markers introduced. The single auto-fix (`graph\_ml` display-underscore escape) is documented in 04-01-SUMMARY and does not alter the rendered text layer.

### Gaps Summary

No goal-blocking gaps. All seven verifiable must-have truths are backed by codebase evidence. The two GitHub-mutation criteria (ROADMAP 2 & 3 / GH-01 & GH-02) and the Teaching-compression criterion (ROADMAP 4) are explicit, documented owner decisions (D-08, D-05) recorded across CONTEXT.md, REQUIREMENTS.md, ROADMAP.md and both SUMMARYs — per the verification context these are owner-deferred/overridden, not failures. The residual goal clause "every repo it links to says what the resume says" is knowingly unmet this phase (rollout README stale) as an accepted trade-off with a turnkey ready-fix preserved.

---

_Verified: 2026-08-24_
_Verifier: Claude (gsd-verifier)_
