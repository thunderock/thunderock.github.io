---
phase: 06-palette-site-sync
reviewed: 2026-08-24T00:00:00Z
depth: standard
files_reviewed: 6
files_reviewed_list:
  - scripts/build-palette-samples.sh
  - scripts/verify-site-regressions.sh
  - Makefile
  - index.html
  - docs/main.tex
  - .gitignore
findings:
  blocker: 0
  critical: 0
  warning: 1
  info: 2
  total: 3
status: issues_found
---

# Phase 6: Code Review Report

**Reviewed:** 2026-08-24
**Depth:** standard
**Files Reviewed:** 6
**Status:** issues_found

## Summary

Reviewed the Phase 6 (Palette & Site Sync) changes at standard depth with an
adversarial stance, verifying every claim by execution rather than inspection.
The two new bash scripts, the Makefile wiring, the public `index.html` resync,
and the single `accentlight` removal in `docs/main.tex` are, on the whole,
high quality. No BLOCKER-class defect was found. Evidence gathered:

- **`verify-site-regressions.sh` runs green** on the committed `index.html`
  (18/18 assertions PASS, exit 0), and **every assertion class is genuinely
  failable** — I re-ran all four documented negative controls with the exact
  non-ASCII bytes (en dash U+2013, multiplication sign U+00D7): retired figures
  reinserted → 4 FAIL; every absence class reinserted → 10 FAIL; `rollout`/
  `torch.compile` deleted → the corresponding presence FAIL; D-09 honesty terms
  inserted → 7 FAIL. Missing file → exit 2 (never a pass). The `--html`
  disclaimer prints. No assertion is a tautology or vacuous grep, and byte-exact
  `LC_ALL=C grep -F` is used throughout.
- **Needle false-substring audit:** all 12 absence needles count 0 against the
  committed file, and none substring-collide with legitimate content (checked
  `3.87`/`8.32` against the CDN integrity hashes — `.` is literal under `-F`, no
  collision). All 3 presence needles count exactly 1.
- **Makefile wiring is clean:** `REGRESS6` is chained into both `verify` (before
  the harness) and `verify-regressions` with a bare `@bash $(REGRESS6)` — no
  `-` prefix, no `|| true`, no `--html`. `make verify-regressions` exits 0 with
  all five nets green; a net failure propagates non-zero via make's normal
  recipe-abort semantics. (The three `|| true` occurrences are in `tex-deps`
  and `clean`, not the verify recipes.)
- **`index.html` structure is sound:** `<div>` 96/96 balanced, `<ul>` 10/10,
  real `<li>` 33/33 balanced (the raw `<li` grep over-counts by 5 `<link>`
  tags). The rewritten Adobe and Projects links are all well-formed
  (`rollout`, `graph_ml`, the `thunderock` more-link, the resume PDF download,
  LinkedIn double-dash). No retired throughput figure, career-break entry,
  GPA, city, pruned section, or retired grad-project title survives; no
  résumé-contradicting claim spotted.
- **`docs/main.tex` compiles cleanly** after the `accentlight` removal: a
  scratch `latexmk` build exits 0, produces exactly 2 pages, and logs no
  undefined-color error. No residual `accentlight` reference remains; the two
  live colors (`accent`, `accentdark`) are both still defined and used.

The findings below are robustness/coverage observations, not correctness
failures in the shipped artifact.

## Warnings

### WR-01: `build-palette-samples.sh` has no cleanup trap — scratch dirs and the summary temp file leak on error/interrupt

**File:** `scripts/build-palette-samples.sh:120, 174, 208, 213`
**Issue:** The script runs under `set -euo pipefail` and creates temporaries with
`mktemp` but installs **no `trap ... EXIT/INT/TERM`**. On the happy path each
`SCRATCH` dir is removed (line 174) and `SUMMARY_ACC` is removed (line 213), so
normal runs are clean. But on any abnormal exit the temporaries leak:

- A latexmk failure is handled (`return 1`) and deliberately keeps `SCRATCH` for
  inspection (documented). However, because `build_one` is called unguarded in
  the `all` loop, `set -e` then aborts the whole script **before** line 213, so
  `SUMMARY_ACC` leaks in `$TMPDIR`.
- Failures of the other unguarded commands inside `build_one` (`cp`, `pdfinfo`,
  the `measure` command substitution) similarly abort mid-function under `set -e`
  and leak the current `SCRATCH` dir — which by then holds a full 2-page LaTeX
  build tree, not a trivial file.
- A `Ctrl-C` during any of the four sequential LaTeX builds leaves the
  in-progress `SCRATCH` (and `SUMMARY_ACC`) behind with no cleanup.

Confirmed: `grep -nE 'trap ' scripts/build-palette-samples.sh` → no trap defined.

**Fix:** Track temporaries and clean them on exit, preserving the intentional
"keep scratch on latexmk failure" behavior by unregistering that specific dir:

```bash
_TMPS=""
cleanup() { for d in $_TMPS; do rm -rf "$d"; done; }
trap cleanup EXIT INT TERM

# on create:
SCRATCH="$(mktemp -d "${TMPDIR:-/tmp}/palette.XXXXXX")"; _TMPS="$_TMPS $SCRATCH"
# on the deliberate-retain path, drop it from the cleanup set instead of leaking silently:
#   _TMPS="${_TMPS/ $SCRATCH/}"   # keep for inspection, everything else still cleaned
```

## Info

### IN-01: Retired-latency needle `10–50×` is byte-exact only, with no broader backstop — an ASCII-reworded latency figure would false-pass

**File:** `scripts/verify-site-regressions.sh:265-267`
**Issue:** The throughput register is guarded at two granularities — the exact
retired string `3–8K images/sec` (S6.1) **and** the broad catch-all `images/sec`
(S6.14) plus `32 GPUs` (S6.15) — so a re-worded throughput figure is still
caught. The latency figure `10–50×` (S6.2) has only its single byte-exact form.
I verified that a reworded ASCII latency claim escapes: appending
`<li>10-50x faster image loading</li>` (ASCII hyphen + `x`, not U+2013/U+00D7)
to a fixture yields **0 FAIL** — no assertion catches it. This is a defensible
design tradeoff (D-08 targets the *specific* retired figures, and there is no
safe broad `×`/`x` needle over raw HTML), so it is recorded as INFO, not a
defect. If symmetric coverage is desired, consider a narrower backstop such as
`50×`/`faster image loading` — accepting that any broad latency needle risks a
false-fail on legitimate future phrasing.
**Fix:** Optional. Either accept the documented byte-exact scope, or add a
targeted secondary needle and record it (like `images/sec` was) in the header's
NEGATIVE CONTROLS block so the added class stays proven-failable.

### IN-02: `SUMMARY_ACC` append relies on `measure` always emitting the `>> PALETTE` line under `set -e`

**File:** `scripts/build-palette-samples.sh:169-171`
**Issue:** `printf '%s\n' "$MOUT" | grep '^>> PALETTE' >> "$SUMMARY_ACC"` runs
under `set -euo pipefail`. It is safe today only because `measure()`
unconditionally prints the `>> PALETTE ...` line, so the `grep` always matches
(exit 0). If a future edit to the `measure` heredoc ever suppressed that line on
some path, `grep` would exit 1 and — because this pipeline is not in a condition
— `set -e` + `pipefail` would abort the whole run mid-loop. It is a latent
fragility, not a current bug.
**Fix:** Make the append non-fatal and explicit, e.g.
`printf '%s\n' "$MOUT" | grep '^>> PALETTE' >> "$SUMMARY_ACC" || true`, or
extract the line without a pipeline that can fail the run.

---

_Reviewed: 2026-08-24_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: standard_
