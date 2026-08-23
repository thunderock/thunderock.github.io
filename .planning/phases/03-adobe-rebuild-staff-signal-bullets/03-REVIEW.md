---
phase: 03-adobe-rebuild-staff-signal-bullets
reviewed: 2026-08-22T21:30:00-07:00
depth: standard
scope: 332fd5b..HEAD (shipped source files only)
files_reviewed: 4
files_reviewed_list:
  - scripts/verify-phase3-regressions.sh
  - Makefile
  - docs/verify/manifest.txt
  - docs/main.tex
findings:
  blocker: 0
  warning: 2
  note: 3
  total: 5
status: issues
---

# Phase 3: Code Review Report

**Reviewed:** 2026-08-22
**Depth:** standard (per-file analysis + evidence runs)
**Files Reviewed:** 4
**Status:** issues (0 BLOCKER / 2 WARNING / 3 NOTE)

## Evidence runs (all against the committed tree)

| Command | Exit | Observation |
|---|---|---|
| `bash scripts/verify-resume.sh` | 0 | harness green; G6.13 ×5 and G6.14 ×1 WARN (non-gating) |
| `bash scripts/verify-phase2-regressions.sh` | 0 | Phase-2 net green |
| `bash scripts/verify-phase3-regressions.sh` | 0 | 72 P3 assertions, 0 failures |
| `shellcheck -f gcc scripts/verify-phase3-regressions.sh` | 0 | clean (two deliberate SC2329 disables, documented) |

## Summary

The Phase-3 regression net is unusually well-defended: sentinel `-1` for unmeasurable
grep counts, no-pipe `while read` loops so `emit` mutations survive, `LC_ALL=C`
byte-exact matching on U+2013/U+00D7 needles, exit-2 vs exit-1 vocabulary kept
distinct, `mktemp` scratch with a signal-safe inline trap, and both text streams
(raw + squeezed) asserted so normalization can never manufacture a pass. No false-green
path was found: every helper's unmeasurable branch emits FAIL, `--gate-text` prints its
non-certifying disclaimer, and no Makefile recipe carries a waiver flag. Bash-3.2
portability holds (no arrays, no `local`, no `[[ ]]`, no case-converting expansions).

**Internal-tooling name scan (BLOCKER rule):** grep over Makefile, scripts/, docs/main.tex,
docs/verify/, index.html for workflow/planning tool names found none. The one hit,
"Google OCR API" in index.html, names Google's public OCR product inside a pre-existing
project description — not internal tooling, and index.html was not changed this phase.
References to `.planning/...` paths inside the net's comments follow the Phase-2 net's
established precedent (10 such references there) and name committed repo files, not tools.

**Single-file constraint (docs/main.tex):** the only `\input` is `\input{glyphtounicode}`
(line 15), a TeX-distribution file required for `\pdfgentounicode=1`; no local
`\input`/`\include` exists. Frozen strings (dates, employers, titles, geometry) are
untouched — confirmed by the harness's own green freeze gates. Promotion rule applied
correctly in the manifest: A100, H100, torch.compile, Triton appended to
KEYWORDS_REQUIRED and removed from KEYWORDS_TARGET with `:phase` suffixes stripped,
verified by the net's four `assert_promoted` conjunction checks passing.

## Warnings

### WR-01: A Phase-2 net failure silences the entire Phase-3 census

**File:** `Makefile:196-199, 224-226` (`verify` and `verify-regressions` recipes)
**Issue:** Both targets chain `@bash $(REGRESS)` then `@bash $(REGRESS3)` as separate
recipe lines. GNU Make 3.81 aborts a recipe at its first failing line — the exact
behavior the Makefile's own comment block cites as the reason the nets are chained
*before* the harness. That same reasoning applies between the two nets and is not
handled: any P2.x FAIL (exit 1) means the 72-assertion P3 census never prints, so a
commit that regresses both phases reports only the Phase-2 half. Both scripts are
aggregate-report designs (run everything, then summarize), and the chaining defeats
that property across the pair. Gating is unaffected — make still exits non-zero — the
loss is diagnostic completeness, which these scripts' headers treat as a design goal.
**Fix:** run both and aggregate without masking, e.g.:
```make
verify-regressions:
	@rc=0; bash $(REGRESS) || rc=1; bash $(REGRESS3) || rc=1; exit $$rc
```
This preserves "never `-` or `|| true`" (a failure still fails the target) while
letting both censuses print. Same pattern for the two net lines in `verify`.

### WR-02: G6.13's WARN owner points at a phase that closed without clearing it

**File:** `docs/verify/manifest.txt:60` (`WARN_OWNERS=...G6.13:3...`)
**Issue:** Commit 6d58396 (03-02) changed `G6.13:unassigned` to `G6.13:3`, claiming the
role-block-adjacency deviation for Phase 3. Phase 3 is now complete, and the live
harness run still emits five `G6.13 WARN ... (owner: Phase 3)` lines — every role block
including the rebuilt Adobe one. Per the manifest's own vocabulary an owner names who
will drive the WARN to zero; a pointer at a completed phase is now false, and every
future census reads as if an active phase owns work that no open plan carries.
`verify-resume.sh:1929` states "no requirement owns the fix", which is what
`unassigned` is defined to mean.
**Fix:** either revert to `G6.13:unassigned`, reassign to the future phase that will
change the role-header layout, or — if Phase 3's decision record accepts the adjacency
split as permanent — set the `none` sentinel and record that acceptance. An owner value
must not survive its phase's close-out with the WARN still firing.

## Notes

### NT-01: Dead helper with a comment that no longer matches reality

**File:** `scripts/verify-phase3-regressions.sh:312-323` (`assert_present_i`), also
`assert_whole_line_once` (380) and `region_line_of` (455)
**Issue:** All three are defined but have zero call sites (each carries a
`shellcheck disable=SC2329`). `assert_whole_line_once` and `region_line_of` honestly
document themselves as kept-from-template. `assert_present_i`'s comment, however,
says "First caller lands with Group 2 in the next commit of this plan" — Group 2
landed (lines 698-718) using inline `gcount -Fic` and never calls it, so the comment
now describes a plan that didn't happen.
**Fix:** update the comment to the kept-from-template wording its siblings use, or
delete the helper.

### NT-02: `region_first_nonempty`'s numeric guard misses the one-empty-operand case

**File:** `scripts/verify-phase3-regressions.sh:481-483`
**Issue:** The guard `case "$1$2" in ''|*[!0-9]*)` concatenates the operands, so
`$1=""`,`$2="4"` yields `"4"` — numeric — and slips past to `[ "" -lt 1 ]`, which
errors on stderr, and then to `sed -n ",4p"`, which also errors (no `2>/dev/null` on
line 487). The function still returns empty and the caller's unmeasurable branch fires,
so no wrong verdict is possible; the comment's claim that the guard handles an
anchor lookup that "can come back EMPTY" is only true when *both* operands are empty.
Currently unreachable: the sole caller (line 691) guards `SUB_AT` and passes `$((...))`
arithmetic results. Latent only — matters if the NT-02 "second caller" the comment
anticipates ever passes a single empty operand.
**Fix:** guard each operand separately: `case "$1" in ''|*[!0-9]*) return 0;; esac`
and the same for `$2`.

### NT-03: Rust carrier count is substring-based

**File:** `scripts/verify-phase3-regressions.sh:757` (`grep -Fo -- 'Rust'`)
**Issue:** `-F` occurrence counting matches `Rust` inside any longer token carrying
the capitalized stem (e.g. a hypothetical "Rusty", "TrustRust"). Today's document has
exactly the two genuine carriers, and the ≥2 threshold plus case-sensitivity make a
false PASS require a capitalized-mid-word coincidence — low risk, but the count is
documented as "occurrences" of the keyword when it is occurrences of the substring.
**Fix:** none required now; if a false carrier ever appears, switch to a
word-boundary-approximating count (e.g. `grep -oE '(^|[^[:alnum:]])Rust([^[:alnum:]]|$)'`
adapted to bash-3.2/BSD-grep constraints).

---

_Reviewed: 2026-08-22_
_Reviewer: gsd-code-reviewer_
_Depth: standard_
