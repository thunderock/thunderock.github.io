---
gsd_state_version: 1.0
milestone: v1.0
milestone_name: Staff MLE Resume Optimization
status: planning
last_updated: "2026-08-22T17:07:21.479Z"
last_activity: 2026-08-22
progress:
  total_phases: 6
  completed_phases: 1
  total_plans: 3
  completed_plans: 3
  percent: 17
---

# Project State

## Current Position

Phase: 2
Plan: Not started
Status: Ready to plan
Last activity: 2026-08-22

Progress: [██████████] 100% of Phase 01's plans (milestone v1.0: 1 of 6 phases complete, 17%)

## Project Reference

See: .planning/PROJECT.md (updated 2026-08-21)

**Core value:** Resume passes ATS keyword screens for Staff MLE / inference-framework roles — every claim interview-defensible.
**Current focus:** Phase 2 — page 1 budget & text layer defects

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

Last session: 2026-08-22T17:07:21.473Z
Stopped at: Phase 2 context gathered
Resume file: .planning/phases/02-page-1-budget-text-layer-defects/02-CONTEXT.md

## Performance Metrics

| Phase | Plan | Duration | Notes |
|-------|------|----------|-------|
| 01 | 01 | 11 min | 3 tasks, 4 files |
| 01 | 02 | 22 min | 4 tasks, 1 file |
| 01 | 03 | 33 min | 3 tasks, 2 files |
