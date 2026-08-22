---
phase: 02-page-1-budget-text-layer-defects
plan: 02
subsystem: resume-document
tags: [latex, pdftotext, ats, text-layer, verification-harness, negative-control, education-binding]

# Dependency graph
requires:
  - phase: 01-verification-harness
    provides: "scripts/verify-resume.sh + docs/verify/{manifest.txt,baseline-frozen.txt} — the acceptance oracle, and the --skip-freshness/mktemp negative-control recipe this plan reused"
  - phase: 02-page-1-budget-text-layer-defects
    provides: "Plan 01: 4 of 5 BLOCKERs cleared, G6.12 left as the sole live FAIL; the measured 50.4pt/4.39-line budget; the G7.2-PASSes finding that made the PROBE_LINES branch resolve to NO-RAISE"
provides:
  - "Education city cells dropped (D-09) — neither 'Bloomington, IN' nor 'Patna, India' appears in source or text layer, and both degree date ranges still extract whole-line"
  - "MEASURED: Education `\\resumeSubheading` #2 extracts BEFORE #1; the degree dates therefore ship in #4, not D-09's #2"
  - "G6.12 rewritten to an ANCHOR-FREE institution-first clause — the institution must BE the first non-empty extracted line inside the EDUCATION region"
  - "New reusable harness helper `region_first_nonempty <start> <end>`"
  - "EDU_CITY deleted from the manifest in the same commit as its only reader — the empty-needle trap avoided by construction"
  - "Negative control proving the new clause still FAILs on the pre-Phase-2 artifact pair (not a tautology)"
  - "THE GREEN GATE: bash scripts/verify-resume.sh exits 0 with 0 FAIL for the first time in the project"
  - "PROBE_LINES stays 5 with a recorded 7.0pt armed-guard margin"
  - "ROADMAP + REQUIREMENTS superseded-figure placeholders filled with the measured 50.4pt / 4.39 lines"
affects: [phase-03 (spends the 50.5pt page-1 slack on the Adobe rebuild; inherits a green gate as its regression baseline), phase-04 (PG2-03 owns Education GPA removal and re-triggers G6.12's institution-first clause), phase-05 (Skills), phase-06 (palette)]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Anchor-free region assertion: assert a positional property OF the region (`is the first non-empty line`) instead of comparing against a supplied needle — fires on every noise string, not just the one the needle names, and cannot degrade into an empty-needle match"
    - "Delete a manifest needle key and its only reader in ONE commit; a key that outlives its reader, or a reader that outlives its key, are both worse than leaving the pair alone"
    - "Negative control as the anti-tautology gate: after strengthening an assertion, re-run it against the pre-change artifact pair via `git show` into a `mktemp -d` (basename preserved) and require the FAIL"
    - "De-hardcode remedy line numbers into content locators when a later phase will move the code again"

key-files:
  created:
    - .planning/phases/02-page-1-budget-text-layer-defects/02-02-SUMMARY.md
  modified:
    - docs/main.tex
    - scripts/verify-resume.sh
    - docs/verify/manifest.txt
    - docs/AshutoshTiwari.pdf
    - docs/AshutoshTiwari.log
    - docs/AshutoshTiwari.fdb_latexmk
    - .planning/ROADMAP.md
    - .planning/REQUIREMENTS.md

key-decisions:
  - "D-09's date-placement sub-clause departed from ON MEASUREMENT: dates ship in `\\resumeSubheading` #4, not #2. Measurement A (date in #2, D-09 as written) extracted the date at line 94 BEFORE the institution at 96 — the defect class survived with a new noise string. Only #4 yields institution-first. D-09's actual decision (drop the city cells) shipped intact"
  - "G6.12's ordering clause made anchor-free rather than repointed: 'the institution IS the first non-empty line in the region'. Repointing EDU_CITY at the degree line would have gone GREEN on the measured date-first document — a false-PASS generator"
  - "EDU_CITY and its only reader (7 references, all inside the G6.12 block) deleted in one commit; deleting the key alone degrades `region_line_of` into `grep -Fx -- \"\"`, which matches the region's first BLANK line"
  - "PROBE_LINES stays 5 — G7.2 PASSes. Margin recorded: probe 57.5pt vs measured slack 50.5pt = 7.0pt (0.61 lines) of genuine overflow, so the anti-rot guard is armed rather than quiet"
  - "Artifacts ride in the SOURCE commit (29999ff), so HEAD (doc-only) does not list them; criterion 7's protected property was proven substantively by a real `git clone` of HEAD verifying at G0.3 PASS exit 0"
  - "ROADMAP criterion 5's own `≈8 from the fold` parenthetical reconciled as well as the note below it, so the two no longer contradict and neither re-seeds the superseded prediction"

patterns-established:
  - "Measure-then-branch, with the escalation gate pre-authorized: the plan enumerated both of D-09's date positions AND the STOP condition if neither worked, so the executor never had to choose between weakening an assertion and inventing a third arrangement"
  - "Strengthen-and-prove: every gate edit paired with a negative control that must still FAIL on the pre-change input"
  - "Measured margin instead of a bare PASS: a guard that passes is recorded with the numeric distance by which it passes, so a later phase can see when it is about to stop being armed"

requirements-completed: [EXP-01]

# Metrics
duration: 11 min
completed: 2026-08-22
---

# Phase 02 Plan 02: Education Parse Order, Anchor-Free G6.12 & the Green Gate Summary

**Education city cells dropped and the degree dates relocated to the cell measured to extract last, G6.12 rewritten from a needle comparison to an anchor-free institution-first assertion with a negative control proving it still fails on the old document — turning the project's last live BLOCKER green and landing `bash scripts/verify-resume.sh` at exit 0 for the first time.**

## Performance

- **Duration:** 11 min
- **Started:** 2026-08-22T18:44:19Z
- **Completed:** 2026-08-22T18:56:16Z
- **Tasks:** 3 of 3
- **Files modified:** 8 (3 source/harness + 3 tracked build artifacts + 2 planning docs)

## Accomplishments

- **THE GATE IS GREEN.** `bash scripts/verify-resume.sh` exits **0** with `>> PASS: 0 blocking failures.` and **zero** `RESULT ... FAIL` lines — the first time in the project. Arrival state was exit 1 with one BLOCKER (`G6.12`); Phase 2 as a whole took it from 5 to 0.
- **`make verify-selftest` exits 0** with all ten controls green: `G7.[1-4]` 4 PASS + `G8.[1-6]` 6 PASS, 0 FAIL, and **0 SKIP among them** (a `G8.3 SKIP` would have meant the staleness control silently did not run).
- **The Education defect was fixed structurally, and the fix was measured rather than assumed.** D-09's own date placement (`#2`) reproduced the defect with a new noise string; `#4` was measured to work. Both extraction orders are recorded verbatim.
- **`G6.12` is now strictly stronger than the clause it replaces** — anchor-free, so it fires on city-first, date-first and degree-first alike instead of only on the one string a needle names — and a negative control proves it still `FAIL`s on the pre-Phase-2 artifact pair.
- **`EDU_CITY` and its only reader disappeared together**, keeping the documented empty-needle trap unreachable. `EDU_HEADING`/`EDU_INSTITUTION`/`EDU_DATE`/`EDU_BIND_WINDOW` and the whole `EDU_LO`/`EDU_HI`/`EDU_SPAN` window computation survive untouched.
- **No threshold was moved to reach green.** `PROBE_LINES` stayed 5, `baseline-frozen.txt` is byte-unmodified across the entire phase, `ALLOW_FROZEN_UPDATE` was never invoked, and the whole-phase `manifest.txt` diff is exactly the `EDU_CITY` removal plus its explanatory comment.
- **A fresh `git clone` of `HEAD` verifies the committed PDF** at `G0.3 PASS` and exits 0 — the committed artifact is provably built from the committed source.

## Task Commits

Each task was committed atomically; Task 1 carries source and regenerated artifacts together (Plan 01 Decision 5 / 02-PATTERNS §6).

1. **Task 1: Drop the Education city cells and measure the resulting extraction order** — `29999ff` (feat)
2. **Task 2: Reconcile G6.12 to an anchor-free institution-first clause and prove it still fails on the old document** — `232abc2` (fix)
3. **Task 3: Reconcile PROBE_LINES, land the self-test green, and record the measured budget** — `10be4ab` (docs)

**Plan metadata:** see the `docs(02-02)` commit that carries this file.

## Files Created/Modified

- `docs/main.tex` — Education section (`:232-237`): both city cells (`#2`) dropped, both degree date ranges moved from `#4`… then back to `#4` after measurement, with `#2` left empty. Source `--` preserved in both ranges. GPAs retained.
- `scripts/verify-resume.sh` — new `region_first_nonempty` helper (`:395-414`, before the `--census` short-circuit at `:504`); `G6.12` block (`:1878-1930`) rewritten anchor-free with a refreshed block comment, remedy content-locator and `EDU_OWNER`. Net +41 lines.
- `docs/verify/manifest.txt` — `EDU_CITY=` deleted; 7-line comment recording why the anchor became unnecessary and why the key could not outlive its reader.
- `docs/AshutoshTiwari.pdf` — regenerated (225740 → 225534 bytes; the dropped city cells shorten page 2)
- `docs/AshutoshTiwari.log`, `docs/AshutoshTiwari.fdb_latexmk` — regenerated; log carries **0** `Overfull \hbox`. `.aux`/`.fls`/`.out` are tracked but byte-unchanged.
- `.planning/ROADMAP.md` — criterion 5's parenthetical and the `Superseded literals` note's `Measured figure:` placeholder both filled; Phase 2 checkboxes + Progress row.
- `.planning/REQUIREMENTS.md` — EXP-05's `(~8 lines freed)` replaced with the measured figure; EXP-01 closed.

## The Measurement That Drove Task 1

`pdftotext` default mode, `tr '\f' '\n'`, non-empty lines inside the `EDUCATION` region.

### Measurement A — date in `#2` (D-09 exactly as written)

```
  93| EDUCATION
  94| Aug. 2021 – May 2023                                      <- #2, extracts FIRST
  95| (blank)
  96| Indiana University, Bloomington                            <- #1
  97| Master of Science in Computational Data Science 3.87/4.0   <- #3
  98| (blank)
  99| Aug. 2011 – May 2015                                      <- #2
 100| (blank)
 101| National Institute of Technology                           <- #1
 102| Bachelor of Science in Computer Science 8.32/10.0           <- #3
```

**DATE-FIRST — the defect class survived.** `#2` is the cell measured to extract *first* in Education rows, so the date simply replaced the city as the string a parser reads before the school. This is precisely the consequence the plan's `<trap_resolutions>` T-1 anticipated, and precisely why repointing the needle at the degree line was rejected: on this document "institution precedes degree" is *true*, so a repointed `G6.12` would have gone green here.

### Measurement B — date in `#4`, `#2` empty (SHIPPED)

```
  93| EDUCATION
  94| Indiana University, Bloomington                            <- #1, FIRST non-empty
  95| Master of Science in Computational Data Science 3.87/4.0   <- #3
  96| (blank)
  97| Aug. 2021 – May 2023                                      <- #4
  98| (blank)
  99| National Institute of Technology                           <- #1
 100| Bachelor of Science in Computer Science 8.32/10.0           <- #3
 101| (blank)
 102| Aug. 2011 – May 2015                                      <- #4
```

**INSTITUTION FIRST.** Mechanically: `EDUCATION` at 93, first non-empty line after it at **94**, `Indiana University, Bloomington` at **94** — equal.

Work Experience rows still extract `#1` before `#2`; Education rows extract `#2` before `#1`. That asymmetry is not a source-order property and is exactly what `G6.12` exists to catch — which is why the plan mandated measuring, and why the escalation gate (STOP if neither `#2` nor `#4` works) was never needed.

## `G6.12` Before and After

| | Before | After |
|---|---|---|
| Ordering clause | `EDU_INST_AT -gt EDU_CITY_AT` — institution must precede a **supplied city needle** | `EDU_INST_AT -ne EDU_FIRST_AT` — institution must **BE** the region's first non-empty line |
| Anchors read | 3 (`EDU_INSTITUTION`, `EDU_CITY`, `EDU_DATE`) | 2 (`EDU_INSTITUTION`, `EDU_DATE`) + a measured region property |
| Fires on | city-first only | city-first, date-first, degree-first, anything-first |
| Empty-needle trap | reachable (needle can go absent) | unreachable by construction |
| Window clause | `EDU_LO`/`EDU_HI`/`EDU_SPAN` vs `EDU_BIND_WINDOW` | **identical, byte-untouched** |
| Remedy text | hardcoded `docs/main.tex:240-242` (stale) | content locator (Phase 4 moves these again) |
| `EDU_OWNER` | `Phase 2` | `Phase 4 / PG2-03`, recording Phase 2 / EXP-01 fixed it |

Shipped `PASS`:

```
RESULT G6.12  PASS  Education binding intact inside the 'EDUCATION' region (gate lines 94-103):
                    the institution line 'Indiana University, Bloomington' (line 94) is the first
                    non-empty line in the region, and date line 97 is 2 non-empty line(s) away
                    (window 3)
```

## Negative Control — the Anti-Tautology Proof

Pre-Phase-2 `main.tex` + `AshutoshTiwari.pdf` (`f278020`, the commit before Plan 01's first) copied via `git show` into a `mktemp -d` with the basename `main.tex` preserved, then run with `--pdf` / `--tex` / `--skip-freshness`. Its `EDUCATION` region leads with `Bloomington, IN` at line 100. Verbatim, exit **1**:

```
RESULT G0.3   SKIP  freshness proof waived by explicit request (--skip-freshness); this run's
                    content results do NOT certify the committed artifact
RESULT G6.12  FAIL  Education binding broken inside the 'EDUCATION' region (gate lines 100-113)
                    -- ordering: the institution line 'Indiana University, Bloomington' (line 102)
                    is NOT the first non-empty line in the region -- line 100 comes first and
                    reads 'Bloomington, IN', so a text-only parser reads that instead of the
                    school; reorder the \resumeSubheading arguments in the Education section of
                    docs/main.tex so the institution cell is what extracts first.
                    Owner: Phase 4 / PG2-03 (...)
```

`G0.3 SKIP` confirms `--skip-freshness` was the only waiver used. The flag appears in **no** Makefile target (`grep -c 'skip-freshness' Makefile` == 0). **The clause was fixed, not weakened.**

## `PROBE_LINES` (T-2) — Resolved by the Oracle, Not a Prediction

```
RESULT G7.2   PASS  the probe PDF is 3 page(s), above the manifest PAGES=2 budget,
                    so the +5 probe is a genuine overflow
```

**`PROBE_LINES` stays 5.** Margin proving the anti-rot guard is *armed* rather than merely quiet:

| Quantity | Value |
|---|---|
| Probe height (`PROBE_LINES` 5 × `LINE_PT` 11.5) | **57.5pt** |
| Measured page-1 slack (`G3.2`) | **50.5pt** (+4.39 lines) |
| **Probe exceeds available slack by** | **7.0pt** (0.61 lines) |

`02-PATTERNS.md` §5.5 predicted this trap would fire, on the premise that the phase would free 10–11 lines (115–127pt). It freed 50.4pt, which sits *below* the probe's 57.5pt, so the probe still pushes the document to 3 pages against `PAGES=2`. Raising `PROBE_LINES` would have enlarged a probe that already overflows — weakening the guard for no reason, irreversibly, since the raise-only rule forbids lowering it later. `PAGES`, `CEILING_PT` and `LINE_PT` are untouched.

## Superseded Figures — Filled, Not Duplicated (D-08)

All three sites that carried the same superseded prediction now agree on the measured value:

| Site | Was | Now |
|---|---|---|
| `ROADMAP.md:56` (`Superseded literals` note) | `Measured figure: _recorded by 02-02 Task 3_` | **50.4pt / 4.39 lines**, broken down: career-break **48.9pt / 4.26 lines** + fold **1.5pt / 0.13 lines** |
| `ROADMAP.md:52` (criterion 5's own parenthetical) | `≈4.25 from the career-break row + ≈8 from the fold` | `≈4.25 from the career-break row` **retained** + measured **0.13 lines / 1.5pt**, with an explicit D-08 supersession marker |
| `REQUIREMENTS.md:22` (EXP-05) | `(~8 lines freed)` | measured **1.5pt / 0.13 lines** from the fold + the 50.4pt / 4.39-line total, marked superseded by D-08 |

Exactly **one** `Superseded literals` note remains; the `ashutosh--tiwari` binding, the STATE.md reference and the D-08 citation are intact. Criterion 5's `**≥12 lines**` text is left as written — superseded by the note, never rewritten. The measured `≈4.25 from the career-break row` term was retained, not collaterally deleted.

## Requirement Coverage (Task 3 criterion 10)

| Requirement | Satisfied by | Evidence |
|---|---|---|
| **EXP-01** — career-break entry removed; Education carries the master's dates | Plan 01 Task 2 (career-break deletion) **+ this plan's Tasks 1–2** (D-09 Education fix, the `G6.12` BLOCKER that kept it open) | `Career Break` == 0 in source and text layer; `Aug. 2021 – May 2023` extracts whole-line ×1; `G6.12 PASS`. Closed here, as Plan 01 Decision 4 specified |
| **EXP-05** — Groupon + NetSpeed folded, C++/NoC retained | Plan 01 Task 3 | Already `[x]`; this plan only corrected its superseded parenthetical |
| **EXP-06** — LinkedIn en-dash fixed, portfolio URL literal | Plan 01 Task 1 | Already `[x]`; `ashutosh–tiwari` == 0, `ashutosh--tiwari` ≥ 1 |

**Criterion 5's figure is the measured `50.4pt / 4.39 lines` — explicitly NOT 12.** The `≥12 lines` literal is superseded by D-08 and by the ROADMAP note, and no threshold was adjusted to make the original prediction come true.

## Acceptance Criteria — Verification Log

### Task 1 (9/9 PASS)

| # | Criterion | Measured |
|---|---|---|
| 1 | `Bloomington, IN` / `Patna, India` == 0 in gate **and** source | 0 / 0 / 0 / 0 |
| 2 | Both degree ranges `-Fxc` == 1 | `Aug. 2021 – May 2023` 1; `Aug. 2011 – May 2015` 1 |
| 3 | Both institutions `-Fxc` == 1 | 1 / 1 |
| 4 | GPAs retained ≥ 1 | `3.87/4.0` 1; `8.32/10.0` 1 |
| 5 | Region order recorded; first non-empty line **is** the institution | EDUCATION 93, first non-empty 94, institution 94 — equal |
| 6 | exit 1, RESULT FAIL == 1, sole FAIL `G6.12`, message contains `unmeasurable` | exit 1; 1; `G6.12`; yes |
| 7 | `docs/verify/` + `scripts/` untouched | 0 changed files |
| 8 | `G5.1`/`G5.2`/`G5.5` 5 PASS each (15), 0 FAIL; `G4.1` `G1.1` `G2.1` `G3.4` `G6.8` PASS | 5/5/5 = 15, 0 FAIL; all present (`G6.8` 7 PASS) |
| 9 | Date-first branch documented with the forcing measurement + cities still dropped | Measurements A and B above; cities 0 |

### Task 2 (11/11 PASS)

| # | Criterion | Measured |
|---|---|---|
| 1 | exit **0**, `>> PASS: 0 blocking failures.`, RESULT FAIL == 0 | 0; present; 0 |
| 2 | `G6.12 PASS` == 1, names `first` + the institution | 1; both present |
| 3 | `EDU_CITY` == 0 in harness **and** manifest | 0 / 0 |
| 4 | 4 real `EDU_` key lines; 4 `manifest_get EDU_` readers (was 5) | 4 / 4 |
| 5 | `region_first_nonempty` ≥ 2 occurrences; definition before `--census` | 3; def `:405` < census `:504` |
| 6 | 0 removed `EDU_(LO\|HI)=` diff lines; `EDU_SPAN` count unchanged at 4 | 0; 4 |
| 7 | Negative control `G6.12` **FAIL**, that run's `G0.3` == `SKIP` | FAIL; SKIP (verbatim above) |
| 8 | 0 `expected_fail\|allowlist\|known_fail\|\|\| true` | 0 |
| 9 | 0 threshold diff lines; `baseline-frozen.txt` unmodified | 0; 0 |
| 10 | `shellcheck -f gcc` == 1 finding (pre-existing `SC2329` on `cleanup`); no `disable` added | 1 (now `:473`, was `:452` — same finding, shifted by the helper); 0 |
| 11 | RESULT lines ≥ 83 across 39 distinct IDs | 83; 39 |

### Task 3 (11/11 PASS — criterion 7 with a documented deviation)

| # | Criterion | Measured |
|---|---|---|
| 1 | Both gates exit 0 | gate 0 with `>> PASS: 0 blocking failures.`; self-test 0 |
| 2 | `G7.[1-4]` 4 PASS + `G8.[1-6]` 6 PASS = 10; 0 FAIL; `G8.3` not SKIP | 4 + 6 = 10; 0 / 0; `G8.3` **PASS** |
| 3 | `PROBE_LINES` integer ≥ 5; margin recorded if unchanged | 5, 0 diff lines this phase; margin 57.5pt vs 50.5pt = 7.0pt |
| 4 | 0 other budget-key diff lines | 0 (whole phase, vs `f278020`) |
| 5 | `baseline-frozen.txt` unmodified across the phase; no `ALLOW_FROZEN_UPDATE` | 0 changed; never invoked |
| 6 | `skip-freshness` absent from Makefile | 0 |
| 7 | Freshness record committed; clean-tree `G0.3 PASS` exit 0 | `G0.3 PASS` exit 0; **fresh `git clone` of HEAD** also clean + `G0.3 PASS` + exit 0. Artifacts are in `29999ff`, not HEAD — see Deviations |
| 8 | No NEW porcelain entry vs pre-task snapshot; every `files_modified` path absent | `comm -13` == 0 (pre and post both exactly `?? .omc/`); all 11 paths absent |
| 9 | Placeholders filled not duplicated; `≈4.25` retained; Progress `Complete` | `Superseded literals` 1; `recorded by 02-02 Task 3` 0; `(~8 lines freed)` 0; `≈8 from the fold` 0; `≈4.25 from the career-break row` 1; row `2/2 Complete` |
| 10 | EXP-01/05/06 mapped; criterion-5 figure measured, not 12 | see Requirement Coverage |
| 11 | No package manager; no new `\usepackage` | 0 added `\usepackage` vs `f278020`; no `npm`/`pip`/`pipx`/`cargo`/`uv`/`brew install` run |

### Plan-level `<verification>` (8/8 PASS)

| # | Check | Result |
|---|---|---|
| 1 | gate exit 0, `>> PASS: 0 blocking failures.`, RESULT FAIL == 0 | **0**; present; **0** |
| 2 | self-test exit 0, 4 `G7` + 6 `G8` PASS (10), no SKIP among them | **0**; 4 + 6 = **10**; SKIP **0** |
| 3 | `G(0.3\|4.1\|6.12) PASS` count | **3** |
| 4 | text-layer literals | `Bloomington, IN` 0; `Patna, India` 0; `Aug. 2021 – May 2023` 1; `ashutosh–tiwari` 0; `ashutosh--tiwari` 1; `Career Break` 0 |
| 5 | `EDU_CITY` == 0 in harness and manifest | 0 / 0 |
| 6 | `baseline-frozen.txt` unmodified vs phase base | 0 |
| 7 | negative control re-runnable → `G6.12 FAIL` | exit 1, `G6.12 FAIL` reproduced |
| 8 | no NEW porcelain entry; `.fdb_latexmk` committed | 0 new; in `29999ff` with its source (see Deviations) |

## Decisions Made

1. **D-09's date-placement sub-clause was departed from, on measurement.** The dates ship in `\resumeSubheading` `#4`, not `#2`. Measurement A proved `#2` is the cell that extracts *first* in Education rows, so following D-09 literally would have replaced the city with a date as the pre-institution noise string. D-09's actual decision — drop the redundant city cells — shipped intact; no city cell was restored, no assertion weakened, no third cell arrangement invented. The plan's Task 1 branch table pre-authorized exactly this move.
2. **`G6.12` was made anchor-free rather than repointed.** Repointing `EDU_CITY` at the degree line needed no harness edit and would have passed on the date-first document — a false-PASS generator that silently un-asserts the defect. The anchor-free form is strictly stronger: it encodes the clause's *purpose* ("the institution binds before location noise") instead of one instance of it, and eliminates the empty-needle trap structurally rather than by care.
3. **`EDU_CITY` and its only reader were deleted in one commit.** All seven references sat inside the `G6.12` block, so the removal is contained. Deleting the key alone is documented as *worse* than leaving it (empty needle → `grep -Fx -- ""` → first blank line); deleting the reader alone leaves dead config. One commit is the only safe ordering.
4. **The window clause was preserved as mechanics, not as text.** `EDU_LO`/`EDU_HI`/`EDU_SPAN` and the `EDU_BIND_WINDOW` comparison are byte-identical. The `PASS` message *was* rewritten — unavoidably, since the old one interpolated the removed variable — and still states the measured span and window, per the plan's explicit criterion-6 exemption.
5. **`PROBE_LINES` stayed 5 and the margin was recorded.** `G7.2` PASSes; the guard is armed by 7.0pt. Raising it would enlarge an already-overflowing probe and, given the raise-only rule, could never be undone.
6. **Artifacts ride in the source commit.** `29999ff` carries `main.tex` + `.pdf` + `.log` + `.fdb_latexmk` together, so no commit in this phase's history has a PDF that `G0.3` would refuse at exit 2. This continues Plan 01 Decision 5 and 02-PATTERNS §6.
7. **ROADMAP criterion 5's own parenthetical was reconciled, not just the note below it.** The plan flagged that leaving `≈8 from the fold` would make ROADMAP contradict its own supersession note two lines later and re-seed a figure a later pass would "correct" backwards. It is replaced with the measured figure *and* explicitly marked superseded, so both of criterion 9's disjuncts hold (the bare string count is 0 **and** the surviving reference is annotated).

## Deviations from Plan

### Auto-fixed / adjusted

**1. [Measured branch, pre-authorized] Degree dates placed in `#4` instead of D-09's `#2`**
- **Found during:** Task 1 (measurement A)
- **Issue:** With the date in `#2`, `Aug. 2021 – May 2023` extracted at gate line 94 — *before* `Indiana University, Bloomington` at 96. D-09's date placement reproduced the parse-order defect with a new noise string.
- **Fix:** Moved both date ranges to `#4` (row 2's right cell, measured to extract last) with `#2` left empty. Rebuilt and re-measured until the institution was the region's first non-empty line.
- **Files modified:** `docs/main.tex`
- **Verification:** Measurement B above; `EDUCATION` 93 → first non-empty 94 → institution 94.
- **Committed in:** `29999ff`
- **Note:** This is the plan's own second branch, taken as written — recorded here for the audit trail rather than as unplanned work. The escalation gate (STOP if neither `#2` nor `#4` works) was not reached.

**2. [Criterion wording vs. protected property] Task 3 criterion 7's `HEAD` clause satisfied substantively, not literally**
- **Found during:** Task 3 step 3
- **Issue:** Criterion 7 asks that `git show --name-only --format= HEAD` include `docs/AshutoshTiwari.fdb_latexmk` and `docs/AshutoshTiwari.pdf`. It was written assuming Task 3 would be the artifact-regenerating commit. Task 1 had already committed the artifacts atomically with the source that produced them (Plan 01 Decision 5, 02-PATTERNS §6), so `make build` in Task 3 was a no-op — `make: Nothing to be done for 'build'` — and HEAD legitimately has no artifact delta.
- **Fix:** Kept the safer invariant and proved the property criterion 7 exists to protect (T-02-12, stale greenlight) directly instead of by grepping HEAD: a genuine `git clone` of HEAD has a clean tree, and its `bash scripts/verify-resume.sh` emits `RESULT G0.3 PASS PDF provably built from current main.tex (latexmk md5 eff2ec04067eb8fa60b775424a0a3a53)` and exits **0**. `.aux`/`.fls`/`.out` are tracked but were byte-unchanged by the Education edit.
- **Rejected alternative:** Deferring artifacts to a trailing `build(resume):` commit would satisfy the literal wording but leave `29999ff` carrying a stale PDF that a fresh checkout refuses at exit 2 — strictly worse, and contradicting the `<read_first>` guidance the plan itself cites. Also rejected: forcing a no-op rebuild purely to manufacture a diff that makes the grep pass.
- **Verification:** fresh-clone run above; `29999ff` contents listed in Task Commits.
- **Committed in:** artifacts in `29999ff`; planning docs in `10be4ab`

---

**Total deviations:** 2 (1 pre-authorized measured branch, 1 criterion-wording reconciliation with the protected property proven directly)
**Impact on plan:** No scope change and no assertion weakened. Deviation 1 is a branch the plan enumerated and pre-authorized. Deviation 2 preserves a stronger history invariant than the criterion's literal wording would produce, and the underlying threat mitigation is verified by a stricter test (fresh clone) than the criterion specified. No manifest threshold moved, no frozen string touched, no suppression added.

## Issues Encountered

1. **`gsd-sdk query roadmap.update-plan-progress 02` reverted the Progress row.** Run before `02-02-SUMMARY.md` existed on disk, it counted 1 SUMMARY against 2 PLANs and rewrote the row Task 3 had set to `2/2 Complete` back to `1/2 In Progress`. Resolved by ordering: the SUMMARY is written first, then `state.update-progress` and `roadmap.update-plan-progress` are re-run so both read the completed state.
2. **`gsd-sdk query state.record-metric` requires the flag form** (`--phase --plan --duration --tasks --files`); positional arguments return `{"error":"phase, plan, and duration required"}`. Known from Plan 01; used the flag form directly.
3. **`gsd-sdk query state.add-decision --summary-file` rejects paths outside the project directory.** Known from Plan 01; decision text was staged in `.planning/.scratch-0202/`, the four calls run, then the directory removed — `git status --porcelain` is byte-identical to the pre-plan snapshot.

None of these touched `docs/` or the harness.

## Known Stubs

None. No hardcoded empty value, placeholder string or unwired data path was introduced. The one empty argument added (`\resumeSubheading`'s `#2`) is a deliberate empty *table cell* whose extraction behaviour was measured, not a stub — the plan's own shipped shape for the row, and `\resumeSubheading` was already proven to accept an empty cell (the deleted career-break row used `{}` as `#2`). The `Measured figure:` placeholder that *did* exist in `ROADMAP.md` was filled by this plan and asserted gone (`grep -Fc 'recorded by 02-02 Task 3'` == 0).

## Threat Flags

None. No new network endpoint, auth path, file-access pattern or trust-boundary schema was introduced — this plan edits document content, a shell assertion and two planning documents.

Dispositions from the plan's register, all discharged:

- **T-02-07** (tampering with the `G6.12` clause) — mitigated: replaced with a strictly stronger anchor-free form; the negative control against the pre-Phase-2 pair produced `RESULT G6.12 FAIL`, so the clause is not a tautology.
- **T-02-08** (`EDU_CITY` removal) — mitigated: both greps return 0; key and only reader removed in `232abc2` together.
- **T-02-09** (`PROBE_LINES`) — mitigated: not raised (unnecessary), never lowered; `G7.1` and `G7.2` both PASS at 5; 0 other threshold keys moved.
- **T-02-10 / T-02-11** (repudiation of frozen strings) — mitigated: `baseline-frozen.txt` byte-unmodified across the whole phase; `ALLOW_FROZEN_UPDATE` never invoked; `G4.1` still hashes to `8b13a46b…465a56`; `G5.1`/`G5.2`/`G5.5` 15 PASS. The two Education ranges — which `baseline-frozen.txt` does **not** cover — are protected by `EDU_DATE` + the retained `EDU_BIND_WINDOW` clause and by direct `-Fxc == 1` assertions; both source `--` forms untouched, so the extracted U+2013 byte is unchanged.
- **T-02-12** (stale greenlight) — mitigated: `make build` only, never `make clean`; `.fdb_latexmk` committed with its source; fresh-clone `G0.3 PASS` exit 0.
- **T-02-13** (`--skip-freshness` leaking into a Makefile target) — mitigated: `grep -c 'skip-freshness' Makefile` == 0; used once, in the negative control, with a `mktemp -d` copy.
- **T-02-14** (Education information disclosure) — accepted as planned: city cells removed, nothing new published, GPAs retained for Phase 4 / PG2-03.
- **T-02-SC** (supply chain) — accepted / not applicable: zero package-manager commands, zero new `\usepackage` lines.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

**Phase 2 is complete and the gate is green.** Handoff facts, all measured post-plan:

- **`bash scripts/verify-resume.sh` exits 0** with `>> PASS: 0 blocking failures.` and 0 FAIL. This is now Phase 3's regression baseline: any FAIL it introduces is unambiguously its own.
- **`make verify-selftest` exits 0** with all ten controls PASS and no SKIP. Use `bash scripts/verify-resume.sh` for the gate, **never** `make verify` — GNU Make 3.81 collapses exit 1 and exit 2 to its own 2.
- **Page-1 slack available to Phase 3: +50.5pt / +4.39 lines** (`G3.1` deepest bottom 713.9pt vs `CEILING_PT=764.4`). Page 2 has +53.5pt / +4.65 lines.
- **The self-test guard has only 7.0pt of headroom left.** The `+5`-line probe is 57.5pt against 50.5pt of slack. **If Phase 3 nets more than ~7pt of *additional* page-1 recovery, `G7.2` will start FAILing** and `PROBE_LINES` must then be raised by the smallest integer increment that restores PASS (re-confirming `G7.1` at the new value). Phase 3 *spends* budget, so this is unlikely — but a compression-heavy pass should re-read `G7.2` rather than assume.
- **`G6.12`'s next owner is Phase 4 / PG2-03**, and `EDU_OWNER` now says so. PG2-03 drops the Education GPAs and compresses the section — it must keep the institution as the region's **first non-empty extracted line**. `EDU_INSTITUTION`, `EDU_DATE`, `EDU_BIND_WINDOW`, `EDU_HEADING` are the four surviving anchors; there is no city anchor to maintain.
- **`region_first_nonempty` is available for reuse** (`scripts/verify-resume.sh:405`) for any future "X must lead its section" assertion.
- **WARN tier, unchanged by this plan and still unowned here:** `G5.4` 8 digit-bearing page-1 bullets vs `DIGIT_BULLET_FLOOR=7` (owner Phase 3); `G6.13` all five role blocks split (unassigned); `G6.14` Skills 4 lines vs `SKILLS_MAX_LINES=3` (owner Phase 5); `G6.6` seven absent target keywords (owners Phase 3/5). None gate.
- **`EXP-01`, `EXP-05`, `EXP-06` are all closed.** Phase 2's ROADMAP row reads `2/2 Complete`.

No blockers.

## Self-Check: PASSED

- **Files on disk:** `.planning/phases/02-page-1-budget-text-layer-defects/02-02-SUMMARY.md`, `docs/main.tex`, `scripts/verify-resume.sh`, `docs/verify/manifest.txt`, `docs/AshutoshTiwari.pdf`, `docs/AshutoshTiwari.log`, `docs/AshutoshTiwari.fdb_latexmk`, `.planning/ROADMAP.md`, `.planning/REQUIREMENTS.md` — all FOUND
- **Commits resolvable:** `29999ff`, `232abc2`, `10be4ab` — all present in `git log --oneline --all`
- **All 31 task-level acceptance criteria re-run and PASS** (9 + 11 + 11), with Task 3 criterion 7 satisfied via the documented stronger proof
- **All 8 plan-level `<verification>` checks re-run and PASS**
- **`git status --porcelain` byte-identical to the pre-plan snapshot** (`?? .omc/` only, pre-existing and not this phase's)
- **A fresh `git clone` of HEAD** verifies the committed artifact: `G0.3 PASS`, `G4.1 PASS`, `G6.12 PASS`, exit **0**

---
*Phase: 02-page-1-budget-text-layer-defects*
*Completed: 2026-08-22*
