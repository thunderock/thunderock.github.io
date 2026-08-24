---
phase: 04-page-2-restructure-github-presence
reviewed: 2026-08-24T02:29:21Z
depth: standard
files_reviewed: 5
files_reviewed_list:
  - scripts/verify-phase4-regressions.sh
  - scripts/verify-phase3-regressions.sh
  - Makefile
  - docs/verify/manifest.txt
  - docs/main.tex
findings:
  critical: 1
  warning: 1
  info: 3
  total: 5
status: resolved
resolved: 2026-08-23
---

# Phase 4: Code Review Report

**Reviewed:** 2026-08-24T02:29:21Z
**Depth:** standard
**Files Reviewed:** 5
**Status:** resolved (CR-01 + WR-01 fixed in `cb6b590`; see Resolution below)

## Summary

Reviewed the Phase-4 page-2 restructure and its gate wiring: the new
`scripts/verify-phase4-regressions.sh` page-2 content net, the Phase-3 net
reconciliation (here-doc loops expanded to explicit `assert_*` calls, 10 needles
flipped to `assert_absent`, H100 demoted), the `Makefile` REGRESS4 wiring, the
`EDU_INSTITUTION`/H100 manifest edits, and the `docs/main.tex` page-2 body.

Both nets run green against the committed PDF (P3: 72/72, P4: 38/38), the
`\resumeProjectHeading` count is exactly 3, and I verified against the base
commit `798c0fb` that the retirement/absence needles are **not** vacuous — the
cut-abstract clause (`In this work, we propose`), the seven retired project
names, the two GPAs, and the city string are all the exact literals that were
removed, so the anti-tautology posture holds. The reconciled Phase-3 assertions
map 1:1 onto the removed content and preserve the positional `P3.xx` ids. The
page-2 LaTeX is well-formed (escaped specials, valid `\href`, balanced math).

One real correctness defect stands out: the Education **city-absence** assertion
matches a multi-word phrase against the RAW extracted stream only, which I
demonstrated produces a **false PASS** when the phrase wraps across lines — the
exact failure mode the script's own header says the whitespace-squeezed stream
exists to prevent. A related but fail-safe (false-red) inconsistency affects
several page-2 present-checks.

## Critical Issues

### CR-01: City-regression absence check matches a multi-word phrase against the RAW stream only — demonstrated false-green

**File:** `scripts/verify-phase4-regressions.sh:393-395`
**Issue:**
P4.32 asserts the dropped city is absent:

```sh
assert_absent "PG2-03 Education city dropped from the institution cell (text layer)" \
    'Indiana University, Bloomington' "$GATE" \
    "The Bloomington city is back on the institution cell. ..."
```

`'Indiana University, Bloomington'` is a multi-word literal, but it is matched
against `$GATE` (the raw, form-feed-normalized stream) **only**. The script's own
header (lines 51-55, 258-268) states the load-bearing rule: *"Multi-word
literals are therefore matched against a whitespace-squeezed stream ... so a
multi-word literal that pdftotext broke across a wrap point still matches."* A
fixed-string search on the raw stream returns 0 for a phrase that `pdftotext`
wrapped at a space — so a real regression that reintroduces the city is reported
as **absent (PASS)** whenever the phrase happens to break across two extracted
lines. This is a gate passing when it should fail.

Reproduced against the committed artifact by feeding a fixture in which the
regressed city is present but wrapped:

```
# fixture: "...Indiana University,\nBloomington\n" appended to the real text layer
RESULT P4.32  PASS  ... 'Indiana University, Bloomington' is absent ... (count 0)   # WRONG — city IS present
# control: same string on one line
RESULT P4.32  FAIL  ... appears 1 time(s) ... want 0                                # correct
```

The sibling Phase-3 net does this correctly — its multi-word absence needle
`'3–8K images/sec on 32 GPUs'` is asserted against `$SQUEEZED`, and the
in-file abstract check (P4.22, same script, line 356-358) already uses
`$SQUEEZED`. Only this city check regressed to the raw stream.

**Fix:** assert the city absence against the squeezed stream (or, matching the
Phase-3 `10--50` pattern, against BOTH), so a wrap cannot hide the regression:

```sh
assert_absent "PG2-03 Education city dropped from the institution cell (whitespace-squeezed text layer)" \
    'Indiana University, Bloomington' "$SQUEEZED" \
    "The Bloomington city is back on the institution cell. D-06 renders 'Indiana University' city-free (manifest EDU_INSTITUTION synced, D-07)."
```

(Note: the realistic wrap probability for this short bold cell is low today, but
the failure mode is demonstrable and the fix is trivial; a future page-2 reflow —
which the header explicitly anticipates for Phase 5 — is exactly when it would
bite silently.)

## Warnings

### WR-01: Multi-word PRESENT checks asserted against the RAW stream — false-red risk on reflow

**File:** `scripts/verify-phase4-regressions.sh:349-351, 396-397, 413-414`
**Issue:**
Six present-checks match multi-word literals against `$GATE` (raw lines) instead
of `$SQUEEZED`, contradicting the same two-stream convention the header
documents:

- P4.17 `'first author'` (line 349)
- P4.18 `'NetSci 2023'` (line 350)
- P4.19 `'IC2S2 2023'` (line 351)
- P4.33 `'Indiana University'` (line 396-397)
- P4.37 `'INFO-I 606'` (line 413)
- P4.38 `'CSCI-B 555'` (line 414)

These pass today because each literal currently lands on a single extracted
line, but if `pdftotext` wraps any of them (e.g. `(INFO-I 606)` mid-bullet, or
`first author` at a sentence-end wrap) the `assert_present` returns 0 and the net
goes **red on a correct document** — the precise false-alarm the squeezed stream
exists to prevent, and precisely the situation the header warns about for the
Phase-5 page-2 Skills rebuild. This is fail-safe (red, not green), so it is a
robustness/maintainability defect rather than a correctness hole, but it should
be fixed to match the file's own stated rule.

**Fix:** move each multi-word present-check to `$SQUEEZED` (Phase-3 puts *all* of
its multi-word present needles on the squeezed stream; keep only the
whitespace-free tokens — `IUNI`, `TieML`, `Poster`, the URLs — on `$GATE`).

## Info

### IN-01: `assert_count` counts matching lines, not occurrences

**File:** `scripts/verify-phase4-regressions.sh:217-228, 411-412`
**Issue:** `assert_count` is built on `gcount -Fc`, and `grep -Fc` counts matching
*lines*. The Phase-3 net's `RUST_N` block (verify-phase3-regressions.sh:757-765)
deliberately switched to `grep -Fo | grep -c '.'` for exactly this reason. For
`'Teaching Assistant'` == 3 the two agree today (one occurrence per bullet, at
line starts), but if two occurrences ever rendered on one wrapped extracted line
the count would under-report and go red for a fabricated reason.
**Fix:** none required now; if `assert_count` is ever pointed at a needle that can
co-occur on one line, switch it to occurrence counting like the `RUST_N` path.

### IN-02: Page-2 net documents no negative controls, unlike its siblings

**File:** `scripts/verify-phase4-regressions.sh:30-60`
**Issue:** The Phase-2/Phase-3 nets carry an explicit NEGATIVE CONTROLS section
proving each assertion class is failable (anti-tautology). The Phase-4 net omits
it. I confirmed against `798c0fb` that every absence/retirement needle here is a
real removed literal (so none is vacuous today), but the failability record that
the repo's own Phase-1 rule mandates is not written down for this net.
**Fix:** add a NEGATIVE CONTROLS header block mirroring the siblings (the
`--gate-text` crafted-fixture recipe already works — it is how CR-01 was
reproduced).

### IN-03: `verify` / `verify-regressions` short-circuit on the first failing net

**File:** `Makefile:197-201, 231-234`
**Issue:** The recipes chain `@bash $(REGRESS)` → `$(REGRESS3)` → `$(REGRESS4)` →
`$(VERIFY)` as separate lines; GNU Make 3.81 aborts the recipe at the first
failing line, so a Phase-2 net failure prevents the Phase-3/Phase-4 nets from
running (and reporting their own regressions) in the same invocation. This is a
documented, deliberate tradeoff (the header block at lines 185-196 explains it),
noted here only so a reader is not surprised that a green Phase-4 net can be
masked by a red Phase-2 net. No fix required.

---

_Reviewed: 2026-08-24T02:29:21Z_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: standard_

---

## Resolution (2026-08-23)

All actionable findings addressed; every suite is green after the fix (P4 38/38, resume exit 0, P2 27, P3 72, self-test 10 G7/G8 / 0 SKIP; `bash -n` + shellcheck clean).

- **CR-01 (BLOCKER) — FIXED** (`cb6b590`): the city-absence check (P4.32) and six sibling multi-word present-checks (P4.17/18/19/33/37/38) now assert against `$SQUEEZED` instead of the raw `$GATE` stream. A crafted `--gate-text` fixture with the city wrapped across two lines (`Indiana University,` / `Bloomington`) — raw count 0, squeezed count 1 — now correctly makes **P4.32 FAIL (exit 1)**, closing the false-green. Single-token needles (the GPAs, `Poster`) correctly stay on `$GATE`.
- **WR-01 (WARNING) — FIXED** (`cb6b590`, same commit): the six present-checks moved to `$SQUEEZED`, so a page-2 reflow (the Phase-5 scenario the net's header anticipates) can no longer false-red them.
- **INFO — reviewed, no change:**
  - `assert_count` counts matching lines not occurrences: acceptable for the `Teaching Assistant == 3` D-05 guard because the three TA items render on separate extracted lines (verified); a future reflow joining two onto one line would need revisiting.
  - Phase-4 net has no standing negative-controls block: each assertion class instead carries a `--gate-text` failability control, verified failable at plan-check, verification, and again here — sufficient for a content net.
  - Makefile `verify` chain short-circuits on the first failing net: documented + intended (GNU Make 3.81 collapses exit codes); direct `bash scripts/verify-*.sh` invocation remains the oracle.

_Resolution by: Claude (orchestrator), 2026-08-23_
