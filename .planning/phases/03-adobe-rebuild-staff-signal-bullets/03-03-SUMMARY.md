---
phase: 03-adobe-rebuild-staff-signal-bullets
plan: 03
subsystem: planning
tags: [decision-record, traceability, page-budget, latex, honesty-gate, exp-08]

# Dependency graph
requires:
  - phase: 02-page-1-budget-text-layer-defects
    provides: the measured +50.5pt / +4.39-line page-1 slack, the 7.0pt G7.2 probe margin, the PROBE_LINES raise-only rule and the artifacts-ride-with-source commit convention
  - phase: 03-adobe-rebuild-staff-signal-bullets
    provides: "03-01's scripts/verify-phase3-regressions.sh (the P3 acceptance oracle) whose Class D EXP-08 assertions Task 3 corroborates against"
provides:
  - "criterion-1 disposition table: a retain/revise/retire decision for all 11 current Adobe entries plus the governance add, with a keywords-carried column, committed BEFORE any docs/main.tex edit"
  - "criterion-3 figure->evidence traceability: 14 shipped figures each citing a line-numbered CODEBASE-EVIDENCE.md entry, plus a retirement row for the two unprovenanced figures"
  - "the page-1 budget ledger: baseline, unit cost, +4-line ceiling, per-wave spend table, free-tail table, contingency ladder and two hard rails -- the spend authority waves 2-4 draw against"
  - "the Swiggy/Flipkart per-bullet disposition with corrected rendered-line counts (Adobe 18 / Swiggy 11 / Flipkart 9) and the re-derive-from-boundaries rule"
  - "both EXP-08 draft families, UNVERIFIED-flagged, needle-cased, evidence-cited, and absent from docs/main.tex"
affects: [03-04, 03-05, 03-06, 03-07, 03-08, phase-04, phase-05, phase-06]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "disposition-before-text: the criterion-1 record is committed first and commit ordering IS the proof (git log -1 -- docs/main.tex still reports the Phase-2 commit 29999ff)"
    - "figure->evidence traceability table as a doc assertion: a figure row without a CODEBASE-EVIDENCE.md line number is a defect"
    - "measured-not-predicted budget ledger with a numeric contingency ladder, so a content plan can decide to back an edit out without re-measuring the phase"
    - "needle-casing table for absence->presence flips, derived from reading the assertion implementation rather than assuming it"

key-files:
  created:
    - .planning/phases/03-adobe-rebuild-staff-signal-bullets/03-DECISION-RECORD.md
  modified:
    - .planning/STATE.md
    - .planning/ROADMAP.md

key-decisions:
  - "Disposition totals are 9 retain-and-revise (5 topics + 4 nested items), 2 revise (A1 lead per D-01, A4 figure swap per D-05), 1 add (A12 governance per D-02) and ZERO retire; the two retired FIGURES live inside A4, whose entry is revised rather than removed"
  - "assert_absent in the P3 net is case-SENSITIVE (gcount -Fc), so a mentoring draft shipped as sentence-initial 'Mentored' would leave the needle at 0 and make 03-08's absent->present flip report a false absence; every draft is worded to carry its needle byte-for-byte"
  - "EXP-08 candidate (c) (preemptible-fleet idempotent autorecovery) has NO Class D needle; the gap is recorded with its consequence and a suggested needle (drop-before-create) rather than left to be rediscovered"
  - "Swiggy's rendered-line count is 11, not RESEARCH's 8 -- that row's own gate region (36-46) is 11 lines and the per-bullet breakdown sums to 11; line-neutrality must be re-derived from region boundaries because absolute gate numbers shift when Adobe grows"
  - "requirements-completed is deliberately EMPTY: this plan writes the decision record and lands no resume content, and the P3 oracle still reports 46 owned FAILs"

patterns-established:
  - "Frozen-surface register: seven named surfaces with the specific gate or anchor each one protects, so a later plan cannot buy a line by touching one 'harmlessly'"
  - "Contingency ladder as spend authority: three numeric thresholds (+16.1pt / +4.7pt / 3 pages) plus two hard rails, one of which is a CEILING on slack (G3.2 p1 must never RISE above +50.5pt)"
  - "Recorded-gap convention extended from 03-01's Class E: an assertion that cannot exist yet is written down with owner, consequence and suggested form"

requirements-completed: []

# Metrics
duration: 12 min
completed: 2026-08-22
---

# Phase 3 Plan 03: Decision Record — Disposition, Traceability, Budget & EXP-08 Drafts Summary

**A 586-line decision record that discharges criterion 1 before any resume text exists: a disposition plus keyword inventory for all 12 Adobe entries (zero retires), 14 shipped figures each traced to a line-numbered evidence entry, a measured page-1 budget ledger with a three-threshold contingency ladder, and four ⚠ UNVERIFIED EXP-08 drafts that are provably nowhere in `docs/main.tex`.**

## Performance

- **Duration:** 12 min
- **Started:** 2026-08-23T03:47:00Z
- **Completed:** 2026-08-23T03:57:22Z
- **Tasks:** 3
- **Files modified:** 3 (1 created: the decision record; 2 close-out metadata: STATE.md, ROADMAP.md)

## Accomplishments

- **Criterion 1 discharged with commit ordering as the proof.** All 11 current Adobe entries (A1–A11) plus the A12 governance add carry a disposition, a source anchor, today's gate lines, rendered cost, the `G5.4` digit flag and a **keywords-carried** column. `git log --oneline -1 -- docs/main.tex` still reports the Phase-2 commit `29999ff` — no content edit happened before the record landed.
- **The five single-occurrence BLOCKER keyword carriers are flagged with their source lines**, so Pitfall 7 is a checkable table rather than prose: `Rust` ×1 (`main.tex:163`), `SQS` ×1 (`:156`), `Flash Attention` ×1 (`:161`), `FSDP` ×2-from-one-string (`:160`), and `distributed` ×2 with both carriers inside A7/A8 — capital-D `Distributed Inference Frameworks` explicitly does not count, because `G6.5` is case-sensitive.
- **14 shipped figures each cite a line-numbered `CODEBASE-EVIDENCE.md` entry** (every citation resolved live with `LC_ALL=C grep -Fn`), and both retired figures are named as retired with the EN-DASH assertion rule and the measured stream asymmetry that makes an ASCII assertion vacuous.
- **The budget ledger is the spend authority for waves 2–4**: +50.5pt baseline, 11.4–11.5pt/line, the +4-line ceiling with its +5 three-page evidence, a spend table summing to **+3** (leaving one rendered line as the EXP-08 approval fund), the eleven-entry free-tail table totalling ≈484 zero-cost characters, and a contingency ladder with three numeric thresholds and two hard rails.
- **Four EXP-08 drafts exist, ⚠-flagged, needle-cased and evidence-cited** — and `LC_ALL=C grep -Fc` returns **0** for `AssumeRole`, `6-week` and `mentored` in `docs/main.tex`, corroborated by six observed `EXP-08` PASS lines from an existing `scripts/verify-phase3-regressions.sh`.

## Task Commits

Each task was committed atomically:

1. **Task 1: Criterion-1 disposition table** — `8dd7d83` (docs)
2. **Task 2: Figure→evidence traceability, budget ledger, Swiggy/Flipkart disposition** — `8711931` (docs)
3. **Task 3: Both EXP-08 draft families, ⚠-flagged, plan-document only** — `645deae` (docs)

**Plan metadata:** see the trailing `docs(03-03): complete the decision record plan` commit.

## Files Created/Modified

- `.planning/phases/03-adobe-rebuild-staff-signal-bullets/03-DECISION-RECORD.md` (created, 586 lines) — the phase's decision record: Section 0 criterion-1 disposition + keyword inventory + digit baseline + frozen surfaces; Section A figure→evidence traceability + attribution rules + retirement row + LaTeX encoding rules; Section B the page-1 budget ledger; Section C the Swiggy/Flipkart disposition; Section D both EXP-08 draft families.

**No file under `docs/` was touched.** `git diff --name-only 8dd7d83~1..HEAD` lists exactly one path — the record itself.

## The numbers waves 2–4 spend against

### Disposition totals (criterion 1)

| Disposition | Count | Entries |
|---|---|---|
| retain-and-revise (topics) | **5** | A2, A6, A9, A10, A11 |
| retain-and-revise (nested items) | **4** | A3, A5, A7, A8 |
| revise | **2** | A1 (lead, D-01), A4 (figure swap, D-05) |
| add | **1** | A12 (governance, D-02) |
| **retire** | **0** | — |

Named as surviving: `Falcon-40B`, `Llama 2 70B`, KEDA-on-`SQS queue depth`, `Source → Transform → Sink`.

### Figure→evidence traceability (criterion 3)

**14 shipped-figure rows, 14 citations, 0 uncited.** `1.09M` / `8×A100` / `16 fractional-GPU actors` → `:58`; `24×A100-40GB` / `9 model queues` → `:62` (+`:61`); `64 H100s` → `:98`; `202.6M-row` → `:34`+`:35`; `24.8M` → `:38`; `~700M` / `35–38M` → `:88` (+`:107`); `40-node` → `:107`; `27,135` → `:29`; `9.7k-line` → `:30`; `torch.compile(mode="max-autotune")` → `:54`.

**2 retirement rows:** `10–50` and `3–8K images/sec on 32 GPUs`, both unprovenanced.

### Budget ledger expected end state

| Item | Spend |
|---|---|
| A12 governance topic (topic-only; the nested-item form costs 4 = the whole budget, forbidden) | **+2** |
| A4 Ray swap (D-05) | **+1** |
| D-04 mechanisms, D-06 figures, D-07 bridge | **0pt target** — into ≈484 free tail chars |
| Swiggy + Flipkart (D-11) | **0** |
| **Expected end state** | **+3 rendered lines → `G3.2` p1 ≈ +16.1pt** |

**Reserve:** one rendered line (**11.5pt**) held unspent as the EXP-08 approval fund. **Ceiling:** +4 lines (`G3.2` p1 +4.7pt) is the last safe step; +5 is a 3-page PDF with `G1.1` FAIL + `G2.1` FAIL. **Ladder:** ≥+16.1pt reserve intact · +4.7pt…+16.1pt reserve consumed (the checkpoint must say so) · <+4.7pt or 3 pages back the edit out. **Rails:** never a fifth line; `G3.2` p1 must never **rise** above +50.5pt (net-freeing one line measured 61.4pt slack and made the +5 probe render 2 pages → `G7.2` FAIL).

### EXP-08 draft needles

| Draft | Needle | Present in record | Count in `docs/main.tex` | Owning role if approved |
|---|---|---|---|---|
| (a) STS assume-role storm fix | `AssumeRole` | ✓ | **0** | A10 Enrichment Service |
| (b) 6-week silent outage + smoke-test CI | `6-week` | ✓ | **0** | A9 Build & Deployment System |
| (c) preemptible-fleet idempotent autorecovery | ⚠ **none locked** | n/a | n/a | A10 Enrichment Service |
| mentoring line | `mentored` (lowercase, mid-sentence) | ✓ | **0** | A6 Foundation Model Training Framework |

`STS` is **not** a needle — a fixed-string search matches inside `TESTS` (verified: `printf 'RUNNING TESTS\n' | LC_ALL=C grep -Fc 'STS'` → 1).

## Decisions Made

1. **The two retired figures do not make A4 a `retire` row.** D-03 says retire nothing, and A4 keeps its bullet, shape and position while swapping an unprovenanced pair for an evidenced figure. Recording A4 as `revise` and stating the figure/entry distinction explicitly prevents a later reader from concluding a claim was dropped — which is the exact confusion criterion 1 exists to prevent.
2. **`assert_absent` is case-sensitive, so draft casing is load-bearing.** Read from the implementation (`gcount -Fc`), not assumed. A needle-casing table is recorded because a draft shipped as sentence-initial `Mentored` would leave `assert_absent 'mentored'` at count 0 — 03-08's absent→present flip would then report a **false absence on a bullet that is actually on the page**. Same class of trap for `six-week` vs `6-week` and `assume-role` vs `AssumeRole`.
3. **EXP-08 candidate (c) has no locked absence needle, and that is written down.** Class D locks exactly three needles and none covers (c). Recorded with the consequence (if (c) is the approved draft, 03-08 must add a needle in the SAME commit that ships it) and a suggested needle (`drop-before-create`). This extends 03-01's Class E convention: a gap that is written down is a decision; a gap that is not is an omission.
4. **Swiggy is 11 rendered lines, superseding RESEARCH's 8.** The RESEARCH row is internally inconsistent — it states gate region 36–46, which is 11 lines. Measured per-bullet: 2+2+2+2+2+1 = 11. Flipkart's 9 and Adobe's 18 reproduce exactly. Recorded together with the instruction that absolute gate numbers **shift when Adobe grows**, so line-neutrality must be re-derived from region boundaries — a differential check pinned to literal line numbers would report a false regression the moment the governance topic lands.
5. **`requirements-completed` is deliberately EMPTY and `requirements mark-complete` was NOT run**, despite the plan's `requirements: [EXP-02, EXP-04, EXP-07, EXP-08]`. This plan writes the decision record; it lands no Adobe content (EXP-02), puts no figure into `docs/main.tex` (EXP-04), tightens no Swiggy/Flipkart bullet (EXP-07) and ships no EXP-08 bullet — and the P3 oracle still reports **46 owned FAILs**. All four requirements are shared, with **03-08 the last claiming plan** for each. This follows the precedent recorded for 03-01, 03-02 and Phase 2 Plan 01: a requirement shared across plans completes when the LAST plan lands.
6. **The mentoring draft's confirmation ask is stronger than the cost family's, and the checkpoint must say so.** The cost drafts restate facts already in `CODEBASE-EVIDENCE.md` and ask only for approval of framing and magnitude. The mined commits show the mentoring *artifacts* (architecture guide, runbook, launch templates, model onboardings) but **cannot show a mentoring relationship** — commit history does not record who learned what from whom. So that draft asks the user to confirm a fact the evidence pass could not reach. It also carries **no numeral at all**, because "mentored N engineers" is precisely the invented headcount D-13 forbids.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Missing Critical] Recorded the needle-casing constraint the plan does not name**

- **Found during:** Task 3
- **Issue:** The plan requires each draft to "carry its locked absence needle so the post-checkpoint assertion can flip", but does not state that the flip is **case-sensitive**. Reading `assert_absent` in `scripts/verify-phase3-regressions.sh` shows it counts with `gcount -Fc "$2"` — a fixed-string, case-sensitive match. A mentoring draft written naturally as *"Mentored applied-ML engineers…"* would therefore leave `assert_absent 'mentored'` reading count 0 after shipping, so 03-08's absent→present flip would silently report a false absence on a live bullet. The gate would look green while proving nothing — the exact failure mode this phase's standing rule forbids.
- **Fix:** Added a needle-casing table to Section D (`AssumeRole` / `6-week` / `mentored`, each with its must-write and must-not-write forms) and worded the mentoring draft so `mentored` appears **lowercase and mid-sentence**.
- **Files modified:** `.planning/phases/03-adobe-rebuild-staff-signal-bullets/03-DECISION-RECORD.md`
- **Verification:** `awk '/^assert_absent\(\)/,/^}/'` confirms `gcount -Fc`; the shipped draft's needle is lowercase mid-sentence; the automated gate confirms all three needles present in the record and ×0 in `docs/main.tex`.
- **Committed in:** `645deae` (Task 3 commit)

**2. [Rule 2 - Missing Critical] Recorded EXP-08 candidate (c)'s missing absence needle**

- **Found during:** Task 3
- **Issue:** The plan names an absence needle for candidates (a) and (b) only. `03-01-PLAN.md` Class D locks exactly three needles (`AssumeRole`, `6-week`, `mentored`) and none belongs to candidate (c). Candidate (c) is therefore **not covered by an absent-by-default assertion at all** — if it is the draft the user approves, it would enter `docs/main.tex` with no machine record that it was ever gated, defeating D-14's whole mechanism for that one bullet.
- **Fix:** Flagged (c) as `⚠ NO LOCKED NEEDLE` in its own heading, recorded the consequence (03-08 must add its needle in the SAME commit that ships it) and suggested a concrete needle (`drop-before-create` — distinctive, wrap-safe, ×0 in `docs/main.tex` today).
- **Files modified:** `.planning/phases/03-adobe-rebuild-staff-signal-bullets/03-DECISION-RECORD.md`
- **Verification:** `LC_ALL=C grep -Fc 'drop-before-create' docs/main.tex` → 0 (well-formed, non-vacuous); the gap and its owner are stated in the record.
- **Committed in:** `645deae` (Task 3 commit)

**3. [Rule 1 - Bug] Covered `main.tex:178` as well as the plan's acceptance-criteria `:192`**

- **Found during:** Task 3
- **Issue:** The plan's `<action>` and `<read_first>` both name `docs/main.tex :158 and :178` as the framings the mentoring draft must not duplicate, but its acceptance criterion says ":158 and `:192`". `:178` is Swiggy's *"Founding member"* claim — a genuine leadership framing; `:192` is Flipkart's Cascading/HDFS pipelines row, which carries no people or leadership claim at all. Writing only against `:192` would have satisfied the criterion's letter while leaving the real duplication risk (`:178`) unexamined.
- **Fix:** The diff table covers **all three** lines — `:158` (artifact adoption), `:178` (his own seat), `:192` (checked and confirmed to carry nothing about people) — so both readings of the criterion are satisfied and the substantive risk is addressed.
- **Files modified:** `.planning/phases/03-adobe-rebuild-staff-signal-bullets/03-DECISION-RECORD.md`
- **Verification:** `sed -n '158p;178p;192p' docs/main.tex` read directly; the table has 3 rows, one per line.
- **Committed in:** `645deae` (Task 3 commit)

**4. [Rule 1 - Bug] Superseded RESEARCH's "Swiggy 8 rendered lines" with the measured 11**

- **Found during:** Task 2
- **Issue:** `03-RESEARCH.md:487` states Swiggy as "gate 36–46, 8 rendered lines" — internally inconsistent, since 36 through 46 inclusive is 11 lines. The plan already anticipated this ("RESEARCH's 'Swiggy 8' figure is superseded by this measurement"), and the measurement confirms it: the per-bullet breakdown sums to 11.
- **Fix:** Recorded Swiggy as **11** with the per-bullet derivation, and explicitly marked the RESEARCH figure superseded so a later differential check is not built on it.
- **Files modified:** `.planning/phases/03-adobe-rebuild-staff-signal-bullets/03-DECISION-RECORD.md`
- **Verification:** `pdftotext` gate lines 36–46 enumerated one bullet at a time; 2+2+2+2+2+1 = 11.
- **Committed in:** `8711931` (Task 2 commit)

**5. [Rule 2 - Missing Critical] Added the byte-vs-character measurement caveat to the free-tail table**

- **Found during:** Task 2
- **Issue:** Re-measuring the free-tail table with `awk '{print length}'` yields **byte** counts, and the U+2013 bullet prefix is 3 bytes — so a later reader re-deriving the table naively gets +2 on every bullet-led line (and +7 on A4, which also carries U+2013 ×2 and U+00D7 ×1). Without the caveat, the discrepancy reads as the table being wrong and could prompt someone to "correct" a set of figures that are already right.
- **Fix:** Recorded the character counts as authoritative, listed today's measured byte counts alongside them, and named the cause.
- **Files modified:** `.planning/phases/03-adobe-rebuild-staff-signal-bullets/03-DECISION-RECORD.md`
- **Verification:** Byte counts 76/40/112/135/16/51/111/132/97/71/42 reconcile to the character counts 76/40/110/128/16/51/109/130/97/71/42 by exactly the multi-byte glyph count on each line.
- **Committed in:** `8711931` (Task 2 commit)

**6. [Rule 1 - Bug] Repaired STATE.md `percent` after `state.update-progress` wrote a phase-based figure into a plan-based field**

- **Found during:** Close-out (state updates)
- **Issue:** After `gsd-sdk query state.advance-plan` + `state.update-progress`, STATE.md frontmatter read `percent: 33` while the body bar read `Progress: [██████░░░░] 62%`. The frontmatter field has been **plan-based** in every prior commit (`completed_plans: 7` / `percent: 54`, matching the body), and `8/13 = 62%` while `2/6 phases = 33%` — so the SDK wrote a phase-derived percentage into a plan-derived field, leaving the same file self-contradictory. Any consumer reading frontmatter instead of the rendered bar would report the milestone as 33% complete.
- **Fix:** Set `percent: 62` to match both the body bar and the `completed_plans/total_plans` arithmetic.
- **Files modified:** `.planning/STATE.md`
- **Verification:** frontmatter `percent` and the body bar now both read 62%; asserted equal programmatically at close-out.
- **Committed in:** the trailing `docs(03-03)` metadata commit

**7. [Rule 1 - Bug] Restored the descriptive `last_activity` suffix that `state.record-session` flattened**

- **Found during:** Close-out (state updates)
- **Issue:** `state.record-session` reduced `last_activity` (frontmatter line 7) and `Last activity:` (body line 23) to a bare `2026-08-23`, dropping the descriptive suffix every prior entry carries (e.g. `2026-08-23 -- Phase 03 Plan 02 complete (P2 net wired into make, G6.13 WARN claimed)`). A bare date tells the next session which day work stopped but not what landed — which is the entire purpose of the field.
- **Fix:** Restored the convention on both lines with this plan's description.
- **Files modified:** `.planning/STATE.md`
- **Verification:** both lines carry the `-- Phase 03 Plan 03 complete (…)` suffix; STATE.md is 117 lines, under the 150-line ceiling.
- **Committed in:** the trailing `docs(03-03)` metadata commit

---

**Total deviations:** 7 auto-fixed (3 missing-critical under Rule 2, 4 bugs under Rule 1)
**Impact on plan:** All seven strengthen the record's machine backing, correct a figure the plan itself flagged as suspect, or repair state metadata that the close-out tooling wrote inconsistently. Deviations 1 and 2 close gaps that would have made an EXP-08 assertion silently unfalsifiable — the precise failure class this phase's standing rule ("an assertion never observed failing is not a gate") exists to prevent. Deviations 6 and 7 were introduced by this plan's own `gsd-sdk` state writes and are repaired in the same close-out, so no commit ships a self-contradictory STATE.md. No scope creep: outside `.planning/`, zero files were touched, and `docs/` is byte-unchanged.

## Issues Encountered

None. Two verification-tooling notes worth carrying:

- Two of Task 2's acceptance-criteria spot-checks initially read as failures because my `grep -F` patterns included markdown bold markers (`never** say "achieved"`) or matched the table **header** row. Both were pattern artifacts, not content gaps — re-grepped correctly, all criteria pass. Lesson for later plans: when spot-checking a markdown artifact, grep the prose substring, not the marked-up form.
- The P3 net's census is **byte-stable at 46 FAILs / 0 unowned** across all three commits, as it must be — this plan touched no script.

## Verification Evidence

| Check | Result |
|---|---|
| `test -f 03-DECISION-RECORD.md` | FOUND — 586 lines (`min_lines: 90`) |
| `grep -Fc 'retain-and-revise'` | 12 (must_haves `contains`) |
| `grep -c 'CODEBASE-EVIDENCE.md:'` | 28 (key_link pattern) |
| `grep -c 'main.tex:'` | 61 (key_link pattern) |
| Disposition rows A1–A12 | 12 rows; source anchors span `:151`–`:165`; **0** `retire` rows |
| Section C anchors | `:172 :174 :175 :177 :178 :179 :186 :187 :188 :190 :192` |
| `test -x scripts/verify-phase3-regressions.sh` | **succeeded** — 03-01 Task 2's net was on disk, so Task 3's EXP-08 corroboration was a real observation, not a swallowed missing-file error |
| `EXP-08` slice of the P3 net | **6 PASS, 0 FAIL** (P3.67–P3.72) — a non-zero slice, so not a vacuous zero-line pass |
| `LC_ALL=C grep -Fc` in `docs/main.tex` | `AssumeRole` 0 · `6-week` 0 · `mentored` 0 |
| Draft text scanned for `$` / `%` / headcount | 0 dollar signs, 0 percent signs; only numerals are `6-week`, `60s`, `8-thread` — all evidence-cited |
| `bash scripts/verify-resume.sh` | exit **0** after every task |
| `bash scripts/verify-phase2-regressions.sh` | exit **0**, 27 anchored `^RESULT P2\..*PASS` lines after every task |
| `bash scripts/verify-phase3-regressions.sh` | exit 1 with **46** FAILs, **0** unowned — byte-identical across all three commits |
| `git status --porcelain docs/` | **empty** throughout |
| `git log --oneline -1 -- docs/main.tex` | `29999ff` (Phase 2) — no content edit preceded this plan |
| `git diff --diff-filter=D` per commit | no deletions |

## Self-Check: PASSED

- `03-DECISION-RECORD.md` exists on disk at the declared path (586 lines).
- All three task commits resolve in `git log --oneline --all`: `8dd7d83`, `8711931`, `645deae`.
- Every task's `<automated>` gate and every acceptance criterion re-run and passing at close-out.
- Plan-level `<verification>` re-run: `docs/` clean, both standing nets green, EXP-08 slice all PASS against an existing net.

## User Setup Required

None — no external service configuration required. This plan installs zero packages (threat `T-03-SC` closed by construction).

## Next Phase Readiness

**Ready for 03-04 (Adobe rebuild).** The three things a content plan needs are now fixed and greppable:

- **What may change and what may not** — the disposition table (zero retires) plus the seven frozen surfaces.
- **What each figure is allowed to claim** — 14 traced figures, 2 named retirements, the Ray-attribution and Content-Gate framing rules as wording constraints, and the `\textasciitilde{}700M` / bare-`~` encoding rules.
- **How much room there is** — +4-line ceiling, +3 expected spend, one line reserved for EXP-08, and a three-threshold ladder that lets a plan decide to back an edit out without re-deriving the budget.

**Binding constraints handed forward:**

1. **Ordering (Pitfall 7):** the A12 governance group lands the second `Rust` copy, so it must land **before or with** any A9 reword. `scripts/verify-phase3-regressions.sh` Group 3's `Rust`-count ≥2 clause enforces it.
2. **Never net-free a rendered line.** `G3.2` p1 must never rise above +50.5pt; `bash scripts/verify-resume.sh` stays green through this failure, so it is only visible under `make verify-selftest`. Spend before you free; no wave may end net-freed.
3. **Assert the value in the `G5.4` message, not the absence of a FAIL** — `G5.4` is warn-tier and cannot fail. Baseline 8; criterion 4 requires ≥8; `DIGIT_BULLET_FLOOR` is never lowered. And `G5.4` cannot see a digit that wrapped onto a continuation line, so put a digit on the owning bullet's **first** rendered line.
4. **Line-neutrality must be re-derived from region boundaries**, never from the literal gate numbers 36–46 / 54–62 — those shift the moment Adobe grows.
5. **Governance topic ships topic-only.** The `\resumeTopic`-plus-nested-item shape measures 4 rendered lines — the entire budget — and is forbidden.

**For 03-07/03-08 (the EXP-08 checkpoint and conditional wave):**

- Four drafts are ready with owning topics, evidence citations and estimated costs; **cost must be re-measured after the build, never trusted from the estimate.**
- **Candidate (c) needs a needle added in the same commit that ships it** — it has none today.
- **Draft casing is load-bearing:** the flip needles are case-sensitive fixed strings.
- The checkpoint's `<context>` must quote the measured `G3.2` figure so the user knows whether the reserve survived, and must present the mentoring draft as a **fact the evidence pass could not reach** rather than a framing choice.
- Rejecting every draft is a **green** outcome (D-14).

**No blockers introduced.** The pre-existing `[Phase 3] EXP-08 hard sign-off checkpoint` and `[Phase 5] torch.compile CUDA-graphs config read` concerns are untouched by this plan.

---
*Phase: 03-adobe-rebuild-staff-signal-bullets*
*Completed: 2026-08-22*
