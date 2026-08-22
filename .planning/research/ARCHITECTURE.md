# Architecture Research — LaTeX Resume + Site Integration

**Domain:** Single-author LaTeX resume (pdfTeX) + static portfolio page, ATS-constrained, hard page-1 layout gate
**Milestone:** v1.0 Staff MLE Resume Optimization
**Researched:** 2026-08-21
**Confidence:** HIGH for everything about the existing artifacts (measured directly against `docs/main.tex` and `docs/AshutoshTiwari.pdf` via `latexmk` build probes + `pdftotext`/`pdfinfo` extraction); MEDIUM for external ATS-vendor guidance; MEDIUM for palette convention (corpus evidence from mainstream LaTeX CV templates, not a controlled study).

> **Method note.** Every number labelled MEASURED was produced by copying `docs/main.tex` into `/tmp/resume-probe/`, applying one isolated edit, building with `latexmk -pdf -interaction=nonstopmode -halt-on-error`, and reading page count from `pdfinfo` plus per-page content extents from `pdftotext -bbox`. The repo working tree was never modified (`git status --porcelain` empty before and after). Baseline probe reproduced the committed PDF exactly (page-1 content bottom = 764.3pt in both), so probe deltas transfer directly to the real document.

---

## System Overview

```
┌──────────────────────────────────────────────────────────────────────┐
│                          SOURCE OF TRUTH                             │
├──────────────────────────────────────────────────────────────────────┤
│  docs/main.tex (340 ln)              index.html (42 KB)              │
│  ┌────────────────────────────┐      ┌────────────────────────────┐  │
│  │ PREAMBLE      ln 1–121     │      │ hero    ln 41  #intro      │  │
│  │  geometry     ln 37–48     │      │ about   ln 43  #about      │  │
│  │  palette      ln 17–26  ◄──┼──╳───┤ css/style.css #00BFFF      │  │
│  │  \section     ln 51–57     │  no   │ timeline ln 186–225       │  │
│  │  ATS switch   ln 59–60     │ shared│   Adobe    ln 190–201     │  │
│  │  itemize      ln 69–72     │ color │   CareerBrk ln 207–225    │  │
│  │  macros       ln 76–121    │      └────────────────────────────┘  │
│  ├────────────────────────────┤                    │                 │
│  │ BODY                       │                    │                 │
│  │  header       ln 129–137   │                    │                 │
│  │  Experience   ln 144–217 ──┼── PAGE 1 (hard gate)                │
│  │  \newpage     ln 219    ◄──┼── the boundary                      │
│  │  Pubs…Skills  ln 220–324 ──┼── PAGE 2                            │
│  └────────────────────────────┘                    │                 │
├──────────────────────────────────────────────────────────────────────┤
│                             BUILD                                    │
│  Makefile ── latexmk -pdf -jobname=AshutoshTiwari ── BasicTeX        │
│              (JOBNAME is FIXED → cannot emit variants)               │
├──────────────────────────────────────────────────────────────────────┤
│                          ARTIFACTS                                   │
│  docs/AshutoshTiwari.pdf (2 pp, letter, committed)   GitHub Pages    │
│         │                                                            │
│         └─► ATS text layer ─── pdftotext ─── recruiter/ATS keyword   │
└──────────────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | File:line | Owns | Milestone touches it? |
|---|---|---|---|
| Palette definitions | `docs/main.tex:18-20` | 3 named colors | **Yes** — palette proposals |
| Link colors | `docs/main.tex:21-26` | `linkcolor`/`citecolor`/`urlcolor` = `accentdark` | Indirectly (follows palette) |
| Page geometry | `docs/main.tex:37-42` | `\textheight` = **737.15pt** MEASURED, margins | No — do not touch (see anti-patterns) |
| `\raggedbottom` | `docs/main.tex:46` | Makes overflow **silent** | No — but drives verification design |
| `\section` renderer | `docs/main.tex:51-57` | Small-caps head + colored rule | Only via palette |
| ATS switch | `docs/main.tex:15,59-60` | `glyphtounicode` + `\pdfgentounicode=1` | No — never remove |
| Vertical rhythm | `docs/main.tex:69-72` | `itemsep`/`topsep` per nesting level | **Contingent** — fit lever |
| `\resumeSubheading` | `docs/main.tex:82-88` | 2-cell `tabular*` role header | No structural change needed |
| `\resumeTopic` | `docs/main.tex:109-111` | **bold label**: description | **Yes** — Adobe rebuild |
| Sub-bullet label | `docs/main.tex:114` | `labelitemiii` = `\textendash` | Optional ATS hardening |
| Role-list spacing | `docs/main.tex:117` | `itemsep=3pt` between roles | **Contingent** — fit lever |
| Contact line | `docs/main.tex:132-136` | Phone/email/LinkedIn/site/GitHub | **Yes** — LinkedIn handle bug |
| Experience | `docs/main.tex:144-217` | 6 roles, 15 topics, 10 items MEASURED | **Yes** — the core rewrite |
| Page boundary | `docs/main.tex:219` | `\newpage` | No — it is the gate, not a lever |
| Skills | `docs/main.tex:318-324` | Comma-separated keyword blob | **Yes** — skills stretch |
| Site hero/about | `index.html:41,43` | Public positioning text | **Yes** — site sync |
| Site timeline | `index.html:190-201, 207-225` | Adobe bullets + **its own career break** | **Yes / scope question** |

---

## 1. Change Map

### 1.1 Career-break removal

| Target | `docs/main.tex:169-174` (6 source lines, verified: `\resumeSubheading{Career Break for Master's Degree}{}` … `\resumeItemListEnd`) |
|---|---|
| Operation | Delete the whole block. No replacement row (per PROJECT.md:62). |
| Rendered footprint | y 341.0 → ~384pt on page 1 = **4 text lines** (2 header + 2 wrapped body) MEASURED |
| Budget effect | **−48.9pt** on page 1 (content bottom 764.3 → 715.4) MEASURED — includes the inter-role `itemsep=3pt` gap |
| Side effect | Removes the all-caps extraction line `MASTER OF SCIENCE IN COMPUTATIONAL DATA SCIENCE` from inside Work Experience (see §3 watch-item 3) |
| Neighbours | Leaves `docs/main.tex:166` (`\resumeItemListEnd` of Adobe) adjacent to `docs/main.tex:176` (`\resumeSubheading` Swiggy) — Swiggy directly follows Adobe |
| Site twin | `index.html:207-225` carries an equivalent `Career Break — Master's Degree` timeline item (heading `index.html:215`, sub-lines 216-217, bullet 221). **Not in PROJECT.md's Active list** — surface as a scope decision. |

### 1.2 Adobe Firefly section rebuild

| Target | `docs/main.tex:147-166` |
|---|---|
| Sub-targets | `:147-149` header (title / dates / company link / designation) · `:151` lead `\resumeItem` · `:152-157` topic **Distributed Inference Frameworks** + 3 nested subs · `:158-162` topic **Foundation Model Training Framework** + 2 nested subs · `:163` topic **Build & Deployment System** · `:164` topic **Enrichment Service** · `:165` topic **Data Quality Framework** |
| Current footprint | y 112.0 → ~335pt = **20 text lines** (2 header + 18 body) ≈ **223pt**, i.e. **30% of page 1** MEASURED |
| Constraint | `:148` title string and `:148` date range are **frozen** (PROJECT.md:39 — never change titles/dates). Positioning must come from topic labels and bullet language, not the printed title. |
| Evidence source | `.planning/research/CODEBASE-EVIDENCE.md` — note the honest-framing rules at `CODEBASE-EVIDENCE.md:7-14` are binding |
| Budget | Whatever the rebuild adds must fit inside 48.9pt freed by §1.1, or be paid for from §2.3 levers |

### 1.3 Keyword optimization

Two distinct surfaces with **very different budgets** — this is the key architectural insight for phase decomposition.

| Surface | File:line | Page | Headroom | Notes |
|---|---|---|---|---|
| Experience bullets | `docs/main.tex:151-165` (Adobe), `:180-187` (Swiggy), `:194-200` (Flipkart), `:207` (Groupon), `:214` (Netspeed) | 1 | **48.9pt / 4 lines** | Expensive. Every keyword competes for the page-1 gate. |
| Technical Skills | `docs/main.tex:321-322` | 2 | **53.5pt / 4 added lines** MEASURED | Cheap. Zero page-1 cost. |

Measured keyword gaps in the current PDF (`pdftotext docs/AshutoshTiwari.pdf` occurrence counts): `torch.compile` **0**, `A100` **0**, `H100` **0**, `ONNX` **0**, `CUDA` **0**, `Rust` **1**, `fault` **1**, `SQS` **1** — against `CODEBASE-EVIDENCE.md:54` (torch.compile max-autotune in production), `:56` (ONNX Runtime CUDA EP), `:27,98,127` (A100-80GB / H100 / 64-H100 wave), `:29-30` (+27,135-line Rust subsystem). These are evidence-backed keywords the document currently does not carry at all.

Page-2 growth is measured safe to **+4 skills lines** (page-2 content bottom 710.9 → 754.8pt, 9.7pt of ceiling left); +5 and beyond keeps 2 pages but leaves <6pt margin — treat +4 as the working cap.

### 1.4 Skills stretch

| Target | `docs/main.tex:318-324` — `:321` domain/language blob, `:322` `\textbf{Frameworks/Libraries/Tools}` blob |
|---|---|
| Current form | Comma-separated inside `\begin{itemize}[leftmargin=0.15in, label={}]` (`:319`) with a manual `\\` break between the two lines |
| ATS verdict | Already correct — comma-separated lists are one of exactly three parser-safe forms per Jobscan; no table, no column |
| Budget | Page 2, +4 lines safe MEASURED |
| Gate | PROJECT.md:30 — user approves the final list; bullets stay evidence-true, Skills may stretch to interview-defensible adjacent tech |

### 1.5 Palette proposals

| Target | `docs/main.tex:18-20` — exactly **two** hex values matter |
|---|---|
| `accent` (`:18` `#17685C`) | **2 use sites**: `:55` section underline rule (1pt), `:131` name underline rule (2pt). Rules only — no text. |
| `accentdark` (`:20` `#0E463E`) | **11 use sites**: `:23-25` hyperref link/cite/url colors, `:54` section heading text, `:85` role title inside `\resumeSubheading`, `:130` the name, `:149/:178/:192/:205/:212` the five company names |
| `accentlight` (`:19` `#E4EFEC`) | **0 use sites** — dead code, residue of the pre-`87e4780` filled-section-bar design. Delete or repurpose; changing it has no visual effect. |
| Blast radius | A palette swap = editing 2 hex literals. No macro, no body, no CSS. |

### 1.6 Site hero/about sync

See §5 for exact strings. Targets: `index.html:41`, `:43`, `:190-191`, `:195-201`, and the scope-question block `:207-225`.

### 1.7 Bonus defect found (cheap, high value, no budget cost)

`docs/main.tex:134` writes the visible handle as `Linkedin@ashutosh--tiwari`. LaTeX's `--` ligature renders it as a single **en dash (U+2013)**, so the extracted text layer reads `Linkedin@ashutosh–tiwari` — **the wrong LinkedIn handle**. MEASURED: extracted token contains `--` = `False`, contains U+2013 = `True`. The `\href` URL itself is unaffected (the clickable link is correct); only the human-readable / ATS-harvested text is corrupt. Fix by breaking the ligature (`ashutosh-{}-tiwari`) and re-verifying with `pdftotext`. Zero layout cost.

---

## 2. Page-1 Fit Mechanics

### 2.1 The geometry, exactly

| Quantity | Value | Source |
|---|---|---|
| `\textheight` | **737.15378pt** | `\typeout` probe on the real preamble |
| `\topmargin` | −43.36243pt | probe (`docs/main.tex:41`) |
| Text-block top | y = 27.3pt | `pdftotext -bbox` |
| Text-block **ceiling** | **y = 764.4pt** | 27.3 + 737.15 |
| Page-1 content bottom (current) | **y = 764.3pt** | `pdftotext -bbox` on committed PDF |
| **Page-1 slack, current** | **0.15pt** | ceiling − content |
| Page-2 content bottom | y = 710.9pt | `pdftotext -bbox` |
| **Page-2 slack** | **53.5pt ≈ 4.6 lines** | ceiling − content |
| Physical margins | L 0.500in · R 0.508in · T 0.378in · B 0.384in | `pdftotext -bbox` |

**Page 1 is 99.98% full.** There is no hidden room. `\raggedbottom` (`docs/main.tex:46`) means the page simply stops where it stops; it does not signal fullness.

### 2.2 What is on page 1 now

| Block | `main.tex` | y span | Text lines | ≈ pt |
|---|---|---|---|---|
| Name + rule + contact | `:129-137` | 27.0 → 72 | 2 | 45 |
| `\section{Work Experience}` + rule | `:144` | 72 → 112 | 1 | 40 |
| **ADOBE FIREFLY** | `:147-166` | 112 → 335 | **20** | **223** |
| Career Break | `:169-174` | 341 → 384 | 4 | 43 |
| SWIGGY | `:176-188` | 388 → 536 | 13 | 148 |
| FLIPKART | `:190-201` | 541 → 663 | 11 | 122 |
| GROUPON | `:203-208` | 667 → 712 | 4 | 45 |
| NETSPEED SYSTEMS | `:210-215` | 716 → 764 | 4 | 48 |
| | | | **59 lines** | **737** |

Line counts are visual lines (baseline-grouped from `-bbox`, merging the 2–3pt font-metric offsets that bold/roman runs produce inside one line). Adobe alone is a third of the page and 20 of 59 lines.

### 2.3 The cost model — MEASURED

**One added single-line level-2 item costs exactly 11.5pt.** Verified linear across 4 successive additions (715.4 → 726.9 → 738.3 → 749.8 → 761.3). The 5th addition tips to 3 pages.

| Lever | `main.tex` | Δ page-1 | ≈ lines | Reversible? | Notes |
|---|---|---|---|---|---|
| **Remove career break** | `:169-174` | **−48.9** | 4.25 | yes | Already in scope. This is the budget. |
| Remove GROUPON role | `:203-208` | **−49.3** | 4.3 | yes | 2016–17, single topic, weakest Staff-MLE signal |
| Remove NETSPEED role | `:210-215` | ≈ −49 (est., identical 2+2 shape) | 4.3 | yes | 2015–16, oldest |
| Remove 1 two-line L3 sub-bullet | e.g. `:183` | **−22.1** | 1.9 | yes | Swiggy Akka sub-bullet |
| Remove 1 single-line topic | e.g. `:187` (DAQ), `:195` (Tail Query) | ≈ −11.5 | 1 | yes | Weakest topics in older roles |
| `itemize,2` `itemsep 0.5→0`, `topsep 1→0` | `:71` | **−8.4** | 0.7 | yes | Near-invisible; free real estate |
| Role gap `itemsep 3pt→2pt` | `:117` | **−4.0** | 0.35 | yes | Near-invisible |
| Add 1 topic + 1 nested sub-bullet | — | **+22.9** | 2 | — | The shape the Adobe rebuild will add |

**Reading the budget.** Career-break removal buys **4 single lines**, or **2 topic+sub-bullet pairs**, or **~1.2 topics with a 2-line description plus one sub-bullet**. If the Adobe rebuild wants more, the cheapest honest source is the two pre-2018 roles: collapsing GROUPON + NETSPEED into a single "earlier experience" line frees ≈ **90–98pt (8 lines)** while costing almost nothing in Staff-MLE signal (they are 9–11 years old and carry 1 topic each). Formatting micro-tuning (`:71` + `:117`) adds only **12.4pt** combined — useful as a final nudge, not as a strategy.

### 2.4 What NOT to do

| Anti-lever | Why not |
|---|---|
| Shrink body font below `\small` | `\resumeItem` (`:77`) and `\resumeTopic` (`:110`) already render at `\small` (≈9pt on a 10pt base). `\footnotesize` (8pt) drops below the 10–12pt body range mainstream ATS/resume guidance recommends, for ~10% height. Bad trade. |
| Reduce margins further | Top/bottom are already **0.378in / 0.384in** MEASURED. Common laser printers have a ~0.25in unprintable edge. Little headroom, real clipping risk. |
| Widen `\textwidth` | Horizontal margins are 0.5in so there *is* room, but widening re-flows every wrapped line in the document and invalidates all measurements in this file — a whole-document re-measure, not a tweak. Lever of last resort. |
| Reintroduce negative `\vspace` between entries | The preamble comment at `:80-81` records that the two-line header was deliberately made a single `tabular*` to avoid "fragile negative `\vspace` between two tabulars". Don't undo that decision. |
| Two-column layout | Jobscan: page-level columns cause text-layer scrambling — "a catastrophic data collision". |
| Move or delete `\newpage` (`:219`) | It *is* the gate. Removing it doesn't create room; it lets Experience bleed into Publications. |
| Remove `\pdfgentounicode=1` / `glyphtounicode` (`:15,59-60`) | Directly breaks the ATS text layer. |

### 2.5 The overflow-detection trap — read this before writing any phase plan

MEASURED across three probe builds:

| Probe | Pages | Overfull/Underfull warnings | Errors |
|---|---|---|---|
| baseline | 2 | **0** | 0 |
| +4 lines (fits) | 2 | **0** | 0 |
| **+5 lines (overflows)** | **3** | **0** | **0** |

`\raggedbottom` suppresses the underfull-vbox warnings that would normally flag a loose page, and there is no such thing as an "overfull page" warning. **A 3-page overflow produces a completely clean, exit-0 `make build`.** The committed `docs/AshutoshTiwari.log` likewise has zero warnings.

Consequence: **`make build` succeeding proves nothing about the page-1 gate.** Page count is the only signal. Every phase that edits Experience must run the §6 gate, not just build.

---

## 3. ATS-Safe LaTeX — verified against this document

Verification ran `pdftotext` in all three modes (default / `-layout` / `-raw`) against `docs/AshutoshTiwari.pdf`.

### 3.1 Already correct — do not regress

| Practice | Where | Evidence |
|---|---|---|
| `\input{glyphtounicode}` + `\pdfgentounicode=1` | `:15`, `:59-60` | **Zero** ligature glyphs in extracted text (checked ﬁ ﬂ ﬀ ﬃ ﬄ → all absent; "first", "profiles", "fixes" extract as plain ASCII). This is the sb2nov→jakegut convention — corpus confirms it in `sb2nov/resume:39-44`, `jakegut/resume:56-61`, `santifer/career-ops`, `DaKheera47/job-ops`, `fork-commit-merge`, and LaTeX2e itself (`latex3/latex2e base/ltfinal.dtx:734`). The comment text at `:59` is verbatim from that lineage. |
| `[hidelinks]` | `:10` | No link borders in output |
| Standard section names | `:144,220,238,260,270,281,318` | Extract as clean uppercase: `WORK EXPERIENCE`, `EDUCATION`, `RESEARCH EXPERIENCE / INDEPENDENT STUDY`, `TEACHING EXPERIENCE`, `SELECTED PROJECTS`, `TECHNICAL SKILLS`. `\scshape` (`:54`) round-trips to real uppercase letters, not PUA codepoints. |
| `tabular*` role headers | `:82-88` | **Correct linear reading order in all 3 modes**: title → date → company → designation. Default mode splits the row into separate lines (the `\extracolsep{\fill}` gap reads as a column break) which is *helpful* — the date lands on its own line. See §3.3 for why the generic "avoid tables" warning does not bite here. |
| `\resumeTopic` bold-label pattern | `:109-111` | Extracts as one clean line: `– Distributed Inference Frameworks: Designed and led engineering for…`. Label, colon and description stay adjacent. |
| Comma-separated Skills | `:321-322` | Exactly one of Jobscan's three blessed forms (commas / `\|` / `•`). Not a table. |
| Single column, no graphics/text boxes | throughout | Only two vector `\rule`s (`:55`, `:131`) — not text, cannot scramble |
| Clean build | `docs/AshutoshTiwari.log` | 0 Overfull, 0 Underfull, 0 errors |

Non-ASCII inventory of the extracted text (complete): U+2013 en dash ×40, U+2019 apostrophe ×6, U+2022 bullet ×6, U+2192 → ×3, U+2206 ∆ ×2, U+00D7 × ×1, U+2014 em dash ×1, U+201C/U+201D quotes ×1 each. All are ordinary punctuation/math that extract correctly; none are keywords. **Em dashes and `\textendash` sub-bullets are not a problem** — the concern raised in the brief does not materialize.

### 3.2 Watch items, ranked

| # | Risk | Where | Severity | Fix |
|---|---|---|---|---|
| 1 | **LinkedIn handle corrupted in the text layer** — `--` → U+2013, so extraction yields `ashutosh–tiwari` not `ashutosh--tiwari` | `:134` | **HIGH** (wrong contact data reaches recruiter/ATS) | Break the ligature: `ashutosh-{}-tiwari`. Re-verify with `pdftotext`. Zero layout cost. |
| 2 | All-caps designation strings extract as standalone all-caps lines that a naive section-segmenter could read as headings — e.g. `BACKEND ENGINEERING` (`:205`), `MASTER OF SCIENCE IN COMPUTATIONAL DATA SCIENCE` (`:171`) | `:149,178,192,205,212` + `:171` | LOW-MED | §1.1 already deletes the worst one. If a scanner reports mis-sectioning, title-case the designation argument. |
| 3 | En-dash date separators (`--` → U+2013) | `:148,177,191,204,211` | LOW | Most date parsers handle U+2013. A plain hyphen or ` to ` is maximally safe. Flag only. |
| 4 | `-raw` extraction loses inter-word spaces (`SeniorMachineLearning`, `ADOBEFIREFLY`, `MASTEROFSCIENCEIN…`) | inherent | LOW, **not fixable** | Artifact of pdfTeX's kern-based justified typesetting; affects every pdfTeX resume. Absent in default and `-layout` modes, which is what modern extractors use. Implication: don't trust a single scanner's verdict. |
| 5 | Sub-bullet marker is an en dash, not `•` (article's default `labelitemii` is also an en dash; `:114` sets `labelitemiii` to `\textendash`) | `:114` | LOW | Jobscan explicitly blesses `•`. Optional hardening: `\textbullet` at levels 2–3. **Changes the visual design and label widths → needs user sign-off and a page-1 re-measure.** |
| 6 | `titlesec` loaded but unused — `\section` is hand-redefined | `:5` vs `:51-57` | NONE | Dead weight only. Side effect: no PDF outline/bookmarks; `pdfinfo` reports `Tagged: no`. Normal for pdfTeX, not an ATS blocker. |
| 7 | `accentlight` defined, never used | `:19` | NONE | Dead code; clean up during the palette phase. |

### 3.3 On `tabular*` vs the vendor "avoid tables" warning

Jobscan's position is unambiguous: "Most ATS parsers read linearly… Using grids or side-by-side columns causes text-layer scrambling", and their worked failure example is a **page-level two-column design** (Canva/Illustrator) where Lever recovered work experience and dropped skills, contact info and links entirely.

`docs/main.tex:82-102` is a different construct: a **single-row, two-cell, full-width `tabular*`** used only for header lines. Empirically it extracts in correct order in all three `pdftotext` modes, and the same macro shape is the canonical `jakegut/resume` / `sb2nov/resume` pattern that circulates as ATS-safe. **Assessment: keep it.** The zero-risk alternative, if a real scanner ever flags it, is the `\hfill` form used by `santifer/career-ops` (`\textbf{#1} \hfill #2 \\`) — a drop-in swap inside `\resumeSubheading` that changes no call sites. Note this would alter vertical spacing, so re-measure page 1 after.

### 3.4 Keyword strategy implication (external evidence, MEDIUM confidence)

From Jobscan's ATS guide, citing their *State of the Job Search* recruiter survey:

- 99.7% of recruiters use ATS keyword filters.
- Resumes containing the **exact target job title** got **10.6× more interview invitations**.
- **76.4%** of surveyed recruiters start candidate search **from skills**.
- Explicit anti-pattern: keyword stuffing — "recruiters are wary of overly broad skill lists… they could reject resumes that seem suspicious or lack context."

Three architectural consequences:

1. **Skills is the highest-leverage, lowest-cost surface.** 76.4% skills-first search, and `docs/main.tex:321-322` sits on page 2 with 53.5pt of slack. Bias keyword expansion here.
2. **The "Staff" title keyword has no home yet.** PROJECT.md:39 freezes the printed title. There is a **commented-out `\section{Summary}` at `docs/main.tex:141-142`** — a ready-made insertion point for a headline carrying target-role language. Cost: ~3–4 lines of the 4.25-line budget, i.e. it would consume nearly the entire career-break dividend. **Not in PROJECT.md's Active list** — surface as an explicit trade, don't assume it.
3. **Stuffing risk is real and PROJECT.md already guards it** (`:37` out-of-scope list, `CODEBASE-EVIDENCE.md:7-14` honest-framing rules). The vendor evidence independently supports that boundary: unbacked keywords get rejected on inspection.

---

## 4. Palette Integration

### 4.1 Propagation model

```
:18 accent      ──► :55  \section underline rule (1pt)      ─┐ rules only
                └─► :131 name underline rule (2pt)          ─┘ WCAG floor 3:1

:20 accentdark  ──► :23-25 hyperref link/cite/url color     ─┐
                ├─► :54  section heading text                │ text
                ├─► :85  role title (\resumeSubheading #1)   │ WCAG target 7:1
                ├─► :130 name                                │
                └─► :149,178,192,205,212 five company names ─┘

:19 accentlight ──► (nothing)                                  dead
```

**A palette swap touches exactly two hex literals.** No macro edits, no body edits. `accentlight` is inert.

### 4.2 No coupling to the site

`css/style.css` uses `#00BFFF` (×12), `#0099cc`, `#939393`, `#727272`, `#333`. A repo-wide search for `17685C` / `0E463E` / `E4EFEC` returns matches **only** in `docs/main.tex`. The site's `#intro` (`css/style.css:70-74`) and `#surname` (`:52-56`) are `#939393`.

Consequence: **the palette phase and the site-sync phase are fully independent.** (Worth noting as an out-of-scope observation: resume teal and site sky-blue are already visually unrelated. PROJECT.md:38 defers site redesign.)

### 4.3 Print and grayscale safety

Two bars matter, and they are different: `accent` carries only vector rules (WCAG large/graphic floor **3:1**); `accentdark` carries body-adjacent text (AAA target **7:1**). Grayscale % is ITU-R BT.601 luma, which is what printer drivers approximate.

| Palette | `accent` | CR/white | gray% | `accentdark` | CR/white | gray% |
|---|---|---|---|---|---|---|
| **CURRENT teal** | `#17685C` | 6.62:1 | 30.8% | `#0E463E` | 10.69:1 | 20.5% |
| **P1 Deep navy** | `#1F4E79` | 8.66:1 | 27.0% | `#14345B` | 12.56:1 | 18.4% |
| **P2 Oxblood** | `#7B2D3B` | 9.21:1 | 27.4% | `#571F29` | 12.86:1 | 19.2% |
| **P3 Graphite mono** | `#3E4A59` | 9.02:1 | 28.3% | `#22303C` | 13.50:1 | 17.7% |
| *ref: Awesome-CV `awesome`* | `#3E6D9C` | 5.42:1 | 39.3% | — | — | — |
| *ref: moderncv `headcolor`* | `#3873B3` | 4.92:1 | 41.0% | — | — | — |
| *ref: Awesome-CV `darktext`* | `#414141` | 10.21:1 | 25.5% | — | — | — |
| *ref: pure black* | `#000000` | 21.00:1 | 0.0% | — | — | — |

Findings:

- **Current palette is already safe.** `accent` clears the 3:1 rule floor with margin and even clears AA-body 4.5:1; `accentdark` clears AAA 7:1. Both print at 20–31% gray → read as dark gray on a B/W photocopy, never washed out.
- **The current palette is more conservative than mainstream templates.** Awesome-CV's and moderncv's defaults (5.42:1, 4.92:1) are *lighter* than `#17685C`. There is no contrast reason to change.
- **`accentlight` (#E4EFEC) is 92.3% gray — it would vanish on a photocopy.** Harmless today because it is unused; this is exactly why it should not be revived as a fill.
- **Screening rule for any new candidate:** `accent` ≤ ~35% gray and ≥3:1; `accentdark` ≤ ~25% gray and ≥7:1. All three proposals below satisfy both and are *higher*-contrast than today.
- `accent`↔`accentdark` grayscale separation is 21–27/255 across all candidates — the two-tone hierarchy survives grayscale in every case.

### 4.4 Three candidate directions

Corpus evidence (mainstream LaTeX CV/resume templates, sampled via code search): **mid-blue dominates** — `posquit0/Awesome-CV` `#3E6D9C`, `mitchelloharawild/vitae` moderncv `#3873B3`, `jankapunkt/latexcv` `RGB(0,150,255)` and `RGB(0,120,150)`, `bbatsov` cheatsheet `#268BD2`. Neutral grays carry text hierarchy (`#414141`, `#333333`, `#5D5D5D`, `#999999`). Orange/pink appear only in explicitly "creative" variants. **No burgundy/oxblood anywhere in the sample.**

| | **P1 — Deep navy** | **P2 — Oxblood** | **P3 — Graphite mono** |
|---|---|---|---|
| `accent` | `#1F4E79` | `#7B2D3B` | `#3E4A59` |
| `accentdark` | `#14345B` | `#571F29` | `#22303C` |
| Rationale | The default professional register for senior technical resumes; best-precedented direction in the corpus. Reads as institutional, not decorative. | Differentiates without going warm-bright. High contrast, mature. **Unprecedented in the sampled corpus** — highest upside, highest subjectivity. | Effectively monochrome: near-black text, slate-gray rules. Maximum conservatism; closest to the pure-black templates while keeping the two-tone system intact. |
| Risk | Very safe, least distinctive — many candidates use blue. | No corpus precedent; some readers may read burgundy as legal/academic rather than infra-engineering. | Loses the accent identity; the document becomes visually quieter than today. |
| Contrast vs today | Better (8.66 / 12.56 vs 6.62 / 10.69) | Better (9.21 / 12.86) | Best (9.02 / **13.50**) |

**Keep-teal is a legitimate outcome** (PROJECT.md:31). Nothing in the contrast, print or ATS analysis argues against `#17685C`/`#0E463E`; the decision is purely aesthetic.

### 4.5 Rendering samples — build mechanic

`make build` hardcodes `JOBNAME := AshutoshTiwari` (Makefile), so it **cannot emit multiple named variants**. Use the harness that produced every measurement in this document:

```bash
export PATH=/Library/TeX/texbin:$PATH
mkdir -p /tmp/palette && cd /tmp/palette
for name in teal navy oxblood graphite; do
  case $name in
    teal)     A=17685C; D=0E463E ;;
    navy)     A=1F4E79; D=14345B ;;
    oxblood)  A=7B2D3B; D=571F29 ;;
    graphite) A=3E4A59; D=22303C ;;
  esac
  sed -e "s/{accent}{HTML}{17685C}/{accent}{HTML}{$A}/" \
      -e "s/{accentdark}{HTML}{0E463E}/{accentdark}{HTML}{$D}/" \
      "$REPO/docs/main.tex" > "$name.tex"
  latexmk -pdf -interaction=nonstopmode -halt-on-error -jobname="palette-$name" "$name.tex"
done
```

Two constraints on ordering: samples must be rendered from **frozen final content** so the user judges the real artifact, and each sample must still be page-count-checked (a palette swap cannot change layout, but verifying is free).

---

## 5. Site Sync Points

Exact strings in `index.html`. The site has **no `<meta name="description">` and no Open Graph tags** (searched) — positioning text is invisible to link previews and search snippets. Out of scope, but worth logging.

| # | File:line | Current string | Sync action |
|---|---|---|---|
| 1 | `index.html:41` | `<span id="intro">Senior Machine Learning Engineer at Adobe Firefly</span>` | **Primary hero string.** Must mirror the resume's new positioning. Title itself is frozen (PROJECT.md:39) — reposition by what follows, e.g. adding the inference-framework/distributed-systems register. |
| 2 | `index.html:43` | `<p id="about">` — "…**over 8 years**… My current work spans **distributed inference and training frameworks, MLOps platforms on Kubernetes, and foundation-model training** for generative AI on billions of images and videos. Prior to Firefly… **Swiggy and Flipkart**…" | The bolded spans are the positioning payload. Sync vocabulary with the rebuilt Adobe bullets. Note it also asserts "Master's in Computational Data Science from Indiana University" — this is the site's remaining career-break signal and it is *fine to keep* (Education context, not an Experience row). |
| 3 | `index.html:190-191` | `<span id="section-heading">Adobe Firefly</span>` / `<p><b>Senior Machine Learning Engineer (ML Platform &amp; Frameworks)</b></p>` | Must match `docs/main.tex:148-149` exactly (title + company). Note the HTML entity `&amp;`. |
| 4 | `index.html:195-201` | 7 `<li>` Adobe bullets (currently *more* detailed than the resume: lineage/provenance graph at `:200`, Kubernetes platform at `:198`) | Must not **contradict** the rebuilt resume bullets. The site may carry more detail; it must not carry claims the resume's honesty rules excluded (`CODEBASE-EVIDENCE.md:7-14`). |
| 5 | `index.html:207-225` | Timeline item `Career Break — Master's Degree` (heading `:215`, `Indiana University, Bloomington` `:216`, `M.S. in Computational Data Science` `:217`, bullet `:221`) | **SCOPE QUESTION.** PROJECT.md:32 scopes site sync to "hero/about" only, but leaving this here makes the two artifacts disagree on the milestone's headline decision (PROJECT.md:27,62). Decide explicitly: remove, or keep deliberately. |
| 6 | `index.html:29` | `<title>Ashutosh Tiwari</title>` | Carries no role text. Optional SEO win; out of current scope. |
| 7 | `css/style.css:52-56, 70-74, 115-119` | `#surname`/`#intro` `#939393`, `#section-heading` | **Do not touch.** Site palette is independent (§4.2); text-only sync this milestone. |

---

## 6. Build Order and Verification Loop

### 6.1 Dependency graph

```
                    ┌──────────────────────────────────────┐
                    │ B. Career-break removal (:169-174)   │  ← creates the 48.9pt budget
                    │    + LinkedIn handle fix (:134)      │     (fix is free, fold in here)
                    └───────────────┬──────────────────────┘
                                    │ budget available
                    ┌───────────────▼──────────────────────┐
                    │ C. Adobe rebuild (:147-166)          │  ← consumes the budget
                    │    from CODEBASE-EVIDENCE.md         │
                    └───────────────┬──────────────────────┘
                                    │ page-1 language settled
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
┌───────▼─────────────┐   ┌─────────▼──────────┐   ┌────────────▼────────────┐
│ D. Keyword pass on  │   │ E. Skills stretch  │   │ F. Fit tuning           │
│    older roles      │   │    (:321-322)      │   │    CONTINGENT — only if │
│    (:180-214)       │   │    PAGE 2, +4 line │   │    C/D overflowed       │
│    PAGE 1 budget    │   │    budget          │   │    (:71,:117, trim      │
└───────┬─────────────┘   └─────────┬──────────┘   │     :203-208/:210-215)  │
        │                           │              └────────────┬────────────┘
        └───────────────┬───────────┴───────────────────────────┘
                        │ CONTENT FROZEN — 2 pages verified
        ┌───────────────▼──────────────────────┐
        │ G. Palette proposals (:18-20)        │  ← renders frozen content
        │    3 samples → user picks            │
        └───────────────┬──────────────────────┘
                        │ resume final
        ┌───────────────▼──────────────────────┐
        │ H. Site sync (index.html:41,43,      │  ← mirrors settled language
        │    190-191,195-201; decide 207-225)  │
        └──────────────────────────────────────┘
```

### 6.2 Why this order

| Edge | Reason |
|---|---|
| B → C | B *creates* the 48.9pt the Adobe rebuild spends. Doing C first means writing against a 0.15pt budget and immediately overflowing to 3 pages — with **no build warning** (§2.5) to tell you. |
| C → D | Adobe is the largest block (223pt, 20 lines) and the highest-signal content. Its final size determines what is left for the older roles. Optimizing older-role language first risks re-doing it. |
| E ∥ D | Skills is page 2 with its own independent 53.5pt budget. **No dependency on the page-1 gate** — it can run in parallel with D, or earlier if convenient. This is the cheapest keyword surface (76.4% of recruiters search skills-first). |
| D,E → F | Fit-tuning against non-final content is wasted work. F is *contingent*: if C+D land inside budget, F is skipped entirely. |
| F → G | Palette samples must render the artifact the user will actually ship, or the choice is made against the wrong document. |
| G → H | Site text mirrors settled resume language; syncing earlier means syncing twice. |
| B: handle fix | `:134` is independent, zero-budget, zero-risk. Folding it into the first phase gets it verified early. |

Two decisions to surface **before** planning C, because both change the budget arithmetic:

1. **Summary/headline line?** `docs/main.tex:141-142` is a commented-out `\section{Summary}` — the natural home for the target-role keyword (10.6× interview signal). Cost ≈3–4 lines = nearly the whole career-break dividend. Not currently in PROJECT.md Active.
2. **Trim the two pre-2018 roles?** GROUPON (`:203-208`, −49.3pt MEASURED) and NETSPEED (`:210-215`, ≈−49pt) together free ≈8 lines. Highest-value budget source if the Adobe rebuild needs room. Not currently in PROJECT.md Active.

### 6.3 The verification gate — runnable

Save as `.planning/verify-resume.sh`. **Every phase that edits `docs/main.tex` must pass this**, because `make build` alone is silent on the only hard constraint (§2.5).

```bash
#!/usr/bin/env bash
# Resume verification gate. Exits non-zero on any violation.
set -uo pipefail
export PATH=/Library/TeX/texbin:$PATH
cd "$(git rev-parse --show-toplevel)"
PDF=docs/AshutoshTiwari.pdf
CEIL=764.4          # text-block bottom = 27.3 + \textheight(737.15)
fail=0
note() { printf '%-6s %s\n' "$1" "$2"; }

# make is mtime-gated; force a real rebuild so a revert can't leave a stale PDF
touch docs/main.tex && make build >/dev/null || { note FAIL "build failed"; exit 1; }

# GATE 1 — page count. The ONLY overflow signal (raggedbottom suppresses warnings).
pages=$(pdfinfo "$PDF" | awk '/^Pages:/{print $2}')
if [ "$pages" = "2" ]; then note OK "page count = 2"
else note FAIL "page count = $pages (want 2) -> Experience overflowed page 1"; fail=1; fi

# GATE 2 — the \newpage boundary held: page 2 must START at Publications.
# Do NOT test for absence of company names on p2 — a partial spill can leave a
# fragment ("Breakdown.") that matches no company and yields a false OK. VERIFIED.
if pdftotext -f 1 -l 1 "$PDF" - | grep -q 'WORK EXPERIENCE'; then note OK "Experience starts on p1"
else note FAIL "WORK EXPERIENCE heading not on page 1"; fail=1; fi
if pdftotext -f 1 -l 1 "$PDF" - | grep -qi 'netspeed'; then note OK "last role on p1"
else note FAIL "last Experience role not on p1"; fail=1; fi
p2first=$(pdftotext -f 2 -l 2 "$PDF" - | grep -m1 .)
if printf '%s' "$p2first" | grep -qi 'publications'; then note OK "p2 starts at Publications"
else note FAIL "p2 starts at '$p2first' -> Experience spilled past \\newpage"; fail=1; fi

# GATE 3 — page-fill headroom, both pages.
python3 - "$PDF" "$CEIL" <<'PY' || fail=1
import subprocess,sys,xml.etree.ElementTree as ET
pdf,ceil=sys.argv[1],float(sys.argv[2])
subprocess.run(['pdftotext','-bbox',pdf,'/tmp/_v.xml'],check=True,capture_output=True)
tag=lambda e:e.tag.split('}')[-1]
bad=False
for i,pg in enumerate([p for p in ET.parse('/tmp/_v.xml').getroot().iter() if tag(p)=='page'],1):
    w=[x for x in pg.iter() if tag(x)=='word']
    if not w: continue
    bot=max(float(x.get('yMax')) for x in w); slack=ceil-bot
    flag='FAIL' if slack<0 else 'OK'
    if slack<0: bad=True
    print(f"{flag:<6} p{i} bottom={bot:.1f}pt headroom={slack:+.1f}pt (~{slack/11.5:+.1f} lines @11.5pt/line)")
sys.exit(1 if bad else 0)
PY

# GATE 4 — ATS text layer intact.
python3 - "$PDF" <<'PY' || fail=1
import subprocess,sys
t=subprocess.run(['pdftotext',sys.argv[1],'-'],capture_output=True,text=True).stdout
bad=False
ligs=[c for c in 'ﬁﬂﬀﬃﬄ' if c in t]
print(("FAIL   ligatures leaked: "+''.join(ligs)) if ligs else "OK     no ligature corruption")
bad |= bool(ligs)
for h in ['WORK EXPERIENCE','EDUCATION','TECHNICAL SKILLS','SELECTED PROJECTS']:
    ok=h in t; print(f"{'OK    ' if ok else 'FAIL  '} section heading {h!r}"); bad |= not ok
li=[w for w in t.split() if 'inkedin@' in w.lower()]
ok = bool(li) and '--' in li[0]
print(f"{'OK    ' if ok else 'FAIL  '} LinkedIn handle in text layer: {li[0] if li else '<missing>'!r} (needs literal '--')")
bad |= not ok
sys.exit(1 if bad else 0)
PY

# GATE 5 — evidence-backed keyword presence (tune list per phase).
for kw in inference distributed Kubernetes PyTorch FSDP Ray vLLM Rust fault; do
  n=$(pdftotext "$PDF" - | grep -oi "$kw" | wc -l | tr -d ' ')
  [ "$n" -gt 0 ] && note OK "keyword '$kw' x$n" || note WARN "keyword '$kw' absent"
done

[ "$fail" = 0 ] && { note PASS "all gates green"; exit 0; } || { note FAIL "gate(s) violated"; exit 1; }
```

Notes on the gate:

- **`touch docs/main.tex` is not cosmetic.** `make build` is mtime-gated (`$(PDF): $(TEX_DIR)/$(TEX_FILE)`); after a revert the PDF can be newer than the source and `make` becomes a no-op, silently verifying a stale artifact.
- **Gate 2 must assert what page 2 *starts with*, not what it lacks.** VERIFIED against the overflow probe: a partial spill left the fragment `Breakdown.` on page 2, which matches no company name — so an "absence of Swiggy/Flipkart/Groupon/Netspeed" test returned a **false OK** while the document was 3 pages. The positive assertion (`p2` begins at `PUBLICATIONS`) discriminated correctly across all five probe states (committed / career-break-removed / +4 lines / +5 lines overflow / Groupon-removed). Match case-insensitively — `\scshape` (`:54`) extracts as uppercase.
- Gate 3 reports headroom in **lines** using the measured 11.5pt/line, so a phase can see "1.4 lines left" rather than a raw point count.
- Gate 4's LinkedIn assertion **fails today** (§1.7) — that is intentional; it turns the defect into a tracked, verifiable fix.
- Gate 5 keywords are `WARN` not `FAIL` so the list can be tuned per target JD without breaking the gate.

**Gate behaviour, verified read-only** (no repo writes; probes built in `/tmp`):

| Artifact | Pages | Gate 1 | Gate 2 | Gate 3 (p1 headroom) | Gate 4 |
|---|---|---|---|---|---|
| committed `docs/AshutoshTiwari.pdf` | 2 | OK | OK | **+0.1pt** (+0.01 lines) | FAIL (LinkedIn `–`) |
| career-break removed | 2 | OK | OK | +49.0pt (+4.26 lines) | FAIL (LinkedIn) |
| +4 filler lines | 2 | OK | OK | +3.2pt (+0.28 lines) | FAIL (LinkedIn) |
| **+5 filler lines** | **3** | **FAIL** | **FAIL** | +2.7pt — *misleadingly green* | FAIL (LinkedIn) |
| GROUPON removed | 2 | OK | OK | +98.3pt (+8.55 lines) | FAIL (LinkedIn) |

Two things to read out of this table:

1. **Gate 3 alone is not sufficient.** On the 3-page artifact the page-1 headroom still reads `+2.7pt` — green — because once content spills, page 1 is no longer the binding page. Only gates 1 and 2 catch it. Never substitute a fill measurement for the page-count check.
2. **At +4 lines the headroom is +3.2pt — a quarter of one line.** A phase that lands there is one word-wrap away from a silent 3-page document. Treat anything under ~1 line (11.5pt) of headroom as "must re-verify after any wording tweak, however small".

### 6.4 Per-phase loop

```
edit docs/main.tex
  └─► bash .planning/verify-resume.sh
        ├─ PASS ──► visual check (make view) ──► commit
        └─ FAIL page-1 ──► apply a §2.3 lever, cheapest first:
                            :71 itemsep (−8.4pt) → :117 role gap (−4.0pt)
                            → drop weakest topic (−11.5pt)
                            → drop weakest sub-bullet (−22.1pt)
                            → collapse GROUPON/NETSPEED (−49pt each)
                           re-run gate
```

---

## Anti-Patterns Specific to This Milestone

### AP1: Trusting a green build

**What people do:** edit Experience, run `make build`, see exit 0 and no warnings, commit.
**Why it's wrong:** MEASURED — a 3-page overflow produces zero warnings and zero errors (§2.5). `\raggedbottom` (`:46`) removes the only mechanism that would complain.
**Do instead:** treat `pdfinfo | Pages: 2` as the build's real exit code. Run §6.3.

### AP2: Writing the Adobe rebuild before deleting the career break

**What people do:** start with the interesting content work.
**Why it's wrong:** the budget is **0.15pt** until `:169-174` is gone. Every draft overflows, silently, and you cannot tell a too-long draft from a correct one.
**Do instead:** B before C (§6.1).

### AP3: Buying page-1 space with font size or margins

**What people do:** `\footnotesize`, or shave `\textheight`/margins.
**Why it's wrong:** body text is already `\small` (`:77`, `:110`) ≈9pt, and top/bottom margins are already 0.378in/0.384in MEASURED — inside the neighbourhood of the ~0.25in printer clip zone. Both trade legibility or printability for ~1 line.
**Do instead:** cut content. The two pre-2018 roles (`:203-208`, `:210-215`) are worth ≈8 lines and carry the least Staff-MLE signal.

### AP4: Keyword-stuffing Experience bullets

**What people do:** cram JD vocabulary into page-1 bullets.
**Why it's wrong:** double penalty — it burns the scarcest resource (page-1 lines at 11.5pt each) and triggers the exact failure Jobscan documents (recruiters reject broad, context-free keyword lists). PROJECT.md:37 and `CODEBASE-EVIDENCE.md:9` already forbid the unbacked terms.
**Do instead:** put breadth in Skills (page 2, 53.5pt slack, 76.4% of recruiters search skills-first); keep Experience bullets evidence-true and specific.

### AP5: Treating the palette as a layout change

**What people do:** re-verify layout after a color swap, or fear the palette will affect fit.
**Why it's wrong:** `accent`/`accentdark` are consumed at 13 sites, all pure color (`:23-25,54,55,85,130,131,149,178,192,205,212`). No metrics change. Conversely, don't assume the reverse: `\textbullet` label hardening (watch-item 5) **does** change label widths and must be re-measured.
**Do instead:** swap 2 hex values, run the gate anyway (it's free), and reserve real re-measurement for anything touching `:71`, `:114`, `:117`, or content.

### AP6: Syncing the site's hero while leaving its career-break timeline

**What people do:** follow PROJECT.md:32 literally — hero/about only.
**Why it's wrong:** `index.html:207-225` is a full career-break timeline entry. Removing it from the resume and leaving it on the site makes the two public artifacts disagree on the milestone's headline decision.
**Do instead:** raise it as an explicit scope decision before H (§5 row 5).

---

## Integration Points

### Internal boundaries

| Boundary | Coupling | Notes |
|---|---|---|
| preamble (`:1-121`) ↔ body (`:127-335`) | Macro contract: `\resumeSubheading{4}`, `\resumeTopic{2}`, `\resumeItem{1}` | Content rewrites need **no** preamble change. Fit tuning touches only `:69-72`, `:117`. |
| Experience (`:144-217`) ↔ page 2 (`:220-324`) | `\newpage` at `:219` | Hard, one-way. Experience cannot borrow page-2 slack; page 2 has its own independent 53.5pt. |
| palette (`:18-20`) ↔ 13 consumption sites | Named colors | Swap-safe. `accentlight` unused. |
| `docs/main.tex` ↔ `index.html` | **Text only.** Zero shared color, zero shared build. | Site palette is `#00BFFF` (`css/style.css`). Sync is a copy-edit task, not a code task. |
| `docs/main.tex` ↔ `docs/AshutoshTiwari.pdf` | `make build`, PDF is **committed** | Every content commit needs a PDF regen commit (repo history shows this pattern: `65ca963`, `c4473cf`, `c9c56ec` "build(resume): regenerate AshutoshTiwari.pdf"). |

### External toolchain

| Tool | Role | Gotcha |
|---|---|---|
| `latexmk` / BasicTeX | Build | Needs `/Library/TeX/texbin` on PATH (Makefile exports it; ad-hoc probe scripts must too) |
| `make build` | Wrapper | mtime-gated → `touch docs/main.tex` before verifying a revert. `JOBNAME` fixed → cannot emit palette variants (§4.5) |
| `pdfinfo` (poppler) | **Page-count gate** | The single most important verification command |
| `pdftotext` (poppler 26.08.0 present) | ATS simulation | Run **default** mode as the ATS proxy; `-bbox` for fill measurement; `-raw` only as a pessimistic probe (§3.2 #4) |
| `pdfminer` / Apache Tika | Optional cross-check | Not installed (`pip install` blocked in this environment; `java` present if a Tika cross-check is ever wanted) |

---

## Sources

**Primary (HIGH confidence — direct measurement, this repo, 2026-08-21)**
- `docs/main.tex` (340 ln), `docs/AshutoshTiwari.pdf` (2 pp, 612×792pt, pdfTeX-1.40.27), `docs/AshutoshTiwari.log`, `Makefile`, `index.html`, `css/style.css`
- `.planning/PROJECT.md`, `.planning/research/CODEBASE-EVIDENCE.md`
- Build probes in `/tmp/resume-probe/` (17 `latexmk` builds): baseline reproduction, career-break removal, 13-point filler sweep, per-element cost isolation (Groupon removal, itemsep tuning, role-gap tuning, nested-wrapper cost, sub-bullet removal), 9-point page-2 growth sweep
- `\typeout` geometry probe → `\textheight=737.15378pt`, `\topmargin=-43.36243pt`
- `pdftotext` extraction in default / `-layout` / `-raw` / `-bbox` modes; Unicode codepoint census of the full text layer
- WCAG relative-luminance and ITU-R BT.601 luma computed locally for all candidate palettes

**External (MEDIUM confidence — ATS vendor, dated 2026)**
- Jobscan, *How to Write an ATS Resume That Lands Interviews* — https://www.jobscan.co/blog/ats-resume/ (99.7% keyword filters; 10.6× job-title effect; 76.4% skills-first; keyword-stuffing rejection). Vendor blog citing their own recruiter survey — directionally credible, not peer-reviewed.
- Jobscan, *Why ATS Tables and Columns Ruin Your Resume* — https://www.jobscan.co/blog/resume-tables-columns-ats/ (linear parsing, text-layer scrambling, blessed skills separators `|` `•` `,`, umbrella method). Their failure example is a page-level 2-column design, **not** a single-row `tabular*` — noted in §3.3.

**Corpus (MEDIUM confidence — real-world template practice, code search)**
- `\pdfgentounicode=1` + ATS comment lineage: `sb2nov/resume:39-44`, `jakegut/resume:56-61`, `santifer/career-ops`, `DaKheera47/job-ops`, `fork-commit-merge/fork-commit-merge`, `latex3/latex2e base/ltfinal.dtx:734`
- Palette conventions: `posquit0/Awesome-CV` (`#3E6D9C`; text `#414141`/`#333333`/`#5D5D5D`/`#999999`), `mitchelloharawild/vitae` moderncv (`#3873B3`), `jankapunkt/latexcv` (`RGB(0,150,255)`, `RGB(0,120,150)`), `bbatsov/prelude` (`#268BD2`)
- Counter-example worth avoiding: `liantze/AltaCV` remaps `f_i`→U+FB01 etc., which *reintroduces* ligature codepoints into the text layer — the opposite of what `docs/main.tex:15,59-60` achieves.

**Gaps / not verified**
- No real ATS was run against the PDF (no Jobscan/Lever/Greenhouse account). Claims are `pdftotext`-based simulation across three modes — strong for text-layer integrity, not a substitute for one live scan before the final send.
- Cross-extractor validation with `pdfminer.six` or Tika was not possible in this environment.
- NETSPEED removal cost (≈49pt) is estimated by structural symmetry with the measured Groupon removal (−49.3pt), not directly measured.
- Palette preference is aesthetic; no evidence exists that any of teal/navy/oxblood/graphite outperforms the others in screening.

---
*Architecture research for: LaTeX resume + static site integration, milestone v1.0*
*Researched: 2026-08-21*
