---
phase: 04-page-2-restructure-github-presence
plan: 01
subsystem: resume
tags: [latex, pdf, resume, verify-gates, education, publications, projects]

requires:
  - phase: 03 (+ page-1 finalization 798c0fb)
    provides: frozen page-1 Experience block, the four-suite verification harness (verify-resume.sh, P2/P3 nets, verify-selftest), the EDU_* manifest keys and G6.12 ordering gate
provides:
  - Page-2 restructured docs/main.tex — Education institution-first (no GPAs, no IU city), Publications abstract cut + one fairness-aware contribution line, Research collapsed to one line, Selected Projects swapped to rollout + graph_ml
  - manifest EDU_INSTITUTION synced to "Indiana University" (D-07)
  - Rebuilt 2-page PDF (page 2 opening at PUBLICATIONS) with all four suites green
affects: [phase-5-skills (PG2-04/05/06 — C++/Cython graph_ml anchor, H100 needle-flip), phase-6-site-sync, 04-02 page-4 regression net]

actuals:
  tokens: 2070      # chars/4 over the realized source+manifest diff (17d4e61~1..572ff90)
  tasks: 3
  commits: 3

tech-stack:
  added: []
  patterns:
    - "Verbatim-draft LaTeX still needs a compile pass — escape special chars (\\_) in \\href display text before shipping"
    - "Gate-coupled edit (source + manifest needle) lands in one commit; needle follows the document, never weakens the assertion"

key-files:
  created:
    - .planning/phases/04-page-2-restructure-github-presence/04-01-SUMMARY.md
  modified:
    - docs/main.tex
    - docs/verify/manifest.txt
    - docs/AshutoshTiwari.pdf (+ .log/.fdb_latexmk/.aux/.fls/.out regenerated, ride in the source commits)

key-decisions:
  - "D-05 (owner override): Teaching left byte-unchanged (3 TA items) — an INTENTIONAL deviation from ROADMAP Phase-4 criterion 4 ('Teaching → one line'), not an oversight"
  - "Rule 1 auto-fix: escaped the underscore in the graph_ml display-link text so the spike Variant A block compiles; text layer still renders github.com/thunderock/graph_ml"
  - "EDU_INSTITUTION needle updated to follow the D-06 source edit in the SAME commit (D-07); G6.12 logic untouched"

patterns-established:
  - "Every task confirmed page-1 freeze via git diff 798c0fb -- docs/main.tex showing hunks only at/after the \\newpage boundary (line 213)"

requirements-completed: [PG2-01, PG2-02, PG2-03]

coverage:
  - id: D1
    description: "Education is institution-first, GPA-free, city-free on Indiana University; both date ranges retained; manifest EDU_INSTITUTION synced (D-06/D-07)"
    requirement: "PG2-03"
    verification:
      - kind: automated_ui
        ref: "bash scripts/verify-resume.sh :: G6.12 PASS (institution 'Indiana University' first non-empty EDU line); pdftotext: 3.87/4.0=0, 8.32/10.0=0, 'Indiana University, Bloomington'=0, both date ranges present"
        status: pass
    human_judgment: false
  - id: D2
    description: "Publications = first-author citation + venue links + Poster link + one fairness-aware-graph-ML contribution line; abstract paragraph gone (D-03)"
    requirement: "PG2-02"
    verification:
      - kind: automated_ui
        ref: "pdftotext squeezed: 'In this work, we propose'=0, 'fairness-aware graph representation learning'>=1, first author/NetSci 2023/IC2S2 2023/Poster each >=1"
        status: pass
    human_judgment: false
  - id: D3
    description: "Research collapsed to one \\resumeItem covering IUNI / paid RA / NLP-Lab TieML threads; per-item semester stamps dropped (D-04)"
    requirement: "PG2-03"
    verification:
      - kind: automated_ui
        ref: "source: exactly 1 \\resumeItem in Research list; pdftotext: IUNI/'User Intent as a Network'/TieML each >=1"
        status: pass
    human_judgment: false
  - id: D4
    description: "Selected Projects = exactly rollout + graph_ml (spike Variant A); seven grad entries gone; residual2vec_ not re-featured; C++/Cython present (D-01/D-02)"
    requirement: "PG2-01"
    verification:
      - kind: automated_ui
        ref: "pdftotext: rollout/graph_ml + both github.com/thunderock URLs + C++/Cython present; BiasNet/DeepFoodie/BlindNet/Continuous Dominant Set/Humana/AnalyticsVidhya/Bias Manifolds each=0; source \\resumeProjectHeading count=3 (preamble + 2 uses)"
        status: pass
    human_judgment: false
  - id: D5
    description: "Teaching left byte-unchanged by owner override (D-05) — intentional deviation from ROADMAP Phase-4 criterion 4"
    requirement: "PG2-03"
    verification:
      - kind: manual_procedural
        ref: "git diff 798c0fb -- docs/main.tex shows no hunk touching the Teaching section"
        status: pass
    human_judgment: true
    rationale: "Owner-scoped decision to keep three TA items rather than compress; deviates from a ROADMAP criterion, so surfaced for the owner to confirm the override still holds"

duration: 6min
completed: 2026-08-24
status: complete
---

# Phase 4 Plan 01: Page-2 Restructure Summary

**Page 2 of the LaTeX résumé leads with current click-through artifacts — Education is institution-first (GPAs/city dropped), the Publications abstract is replaced by one fairness-aware-graph-ML contribution line, Research is one line across all three threads, and Selected Projects is now exactly `rollout` + `graph_ml` — with page 1 byte-frozen at 798c0fb and all four verification suites green.**

## Performance

- **Duration:** 6 min
- **Started:** 2026-08-24T01:53:23Z
- **Completed:** 2026-08-24T01:59:29Z
- **Tasks:** 3
- **Files modified:** 8 (2 source: docs/main.tex, docs/verify/manifest.txt; 6 regenerated artifacts)

## Accomplishments
- **Education (D-06/D-07):** dropped both GPAs (`3.87/4.0`, `8.32/10.0`) and the `Bloomington` city; kept both date ranges; synced `EDU_INSTITUTION → Indiana University` in the same commit. G6.12 PASS institution-first.
- **Publications (D-03):** cut the abstract paragraph; kept the first-author NetSci/IC2S2 citation, venue links, and Poster link; added one fairness-aware-graph-ML contribution line.
- **Research (D-04):** collapsed three items into one `\resumeItem` (IUNI independent study, paid RA "User Intent as a Network", NLP-Lab TieML / fine-tuned-LLM work); dropped per-item semester stamps.
- **Selected Projects (D-01/D-02):** replaced all seven 2017–2022 grad-school entries with `rollout` + `graph_ml` (spike Variant A); `residual2vec_` not re-featured; no unverified perf numbers; `C++/Cython` (Phase-5 PG2-06 anchor) present.
- **Teaching (D-05, owner override):** left byte-unchanged — recorded as an intentional deviation from ROADMAP Phase-4 criterion 4.

## Page-2 headroom walk (G3.2, 11.5pt/line)
- Baseline: p2 **+53.5pt** (+4.65 lines)
- After Task 1 (Education): p2 **+53.5pt** (unchanged — line shortening, not removal)
- After Task 2 (Publications + Research): p2 **+129.2pt** (+11.23 lines)
- After Task 3 (Projects 7→2): p2 **+222.0pt** (+19.31 lines)

Net strongly negative on rendered lines, as D-09 predicted — zero fit risk; PDF stays 2 pages, page 2 still opens at PUBLICATIONS (G2.1 PASS).

## Four-suite green evidence (final gate)
- `bash scripts/verify-resume.sh` → **exit 0**, 0 FAIL/BLOCKER result lines; **G6.12 PASS** ("institution line 'Indiana University' … is the first non-empty line in the region, and date line … 2 non-empty line(s) away (window 3)"); **G0.3 PASS** (fresh — latexmk md5 present, `make clean` never run).
- `bash scripts/verify-phase2-regressions.sh` → **27** anchored `^RESULT P2\.[0-9]+ +PASS`.
- `bash scripts/verify-phase3-regressions.sh` → **72** anchored `^RESULT P3\.[0-9]+ +PASS`.
- `make verify-selftest` → **exit 0**, **10** G7/G8 PASS, **0** anchored SKIP.

## Page-1 freeze proof
`git diff 798c0fb -- docs/main.tex` hunk headers: `@@ -221`, `@@ -232`, `@@ -255`, `@@ -272` — every hunk at/after the `\newpage` boundary (line 213). No page-1 Experience line changed.

## Task Commits

1. **Task 1 (tracer): Education tighten + manifest EDU_INSTITUTION sync** — `17d4e61` (feat)
2. **Task 2: Publication trim + Research one-line compress** — `e6ebbcd` (feat)
3. **Task 3: Selected Projects 7→2 swap (rollout + graph_ml)** — `572ff90` (feat)

## Files Created/Modified
- `docs/main.tex` — page-2 body restructured (Education, Publications, Research, Selected Projects); page 1 byte-frozen.
- `docs/verify/manifest.txt` — `EDU_INSTITUTION` → `Indiana University` (D-07); no key added, no assertion logic changed.
- `docs/AshutoshTiwari.pdf` (+ `.log`/`.fdb_latexmk`/`.aux`/`.fls`/`.out`) — regenerated, ride in the source commits.

## Decisions Made
- **D-07 needle-follows-document:** the manifest `EDU_INSTITUTION` value was updated to match the trimmed source in the same commit as the D-06 edit — a needle update following the document, not gate-weakening. G6.12 assertion logic untouched.
- **D-05 owner override:** Teaching kept as three TA items (see Deviations).

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Escaped the underscore in the graph_ml display-link text**
- **Found during:** Task 3 (Selected Projects swap)
- **Issue:** The spike Variant A block, shipped verbatim, has `\underline{github.com/thunderock/graph_ml}` — the raw `_` in the `\href` *display* text is a math subscript in normal LaTeX, causing a fatal `! Missing $ inserted.` at compile time and producing no PDF. (The `_` in the first `\href` URL argument is fine — hyperref handles it; only the display text is normal text.)
- **Fix:** Escaped that one underscore to `graph\_ml` in the display text only. The rendered PDF text layer still extracts `github.com/thunderock/graph_ml`, so all acceptance-criteria text-layer needles still match.
- **Files modified:** docs/main.tex
- **Verification:** `make build` exit 0; pdftotext contains `github.com/thunderock/graph_ml` (=1) and `graph_ml` (=2); all four suites green.
- **Committed in:** `572ff90` (Task 3 commit)

### Intentional deviation (owner decision, not auto-fix)

**D-05: Teaching section left byte-unchanged.** ROADMAP Phase-4 criterion 4 says "Teaching renders as one line." The owner overrode this (04-CONTEXT D-05) to keep all three TA items. Recorded here as an intentional deviation so a later reader does not treat it as unfinished work.

---

**Total deviations:** 1 auto-fixed (1 bug), plus 1 recorded owner-override deviation.
**Impact on plan:** The auto-fix was required for the source to compile at all; it does not change rendered content or any acceptance needle. No scope creep.

## Issues Encountered
- The verbatim spike LaTeX did not compile as-is (unescaped `_`); resolved via the Rule 1 auto-fix above. No other issues.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Page 2 is restructured and green; PG2-01/02/03 satisfied and marked complete by this plan (last/only claiming plan).
- `rollout` + `graph_ml` now carry the `C++/Cython` anchor Phase 5 (PG2-06) references; the H100 needle-flip remains a Phase-5 obligation (KEYWORDS_TARGET, unchanged here).
- 04-02 will add the page-2 content regression net (`scripts/verify-phase4-regressions.sh`) guarding this restructure.
- Deferred (owner, resume-only): GH-01 (privatize `random_walk`), GH-02 (fix `rollout` README stale status) — recorded in 04-CONTEXT Deferred Ideas.

## Self-Check: PASSED
- SUMMARY file present; all three task commits (`17d4e61`, `e6ebbcd`, `572ff90`) exist in git; rebuilt PDF present.

---
*Phase: 04-page-2-restructure-github-presence*
*Completed: 2026-08-24*
