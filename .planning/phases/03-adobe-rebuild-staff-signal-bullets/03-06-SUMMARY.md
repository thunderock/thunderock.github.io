---
phase: 03-adobe-rebuild-staff-signal-bullets
plan: 06
subsystem: resume-content
tags: [latex, pdftotext, ats-keywords, line-budget, staff-signal, swiggy, flipkart]

# Dependency graph
requires:
  - phase: 03-05
    provides: "the measured entering headroom G3.2 p1 +17.1pt (+1.49 lines), the corrected itemize-3 line-1 capacity of 135 characters, the anchored-FAIL-census rule, and the marker-line-scoping rule for reading decision payloads"
  - phase: 03-03
    provides: "the Section C Swiggy/Flipkart disposition, the no-new-claims constraint, the `manual deploys` entailment licence, and the measured 11/9 rendered-line baselines"
provides:
  - "Swiggy bullets on staff-signal formulas: 18M+ adoption count on the Online Inference Platform bullet's FIRST rendered line, and the fault-isolation / backpressure / sustained-low-P99 failure-class closure stated as mechanism-then-outcome"
  - "Flipkart ML Workflow Automation carrying the closure story with the error class named -- `manual deploys` -- plus the Airflow item gating every auto-deploy on data and model validations"
  - "both regions rendered-line NEUTRAL: Swiggy 11 -> 11, Flipkart 9 -> 9, derived from region boundaries (subtitle anchor -> next blank line), never from absolute gate line numbers"
  - "the Phase-3 regression net driven to exit 0 -- 72 anchored PASS, 0 anchored FAIL, red-on-arrival census of 46 fully discharged"
  - "G5.4 raised 10 -> 11 by moving `4Bn rows` off a continuation line onto the Feature Store bullet's first rendered line (Pitfall 5 applied deliberately)"
  - "measured EXP-08 approval reserve handed to 03-07: G3.2 p1 +17.1pt (+1.49 lines), reserve INTACT above the ladder's >= +16.1pt top rung by 1.0pt"
  - "the five-block employer-vs-subtitle extraction order, now uniformly employer-BEFORE-subtitle -- the historical Flipkart inversion self-healed as predicted"
affects: [03-07, 03-08, phase-05, phase-06]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "region-boundary derivation: resolve the frozen subtitle line as a whole-line anchor, then walk to the next blank line -- the only line-neutrality check that survives an upstream block growing"
    - "spend nothing, move characters freely: rendered-line neutrality constrains LINE counts, so a bullet may grow or shrink in characters at zero pt cost provided it stays inside its wrap band"
    - "wrap-band sizing: for a 2-rendered-line target keep content above the measured line-1 capacity and below twice it; for a 1-line target stay under line-1 capacity"
    - "needle-placement safety: position a whitespace-free locked literal away from the wrap boundary so LaTeX hyphenation can never split it across two extracted lines"
    - "no-new-claims proof by numeric-token diff: extract every numeric token from the pre-edit and post-edit source region and require the set difference to be empty"

key-files:
  created:
    - .planning/phases/03-adobe-rebuild-staff-signal-bullets/03-06-SUMMARY.md
  modified:
    - docs/main.tex
    - docs/AshutoshTiwari.pdf
    - docs/AshutoshTiwari.log
    - docs/AshutoshTiwari.fdb_latexmk

key-decisions:
  - "Rendered-line neutrality was held per-bullet, not merely per-region: every Swiggy and Flipkart bullet kept its own rendered line count (Swiggy 2+2+2+2+2+1, Flipkart 2+1+2+2+2), so no intra-region compensation could mask a spend"
  - "G5.4 was allowed to RISE 10 -> 11 rather than held at 10: the Feature Store reword replaced the vague `at production scale` qualifier with the bullet's own `4Bn rows and 10K QPS` figures, which pulled `4Bn rows` onto the first rendered line where the regex can see it"
  - "Task 1's `<automated>` EXP-07-PASS-slice sub-clause was UNSATISFIABLE at Task-1 time and was replaced with an equivalent-or-stronger gate; the net carries exactly ONE EXP-07-labelled assertion and it is Task 2's own needle"
  - "The plan's absolute SOURCE line numbers are stale by +1 for both blocks; every reference was resolved by content and the frozen-cell byte-identity assertion was re-pointed at the ACTUAL title/date and employer/subtitle lines"
  - "The Flipkart closure clause leads with the error class (`to retire manual deploys`) rather than trailing it, which both reads as a staff-signal closure formula and puts the locked needle at character 73 -- far from the wrap boundary"

patterns-established:
  - "Region-boundary line-count derivation: a reusable anchor->blank-line walk that reports each of the five role blocks, immune to upstream growth"
  - "Frozen-surface proof by diff scope: assert the whole source diff touches ONLY the intended bullet lines, then assert byte-identity on the frozen cells by content-resolved line number"
  - "Forbidden-addition vocabulary sweep: after an entailment-licensed reword, grep the edited region for outage/incident/rate/duration vocabulary and require zero"

requirements-completed: []

# Metrics
duration: 13 min
completed: 2026-08-22
---

# Phase 3 Plan 6: Swiggy and Flipkart Staff-Signal Bullets Summary

**Both blocks reworded to staff-signal formulas -- Swiggy leading on the 18M+ adoption count with the fault-isolation / backpressure / sustained-low-P99 closure, Flipkart naming `manual deploys` as the error class its first automated train-to-deploy workflow retired -- at exactly zero net rendered lines, driving the Phase-3 regression net from its last surviving FAIL to a clean exit 0 (72 PASS).**

## Performance

- **Duration:** 13 min
- **Started:** 2026-08-23T04:56Z
- **Completed:** 2026-08-23T05:09Z
- **Tasks:** 2
- **Files modified:** 4 (1 source, 3 artifacts)

## Accomplishments

- **The last red assertion in the phase is green.** `bash scripts/verify-phase3-regressions.sh` now exits **0** with **72 anchored PASS / 0 anchored FAIL**. The census that arrived at wave 1 with 46 owned FAILs is fully discharged: 32 cleared by 03-04, 13 by 03-05, and the final `/03-06`-owned `manual deploys` needle by Task 2 here.
- **Both regions are rendered-line neutral, proven by boundary derivation rather than by line literals.** Swiggy **11 -> 11**, Flipkart **9 -> 9**, with Adobe untouched at 21. `G3.2` p1 stayed at **+17.1pt (+1.49 lines)** across both task commits -- byte-identical to the figure `03-05-SUMMARY.md` recorded, so no line was freed and the `G7.2` probe margin is untouched.
- **`G5.4` improved 10 -> 11** without spending a line, by applying the Pitfall-5 lesson deliberately: the Feature Store reword replaced the unmeasured phrase `at production scale` with the bullet's own figures, and `4Bn rows` moved from a continuation line onto the bullet's first rendered line where the bullet-glyph-anchored regex can see it.
- **Every single-carrier keyword survived.** `fault` (whose only carrier is Swiggy's `fault isolation across clusters`) reads ×3 and the page-1 `Spark` carrier reads ×3; `G6.5` is **17 PASS / 0 FAIL**.
- **The anti-rot guard is still armed.** `make verify-selftest` exits 0 with **ten** anchored G7/G8 PASS, **zero** SKIP, and `G7.2 PASS the probe PDF is 3 page(s)` -- the wave did not end net-freed.
- **The EXP-08 approval reserve survived unchanged**, so 03-07's checkpoint is deciding in the reserve-intact situation, not the ceiling situation.

## Task Commits

Each task was committed atomically, source and artifacts together:

1. **Task 1: Swiggy -- adoption count on the first line, explicit failure-class closure, line-neutral** - `5215f88` (feat)
2. **Task 2: Flipkart -- the ML workflow closure story naming the error class closed, line-neutral** - `03c8b38` (feat)

Both commits contain `docs/main.tex` with `docs/AshutoshTiwari.pdf`, `docs/AshutoshTiwari.log` and `docs/AshutoshTiwari.fdb_latexmk` -- verified per commit with `git show --name-only`. No `make clean`, no file deletions in either commit (`git diff --diff-filter=D` empty for both).

## Files Created/Modified

- `docs/main.tex` — six Swiggy bullet lines (`:173`, `:175`-`:176`, `:178`-`:180`) and five Flipkart bullet lines (`:187`-`:189`, `:191`, `:193`) reworded in place. Diff hunk headers confirm nothing else moved: `@@ -173 +173 @@`, `@@ -175,2 +175,2 @@`, `@@ -178,3 +178,3 @@` for Task 1; `@@ -187,3 +187,3 @@`, `@@ -191 +191 @@`, `@@ -193 +193 @@` for Task 2.
- `docs/AshutoshTiwari.pdf` — rebuilt, 2 pages, 0 Overfull `\hbox`.
- `docs/AshutoshTiwari.log`, `docs/AshutoshTiwari.fdb_latexmk` — rebuild records; the `.fdb_latexmk` md5 is what `G0.3` reads, which is why the artifacts ride in the source commits (`G0.3 PASS`, md5 `abd1fe0dd121f276c2284e82b936c3a2`).
- `docs/AshutoshTiwari.aux`, `.fls`, `.out` — tracked but byte-unchanged by these edits.

## The measurement record

### Rendered-line neutrality, and how it was derived

Every count below comes from `pdftotext docs/AshutoshTiwari.pdf - | tr '\f' '\n'`, with each region resolved as **the frozen subtitle line matched as a whole line, then the walk from the next line down to the next blank line**. Absolute gate line numbers were never used as boundaries — Adobe grew to 21 rendered lines in 03-05 and pushed everything below it down, exactly the shift `03-DECISION-RECORD.md` Section C warns about.

| block | anchor (frozen subtitle) | region before | rendered before | region after | rendered after | delta |
|---|---|---|---|---|---|---|
| Adobe | `GENERATIVE AI, COMPUTER VISION, LARGE LANGUAGE MODELS` | 11–31 | **21** | 11–31 | **21** | 0 (untouched) |
| **Swiggy** | `DATA SCIENCE PLATFORM, TIME SERIES FORECASTING` | 39–49 | **11** | 39–49 | **11** | **0** |
| **Flipkart** | `SEARCH RELEVANCE, QUERY INTENT, NLP` | 57–65 | **9** | 57–65 | **9** | **0** |
| Groupon | `BACKEND ENGINEERING` | 73–74 | 2 | 73–74 | 2 | 0 (lever not pulled) |
| NetSpeed | `GRAPH ALGORITHMS, NETWORK ON CHIP` | 82–83 | 2 | 82–83 | 2 | 0 (lever not pulled) |

Both regions match the `03-DECISION-RECORD.md` Section C baselines (Swiggy **11**, Flipkart **9**), confirming that record's supersession of `03-RESEARCH.md`'s "Swiggy 8" once more. Neutrality was held **per bullet**, not only per region, so no intra-region compensation could hide a spend:

| block | per-bullet rendered lines before | after |
|---|---|---|
| Swiggy | 2 (S1) + 2 (S2) + 2 (S3) + 2 (S4) + 2 (S5) + 1 (S6) | identical |
| Flipkart | 2 (F1) + 1 (F2) + 2 (F3) + 2 (F4) + 2 (F5) | identical |

### `G3.2` p1 — unchanged at every commit

| point | `G3.2` p1 |
|---|---|
| entering (from `03-05-SUMMARY.md`) | **+17.1pt (+1.49 lines)** |
| after Task 1 (`5215f88`) | **+17.1pt (+1.49 lines)** |
| after Task 2 (`03c8b38`) | **+17.1pt (+1.49 lines)** |

Zero net delta across the whole plan, as D-11 requires. `G3.2` p1 never ROSE above the +50.5pt baseline either, so rail 2 held. `G3.1` reads `deepest content bottom 747.3pt vs ceiling 764.4pt`.

### Gate values

| gate | entering | after Task 1 | after Task 2 (final) |
|---|---|---|---|
| `G0.3` | PASS | PASS | **PASS** (md5 `abd1fe0d…c3a2`) |
| `G1.1` | 2 pages | 2 pages | **2 pages** |
| `G2.1` | PASS | PASS | **PASS** |
| `G3.2` p1 | +17.1pt | +17.1pt | **+17.1pt** |
| `G5.4` | 10 | 11 | **11** (≥8) |
| `G6.4` | PASS | PASS | **PASS** |
| `G6.5` | 17 PASS / 0 FAIL | 17 / 0 | **17 / 0** |
| `bash scripts/verify-resume.sh` | exit 0 | exit 0 | **exit 0** |
| P2 net | 27 anchored PASS / 0 FAIL | 27 / 0 | **27 / 0**, exit 0 |
| P3 net | 71 PASS / **1 FAIL** | 71 / **1** | **72 PASS / 0 FAIL, exit 0** |
| `make verify-selftest` | exit 0, 10 PASS, 0 SKIP | — | **exit 0, 10 PASS, 0 SKIP** |

`make verify` also exits 0 — recorded as ROADMAP-criterion-5 corroboration only; the oracle stayed `bash scripts/verify-resume.sh` throughout.

### `G5.4` rose 10 → 11, and exactly why

Final match set (page-1 lines beginning with a bullet glyph and containing a digit): **15, 16, 22, 23, 26, 28, 39, 45, 49, 64, 73** — Adobe 6, **Swiggy 3**, Flipkart 1, Groupon 1, NetSpeed 0.

The gain is line **45**, the Feature Store bullet's first rendered line:

```
– Feature Store: Built and maintained the feature store and its pipelines, serving on-demand features to production ML models at 4Bn rows
and 10K QPS, with multichannel ingestion via Spark, Flink, and user files.
```

Before the reword, `(4Bn rows, 10K QPS)` sat wholly on the continuation line — `03-DECISION-RECORD.md`'s live proof of Pitfall 5, and correctly invisible to the regex. Replacing the unmeasured qualifier `at production scale` with the figures themselves is both the staff-signal move (a number instead of an adjective) and what pulled `4Bn rows` onto the countable line. `10K QPS` still lands on the continuation line and is still invisible — which is fine, and left as-is rather than engineered, because the criterion is a floor of 8 and the value is 11. **`DIGIT_BULLET_FLOOR` was not touched.**

### Locked literals and single-carrier keywords

| needle | assertion | result |
|---|---|---|
| `18M+` | P3.10 (squeezed), P3.18 (raw) | PASS / PASS |
| `4Bn rows` | P3.11 | PASS |
| `10K QPS` | P3.12 | PASS |
| `fault isolation across clusters` | P3.7 | PASS |
| `backpressure-aware scheduling` | P3.8 | PASS |
| `sustained low P99` | P3.9 | PASS |
| `first workflow at Flipkart` | text layer count 1 | PASS |
| `validations` | text layer count 1 (raw-readable on one line) | PASS |
| `millions every day` | squeezed count 1 | PASS |
| **`manual deploys`** | **P3.66 (squeezed)** | **PASS — the plan's target** |
| `fault` (sole Swiggy carrier) | `G6.5` | PASS ×3 |
| `Spark` (sole page-1 carrier) | `G6.5` | PASS ×3 |

`18M+` is on the Online Inference Platform bullet's **first** rendered line (character 103, inside the measured ~137-character line-1 window); `4Bn+` is on the Large-Scale Data Pipelines bullet's first rendered line (character 72). `manual deploys` landed at character 73 of its bullet and `validations` at character 160 — both deliberately placed away from the wrap boundary so LaTeX hyphenation could not split a whitespace-free or squeezed-critical needle across two extracted lines.

Incidental improvement worth recording: `millions every day` now reads **×1 in the raw stream too** (it fits wholly on gate line 57 after the reword) where it previously read ×0 there and ×1 squeezed. The assertion stays squeezed-only and stays green — squeezing can never destroy a match — so no assertion needed changing.

### No new claims

Numeric-token set diff over the edited source regions, pre-edit vs post-edit:

| block | pre-edit numeric tokens | post-edit | newly introduced |
|---|---|---|---|
| Swiggy (`:173`-`:180`) | `10K 15M 18M+ 4Bn 99` | `10K 15M 18M+ 4Bn 99` | **none** |
| Flipkart (`:187`-`:193`) | `4Bn+` | `4Bn+` | **none** |

Forbidden-addition vocabulary sweep over the edited Flipkart lines — `outage`, `incident`, `failure rate`, `%`, `per week`, `per month`, `per day`, `hours`, `days`, `weeks`, `months` — all **0**. The `manual deploys` clause stays strictly inside the entailment `03-DECISION-RECORD.md` Section C licenses: a workflow that is the *first* to automate training and auto-deployment entails the deploys were manual before it, and `to retire manual deploys` names that prior state without adding a frequency, duration, incident count or error rate. The `validations` clause likewise only restates what the line already named, phrased as a gate (`gating every auto-deploy on data and model validations`) rather than as an inclusion.

### Frozen surfaces

| surface | assertion | result |
|---|---|---|
| Swiggy `\resumeSubheading` title + dates (actual `:170`) | byte-identical vs previous commit | **BYTE-IDENTICAL** |
| Swiggy employer + subtitle (actual `:171`) | byte-identical vs previous commit | **BYTE-IDENTICAL** |
| Flipkart `\resumeSubheading` (actual `:183`) | byte-identical vs previous commit | **BYTE-IDENTICAL** |
| Flipkart title + dates (actual `:184`) | byte-identical vs previous commit | **BYTE-IDENTICAL** |
| Flipkart employer + subtitle (actual `:185`) | byte-identical vs previous commit | **BYTE-IDENTICAL** |
| `docs/verify/baseline-frozen.txt` | zero diff | **untouched** |
| `docs/verify/manifest.txt` | zero diff | **untouched** (no promotion, no threshold change) |
| `scripts/*.sh` | zero diff | **untouched** (the net was driven green by content, not by editing the net) |

The diff-scope check is the stronger half of this: the two commits' hunk headers cover only the eleven bullet lines, so no frozen cell could have moved even by whitespace.

### Employer-vs-subtitle extraction order — all five blocks

Recorded as the plan requires, **and it is now uniform**:

| block | employer gate line | subtitle gate line | order |
|---|---|---|---|
| ADOBE FIREFLY | 9 | 10 | employer **BEFORE** subtitle |
| SWIGGY | 37 | 38 | employer **BEFORE** subtitle |
| FLIPKART (a Walmart company) | 55 | 56 | employer **BEFORE** subtitle |
| GROUPON | 71 | 72 | employer **BEFORE** subtitle |
| NETSPEED SYSTEMS (Acquired by Intel) | 80 | 81 | employer **BEFORE** subtitle |

The historical Flipkart inversion — the employer extracting **after** its subtitle — **has self-healed**, exactly as the plan predicted it would once Adobe grew by a rendered line. This was measured, not fixed: nothing in this plan touched the Flipkart `\resumeSubheading`, and it is deliberately **not gated**. A later plan must not treat the order as guaranteed; it is a `pdftotext` row-order artifact of a two-cell `tabular*` row, and the Phase-2 precedent is explicit that such extraction order is **measured, never predicted**.

### EXP-08 line reserve — the number 03-07's checkpoint needs

**The reserve SURVIVED, unchanged.** `G3.2` p1 = **+17.1pt (+1.49 lines)**, which is above the contingency ladder's top rung (**≥ +16.1pt**) by **1.0pt**. Consequences for 03-07's `<context>`:

- The user is deciding in the **reserve-intact** situation, not the +4.7pt ceiling situation. Roughly **one rendered line (≈11.5pt)** of approval fund exists.
- The sanctioned **Groupon/NetSpeed reword-shorter lever was NOT pulled** (both descriptors still render 2 lines each, unchanged), so **no same-commit obligation is inherited**.
- Because a one-line approval would land `G3.2` p1 at roughly **+5.6pt**, still above the measured +4.7pt ceiling rung, a single approval is fundable without touching a frozen surface. **A second** approved line is not — that would be the fifth rendered line of the phase and a measured 3-page PDF.
- Cost must still be **re-measured after the build**, never accepted from the 1–2-line estimates in `03-DECISION-RECORD.md` Section D.

### Capacity figures re-measured on this artifact

Correcting forward for whoever budgets next. Measured in **characters** (never bytes — the U+2013 bullet prefix is 3 bytes, `×` is 2, `’` is 3):

| shape | max line-1 width observed | note |
|---|---|---|
| itemize-2 (topics) | **137** | Swiggy Feature Store, gate 45 |
| itemize-3 (nested items) | **136** | Swiggy Akka item, gate 43 |

This corroborates `03-05`'s correction (135 for itemize-3 line 1) and slightly raises it. The practical band used for sizing, which produced the correct rendered line count on the **first** build for all eleven bullets with zero retries:

- **2-rendered-line target:** content **> ~140** and **< ~270** characters.
- **1-rendered-line target:** content **< ~130** characters (Swiggy DAQ landed at 106, Flipkart Tail Query Classifier at 116).

Method: draft, compute `len()` in characters against the measured width, only then edit, then rebuild and re-derive the region boundaries.

## Decisions Made

1. **Neutrality was enforced per bullet, not merely per region.** D-11 only requires the region total to be unchanged, so a bullet dropping to 1 line while another rose to 3 would have satisfied it. Holding each bullet's own count instead means the boundary derivation and the `G3.2` reading are mutually corroborating rather than two views of a possibly-compensating change.

2. **`G5.4` was allowed to rise to 11.** The alternative was to keep `4Bn rows` on a continuation line purely to hold the number at 10, which would have meant preserving the vague `at production scale` phrase. The gate is a floor (`DIGIT_BULLET_FLOOR=7`, criterion needs ≥8) and it is warn-tier; rising is strictly safer than holding, and the figure it exposes is one the document already carried. **`DIGIT_BULLET_FLOOR` was not raised to match** — the Phase-1 rule against moving a threshold toward a document applies in both directions.

3. **The Flipkart closure leads with the error class.** `Built the first workflow at Flipkart to retire manual deploys, automating training and auto-deployment of search models` was chosen over trailing the clause (`…of search models, retiring the manual deploys it replaced…`). Both fit two lines, but the leading form reads as a closure formula rather than an afterthought **and** puts `manual deploys` at character 73 instead of 135 — the latter straddles the ~137-character wrap boundary, where a needle is one reflow away from being split.

4. **`Built and maintained` was kept on the Feature Store bullet.** `Built and owned` would have read as a stronger staff signal, but "owned" is a claim the pre-edit line does not make. The no-new-claims constraint governs verbs as well as figures; the staff signal was found in replacing the vague scale qualifier with measured figures instead.

5. **The Swiggy routing pair kept both bullets at two lines each even though S2 compressed.** Characters may move freely inside a line at zero pt cost, so S2's tightening did not need backfilling — but it did need to stay above the wrap threshold, or the region would have dropped to 10 and freed a line, reddening `G7.2` under `--selftest` while `bash scripts/verify-resume.sh` stayed green.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Task 1's `<automated>` clause contained an unsatisfiable EXP-07-PASS-slice sub-clause**

- **Found during:** Task 1 (Swiggy), running the plan's verification block verbatim.
- **Issue:** The clause ends `… && grep -cE 'PASS.*EXP-07' "$SC/p06a.txt" | grep -qvx 0`, intended to prove the EXP-07 slice was actually inspected rather than vacuously empty. But `scripts/verify-phase3-regressions.sh` carries **exactly one** EXP-07-labelled RESULT assertion — `P3.66`, the `manual deploys` needle that **Task 2** lands. Measured at Task-1 time: EXP-07 lines total **2** (one `RESULT` line plus the `>> Groups run:` footer, which merely mentions the string), EXP-07 **PASS** lines **0**, EXP-07 FAIL lines **1**. So `grep -cE 'PASS.*EXP-07'` reads `0`, `grep -qvx 0` exits 1, and the whole command exits non-zero on a document where every acceptance criterion is in fact satisfied. This is the same failure class `[Phase 3 / 03-04]` recorded for the anchored-vs-unanchored FAIL census: a verification clause that cannot pass is indistinguishable, in a log, from a document that is wrong.
- **Fix:** Kept the criterion's load-bearing half verbatim — filter the EXP-07 slice to FAIL lines **first**, then require zero non-`manual deploys` survivors (measured **0**) — and replaced the vacuity guard with two **stronger** assertions that do not depend on an EXP-07 label existing: (a) the anchored `^RESULT P3\.[0-9]+ +FAIL` census equals **1** and that single line is the `manual deploys` one, and (b) each of the six named Swiggy retention needles is looked up by its literal in the net output and asserted non-FAIL (`18M+` P3.10/P3.18, `4Bn rows` P3.11, `10K QPS` P3.12, `fault isolation across clusters` P3.7, `backpressure-aware scheduling` P3.8, `sustained low P99` P3.9 — all PASS). (b) is what the vacuity guard was reaching for and is strictly stronger, since it names the needles instead of trusting a label.
- **Files modified:** none — this was a verification-clause correction, not a source change. `scripts/verify-phase3-regressions.sh` was **not** edited.
- **Verification:** The corrected gate exits 0 at Task 1. After Task 2 the plan's own Task-2 `<automated>` clause — which does not contain the defective sub-clause — was run **verbatim** and exits 0.
- **Committed in:** `5215f88` (Task 1 commit; no script or net change accompanied it).

**2. [Rule 3 - Blocking] Every absolute source line number in the plan is stale by +1, including the frozen-cell byte-identity targets**

- **Found during:** Task 1 `<read_first>`, before any edit.
- **Issue:** The plan cites Swiggy at `:168-181` with bullets at `:172`/`:174`/`:175`/`:177`/`:178`/`:179` and freezes `:169`/`:170`; Flipkart at `:182-193` with bullets at `:186`/`:187`/`:188`/`:190`/`:192` and freezes `:183`/`:184`. The live file has Swiggy bullets at `:173`/`:175`/`:176`/`:178`/`:179`/`:180` with the frozen cells at `:170` (title + dates) and `:171` (employer + subtitle), and Flipkart bullets at `:187`/`:188`/`:189`/`:191`/`:193` with frozen cells at `:184` and `:185`. Cause: 03-05's D-05 Ray swap added one source line to the Adobe block. This is the *source*-side twin of the gate-line shift `03-DECISION-RECORD.md` Section C warns about — the plan warns about rendered lines but then hard-codes source lines. Left uncorrected, the frozen-cell assertion would have compared `:169` (`\resumeSubheading`) and `:170` (title + dates) and silently **never checked the employer/subtitle line at all**, which is the anchor `scripts/verify-phase3-regressions.sh` Group 2 resolves against.
- **Fix:** Resolved every reference by **content** rather than by number, and replaced the numeric byte-identity assertion with two checks: (a) `git diff -U0 docs/main.tex` hunk headers must cover **only** the intended bullet lines — measured `@@ -173 +173 @@`, `@@ -175,2 +175,2 @@`, `@@ -178,3 +178,3 @@` for Swiggy and `@@ -187,3 +187,3 @@`, `@@ -191 +191 @@`, `@@ -193 +193 @@` for Flipkart; and (b) byte-identity against the previous commit on the **content-resolved** frozen lines — Swiggy `:170` and `:171`, Flipkart `:183`, `:184` and `:185`, all five **BYTE-IDENTICAL**. (a) is stronger than the plan's assertion because it proves nothing outside the bullet lines moved, rather than proving two specific lines did not.
- **Files modified:** none beyond the intended bullet lines.
- **Verification:** All five frozen lines byte-identical; hunk headers as listed; `docs/verify/baseline-frozen.txt` and `docs/verify/manifest.txt` both zero-diff.
- **Committed in:** `5215f88` and `03c8b38`.

---

**Total deviations:** 2 auto-fixed (2 blocking; 0 bugs, 0 missing-critical). Neither was a source defect — both were stale or unsatisfiable **verification instructions**, corrected by substituting equivalent-or-stronger checks. No architectural change, so no Rule 4 escalation.
**Impact on plan:** None on scope or content. Both corrections made the acceptance evidence stronger than the plan's own wording asked for: an unsatisfiable clause was replaced with a needle-by-name check, and a two-line byte-identity check was replaced with a whole-diff scope proof. No assertion was relaxed and no net or manifest was edited to reach green.

## Issues Encountered

- **Most of D-09's Swiggy content was already present on arrival**, since the P3 retention needles for `18M+`, `4Bn rows`, `10K QPS`, `fault isolation across clusters`, `backpressure-aware scheduling` and `sustained low P99` were PASS from wave 1 (they are retention guards over pre-existing text, not new-content assertions). The deliverable was therefore genuinely a **reword for staff-signal density** rather than a content addition — job-description voice (`Core contributor to the online inference platform`, echoing its own topic name; `Built and maintained a Feature Store`, echoing its own topic name; `a tool used to scrape APIs at scale`) and unmeasured qualifiers (`at production scale`) replaced with ownership-plus-outcome phrasing and the figures the bullets already carried. Resolved by treating the retention needles as **constraints** on the reword rather than as its goal.
- **Nothing else.** Both tasks landed at their target rendered line count on the first build, with 0 Overfull `\hbox`, no retries and no back-out.

## Authentication Gates

None — no external service or credential was involved.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

**Ready for 03-07 (the EXP-08 sign-off checkpoint).**

- **The phase oracle is fully green.** `bash scripts/verify-phase3-regressions.sh` exits **0** (72 anchored PASS / 0 anchored FAIL), `bash scripts/verify-resume.sh` exits **0**, `bash scripts/verify-phase2-regressions.sh` exits **0** (27 anchored PASS), `make verify-selftest` exits **0** (ten G7/G8 PASS, zero SKIP), `make verify` exits **0**. The working tree is clean apart from a pre-existing untracked `.omc/` directory that this plan did not create and left alone.
- **The number 03-07's checkpoint context must quote:** `G3.2` p1 = **+17.1pt (+1.49 lines)** — the **reserve-intact** rung. Roughly one rendered line of approval fund. One approval is fundable without a frozen-surface change; two are not.
- **No inherited obligation.** The Groupon/NetSpeed reword-shorter lever was not pulled, so no same-commit pairing is owed.
- **Still owed by later plans, unchanged by this one:** EXP-08 candidate (c) has **no Class D absence needle** — if it is the approved draft, 03-08 must add its needle (suggested `drop-before-create`) in the **same commit** that ships it. All three existing Class D needles (`AssumeRole`, `6-week`, `mentored`) remain absent-by-default and PASS (P3.67–P3.72), and the needle-casing table in `03-DECISION-RECORD.md` Section D governs any approved wording — a sentence-initial `Mentored` would leave `assert_absent 'mentored'` reading 0 forever.
- **`requirements-completed` is deliberately EMPTY and `requirements mark-complete` was NOT run**, despite this plan's `requirements: [EXP-07]`. Seventh consecutive plan in this phase to follow the rule. EXP-07 is claimed by 03-01, 03-02, 03-03, **03-06** and **03-08**, with 03-08 the last claiming plan. EXP-07's own text — *"Swiggy/Flipkart bullets tightened to staff-signal formulas (adoption-count + failure-class-closure slots)"* — is now **substantively satisfied** here, and unlike 03-05's handover the oracle is no longer red on anything. But the standing precedent (a requirement shared across plans completes when the LAST plan lands, not the first) still puts the tick at 03-08, and EXP-08's conditional wave can still change page-1 content that EXP-07's neutrality contract sits on top of.
- **Standing warnings carried forward for 03-07/03-08 and Phase 5:** (1) count the P3 census with the **anchored** `^RESULT P3\.[0-9]+ +FAIL` — the two `!!` footer lines contain the word FAIL by construction; (2) read a decision-marker payload by **scoping to its marker line**, never with a document-wide grep of `.planning/STATE.md`; (3) derive region line counts from **boundaries**, never from gate-line literals — and note this plan found the same trap on the **source** side, so re-resolve source line numbers by content too; (4) `G5.4` is warn-tier and cannot fail — assert the **value** in its message (now **11**); (5) the employer-before-subtitle order is now uniform across all five blocks but is an unmeasured-by-gate `pdftotext` artifact, so measure it, do not assume it.
- **Unchanged handoff to Phase 6:** `index.html:196` still duplicates both figures Phase 3 retired, and `index.html:207-225` still carries the site's career-break timeline entry. Both are live behind `.github/workflows/jekyll.yml` on push to `master`.

---
*Phase: 03-adobe-rebuild-staff-signal-bullets*
*Completed: 2026-08-22*

## Self-Check: PASSED

- `key-files.created` exists on disk: `.planning/phases/03-adobe-rebuild-staff-signal-bullets/03-06-SUMMARY.md`
- `key-files.modified` all exist: `docs/main.tex`, `docs/AshutoshTiwari.pdf`, `docs/AshutoshTiwari.log`, `docs/AshutoshTiwari.fdb_latexmk`
- Both task commits resolve in `git log --oneline --all`: `5215f88`, `03c8b38`
- Every task `<acceptance_criteria>` re-run after the final commit: region boundaries Swiggy **11**, Flipkart **9** (unchanged); `G3.2` p1 **+17.1pt** (unchanged from `03-05-SUMMARY.md`); all six Swiggy retention needles PASS; EXP-07 FAIL slice empty after filtering; `bash scripts/verify-resume.sh` exit **0** with `G1.1` 2 pages, `G2.1`/`G6.4` PASS, `G6.5` **17 PASS / 0 FAIL**, `G5.4` **11**; `18M+` on the Online Inference Platform bullet's first rendered line; `bash scripts/verify-phase2-regressions.sh` **27** anchored PASS / 0 FAIL; `bash scripts/verify-phase3-regressions.sh` exit **0** with **72** anchored PASS / **0** anchored FAIL; `make verify-selftest` exit **0** with ten G7/G8 PASS and zero SKIP; frozen cells byte-identical; `baseline-frozen.txt` and `manifest.txt` zero-diff; no new numeric claim in either region; both commits carry source with `.pdf`, `.log` and `.fdb_latexmk`.
- Plan-level `<verification>` re-run: `make verify` exit **0** (ROADMAP-criterion-5 corroboration only). `make clean` never run.
