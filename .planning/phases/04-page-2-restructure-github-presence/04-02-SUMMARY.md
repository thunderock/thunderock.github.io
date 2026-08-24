---
phase: 04-page-2-restructure-github-presence
plan: 02
subsystem: verification
tags: [regression-net, verify-gates, page-2, pdftotext, makefile, github-presence, deferrals]

requires:
  - phase: 04-01
    provides: the finalized page-2 text layer + source (rollout + graph_ml Projects, trimmed Publication, one-line Research, institution-first GPA/city-free Education, unchanged Teaching) that this net asserts against
  - phase: 03
    provides: the P2/P3 regression-net idioms (emit/assert helpers, gate.txt + squeezed.txt two-stream setup, --gate-text negative control, exit vocab 0/1/2) copied verbatim here; the Makefile REGRESS/REGRESS3 wiring extended
provides:
  - scripts/verify-phase4-regressions.sh — standing page-2 content net (38 P4.x assertions), green on arrival, each class proven failable, wired into make
  - Makefile REGRESS4 chained into verify + verify-regressions
  - GH-01/GH-02 recorded as explicit owner deferrals (D-08) with ready commands; GH-03 recorded satisfied + ticked
affects: [phase-5-skills (edits page 2 at \section{Technical Skills}; the P4 net now guards PG2-01/02/03 against that edit)]

tech-stack:
  added: []
  patterns:
    - "Green-on-arrival content net: every assertion CLASS (present / absent / count) proven failable by a crafted --gate-text fixture returning exit 1 — an assertion never observed failing is not a gate"
    - "New assert_count helper (exact-N via gcount -Fc, -1 sentinel = unmeasurable = FAIL) machine-records the D-05 owner override (Teaching still carries exactly three TA items)"
    - "Two-stream matching: whitespace-free tokens vs the RAW gate stream, multi-word literals vs the whitespace-squeezed stream — normalization can never be the thing that makes an assertion pass"

key-files:
  created:
    - scripts/verify-phase4-regressions.sh
    - .planning/phases/04-page-2-restructure-github-presence/04-02-SUMMARY.md
  modified:
    - Makefile
    - .planning/REQUIREMENTS.md
    - .planning/ROADMAP.md
    - .planning/phases/04-page-2-restructure-github-presence/04-02-PLAN.md

key-decisions:
  - "GH-01 (privatize random_walk) DEFERRED by owner (D-08) — public-but-empty, unlinked from résumé, zero click-through impact; ready command preserved, not ticked"
  - "GH-02 (fix rollout README stale status) DEFERRED by owner (D-08) — accepted trade-off: the featured rollout link keeps reading 'spec / pre-implementation'; ready fix preserved, not ticked"
  - "GH-03 SATISFIED on the résumé side + ticked — rollout wording owner-confirmed during discuss-phase (D-01), shipped verbatim in Plan 04-01 Task 3; no checkpoint presented (the confirmation already existed)"
  - "D-05 owner override machine-recorded: assert_count 'Teaching Assistant' == 3 makes the kept-three-TA-items decision a gate, not merely prose"

requirements-completed: [GH-03]
requirements-deferred: [GH-01, GH-02]

actuals:
  tokens: 9120       # chars/4 over the realized diff (script + Makefile + REQUIREMENTS + ROADMAP, d296a98..2ac3d07)
  tasks: 2
  commits: 2

duration: 5min
completed: 2026-08-24
status: complete
---

# Phase 4 Plan 02: Page-2 Content Regression Net & GitHub-Presence Decisions Summary

**A standing page-2 content regression net (`scripts/verify-phase4-regressions.sh`, 38 P4.x assertions) now guards the PG2-01/02/03 restructure Plan 04-01 landed — green on arrival against the committed PDF, each assertion class proven failable by a crafted `--gate-text` fixture, wired into `make` alongside the P2/P3 nets — and the GitHub-presence requirements are closed as owner decisions: GH-03 satisfied and ticked, GH-01/GH-02 recorded as explicit D-08 deferrals with their ready commands and NO GitHub mutation performed.**

## Performance

- **Duration:** ~5 min
- **Tasks:** 2
- **Commits:** 2 (`c956bb7`, `2ac3d07`)
- **Files:** 1 created (the net), 4 modified (Makefile + three planning docs)

## Accomplishments

### Task 1 — the page-2 content net (`c956bb7`)
- Created `scripts/verify-phase4-regressions.sh` as the page-2 twin of the P2/P3 nets, copying their idioms verbatim: the `emit`/`die2`/`gcount`/`display_of`/`assert_present`/`assert_absent` helpers, the mktemp scratch with the `gate.txt` (form-feed→newline) + `squeezed.txt` (whitespace-squeezed) two-stream setup, the `--gate-text FILE` negative-control flag with its "does NOT certify the committed artifact" note, the three-way exit vocabulary (0 all-pass / 1 regressed / 2 cannot-verify), bash-3.2.57 style (no assoc arrays, no `mapfile`, no `local`, `_`-prefixed temporaries), `LC_ALL=C` on every grep, and the `RESULT P4.<n> <PASS|FAIL>` stable-order contract.
- Added the plan's new `assert_count <label> <needle> <file> <N>` helper (exact-N via `gcount -Fc`; the `-1` sentinel for missing/unreadable input reports FAIL/unmeasurable).
- **38 assertions**, grouped in stable order:
  - **PG2-01 (Projects):** `rollout` / `graph_ml` / both `github.com/thunderock/...` links present (gate); `C++/Cython` present (squeezed, the Phase-5 PG2-06 anchor); seven retired names absent from the text layer (`BiasNet`, `DeepFoodie`, `BlindNet`, `Continuous Dominant Set`, `Humana`, `AnalyticsVidhya`, `Bias Manifolds`); a representative subset (`BiasNet`, `Continuous Dominant Set`, `AnalyticsVidhya`) absent from source too (commented-out resurrection guard); `\resumeProjectHeading` count == 3 in source (1 preamble def + 2 uses).
  - **PG2-02 (Publication):** `first author` / `NetSci 2023` / `IC2S2 2023` / `Poster` present (gate); `fairness-aware graph representation learning` present (squeezed); the cut abstract clause `In this work, we propose` absent from both text layer (squeezed) and source.
  - **PG2-03 (Research):** `IUNI` / `TieML` present (gate); `User Intent as a Network` / `NLP Lab` present (squeezed).
  - **PG2-03 (Education):** GPAs `3.87/4.0` and `8.32/10.0` absent from both text layer and source; `Indiana University, Bloomington` (city) absent (gate); `Indiana University` present (gate); both date ranges `Aug. 2021` / `Aug. 2011` present (squeezed).
  - **PG2-03 / D-05 (Teaching owner override):** `assert_count 'Teaching Assistant' == 3` (machine record that Teaching was NOT compressed); `INFO-I 606` / `CSCI-B 555` present (gate).
- Wired into the Makefile: `REGRESS4 := scripts/verify-phase4-regressions.sh` defined; `@bash $(REGRESS4)` chained as the last net line of BOTH `verify` (after `$(REGRESS3)`, before `$(VERIFY)`) and `verify-regressions`; the header help comment, the `verify-regressions` help comment, the section comment block, and the gating-invocation comment all updated to include the P4.x net. `chmod +x` applied.

### Task 2 — GitHub-presence decisions + whole-phase verification (`2ac3d07`)
- Documentation-only, no code, no GitHub mutation, no rebuild.
- Recorded the three GitHub-presence outcomes as decisions (below) in `REQUIREMENTS.md` and `ROADMAP.md`; corrected the plan's Task 2 `<files>` list to the traceability docs it actually edits (plan-checker cosmetic note).

## P4 net assertion inventory + failability controls

- **Green on arrival:** bare run exits 0, **38** `^RESULT P4\.` lines all PASS, **0** FAIL. `bash -n` clean; `shellcheck -f gcc` clean.
- **Failability proven per class** (crafted `--gate-text` fixtures over scratch copies of the real text layer, each exit 1 — recorded per the standing rule "an assertion never observed failing is not a gate"):

| Class | Crafted fixture | Flipped assertion | Exit |
|-------|-----------------|-------------------|------|
| absent (present-name) | base + a `BiasNet` line | P4.6 FAIL (retired name back) | 1 |
| present | base with `rollout` lines removed | P4.1 + P4.3 FAIL (featured project/link gone) | 1 |
| absent (abstract) | base + `In this work, we propose ...` line | P4.22 FAIL (abstract clause back) | 1 |
| count | base + a 4th `Teaching Assistant` line | P4.36 FAIL (count 4 != 3) | 1 |

  The `--gate-text` runs certify nothing about the committed artifact and say so on stdout; no build target passes the flag.

## Make wiring

`REGRESS4` defined next to `REGRESS`/`REGRESS3`; `@bash $(REGRESS4)` runs last of the three nets in both `verify` and `verify-regressions` (nets chained before the slower harness so a content regression is reported first, per the existing recipe rationale). Gating invocation stays run directly: `bash scripts/verify-resume.sh && bash scripts/verify-phase2-regressions.sh && bash scripts/verify-phase3-regressions.sh && bash scripts/verify-phase4-regressions.sh` — `make verify` is corroboration only (GNU Make 3.81 collapses exit 1/2 into 2).

## Five-suite green evidence (whole-phase gate)

- `bash scripts/verify-resume.sh` → **exit 0**.
- `bash scripts/verify-phase2-regressions.sh` → **27** anchored `^RESULT P2\.[0-9]+ +PASS`.
- `bash scripts/verify-phase3-regressions.sh` → **72** anchored `^RESULT P3\.[0-9]+ +PASS`.
- `bash scripts/verify-phase4-regressions.sh` → **exit 0**, **38 PASS / 0 FAIL**, each class proven failable.
- `make verify-selftest` → **exit 0**, **10** anchored `^RESULT G[78]\.` PASS, **0** anchored SKIP, **0** anchored FAIL.
- `make verify` (corroboration) → exit 0; `make verify-regressions` → exit 0.

## Page-1 freeze proof

`git diff 798c0fb -- docs/main.tex` hunk headers: `@@ -221`, `@@ -232`, `@@ -255`, `@@ -275` — every hunk at/after the `\newpage` boundary (line 213), i.e. all Plan 04-01 page-2 edits; no page-1 Experience line changed. This plan did not touch `docs/main.tex` (unchanged in the working tree) and did not rebuild the PDF, so the artifact is byte-identical to Plan 01's. The git hunk-context annotation shows the pre-restructure abstract line as its anchor, but the clause is absent from the current source (verified: current count 0, `798c0fb` count 1) — no contradiction with P4.22/P4.23.

## Decisions Made (GitHub presence, D-08)

- **GH-01 — privatize `random_walk`: DEFERRED by owner (D-08).** `random_walk` is public but ~empty (4KB, 3 commits) and is **not** linked from the résumé (only `rollout` + `graph_ml` are), so leaving it public has no click-through impact — privatization was account-hygiene only. Ready command preserved verbatim for a later turnkey reactivation: `GH_TOKEN=$(gh auth token -u thunderock) gh api -X PATCH repos/thunderock/random_walk -f private=true`. NOT ticked — genuinely deferred.
- **GH-02 — fix `rollout` README stale status: DEFERRED by owner (D-08).** **Accepted, documented trade-off:** a recruiter clicking the featured `github.com/thunderock/rollout` link reads its stale `Status: spec / pre-implementation. v1 in design.` Ready fix preserved verbatim: replace that line with `Status: v1 implemented — 18 crates; PPO/GRPO/DPO/SFT/RM; vLLM batch + online inference; CI across 197 test files.` NOT ticked — genuinely deferred.
- **GH-03 — rollout capability wording confirmed: SATISFIED on the résumé side + TICKED.** The rollout bullet wording was owner-confirmed to survive "walk me through it" during discuss-phase (04-CONTEXT.md D-01) and shipped verbatim in Plan 04-01 Task 3. Recorded as a documented confirmation; no checkpoint presented because the confirmation already exists.

No GitHub API call or README edit was made this phase (D-08). Trust boundary "phase scope → GitHub account" held: no credential used, no repo mutated.

## Deviations from Plan

None — plan executed as written. One trivial plan-checker cosmetic fix applied inline: 04-02 Task 2's `<files>` list was `scripts/verify-phase4-regressions.sh` (Task 1's file); corrected to `.planning/REQUIREMENTS.md, .planning/ROADMAP.md, .planning/STATE.md` to reflect what Task 2 actually edits.

## Threat model

- **T-04-04 (mitigate):** each assertion class proven failable by a crafted `--gate-text` fixture (exit 1), recorded above — satisfied.
- **T-04-05 (accept):** GH-01/GH-02 deferrals recorded with ready commands + the accepted stale-README trade-off — a later reader sees decisions, not gaps.
- **T-04-06 (mitigate):** no `gh`/token use this phase; the deferral records the per-command-token form only, never an account switch.
- No new security-relevant surface introduced (read-only net, no endpoints, no schema, no package installs).

## Known Stubs

None. The net wires all 38 assertions to the real committed text layer / source; no placeholder or empty-data path exists.

## Next Phase Readiness

- The P4 net now guards PG2-01/02/03 for Phase 5, which edits page 2 at `\section{Technical Skills}` (PG2-04/05/06) — the `C++/Cython` graph_ml anchor (P4.5) and the retired-name absence set will catch a regression there.
- GH-01/GH-02 remain turnkey-reactivatable from the ready commands in 04-CONTEXT.md Deferred Ideas and this SUMMARY, if the owner reverses the resume-only decision.

## Self-Check: PASSED

- SUMMARY file present; both task commits (`c956bb7`, `2ac3d07`) exist in git; `scripts/verify-phase4-regressions.sh` present and executable.

---
*Phase: 04-page-2-restructure-github-presence*
*Completed: 2026-08-24*
