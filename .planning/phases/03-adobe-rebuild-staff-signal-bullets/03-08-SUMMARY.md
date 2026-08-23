---
phase: 03-adobe-rebuild-staff-signal-bullets
plan: 08
subsystem: resume-content
tags: [exp-08, mentoring-bullet, compression, make-wiring, regression-net, wr-01, end-state, phase-close]

# Dependency graph
requires:
  - phase: 03-07
    provides: "the `[Phase 3 / EXP-08]` verdict record -- three drafts REJECTED, the mentoring line APPROVED with its byte-exact wording, `staff-signal: yes`, and the binding budget arithmetic that the approved draft needs compressing to one rendered line or backing out"
  - phase: 03-06
    provides: "the entering headroom G3.2 p1 +17.1pt (+1.49 lines) with the EXP-08 reserve intact, the P3 net at exit 0 with 72 anchored PASS, and the boundary-derivation rule for role regions"
  - phase: 03-02
    provides: "the Phase-2 net's make wiring, whose shape this plan reuses to close the same audit finding for the Phase-3 net"
provides:
  - "the approved mentoring claim SHIPPED, compressed from 284 to 133 characters (prefix included) so it lands as ONE rendered line inside the +17.1pt fund; page 1 closes at +5.9pt, still 2 pages"
  - "both EXP-08 sign-off outcomes machine-asserted: P3.71/P3.72 flipped absent->present on `mentored` in the shipping commit, P3.67-P3.70 keep their absence pairs for the two rejected drafts, both new assertions proven failable by crafted controls"
  - "`REGRESS3` wired into `make verify-regressions` AND chained into `make verify` ahead of the harness, so Phase 3 did not recreate the audit's unwired-net finding for the net it authored"
  - "the measured phase end state on .planning/STATE.md: the four-step page-1 walk, the +51.6pt derived overflow-probe margin, the WR-01 five-block measurement, two upstream artifact corrections, and the keyword-promotion ownership record"
  - "Phase 3 CLOSED: ROADMAP ticked with 8 plans listed, EXP-02/03/04/07/08 ticked with Traceability rows Complete, all five suites green"

affects: [phase-04, phase-05, phase-06]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "scratch-build candidate selection: compile every compression candidate under mktemp -d and read its rendered width, so the real artifact never takes an intermediate build that could overflow the page"
    - "per-draft assertion flip: an approved needle flips absent->present while every rejected needle keeps its absence pair, so 'exactly what was signed off shipped' is two assertions rather than one observation"
    - "ID-preserving placement: the flipped pair is placed after the draft loop so it inherits the assertion IDs every prior record cites, instead of renumbering the group"
    - "compress-by-dropping: an over-budget approved claim is narrowed by deleting detail and never by inventing, with every dropped fragment named in the record so a reader can confirm the claim was narrowed rather than reshaped"
    - "wire-when-green: a new standing net is chained into the default target at phase close, not mid-phase, so `make verify` is never red for the duration of the phase that authored the net"

key-files:
  created:
    - .planning/phases/03-adobe-rebuild-staff-signal-bullets/03-08-SUMMARY.md
  modified:
    - docs/main.tex
    - scripts/verify-phase3-regressions.sh
    - Makefile
    - .planning/STATE.md
    - .planning/ROADMAP.md
    - .planning/REQUIREMENTS.md
    - docs/AshutoshTiwari.pdf

key-decisions:
  - "Branch B applied: the approved mentoring claim shipped COMPRESSED to 131 prose / 133 total characters as a nested `\\resumeItem` in A6, preserving all three claim limbs (mentored onto the framework / onboarding guides authored / integrations reviewed), the lowercase mid-sentence `mentored` needle, and zero numerals -- the APPROVED-BUT-UNAPPLIABLE-WITHIN-BUDGET back-out was NOT needed"
  - "Branch C NOT triggered: the criterion-2 read is positive (scoped to the verdict marker line), so no lead-bullet revision was owed, Branch C's revision-authorization marker is correctly absent from STATE.md, and EXP-02 ticked on the positive read"
  - "The sanctioned Groupon/NetSpeed reword lever was NOT pulled: compressing the claim made the existing fund sufficient, so both descriptor literal sets stay byte-untouched and both forbidden shortened forms stay forbidden"
  - "MEASURED: itemize-3 line-1 capacity is ~133 characters for this character mix, not a flat 135 -- a 134-character candidate wrapped to two rendered lines in the scratch probe. Character count is a proxy for typeset width, never the width itself"
  - "MEASURED: real per-rendered-line cost is 11.2pt, not the 11.5pt LINE_PT the arithmetic assumed, so the phase closed at +5.9pt rather than the predicted +5.6pt -- 1.2pt above the back-out rung"
  - "WR-01 REVERSED 03-06's reading: Flipkart has RE-INVERTED to subtitle-first while the other four blocks stay employer-first, driven only by this plan's one added rendered line. Measured, deliberately not gated, and the Phase-4 BLOCKER candidacy now carries counter-evidence -- such an assertion would be red today on a correct document"
  - "PROBE_LINES stays 5 and DIGIT_BULLET_FLOOR stays 7: spending slack GREW the probe margin to +51.6pt, so the guard is more firmly armed at phase close than at phase start"
  - "`CUDA graphs` deliberately left unpromoted (D-07 ships the hyphenated singular, which the plural fixed-string target cannot match) and the Class E `CUDA` absence assertion deliberately not added (D-08 resolved to the branch where the clause legitimately names it)"

patterns-established:
  - "Marker hygiene: never reproduce a machine-read marker inside prose the same grep will scan -- describe it and cite where it is defined. Caught three times in one bullet draft during this plan"
  - "Both-header-row region derivation: derive a role region from max(employer, subtitle) + 1, never from the subtitle alone, because the subtitle can extract first and the employer line then falls inside the derived region"
  - "Anchored status counting extends to SKIP: `^RESULT G[78]\\.[0-9]+ +SKIP` -- an unanchored SKIP grep matches the word inside G8.2's own success message and reports a phantom skip on a green self-test"

requirements-completed: [EXP-02, EXP-03, EXP-04, EXP-07, EXP-08]

# Metrics
duration: 17 min
completed: 2026-08-23
---

# Phase 3 Plan 08: Apply Approved Bullets, Wire the Net, Close the Phase Summary

**The one approved leadership claim shipped compressed from 284 to 133 characters so it fits page 1 as a single rendered line, both sign-off outcomes are machine-asserted, the Phase-3 net is reachable from `make`, and the phase closed green at a measured +5.9pt of page-1 headroom.**

## Performance

- **Duration:** 17 min
- **Started:** 2026-08-23T06:08:38Z (03-07 close)
- **Completed:** 2026-08-23T06:25:13Z
- **Tasks:** 3 of 3
- **Files modified:** 9 (6 tracked source/planning files + 3 regenerated artifacts)

## Accomplishments

- **The approved claim shipped inside budget without breaking anything, and without needing the pre-authorized back-out.** The sign-off record approved a 284-character draft and, in the same breath, measured that it renders as 3 lines against a 1-line fund. It shipped at **133 characters (131 prose + the 2-character prefix) as exactly one rendered line**, with all three limbs of the approved claim intact.
- **Candidate selection was measured in a scratch build, not guessed** — four candidates compiled under `mktemp -d` and their rendered widths read, so the real artifact never took an intermediate build that could overflow. This is what caught that a 134-character candidate wraps while the 133-character one does not.
- **Both sign-off outcomes are asserted, not one.** `P3.71`/`P3.72` flipped `assert_absent` → `assert_present` on `mentored` in the same commit that shipped the bullet; `P3.67`–`P3.70` keep their absence pairs for the rejected `AssumeRole` and `6-week`. **Both new assertions were proven failable by crafted controls** rather than assumed green.
- **Phase 3 did not recreate the audit's unwired-net finding for its own net.** `REGRESS3` runs from `make verify-regressions` and is chained into `make verify` ahead of the harness — wired at close, when green, so `make verify` was never red for the phase's duration.
- **WR-01's measurement overturned the prior reading**, and that is the most useful thing this plan learned: Flipkart's employer/subtitle inversion, recorded as self-healed by 03-06, **came back** from this plan's one added rendered line. A Phase-4 employer-first BLOCKER would be red today on a fully correct document.

## Task Commits

Each task was committed atomically:

1. **Task 1: Apply the approved bullet and flip the EXP-08 assertions** — `9feca81` (feat)
2. **Task 2: Make the Phase-3 net reachable from make** — `056d8f2` (build)
3. **Task 3: Measure the end state, record decisions, tick requirements** — `5a916d8` (docs)

**Pre-task:** `4781b13` (docs) — committed the pending single-file-source constraint record found in the working tree, so the tree was clean before Task 1.

## The shipped claim, against what was approved

| | Text | Chars (prose / +prefix) | Rendered lines |
|---|---|---|---|
| **Approved** | Grew the platform's engineering bench: mentored applied-ML and platform engineers onto the training and inference frameworks, authoring the architecture guide, runbook and multi-node launch templates teams onboard with, and reviewing their module integrations through to production. | 282 / 284 | **3** (derived) |
| **Shipped** | Grew the engineering bench: mentored engineers onto the framework, authored its onboarding guides, and reviewed their integrations. | 131 / **133** | **1** (measured) |

Position: nested `\resumeItem` in **A6 `\resumeTopic{Foundation Model Training Framework}`** — the owning topic the record named.

**What was dropped, exhaustively:** `platform's`; the enumeration `architecture guide, runbook and multi-node launch templates teams onboard with` → `its onboarding guides`; the qualifier `applied-ML and platform` on engineers; `training and inference` on frameworks; `module … through to production` on integrations. **Every dropped fragment narrows the claim — not one word claims more than the approved text did.** Compression is entirely by dropping detail, never by inventing.

**Constraint compliance, each verified rather than asserted:**

| Constraint | Result |
|---|---|
| lowercase mid-sentence `mentored`, byte-exact | ✅ `bench: mentored engineers` — `P3.71`/`P3.72` both PASS at count 1 |
| D-13 no invented numerals (no headcount) | ✅ zero numerals in the shipped string |
| ≤135 chars prose-plus-prefix → one rendered line | ✅ 133, measured as one rendered line at gate 21 |
| `achiev` ×0 | ✅ `LC_ALL=C grep -Fci achiev docs/main.tex` = 0 |
| no rejected draft in any wording | ✅ `AssumeRole` and `6-week` ×0 in source and text layer |
| ASCII only | ✅ `G6.4` PASS; the only census move is U+2013 38 → 39, the bullet's own declared prefix glyph |

## Measured end state — the numbers Phase 4 inherits

| Quantity | Measured |
|---|---|
| `G1.1` | **PASS — 2 pages**, manifest `PAGES=2` |
| `G2.1` | **PASS** — page 2 still opens at `PUBLICATIONS` |
| `G3.1` | deepest content bottom **758.5pt** vs ceiling **764.4pt** |
| **`G3.2` p1 headroom** | **+5.9pt (+0.51 lines)** |
| **`G3.2` p2 headroom** | **+53.5pt (+4.65 lines)** |
| Derived **`G7.2` margin** | **57.5pt − 5.9pt = +51.6pt** (was 7.0pt at Phase 2 close) |
| Adobe rendered region | **22 lines (gate 8–29)** — 18 → 22, **+4 across the phase**, exactly the ledger ceiling |
| Swiggy / Flipkart | **11** (gate 34–44) / **9** (gate 49–57) — line-neutral all phase |
| `G5.4` digit-bearing | **11** against `DIGIT_BULLET_FLOOR=7` |
| `G6.5` | **17 PASS**, 0 FAIL |

**Page-1 walk, all four steps:** `+50.5pt` (arrival) → `+28.1pt` (03-04, governance topic +2) → `+17.1pt` (03-05, Ray swap +1) → `+17.1pt` (03-06, line-neutral) → **`+5.9pt`** (03-08, mentoring claim +1). Rail 1 (never a fifth line) and rail 2 (p1 never rises above +50.5pt) both held at every intermediate commit.

**Two predictions superseded by measurement:** the ledger predicted the +4 ceiling lands p1 at **+4.7pt**, and the sign-off record predicted the final line lands it at **+5.6pt**. It measured **+5.9pt**, because the real per-rendered-line cost is **11.2pt** rather than the 11.5pt `LINE_PT` the arithmetic assumed. The phase closed **1.2pt above** the back-out rung, not on it.

**`PROBE_LINES` stays 5** — raise-only, and 5.9pt of slack is nowhere near the 57.5pt that would stop the probe proving anything. **`DIGIT_BULLET_FLOOR` stays 7**, not raised toward the measured 11. `docs/verify/manifest.txt` byte-unchanged by this plan; `docs/verify/baseline-frozen.txt` untouched all phase.

## WR-01 — the five-block extraction order, measured and not fixed

| Block | employer @ | subtitle @ | Order |
|---|---|---|---|
| ADOBE FIREFLY | 9 | 10 | employer-first |
| SWIGGY | 38 | 39 | employer-first |
| **FLIPKART (a Walmart company)** | **57** | **56** | **SUBTITLE-FIRST** |
| GROUPON | 72 | 73 | employer-first |
| NETSPEED SYSTEMS (Acquired by Intel) | 81 | 82 | employer-first |

`03-06-SUMMARY` measured **all five employer-first** and recorded the Flipkart inversion as self-healed once Adobe reached 21 rendered lines. This plan's one added line took Adobe to 22 and **un-healed it**. No `\resumeSubheading` was touched.

That settles the ordering's nature: **a `pdftotext` row-position artifact of a two-cell `tabular*` row, not a property** — it flips both ways on a purely cosmetic y-shift. It was **measured, not fixed**; no employer-first BLOCKER was added. The Phase-4 candidacy stands but now carries counter-evidence: such an assertion **would be red right now on a fully correct document**. If Phase 4 wants coverage, the assertable property is that the two header rows are *adjacent*, never which extracts first.

`G6.13` remains a **WARN owned by Phase 3**, firing on all five blocks (Flipkart at span 5, the rest at 4) — claimed, not cleared. `ROLE_BIND_WINDOW` stays a local constant.

## Files Created/Modified

- `docs/main.tex` — one nested `\resumeItem` added to the A6 training-framework topic (+1 source line, +1 rendered line)
- `scripts/verify-phase3-regressions.sh` — `mentored` moved out of the absent-by-default draft loop into an explicit `assert_present` pair placed *after* the loop so it keeps IDs 71/72; the two rejected drafts' remediation messages rewritten to read as enforced verdicts rather than pending work; group header and two header-doc blocks updated to describe both outcomes
- `Makefile` — `REGRESS3` variable; `@bash $(REGRESS3)` in both `verify-regressions` and the chained `verify` recipe; target index line and doc comment updated to name both nets
- `.planning/STATE.md` — five `[Phase 3 / 03-08]` decision bullets (the compression record + the four Task-3 end-state records)
- `.planning/ROADMAP.md` — Phase 3 ticked with completion date; 03-08 ticked in the plan list (all 8 listed, `**Plans:** 8` already correct)
- `.planning/REQUIREMENTS.md` — EXP-02/03/04/07/08 ticked; their five Traceability rows set to Complete
- `docs/AshutoshTiwari.pdf`, `.log`, `.fdb_latexmk` — regenerated, riding in the Task 1 source commit

## Decisions Made

See `key-decisions` frontmatter and the five `[Phase 3 / 03-08]` bullets on `.planning/STATE.md`. Two are worth restating.

**The back-out path was pre-authorized and deliberately not taken.** 03-07 handed this plan an approval together with a measurement that it could not be applied as approved, plus explicit permission to record `APPROVED-BUT-UNAPPLIABLE-WITHIN-BUDGET` and keep the absence assertions. Taking that path would have left the phase green and would have been defensible. It was not taken because a faithful one-line rendering *does* exist: every limb of the claim survives, and the compression only ever narrows. Backing out would have discarded a claim the user explicitly approved on a budget problem that compression solves.

**The reword lever stayed sheathed.** 03-07 measured that the Groupon/NetSpeed lever recovers ≈0 rendered lines and therefore could not fund the addition. Compressing the claim itself made the existing +17.1pt fund sufficient, so no reword rides in the commit at all — both descriptor literal sets are byte-untouched, both forbidden shortened forms stay forbidden, and the `C++ graph algorithms` anchor that ROADMAP Phase 5 criterion 4 rests on was never put at risk. The P2 net reads **27** anchored PASS unchanged.

## Deviations from Plan

**None — plan executed exactly as written.** No deviation rule fired. Task 1 resolved to Branch B (one approved draft) with Branch C not triggered, exactly as 03-07 predicted; Tasks 2 and 3 were unconditional.

Three things worth distinguishing from deviations because they *look* like them:

- **Compressing the approved wording is not a departure from the plan — it is the plan.** Task 1's action text says to ship "exactly the wording it records," and the record's own CONSEQUENCE clause instructs 03-08 to land the claim at ≤135 characters or back it out. The compression is the instruction, and the shipped string is recorded verbatim beside the approved one so nothing rests on memory.
- **Rewriting the two rejected drafts' `assert_absent` remediation messages** was not in the plan's letter, which says to leave those pairs "exactly as they are." Their *assertions* are byte-identical in needle, stream and helper — what changed is the human-facing message, which still said "if the bullet was approved, 03-08 flips THIS needle." Left alone, the net would have told a future reader that a rejected draft's absence was pending work rather than an enforced verdict. The guarantee the plan protects (absence stays machine-asserted) is untouched; only the prose that describes it was corrected.
- **The pre-task commit** (`4781b13`) is not this plan's work. The single-file-source constraint record was already uncommitted in the working tree on arrival; committing it first kept Task 1's commit atomic instead of sweeping an unrelated record into it.

## Issues Encountered

- **A machine-read marker collided with prose that merely quoted it — three times in one draft bullet, caught before commit.** This is the **fifth sighting** of this phase's signature defect class. The first draft of the compression record quoted (1) Branch C's `EXP-02 tick rests on the applied revision` marker, taking its file count 0 → 1, which would have told Task 3's gate that a revision had landed when none did; (2) the criterion-2 token's colon form, taking that token 1 → 2 and colliding with the marker-line-scoped read the `[Phase 3 / 03-05]` standing rule prescribes; and (3) `[Phase 3 / EXP-08]` itself, taking its count 1 → 2, which fails Task 3's own uniqueness assertion outright. All three were caught by running the gate greps against the draft before committing. Resolved by describing each marker and citing where it is defined instead of reproducing it. **Standing rule for Phases 4–6:** never reproduce a machine-read marker inside prose the same grep will scan.
- **An unanchored SKIP count reported a phantom skip on a green self-test.** `grep -cE '^RESULT G[78]\..* SKIP'` returned 1 against a self-test with ten PASS and zero skips — the match was inside `G8.2`'s own *success* message (`…which G0.3 reported as SKIP`). The anchored form `^RESULT G[78]\.[0-9]+ +SKIP` returns 0. This is the same trap already recorded three times for the P2 net's PASS side and the P3 net's FAIL side, now confirmed on the SKIP side too: **anchor every status count, on every status.**
- **A subtitle-anchored region derivation over-counted Flipkart by one rendered line** (read 10, actual 9) because the employer line now extracts *after* the subtitle and falls inside the derived region. Fixed by deriving from `max(employer, subtitle) + 1`. This is precisely the hazard `[Phase 3 / 03-06]` warned about, now demonstrated live — recorded so Phase 4 does not rediscover it.
- **Pre-existing untracked `.omc/` directory**, present before this plan started and unrelated to it. Out of scope per the scope boundary: not touched, not committed, not gitignored. Flagged only so a later reader does not read it as this plan's output.

## User Setup Required

None — no external service configuration required. The one human input this phase needed (the per-bullet sign-off) was taken and recorded at 03-07.

## Next Phase Readiness

**All five suites green at the end state:**

| Suite | Result |
|---|---|
| `bash scripts/verify-resume.sh` | **exit 0** — 83 `RESULT` lines, 0 FAIL, 0 SKIP |
| `bash scripts/verify-phase2-regressions.sh` | **exit 0** — **27** anchored `^RESULT P2\..*PASS` |
| `bash scripts/verify-phase3-regressions.sh` | **exit 0** — **72** anchored PASS, **0** anchored FAIL |
| `make verify-selftest` | **exit 0** — ten G7/G8 PASS, zero anchored SKIP |
| `make verify` | **exit 0** — criterion-5 corroboration only, never the oracle |

**For Phase 4, explicitly:**

1. **Budget, both pages.** `G3.2` p1 **+5.9pt (+0.51 lines)** and p2 **+53.5pt (+4.65 lines)** at `LINE_PT=11.5`. Page 1 has **half a rendered line** left — treat it as full. Page 2's 53.5pt is the independent budget Phase 4 restructures behind the one-way `\newpage`. The real per-line cost measured on this document is **11.2pt**, not 11.5pt.
2. **Derived `G7.2` margin: +51.6pt** (57.5pt probe height minus 5.9pt final p1 slack), up from 7.0pt at Phase 2 close — spending slack *grew* the margin, so the anti-rot guard is more firmly armed than ever. **`PROBE_LINES` is raise-only and was NOT raised**; it stays **5**. It may only be raised if a future end state leaves *more* than 57.5pt of page-1 slack, and it can never be lowered afterwards. `DIGIT_BULLET_FLOOR` stays **7**.
3. **The five-block employer-order measurement, and its Phase-4 assertion candidacy.** Four of five blocks extract employer-first; **FLIPKART is subtitle-first** (employer@57 / subtitle@56). The order **re-inverted inside this phase** from a single added rendered line, so it is a row-position artifact and not a property. **An employer-first BLOCKER assertion would be RED TODAY on a correct document** — if Phase 4 adds coverage, assert *adjacency* of the two header rows, never which extracts first. Derive any role region from `max(employer, subtitle) + 1`, never from the subtitle alone.
4. **The `index.html:196` obligation is intact and still Phase 6's.** Both figures this phase retired are still live and public in the site's parallel Adobe block, and `index.html:207-225` still carries the career-break timeline entry (SITE-02). Both publish on every push to `master` via `.github/workflows/jekyll.yml`. Full record on `.planning/STATE.md` under `[Phase 3 / 03-02]`; the `Blockers/Concerns` entry stands.
5. **Standing-net invocation is now one command:** `make verify-regressions` runs **both** the P2.x and P3.x nets, and both are chained into `make verify` ahead of the harness. The direct gating invocation remains `bash scripts/verify-resume.sh && bash scripts/verify-phase2-regressions.sh && bash scripts/verify-phase3-regressions.sh`, because GNU Make 3.81 collapses exit 1 and exit 2 into its own 2.
6. **EXP-02 was TICKED, not gapped** — the criterion-2 qualitative read was positive, so there is **no `EXP-02 qualitative gap` item to inherit** and no ROADMAP annotation was written. Both canonical surfaces agree: ROADMAP Phase 3 is ticked plainly and all five REQUIREMENTS rows read Complete.

**Carried forward for Phase 5:** `G6.6`'s target-keyword WARN **fires unconditionally with no branch on the count**, so `G6.5`/`G6.6` are the promotion *convention* and not a promotion *gate* — the only machine backing is the P3 net's promotion triple `P3.42`–`P3.45`. `Triton` was promoted early by 03-05 (Phase-5-owned target; the `:phase` suffix is WARN routing, not permission), and PG2-04's Skills-tier form remains **additive**, not discharged. `CUDA graphs` stays unpromoted at ×0 by decision, because D-07 ships the hyphenated singular the plural fixed string cannot match.

**Carried concern, unchanged:** the `G6.13` WARN on all five role blocks remains owned by Phase 3 — claimed and recorded, not cleared.

## Self-Check: PASSED

Every claim above was re-verified after this SUMMARY was written, not asserted:

| Check | Result |
|---|---|
| `03-08-SUMMARY.md` exists | **FOUND** |
| Commit `9feca81` (Task 1) | **FOUND** — `feat(03-08): ship the approved mentoring bullet and assert the rejected ones absent` |
| Commit `056d8f2` (Task 2) | **FOUND** — `build(03-08): run both standing content nets from the regression target` |
| Commit `5a916d8` (Task 3) | **FOUND** — `docs(03-08): record the phase-3 end state and close its requirements` |
| Commit `4781b13` (pre-task) | **FOUND** — `docs: record the single-file LaTeX source constraint` |
| `bash scripts/verify-resume.sh` | **exit 0**, 83 RESULT, 0 FAIL, 0 SKIP |
| `bash scripts/verify-phase2-regressions.sh` | **exit 0**, **27** anchored PASS |
| `bash scripts/verify-phase3-regressions.sh` | **exit 0**, **72** anchored PASS, **0** anchored FAIL |
| `make verify-selftest` | **exit 0**, 10 anchored G7/G8 PASS, **0** anchored SKIP |
| `make verify` | **exit 0** |
| `P3.71` / `P3.72` | **PASS** — `mentored` present ×1 in both `docs/main.tex` and the text layer |
| `P3.67`–`P3.70` | **PASS** — `AssumeRole` and `6-week` absent in both streams |
| new presence pair proven failable | **yes** — `--gate-text` fixture reddens `P3.72`; scratch `--tex` copy reddens `P3.71`; exit 1 both times |
| `make -n verify-regressions` / `make -n verify` | **2 net invocations each**; in `verify` both precede `verify-resume.sh` |
| `grep -c 'REGRESS3' Makefile` | **5** (≥2 required) |
| `grep -c -- '--gate-text\|--skip-freshness' Makefile` | **0** |
| `LC_ALL=C grep -Fci achiev docs/main.tex` | **0** |
| `[Phase 3 / D-08]` count | **1** |
| `[Phase 3 / EXP-08]` count | **1** |
| `staff-signal:` count | **1**, on the verdict marker line, reads `yes` |
| Branch C revision marker count | **0** — correctly absent on a positive read |
| `index.html:196` count | **2** (≥1 required) |
| unticked EXP-02/03/04/07/08 boxes | **0**; zero Traceability rows read Pending |
| retired figure strings in ROADMAP / REQUIREMENTS | **still present** (`10–50` ×1, `3–8K` ×1 in each) — the record was not "cleaned" |
| retired figures in the PDF text layer | **0** each — criterion 3 holds |
| `git status --porcelain docs/verify/baseline-frozen.txt docs/verify/manifest.txt` | **empty** |
| shipped bullet rendered width | **133 chars, gate line 21, ONE rendered line** |
| file deletions in any of the four commits | **none** |

---
*Phase: 03-adobe-rebuild-staff-signal-bullets*
*Completed: 2026-08-23*
