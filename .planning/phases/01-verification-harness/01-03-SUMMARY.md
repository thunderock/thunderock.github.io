---
phase: 01-verification-harness
plan: 03
subsystem: testing
tags: [bash, make, latexmk, poppler, pdfinfo, python3, negative-controls, self-test, verification-harness]

# Dependency graph
requires:
  - phase: 01-01
    provides: "RESULT contract, 0/1/2 exit vocabulary, manifest readers, --skip-freshness override, G0.1-G0.4 preconditions, honesty freeze, 28-key manifest"
  - phase: 01-02
    provides: "G1-G6 content assertions, glyph_census factored for --census, emit_row/emit_rows row protocol, geom_hash, FAILED_IDS summary, two negative-control recipes to model G8.1/G8.2 on"
provides:
  - "G7.1-G7.4: overflow self-test that proves its own premise (build exit 0, zero warnings) before proving the page gates fire, with a page-count anti-rot guard"
  - "G8.1-G8.5: five non-probe negative controls proving the honesty, geometry, staleness, glyph and keyword classes each fire when their input is broken"
  - "G8.6: blast-radius assertion for the control group (tracked inputs checksum-identical, no working-tree entry added)"
  - "--census wired to the shared glyph_census: exits 1 on any of G6.1-G6.3, reads no PDF and no source"
  - "--write-baseline: regenerates observation-only manifest keys, refuses to rewrite BLOCKER-gated thresholds, refuses the honesty freeze without ALLOW_FROZEN_UPDATE=1 plus a printed unified diff"
  - "make verify / verify-selftest / verify-baseline / poppler targets; check extended in place from five to eight dependency rows"
  - "Measured Make 3.81 exit-code collapse documented in the Makefile itself, with the 1-vs-2 distinction asserted at script level"
affects: [02-page1-budget, 03, 04, 05, 06]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Inverted acceptance: --selftest passes because verification FAILED on the probe and on every mutated input"
    - "Premise-then-gate ordering: G7.1 proves today's build accepts the injection silently, G7.2 proves the probe still overflows, only then G7.3 proves the gates catch it"
    - "Negative control = mutate ONE input on a mktemp -d copy, re-invoke the harness against the copy, assert the NAMED assertion ID reports FAIL; a control that does not fail is itself a BLOCKER failure"
    - "Probe scratch nested under $WORK, so the single guarded-removal path already covers every control directory"
    - "Baseline writer splits keys into re-measured (observation-only) vs preserved (BLOCKER-gated or policy); divergence on a gated key is reported loudly, never written"
    - "Blast-radius assertions (G7.4, G8.6) compare a before/after snapshot, so they measure what the harness changed rather than whether the caller's tree happened to be clean"

key-files:
  created: []
  modified:
    - scripts/verify-resume.sh
    - Makefile

key-decisions:
  - "G7.4 and G8.6 assert the working tree via a before/after porcelain comparison plus explicit tracked-input checksums, not absolute emptiness: absolute emptiness conflates 'the self-test changed nothing' with 'the caller had no edits in progress' and would false-positive during Phase 2, when docs/main.tex is legitimately dirty"
  - "--write-baseline re-measures only P1_TOP_PT and P1_BOTTOM_WS_PT. PAGES, CEILING_PT, PAGE_SIZE and PAGE2_OPENS_WITH are measured and REPORTED but never written, because a generator that raises a BLOCKER threshold to match a document that moved away from it deletes the gate exactly the way re-freezing a changed employment date defeats VERIFY-03"
  - "--write-baseline regenerates only the [geometry-sha256] value in the honesty freeze even with ALLOW_FROZEN_UPDATE=1; the 15 strings stay hand-authored by design"
  - "The G8 TEX copies keep the ORIGINAL basename: the freshness record is looked up by source filename, so a renamed copy would find no record, escalate to the L2 rebuild arbiter and come back FRESH -- G8.3 depends on taking the strictly-stronger L1 byte path (the 01-01 finding, applied)"
  - "G8.2's textheight mutation bumps whatever value is currently declared rather than hardcoding 1.2in -> 1.3in, so the control cannot silently no-op if a later phase changes the declaration"
  - "geom_hash relocated from the G4 section into the helper block so the baseline writer and the G4.1 gate share one implementation of the geometry rule"
  - "G8.6 emits on every run (PASS or FAIL) rather than only on failure, matching the harness rule that an assertion must be visible when clean"

patterns-established:
  - "Anti-rot guard before the gate assertion: a probe whose validity depends on the headroom the milestone is creating must assert its own overflow first"
  - "Every negative control names the assertion ID it expects to fail, and prints the mutation it made"
  - "Makefile records measured tool behaviour (Make 3.81 exit-code collapse) beside the target it constrains"

requirements-completed: [VERIFY-01, VERIFY-02, VERIFY-03]

# Metrics
duration: 33 min
completed: 2026-08-22
---

# Phase 01 Plan 03: Self-Test, Negative Controls and Make Integration Summary

**Every assertion class in the harness has now been observed failing as well as passing: a +5-line overflow probe that today's build accepts at exit 0 with zero warnings produces a 3-page PDF that trips G1.1 and G2.1, five non-probe controls each fire their named assertion, and `make verify` exits non-zero on the committed PDF while `bash scripts/verify-resume.sh` exits exactly 1.**

## Performance

- **Duration:** 33 min
- **Started:** 2026-08-22T06:02:00Z
- **Completed:** 2026-08-22T06:35:24Z
- **Tasks:** 3 (all `type="auto"`, no checkpoints)
- **Files modified:** 2 (`scripts/verify-resume.sh` 1306 → 1874 lines, `Makefile` 139 → 196 lines)
- **Self-test latency:** 13s wall (budget 20s) — six full harness invocations plus one 1.3s probe build

## Accomplishments

- **The gates are now proven, not asserted.** G7 demonstrates ROADMAP criterion 1's premise numerically (`latexmk` exit 0, **0** overfull/underfull warnings) and then demonstrates that verifying the resulting 3-page probe fails on **G1.1 and G2.1 specifically** — the distinction that separates "failed for the right reason" from "failed on the pre-existing en-dash defect".
- **The structural anchor resolved exactly where research measured it**: `begin=127 break=219 insert=215`. The `\newcommand` skip is load-bearing — the list-end token is first *defined* at `docs/main.tex:121`, above `\begin{document}`.
- **Five negative controls, five named failures.** One-byte date mutation → `G5.1 FAIL count=0`; `\textheight` 1.2in→1.3in → `G4.1 FAIL`; appended-comment drift → **exit 2** with `RESULT G0.3 FAIL`; ligature + private-use + replacement-character fixture → `G6.1`/`G6.2`/`G6.3 FAIL`; synthetic absent keyword → `G6.5 FAIL` naming the token.
- **The exit-1 / exit-2 vocabulary survives Make.** `make verify` exits **2** (GNU Make 3.81 collapses any failed recipe to 2, measured both ways), so the document-wrong code is asserted at script level (**1**) and the refuse-to-verify code by the unflagged staleness control (**2**). Both codes are exercised on every self-test run.
- **The override is contained.** `--skip-freshness` appears 9× in the script and **0×** in the `Makefile`; every run carrying it prints `RESULT G0.3 SKIP`; G8.3 deliberately omits it so the unflagged refusal path stays continuously exercised.
- **The highest-consequence risk is guarded twice.** `--write-baseline` leaves `baseline-frozen.txt` byte-identical without `ALLOW_FROZEN_UPDATE=1`, and *with* the variable regenerates only the derivable geometry hash after printing a unified diff. It is also manifest-idempotent: `diff -u` reports no differences on an unchanged document.
- **Zero blast radius.** The committed PDF is byte-identical (`123d02e3…60d1`) before and after every run; `docs/verify/baseline-frozen.txt`, `docs/verify/manifest.txt` and `docs/main.tex` are checksum-identical after `--selftest`; `git status --porcelain` is empty.

## Task Commits

1. **Task 1: The overflow self-test — probe injector and G7.1 through G7.4** — `9290eeb` (feat)
2. **Task 2: Negative controls for the honesty, geometry, staleness, glyph and keyword classes** — `1b80416` (feat)
3. **Task 3: Makefile integration and the baseline regeneration guard** — `5692bd2` (feat)

## Files Created/Modified

- `scripts/verify-resume.sh` — 1306 → 1874 lines, mode 100755 unchanged. `--selftest`, `--census` and `--write-baseline` all replaced their Plan 01 stubs; `geom_hash` moved into the helper block; new `p1_headroom` helper feeds the G7.2 rot-guard remedy.
- `Makefile` — 139 → 196 lines. `VERIFY` variable, `Verification` section with three targets, `poppler` install target, `check` extended in place, `.PHONY` and `install` appended to, help widened to `%-16s`, header doc-block re-padded with three new rows, explanatory comments above `verify` and `clean`.

## `make verify-selftest` — exit 0

```
RESULT G0.1   PASS  pdfinfo, pdftotext and python3 present
RESULT G0.2   PASS  artifacts present and non-empty: docs/AshutoshTiwari.pdf, docs/main.tex, docs/verify/manifest.txt, docs/verify/baseline-frozen.txt
RESULT G0.3   PASS  PDF provably built from current main.tex (latexmk md5 729318505f45209be4838bdff42044c4)
RESULT G0.4   INFO  mtimes identical (pdf=1787351282 tex=1787351282) -- newer-than is indeterminate, as expected after a checkout; not gated
RESULT G7.1   PASS  the build accepts +5 injected line(s) silently: latexmk exit code 0 with 0 overfull/underfull warning(s) (begin=127 break=219 insert=215)
RESULT G7.2   PASS  the probe PDF is 3 page(s), above the manifest PAGES=2 budget, so the +5 probe is a genuine overflow
RESULT G7.3   PASS  verifying the probe fails on the right gates: exit 1 with G1.1 FAIL x1 (page count) and G2.1 FAIL x1 (page-1 boundary)
RESULT G7.4   PASS  docs/AshutoshTiwari.pdf byte-unchanged (sha256 123d02e3...60d1) and git status --porcelain empty before and after the probe
RESULT G8.1   PASS  the honesty freeze fires on a one-byte date change: 'Jul. 2024 – Present' -> 'Jul. 3024 – Present' produced RESULT G5.1 FAIL with count=0
RESULT G8.2   PASS  the geometry freeze fires on margin drift: textheight 1.2in -> 1.3in produced RESULT G4.1 FAIL (reached through --skip-freshness, which G0.3 reported as SKIP)
RESULT G8.3   PASS  a drifted source is REFUSED rather than reported wrong: exit code 2 with RESULT G0.3 FAIL x1, machine-readable and distinct from the exit code 1 that means the document is wrong
RESULT G8.4   PASS  all three glyph classes fire on a corrupted text fixture: G6.1 (ligature), G6.2 (private-use) and G6.3 (replacement character) all FAIL, census exit code 1
RESULT G8.5   PASS  a required keyword that is absent from the text layer fires: RESULT G6.5 FAIL names 'ZZSELFTESTKEYWORDABSENTBYCONSTRUCTION'
RESULT G8.6   PASS  every control ran on a scratch copy: docs/verify/baseline-frozen.txt, docs/verify/manifest.txt and docs/main.tex are checksum-identical and the controls added no git status --porcelain entry
>> Probe: +5 line(s) injected at begin=127 break=219 insert=215 in a scratch copy, built with jobname=probe.
>> Controls: each assertion class observed FAILING as well as passing -- G8.1/G5.1 G8.2/G4.1 G8.3/G0.3-exit2 G8.4/G6.1-3 G8.5/G6.5.
>> Self-test acceptance is INVERTED: it passes because verification FAILED on the probe and on every mutated input.
>> PASS: the gates fire. 0 blocking failures in the self-test.
```

## `make verify` — exit 2 (recipe returned 1)

The five BLOCKER FAIL lines, unchanged from Plan 02 and each naming Phase 2:

```
RESULT G6.9   FAIL  contact literal missing from the text layer: 'ashutosh--tiwari' (0 occurrences) -- ... Owner: Phase 2 / EXP-06
RESULT G6.9   FAIL  contact literal missing from the text layer: 'github.com/thunderock' (0 occurrences) -- ... Owner: Phase 2 / EXP-06
RESULT G6.9   FAIL  contact literal missing from the text layer: 'thunderock.github.io' (0 occurrences) -- ... Owner: Phase 2 / EXP-06
RESULT G6.10  FAIL  corrupted handle present in the text layer: 'ashutosh–tiwari' on 1 line(s) (U+2013 EN DASH) -- ... Owner: Phase 2 / EXP-06
RESULT G6.12  FAIL  Education binding broken inside the 'EDUCATION' region (gate lines 100-113) -- ordering: the city line ... Owner: Phase 2 (EXP-01 already edits Education; re-asserted by Phase 4 / PG2-03)
!! FAIL: 5 blocking failure(s) in: G6.9 G6.10 G6.12
!! The document is wrong. Every RESULT ... FAIL line above names its fix owner.
make: *** [verify] Error 1
```

`grep -E 'RESULT G[0-9.]+ +FAIL' | grep -cvE 'G6\.(9|10|12)'` → **0**. No BLOCKER other than the three Phase-2-owned defects. Script-level exit code: **1**.

## `make check` — eight dependency rows

```
Checking build dependencies on Darwin...
  brew     : Homebrew 6.0.18-119-g2e0a0a5
  pdflatex : pdfTeX 3.141592653-2.6-1.40.27 (TeX Live 2025)
  latexmk  : Latexmk, John Collins, 27 Dec. 2024. Version 4.86a
  tlmgr    : ok (/Library/TeX/texbin/tlmgr)
  source-sans-pro: ok
  pdfinfo  : pdfinfo version 26.08.0
  pdftotext: pdftotext version 26.08.0
  python3  : Python 3.11.12
```

All five original rows intact, `check` declared once (`grep -c '^check:'` → 1), zero `overriding recipe` warnings.

## Committed PDF checksums

| When | sha256 |
|---|---|
| Before `make verify-selftest` | `123d02e32403db204252419097e718cdb1d8dbd24e83658afa3f25f5b4ef60d1` |
| After `make verify-selftest` | `123d02e32403db204252419097e718cdb1d8dbd24e83658afa3f25f5b4ef60d1` |

Identical. `make clean` was never run (it deletes tracked aux files and would force a rebuild that rewrites the committed PDF); its non-extension was verified statically.

## Decisions Made

See frontmatter `key-decisions`. The three a later phase must not silently reverse:

1. **G7.4 / G8.6 compare a before/after snapshot rather than asserting absolute tree emptiness.** The property under test is "the self-test changed nothing". Asserting emptiness would make `make verify-selftest` fail during Phase 2, when `docs/main.tex` and the rebuilt PDF are legitimately dirty — a false positive on the *caller's* state, not the harness's. The tracked-input checksum clause in G8.6 covers threat T-01-08 directly, and the plan-level gate asserts tree cleanliness separately.
2. **`--write-baseline` never rewrites a BLOCKER-gated threshold.** `PAGES`, `CEILING_PT`, `PAGE_SIZE` and `PAGE2_OPENS_WITH` are measured, compared, and reported with a `!!` line if they diverge. Verified by mutating a manifest copy to `PAGES=3`: the writer refused it and said why, while still correcting the observation-only `P1_TOP_PT`.
3. **The G8 source copies must keep the basename `main.tex`.** This is the 01-01 "L1 strictly stronger than L2" finding applied: a renamed copy finds no `.fdb_latexmk` record, escalates to the L2 rebuild arbiter, and a comment appended after `\end{document}` comes back **FRESH** — silently disarming G8.3.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Correctness] G7.4 and G8.6 assert a tree-state delta, not absolute porcelain emptiness**

- **Found during:** Task 1 (G7.4 implementation)
- **Issue:** The plan specifies G7.4 should assert `git status --porcelain` "produces no output". Implemented literally, the assertion measures the *caller's* working-tree state rather than the self-test's blast radius: it fails whenever any unrelated edit is in progress (including this plan's own in-flight edit to `scripts/verify-resume.sh`), and it will fail spuriously in Phase 2, which legitimately modifies `docs/main.tex` and rebuilds the PDF.
- **Fix:** Both clauses now compare a porcelain snapshot captured before the probe against one captured after, and G8.6 adds an explicit `shasum -a 256` comparison of the three tracked inputs the controls copy. Any leak out of a scratch directory still fails the assertion; a pre-existing modification is reported in the PASS message rather than misattributed. The message states the distinction verbatim so no reader mistakes it for a weakened check. Both assertions fail closed when git is unavailable.
- **Files modified:** `scripts/verify-resume.sh`
- **Verification:** With a clean tree, G7.4 prints "git status --porcelain empty before and after the probe" and the plan's `test -z "$(git status --porcelain)"` criterion passes independently. The plan-level gate step 6 and both tasks' `<verify>` blocks were re-run green after each commit.
- **Committed in:** `9290eeb` (Task 1), `1b80416` (Task 2)

**2. [Rule 3 - Blocking] `geom_hash` relocated so the baseline writer and the G4.1 gate share one implementation**

- **Found during:** Task 3 (`--write-baseline` implementation)
- **Issue:** `--write-baseline` needs the geometry hash to decide whether the honesty freeze would change, but `geom_hash` was defined inside the G4 section — below the mode short-circuits, so the function does not exist when the writer runs. The alternatives were to duplicate the hash rule (two implementations that can drift apart, which is precisely how a writer and a gate stop agreeing) or to move the mode block below the content assertions (which would make `--write-baseline` pay for every extraction it deliberately skips).
- **Fix:** Moved the `geom_hash` definition into the helper block beside `frozen_section`, with a comment at both the new and the old location recording why. This continues the pattern 01-02 established for `glyph_census`.
- **Files modified:** `scripts/verify-resume.sh`
- **Verification:** `bash scripts/verify-resume.sh` still emits `RESULT G4.1 PASS` naming the frozen hash `8b13a46b…5a56`; the G8.2 drift control still produces `G4.1 FAIL`; `--write-baseline` reads the same value.
- **Committed in:** `5692bd2`

**3. [Rule 1 - Correctness] G8.2 bumps the declared `\textheight` value instead of hardcoding `1.2in` → `1.3in`**

- **Found during:** Task 2
- **Issue:** A literal `sed 's/1.2in/1.3in/'` silently produces an *unmutated* copy once a later phase changes the declaration, turning the geometry control into a no-op that reports PASS.
- **Fix:** The control parses the current `\addtolength{\textheight}{…in}` value and writes it back incremented by 0.1, exiting loudly if the declaration is absent. Today that is exactly `1.2in → 1.3in`, which the message prints.
- **Files modified:** `scripts/verify-resume.sh`
- **Verification:** `RESULT G8.2 PASS … textheight 1.2in -> 1.3in produced RESULT G4.1 FAIL`; the plan's standalone literal-`sed` criterion also passes independently.
- **Committed in:** `1b80416`

**4. [Rule 2 - Missing critical] G8.6 added: blast-radius assertion for the control group**

- **Found during:** Task 2
- **Issue:** The plan requires "after all controls, assert once more that `git status --porcelain` is empty" but assigns no assertion ID, so the check would have been invisible on a passing run — contrary to the harness's own rule that an assertion must report when clean.
- **Fix:** Added `G8.6`, emitted on every self-test run, with two clauses: the three tracked inputs are checksum-identical, and the controls added no working-tree entry. It gates like any other BLOCKER. The `G8.1`–`G8.5` counting criteria are unaffected.
- **Files modified:** `scripts/verify-resume.sh`
- **Verification:** `grep -cE 'RESULT G8\.[1-5] +PASS'` returns 5 and `grep -cE 'RESULT G8\.[0-9] +FAIL'` returns 0 on the same output.
- **Committed in:** `1b80416`

**5. [Rule 1 - Bug] `--skip-freshness` removed from a Makefile comment**

- **Found during:** Task 3 acceptance gate
- **Issue:** A comment above the `verify` target *stated the rule* that no target may pass the freshness waiver — and in doing so contained the literal flag, tripping `LC_ALL=C grep -Fc -- '--skip-freshness' Makefile` returns 0. The criterion grants no comment exemption, and rightly so: a static grep is the whole containment mechanism.
- **Fix:** Reworded to name the flag only by description ("the one flag that can waive it … is named only inside the script").
- **Files modified:** `Makefile`
- **Verification:** `LC_ALL=C grep -Fc -- '--skip-freshness' Makefile` → 0; the script still carries it 9×; `bash scripts/verify-resume.sh --skip-freshness` still prints `RESULT G0.3 SKIP`.
- **Committed in:** `5692bd2`

**6. [Rule 2 - Missing critical] Header doc-block re-padded**

- **Found during:** Task 3
- **Issue:** The block aligns every description at one column. `make verify-selftest` and `make verify-baseline` are 20 characters wide against the block's 14-character field, so adding them at the existing column was impossible.
- **Fix:** Re-padded all eleven rows to a 20-character target field. Purely cosmetic; same convention, wider column — the same reason the plan bumps the help format to `%-16s`.
- **Files modified:** `Makefile`
- **Verification:** `grep -cE '^#   make verify' Makefile` → 3; `make help` output aligned.
- **Committed in:** `5692bd2`

---

**Total deviations:** 6 auto-fixed (3 × Rule 1 correctness/bug, 2 × Rule 2 missing critical, 1 × Rule 3 blocking)
**Impact on plan:** No scope change, no assertion weakened, no criterion relaxed. Deviations 1 and 3 make two assertions *stronger* against future false positives; 2 removes a duplicate-implementation risk; 4 and 6 close gaps the plan left implicit; 5 restores a containment criterion the implementation itself had broken.

## Measured Values That Differ From the Research Table

| Item | Research | Measured this session | Consequence |
|---|---|---|---|
| Full suite latency | ≈1.6s (`make verify && make verify-selftest`) | **13s** wall for `make verify-selftest` alone | Within the plan's 20s budget. Research assumed one scratch build; the delivered self-test makes six full harness invocations (G7.3 plus four controls plus the census) and a probe build. Wall time is spawn-latency bound (0.45s user / 0.63s sys per plain run at ~40% CPU), not CPU bound. |
| Probe anchor | lines 127 / 219 / 215 | identical | The structural anchor is stable. |
| Probe result | exit 0, 0 warnings, 3 pages, ≈1.1s | exit 0, 0 warnings, 3 pages, ≈1.3s | Criterion 1's premise reproduced exactly. |
| `make verify` exit code | "non-zero" (corrected during planning) | **2** | Confirms the Make 3.81 collapse; the recipe returned 1. |

## Issues Encountered

None blocking. Two worth recording:

- **`shellcheck` still reports exactly one finding, `SC2329` on `cleanup`** ("function is never invoked" — it is, via `trap cleanup EXIT`). Confirmed pre-existing in Plan 02 and left alone per the scope boundary. No new findings from 568 added lines.
- **Self-test latency is spawn-bound, not algorithmic.** Four of the five G8 controls must run the real harness end-to-end to reach the assertion they validate, so the cost is inherent to using the production code path rather than a stubbed one. Noted rather than optimised: reducing it would mean giving the controls a cheaper path than the thing they are proving.

## Known Stubs

None. All three previously stubbed flags (`--selftest`, `--write-baseline`, `--census`) now perform real work, and the `G7.5` placeholder ID from Plan 01 is gone. Every one of the 50 assertion IDs in the harness performs a real measurement.

## Threat Flags

None. No new network endpoint, auth path, file-access pattern or schema at a trust boundary. The single new write path (`--write-baseline` → `docs/verify/`) is the one the plan's threat register anticipates as T-01-06 and is mitigated as specified: refuses the honesty freeze without `ALLOW_FROZEN_UPDATE=1`, prints a unified diff first, and stages through a sibling temp file so the move is a true atomic rename.

## User Setup Required

None — no external service configuration required. `make install` now installs Homebrew `poppler` (present at 26.08.0) so a clean machine can run the gate, and `make check` reports all three verification tools.

## Verification Evidence

All 10 plan-level `<verification>` steps and all 3 tasks' `<acceptance_criteria>` re-run green against a clean tree immediately before this summary. A consolidated re-check of the 30 scriptable criteria reported **PASS=30 FAIL=0**.

| Check | Result |
|---|---|
| `make verify-selftest; echo $?` | **0**, four `G7.[1-4] PASS` + five `G8.[1-5] PASS` |
| `make verify; echo $?` | **2** (non-zero, as ROADMAP criteria 1-4 word it) |
| `bash scripts/verify-resume.sh; echo $?` | **1** — the document-wrong code |
| Drifted `--tex`, no override | exit **2** with exactly one `RESULT G0.3 FAIL` |
| `make verify` FAIL lines | 5, all `G6.9`/`G6.10`/`G6.12`, all naming Phase 2 |
| Non-named BLOCKER FAILs | 0 |
| `git status --porcelain` after every run above | empty |
| `docs/AshutoshTiwari.pdf` sha256 before/after | identical |
| `make check` | 8 rows; 5 originals intact; 0 `overriding recipe` warnings |
| `make help` | `verify`, `verify-selftest`, `verify-baseline` listed and aligned (`%-16s`) |
| `bash scripts/verify-resume.sh --write-baseline` then `git diff --stat docs/verify/` | no change |
| `ALLOW_FROZEN_UPDATE=1 … --write-baseline` | prints `---`/`+++` unified-diff headers, writes nothing (hash unchanged) |
| Manifest idempotency (`diff -u`) | no differences |
| `--write-baseline` on a `PAGES=3` manifest copy | refused with a `!!` line naming G1.1; observation-only key still corrected |
| G8.3 inner run standalone | exit 2, one `RESULT G0.3 FAIL` |
| G8.2 inner run standalone (`--skip-freshness`) | `RESULT G4.1 FAIL`; without the flag exit 2 and **zero** `G4.1` lines |
| `--census` on a crafted fixture standalone | exit 1, three `G6.(1\|2\|3) FAIL`, zero `G1`/`G4`/`G5` lines |
| `LC_ALL=C grep -Fc -- '--skip-freshness'` | script 9, `Makefile` **0** |
| `mktemp -d` occurrences in script | 11 (every control on its own scratch copy) |
| `LATEXMK_FLAGS` in script / content anchors in injector | 0 / 0 |
| `.gitignore`, `.github/workflows/jekyll.yml` | unchanged |
| `shellcheck` | 1 finding, pre-existing (`SC2329` on `cleanup`) |
| `make clean` | never run; non-extension verified statically |

## Self-Check: PASSED

- `scripts/verify-resume.sh` (1874 lines, mode 100755) and `Makefile` (196 lines) both present on disk
- Commits `9290eeb`, `1b80416`, `5692bd2` all present in `git log`
- All task acceptance criteria re-run: 13/13 (Task 1), 12/12 (Task 2), 18/18 (Task 3)
- Plan `<verification>` steps 1–10: all green
- `docs/` untouched; working tree clean; committed PDF byte-identical
- No `make clean`, no `git clean`, no `git stash`, no `eval`, no `source` of a manifest

## Next Phase Readiness

**Phase 1 is DONE by its own definition:** steps 1–4 of the plan's phase gate all hold. `make verify-selftest` exits 0, `make verify` exits non-zero naming exactly the three Phase-2-owned defects, `bash scripts/verify-resume.sh` exits 1, and a drifted source is refused at exit 2.

Phase 2 inherits a harness that is red on arrival and mechanically checkable:

- **Turn it green by fixing the document, never the harness.** EXP-06: make the anchor text the literal URLs and break the en-dash handle at `docs/main.tex:134`; then reorder the `\resumeSubheading` arguments at `docs/main.tex:240-242`. No harness change is required or expected.
- **`make verify` exiting 0 against today's committed PDF would mean the harness is wrong, not that the resume is right.** Likewise `bash scripts/verify-resume.sh` exiting 0. Anyone who "fixes" that in this phase has deleted the deliverable.
- **After the Groupon/NetSpeed fold, watch `RESULT G7.2`.** It is the guard against the self-test rotting into a no-op: if the fold frees more than the probe's ≈57.5pt without content being added back, G7.2 fails with the remedy (raise `PROBE_LINES` in the manifest) and the measured headroom.
- **Phase 2 will see a dirty `docs/`** while editing and rebuilding. `make verify-selftest` is designed to keep working there (see decision 1), but note that a rebuilt PDF changes the tracked aux files as well — commit them together.
- **`make verify-baseline` is for the observation keys only.** A `!!` line naming a gated key means the document moved away from its budget; that is a Phase 2/4 content decision, not a manifest edit.

Concern carried forward: none blocking. The `VERIFY-01/02/03` checkboxes in `REQUIREMENTS.md` are now substantively backed end-to-end — `make verify` exists, the gates are proven to fire, and each requirement has at least one negative control — which closes the bookkeeping caveat both prior summaries carried.

---
*Phase: 01-verification-harness*
*Completed: 2026-08-22*
