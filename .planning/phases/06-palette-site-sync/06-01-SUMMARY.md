---
phase: 06-palette-site-sync
plan: 01
subsystem: ui
tags: [latex, xcolor, wcag, palette, accessibility, resume, grayscale]

# Dependency graph
requires:
  - phase: 03-content-honesty
    provides: "page-1 byte-freeze at 798c0fb and the verify-resume/P2-P5 regression nets the palette change must keep green"
provides:
  - "VIS-01 decided: teal palette kept (incumbent), the two hex literals unchanged"
  - "Dead accentlight color definition deleted — zero unused color definitions remain"
  - "scripts/build-palette-samples.sh — reusable sed+latexmk WCAG sample harness for all four candidate palettes"
  - "Measured WCAG contrast table for teal/navy/oxblood/graphite (color + BT.601 grayscale)"
affects: [palette, site-sync, future-color-changes]

actuals:
  tokens: 4200
  tasks: 4
  commits: 3

tech-stack:
  added: []
  patterns:
    - "sed+latexmk variant harness (per-jobname) to render palette samples without touching the tracked source"
    - "WCAG sRGB relative-luminance + BT.601 luma contrast computed from hex literals, never sampled from pixels"

key-files:
  created:
    - "scripts/build-palette-samples.sh (Task 1/2, committed f6ac1ad + 590202a)"
  modified:
    - "docs/main.tex — deleted \\definecolor{accentlight}; accent/accentdark unchanged"
    - "docs/AshutoshTiwari.pdf (+ .log/.fdb_latexmk) — regenerated in the same commit as the source edit"

key-decisions:
  - "User picked teal at the VIS-01 checkpoint (D-04): incumbent stays, a legitimate zero-challenger outcome per D-01"
  - "accentlight deleted regardless of the teal pick — D-03 requires zero unused color definitions (accentlight had 0 use sites)"

patterns-established:
  - "Palette apply is preamble-only: edit the two hex literals + delete accentlight; the 13 downstream color use sites re-color automatically"

requirements-completed: [VIS-01]

coverage:
  - id: D1
    description: "Four palette columns (teal/navy/oxblood/graphite) render the frozen resume as 2-page PDFs + grayscale, each measured against the fixed WCAG bar (text >=7:1, rule >=3:1, grayscale text >=4.5:1, rule >=3:1)"
    requirement: "VIS-01"
    verification:
      - kind: automated_ui
        ref: "bash scripts/build-palette-samples.sh all — all four VERDICT=PASS, each 2 pages"
        status: pass
    human_judgment: false
  - id: D2
    description: "User selects the shipping palette from the rendered samples (teal-stays is legitimate)"
    requirement: "VIS-01"
    verification:
      - kind: manual_procedural
        ref: "VIS-01 checkpoint:decision — user picked teal"
        status: pass
    human_judgment: true
    rationale: "Palette selection is an aesthetic judgment against real samples; the harness cannot decide it (D-04)"
  - id: D3
    description: "Chosen palette applied (teal = 2 hex literals unchanged) and dead accentlight definition deleted; verify-resume + P2-P5 nets stay green; page 1 byte-frozen"
    requirement: "VIS-01"
    verification:
      - kind: automated_ui
        ref: "bash scripts/verify-resume.sh (exit 0) + P2/P3/P4/P5 nets (exit 0) + page-1 text == 798c0fb"
        status: pass
    human_judgment: false

# Metrics
duration: ~8min (continuation)
completed: 2026-08-24
status: complete
---

# Phase 6 Plan 01: Palette Decision (VIS-01) Summary

**User chose the incumbent teal palette against the frozen resume; the dead `accentlight` color definition was deleted, driving unused color definitions to zero, with page 1 byte-frozen at 798c0fb and every regression net green.**

## Performance

- **Duration:** ~8 min (continuation agent, post-checkpoint)
- **Completed:** 2026-08-24
- **Tasks:** 4 (Tasks 1-2 in prior session, Task 3 checkpoint resolved by user, Task 4 here)
- **Files modified:** 4 (docs/main.tex + 3 regenerated artifacts) in Task 4

## Accomplishments

- **VIS-01 decided — teal stays.** All four columns clear the fixed WCAG bar; the three challengers are all higher-contrast than teal, which already clears every bar, so the burden of proof was on the challenger and the user affirmatively kept the incumbent (D-01 / D-04).
- **Dead `accentlight` definition deleted** (`\definecolor{accentlight}{HTML}{E4EFEC}`) — it had 0 use sites; D-03 requires zero unused color definitions. This landed regardless of the teal pick.
- **`accent` (#17685C) and `accentdark` (#0E463E) left byte-identical** — teal is a no-op on the two hex literals.
- **Preamble-only edit:** `git diff -U0 docs/main.tex` shows a single removed line and no page-1 hunk; page-1 text layer is identical to 798c0fb.

## Measured WCAG table (all four columns, from `scripts/build-palette-samples.sh all`)

| Palette | accent/accentdark | text vs white | rule vs white | grayscale text (BT.601) | grayscale rule | pages | verdict |
|---|---|---|---|---|---|---|---|
| **teal (chosen)** | #17685C / #0E463E | 10.69:1 | 6.62:1 | 12.45:1 | 8.32:1 | 2 | PASS |
| navy | #1F4E79 / #14345B | 12.56:1 | 8.66:1 | 13.39:1 | 9.59:1 | 2 | PASS |
| oxblood | #7B2D3B / #571F29 | 12.86:1 | 9.21:1 | 13.01:1 | 9.44:1 | 2 | PASS |
| graphite | #3E4A59 / #22303C | 13.50:1 | 9.02:1 | 13.77:1 | 9.15:1 | 2 | PASS |

Bar: text >=7:1, rule >=3:1, grayscale text >=4.5:1, grayscale rule >=3:1 (inclusive). All four PASS; teal is the lowest-contrast of the four but still well above every floor.

## Task Commits

1. **Task 1: Palette-sample WCAG harness, proven on navy** - `f6ac1ad` (feat) — prior session
2. **Task 2: Render + measure all four columns + summary table** - `590202a` (feat) — prior session
3. **Task 3: VIS-01 checkpoint:decision** - resolved by user: **teal** (no commit; a decision)
4. **Task 4: Apply teal + delete accentlight, keep harness green** - `9fbe245` (feat)

## Files Created/Modified

- `docs/main.tex` — removed the `accentlight` `\definecolor` line; accent/accentdark unchanged (teal)
- `docs/AshutoshTiwari.pdf`, `.log`, `.fdb_latexmk` — regenerated in commit `9fbe245` (rode with the source edit; `.aux`/`.fls`/`.out` were byte-unchanged by the preamble-only edit, per the Phase-2 precedent)

## Decisions Made

- **Teal kept (incumbent).** The user selected teal at the blocking VIS-01 `checkpoint:decision`. Recorded as an affirmative decision, not a skip.
- **accentlight deleted regardless of the pick** (D-03) — zero unused color definitions is a phase requirement independent of which palette ships.

## Deviations from Plan

None — plan executed exactly as written. Teal (both hex literals unchanged) is the plan's explicitly-anticipated zero-challenger branch; the accentlight deletion is the plan's common path.

## Issues Encountered / Known Env Caveat

- **Ghostscript grayscale color-conversion is broken in this environment.** `gs` is on PATH (`/usr/local/bin/gs`) but its `-sColorConversionStrategy=Gray` PDF path did not produce a usable true-grayscale PDF, so `scripts/build-palette-samples.sh` falls back to an ImageMagick 150dpi **raster** grayscale render for the visual preview (`build/palette/*-gray.pdf`). This is a preview-only caveat: the **numeric** grayscale WCAG contrast (BT.601 luma of each hex vs white) is computed deterministically from the hex literals regardless of the visual render, so the grayscale floors in the table above are fully measured, not eyeballed. No impact on the shipped resume (which is color).

## Verification

- `LC_ALL=C grep -c accentlight docs/main.tex` = **0**
- `\definecolor{accent}` and `\definecolor{accentdark}` both present at teal hex (#17685C / #0E463E)
- `git diff -U0 docs/main.tex` = single removed accentlight line, no page-1 hunk
- `bash scripts/verify-resume.sh` → **exit 0** (0 blocking failures)
- P2 (27) / P3 (72) / P4 (38) / P5 (25) regression nets → **all exit 0**
- Page-1 text layer **identical** to 798c0fb (`pdftotext -f 1 -l 1` diff clean)
- Regenerated PDF + aux ride in the same commit as the source edit (`9fbe245`)

## Next Phase Readiness

- VIS-01 complete; the palette question is settled (teal) for the milestone.
- Remaining Phase 06 plans (06-02, 06-03) cover the site-sync obligations (the `index.html` retired-figure duplicates + career-break timeline recorded in STATE.md by Phase 3). Those are independent of the palette decision.

## Self-Check: PASSED

- FOUND: docs/main.tex (accentlight count 0, accent/accentdark present)
- FOUND: docs/AshutoshTiwari.pdf regenerated
- FOUND: commit 9fbe245 (Task 4), f6ac1ad + 590202a (Tasks 1-2)

---
*Phase: 06-palette-site-sync*
*Completed: 2026-08-24*
