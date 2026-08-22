---
phase: 02-page-1-budget-text-layer-defects
verified: 2026-08-22T13:05:00Z
status: passed
score: 20/20 must-haves verified
overrides_applied: 0
re_verification:
  previous_status: none
  previous_score: n/a
  gaps_closed: []
  gaps_remaining: []
  regressions: []
carried_warnings:
  - id: WR-01
    summary: "FLIPKART subtitle extracts before its employer line; deferred to Phase 3 by orchestrator judgment"
    deferral_assessment: sound
    evidence: "Pre-phase artifact (65573ac) already extracted title→date→employer for ALL FIVE role blocks; the only Phase-2 delta is FLIPKART's G6.13 span 4→5, which the harness reports as a non-gating WARN. No Phase-2 must-have, ROADMAP criterion, or requirement asserts Work-Experience employer ordering, and G5.5 whole-line employer freeze is 5/5 PASS."
    carry_forward: "Phase 3 must claim G6.13's 'owner: unassigned' field; the flip is documented in 02-REVIEW.md but in neither SUMMARY."
---

# Phase 2: Page-1 Budget & Text-Layer Defects Verification Report

**Phase Goal:** The page-1 line budget every later phase spends actually exists, and the three live text-layer defects are gone — with `make verify` green for the first time
**Verified:** 2026-08-22T13:05:00Z
**Status:** passed
**Re-verification:** No — initial verification

Every figure below was produced by running the harness in this session. No SUMMARY claim was accepted as evidence; the pre-phase artifact was reconstructed from git and measured independently.

## Harness Execution (run, not assumed)

| # | Command | Expected | Observed | Verdict |
|---|---------|----------|----------|---------|
| 1 | `bash scripts/verify-resume.sh` | exit 0, zero FAIL | exit **0**, `RESULT … FAIL` count **0**, trailer `>> PASS: 0 blocking failures.` | ✓ |
| 1a | G5.1 / G5.2 / G5.5 | 5/5/5 PASS | **5 / 5 / 5** PASS, each "exactly once as a whole extracted line" | ✓ |
| 2 | `make verify-selftest` | exit 0, G7.[1-4]=4 + G8.[1-6]=6 | exit **0**, G7.1–G7.4 **4 PASS**, G8.1–G8.6 **6 PASS**, 0 SKIP | ✓ |
| 3 | `make verify` | exit 0 | exit **0**, 0 FAIL, PDF byte-unchanged (md5 `5573d256…` pre == post) | ✓ |
| — | Gate tally | — | 60 PASS / 0 FAIL / 15 WARN / 8 INFO | ✓ |

`make verify` did not rebuild: G0.4 reported `pdf=1787424325 tex=1787424320`, so the PDF is newer and Make's prerequisite is satisfied. Tree after all three runs: only untracked `.omc/` (pre-existing, not a phase artifact — it is also the "1 path already modified" G7.4 names).

## Goal Achievement — ROADMAP Phase 2 Success Criteria

Both **superseded literals** are honored as binding; neither was corrected backwards.

| # | Criterion | Status | Evidence |
|---|-----------|--------|----------|
| 1 | Experience runs Swiggy → Adobe with no career-break row, master's dates still visible in Education | ✓ VERIFIED | Source diff `65573ac..HEAD` deletes the whole `\resumeSubheading{Career Break for Master's Degree}` block; text-layer diff removes its 6 lines (`Career Break for Master's Degree`, `MASTER OF SCIENCE IN…`, the descriptor). Grep for `career\|sabbat` in the text layer: the only hit is `Structural Latency Breakdown` (a NetSpeed module name — false positive on "Break"). `Aug. 2021 – May 2023` extracts as a whole line **exactly once**, inside the EDUCATION region. |
| 2 | Groupon and NetSpeed render as one compact earlier-experience block that still reads C++ and Network-on-Chip | ✓ VERIFIED | Both `\resumeTopic` bodies replaced by a single `\resumeItem{\textit{…}}`; both sit inline at the bottom of WORK EXPERIENCE with **no new section heading** (G6.7 PASS, G6.8 PASS ×**7**, manifest `SECTIONS` byte-untouched). Text layer: `C++` ×3, `Network-on-Chip` ×1. Page-1 tail confirms the shape: `GROUPON / BACKEND ENGINEERING / – …` then `NETSPEED SYSTEMS (Acquired by Intel) / GRAPH ALGORITHMS, NETWORK ON CHIP / – …`. |
| 3 | `pdftotext` contains the correct hyphenated handle **[superseded → `ashutosh--tiwari`]** and zero `ashutosh–tiwari` (en dash) | ✓ VERIFIED | `ashutosh--tiwari` present on **1** line; hexdump of the extracted token = `61 73 68 75 74 6f 73 68 2d 2d 74 69 77 61 72 69` — **two U+002D**, not U+2013. En-dash form: **0** occurrences. G6.9 PASS, G6.10 PASS. The single-hyphen literal in ROADMAP:50 was **not** propagated into the manifest (STATE.md `[Phase 1 / A1]` supersession respected). |
| 4 | Text layer carries portfolio, GitHub, LinkedIn URLs as literal strings, not masked anchors | ✓ VERIFIED | `thunderock.github.io` ×1, `github.com/thunderock` ×1, `linkedin.com/in/ashutosh--tiwari` ×1, `findashutoshtiwari@gmail.com` ×1 — all four G6.9 PASS. Masked display text (`Homepage/Portfolio`, `Github@thunderock`, `Linkedin@ashutosh--tiwari`) is gone from the diff. Clickability preserved: the PDF's compressed object streams yield **27 URI annotations** including all four contact targets, and every `\href` target is byte-identical pre/post. |
| 5 | `make verify` passes end-to-end, headroom shows **[superseded → measured, not ≥12]** page-1 space recovered | ✓ VERIFIED | `make verify` exit **0**; `bash scripts/verify-resume.sh` exit **0**. Budget independently re-measured by running the harness against the reconstructed pre-phase artifact: **pre** `G3.1` deepest bottom **764.3pt`, `G3.2` p1 headroom **+0.1pt (+0.00 lines)** → **post** `G3.1` **713.9pt`, `G3.2` **+50.5pt (+4.39 lines)**. Recovery = **50.4pt**, exactly the ROADMAP figure. No manifest threshold moved (`PAGES`, `CEILING_PT`, `LINE_PT`, `PROBE_LINES`, `CAREER_BREAK_PT` all untouched); `baseline-frozen.txt` untouched. |

**Score: 5/5 ROADMAP criteria verified.**

## Observable Truths — PLAN frontmatter must_haves

### 02-01 (contact line, career break, fold, budget)

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | D-02: handle extracts as `ashutosh--tiwari`, never U+2013 | ✓ VERIFIED | See criterion 3. Ligature broken via `ashutosh-{}-tiwari` (empty-group technique — one of the three the plan left to executor discretion); `\href` target unchanged. |
| 2 | D-01 + D-03: portfolio + GitHub literal on the contact line, all contact items still clickable | ✓ VERIFIED | See criterion 4. **Precision note:** `\href` count is **4 pre-phase and 4 post-phase** — the phone `669-292-7534` was never a link (D-01: "Phone and email keep their current forms"). The truth's "all five clickable" overstates by one; there is **no regression** — 4/4 links intact with byte-identical targets. |
| 3 | D-10: Work Experience runs Adobe → Swiggy, no career-break row anywhere in the text layer | ✓ VERIFIED | See criterion 1. |
| 4 | D-04/05/06: each reads as one compact block; NetSpeed names C++, Network-on-Chip + all four modules; Groupon names Cyclops, NSVD, Neo4j, customer segmentation, the customer-service platform in every Groupon country | ✓ VERIFIED | `Virtual Channel Arbitration` ×1, `Polarity-based Arbitration` ×1, `Multi-Cast Filtering` ×1, `Structural Latency Breakdown` ×1, `Network-on-Chip` ×1. `NSVD` ×1, `Neo4j` ×1, `Cyclops` ×1, `every Groupon country` ×1. Two literals needed normalization, both benign and both present: `customer segmentation` ships sentence-capitalized as **"Customer segmentation"** (case-insensitive ×1 — the NT-03 editorial rendering), and `customer-service platform` **wraps a line break** (`…customer-service` / `platform live in…`) so it matches ×1 once whitespace-normalized. |
| 5 | D-07: every employment date, title and employer still byte-identical to the Phase-1 honesty freeze | ✓ VERIFIED | G5.1 5/5, G5.2 5/5, G5.5 5/5 — all whole-line, all count exactly 1. `docs/verify/baseline-frozen.txt` **unmodified** in the phase diff (no `--write-baseline` escape hatch used). G4.1 hash `8b13a46bf5716cb9…f465a56` is **identical** to the value Phase 1 recorded. |
| 6 | D-08: recovered headroom recorded as a measured number, not a predicted figure | ✓ VERIFIED | ROADMAP:56 and REQUIREMENTS:22 both carry the measured `50.4pt / 4.39 lines` with the derivation printed; D-08's own "10–11 lines" is explicitly corrected downward. Reproduced from scratch this session (criterion 5). |

### 02-02 (Education parse order, harness reconciliation, green gate)

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 7 | D-09: inside EDUCATION a text-only parser reads the institution first — not a city, not a date | ✓ VERIFIED | `G6.12 PASS` — "the institution line 'Indiana University, Bloomington' (line 94) is the first non-empty line in the region, and date line 97 is 2 non-empty line(s) away (window 3)". Region dump confirms: `EDUCATION / Indiana University, Bloomington / Master of Science… 3.87/4.0 / Aug. 2021 – May 2023`. |
| 8 | D-09: neither `Bloomington, IN` nor `Patna, India` anywhere in the text layer; both degree date ranges still there | ✓ VERIFIED | `Bloomington, IN` **0**, `Patna, India` **0**. `Aug. 2021 – May 2023` whole-line ×1, `Aug. 2011 – May 2015` whole-line ×1. |
| 9 | The Education assertion still FAILS on the pre-change document — fixed, not weakened | ✓ VERIFIED | **Independently reproduced.** Ran the current harness against the reconstructed pre-phase pair (`git show 65573ac:` → `/tmp`, `--skip-freshness`): exit **1**, `!! FAIL: 5 blocking failure(s) in: G6.9 G6.10 G6.12`, with `G6.12 FAIL … the institution line … is NOT the first non-empty line in the region — line 100 comes first and reads 'Bloomington, IN'`. The anchor-free clause fires on the old document. Not a tautology. |
| 10 | `bash scripts/verify-resume.sh` exits 0 on the committed artifact — green for the first time | ✓ VERIFIED | Run #1: exit 0, 0 FAIL. Phase 1 recorded arrival at exit 1 / 5 FAILs; my negative control reproduced **exactly** that 5-FAIL set on the pre-phase artifact, so the 5→0 transition is measured on both ends. |
| 11 | `make verify-selftest` exits 0 and the +N-line probe still genuinely overflows after the budget was freed | ✓ VERIFIED | exit 0. `G7.2 PASS` — "the probe PDF is 3 page(s), above the manifest PAGES=2 budget, so the +5 probe is a genuine overflow". `PROBE_LINES=5` unchanged; margin re-derived: 5 × 11.5 = 57.5pt probe vs 50.5pt slack = **7.0pt armed**. |
| 12 | A fresh checkout can verify the committed PDF without refusing it as stale | ✓ VERIFIED | **Independently reproduced.** `git clone` of HEAD into `/tmp`: porcelain **0 entries**, `bash scripts/verify-resume.sh` → exit **0**, `G0.3 PASS PDF provably built from current main.tex (latexmk md5 eff2ec04067eb8fa60b775424a0a3a53)`, 0 FAIL. `G0.4 INFO mtimes identical … as expected after a checkout`. |

**Score: 12/12 plan truths verified.**

## Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `docs/main.tex` | bare-URL contact line + `--` ligature break; no career break; folded Groupon/NetSpeed; Education institution-first | ✓ VERIFIED | Contains `https://linkedin.com/in/ashutosh--tiwari` (href target) and `ashutosh-{}-tiwari` (display). Full phase diff = **24 changed lines**, all 5 intended edits, nothing else. |
| `docs/AshutoshTiwari.pdf` | 2-page artifact, all four `CONTACT_LITERALS`, zero `FORBIDDEN_LITERAL` | ✓ VERIFIED | `pdfinfo` Pages: **2**. 4/4 contact literals present, forbidden literal 0. Glyph gates clean: G6.1/G6.2/G6.3 = 0 ligature / 0 private-use / 0 U+FFFD; G6.4 PASS (every non-ASCII declared). |
| `docs/AshutoshTiwari.fdb_latexmk` | md5 record tying artifact to source so G0.3 passes on a fresh checkout | ✓ VERIFIED | Record line 119: `"main.tex" … eff2ec04067eb8fa60b775424a0a3a53`; live `md5 -q docs/main.tex` = `eff2ec04067eb8fa60b775424a0a3a53`. **Byte-for-byte match** — spot-check requested by the verification brief. Confirmed again from a virgin clone. |
| `scripts/verify-resume.sh` | anchor-free G6.12 ordering clause | ✓ VERIFIED | Contains `region_first_nonempty` (helper at :405–406). Negative control proves it fires (truth #9). |
| `docs/verify/manifest.txt` | `EDU_CITY` removed with its only reader; `PROBE_LINES` reconciled | ✓ VERIFIED | Phase manifest diff is **exactly** the `EDU_CITY` deletion + its explanatory comment. `grep -rn EDU_CITY` over `*.sh`/`*.txt`/`*.tex`/`Makefile` outside `.planning/`: **0**. `PROBE_LINES` reconciliation outcome = correctly left at 5, proven still-armed by G7.2 (truth #11). |

## Data-Flow / Wiring Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `main.tex` contact line | manifest `CONTACT_LITERALS` | pdftotext line 2, substring-matched by G6.9 | ✓ WIRED | All four literals resolve on extraction line 2; pattern `linkedin\.com/in/ashutosh--tiwari` matches. |
| Groupon/NetSpeed `\resumeSubheading` rows | `baseline-frozen.txt` dates/titles/employers | whole-line match by G5.1/G5.2/G5.5 | ✓ WIRED | `Sep. 2016 – Sep. 2017` and `Sep. 2015 – Aug. 2016` both whole-line ×1; fold did not disturb the two-row header the freeze depends on. |
| `verify-resume.sh` G6.12 | manifest `EDU_INSTITUTION` + `EDU_DATE` + `EDU_BIND_WINDOW` | `section_region('EDUCATION')` → `region_first_nonempty`, window retained | ✓ WIRED | G6.12 PASS reports both clauses (first-non-empty **and** the 2-away/window-3 binding). |
| manifest `PROBE_LINES` | G7.1/G7.2 self-test probe | injected `\resumeItem` count pushing past `PAGES=2` | ✓ WIRED | Probe anchors still resolve (`begin=127 break=211 insert=207`); probe yields 3 pages. |

## Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|----------|---------|--------|--------|
| Gate is green on the committed artifact | `bash scripts/verify-resume.sh` | exit 0, 0 FAIL | ✓ PASS |
| Gate is exposed through Make | `make verify` | exit 0 | ✓ PASS |
| Gates provably still fire | `make verify-selftest` | exit 0, 10/10 controls | ✓ PASS |
| Gate still fails on the pre-phase document | `… --pdf <65573ac pdf> --tex <65573ac tex> --skip-freshness` | exit 1, 5 FAIL in G6.9/G6.10/G6.12 | ✓ PASS |
| Fresh checkout verifies without staleness refusal | `git clone` → `bash scripts/verify-resume.sh` | exit 0, G0.3 PASS | ✓ PASS |
| Build is clean (contact line did not run wide at `\small`) | `grep -c Overfull\|Underfull\|LaTeX Warning docs/AshutoshTiwari.log` | **0 / 0 / 0** | ✓ PASS |
| Document is exactly 2 pages, page 2 opens at PUBLICATIONS | `pdfinfo`; `pdftotext -f 2 -l 2` first non-empty | `Pages: 2`; `PUBLICATIONS` | ✓ PASS |

## Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|-------------|-------------|--------|----------|
| **EXP-01** | 02-01 + 02-02 | Career-break entry removed; Experience runs Swiggy → Adobe; Education carries the master's dates | ✓ SATISFIED | Criterion 1 + truths 3, 7, 8. Correctly closed by 02-02 (the last plan to land), not 02-01 — `G6.12` was still red at 02-01's close, so closing it earlier would have misreported the phase. |
| **EXP-05** | 02-01 | Groupon + NetSpeed folded; NetSpeed retains C++/Network-on-Chip as C++ evidence | ✓ SATISFIED | Criterion 2 + truth 4. Corrected parenthetical carries the measured 1.5pt / 0.13-line fold contribution and the 50.4pt / 4.39-line phase total. |
| **EXP-06** | 02-01 | LinkedIn en-dash defect fixed; portfolio URL literal in the text layer | ✓ SATISFIED | Criteria 3 + 4, truths 1 + 2. |

**Orphan check:** `REQUIREMENTS.md` maps exactly `EXP-01`, `EXP-05`, `EXP-06` to Phase 2; all three are claimed in PLAN frontmatter and all three are checkboxed `[x]` with a consistent coverage table (`Complete`) and Progress row (`2/2 Complete`). **No orphaned requirements.** `EXP-02/03/04/07/08` remain `[ ]` / `Pending → Phase 3` — correctly untouched.

## Docs Hygiene (superseded figures)

| Check | Result |
|-------|--------|
| ROADMAP:50 criterion 3 single-hyphen literal preserved as superseded | ✓ intact — not corrected backwards |
| ROADMAP:52 criterion 5 "≥12 lines" preserved as superseded | ✓ intact — not corrected backwards |
| ROADMAP:54-56 Superseded-literals note binds both | ✓ present, both bullets |
| Measured figure `50.4pt` occurrences | **2** — ROADMAP:56 ×1, REQUIREMENTS:22 ×1. No duplication |
| Measured figure `4.39` occurrences | **2** — same two lines. No duplication |
| Leftover placeholders (`TBD`/`TODO`/`FIXME`/`<measured>`) | **0** (excluding legitimate `Plans: TBD` for unplanned Phases 3-6) |

## Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| `scripts/verify-resume.sh` | 468, 837, 979, 1023, 1083, 1106, 1121 | `XXXXXX` | ℹ️ Info — **false positive** | `mktemp -d` templates; the X's are required by `mktemp`. Not debt markers. |
| `docs/main.tex` | 303 | `HACK` | ℹ️ Info — **false positive** | Substring of the repository name `AnalyticsVidhya_JANATAHACK`. Pre-existing, untouched by this phase. |

**Debt-marker gate: PASS.** Zero genuine `TBD` / `FIXME` / `XXX` / `TODO` / `PLACEHOLDER` in any phase-modified file (`docs/main.tex`, `scripts/verify-resume.sh`, `docs/verify/manifest.txt`).

## Scope-Leak Check (Phase 3/4/5 content)

| Guard | Result |
|-------|--------|
| Adobe bullets untouched | ✓ Full `main.tex` phase diff (24 lines) contains **no** Adobe-block hunk |
| Skills untouched | ✓ diff grep for `skill\|vLLM\|torch.compile\|Triton` = **0** matches; `G6.14 WARN` still reports Skills at 4 lines vs target 3, owner Phase 5 |
| GPAs retained (Phase 4 / PG2-03 owns removal) | ✓ `3.87/4.0` and `8.32/10.0` both still extract (2 hits) |
| Forward-work WARNs still correctly owned | ✓ `G6.6` ×7 (torch.compile, A100, H100, ONNX, CUDA graphs, Iceberg, Triton) all x0 with owners Phase 3/Phase 5; `G5.4` owner Phase 3 |

**No Phase 3/4/5/6 scope leaked in.**

## Commit Story

| Commit | Subject | Convention |
|--------|---------|-----------|
| `92f4891` | `feat(02-01): display bare URLs in the contact line and break the -- ligature` | ✓ |
| `450a312` | `feat(02-01): delete the career-break entry from Work Experience` | ✓ |
| `933778e` | `feat(02-01): fold Groupon and NetSpeed to header plus one italic descriptor` | ✓ |
| `632b632` | `docs(02-01): complete page-1 budget and contact-line defects plan` | ✓ |
| `29999ff` | `feat(02-02): drop the Education city cells and bind the date to the degree row` | ✓ |
| `232abc2` | `fix(02-02): assert Education institution-first without a second anchor` | ✓ |
| `10be4ab` | `docs(02-02): record the measured page-1 budget and land the green gate` | ✓ |
| `e4527ed` | `docs(02-02): complete education parse order and green-gate plan` | ✓ |
| `980743e` | `docs(02): code review` | ✓ |

Clean Conventional Commits throughout (`feat`/`fix`/`docs` with phase-plan scopes), one logical change each, source-before-doc ordering. No standalone `build(...)` commit exists **by design**: regenerated artifacts ride inside their source commit (e.g. `29999ff` carries `main.tex` + `.pdf` + `.log` + `.fdb_latexmk` together), so a fresh checkout of *any* commit in the range has a `.fdb_latexmk` md5 matching its own `main.tex`. Deferring artifacts to a trailing build commit would have left `29999ff` carrying a stale PDF. Verified end-state: fresh clone of HEAD → `G0.3 PASS`. No internal-tooling terminology leaked into any message (grep for tool names: 0).

## Carried Warning — WR-01 Deferral Assessment

**Finding:** `SEARCH RELEVANCE, QUERY INTENT, NLP` (Flipkart's subtitle) now extracts *before* `FLIPKART (a Walmart company)`; pre-phase the employer came first. Source block `docs/main.tex:187-193` is untouched — the flip is a pdftotext position artifact caused by the ~49pt upward shift from the career-break deletion. Deferred to Phase 3 by orchestrator judgment.

**Verdict: the deferral is SOUND.** Five independent grounds, each measured this session:

1. **The defect class is pre-existing, not introduced.** Extracting the pre-phase artifact shows title→date→**employer** was *already* the order for **all five** role blocks: `ADOBE FIREFLY` (title 5, date 7, employer 9), `SWIGGY` (36/38/40), `FLIPKART` (54/56/58), `GROUPON` (70/72/74), `NETSPEED` (79/81/83). Phase 1 shipped green-with-WARN on exactly this. Phase 2 did not create employer-late extraction; it moved one block one notch further inside an already-accepted class.
2. **The delta is one span unit, and the harness reports it.** `G6.13 WARN` prints FLIPKART at **span 5** against the other four at **span 4**. It is a non-gating WARN, so it did not block — but it is *not* invisible, which materially softens the review's "landed silently" framing.
3. **Nothing in Phase 2's contract depends on it.** No ROADMAP Phase-2 criterion, no plan must_have truth, and no requirement (EXP-01/05/06) asserts Work-Experience employer ordering. D-07's actual guarantee — employer strings byte-identical and whole-line — holds: `G5.5` 5/5 PASS.
4. **No Phase-1 criterion regressed.** Phase 1's geometry hash is unchanged, its 5-FAIL arrival state reproduced exactly, and its criteria 1–5 all still hold on this artifact.
5. **Fixing now would be re-litigated immediately.** Phase 3's Adobe rebuild shifts every block's y-position again, so any ordering fix landed now is unverifiable until after that shift. The reviewer's own preferred remedy (generalize `region_first_nonempty` to Work Experience rows) is a harness extension, legitimately Phase-3 work.

**Carry-forward obligation (must not be dropped):** `G6.13`'s owner field literally reads `owner: unassigned`, and neither SUMMARY mentions the flip — only `02-REVIEW.md` does. Phase 3's context must claim `G6.13` ownership and record the wobble, or the deferral decays into an untracked WARN. This is a documentation obligation, not a code defect, and does not block phase closure.

## Deferred Items

None. No Phase-2 must-have is met only by a later phase; all 20 resolve inside this phase.

## Gaps Summary

**None.** The phase goal decomposes into three clauses, and each is machine-verified end to end:

1. *"The page-1 line budget every later phase spends actually exists"* — measured **50.4pt / 4.38–4.39 lines**, reproduced from both ends (pre-phase 764.3pt / +0.1pt headroom → post 713.9pt / +50.5pt). Earned by deleting content, not by relaxing a threshold: `PAGES`, `CEILING_PT`, `LINE_PT`, `PROBE_LINES`, `CAREER_BREAK_PT` and `baseline-frozen.txt` are all byte-untouched, and the geometry hash is identical to Phase 1's.
2. *"The three live text-layer defects are gone"* — the exact 5-FAIL set Phase 1 recorded (`G6.9`×3 masked literals, `G6.10` en-dash handle, `G6.12` Education parse order) reproduced on the pre-phase artifact and all now PASS. Critically, `G6.12` was made **stronger** (anchor-free) rather than weakened, and the negative control I re-ran proves it still fails on the old document.
3. *"`make verify` green for the first time"* — `make verify` exit 0, `bash scripts/verify-resume.sh` exit 0, 0 FAIL, and `make verify-selftest` exit 0 with 10/10 inverted controls still firing, so the green is a green gate rather than a disarmed one.

One WARNING is carried forward (WR-01) with the deferral assessed sound on measured evidence, plus two INFO-level precision notes: the must_have phrase "all five contact items still clickable" overstates by one (the phone was never a link, 4/4 links intact pre and post), and the "4.39 lines recovered" figure is `G3.2`'s printed headroom line-equivalent (4.391) where the strict delta is 4.383 — both source numbers are printed in ROADMAP:56, so the record is self-checking.

## Recommendations (non-blocking — no user decision required to close this phase)

Phase 2 is **not** a checkpoint phase (ROADMAP's Checkpoints table lists only Phase 3 / EXP-08 and Phase 4 / GH-03), both plans are `autonomous: true`, and neither carries a `<human-check>` block. Every clause of the goal is machine-assertable and was machine-asserted, so no human verification gate is required. Two items are worth carrying into Phase 3 regardless:

1. **Claim `G6.13` ownership in Phase 3's context** and record the FLIPKART wobble there (see WR-01 carry-forward). Consider generalizing `region_first_nonempty` into an employer-first assertion per Work Experience role once Phase 3's y-positions settle.
2. **Spend before freeing** (or atomically with) in Phase 3. Independently re-derived: the self-test probe is 5 × 11.5 = 57.5pt against 50.5pt of page-1 slack — **7.0pt of armed margin**. Pulling D-08's descriptor-recompression lever *before* spending would stop the probe overflowing, turn `G7.2` red, and tempt a raise of the raise-only `PROBE_LINES`.

A visual pass over the rendered PDF is optional rather than required here: the mechanical proxies for "does it still look right" all came back clean (0 Overfull, 0 Underfull, 0 LaTeX Warnings, `G3.4` 0 words outside the page box on 1177 positioned words), and Phase 3 re-renders page 1 anyway.

---

_Verified: 2026-08-22T13:05:00Z_
_Verifier: the agent (gsd-verifier) — adversarial, goal-backward. Every figure re-measured in-session; the pre-phase artifact was reconstructed from `65573ac` and the fresh-checkout claim reproduced via a real `git clone`._
