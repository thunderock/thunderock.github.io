---
phase: 01-verification-harness
plan: 02
subsystem: testing
tags: [bash, python3, pdftotext, pdfinfo, poppler, shasum, ats, verification-harness, shellcheck-clean]

# Dependency graph
requires:
  - phase: 01-01
    provides: "RESULT contract, 0/1/2 exit vocabulary, manifest readers, form-feed-normalized $WORK/gate.txt, G0.1-G0.4 preconditions, --skip-freshness override, 15-string honesty freeze, 28-key manifest"
provides:
  - "G1.1 page-count BLOCKER read from the pdfinfo page tree with the threshold from manifest PAGES; G1.2 form-feed cross-check as INFO"
  - "G2.1 positive page-2 opening assertion, G2.2/G2.3 page-1 containment BLOCKERs, G2.4 page-2 employer count as INFO-only"
  - "G3.1/G3.4 bbox BLOCKERs (ceiling, words outside page box); G3.2/G3.3 headroom INFO"
  - "G4.1 line-number-independent source-side geometry+setlist hash as the hard margin gate; G4.2 page size; G4.3 top-extent WARN; G4.4 ATS switch; G4.5 raggedbottom INFO"
  - "G5.1/G5.2/G5.5 exact-count whole-line matcher over all 15 frozen strings; G5.3 title-inflation BLOCKER; G5.4 digit-bullet WARN"
  - "G6.1-G6.4 four-class codepoint census in one reusable parameterized block (glyph_census), ready for Plan 03's --census FIXTURE control"
  - "G6.5/G6.6 keyword tiers as the promotion mechanism; G6.7 prohibited terms with word-boundary counting; G6.8 seven canonical headings"
  - "G6.9/G6.10/G6.12 the three live Phase-2-owned defects as named BLOCKER failures with owners in every message"
  - "G6.13/G6.14 adjacency and Skills-length WARNs; G6.15 usage-based invisible-text scan with an unused-definition INFO"
  - "Reusable region helpers: section_region (with terminal-section EOF fallback), region_line_of, region_nonempty_count, gate_line_of, emit_row, emit_rows, warn_owner, frozen_section, geom_hash"
  - "Inverted acceptance realized: bash scripts/verify-resume.sh exits 1 on the committed PDF with exactly 5 BLOCKER FAILs across G6.9/G6.10/G6.12"
affects: [01-03, 02-page1-budget, 03, 04, 05, 06]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Row protocol: inlined python3 heredocs emit 'ID|STATUS|MESSAGE' rows to a FILE; bash re-emits them via emit_row so BLOCKERS is tallied in the current shell (a pipe would lose the increment in a subshell)"
    - "Manifest values reach python only as argv, never interpolated into a heredoc body"
    - "Region scoping (heading -> next-heading-or-EOF) is a shared helper, so a duplicate string elsewhere in the extraction cannot produce a false PASS"
    - "Near-white colour rule asserts USAGE at a call site, not definition, and stays generic over colours rather than naming today's instance"
    - "Every WARN owner is read from manifest WARN_OWNERS or a per-entry ':phase' suffix; no phase number is hardcoded in the script"

key-files:
  created: []
  modified:
    - scripts/verify-resume.sh

key-decisions:
  - "G6.12's window clause measures institution -> date in NON-EMPTY lines per the plan spec, which PASSES today (span 2 vs EDU_BIND_WINDOW=3); only the ordering clause fails. 01-01-SUMMARY's '5 lines wide' framing measured city -> date in raw lines. One G6.12 FAIL either way."
  - "G6.13's line window is a local constant (ROLE_BIND_WINDOW=3), deliberately NOT a manifest key: no requirement owns the fix, so the commit that promotes the assertion is the commit that adds the key. Avoids touching docs/verify/manifest.txt, which is outside this plan's files_modified."
  - "G6.13 gates on RAW line span, not non-empty span: raw span reproduces the research's 'split into three non-adjacent blocks' observation (span 4 > window 3 for all five roles) while non-empty span would have read 2 and printed a misleading 'bound together'."
  - "G6.4 emits PASS with the full census when every codepoint is declared, and one WARN per undeclared codepoint otherwise -- so the assertion is visible on every run rather than silent when clean."
  - "Content assertions sit AFTER the --selftest / --write-baseline short-circuits so those modes keep 01-01's cheap exit-0 behavior and never pay for the extra extractions."
  - "One RESULT line per G3 ID (summarizing all pages) rather than one per page, keeping the stream in stable ID order."
  - "The research snippet's '|| true' guard on the frozen-string count was dropped: no errexit is in effect, so it is unnecessary, and an error-swallowing idiom in the honesty freeze is exactly the wrong signal."

patterns-established:
  - "Row protocol for python-backed assertions: emit ID|STATUS|MESSAGE to a file, dispatch through emit_row/emit_rows"
  - "Terminal-section EOF fallback in section_region, without which a last-section length check reads a vacuous 0 and passes silently"
  - "BLOCKER FAIL messages always end with an explicit 'Owner: Phase N' clause"

requirements-completed: [VERIFY-01, VERIFY-02, VERIFY-03]

# Metrics
duration: 22 min
completed: 2026-08-22
---

# Phase 01 Plan 02: Content Assertions Summary

**The harness became red-on-arrival: 39 assertions (G0.1 through G6.15) now run against the committed PDF and `bash scripts/verify-resume.sh` exits 1, naming exactly the three Phase-2-owned defects — three masked contact literals, the en-dash handle, and the Education parse order — while all 34 other assertions pass or report.**

## Performance

- **Duration:** 22 min
- **Started:** 2026-08-22T05:48:00Z
- **Completed:** 2026-08-22T06:10:00Z
- **Tasks:** 4 (all `type="auto"`, no checkpoints)
- **Files modified:** 1 (`scripts/verify-resume.sh`, 418 → 1306 lines)

## Accomplishments

- **Inverted acceptance is real and mechanically checkable.** `bash scripts/verify-resume.sh` exits **1** with exactly **5 BLOCKER FAILs** — `G6.9` ×3, `G6.10` ×1, `G6.12` ×1 — and `grep -E 'RESULT G[0-9.]+ +FAIL' | grep -cv 'Phase 2'` returns **0**, so every failure names its fix owner. No fourth BLOCKER appeared.
- **39 assertion IDs report on every run**, none silently absent: G0.1–G0.4, G1.1–G1.2, G2.1–G2.4, G3.1–G3.4, G4.1–G4.5, G5.1–G5.5, G6.1–G6.15 → 83 RESULT lines total.
- **Both freezes proven by negative control, never by assertion.** A one-byte date mutation on a `mktemp -d` copy flips G5.1 to `FAIL count=0`; `\textheight` `1.2in`→`1.3in` flips G4.1 to FAIL — and the same run *without* `--skip-freshness` exits 2 emitting no `G4.1` line at all, proving the override is load-bearing rather than decorative.
- **Two false-PASS traps closed by construction.** Education binding is scoped to its own region (the institution string extracts twice — `gate.txt:31` in the page-1 Career Break block and `gate.txt:102` in Education), and `section_region`'s terminal-section EOF fallback is what makes G6.14 count the real 4 Skills lines instead of a vacuous 0.
- **The glyph gate is one parameterized block**, so Plan 03's `--census FIXTURE` control can drive G6.1–G6.4 without duplicating the rules. Verified discriminating: a fixture carrying `ﬁ` + U+E000 + U+FFFD produces FAIL on all three classes.
- **Zero suppression constructs.** `expected_fail`, `allowlist`, `known_fail` and `|| true` each count **0** in the script; `accentlight` counts 0 (the near-white rule is generic over colours); `overfull`/`underfull` count 0 (the page gate reads the page tree, not the log).

## Task Commits

1. **Task 1: Structural page gates — G1, G2, G3** — `475ce56` (feat)
2. **Task 2: The two freezes — G4 geometry, G5 honesty** — `b7b239a` (feat)
3. **Task 3: ATS glyph, keyword and literal gates — G6.1–G6.11** — `971a293` (feat)
4. **Task 4: Education binding, adjacency, invisible-text — G6.12–G6.15 + summary** — `9b6e3a2` (feat)

## Files Created/Modified

- `scripts/verify-resume.sh` — 418 → 1306 lines, mode 100755 unchanged. New shared helpers (`warn_owner`, `emit_row`, `emit_rows`, `glyph_census`, `gate_line_of`, `section_region`, `region_line_of`, `region_nonempty_count`, `frozen_section`, `geom_hash`) sit before the `--census` short-circuit so Plan 03 can call them from that path without restructuring. `result()` gained a de-duplicated `FAILED_IDS` accumulator feeding the closing summary.

## Full RESULT Stream (committed PDF, exit 1)

```
RESULT G0.1   PASS  pdfinfo, pdftotext and python3 present
RESULT G0.2   PASS  artifacts present and non-empty: docs/AshutoshTiwari.pdf, docs/main.tex, docs/verify/manifest.txt, docs/verify/baseline-frozen.txt
RESULT G0.3   PASS  PDF provably built from current main.tex (latexmk md5 729318505f45209be4838bdff42044c4)
RESULT G0.4   INFO  mtimes identical (pdf=1787351282 tex=1787351282) -- newer-than is indeterminate, as expected after a checkout; not gated
RESULT G1.1   PASS  page tree reports 2 page(s), manifest PAGES=2
RESULT G1.2   INFO  form-feed cross-check agrees with the page tree (2 == 2)
RESULT G2.1   PASS  page 2 opens at 'PUBLICATIONS' as required by manifest PAGE2_OPENS_WITH=PUBLICATIONS
RESULT G2.2   PASS  page 1 carries the experience heading 'WORK EXPERIENCE'
RESULT G2.3   PASS  page 1 carries the last experience employer 'NETSPEED SYSTEMS (Acquired by Intel)'
RESULT G2.4   INFO  experience employer names appearing on page 2: 0 (reported only -- absence is a false OK as a gate; G2.1 is the real boundary assertion)
RESULT G3.1   PASS  deepest content bottom 764.3pt vs ceiling 764.4pt (p1 764.3pt, p2 710.9pt)
RESULT G3.2   INFO  headroom at 11.5pt/line: p1 +0.1pt (+0.00 lines), p2 +53.5pt (+4.65 lines)
RESULT G3.3   INFO  page-1 bottom whitespace 27.7pt vs baseline 27.7pt -- the same measurement as G3.1 read from the physical page edge, kept for traceability only
RESULT G3.4   PASS  0 words outside the page box, of 1218 positioned words across 2 page(s)
RESULT G4.1   PASS  geometry and setlist declarations hash to the frozen value 8b13a46bf5716cb9bb9042a4e1bb60a9d6919fd5f347a34ecdc6122d7f465a56
RESULT G4.2   PASS  page size is 612 x 792 pts (letter) as required by manifest PAGE_SIZE
RESULT G4.3   WARN  page-1 top content extent 27.3pt is within 1.0pt of manifest P1_TOP_PT=27.3pt (delta 0.00pt) -- corroborates \topmargin; G4.1 carries the real margin gate (owner: none)
RESULT G4.4   PASS  ATS text-layer switch intact in docs/main.tex: \input{glyphtounicode} and \pdfgentounicode=1
RESULT G4.5   INFO  docs/main.tex declares \raggedbottom -- vertical slack is absorbed silently, which is why the page count (G1.1) is the primary fit gate
RESULT G5.1   PASS  x5   (Jul. 2024 – Present / Jan. 2019 – Jul. 2021 / Sep. 2017 – Jan. 2019 / Sep. 2016 – Sep. 2017 / Sep. 2015 – Aug. 2016)
RESULT G5.2   PASS  x5   (Senior Machine Learning Engineer (ML Platform & Frameworks) / Software Dev Engineer II (ML Platform) / Software Development Engineer (Search Relevance) / Software Development Engineer / Software Engineer)
RESULT G5.3   PASS  no title inflation in the text layer: 'Staff' x0, slash-hedged seniority lines x0
RESULT G5.4   WARN  page-1 digit-bearing bullet lines: 7 against manifest DIGIT_BULLET_FLOOR=7 -- crude metric, kept non-gating (owner: Phase 3)
RESULT G5.5   PASS  x5   (ADOBE FIREFLY / SWIGGY / FLIPKART (a Walmart company) / GROUPON / NETSPEED SYSTEMS (Acquired by Intel))
RESULT G6.1   PASS  ligature codepoints U+FB00-U+FB06: 0
RESULT G6.2   PASS  private-use codepoints U+E000-U+F8FF: 0
RESULT G6.3   PASS  U+FFFD replacement characters: 0
RESULT G6.4   PASS  every non-ASCII codepoint is declared in manifest NONASCII_ALLOW -- census: U+00D7 x1, U+2013 x40, U+2014 x1, U+2019 x6, U+201C x1, U+201D x1, U+2022 x6, U+2192 x3, U+2206 x2
RESULT G6.5   PASS  x13  inference 8, distributed 2, Kubernetes 2, PyTorch 3, FSDP 2, Ray 3, vLLM 2, Rust 1, fault 1, KEDA 2, SQS 1, Spark 3, Flash Attention 1
RESULT G6.6   WARN  x7   torch.compile 0 (Phase 3), A100 0 (Phase 3), H100 0 (Phase 3), ONNX 0 (Phase 5), CUDA graphs 0 (Phase 3), Iceberg 0 (Phase 5), Triton 0 (Phase 5)
RESULT G6.7   PASS  no prohibited term in the text layer (words counted with word boundaries, phrases as fixed strings)
RESULT G6.8   PASS  x7   WORK EXPERIENCE / PUBLICATIONS / EDUCATION / RESEARCH EXPERIENCE / INDEPENDENT STUDY / TEACHING EXPERIENCE / SELECTED PROJECTS / TECHNICAL SKILLS
RESULT G6.9   PASS  contact literal present in the text layer: 'findashutoshtiwari@gmail.com' on 1 line(s)
RESULT G6.9   FAIL  contact literal missing from the text layer: 'ashutosh--tiwari' (0 occurrences) -- the anchor at docs/main.tex:134-136 masks it behind display text; make the anchor text the literal URL. Owner: Phase 2 / EXP-06
RESULT G6.9   FAIL  contact literal missing from the text layer: 'github.com/thunderock' (0 occurrences) -- ... Owner: Phase 2 / EXP-06
RESULT G6.9   FAIL  contact literal missing from the text layer: 'thunderock.github.io' (0 occurrences) -- ... Owner: Phase 2 / EXP-06
RESULT G6.10  FAIL  corrupted handle present in the text layer: 'ashutosh–tiwari' on 1 line(s) (U+2013 EN DASH) -- LaTeX converted the source double hyphen; break the ligature in the anchor text at docs/main.tex:134. Owner: Phase 2 / EXP-06
RESULT G6.11  INFO  -raw extraction diverges: 381 token(s) exist only in -raw output (word gluing), e.g. 40BandLlama270B. 8Kimages/secon ADOBEFIREFLY -- reported only, never gated
RESULT G6.12  FAIL  Education binding broken inside the 'EDUCATION' region (gate lines 100-113) -- ordering: the city line 'Bloomington, IN' (line 100) extracts BEFORE the institution line 'Indiana University, Bloomington' (line 102), so a parser reads the city as the school; reorder the \resumeSubheading arguments at docs/main.tex:240-242. Owner: Phase 2 (EXP-01 already edits Education; re-asserted by Phase 4 / PG2-03)
RESULT G6.13  WARN  x5   every role split across non-adjacent blocks, line span 4 vs window 3 (owner: unassigned)
RESULT G6.14  WARN  'TECHNICAL SKILLS' renders 4 non-empty line(s) against a target of 3 (manifest SKILLS_MAX_LINES; gate lines 171-176) (owner: Phase 5)
RESULT G6.15  PASS  no invisible-text construct in docs/main.tex: no white colour applied, no phantom, no starred negative skip, no near-white colour used at a call site
RESULT G6.15  INFO  near-white colour(s) defined but never applied: accentlight (#E4EFEC, luma 0.923) -- renders nothing today so it is not an invisible-text defect; Phase 6 / VIS-01 must use it or delete it
>> Groups run: G0 preconditions, G1 page count, G2 page-1 boundary, G3 fill, G4 geometry freeze, G5 honesty freeze, G6 ATS text layer. G7-G8 land in Plan 03.
!! FAIL: 5 blocking failure(s) in: G6.9 G6.10 G6.12
!! The document is wrong. Every RESULT ... FAIL line above names its fix owner.
```

Repeated-ID groups are collapsed above with `xN`; the live run prints one line per item (83 RESULT lines, 39 distinct IDs).

## Measured Values That Differ From the Research Table

| Assertion | Research table | Measured this session | Consequence |
|---|---|---|---|
| G6.5 `inference` count | 10 | **8** | None — G6.5 asserts presence, not a count. All 13 required keywords are present. |
| G6.12 window clause | date "3 lines away (window=3)", implied part of the failure | **passes**: institution(102) → date(105) is **2 non-empty lines** apart, inside `EDU_BIND_WINDOW=3` | G6.12 still FAILs on exactly one clause — the city-first ordering. One FAIL line either way, so the plan's count criterion is unaffected. Phase 2's `\resumeSubheading` reorder fixes the failing clause. |
| G3.2 page-1 headroom in lines | `+0.01 lines` | `+0.00 lines` at 2dp (slack ≈0.06pt, not 0.1pt) | Cosmetic. G3.2 is INFO; the plan asserts only that the message carries both `pt` and `lines`. |
| G6.13 today's state | "split into 3 non-adjacent blocks" | reproduced: raw line span **4** vs window 3 for all five roles (2 non-empty lines apart) | Confirms the research. Reported as WARN with `owner: unassigned`; never gated. |
| G6.11 divergence | qualitative (`ADOBEFIREFLY`, …) | **381** tokens exist only in `-raw` output; sample includes `ADOBEFIREFLY` | INFO only, as specified. |

## Decisions Made

See frontmatter `key-decisions`. The three that a later phase must not silently reverse:

1. **G6.12's window clause measures institution → date in non-empty lines** (the plan's wording), which passes today. Only the ordering clause fails. A later reader comparing against `01-01-SUMMARY`'s "5 lines wide" framing (city → date, raw lines) should not conclude the window check is broken.
2. **`ROLE_BIND_WINDOW=3` is a local constant, not a manifest key.** No requirement owns the role-header fix, so promoting G6.13 to a BLOCKER is the commit that should add the key. Adding it now would have edited `docs/verify/manifest.txt`, outside this plan's `files_modified`.
3. **`G6.13` gates on raw line span, not non-empty span.** Non-empty span reads 2 and would print "bound together", contradicting the measured reality that title, date and employer sit in three separate extracted blocks.

## Deviations from Plan

None — plan executed exactly as written. Four self-inflicted issues were caught by the mandatory acceptance-criteria gate and fixed before their task commit; none changed plan scope:

1. **Content assertions were initially inserted after the `--selftest` / `--write-baseline` short-circuits' position in file order but before them in execution order**, which would have made those modes run every content assertion before printing their SKIP. Reordered so both modes short-circuit first, preserving 01-01's cheap exit-0 behavior. Fixed inside Task 1.
2. **A Task 2 comment literally contained `>= 1`**, tripping the criterion that no at-least-one comparison is applied to a frozen-string count. The comment was *stating the rule*, not applying it, but the token is now absent entirely — reworded to "exact-count (== 1), never an at-least-one test". Fixed inside Task 2.
3. **The `glyph_census` doc comment packed `RESULT G6.1` and `RESULT G6.2` onto one line**, so `grep -cE 'RESULT G6\.(1|2|3)'` returned 2 rather than 3. Split to one ID per line; all matches remain inside the single reusable block. Fixed inside Task 3.
4. **G6.13's first implementation measured non-empty span**, printing "bound together" for all five roles and contradicting the research's measured "split into three non-adjacent blocks". Switched to raw line span, which reproduces the research; the non-empty figure is still reported as secondary detail. Fixed inside Task 4.

---

**Total deviations:** 0. **Impact on plan:** none — no scope change, no criterion relaxed, no assertion weakened.

## Known Stubs

Unchanged from 01-01. `--selftest`, `--write-baseline` and `--census` still parse and exit 0 with a `RESULT … SKIP` line naming Plan 03. This plan deliberately did **not** wire `--census` to the new `glyph_census` function — that swap belongs to Plan 03's G8.4 control — but the function is defined *before* the census short-circuit precisely so Plan 03 can call it there without restructuring the entry path.

No content stubs: every one of the 39 assertion IDs performs a real measurement. No hardcoded empty values, no placeholder messages.

## Interface Notes for Plan 03

- **Row protocol.** `glyph_census <file>` and the two inline python blocks emit `ID|STATUS|MESSAGE` rows. Dispatch them with `emit_row <id> <status> <msg>` or `emit_rows <ID> <rowfile>`, and **always from a file redirect, never a pipe** — a pipe runs `result()` in a subshell and the `BLOCKERS` increment is silently lost.
- **`--census` wiring for G8.4** is a one-line swap: replace the `result G6.1 SKIP` line in the census short-circuit with `glyph_census "$CENSUS_FILE" > "$WORK/census.rows"` plus four `emit_rows` calls, then the exit-code branch. The function and helpers are already above that point.
- **G7.3's overflow probe is the only real page-count negative control.** `docs/transcript.pdf` measures 2 pages, so G1.1 *passes* on it; it also has no sibling `transcript.fdb_latexmk`, so G0.3 takes its absent-record L2 path first. Do not reintroduce a transcript-based check.
- **`--skip-freshness` must stay absent from every Makefile target.** Both G4.1 drift observations in this plan pair it with an explicitly mutated `mktemp -d` copy, and every such run prints `RESULT G0.3 SKIP`. Plan 03's static assertion on the Makefile is what keeps that contained.
- **Exit-code vocabulary is now exercised on all three values:** 0 (`--selftest`, `--census`, `--help`), 1 (committed PDF, and the two drift controls), 2 (stale `--tex` without the override, missing poppler).
- **New scratch files** under `$WORK`: `p1.txt`, `p2.txt`, `p1gate.txt`, `p2gate.txt`, `bbox.xml`, `bbox.rows`, `rawmode.txt`, `rawmode.tok`, `gate.tok`, `glued.tok`, `census.rows`, `frozen.rows` (+ `.sel`), `invisible.rows`, `employers.txt`, `titles.txt`, `dates.txt`, `sections.txt`, `contacts.txt`, `kw.required`, `kw.target`, `prohibited.words`, `prohibited.phrases`. Note the hyphen-free `rawmode.txt`, matching the `raw.txt` / `gate.txt` family.

## Issues Encountered

None blocking. Two things worth recording:

- **`shellcheck` reports one finding, `SC2329` on `cleanup`** ("function is never invoked" — it is, via `trap cleanup EXIT`). Confirmed **pre-existing** by running shellcheck against `git show HEAD~4:scripts/verify-resume.sh`, which reports the same finding plus one on `warn` that this plan resolved. Left alone per the scope boundary — it is not caused by this plan's changes.
- **The `SC2034` warning on `P1_TOP_MEASURED`** that appeared after Task 1 resolved itself in Task 2, when G4.3 started consuming the value.

## Verification Evidence

All 5 plan-level `<verification>` steps and all 4 tasks' `<acceptance_criteria>` re-run green against a clean tree immediately before this summary.

| Check | Result |
|---|---|
| `bash scripts/verify-resume.sh; echo $?` | **1** |
| FAIL lines | exactly `G6.9` ×3, `G6.10` ×1, `G6.12` ×1 |
| FAIL lines not naming `Phase 2` | 0 |
| PASS/WARN/INFO lines | 78 (83 RESULT lines total, 39 distinct IDs) |
| G5.1/G5.2/G5.5 PASS | 15 |
| G6.8 PASS | 7 (0 FAIL) |
| G6.5 PASS | 13 = `KEYWORDS_REQUIRED` entry count |
| G6.6 WARN | 7, every line carrying `owner: Phase` |
| Frozen one-byte mutation (`--frozen` on a temp copy) | `RESULT G5.1 FAIL … count=0` |
| `\textheight` drift (`--tex` + `--skip-freshness`) | `RESULT G4.1 FAIL`, `RESULT G0.3 SKIP`, exit 1 |
| Same drift run **without** the override | exit **2**, zero `G4.1` lines |
| `git status --porcelain` after every run | empty |
| `expected_fail` / `allowlist` / `known_fail` / `\|\| true` counts | 0 / 0 / 0 / 0 |
| `accentlight` / `overfull`\|`underfull` counts in script | 0 / 0 |
| `rawmode.txt` present, `raw-mode.txt` absent | yes / yes |
| Manifest metacharacter injection (`; touch`, `$(id -u)`, backticks) | inert — no marker file, value consumed as data |
| `--tex` path containing spaces | no word-splitting; G4.1/G4.4 both PASS |
| Glyph gate on a corrupt fixture (`ﬁ` + U+E000 + U+FFFD) | G6.1/G6.2/G6.3 all FAIL — the gate discriminates |
| `--selftest` / `--write-baseline` / `--census` / `--help` | exit 0, 01-01 stub lines unchanged |
| `PATH=/usr/bin:/bin` | exit 2 with the `brew install poppler` remedy |
| bash 3.2 portability (`declare -A`, `mapfile`, `readarray`, `${v^^}`) | 0 occurrences |
| `set -uo pipefail` with errexit still absent | confirmed |

## Self-Check: PASSED

- `scripts/verify-resume.sh` present on disk, 1306 lines, mode 100755
- Commits `475ce56`, `b7b239a`, `971a293`, `9b6e3a2` all present in `git log`
- All task acceptance criteria re-run: 10/10 (Task 1), 13/13 (Task 2), 20/20 (Task 3), 17/17 (Task 4)
- Plan `<verification>` steps 1–5: all green
- `docs/` untouched; working tree clean after every harness invocation
- No `make`/`touch`/`git clean` in command position; no `eval`, no `source` of the manifest

## User Setup Required

None — no external service configuration required. The only external dependencies remain Homebrew `poppler` 26.08.0 and the system `python3` (stdlib only: `xml.etree`, `collections`, `unicodedata`, `re`), both probed by G0.1.

## Next Phase Readiness

Ready for `01-03`. What Plan 03 inherits:

- A harness with **all 39 content assertions live** and the exit-code vocabulary exercised on 0, 1 and 2.
- `glyph_census` factored and callable from the `--census` short-circuit — the G8.4 control is a wiring change, not a reimplementation.
- Two working negative-control recipes (frozen mutation, geometry drift) to model G8.2 on.
- The `FAILED_IDS` summary line, so a control can assert *which* assertions fired without parsing the whole stream.

**The expected trajectory is unchanged and the exit code is now the inverted one the phase was chartered to produce.** `make verify` still does not exist (Plan 03 adds it), and when it does, **`make verify` exiting 0 against today's committed PDF would mean the harness is wrong, not that the resume is right.** Phase 2 turns it green by fixing EXP-06 (make the anchor text the literal URLs, break the en-dash handle at `docs/main.tex:134`) plus the `\resumeSubheading` argument reorder at `docs/main.tex:240-242` — with **no change to this harness**.

Concern carried forward: none blocking. `01-01-SUMMARY`'s bookkeeping caveat still applies — `VERIFY-01/02/03` are checked off in `REQUIREMENTS.md`, and as of this plan they are substantively satisfied (G1–G3, G6, G4–G5 respectively), but end-to-end coverage still needs Plan 03's `make verify` target and self-test.

---
*Phase: 01-verification-harness*
*Completed: 2026-08-22*
