---
phase: 03-adobe-rebuild-staff-signal-bullets
plan: 04
subsystem: resume-content
tags: [latex, pdftotext, ats-keywords, fault-tolerance, distributed-inference, rust, training-data-governance, page-budget]

# Dependency graph
requires:
  - phase: 03-01
    provides: "scripts/verify-phase3-regressions.sh — the acceptance oracle whose 32 03-04-owned FAILs this plan drives to zero, plus the <locked_literals> needle table"
  - phase: 03-02
    provides: "make verify-regressions / make verify chaining of the Phase-2 net, so every batch was gated against Phase-2 content regressions"
  - phase: 03-03
    provides: "03-DECISION-RECORD.md — the criterion-1 disposition table, the figure→evidence traceability table and the measured page-1 budget ledger this plan spent against"
  - phase: 02
    provides: "the +50.5pt page-1 headroom, the artifacts-ride-in-the-source-commit rule, and the measured 11.4–11.5pt/line unit cost"
provides:
  - "Adobe lead bullet rebuilt into fault-tolerance / distributed-inference voice at zero line cost (D-01)"
  - "new topic-only Training-Data Governance group in Rust, 2 rendered lines, all six governance needles, second Rust carrier (D-02)"
  - "all seven D-04 fault-tolerance mechanism needles named inline in the topics whose subsystems produced them"
  - "eight D-06 scale figures spread across the lead, A2, A10 and A11 at zero additional rendered lines"
  - "A100 and H100 promoted from KEYWORDS_TARGET to KEYWORDS_REQUIRED, suffixes stripped, in the same commit that landed them"
  - "P3 census 46 FAIL -> 14 FAIL; all 32 03-04-owned FAILs cleared; remaining FAILs owned only by 03-05 (13) and 03-06 (1)"
  - "measured page-1 headroom handed to 03-05: G3.2 p1 +28.1pt (+2.44 lines), EXP-08 reserve INTACT"
affects: [03-05, 03-06, 03-07, 03-08, phase-05-keyword-promotion, phase-06-site-sync]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "free-tail writing: append into an already-wrapped bullet's last rendered line — measured 0pt cost"
    - "topic-only \\resumeTopic as the 2-rendered-line carrier for a full multi-clause claim (the \\resumeTopic+nested-item shape costs 4 lines)"
    - "keyword promotion appended adjacently at the END of KEYWORDS_REQUIRED so 'A100|H100' is a witness that is false pre-promotion"

key-files:
  created:
    - .planning/phases/03-adobe-rebuild-staff-signal-bullets/03-04-SUMMARY.md
  modified:
    - docs/main.tex
    - docs/verify/manifest.txt
    - docs/AshutoshTiwari.pdf
    - docs/AshutoshTiwari.log
    - docs/AshutoshTiwari.fdb_latexmk

key-decisions:
  - "Adobe rendered region grew from 18 to 20 gate lines — exactly the +2 the ledger allocated to the A12 governance topic. Everything else in this plan (the lead rewrite, seven D-04 mechanisms, eight D-06 figures, the manifest promotion) landed at a measured 0pt: G3.2 p1 was +50.5pt after Task 1, +28.1pt after Task 2, and +28.1pt after Task 3."
  - "The three genie/asml GPU fleet figures (24×A100-40GB, 9 model queues, 64 H100s) landed in A2 Distributed Inference Frameworks, not in A10 Enrichment Service as 03-DECISION-RECORD.md Section A's owning-topic column lists. A10's 2-rendered-line capacity is ~268 characters and the table assigns it five figures plus four D-04 mechanisms — physically impossible at the 0-line target. A2 is the topic whose subsystem runs those GPU jobs, so every figure still sits in an owning topic (D-06's rule is spread-by-owning-topic, never an aggregate figure bullet) and criterion 3's evidence citations are untouched."
  - "Task 3's <automated> clause `grep -E 'FAIL' | grep -vcE '/03-0[56] ' | grep -qx 0` is unsatisfiable as written: the net emits two trailing `!!` footer lines that contain the word FAIL and carry no owner tag by construction, so the unanchored count can never reach 0 on any document. Gated on the anchored `^RESULT P3\\.[0-9]+ +FAIL` form instead — the same anchored-form rule the plan states three times for the P2 net's `>> PASS:` summary. Anchored count = 0."
  - "A10's retained claim was compressed to make room: 'Orchestration and abstraction layer over the inference framework and other ML Platform offerings; runs fire-and-forget pipelines on datasets of billions of images and videos' became 'Orchestration over the inference framework; …'. The vague 'datasets of billions of images and videos' was replaced by the evidenced 202.6M-row / 24.8M-clip figures, and that phrase still survives verbatim at A6. No locked literal and no keyword carrier was touched."
  - "G5.4 rose 8 -> 10 (Adobe digit-bearing gate lines 15, 16, 21, 22 plus new 25 and 27). Both new figures were deliberately placed on their bullets' FIRST rendered lines, because the G5.4 regex only matches bullet-glyph-prefixed lines. The A2 fleet figures wrapped onto continuation line 14 and are correctly invisible to G5.4 — the count did not need them."
  - "40-node landed in the lead bullet's lifecycle clause rather than in A10, using the pre-authorization in Task 1's action text. It sits on continuation line 12, so it contributes nothing to G5.4."

patterns-established:
  - "Measure, never predict: every batch was make build -> gate extraction -> verify-resume -> P2 net -> P3 net, with G1.1 read first and G3.2 p1 recorded in pt and lines"
  - "Character budgeting from the measured wrap width (itemize-2 ~135-140 chars/line, itemize-3 ~128-130) rather than from the ledger's conservative ~120 estimate — candidates were length-checked before any edit"
  - "Keyword promotion and the text that lands the keyword ship in one commit; the promotion witness grep -Fc 'A100|H100' == 1 distinguishes the promoted state from the pre-promotion KEYWORDS_TARGET entries"

requirements-completed: []

# Metrics
duration: 34 min
completed: 2026-08-23
---

# Phase 03 Plan 04: Adobe Content Rebuild Summary

**The Adobe block now opens on fault-tolerant distributed inference, carries a topic-only Rust training-data governance group in 2 rendered lines, and names all seven D-04 fault-tolerance mechanisms plus eight evidenced D-06 scale figures — for a total spend of exactly the +2 rendered lines the ledger allocated, with A100 and H100 promoted to BLOCKER tier in the commit that landed them.**

## Performance

- **Duration:** 34 min
- **Started:** 2026-08-23T04:14:02Z
- **Completed:** 2026-08-23T04:48:19Z
- **Tasks:** 3
- **Files modified:** 5 (`docs/main.tex`, `docs/verify/manifest.txt`, and the three regenerated artifacts)

## Accomplishments

- **All 32 `/03-04`-owned P3 FAILs cleared.** The net went 46 FAIL / 26 PASS on arrival to **14 FAIL / 58 PASS**, with the remaining FAILs owned only by `/03-05` (13) and `/03-06` (1) — zero unowned, exactly the contract 03-01 wrote.
- **D-01 satisfied at zero line cost.** The lead bullet's first rendered line now carries both `fault-tolerant` and `distributed inference`; the entry still renders as exactly 2 gate lines and `G3.2` p1 did not move.
- **D-02 shipped in the mandated shape.** `Training-Data Governance` is a topic-only `\resumeTopic` with no nested list, 2 rendered lines (gate 27–28), carrying `27,135`, `claim/receipt`, `immutable S3 evidence layouts`, `9.7k-line`, `lineage` and `Rust`, framed as fault-tolerant distributed systems and asserted free of `throughput`, `latency`, `speedup`, `faster` and `images/sec` in its own rendered region.
- **`Rust` is no longer single-carrier.** The governance topic landed the second copy before any reword of `docs/main.tex:163`, closing Pitfall 7's single point of failure on a BLOCKER keyword.
- **D-04 mechanisms named inline, no aggregate bullet.** `exponential backoff` + `full jitter` + `DLQ` in the pipeline/queue topic; `concurrency-safe S3 checkpoint` + `lease/TTL heartbeat` + `circuit breaker` + `idempotent re-run` in the Enrichment Service topic.
- **D-06 figures spread by owning topic** across four entries, all in mandated source form (`24$\times$A100-40GB`, `35--38M`, `\textasciitilde{}700M`) with `G6.4` still PASS.
- **Promotion paired with the text.** `A100` and `H100` appended adjacently at the END of `KEYWORDS_REQUIRED` with `:phase` suffixes stripped and deleted from `KEYWORDS_TARGET`, in the same commit as the figures that land them. `G6.5` now prints **15** PASS.
- **The anti-rot guard is still armed.** `make verify-selftest` exits 0 with ten G7/G8 PASS and zero SKIP; `G7.2` reports the +5 probe as a genuine 3-page overflow. No wave-ending net-freed state.

## Task Commits

Each task was committed atomically, source and regenerated artifacts together:

1. **Task 1: Rewrite the lead bullet into fault-tolerance / distributed-inference voice** — `2c37480` (feat)
2. **Task 2: Add the Rust training-data governance topic** — `5f1cd5e` (feat)
3. **Task 3: Mechanisms, figures and the A100/H100 promotion** — `3642e2b` (feat)

**Plan metadata:** see the trailing `docs(03-04)` commit.

## Per-task measurements

The plan's `<output>` block requires `G3.2` p1 in pt and lines, the `G5.4` value, the Adobe rendered-line count and the P3 FAIL census delta, per task. All figures are read from `bash scripts/verify-resume.sh` and `pdftotext | tr '\f' '\n'` on the committed artifact — none is predicted.

| | baseline (`2f6ac5a`) | Task 1 `2c37480` | Task 2 `5f1cd5e` | Task 3 `3642e2b` |
|---|---|---|---|---|
| `G1.1` | 2 pages | 2 pages | 2 pages | **2 pages** |
| `G2.1` | PASS | PASS | PASS | **PASS** |
| `G3.2` p1 | +50.5pt (+4.39 lines) | **+50.5pt (+4.39 lines)** | **+28.1pt (+2.44 lines)** | **+28.1pt (+2.44 lines)** |
| line delta vs baseline | 0 | **0** | **+2** | **+2** |
| `G5.4` value | 8 | **8** | **9** | **10** |
| `G6.5` PASS lines | 13 | 13 | 13 | **15** |
| `G6.4` | PASS | PASS | PASS | **PASS** |
| Adobe rendered lines | 18 (gate 11–28) | 18 (gate 11–28) | 20 (gate 11–30) | **20 (gate 11–30)** |
| P3 FAIL total | 46 | 44 | 32 | **14** |
| P3 FAIL owned `/03-04` | 32 | 30 | 18 | **0** |
| P3 census delta | — | −2 | −12 | **−18** |
| P2 anchored PASS | 27 | 27 | 27 | **27** |

**Which assertions each task flipped**

- Task 1 → `P3.21` (lead-bullet voice) and `P3.63` (`40-node`, landed in the lead's lifecycle clause under Task 1's pre-authorization).
- Task 2 → `P3.22`–`P3.33`: the six governance literals, the `Rust` ≥2 count clause, and the five framing clauses, which converted from *unmeasurable* (no line contained `Training-Data Governance`, so the region could not be sliced) into real region-scoped absence assertions over gate lines 27–28.
- Task 3 → `P3.34`–`P3.40` (seven D-04 mechanisms), `P3.43`/`P3.44` (the `A100`/`H100` promotion conjunctions), `P3.56`–`P3.62` (seven D-06 figures) and `P3.64`/`P3.65` (the raw-stream accelerator keywords).

**Budget verdict — the EXP-08 reserve is INTACT.** `G3.2` p1 is **+28.1pt**, above the ledger's `≥ +16.1pt` "reserve intact" rung. **No fourth rendered line was spent**, so the sanctioned Groupon/NetSpeed reword-shorter lever was NOT pulled and no same-commit obligation is inherited. 03-05's D-05 swap has its +1 line (≈11.5pt) and roughly one further line remains as the EXP-08 approval fund. `G3.2` p1 never rose above the +50.5pt baseline at any point, so rail 2 held and `G7.2` stayed armed throughout.

## Files Created/Modified

- `docs/main.tex` — 5 content lines changed across the plan (`:151` lead, `:152` A2, `:156` A5, `:164` A10, `:166` A11) plus 1 line inserted (`:165` the new A12 governance topic). Net `+8 / -7` over `2f6ac5a..HEAD`.
- `docs/verify/manifest.txt` — exactly 2 lines changed (`:53` `KEYWORDS_REQUIRED` gains `|A100|H100` at the end; `:54` `KEYWORDS_TARGET` loses `A100:3|H100:3`). No other key touched; `CUDA graphs:3` deliberately left unpromoted (Phase 5 owns the exact-match form), `torch.compile:3` and `Triton:5` left for 03-05.
- `docs/AshutoshTiwari.pdf` / `.log` / `.fdb_latexmk` — regenerated and committed **with** their source in every task commit, so `G0.3` holds on a fresh checkout of each one (verified: `G0.3 PASS`, latexmk md5 `f7800e80a90783cac0308eb2a4b646f9`). `.aux` / `.fls` / `.out` are tracked but were byte-unchanged. `make clean` was never run.

### Where each needle landed

| entry | source | needles landed | rendered lines | line cost |
|---|---|---|---|---|
| A1 lead | `:151` | `fault-tolerant`, `distributed inference`, `40-node` | 11–12 (2) | 0 |
| A2 Distributed Inference Frameworks | `:152` | `24×A100-40GB`, `9 model queues`, `64 H100s` | 13–14 (2) | 0 |
| A5 pipeline / queue modeling | `:156` | `exponential backoff`, `full jitter`, `DLQ` | 17–18 (2) | 0 |
| A10 Enrichment Service | `:164` | `202.6M-row`, `24.8M`, `idempotent re-run`, `concurrency-safe S3 checkpoint`, `lease/TTL heartbeat`, `circuit breaker` | 25–26 (2) | 0 |
| **A12 Training-Data Governance (new)** | `:165` | `Training-Data Governance`, `27,135`, `claim/receipt`, `immutable S3 evidence layouts`, `9.7k-line`, `lineage`, `Rust` (2nd carrier) | 27–28 (2) | **+2** |
| A11 Data Quality Framework | `:166` | `~700M`, `35–38M` | 29–30 (2) | 0 |

A3 (`:154`), A4 (`:155`), A6 (`:158`), A7 (`:160`), A8 (`:161`) and A9 (`:163`) were **not touched** — nothing in this plan is assigned to them and each is either at rendered capacity or the sole carrier of a protected literal. That also discharges Task 3's ordering rule mechanically: A9 was never reworded, so `Rust` was never momentarily ×0.

## Decisions Made

1. **Fleet figures moved from A10 to A2.** Recorded above and in Deviations. Evidence citations unchanged; the figures remain spread across owning topics rather than aggregated.
2. **A10's retained claim compressed.** "…and abstraction layer…and other ML Platform offerings" and "datasets of billions of images and videos" gave way to the two evidenced migration figures. D-03's disposition for A10 is *retain-and-revise*, "revised tighter" is the explicit instruction, and no locked literal or keyword carrier was involved. "billions of images and videos" still survives verbatim at A6 (`:158`).
3. **`40-node` in the lead, not A10.** Task 1's action text pre-authorizes this ("…which is where D-06's `40-node` daily EMR ingestion figure may land if it reads naturally in the lifecycle clause"), and A10 had no room for a sixth item.
4. **`requirements-completed` is deliberately EMPTY and `requirements mark-complete` was NOT run**, despite the plan's `requirements: [EXP-02, EXP-04]`. EXP-02 is claimed by 03-01/02/03/04/08 and EXP-04 by 03-01/03/04/05/08, with **03-08 the last claiming plan for both and 03-08 Task 3 owning the EXP-02 tick**. EXP-04 is also substantively incomplete: its own requirement text names the `1.09M`-row / `8×A100` Ray benchmark, and `P3.46`–`P3.55` (retirement, attribution, replacement) are still RED under 03-05. This is the fourth consecutive plan in this phase to follow the rule 03-01/03-02/03-03 and Phase 2 Plan 01 set — a requirement shared across plans completes when the LAST plan lands.
5. **Character budgeting was re-derived from the measured wrap width, not from the ledger's estimate.** The ledger's per-shape capacity of ≈120–124 characters is conservative; the committed artifact shows itemize-2 lines reaching 135–140 characters and itemize-3 lines reaching 128–130, including a *last* line at 135 (gate 28). Every candidate string was length-checked against that measured width before being written, which is why all four revisions landed at 2 rendered lines on the first build with zero retries.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Task 3's `<automated>` FAIL-census clause is unsatisfiable as written**
- **Found during:** Task 3 (verification, before commit)
- **Issue:** The clause `bash scripts/verify-phase3-regressions.sh | ... | grep -E 'FAIL' | grep -vcE '/03-0[56] ' | grep -qx 0` matches on the *unanchored* word `FAIL`. The net emits two trailing footer lines — `!! FAIL: 14 of 72 Phase-3 regression assertion(s) failed: …` and `!! Every RESULT … FAIL line above names its owning plan and its remedy.` — neither of which carries an owner tag, by construction. The unanchored count is therefore **2** on a fully-correct document and can never reach 0, so the whole `<automated>` command returned exit 1 while every acceptance criterion was in fact satisfied.
- **Fix:** Gated on the anchored form `grep -E '^RESULT P3\.[0-9]+ +FAIL' | grep -vcE '/03-0[56] ' | grep -qx 0`, which is exactly the discipline the plan itself mandates three times for the P2 net (*"a green run emits 28 lines containing the word PASS — the `>> PASS:` summary is the 28th, so always count the anchored form"*). The plan applied that rule to PASS and missed it for FAIL.
- **Files modified:** none — this is a verification-command defect, not a deliverable defect. No script and no assertion was changed.
- **Verification:** anchored `^RESULT P3\.[0-9]+ +FAIL` lines not owned by `/03-05` or `/03-06` = **0**; `/03-04`-owned FAILs = **0**; anchored PASS lines = **58**; the corrected full `<automated>` command exits **0**.
- **Committed in:** n/a (no file change); recorded here so 03-05 and 03-08 do not re-hit it — their plans reuse the same clause shape.

**2. [Rule 3 - Blocking] D-06's three GPU fleet figures placed in A2 rather than A10**
- **Found during:** Task 3 (allocation, before any edit)
- **Issue:** `03-DECISION-RECORD.md` Section A's owning-topic column assigns `24×A100-40GB`, `9 model queues`, `64 H100s`, `202.6M-row` and `24.8M` all to A10 Enrichment Service, and Task 3 additionally requires four D-04 mechanisms in A10. A10 renders 2 lines with a measured capacity of ~268 characters; its retained claim plus those five figures and four mechanisms measures ~345 characters. There is no arrangement that fits at Task 3's 0-additional-line target, and the contingency ladder forbids spending the line unless the room has measurably run out elsewhere — it had not.
- **Fix:** The three genie/asml *fleet* figures went to A2 `Distributed Inference Frameworks`, the topic whose subsystem runs those GPU jobs (offline/batch inference modules — `CODEBASE-EVIDENCE.md:62`, `:98`); the two *migration* figures stayed in A10 alongside `idempotent re-run` and the three control-plane mechanisms. D-06's binding rule is that figures are **spread by owning topic** rather than lumped into one aggregate figure bullet, and that still holds: every figure sits in a topic whose subsystem produced it.
- **Files modified:** `docs/main.tex:152` (A2), `docs/main.tex:164` (A10)
- **Verification:** `P3.56`, `P3.57`, `P3.58`, `P3.64`, `P3.65` all PASS; criterion 3's evidence citations are unchanged (`CODEBASE-EVIDENCE.md:62` for `24×A100-40GB` and `9 model queues`, `:98` for `64 H100s`); the whole task landed at **0** additional rendered lines with `G3.2` p1 unchanged at +28.1pt.
- **Committed in:** `3642e2b`

---

**Total deviations:** 2 auto-fixed (1 verification-command bug, 1 blocking placement constraint)
**Impact on plan:** Neither weakens an assertion or a threshold. The first corrects a check that could not pass on any document; the second is a placement judgment the plan's own D-06 rule (spread, don't aggregate) permits, forced by a measured capacity limit. No locked literal was shortened, no manifest threshold was moved, `PROBE_LINES` and `DIGIT_BULLET_FLOOR` are byte-untouched, and no scope was reduced — all 32 owned assertions are green.

## Threat-model verification

| Threat ID | Mitigation asserted | Evidence |
|---|---|---|
| T-03-18 | frozen title/date/employer/subtitle cells intact | `docs/main.tex:148` and `:149` byte-identical `2f6ac5a..HEAD` (per-line sha compared); `G5.1`/`G5.2`/`G5.5` PASS; `docs/verify/baseline-frozen.txt` byte-unchanged (empty `git diff --stat`) |
| T-03-19 | no single-occurrence BLOCKER keyword lost | `G6.5` 15/15 PASS; `Falcon-40B`, `Llama~2~70B`, `SQS queue depth`, `Source $\to$ Transform $\to$ Sink`, `FSDP/FSDP2`, `Flash Attention` each ×1 in source; `Rust` ×2; governance landed the second `Rust` before A9 was ever reworded (A9 untouched) |
| T-03-20 | promotion carries no `:phase` suffix | `grep -c 'A100:3\|H100:3' docs/verify/manifest.txt` = **0**; `LC_ALL=C grep -Fc 'A100\|H100'` = **1**; `P3.43`/`P3.44` conjunctions PASS |
| T-03-21 | no stale artifact certified fresh | artifacts in every source commit; `G0.3 PASS` (latexmk md5 `f7800e80a90783cac0308eb2a4b646f9`); `make clean` never run |
| T-03-22 | no silent 3-page overflow | `G1.1` read FIRST after all six builds, 2 pages every time; `G3.1`/`G2.3`/`G2.4` never used as fit evidence |
| T-03-23 | budget spent, not freed | `G3.2` p1 +50.5 → +50.5 → +28.1 → +28.1pt, never rising; `make verify-selftest` exit 0 with `G7.2 PASS the probe PDF is 3 page(s)`; `PROBE_LINES` and `DIGIT_BULLET_FLOOR` byte-untouched |
| T-03-24 | Content Gate not framed as inference optimization | `P3.29`–`P3.33` PASS as **real region-scoped** assertions over gate lines 27–28 (previously *unmeasurable*): `throughput`, `latency`, `speedup`, `faster`, `images/sec` all count 0 in the sliced region |
| T-03-25 | no undeclared glyph | `G6.4 PASS`; census U+00D7 ×1→×2 (`$\times$`), U+2013 ×38→×40 (`35--38M` + the new bullet glyph), U+2019 ×5→×6 — all already in `NONASCII_ALLOW`; `~700M` written `\textasciitilde{}700M` and extracts as ASCII U+007E; `grep -c 'sim\$700M\|\$\sim\$700M' docs/main.tex` = **0** |
| T-03-SC | package installs | none — zero packages installed |

## Issues Encountered

None. Every revision landed at its target rendered-line count on the first build, because candidate strings were length-checked against the measured wrap width before being written rather than after. No `make clean`, no rollback, no fix-attempt retries.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

**Ready for 03-05.** What it inherits:

- **`G3.2` p1 = +28.1pt (+2.44 lines).** The D-05 Ray swap's +1 rendered line (≈11.5pt) lands it at ≈+16.6pt, which keeps the EXP-08 approval fund and leaves the reserve intact. **The Groupon/NetSpeed reword-shorter lever was not pulled and is still available untouched.**
- **14 P3 FAILs remain**, 13 owned by `/03-05` (`P3.41`, `P3.42`, `P3.45`–`P3.55`) and 1 by `/03-06` (`P3.66`). Zero unowned. A 15th FAIL means the net is wrong, not the document.
- **Manifest promotion slot.** `A100|H100` now ends `KEYWORDS_REQUIRED`. Per Task 3's rule, 03-05 appends `torch.compile` and `Triton` **after `H100`**, suffixes stripped, in the same commit that lands them — which also means `grep -Fc 'A100|H100'` stays a valid witness only until then; 03-05 should re-derive its own adjacency witness.
- **`CUDA graphs:3` deliberately unpromoted** in `KEYWORDS_TARGET` (Phase 5 owns the exact-match form; D-07's hyphenated phrasing would not land it anyway).
- **Class E gap still open.** 03-05 Task 3 owes the branch-conditional `CUDA` absence needle on the `triton-only-fallback` branch — or, on `cudagraphs-confirmed`, a SUMMARY record that it was deliberately not added.
- **A4 (`docs/main.tex:155`) is untouched and still at rendered capacity** (128 characters on its single line), carrying both retired figures and the `achieving` verb. It is 03-05's target exactly as planned; the +1 line is the budgeted cost of turning it into a 2-line item.
- **`make verify-selftest` is green with `G7.2` armed**, so 03-05 starts from a non-net-freed state.

---
*Phase: 03-adobe-rebuild-staff-signal-bullets*
*Completed: 2026-08-23*

## Self-Check: PASSED

All six key files verified present on disk with `[ -f ]`. All three task commits verified present in `git log --oneline --all` (`2c37480`, `5f1cd5e`, `3642e2b`). Every `<acceptance_criteria>` item from all three tasks re-run and passing; the plan-level `<verification>` loop re-run on the committed artifact: `bash scripts/verify-resume.sh` exit 0 with `G0.3`/`G1.1`/`G2.1`/`G6.4` PASS, `G6.5` 15/15 PASS, `G3.2` p1 +28.1pt (+2.44 lines), `G5.4` 10; `bash scripts/verify-phase2-regressions.sh` exit 0 with 27 anchored `^RESULT P2\..*PASS` lines; `bash scripts/verify-phase3-regressions.sh` exit 1 with 58 PASS / 14 FAIL and **zero** `/03-04`-owned FAILs; `make verify-selftest` exit 0 with ten G7/G8 PASS and no SKIP.
