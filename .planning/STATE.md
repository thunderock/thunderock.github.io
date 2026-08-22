---
gsd_state_version: 1.0
milestone: v1.0
milestone_name: Staff MLE Resume Optimization
status: executing
last_updated: "2026-08-22T18:42:25.556Z"
last_activity: 2026-08-22
progress:
  total_phases: 6
  completed_phases: 1
  total_plans: 5
  completed_plans: 4
  percent: 17
---

# Project State

## Current Position

Phase: 02 (Page-1 Budget & Text-Layer Defects) — EXECUTING
Plan: 2 of 2
Status: Ready to execute
Last activity: 2026-08-22

Progress: [████████░░] 80%

## Project Reference

See: .planning/PROJECT.md (updated 2026-08-21)

**Core value:** Resume passes ATS keyword screens for Staff MLE / inference-framework roles — every claim interview-defensible.
**Current focus:** Phase 02 — Page-1 Budget & Text-Layer Defects

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table. Affecting current work:

- [Roadmap]: Gate → budget → content ordering is forced by measurement, not preference — page 1 has 0.15pt slack and `make build` is silent on a 3-page overflow (exit 0, zero warnings)
- [Roadmap]: Phase 1 is **expected to FAIL** on today's committed PDF (5 live defects) — that is the harness working, not a regression
- [Roadmap]: Summary/headline section stays Out of Scope (user chose fold-only) despite the research recommending it — do not re-add during planning
- [Spike 002]: Projects section = `rollout` + `graph_ml` (Variant A); `random_walk` privatized during the build
- [Phase 1 / A1]: LinkedIn vanity handle is **`ashutosh--tiwari`** (two ASCII hyphens) — user-confirmed at the Plan 01-01 Task 1 checkpoint against a live probe (HTTP 200; LinkedIn canonical `og:url` = `ashutosh--tiwari`; the single-hyphen URL returned 999). This resolves Assumption A1 and **supersedes the single-hyphen literal `ashutosh-tiwari` in ROADMAP.md Phase 2 criterion 3** (cited in planning as ROADMAP:47; the literal actually sits at ROADMAP.md line 50) — that spelling is a roadmapping transcription error and a later verification pass must NOT correct `docs/verify/manifest.txt` backwards to it. `docs/verify/manifest.txt` therefore freezes `ashutosh--tiwari` in `CONTACT_LITERALS` and the EN DASH form `ashutosh–tiwari` (U+2013) in `FORBIDDEN_LITERAL`. **`docs/main.tex:134` needs NO Phase 2 `\href` correction** — its link target and anchor text already read `ashutosh--tiwari` correctly; the only Phase 2 (EXP-06) defect is that the rendered text layer emits the en dash because LaTeX converts the source `--`.
- [Phase 1 / 01-02]: The harness is now **red on arrival by design** — `bash scripts/verify-resume.sh` exits **1** with exactly **5** BLOCKER FAILs (`G6.9` x3 masked contact literals, `G6.10` en-dash handle, `G6.12` Education city-before-institution ordering), each message ending in an explicit `Owner: Phase 2` clause. A 6th BLOCKER appearing means the harness is wrong — investigate the assertion before touching `docs/`. Phase 2 turns it green by fixing EXP-06 plus the `\resumeSubheading` reorder at `docs/main.tex:240-242`, with **no change to the harness**.
- [Phase 1 / 01-02]: `G6.12`'s window clause measures **institution -> date in non-empty lines** (per the plan spec) and **PASSES** today (span 2 vs `EDU_BIND_WINDOW=3`); only the city-first ordering clause fails. `01-01-SUMMARY`'s "5 lines wide" framing measured city -> date in raw lines — a different metric. Do not "fix" the window check on the strength of that older framing.
- [Phase 1 / 01-02]: `G6.13`'s role-adjacency window is a **local constant** (`ROLE_BIND_WINDOW=3`), deliberately not a manifest key: no requirement owns the role-header fix, so the commit that promotes `G6.13` to a BLOCKER is the commit that should add the key. It gates on **raw** line span (4 today, reproducing the research's "three non-adjacent blocks"), not non-empty span (which reads 2 and would print a misleading "bound together").
- [Phase 1 / 01-02]: `section_region`'s **terminal-section EOF fallback** is load-bearing, not defensive. `TECHNICAL SKILLS` is the last `SECTIONS` entry, so a helper returning an empty range there would make `G6.14` count 0 rendered lines — under `SKILLS_MAX_LINES=3` — and report a silent false OK in place of today's real 4.
- [Phase 01]: Phase 1 is DONE by its own gate: make verify-selftest exits 0 with four G7 and five G8 PASS lines, make verify exits non-zero (2 -- GNU Make 3.81 collapses every failed recipe to 2) naming exactly the three Phase-2-owned defects, bash scripts/verify-resume.sh exits 1, and a drifted source is refused at exit 2. Every assertion class has now been observed FAILING as well as passing. — An assertion never observed failing is not a gate. G7 proves the +5-line probe premise numerically (build exit 0, zero warnings) before proving G1.1/G2.1 catch the resulting 3-page PDF; five G8 controls prove the honesty, geometry, staleness, glyph and keyword classes each fire on a broken input.
- [Phase 01]: G7.4 and G8.6 assert the working-tree state as a BEFORE/AFTER delta plus explicit tracked-input checksums, not absolute git status --porcelain emptiness. Absolute emptiness conflates "the self-test changed nothing" with "the caller had no edits in progress" and would false-positive in Phase 2, which legitimately dirties docs/main.tex and the rebuilt PDF. Any leak out of a scratch directory still FAILS the assertion, and both clauses fail closed without git. — The property under test is the self-test blast radius, not the developer tree state. The plan-level gate asserts tree cleanliness separately.
- [Phase 01]: make verify-baseline re-measures ONLY the observation-only manifest keys (P1_TOP_PT, P1_BOTTOM_WS_PT). PAGES, CEILING_PT, PAGE_SIZE and PAGE2_OPENS_WITH are measured and REPORTED with a loud failure line on divergence but never written, and the honesty freeze is refused without ALLOW_FROZEN_UPDATE=1 (and even then only its derivable geometry hash is regenerated, after a printed unified diff). Raising a gated threshold is a reviewed edit, never a regeneration. — A generator that raises a BLOCKER threshold to match a document that moved away from it deletes the gate exactly the way re-freezing a changed employment date defeats VERIFY-03.
- [Phase 01]: Negative-control source copies MUST keep the basename main.tex: the freshness record is looked up by source filename, so a renamed copy finds no .fdb_latexmk record, escalates to the L2 rebuild arbiter, and a comment appended after the document end comes back FRESH -- silently disarming the staleness control. This is the 01-01 "L1 strictly stronger than L2" finding applied. — G8.3 depends on taking the strictly-stronger L1 byte-md5 path; the L2 semantic arbiter cannot see a byte-only change.
- [Phase 02]: [Phase 2 / 02-01]: The measured page-1 budget freed by Phase 2 Plan 01 is **50.4pt / 4.39 lines** (G3.2 p1 headroom +0.1pt -> +50.5pt; deepest content bottom 764.3pt -> 713.9pt). Career-break removal contributed 48.9pt (4.26 lines, matching CAREER_BREAK_PT exactly); the Groupon/NetSpeed fold contributed only 1.5pt (0.13 lines) because both descriptors wrap to two rendered lines at their locked D-05/D-06 length, so the fold recovers the itemize topsep/itemsep overhead and zero rendered lines per role. This measured figure supersedes ROADMAP Phase 2 criterion 5's ">=12 lines" AND corrects D-08's "10-11 lines" prediction downward. Do not raise or lower a manifest threshold to match it, and do not shorten locked content to improve it -- D-08 designates the two descriptors as Phase 3's first re-compression lever. — D-08 mandates asserting the measured post-change value rather than a predicted one. Both the ROADMAP figure and D-08's own estimate assumed the fold would save rendered lines; at measured one-line capacity (137-141 chars) against 167/164-char descriptors it saves none.
- [Phase 02]: [Phase 2 / 02-01]: TRAP T-2 (`PROBE_LINES`) from 02-PATTERNS.md §5.5 **does not trigger** and Plan 02 must NOT raise `PROBE_LINES`. Verbatim: `RESULT G7.2  PASS  the probe PDF is 3 page(s), above the manifest PAGES=2 budget, so the +5 probe is a genuine overflow`. `make verify-selftest` exits 0 with G7.1-G7.4 and G8.1-G8.6 all PASS. The trap was predicated on freeing 10-11 lines (115-127pt); the actual 50.4pt sits below the +5-line probe's ~57.5pt, so the probe still overflows page 1 and the self-test still proves something. `PROBE_LINES` stays 5. The probe injection anchor also still resolves (begin=127 break=211 insert=207) after both fold blocks kept their item lists. — The plan predicted G7.2 might go red and assigned the remedy to Plan 02 Task 3. Measurement shows the premise was wrong, so raising PROBE_LINES now would weaken the anti-rot guard for no reason.
- [Phase 02]: [Phase 2 / 02-01]: `\resumeItem{\textit{...}}` inside a minimal `\resumeItemListStart`/`End` pair is the descriptor carrier for folded roles; `\resumeSubSubheading` was rejected on measurement. Its `{@{}l@{\extracolsep{\fill}}r@{}}` cells cannot line-break, and both locked descriptors (167 and 164 chars) exceed the measured 137-141-char one-line capacity, so it would have produced an overfull \hbox and words printed past the page edge (G3.4 FAIL). `\resumeItem` renders through `\small{\justifying}` and wraps: 0 Overfull \hbox in the log, G3.4 PASS with 0 words outside the page box. Two rendered lines per descriptor is the sanctioned outcome and was kept in preference to the line; both wrap points land at word boundaries with no LaTeX hyphenation, so every locked literal survives extraction. `\resumeSubSubheading` still has zero usages in the document. — D-04 asks for one italic descriptor; the only shape with proven extraction AND line-breaking is \resumeItem. Keeping the two-line wrap preserves all four D-06 module names and the full D-05 literal set, which the forbidden ladder rungs would have dissolved.
- [Phase 02]: [Phase 2 / 02-01]: `EXP-01` is **claimed by both** `02-01-PLAN.md` and `02-02-PLAN.md`, so Plan 01 marked only `EXP-05` and `EXP-06` complete in REQUIREMENTS.md and deliberately left `EXP-01` open. Plan 01 satisfies EXP-01's literal text (career-break entry gone from source and text layer; `Aug. 2021 - May 2023` still extracts once from Education), but D-09's Education parse-order fix -- the still-red `G6.12` -- is Plan 02's, and closing EXP-01 while that BLOCKER stands would misreport the phase. Plan 02 closes EXP-01. — A requirement shared across two plans completes when the last plan lands, not the first. G6.12 is still FAIL, so the checkbox would have been premature.

### Pending Todos

None yet.

### Blockers/Concerns

- [Requirements]: `REQUIREMENTS.md` stated "21 total" v1 requirements but enumerates **23** IDs (3 VERIFY + 8 EXP + 6 PG2 + 3 GH + 1 VIS + 2 SITE). Corrected to 23 during roadmap creation; all 23 are mapped.
- [Phase 3]: EXP-08 carries a hard user sign-off checkpoint on provisional cost/mentoring figures — cannot auto-advance past it
- [Phase 5]: `torch.compile` production config still needs one read to confirm CUDA graphs are not disabled (`max-autotune-no-cudagraphs` / `triton.cudagraphs=False` would invalidate the EXP-03 compiler bridge)

## Deferred Items

Items acknowledged and carried forward:

| Category | Item | Status | Deferred At |
|----------|------|--------|-------------|
| Credibility | CRED-01 upstream vLLM/SGLang PR | v2 backlog | Requirements |
| Credibility | CRED-02 live ATS scan (Jobscan/Lever/Greenhouse) | v2 backlog | Requirements |
| Credibility | CRED-03 LinkedIn profile rewrite | v2 backlog | Requirements |
| Portfolio | PORT-01 full site content refresh | v2 backlog | Requirements |

## Session Continuity

Last session: 2026-08-22T18:38:55.062Z
Stopped at: Completed 02-01-PLAN.md
Resume file: None

## Performance Metrics

| Phase | Plan | Duration | Notes |
|-------|------|----------|-------|
| 01 | 01 | 11 min | 3 tasks, 4 files |
| 01 | 02 | 22 min | 4 tasks, 1 file |
| 01 | 03 | 33 min | 3 tasks, 2 files |
| Phase 02 P01 | 6 min | 3 tasks | 5 files |
