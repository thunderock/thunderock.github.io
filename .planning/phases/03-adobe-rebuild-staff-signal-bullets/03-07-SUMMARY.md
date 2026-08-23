---
phase: 03-adobe-rebuild-staff-signal-bullets
plan: 07
subsystem: resume-content
tags: [exp-08, checkpoint, sign-off, staff-signal, line-budget, absent-by-default, provisional-figures]

# Dependency graph
requires:
  - phase: 03-06
    provides: "the measured entering headroom G3.2 p1 +17.1pt (+1.49 lines) with the EXP-08 reserve INTACT above the ladder's >= +16.1pt top rung by 1.0pt, the P3 net at exit 0 with 72 anchored PASS, and the region-boundary derivation rule"
  - phase: 03-03
    provides: "the four Section D drafts verbatim, the needle-casing table, the (c) missing-needle recorded gap, the budget ledger with its contingency ladder, and the one sanctioned Groupon/NetSpeed reword lever with its same-commit rule"
provides:
  - "the `[Phase 3 / EXP-08]` verdict record in .planning/STATE.md: one explicit verdict per draft ID -- (a) REJECTED, (b) REJECTED, (c) REJECTED, mentoring line APPROVED -- with the approved wording quoted byte-exact"
  - "the greppable `staff-signal: yes` token, ROADMAP criterion 2's qualitative half recorded on a POSITIVE read: 03-08 Task 1 Branch C is NOT triggered and 03-08 Task 3 may tick EXP-02"
  - "the BUDGET FINDING that the approved draft does NOT fit as drafted (284 chars -> 3 derived rendered lines against a 1-line fund) and that the sanctioned reword lever recovers ~0 rendered lines, so it cannot fund it either"
  - "the compression contract 03-08 Task 1 Branch B spends against: <=135 characters prose-plus-prefix for one rendered line, needle and D-13 constraints preserved, or back the edit out as APPROVED-BUT-UNAPPLIABLE-WITHIN-BUDGET"
  - "the (c) Class D needle obligation DISCHARGED BY REJECTION -- `drop-before-create` is not added and stays x0"
  - ".planning/phases/03-adobe-rebuild-staff-signal-bullets/03-07-EVIDENCE.md, the 342-line self-contained sign-off packet (rendered Adobe block, measured headroom, four drafts with citations and line costs, consequence table, digit-bearing count)"
affects: [03-08, phase-05, phase-06]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "prove-then-ask: the blocking checkpoint runs only after all four suites are measured green, so a red document can never consume the user's single sign-off"
    - "absent-by-default recording: a rejection is written as an affirmative decision naming the draft ID, so absence can never be misread as an oversight"
    - "verbatim wording capture: approved text is extracted byte-exact from the decision record into STATE.md, so the applying plan ships the approved string rather than a reconstruction"
    - "cost-before-consequence at a checkpoint: present the measured fund and the derived line cost of each answer alongside the drafts, so an approval cannot be given blind to a page-overflow it would cause"
    - "approval-with-budget-finding: an approval whose as-drafted rendering exceeds the fund is recorded as approved PLUS a compression contract PLUS an explicit back-out clause, rather than being downgraded to a rejection or shipped over budget"

key-files:
  created:
    - .planning/phases/03-adobe-rebuild-staff-signal-bullets/03-07-EVIDENCE.md
    - .planning/phases/03-adobe-rebuild-staff-signal-bullets/03-07-SUMMARY.md
  modified:
    - .planning/STATE.md

key-decisions:
  - "Candidates (a) STS assume-role storm fix, (b) 6-week silent outage root-cause + smoke-test CI and (c) preemptible-fleet idempotent autorecovery are all REJECTED -- recorded as affirmative decisions under D-14, not as omissions; 03-08 must not ship any of them in any wording"
  - "The mentoring/leadership line is APPROVED, as-drafted wording approved in principle, with the user explicitly accepting that the people-relationship claim rests on their own word rather than on mined evidence"
  - "staff-signal: yes -- the rebuilt Adobe block reads as staff signal rather than job description, so criterion 2's qualitative half is satisfied on a positive read; Branch C is not triggered and EXP-02 becomes tickable at 03-08 Task 3"
  - "The (c) Class D absence-needle obligation is DISCHARGED BY REJECTION: `drop-before-create` is not added to the P3 net and stays x0, because the bullet it would have gated is not shipping"
  - "BUDGET FINDING: the approved draft measures 284 chars -> 3 derived rendered lines (34.5pt) against a measured 1-line / +17.1pt fund, and the sanctioned Groupon/NetSpeed lever recovers ~0 rendered lines, so 03-08 Branch B must land it COMPRESSED to one rendered line (<=135 chars prose-plus-prefix) or back the edit out as APPROVED-BUT-UNAPPLIABLE-WITHIN-BUDGET"
  - "requirements-completed is deliberately EMPTY -- EXP-08's sign-off half is now discharged, but the requirement's ship-or-absent half is 03-08's and 03-08 is the last claiming plan"

patterns-established:
  - "Rejection-as-decision: every rejected draft is named by ID with its needle and an explicit do-not-ship clause, so the standing `assert_absent` assertions read as an enforced verdict rather than as work not yet done"
  - "Marker-line self-containment: the whole EXP-08 payload (verdicts, headroom, wording, staff-signal token, compression contract) lives on ONE line carrying the marker exactly once, so the downstream plan reads it by scoping to the marker line per the 03-05 standing rule"
  - "Lever-futility measurement: before recording a reword lever as an available funding path, measure whether the shortened rung actually crosses the line-1 capacity -- a rung that stays above it recovers zero rendered lines"

requirements-completed: []

# Metrics
duration: 48 min
completed: 2026-08-23
---

# Phase 3 Plan 07: EXP-08 Per-Bullet Sign-Off Summary

**Three cost/efficiency drafts rejected and the mentoring line approved at a blocking checkpoint taken against a proven-green rebuild, with `staff-signal: yes` recorded for criterion 2 and a measured finding that the approved claim needs compressing to one rendered line or backing out.**

## Performance

- **Duration:** 48 min across two sessions (Task 1 ~8 min; the balance is the blocking checkpoint wait, which is the plan working as designed)
- **Started:** 2026-08-23T05:15:17Z (03-06 close)
- **Completed:** 2026-08-23T06:03:20Z
- **Tasks:** 2 of 2
- **Files modified:** 2 (`03-07-EVIDENCE.md` created, `.planning/STATE.md` +1 line) — **zero** content files

## Accomplishments

- **The rebuild was proven green before the user was asked anything**, as D-15 requires: harness exit 0 (83 `RESULT` lines, zero FAIL, zero SKIP), P2 net exit 0 with **27** anchored `^RESULT P2\.[0-9]+ +PASS`, P3 net exit 0 with **72** anchored PASS, self-test exit 0 with ten G7/G8 PASS and zero anchored SKIP. `make verify` exit 0 recorded as criterion-5 corroboration only, never the oracle.
- **A 342-line self-contained evidence packet** (`03-07-EVIDENCE.md`) carrying the rendered Adobe block as *extracted text* (gate 11–31, region re-derived from boundaries), the measured `G3.2` p1 headroom in pt and lines with the derived available-line count, all four drafts with their `⚠ UNVERIFIED` text, `CODEBASE-EVIDENCE.md` citation, owning topic and measured line cost, the consequence table with every literal the reword lever must preserve, and the `G5.4` digit-bearing count with the first-line-vs-continuation-line rule. **No recommendation appears anywhere in it.**
- **Every draft has an explicit recorded verdict** behind the single greppable `[Phase 3 / EXP-08]` marker; three rejections are phrased as affirmative decisions with an explicit do-not-ship clause.
- **Criterion 2's unmechanizable half is captured** as the literal `staff-signal: yes` token, so 03-08 has both tick authority and a known-not-triggered Branch C.
- **The approval's real cost was measured, not assumed** — and the finding that it does not fit as drafted, plus the finding that the one sanctioned lever cannot fund it, are recorded now rather than discovered at 03-08's build.

## Task Commits

1. **Task 1: Prove the rebuild green and assemble the evidence packet** — `80dd392` (docs)
2. **Task 2: Per-bullet sign-off on the cost/efficiency and leadership bullets** — `61c77dc` (docs)

**Plan metadata:** see the trailing `docs(03-07)` commit.

## EXP-08 — per-draft verdicts and the criterion-2 read

Verbatim as recorded in `.planning/STATE.md` behind the `[Phase 3 / EXP-08]` marker:

| Draft ID | Draft | Needle | Verdict |
|---|---|---|---|
| **(a)** | STS assume-role storm fix | `AssumeRole` | **REJECTED** |
| **(b)** | 6-week silent outage root-cause + smoke-test CI | `6-week` | **REJECTED** |
| **(c)** | preemptible-fleet idempotent autorecovery | ⚠ none locked | **REJECTED** |
| **mentoring** | mentoring / leadership line | `mentored` (lowercase, mid-sentence) | **APPROVED** — as-drafted wording approved in principle |

**`staff-signal: yes`** — recorded exactly as the user phrased it. The user read page 1 of the rendered PDF end to end and judged the rebuilt Adobe block to read as staff signal rather than job description. Consequences: **03-08 Task 1 Branch C is NOT triggered** (no line-neutral lead-bullet revision is owed; no change was named because none was wanted), and **03-08 Task 3 may tick EXP-02** provided the EXP-02a any-of lead-anchor assertion is still PASS at that point.

**On the approval's nature.** The mentoring draft asks a different question from the cost family's: the mined commits show the *artifacts* (guides, runbooks, launch templates, model onboardings) but commit history cannot record who learned what from whom. The Section D honesty note was presented and read, and the user accepted that **the people-relationship claim rests on their own word**, not on mined evidence. That acceptance is what the approval is.

**On the three rejections.** D-14 makes absence the default and rejection a fully green outcome. `assert_absent` stays byte-unchanged for `AssumeRole` (P3.67/P3.68) and `6-week` (P3.69/P3.70) — re-verified PASS after the record landed — and **03-08 must not ship (a), (b) or (c) in any wording or any length.** The recorded (c) Class D needle obligation is therefore **discharged by rejection**: `drop-before-create` is not added and stays ×0 in both source and text layer.

**Approved wording, byte-exact** (extracted from `03-DECISION-RECORD.md` Section D; round-trip against the source verified `True`; pure ASCII, the apostrophe is U+0027; owning topic **A6 `\resumeTopic{Foundation Model Training Framework}`** as a nested `\resumeItem`):

> Grew the platform's engineering bench: mentored applied-ML and platform engineers onto the training and inference frameworks, authoring the architecture guide, runbook and multi-node launch templates teams onboard with, and reviewing their module integrations through to production.

## Measured headroom at decision time, and whether the reword is required

| Quantity | Measured value |
|---|---|
| `G3.2` p1 headroom | **+17.1pt (+1.49 lines)** at `LINE_PT=11.5` |
| Rendered lines available — `floor(17.1 / 11.5)` | **1** |
| Contingency-ladder position | **reserve INTACT** — above the ≥ +16.1pt top rung by 1.0pt |
| Inherited same-commit reword obligation | **none** — the lever was not pulled in waves 2–4 |
| **Is the sanctioned Groupon/NetSpeed reword required?** | **It is required in the sense that the approval does not fit without funding — and it CANNOT fund it.** The lever recovers ≈0 rendered lines, so the only viable path is compression of the approved claim itself. |

## Handoff to 03-08 — the budget arithmetic, recorded verbatim

⚠ **The approved mentoring claim does NOT fit as drafted, and the one sanctioned lever cannot fund it.** This arithmetic is 03-08 Task 1 Branch B's authority:

- The approved mentoring draft measures **284 characters** (282 prose + the 2-character `– ` bullet prefix) against the measured itemize-3 line-1 capacity of **135**, so `284 / 135` = **2.10 → 3 derived rendered lines**, costing `3 × 11.5` = **34.5pt** against **17.1pt** available → **−17.4pt, i.e. a 3-page PDF with `G1.1` FAIL**. Even a 2-line landing is `17.1 − 23.0` = **−5.9pt** and over budget.
- The fund is **+17.1pt ≈ 1 rendered line** (`floor(17.1 / 11.5)` = 1).
- **The Groupon/NetSpeed lever recovers ≈0 rendered lines.** Measured on this committed artifact both descriptors already render as **2 rendered lines** — Groupon **167** characters (`docs/main.tex:200` resolved by CONTENT, rendered gate 73–74, line 1 = 129 chars) and NetSpeed **164** (`docs/main.tex:207`, rendered gate 82–83, line 1 = 136 chars) — and **rung (b) still wraps to 2 lines at 154 / 150 characters vs the ≈135 line-1 capacity**, so the net recovery is zero. Recovering one rendered line would mean dropping a descriptor to ≤135 characters (−32 on Groupon, −19%), which is exactly the aggressive cut the two forbidden shortened forms (`Virtual Channel and Polarity-based Arbitration`, `Cyclops service platform`) exist to forbid, and it would put the load-bearing multi-word `C++ graph algorithms` anchor that ROADMAP Phase 5 criterion 4 rests on at risk.

**Therefore 03-08 Task 1 Branch B must land the approved mentoring claim COMPRESSED to fit the fund** — target **≤135 characters** measured on prose-plus-prefix (≈133 prose characters) for **one rendered line**, which lands p1 at `17.1 − 11.5` = **+5.6pt**, above the +4.7pt back-out rung, with `G1.1` still reporting 2 pages. The compression **must**:

1. keep the lowercase mid-sentence `mentored` needle byte-exact per the Section D casing table — a sentence-initial `Mentored` leaves `assert_absent 'mentored'` reading count 0 forever, so the absent→present flip would report a **false absence on a bullet that is actually on the page**;
2. keep D-13's no-invented-numerals rule — no headcount; "mentored N engineers" is precisely the invented figure D-13 forbids, and the claim is qualitative on purpose (the approved draft carries **zero numerals**, verified);
3. **not** breach the **+4.7pt** back-out rung or **`G1.1`**;
4. flip **P3.71/P3.72** from `assert_absent` to `assert_present` in the **SAME commit** that ships the bullet.

**If a faithful 1-rendered-line rendering is impossible, 03-08 backs the edit out and records the approval as APPROVED-BUT-UNAPPLIABLE-WITHIN-BUDGET rather than breaking the page.** Per the ladder: never tighten a frozen surface, never lower a threshold to make content fit.

All costs above are estimates from the committed artifact and are **RE-MEASURED at 03-08** by reading `G1.1` first and then `G3.2` p1 — Phase 2's standing rule is that the real cost is read from the build, never trusted from an estimate.

## Files Created/Modified

- `.planning/phases/03-adobe-rebuild-staff-signal-bullets/03-07-EVIDENCE.md` — the 342-line sign-off packet: green-precondition table, rendered Adobe block (gate 11–31, boundary-derived), measured headroom with derived available lines, four drafts with `⚠ UNVERIFIED` text + citation + owning topic + measured line cost, consequence table with the reword lever's preconditions and all eighteen protected literals, `G5.4` digit-bearing count with the first-line rule
- `.planning/STATE.md` — **+1 line, 0 deletions**, a single `[Phase 3 / EXP-08]` decision bullet inside `### Decisions` (hunk `@@ -90,0 +91 @@`)

## Decisions Made

See the EXP-08 section above and the `key-decisions` frontmatter. One decision is worth restating because it is a departure in *kind* from every prior handover in this phase: **an approval is being handed forward together with a finding that it cannot be applied as approved.** The alternatives were both worse — downgrading it to a rejection would overwrite the user's actual answer, and passing it forward silently would have 03-08 discover at build time that an approved bullet is three rendered lines wide with room for one, then improvise a fix under pressure. Recording *approval + compression contract + explicit back-out clause* preserves the verdict, bounds the applying plan, and keeps the page safe.

`requirements-completed` is deliberately **EMPTY** and `requirements mark-complete` was NOT run, despite the plan's `requirements: [EXP-08]`. **Eighth consecutive plan in this phase to follow the rule.** EXP-08 is claimed by 03-01 and 03-03 through 03-08, with **03-08 the last claiming plan**. What is different this time, recorded so nobody reads it as an oversight: EXP-08's own `REQUIREMENTS.md:25` text has two halves — drafted-and-⚠-flagged-then-signed-off, and *shipped only after* that sign-off (never silently). **The sign-off half is now fully discharged** (drafts written in 03-03, flagged, presented at a blocking checkpoint, verdicts recorded). The ship-or-absent half is 03-08's: it must land the one approved claim under measurement or back it out, and keep the three rejected needles absent. Ticking EXP-08 here would claim the ship half on the strength of the sign-off half.

## Deviations from Plan

**None — plan executed exactly as written.** No deviation rule fired. Both tasks are doc-only by design and `git status --porcelain docs/` is empty after both, as the plan's `<verification>` requires.

Two things worth distinguishing from deviations because they *look* like them:

- **The checkpoint was presented for real and blocked.** That is the plan working (D-15, and the `### Blockers/Concerns` entry recording EXP-08 as un-auto-advanceable), not a stall. Under the auto-mode rules a `checkpoint:decision` would ordinarily auto-select the first option; this one is a hard attended gate whose whole purpose is a human verdict on provisional magnitudes, so auto-selection would have produced a false record — the exact failure EXP-08 exists to prevent.
- **The budget finding is a measurement, not a scope change.** The plan anticipated exactly this shape: its consequence table already covers "approve anything that renders as 2+ lines". The new information is only that the lever the table names as the remedy *recovers nothing here*, which is why the remedy recorded for 03-08 is compression rather than the lever.

## Issues Encountered

- **The `[Phase 3 / EXP-08]` marker must appear exactly once in the file, and the payload must be self-contained on that one line.** The plan asserts `grep -Fc '[Phase 3 / EXP-08]'` == 1, and the `[Phase 3 / 03-05]` standing rule requires a decision-marker payload to be read by scoping to its marker line rather than by a document-wide grep. Resolved by writing the entire payload — verdicts, headroom, verbatim wording, `staff-signal` token, compression contract — as a single bullet carrying the marker once, and by deliberately avoiding a second literal `staff-signal:` occurrence anywhere in the file so a downstream scoped read is unambiguous. Verified: marker count 1, `staff-signal:` line count 1, and marker-line extraction yields `staff-signal: yes` and all four verdicts cleanly.
- **`state add-decision` was not used for the verdict bullet.** The prevailing convention prepends a `[Phase 03]: ` prefix, which would break the plan's requirement that the bullet *begin* with the literal marker. Written directly instead, following the existing `[Phase 3 / D-08]` bullet's precedent; the diff is `1 insertion(+), 0 deletions`, inside `### Decisions`.
- **Keep the `staff-signal:` token off SDK-managed lines — a fourth sighting of this phase's signature defect class, caught before it shipped.** The metadata step's `last_activity` text initially quoted `` `staff-signal: yes` `` verbatim, which took the file's token count from 1 to **3**. The plan's assertion is ≥ 1, so it still passed — but two of those copies sat on `last_activity` lines that `state advance-plan` / `record-session` **rewrite on every subsequent plan**, so the count would have silently fluctuated at 03-08 and a marker-line-scoped read could have collided with volatile metadata. Reworded to "a positive criterion-2 staff-signal read" (no colon form), restoring the count to exactly **1** on the marker line, which is what the plan states it writes. **Standing note for 03-08:** when it quotes the token verbatim in its Branch B revision record or an `EXP-02 qualitative gap` bullet, put it on a durable Decisions line — never in `last_activity`, the progress bar area, or any other field the state tooling regenerates.
- **Pre-existing untracked `.omc/` directory** in the working tree, present before this plan started and unrelated to it. Out of scope per the scope boundary; not touched, not committed, not gitignored. Flagged here only so a later reader does not mistake it for this plan's output.

## User Setup Required

None — no external service configuration required. The one human input this plan needed (the per-bullet sign-off) has been given and recorded.

## Next Phase Readiness

**Plan 03-08 is authorized and fully specified:**

- **Add exactly one bullet** — the approved mentoring claim, compressed to one rendered line under the four constraints above — **and nothing else**. Ship no wording for (a), (b) or (c).
- **Branch C is not triggered** (`staff-signal: yes`), so no lead-bullet revision is owed.
- **EXP-02 is tickable at 03-08 Task 3**, subject to the EXP-02a assertion still being PASS.
- **Flip P3.71/P3.72 to `assert_present` in the same commit** that ships the bullet; leave P3.67–P3.70 as `assert_absent`.
- **`drop-before-create` is not needed** — the (c) needle obligation is discharged by rejection.
- **Back-out path is pre-authorized:** if no faithful one-line rendering exists, back the edit out and record `APPROVED-BUT-UNAPPLIABLE-WITHIN-BUDGET`. 03-08 must still measure `G1.1` then `G3.2` p1 rather than trusting this plan's estimates.
- **EXP-08, EXP-02, EXP-03, EXP-04 and EXP-07 all tick (or are recorded as gapped) at 03-08** — it is the last claiming plan for every one of them.

**Carried concerns, unchanged by this plan:** the Phase-6 site-sync obligation (`index.html:196` and `index.html:207-225`) and the `G6.13` WARN owned by Phase 3.

## Self-Check: PASSED

Every claim above was re-verified after the SUMMARY was written, not asserted:

| Check | Result |
|---|---|
| `03-07-EVIDENCE.md` exists | **FOUND** — 342 lines |
| `03-07-SUMMARY.md` exists | **FOUND** |
| `.planning/STATE.md` exists | **FOUND** — 135 lines |
| Commit `80dd392` (Task 1) | **FOUND** — `docs(03-07): assemble the sign-off evidence packet for the candidate bullets` |
| Commit `61c77dc` (Task 2) | **FOUND** — `docs(03-07): record the per-bullet sign-off verdicts for the candidate bullets` |
| `LC_ALL=C grep -Fc '[Phase 3 / EXP-08]' .planning/STATE.md` | **1** |
| that record carries `approved\|rejected\|revised` | **yes** — all four verdicts extract cleanly by marker-line scoping |
| `LC_ALL=C grep -Fc 'staff-signal:' .planning/STATE.md` | **1** (≥ 1 as the plan requires) and it reads `staff-signal: yes` |
| approved wording round-trip vs `03-DECISION-RECORD.md` | **byte-exact `True`**; 282 prose chars, zero numerals (D-13 satisfied), lowercase mid-sentence `mentored` present |
| `git diff` on `.planning/STATE.md` for Task 2 | **1 insertion(+), 0 deletions**, hunk `@@ -90,0 +91 @@` inside `### Decisions` |
| `git status --porcelain docs/` | **empty** — no content file changed in this plan |
| post-record `bash scripts/verify-phase3-regressions.sh` | **exit 0**, 72 anchored PASS, 0 anchored FAIL |
| P3.67–P3.72 (all six Class D absence assertions) | **all PASS** — the three rejections are in force and absent-by-default holds |
| post-record `bash scripts/verify-phase2-regressions.sh` | **exit 0**, 27 anchored PASS |
| post-record `bash scripts/verify-resume.sh` | **exit 0**, 0 FAIL, 0 SKIP |
| Groupon / NetSpeed lever measurement | Groupon 167 chars → 2 rendered lines (line 1 = 129); NetSpeed 164 chars → 2 rendered lines (line 1 = 136) — confirms rung (b) at 154/150 recovers **0** rendered lines |

---
*Phase: 03-adobe-rebuild-staff-signal-bullets*
*Completed: 2026-08-23*
