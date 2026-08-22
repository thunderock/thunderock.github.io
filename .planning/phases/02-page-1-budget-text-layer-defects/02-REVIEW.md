---
phase: 02-page-1-budget-text-layer-defects
reviewed: 2026-08-22
depth: deep
files_reviewed: 6
files_reviewed_list:
  - docs/main.tex
  - scripts/verify-resume.sh
  - docs/verify/manifest.txt
  - docs/AshutoshTiwari.pdf
  - .planning/ROADMAP.md
  - .planning/REQUIREMENTS.md
findings:
  blockers: 0
  warnings: 1
  notes: 3
  total: 4
status: issues_found
---

# Phase 2: Code Review Report

**Reviewed:** 2026-08-22
**Depth:** deep (per-file + cross-file: harness↔manifest↔document, pre/post text-layer diff)
**Range:** 65573ac..HEAD (92f4891, 450a312, 933778e, 29999ff, 232abc2, 10be4ab)
**Status:** issues_found (0 BLOCKER / 1 WARNING / 3 NOTE)

## Ground Truth (run, not assumed)

| Check | Result |
|---|---|
| `bash scripts/verify-resume.sh` | exit **0**, `>> PASS: 0 blocking failures.`, 0 `RESULT ... FAIL` |
| `make verify-selftest` | exit **0**, G7.1–G7.4 + G8.1–G8.6 all PASS, G8.3 PASS (not SKIP) |
| G0.3 freshness | PASS (latexmk md5 `eff2ec04...`) — committed PDF provably built from committed source |

## Findings Table

| ID | Sev | File:Line | Issue |
|---|---|---|---|
| WR-01 | WARNING | docs/AshutoshTiwari.pdf (text layer, Flipkart block) | Undocumented extraction-order flip: FLIPKART employer line now extracts AFTER its subtitle line |
| NT-01 | NOTE | docs/verify/manifest.txt (`PROBE_LINES=5`) | 7.0pt guard margin imposes an ordering constraint on Phase 3 |
| NT-02 | NOTE | scripts/verify-resume.sh:406 | `region_first_nonempty` numeric-arg guard errors (harmlessly) on empty args |
| NT-03 | NOTE | docs/main.tex:199,207 | Descriptors are light editorial renderings of D-05/D-06, not byte-verbatim |

## Warnings

### WR-01: Flipkart employer/subtitle extraction-order flip — undocumented text-layer regression

**File:** `docs/AshutoshTiwari.pdf` text layer (pdftotext of HEAD vs 65573ac, old lines 58–59 vs new lines 52–53). Source block `docs/main.tex:187-193` is untouched.
**Issue:** Diffing `pdftotext` of the pre-phase artifact against HEAD shows one text-layer change outside the phase's intended edits:

```
old:  FLIPKART (a Walmart company)          new:  SEARCH RELEVANCE, QUERY INTENT, NLP
      SEARCH RELEVANCE, QUERY INTENT, NLP         FLIPKART (a Walmart company)
```

The career-break deletion moved the Flipkart block up ~49pt, and pdftotext's ordering of `\resumeSubheading` row-2 cells (#3 left / #4 right... here the employer #3 vs subtitle #4 pair) flipped at the new vertical position. This is the exact defect class G6.12 now guards for Education — a text-only parser reads role-noise (`SEARCH RELEVANCE, QUERY INTENT, NLP`) before the employer name — but no gate asserts employer-first for Work Experience rows, so it landed silently. Neither 02-01-SUMMARY nor 02-02-SUMMARY mentions it (grep for FLIPKART/SEARCH RELEVANCE in both: 0 hits), so it is not a documented deviation. G5.5's whole-line frozen check still PASSes (the line exists, just later), which is why the gate stayed green.
**Why it matters for Phase 3:** cell extraction order is position-sensitive (02-02 measured the same asymmetry: Work rows #1-before-#2, Education rows #2-before-#1). Phase 3's Adobe rebuild will shift every block's y-position again — this ordering can flip back or flip for other employers, invisibly.
**Fix:** Either (a) document it as a known non-gated wobble in Phase 3's context, or (b) extend the harness with an employer-first region assertion per Work Experience role (a `region_first_nonempty`-style clause generalizing G6.12), owned by Phase 3. Do not treat pdftotext row order within a `tabular*` row as stable.

## Notes

### NT-01: 7.0pt PROBE_LINES margin constrains Phase 3's edit ordering

**File:** `docs/verify/manifest.txt` (`PROBE_LINES=5`, `LINE_PT=11.5`)
**Issue:** The self-test's +5-line probe (57.5pt) exceeds current page-1 slack (50.5pt) by only **7.0pt**. If Phase 3 *frees* more than 7.0pt (e.g. pulls the D-08 lever and re-compresses the two folded descriptors, worth ~11.5pt each if they drop to one rendered line) **before** spending the budget on the Adobe rebuild, the probe stops overflowing, G7.2 FAILs, and `make verify-selftest` breaks mid-phase — with `PROBE_LINES` raise-only, so a hasty raise is irreversible. 02-02-SUMMARY records the margin but not the ordering implication.
**Fix (guidance, no code change now):** Phase 3 should spend before (or atomically with) freeing, or accept a temporary G7.2 red and raise `PROBE_LINES` only at a measured stable end-state.

### NT-02: `region_first_nonempty` guard errors on non-numeric/empty args

**File:** `scripts/verify-resume.sh:406`
**Issue:** `[ "$1" -lt 1 ] || [ "$1" -gt "$2" ]` — with an empty `$1`, both tests error to stderr (bash 3.2 `integer expression expected`) and evaluate falsy, so execution falls through to `sed -n ",p"` (its own error) instead of returning empty. Not reachable today: the only caller passes `EDU_START`/`EDU_END` from `section_region`, which always emits two integers, and the `EDU_START = 0` case is handled before the call. The pattern is byte-consistent with the pre-existing `region_line_of`/`region_nonempty_count` helpers, so this is an inherited idiom, not new debt. Otherwise the helper is correct: `sed -n "$1,$2p"` + `grep -n -m1 '[^[:space:]]'` + `$(($1 + _rfn - 1))` has no off-by-one (region-relative line 1 → absolute `$1`), whitespace-only lines are treated as blank, `-m1`/`grep -n` are BSD+GNU portable, and a future legitimate reorder that puts anything above the institution correctly FAILs the gate and forces a conscious edit — the intended anchor-free semantics.
**Fix:** none required; if touched later, add a `case $1$2 in *[!0-9]*|'') return 0;; esac` guard.

### NT-03: Descriptor wording is an editorial rendering of D-05/D-06, not byte-verbatim

**File:** `docs/main.tex:199` (Groupon), `docs/main.tex:207` (NetSpeed)
**Issue:** D-05's `... (NSVD ... on Neo4j) + Cyclops customer-service platform ...` shipped with the `+` rendered as `; ` and a leading capital; D-06's `graph algorithms for Network-on-Chip interconnects in C++` shipped as `C++ graph algorithms for Network-on-Chip interconnects:`. CONTEXT designates D-05/D-06 as the *starting text* the planner carries verbatim, and every locked literal (all four module names incl. Virtual Channel Arbitration, `Network-on-Chip`, `NSVD`, `Neo4j`, `Cyclops`, `customer segmentation`, `customer-service platform`, `live in every Groupon country`, the descriptor-unique `C++ graph algorithms` anchor) is verified present in the extracted stream, and both forbidden ladder rungs measure 0. Compliant; recorded so a later phase doesn't "correct" the wording back toward the D-05/D-06 join characters.
**Fix:** none.

## Clean Checks (evidence per review lens)

1. **Ligature break** — text layer carries `ashutosh--tiwari` as two U+002D (hexdump `2d 2d` confirmed); `ashutosh–tiwari` (U+2013) 0 occurrences; the five frozen date ranges still extract as en-dash whole lines (G5.1 5/5). Renders as two hyphen glyphs (extraction of two hyphen-minus + 0 overfull boxes). The `href` target is byte-identical.
2. **Fold carrier** — `\resumeItem{\textit{...}}` sits inside the standard `\resumeItemListStart/End` pair, same shape as every other role body; log has **0 `Overfull \hbox`** and 0 `Underfull`; both wrap points are word-boundary, no hyphenation.
3. **Education rebind** — dates remained in arg #4 (same `\textit{\small #4}` styling as pre-phase — no visual change), #2 empty leaves `\textbf{#1} & \\` with no tabular artifact: the pdftotext diff shows *only* the two city lines removed from the Education region, institution is the region's first non-empty line (G6.12 PASS).
4. **G6.12 rewrite** — anchor-free clause is strictly stronger (fires on anything-first, empty-needle trap structurally unreachable); window clause (`EDU_LO/HI/SPAN` vs `EDU_BIND_WINDOW`) byte-untouched; remedy text de-hardcoded from stale `:240-242`; negative control against the pre-phase artifact re-verified FAIL by 02-02 (documented, reproducible recipe).
5. **EDU_CITY removal completeness** — `grep -rn EDU_CITY` over `*.sh`/`*.txt`/`*.tex`/Makefile: **0** references outside `.planning/` history docs; key and its only reader died in one commit (232abc2).
6. **Frozen strings** — G5.1/G5.2/G5.5 = 15/15 PASS, all "exactly once as a whole extracted line"; G5.3 PASS; `baseline-frozen.txt` unmodified; only manifest diff is the EDU_CITY deletion + comment.
7. **Text-layer diff vs 65573ac** — every hunk maps to an intended edit (contact line, career-break block, two descriptors, two city lines) **except** the Flipkart flip (WR-01).
8. **Docs hygiene** — ROADMAP criterion-5 parenthetical + Superseded-literals note + REQUIREMENTS EXP-05 all carry the same measured 50.4pt/4.39-line figure once each, no duplication; `≈4.25` retained; EXP-01/05/06 checkboxes + coverage table + Progress row consistent.
9. **bash 3.2 compliance** — new helper uses only POSIX `[`, `sed`, `grep -n -m1`, `cut`, `printf`, `$(())`; no arrays, no `[[`, no `local` (matching file convention); shellcheck delta is the pre-existing SC2329 shifted by +21 lines, no new findings, no `disable` added.

---

_Reviewer: gsd-code-reviewer (adversarial) — depth: deep_
