---
phase: 01-verification-harness
plan: 01
subsystem: testing
tags: [bash, pdftotext, poppler, latexmk, shellcheck-clean, verification-harness, ats]

# Dependency graph
requires: []
provides:
  - "docs/verify/baseline-frozen.txt — honesty freeze: 15 extracted-form strings (5 employment dates, 5 printed titles, 5 employers) + the geometry sha256"
  - "docs/verify/manifest.txt — 28 phase-mutable keys: page budget, section structure, scoped Education binding, geometry alternation, contact literals, text-layer rules, keyword tiers, WARN owners"
  - "scripts/verify-resume.sh — harness entrypoint: RESULT contract, 0/1/2 exit vocabulary, manifest readers, form-feed-normalized extraction, G0.1–G0.4 preconditions"
  - "Resolved Assumption A1: LinkedIn vanity handle frozen as ashutosh--tiwari (two ASCII hyphens)"
  - "$WORK/gate.txt and $WORK/raw.txt — the two text inputs every later content assertion reads"
affects: [01-02, 01-03, 02-page1-budget, 03, 04, 05]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Severity tiers (BLOCKER/WARN/INFO/SKIP) with printed owners read from manifest WARN_OWNERS — promotion, not suppression"
    - "Read-only verification: mktemp -d scratch, no build invocation, no timestamp mutation"
    - "Manifest as inert data: line-wise grep readers, never source/eval, values interpolated only inside quoted arguments"
    - "Two-file baseline split: hand-authored honesty freeze vs phase-mutable manifest (opposite update policies)"

key-files:
  created:
    - docs/verify/baseline-frozen.txt
    - docs/verify/manifest.txt
    - scripts/verify-resume.sh
  modified:
    - .planning/STATE.md

key-decisions:
  - "Assumption A1 resolved: LinkedIn handle is ashutosh--tiwari (two ASCII hyphens), user-confirmed against a live probe; ROADMAP Phase 2 criterion 3's single-hyphen literal is a superseded transcription error"
  - "docs/main.tex:134 needs NO Phase 2 \\href correction — the link target is already correct; the only Phase 2 defect is the rendered en dash"
  - "The .fdb_latexmk md5 lookup anchors on $1==\"\\\"main.tex\\\"\" (first field), never a match-anywhere, because the rule line's fourth field is the output filename"
  - "L1 (byte md5) is strictly stronger than L2 (semantic rebuild compare); L2 is escalation-only and correctly reports FRESH for a source edit that cannot change the rendered document"
  - "--skip-freshness is the sole override and is implemented fully (not stubbed) because it changes G0.3 control flow"

patterns-established:
  - "RESULT contract: printf 'RESULT %-6s %-5s %s\\n' — machine-first lines, human summary after"
  - "die2 emits no RESULT line, so any refusing assertion must emit its own result <id> FAIL first"
  - "Whole-line matching (grep -Fxc == 1) against form-feed-normalized text is the load-bearing matcher"

requirements-completed: [VERIFY-01, VERIFY-02, VERIFY-03]

# Metrics
duration: 11 min
completed: 2026-08-22
---

# Phase 01 Plan 01: Verification Harness Foundations Summary

**Three verification contracts stood up — a 15-string hand-authored honesty freeze, a 28-key mutable manifest, and a bash-3.2 harness whose G0 layer refuses to verify a stale artifact (exit 2) before asserting anything about content.**

## Performance

- **Duration:** 11 min
- **Started:** 2026-08-22T05:33:29Z
- **Completed:** 2026-08-22T05:44:24Z
- **Tasks:** 3 (1 checkpoint decision + 2 auto)
- **Files modified:** 4 (3 created, 1 modified)

## Accomplishments

- **Assumption A1 closed** — the HIGH-risk LinkedIn handle contradiction between `docs/main.tex:134`, `PITFALLS.md:481` and ROADMAP Phase 2 criterion 3 is resolved and recorded behind the `[Phase 1 / A1]` marker in STATE.md. `docs/main.tex` needs no Phase 2 `\href` fix.
- **Honesty freeze authored by hand** (not generated), 15 strings each verified as a unique whole line against the committed PDF's normalized extraction. The header pins the matcher because `Software Development Engineer` (Groupon) is a substring of the Flipkart title — measured `grep -Fc` = 2 vs `grep -Fxc` = 1.
- **Manifest encodes the promotion mechanism**, not an allowlist: 13 measured-present keywords in `KEYWORDS_REQUIRED`, 7 measured-absent in `KEYWORDS_TARGET` with `:owning-phase` suffixes, and a `WARN_OWNERS` entry for every WARN-tier assertion ID including the three sentinels (`none`, `unassigned`, `any`).
- **Harness refuses rather than lies** — a drifted source produces `RESULT G0.3 FAIL` *and* exit 2 (not 1), keeping "cannot verify" semantically distinct from "the document is wrong".
- **L2 scratch-rebuild arbiter implemented and both branches exercised** — escalation on an absent `.fdb_latexmk` record resolves FRESH in 1.05s (research predicted 1.11s) and STALE→exit 2 on real content drift.
- **Threat controls verified by execution, not assertion** — a manifest line carrying `; rm -rf …`, `$(id -u)` and a backticked `touch` was consumed as inert data (no marker file created, exit 0); a `--tex` path containing spaces did not word-split.

## Task Commits

1. **Task 1: Resolve the LinkedIn vanity handle** — `c0edda2` (docs)
2. **Task 2: Honesty freeze + mutable manifest** — `1b7e513` (feat)
3. **Task 3: Harness scaffolding, RESULT contract, G0 preconditions** — `8e17836` (feat)

Pre-task bookkeeping (phase-start STATE/config, committed separately so the Task 1 diff was verifiably Decisions-only): `39375d1` (chore)

## Files Created/Modified

- `docs/verify/baseline-frozen.txt` — 28 non-blank lines: 8-line provenance header + `[dates]`/`[titles]`/`[employers]`/`[geometry-sha256]`. No bullet text, no `Career Break` entry.
- `docs/verify/manifest.txt` — 28 keys across seven annotated groups. `PAGE2_OPENS_WITH=PUBLICATIONS` kept comment-free so it matches `grep -Fxc` exactly.
- `scripts/verify-resume.sh` — 418 lines, mode 100755. `set -uo pipefail` with errexit deliberately absent.
- `.planning/STATE.md` — one bullet added to Accumulated Context → Decisions.

## Decisions Made

### Assumption A1 — LinkedIn vanity handle (Task 1 checkpoint)

**Confirmed spelling: `ashutosh--tiwari` (two ASCII hyphens).** User-selected `double-hyphen`, corroborated by a live probe (HTTP 200; LinkedIn canonical `og:url` = `ashutosh--tiwari`; the single-hyphen URL returned 999).

Consequences recorded:
- `CONTACT_LITERALS` freezes `ashutosh--tiwari`; `FORBIDDEN_LITERAL` carries the EN DASH form `ashutosh–tiwari` (U+2013) currently in the PDF text layer.
- **ROADMAP Phase 2 criterion 3's single-hyphen literal is superseded** — a roadmapping transcription error. The plan cites it as `ROADMAP.md:47`; the literal actually sits at **line 50** (`:47` is the `**Success Criteria**` header). Recorded so a later pass does not correct the manifest backwards.
- **`docs/main.tex:134` needs no Phase 2 `\href` correction.** Both its link target and anchor text already read `ashutosh--tiwari`. The Phase 2 (EXP-06) defect is only that the *rendered text layer* emits an en dash, because LaTeX converts the source `--`.

### Freshness layering asymmetry (new finding, for Plan 03)

L1 (byte-level md5 vs latexmk's record) is **strictly stronger** than L2 (semantic rebuild compare). Measured: appending a line after `\end{document}` makes L1 FAIL (bytes changed) but L2 correctly report FRESH (the rendered document is identical). Consequence: after `make clean` deletes `.fdb_latexmk`, a no-op source edit passes G0.3 where it would have failed with the record present. This follows directly from research's L1-primary / L2-arbiter ranking and is not a defect — but Plan 03 should not assume the two layers are interchangeable.

## Deviations from Plan

None — plan executed exactly as written. Two self-inflicted acceptance-criteria failures were caught by the mandatory verification gate and fixed before commit; neither changed plan scope:

1. `baseline-frozen.txt` initially had a 10-line header, giving 30 non-blank lines against the criterion's `[20,28]` window. Condensed to 8 header lines → 28. Fixed pre-commit, inside Task 2.
2. The harness's own bash-3.2 compatibility *comment* literally contained `mapfile`, `readarray` and `${v^^}`, tripping the `declare -A|mapfile|readarray` criterion — which, unlike the errexit criterion, grants no comment exemption. Reworded to prose. Fixed pre-commit, inside Task 3.

---

**Total deviations:** 0. **Impact on plan:** none — no scope change, no criterion relaxed.

## Known Stubs

Three flags parse and exit 0 with a `RESULT … SKIP` line naming their implementing plan. All three are **explicitly authorized** by this plan's Task 3 action ("may parse and then exit 0 with a `RESULT` SKIP line naming the plan that implements them"); the argument surface exists now so Plans 02/03 need not restructure the entry path.

| Flag | Current behavior | Implemented by |
|------|------------------|----------------|
| `--selftest` | `RESULT G7.1 SKIP`, exit 0 | Plan 03 (G7.1–G7.4 probe build) |
| `--write-baseline` | `RESULT G7.5 SKIP`, exit 0 | Plan 03 (manifest regen + `ALLOW_FROZEN_UPDATE` guard) |
| `--census FILE` | validates FILE readable (else exit 2), `RESULT G6.1 SKIP`, exit 0 | Plan 03 (G6.1–G6.4 glyph gate) |

`--skip-freshness` is **not** a stub — fully implemented here, since it changes G0.3's control flow.

## Interface Notes for Plans 02 and 03

- **`gate.txt`, never `raw.txt`,** for any whole-line matcher. Confirmed this session: `grep -Fxc 'PUBLICATIONS'` returns 0 against `raw.txt` (the page-1 form feed is glued to the first page-2 token) and 1 against `gate.txt`. All 7 section headings verify as whole lines at `gate.txt` lines 4, 89, 99, 114, 127, 136, 170.
- **A G5 frozen-string loop must stop at `[geometry-sha256]`.** The naive skip pattern (`''|'#'*|'['*`) does not skip the hash *value* line, so an unscoped loop would grep the sha256 against the text layer and report a spurious FAIL. The frozen file's header records this; `[geometry-sha256]` belongs to G4.1.
- **Finding P2 reconfirmed:** `Indiana University, Bloomington` appears twice in the extraction — `gate.txt:31` (page-1 Career Break block) and `gate.txt:102` (Education). The Education binding must be scoped between the `EDUCATION` heading and the next `SECTIONS` heading. Measured order in that region: `EDUCATION`(99) → `Bloomington, IN`(100) → `Indiana University, Bloomington`(102) → `Aug. 2021 – May 2023`(105) — city-first and 5 lines wide against `EDU_BIND_WINDOW=3`, so G6.12 fails on both counts.
- **G6.6's per-keyword owner wins over the categorical `G6.6:3`.** `ONNX`, `Iceberg` and `Triton` are Phase 5; reading the categorical value would misattribute three of seven keywords.
- **`manifest_get` strips a trailing `# annotation`,** so `LINE_PT`, `CAREER_BREAK_PT`, `P1_BOTTOM_WS_PT`, `SKILLS_MAX_LINES` and `FORBIDDEN_LITERAL` carry inline comments safely. `PAGE2_OPENS_WITH` deliberately carries none.

## Issues Encountered

None. The `.fdb_latexmk` first-field anchoring trap the plan warned about was reproduced before implementing (a match-anywhere awk returns `"AshutoshTiwari.pdf"`, which would make G0.3 FAIL against pristine artifacts), so the `$1==` form was written correctly the first time.

### Bookkeeping caveat — VERIFY-01/02/03 marked Complete

This plan's frontmatter claims `requirements: [VERIFY-01, VERIFY-02, VERIFY-03]`, so the state tooling checked all three off in `REQUIREMENTS.md`. **Read that as "the harness these requirements live in is under construction", not "delivered."** Plan 01 built only the G0 precondition layer; each requirement is substantively satisfied later:

- **VERIFY-01** (page-count / page-1 boundary gate) → Plan 02, G1–G3
- **VERIFY-02** (ATS text-layer integrity) → Plan 02, G6
- **VERIFY-03** (honesty + geometry freeze) → freeze *authored* here; *asserted* by Plan 02, G4–G5

`make verify` does not exist yet (Plan 03 adds it). Flagging this explicitly because a "Complete" VERIFY-01 while no page-count assertion exists is precisely the false-green this phase was chartered to make impossible — a later audit should not read those checkboxes as end-to-end coverage.

Four cosmetic defects introduced by the state-tooling writes were corrected in the metadata commit (Rule 1): frontmatter `percent: 0` contradicting the rendered 33% bar, a 4-column Performance Metrics row shifted one cell left (`11 min` landed in the Plan column), a `last_activity` reduced to a bare date, and a stale `Stopped at` still naming roadmap creation.

## User Setup Required

None — no external service configuration required. The only external dependency is Homebrew `poppler` 26.08.0, already installed and probed by G0.1.

## Verification Evidence

All 6 plan-level `<verification>` steps and all task `<acceptance_criteria>` re-run green immediately before this summary:

| Check | Result |
|-------|--------|
| `bash scripts/verify-resume.sh` | exit 0, four G0 RESULT lines |
| `RESULT G0.3` on committed artifacts | `PASS … latexmk md5 729318505f45209be4838bdff42044c4` |
| Drifted `--tex` | exit 2 with exactly one `RESULT G0.3 FAIL` line + `make build` remedy |
| Same run + `--skip-freshness` | `RESULT G0.3 SKIP`, `RESULT G0.4 INFO` reached, exit 0 (not 2) |
| `PATH=/usr/bin:/bin` | exit 2 with `brew install poppler` |
| `--census` with nonexistent PDF/TEX | exit 0 — G0.2 skipped, not merely tolerated |
| `git status --porcelain docs/` after runs | empty |
| 15 frozen strings via `grep -Fxc` | 1 for each |
| Manifest metacharacter injection | inert; no marker file; exit 0 |

## Self-Check: PASSED

- `docs/verify/baseline-frozen.txt`, `docs/verify/manifest.txt`, `scripts/verify-resume.sh` all present on disk (`scripts/verify-resume.sh` mode 100755)
- Commits `c0edda2`, `1b7e513`, `8e17836` all present in `git log`
- All task acceptance criteria re-run: 6/6 (Task 1), 11/11 (Task 2), 18/18 (Task 3)
- Plan `<verification>` steps 1–6: all green
- `docs/` clean; no `make`/`touch` in command position; no `eval`/`source`

## Next Phase Readiness

Ready for `01-02`. Plans 02 and 03 have a frozen argument surface, both manifest readers, the `result`/`warn`/`info`/`die2` emitters, the `0/1/2` exit vocabulary, and `$WORK/gate.txt` as the documented whole-line matcher input.

Expected trajectory (unchanged): the harness exits **0** today because no content assertion exists yet. Plan 02 lands G1–G6 and the exit code flips to **1**, naming the three live defects (en-dash handle, zero literal URLs, Education parse order). Plan 03 asserts that inverted acceptance. **`make verify` exiting 0 against today's committed PDF would mean the harness is wrong, not that the resume is right.**

Concern carried forward: none blocking. `make verify` does not exist yet by design (Plan 03 adds it), and `--skip-freshness` must never appear in a Makefile target — Plan 03 asserts its absence statically.

---
*Phase: 01-verification-harness*
*Completed: 2026-08-22*
