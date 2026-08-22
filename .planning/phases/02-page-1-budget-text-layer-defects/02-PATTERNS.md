# Phase 2: Page-1 Budget & Text-Layer Defects - Pattern Map

**Mapped:** 2026-08-22
**Files analyzed:** 3 modified (`docs/main.tex`, `docs/verify/manifest.txt`, regenerated artifacts) + 1 conditionally modified (`docs/verify/baseline-frozen.txt`)
**Analogs found:** 4 / 4 — every edit site has an in-file analog; no new file is created

> **Two harness traps this mapping found that CONTEXT.md does not name.** Both are manifest edits, not `main.tex` edits, and both will turn a correct implementation red:
> 1. **`EDU_CITY` (T-1)** — dropping the Education city cells (D-09) makes `G6.12` FAIL "unmeasurable", and *deleting* the manifest key is worse than leaving it (empty needle matches a blank line). §5.4.
> 2. **`PROBE_LINES` (T-2)** — freeing ~10-11 lines makes the +5-line self-test probe stop overflowing, so `make verify-selftest` FAILs at `G7.2`. §5.5.
>
> **One CONTEXT assumption is refuted:** the geometry hash is a **source** hash over margin + `\setlist` declarations, not a layout measurement. The four edit sites do not touch it, so `baseline-frozen.txt` needs **no** update and `ALLOW_FROZEN_UPDATE` is **not** needed — unless the executor reaches for a `\setlist`/`\addtolength` width lever. §5.3.

---

## 1. File Classification

| Modified file | Role | Data flow | Closest analog | Match |
|---|---|---|---|---|
| `docs/main.tex:129-137` (header contact line) | template / presentation | text-layer emission | itself + `main.tex:222` (`\underline{\emph{\href{...}{NetSci 2023}}}`) | exact (in-file) |
| `docs/main.tex:169-174` (career-break entry) | template / content block | deletion | `main.tex:203-208` (Groupon block: same 4-arg + 1-topic shape) | exact (in-file) |
| `docs/main.tex:203-215` (Groupon + NetSpeed fold) | template / content block | content compression | `main.tex:190-201` (Flipkart: `\resumeSubheading` + topics) | exact (in-file) |
| `docs/main.tex:238-246` (Education) | template / content block | arg reorder + cell drop | `main.tex:147-149` (Adobe: same macro, date in `#2`) | exact (in-file) |
| `docs/verify/manifest.txt` | config (phase-mutable) | key/value data | its own file header ("Thresholds here are meant to move as phases land") | exact |
| `docs/verify/baseline-frozen.txt` | config (guarded) | key/value data | `--write-baseline` refusal path, `verify-resume.sh:1326-1332` | conditional — see §5.3 |
| `docs/AshutoshTiwari.{pdf,log,fdb_latexmk}` | build artifact (tracked!) | regeneration | commit `65ca963` `build(resume): regenerate AshutoshTiwari.pdf` | exact |

---

## 2. Macro inventory — copy these shapes verbatim

### `\resumeSubheading` — the 4-arg two-line tabular (`main.tex:82-88`)

```latex
% Two-line role header rendered as a single tabular for perfectly uniform
% row spacing (no fragile negative \vspace between two tabulars).
\newcommand{\resumeSubheading}[4]{%
  \item%
    \begin{tabular*}{0.97\textwidth}{@{}l@{\extracolsep{\fill}}r@{}}%
      \textbf{\textcolor{accentdark}{#1}} & #2 \\%
      \textit{\small#3} & \textit{\small #4} \\%
    \end{tabular*}%
}
```

**Measured extraction contract (this is the load-bearing property).** `@{\extracolsep{\fill}}` pushes the two cells to opposite margins, and `pdftotext` default mode therefore emits **each cell as its own text line**, blank-separated. Adobe's block (`main.tex:147-149`) extracts as:

```
5   Senior Machine Learning Engineer (ML Platform & Frameworks)   <- #1
6   (blank)
7   Jul. 2024 – Present                                           <- #2
8   (blank)
9   ADOBE FIREFLY                                                 <- #3
10  GENERATIVE AI, COMPUTER VISION, LARGE LANGUAGE MODELS         <- #4
```

That one-cell-per-line behaviour is what makes `G5`'s whole-line matcher (`grep -Fxc … == 1`) pass. **Any fold that glues a frozen title and its employer/date onto one extracted line fails `G5` at count 0.** Reusing `\resumeSubheading` unchanged is the only shape with proven extraction — CONTEXT's discretion ("reuse `\resumeSubheading` vs a slimmer two-cell tabular") resolves to *reuse* unless the executor is willing to re-measure a new tabular from scratch.

Empty right cell is proven too — career-break passes `{}` as `#2` (`main.tex:170`) and extracts with **no** blank-line gap:

```
30  Career Break for Master’s Degree
31  Indiana University, Bloomington
32  MASTER OF SCIENCE IN COMPUTATIONAL DATA SCIENCE
```

### `\resumeSubSubheading` — defined, **never used** (`main.tex:90-95`)

```latex
\newcommand{\resumeSubSubheading}[2]{%
    \item%
    \begin{tabular*}{0.97\textwidth}{@{}l@{\extracolsep{\fill}}r@{}}%
      \textit{\small#1} & \textit{\small #2} \\%
    \end{tabular*}%
}
```

Usage count in `main.tex`: **0** (the single grep hit is the `\newcommand` line). It is the obvious carrier for D-04's "ONE italic descriptor line", but its extraction behaviour is **unproven in this document** — treat any use of it as a measure-then-trust step, not a copy-paste.

### `\resumeTopic` / `\resumeItem` — the bullet shapes being removed (`main.tex:76-78`, `109-111`)

```latex
\newcommand{\resumeItem}[1]{%
  \item\small{\justifying #1}%
}

\newcommand{\resumeTopic}[2]{%
  \item\small{\justifying \textbf{#1}: #2}%
}
```

Today's Groupon/NetSpeed bodies are exactly one `\resumeTopic` each (`main.tex:207`, `:214`), each wrapping to **2** rendered lines (extraction lines 76-77 and 85-86).

### List scaffolding + spacing knobs

```latex
% main.tex:116-121
\newcommand{\resumeSubHeadingListStart}{%
  \begin{itemize}[leftmargin=0.1in, label={}, itemsep=3pt, topsep=2pt]%
}
\newcommand{\resumeSubHeadingListEnd}{\end{itemize}}
\newcommand{\resumeItemListStart}{\begin{itemize}}
\newcommand{\resumeItemListEnd}{\end{itemize}}

% main.tex:113-114 — level-3 marker
\renewcommand{\labelitemiii}{\small\textendash}
```

```latex
% main.tex:69-72 — INSIDE THE GEOMETRY HASH. Do not touch. See §5.3.
\setlist[itemize]{leftmargin=1.4em, labelsep=0.4em,
                  parsep=0pt, partopsep=0pt}
\setlist[itemize,2]{itemsep=0.5pt, topsep=1pt}
\setlist[itemize,3]{itemsep=0.25pt, topsep=0.5pt, leftmargin=1.3em}
```

Dropping a role's `\resumeItemListStart … \resumeItemListEnd` pair removes its `topsep=1pt` + `itemsep` overhead as well as the bullet lines — that overhead is part of the measured saving, not a rounding error.

### Header centre block — the `\href{...}{\underline{...}}` + `$|$` pattern (`main.tex:129-137`)

```latex
\begin{center}
    \textbf{\Huge \scshape \textcolor{accentdark}{Ashutosh Tiwari}} \\ \vspace{2pt}
    {\color{accent}\rule{\textwidth}{2pt}} \\ \vspace{2pt}
    \small 669-292-7534 $|$
    \href{mailto:findashutoshtiwari@gmail.com}{\underline{findashutoshtiwari@gmail.com}} $|$
    \href{https://linkedin.com/in/ashutosh--tiwari}{\underline{Linkedin@ashutosh--tiwari}} $|$
    \href{https://thunderock.github.io/}{\underline{Homepage/Portfolio}} $|$
    \href{https://github.com/thunderock}{\underline{Github@thunderock}}
\end{center}
```

Extracts as **one** text line (`$|$` becomes a spaced `|`):

```
2   669-292-7534 | findashutoshtiwari@gmail.com | Linkedin@ashutosh–tiwari | Homepage/Portfolio | Github@thunderock
```

Note the `–` in the extracted handle: that is `FORBIDDEN_LITERAL`. Also note `\urlstyle{same}` is already set (`main.tex:44`), so a `\nolinkurl`-style display would inherit the body font if the executor goes that route.

---

## 3. Ligature and special-character mechanics in **this** document

| Source form | Extracted form | Where | Rule for Phase 2 |
|---|---|---|---|
| `--` in *display* text (`main.tex:134`) | `–` U+2013 | header handle | **Break it.** This is the G6.10 defect. |
| `--` in *frozen date* strings (`main.tex:148,177,191,204,211`) | `–` U+2013 | all 5 dates | **Do NOT "fix".** `baseline-frozen.txt` stores the *extracted* form (`Sep. 2016 – Sep. 2017`). Changing the source `--` to anything else changes the extracted byte and fails `G5.1` at count 0. |
| `--` inside an `\href` **target** | *never extracted* | `main.tex:134` | Leave the URL alone (D-02). Targets live in compressed `/URI` annotation streams — that absence **is** the G6.9 defect. |
| `\&` (`main.tex:148,163`) | bare `&` | frozen title `… (ML Platform & Frameworks)` | Frozen; do not touch. |
| `'` (`main.tex:170`) | `’` U+2019 | career-break title | Disappears with the deletion. |
| `\textendash` (`main.tex:114`) | `–` U+2013 | level-3 sub-bullet marker | Untouched by this phase. |
| `---` (`main.tex:196`) | `—` U+2014 | Flipkart topic | Untouched; both 2013 and 2014 are in `NONASCII_ALLOW`. |

**Documented remedy for the handle** — `.planning/research/ARCHITECTURE.md:236`:

> Break the ligature: `ashutosh-{}-tiwari`. Re-verify with `pdftotext`. Zero layout cost.

Applied to D-01's bare-URL display text, the shape is:

```latex
\href{https://linkedin.com/in/ashutosh--tiwari}{\underline{linkedin.com/in/ashutosh-{}-tiwari}}
```

Gate arithmetic for the header after the rewrite (`verify-resume.sh:1799-1816`):

* `CONTACT_LITERALS` are matched with `grep -Fc` — **substring**, not whole-line. Each of `findashutoshtiwari@gmail.com`, `ashutosh--tiwari`, `github.com/thunderock`, `thunderock.github.io` need only appear *somewhere* on extraction line 2. Four `G6.9 PASS` lines is the target (three currently FAIL).
* `FORBIDDEN_LITERAL` is also substring-matched and must reach **0**. `thunderock.github.io` as display text is harmless; `ashutosh–tiwari` anywhere is fatal.

---

## 4. Measured width budget (the fold's real constraint)

Measured from the committed PDF's extraction — rendered wrap points, not guesses:

| Surface | Measured capacity | Draft length | Verdict |
|---|---|---|---|
| Level-2 bullet (`\resumeTopic`/`\resumeItem`, `leftmargin=1.4em` inside `0.97\textwidth`) | **137-141 chars** (longest live lines: 141, 141, 140, 138, 138) | — | — |
| Header contact line (`\small`, centred, full `\textwidth`) | 113 chars used today | **125 chars** for D-01's five bare URLs | fits with room; **verify anyway** |
| D-05 Groupon descriptor as drafted | ≤137-141 for one line | **167 chars** | **wraps to 2 lines → saves 0 lines on Groupon** |
| D-06 NetSpeed descriptor as drafted | ≤137-141 for one line | **167 chars** | **wraps to 2 lines → saves 0 lines on NetSpeed** |

**Today's rendered line cost, per role** (Groupon `main.tex:203-208`, extraction lines 70-77): 2 header rows + 2 wrapped topic lines = **4 lines**. A `\resumeSubheading` + one-line descriptor is **3**. So the fold's saving is **~1 rendered line per role plus the itemize `topsep`/`itemsep` overhead** — *only if each descriptor fits one line*. At 167 chars it fits neither, and the fold saves nothing but the list overhead.

This is the concrete form of D-08's "set the harness headroom expectation to the measured post-change value": either tighten both descriptors to **≤ ~135 chars** or record a smaller measured saving. Career-break removal is the reliable part — `CAREER_BREAK_PT=48.9` ÷ `LINE_PT=11.5` = 4.25 lines, corroborated by its 4 rendered lines (extraction 30-34).

---

## 5. Harness interaction patterns (the executor's edit loop)

### 5.1 The loop

```bash
make build                      # latexmk; rewrites docs/AshutoshTiwari.{pdf,log,fdb_latexmk,...}
bash scripts/verify-resume.sh   # the gate — read exit code + RESULT lines
pdftotext docs/AshutoshTiwari.pdf - | tr '\f' '\n' | sed -n '<region>p'   # measure, never assume
make verify-selftest            # after each batch — see the T-2 trap in §5.5
```

Exit-code vocabulary (`verify-resume.sh:121-186`, Makefile:139-160):

| Code | Meaning | Notes |
|---|---|---|
| 0 | all gates pass — **this phase's DONE signal** | `>> PASS: 0 blocking failures.` |
| 1 | the document is wrong | `!! FAIL: N blocking failure(s) in: <IDs>` |
| 2 | cannot verify (stale PDF, crashed measurement block) | `G0.3 FAIL` md5 mismatch is the common one → run `make build` |

Use `bash scripts/verify-resume.sh`, **not** `make verify`: GNU Make 3.81 collapses any recipe failure to its own exit 2, so the script's 1-vs-2 distinction is invisible through Make (Makefile:139-152). Only `FAIL` moves the exit code; `WARN`/`INFO`/`SKIP` never do.

Live baseline to converge from (`01-02-SUMMARY.md:129-141`): exit **1**, exactly **5** BLOCKERs — `G6.9`×3, `G6.10`×1, `G6.12`×1, all owned by Phase 2.

### 5.2 `--write-baseline`: what it re-measures vs refuses (`verify-resume.sh:1170-1336`)

| Class | Keys | Behaviour |
|---|---|---|
| **RE-MEASURED** (written) | `P1_TOP_PT`, `P1_BOTTOM_WS_PT` | only these two |
| **REPORTED, never written** | `PAGES` (G1.1), `PAGE_SIZE` (G4.2), `PAGE2_OPENS_WITH` (G2.1) | drift prints `!! <KEY>: the artifact now measures … NOT rewritten` |
| **PRESERVED verbatim** | section structure, **Education binding (`EDU_*`)**, geometry keys, **contact literals**, text-layer rules, keyword tiers, WARN owners, **`PROBE_LINES`**, `CEILING_PT` | must be a hand edit in a reviewed commit |
| `baseline-frozen.txt` | 15 frozen strings | **never** generated, at any flag |
| `baseline-frozen.txt` | `[geometry-sha256]` | only derivable value; refused without `ALLOW_FROZEN_UPDATE=1`, unified diff printed first |

So both manifest changes this phase needs (`EDU_CITY`, `PROBE_LINES`) are **hand edits**. `make verify-baseline` cannot produce them.

### 5.3 The geometry hash is a **source** hash — no frozen update expected

`geom_hash` (`verify-resume.sh:420-438`) hashes exactly two sorted streams from `docs/main.tex`:

```bash
_gre='\\addtolength\{\\('"$_gk"')\}\{[^}]*\}'   # GEOMETRY_KEYS = oddsidemargin|evensidemargin|textwidth|topmargin|textheight
# + a brace-balanced python match for  \setlist(\[...\])?{...}
```

i.e. `main.tex:38-42` and `main.tex:69-72` — **nothing else**. The four Phase-2 edit sites (129-137, 169-174, 203-215, 238-246) are outside both, so `G4.1` keeps passing on hash `8b13a46b…465a56` and **`baseline-frozen.txt` is not touched this phase**. This resolves CONTEXT's Discretion item 3: there is no "layout legitimately changed" hash to update.

**The one way to trip it:** reaching for a width/spacing lever — a new `\setlist[...]` anywhere in the file, or an `\addtolength` on one of those five keys — changes the hash and requires the guarded path (`ALLOW_FROZEN_UPDATE=1 make verify-baseline`, review the printed diff, commit). Prefer letter-spacing/separator tweaks inside the `center` block (CONTEXT's allowed lever), which are hash-invisible.

### 5.4 TRAP T-1: `EDU_CITY` and D-09's dropped city cells

`G6.12` reads three manifest-supplied anchors inside the Education region (`verify-resume.sh:1851-1890`):

```bash
EDU_INST_AT=$(region_line_of "$EDU_START" "$EDU_END" "$EDU_INST")
EDU_CITY_AT=$(region_line_of "$EDU_START" "$EDU_END" "$EDU_CITY")
EDU_DATE_AT=$(region_line_of "$EDU_START" "$EDU_END" "$EDU_DATE")

if [ -z "$EDU_INST_AT" ] || [ -z "$EDU_CITY_AT" ] || [ -z "$EDU_DATE_AT" ]; then
    result G6.12 FAIL "Education binding unmeasurable inside the '$EDU_HEAD' region …"
```

Consequences of D-09, both verified:

* **Drop the city cell, leave `EDU_CITY=Bloomington, IN`** → `EDU_CITY_AT` empty → `G6.12` FAIL "unmeasurable". The phase cannot go green.
* **Delete the `EDU_CITY=` line from the manifest** → `manifest_get` returns empty → `region_line_of` runs `grep -n -Fx -m1 -- ""`, which matches the **first blank line** in the region (reproduced: returns line 2 of a 4-line probe). `EDU_CITY_AT` is then a nonsense line number and the ordering clause compares against it — a spurious FAIL quoting `city ''`. **Deleting the key is worse than leaving it.**

Today's region for reference (gate lines 99-113, `EDU_START=100`):

```
 99  EDUCATION
100  Bloomington, IN                                    <- #2, extracts FIRST (the defect)
101  (blank)
102  Indiana University, Bloomington                    <- #1
103  Master of Science in Computational Data Science 3.87/4.0
104  (blank)
105  Aug. 2021 – May 2023                              <- #4
```

Note the inversion is **not** a source-order property: Work Experience rows extract `#1` before `#2` (line 5 before line 7) while Education rows extract `#2` before `#1`. **Extraction order of a two-cell row is measured, never predicted** — that is precisely what `G6.12` exists to catch, so re-measure the region after the edit and choose the manifest change against the measured output. The planner owes an explicit decision here (repoint `EDU_CITY` at a real post-change anchor in the region, or a reviewed `G6.12` edit that disables the ordering clause when the anchor is absent), and `01-VERIFICATION.md:198`'s "no change to the harness" assumption holds only for the minimal arg-swap that D-09 rejected.

### 5.5 TRAP T-2: `PROBE_LINES` and the freed line budget

`G7.2` is the self-test's anti-rot guard, and its own comment predicts this phase (`verify-resume.sh:877-882`):

> 5 lines at 11.5pt is about 57.5pt and today's page-1 slack is a fraction of a point … **but a later fold frees roughly 90-98pt, so if content is not added back, page-1 headroom could exceed the probe's height and a fixed-size probe would stop overflowing** — silently turning the whole self-test into a no-op that reports success.

Phase 2 frees ~10-11 lines ≈ 115-127pt, well past the +5-line probe's 57.5pt. Expected failure text, with its own remedy:

```
RESULT G7.2  FAIL  the probe PDF is only 2 page(s) against manifest PAGES=2, so a +5 probe NO
                   LONGER overflows page 1 and the self-test would prove nothing -- page-1
                   headroom is now <N>pt against manifest CEILING_PT; raise PROBE_LINES in
                   docs/verify/manifest.txt until the probe exceeds the page budget again
```

So `make verify-selftest` must be run *and* `PROBE_LINES` raised (hand edit — §5.2) as part of this phase, or CONTEXT's "run `make verify-selftest` after every edit batch" produces a red that looks like a regression.

Probe injection anchor (`verify-resume.sh:839-849`): structural, not textual — last `\resumeItemListEnd` between `\begin{document}` and `\newpage` (today `main.tex:215`, NetSpeed's). Removing both fold blocks' item lists moves it up to Flipkart's `main.tex:201`; it still resolves. It would only break if the page-1 region lost **every** `\resumeItemListEnd`.

### 5.6 Gates that constrain the fold but cannot be tripped by shrinking

* `G3.1` FAILs only when `deepest > CEILING_PT` (`verify-resume.sh:1503`) — one-directional; extra headroom is safe. `G3.2`/`G3.3` are INFO.
* `G2.3` requires `LAST_EXPERIENCE_EMPLOYER=NETSPEED SYSTEMS (Acquired by Intel)` to extract as a **whole line on page 1** (`verify-resume.sh:1422-1428`). The fold must keep it its own extracted line.
* `G2.1` asserts page 2 opens at `PUBLICATIONS`. The explicit `\newpage` (`main.tex:219`) holds this regardless of how much page 1 shrinks — **do not remove it**.
* WARN-only, will move and that is fine: `G5.4` (`DIGIT_BULLET_FLOOR=7` digit-bearing page-1 bullets — neither removed topic carries digits), `G6.13` (role-block adjacency), `G6.14` (Skills length, Phase 5).
* `CAREER_BREAK_PT=48.9` has **zero** references in `verify-resume.sh` — documentation-only. Deleting the entry trips nothing through this key.

---

## 6. Prior analog — how Phase 1 committed tex-adjacent change

**Commit message shape** (`git log`): `<type>(<NN>[-<PP>]): <imperative lowercase>` — one commit per task, scope is the phase or phase-plan number.

```
feat(01-02): add Education binding, adjacency and invisible-text gates G6.12-G6.15
fix(01): never report FRESH from an L2 arbiter that could not measure
docs(01-03): complete self-test, negative controls and make integration plan
chore(01-02): record plan 02 completion in planning state
```

**Artifact regeneration is its own commit** — `docs/AshutoshTiwari.pdf` and its aux files are **tracked**, and the repo's convention separates source from artifact:

```
84641f3 style(resume): switch to darker deep-teal palette and color role designations
65ca963 build(resume): regenerate AshutoshTiwari.pdf
        docs/AshutoshTiwari.fdb_latexmk |  8 ++++----
        docs/AshutoshTiwari.log         |  6 +++---
        docs/AshutoshTiwari.pdf         | Bin 225435 -> 225460 bytes
```

`docs/AshutoshTiwari.fdb_latexmk` **must** ride along: it carries the md5 that `G0.3`'s freshness proof reads, so a source commit without it makes a fresh checkout refuse at exit 2 (`G0.3 FAIL "PDF is stale…"`). Never `make clean` before committing — it deletes that record (Makefile:180-190).

No tex-content analog exists inside Phase 1 (it only added `scripts/` + `docs/verify/`); `style(resume):` / `build(resume):` above are the repo's pre-phase precedent for touching `main.tex` and its artifact.

---

## 7. What NOT to touch

| Surface | Location | Why |
|---|---|---|
| 5 frozen date strings | `main.tex:148,177,191,204,211` | `G5.1` whole-line count must equal exactly 1; source `--` extracts as U+2013 — that *is* the frozen byte |
| 5 frozen titles | `main.tex:148,177,191,204,211` | `G5.2`; `\&` extracts as bare `&` |
| 5 frozen employers | `main.tex:149,178,192,205,212` | `G5.5`; display names + hyperlinks preserved (D-07) |
| `\pdfgentounicode=1`, `\input{glyphtounicode}` | `main.tex:60`, `:15` | `G4.4` BLOCKER — removing either voids every G5/G6 text-layer assertion |
| `\addtolength{\oddsidemargin…\textheight}` | `main.tex:38-42` | in the `G4.1` geometry hash |
| `\setlist[itemize…]` ×3 | `main.tex:69-72` | in the `G4.1` geometry hash (any `\setlist` anywhere counts) |
| `\newpage` | `main.tex:219` | `G2.1` page-2 boundary |
| Section heading wording ×7 | `\section{...}` calls | `SECTIONS` manifest + `G6.8`; no new heading for the fold (D-04) |
| `\href` **targets** | `main.tex:134` and siblings | correct already; D-02 changes display text only |
| The 15 strings in `baseline-frozen.txt` | — | never generated, hand-authored, honesty invariant |

---

## 8. No analog found

None. Every edit site has a same-macro in-file analog. The two genuinely unprecedented decisions are both *harness config*, not code:

| Change | Why no analog | Guidance |
|---|---|---|
| `EDU_CITY` manifest resolution (§5.4) | first phase to remove a gated anchor string rather than reorder it | planner must decide and document; measure the region first |
| `PROBE_LINES` raise (§5.5) | first phase to free page-1 budget, which is what the guard was written for | `G7.2`'s own FAIL text is the spec |

And one repo-hygiene gap worth flagging: `AGENTS.md` points at `Skill("spike-findings-thunderock-github-io")`, which is **not installed** — the equivalent content lives in `.planning/research/PITFALLS.md` (Pitfalls 8, 16, 17 cover the header shape, masked URLs, and the en-dash) and `.planning/research/ARCHITECTURE.md:236`.

---

## Metadata

**Analog search scope:** `docs/main.tex` (340 lines, read whole), `scripts/verify-resume.sh` (2051 lines — targeted reads at 115-234, 340-439, 780-899, 1143-1347, 1449-1543, 1560-1649, 1786-1895), `docs/verify/{manifest.txt,baseline-frozen.txt}`, `Makefile`, `.planning/research/{PITFALLS,ARCHITECTURE}.md`, `.planning/phases/01-verification-harness/{01-02-SUMMARY,01-VERIFICATION}.md`, `git log`.
**Measurements taken read-only:** `pdftotext docs/AshutoshTiwari.pdf` → `/tmp/gate.txt` (form-feed normalized, same pipeline as the harness's `gate.txt`); empty-needle `grep -Fx` probe on `/tmp/edu.probe`. No repo file was modified; no build was run.
**Pattern extraction date:** 2026-08-22
