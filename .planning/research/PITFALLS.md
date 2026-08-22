# Pitfalls Research

**Domain:** Repositioning an existing, working LaTeX resume + portfolio site (Senior MLE, 10 YoE) for Staff MLE / inference-framework roles
**Researched:** 2026-08-21
**Confidence:** HIGH on document-mechanics pitfalls (measured directly against `docs/AshutoshTiwari.pdf`); MEDIUM on ATS behaviour (credible sources disagree — see "Framing"); MEDIUM-LOW on recruiter gap norms (few sources loaded; flagged inline)

---

## Framing: what "ATS-safe" actually buys (read this first)

The two most credible source families **directly contradict each other**, and getting this wrong makes every downstream pitfall mis-prioritised.

| Claim | Jobscan (vendor, sells ATS optimisation) | The Tech Resume Inside Out / named tech recruiters |
|---|---|---|
| Does ATS auto-reject on resume content? | Implies yes — "whether a human recruiter ever sees your resume could depend on how well your resume is optimized for ATS algorithms" | **No.** "None of the major ATS systems reject resumes automatically, or hide them from recruiters. Resume processing for all major systems is basic." |
| PDF vs DOCX | "All ATS recognize Word documents. Most of them can also read PDF" | "Both PDF and Word documents are parsed well enough"; a London tech recruiter: "the best CV format being PDF" |
| Tables/columns | "catastrophic data collision", whole sections dropped | Not addressed; parsing described as basic auto-fill + indexing |
| Ranking | Match scores matter | Only Taleo ranks, "this score is off for software developers", no recruiter consulted relied on it |

Jobscan has a commercial interest in the threat being large; Orosz names the recruiters backing his claims and explicitly calls out that the scare articles cite only resume-service vendors. **Weight Orosz higher on "will I be auto-rejected", and Jobscan higher on "what does the extracted text actually look like"** — the latter is mechanical and I verified it independently below.

**Resolution used throughout this document.** Parse quality does not gate rejection. It gates three concrete things:

1. **Retrievability.** Jobscan's own architecture description: the ATS builds an *inverted index* and recruiters run Boolean queries (`"Java AND (Spring OR Hibernate) NOT Junior"`). A term that is absent from the extracted text makes the candidate **unretrievable for that query**. Presence is binary — this is why the correct keyword goal is **coverage, not density**.
2. **Structured-field auto-fill.** Parsers use NER to tag `"Google"` as Organization and `"2018-2022"` as a Date Range. Bad binding of company↔title↔dates produces a garbled candidate record and a garbled recruiter-side timeline.
3. **The human 6-second scan**, which is the actual decision point: "the recruiter or hiring manager scanning your resume will [decide] ... in a few seconds."

Everything below is scoped to those three, not to a mythical robot gatekeeper.

**Market context (for "which parsers matter"):** Greenhouse 19.3%, Lever 16.6%, Workday 15.9%, iCIMS 15.3% of ATS-detected companies; 98.4% of Fortune 500 use some ATS.

---

## Measured baseline (evidence for the pitfalls below)

All numbers from the committed `docs/AshutoshTiwari.pdf` on 2026-08-21. These are facts about *this* document, not general advice.

| Measurement | Value | Why it matters |
|---|---|---|
| Page 1 last text baseline | yMax **764.3 pt** of 792 pt page | Declared text block bottom is ~763.2 pt (`fullpage` 1in, `topmargin −0.6in`, `textheight +1.2in`) |
| Page-1 top / bottom whitespace | 27.3 pt / **27.7 pt** (symmetric) | Page 1 is filled to the exact bottom of its text block — **zero free lines** |
| Modal line height, page 1 | **11.0 pt** | Conversion factor for every "how many lines can I add" question |
| Career-break block height | **50.0 pt = ~4.5 lines** | This is the **entire** page-1 budget freed by the deletion |
| Page 2 bottom whitespace | 81.1 pt (~7 lines) | Page 2 has slack; page 1 has none |
| `/URI` link annotations | **26 present**, all inside compressed object streams (PDF 1.7 objstm) | Links exist but are invisible to text-layer-only extraction |
| Literal URL strings in text layer | **0** | No `linkedin.com/...`, no `github.com/...`, no `thunderock.github.io` as text |
| Embedded fonts | SourceSansPro Bold/Regular/It (subset, Custom enc) + CMSY9/CMMI9/CMR9/CMR6 (Builtin enc) | Computer Modern is dragged in purely by math mode (`$|$`, `$\to$`, `$\times$`, `$O(\Delta^2)$`); all carry ToUnicode (`uni=yes`) so they do extract |
| `accentdark` #0E463E vs white | **10.69:1** | Passes WCAG AAA (7:1). This is the colour used on all text |
| `accent` #17685C vs white | 6.62:1 | AA but not AAA; used only for rules, where the 3:1 non-text threshold applies — fine |
| `accentlight` #E4EFEC | 1.18:1, **defined at `main.tex:19` and never used** | Dead definition; a palette swap that misses it leaves an inconsistency landmine |
| `accentdark` vs `accent` | **1.61:1** | The "two-tone" system is effectively one tone — a proposal can't rely on these reading as distinct |
| Grayscale luma (BT.601) | accentdark → #343434 (12.45:1); accent → #4E4E4E (8.32:1) | Current palette survives B&W printing comfortably |

**Extraction behaviour (poppler `pdftotext`, three modes):**

- *Default mode* — clean prose, but `tabular*` headers split into **non-adjacent blocks**: `Senior Machine Learning Engineer (ML Platform & Frameworks)` / blank / `Jul. 2024 – Present` / blank / `ADOBE FIREFLY`.
- *Default mode, Education* — **reading order scrambles**: `Bloomington, IN` is emitted **before** `Indiana University, Bloomington`, and `Aug. 2021 – May 2023` lands in its own detached block.
- *Default mode, Research/Teaching* — `\hfill` dates **fully detach**: all three TA bullets, then `Spring 2023 / Fall 2022 / Spring 2022` as a separate block.
- *`-raw` (content-stream order)* — **words glue together**: `ADOBEFIREFLY`, `MASTEROFSCIENCEINCOMPUTATIONALDATASCIENCE`, `SeniorMachineLearning`, `Falcon-40BandLlama270B`, `Aug. 2021–May2023`. Under a stream-order extractor the token `Adobe` **does not exist**.
- *Ligature defect* — the LinkedIn anchor text renders and extracts as `Linkedin@ashutosh–tiwari` (U+2013 en-dash) because LaTeX converted `--` to an en-dash. The underlying `/URI` is correctly `ashutosh--tiwari`. **The clickable link works; the human-readable and machine-extracted handle is wrong.**
- *Bullet markers* — level-2 and level-3 both render as `–`; the visual 3-level hierarchy **flattens to one level** in extraction.
- *Math artifact* — `$O(\Delta^2)$` extracts as `∆2` (U+2206 INCREMENT, superscript flattened).

**Controlled experiment — removing `\justifying` is free.** I rebuilt with `\justifying` stripped from both `\resumeItem` and `\resumeTopic`. Result: PDF bytes differ, but **default-mode and `-raw` extraction are byte-identical**, and pagination is unchanged (still 2 pages, Experience still ends page 1). Two conclusions: (a) dropping justification is a **zero-risk** readability fix; (b) justification is **not** the cause of the `-raw` word-gluing — that is an extractor limitation, so do not "fix" it in LaTeX. *(Honest negative result — I expected the opposite.)*

**Gap arithmetic (the number Phase 1 must actually design against):**

```
Swiggy ends            Jul 2021
Adobe begins           Jul 2024      -> 36-month Experience gap
IU MS (Education)      Aug 2021 - May 2023   covers 22 months
Uncovered by Exp+Edu   ~1 mo (Jul-Aug 2021) + 14 mo (May 2023 -> Jul 2024)
Research/Teaching      Independent Study "Summer 2022 - Summer 2023", TA "Spring 2023"
                       -> narrows the human-visible tail to ~12-13 months
```

So: **~14 months uncovered by dated Experience/Education; ~12–13 months after crediting season-labelled Research entries** — and those Research entries are on page 2, use season labels (which the reference wiki explicitly says not to mix with months), and have dates that detach in extraction.

**This qualifies a PROJECT.md assumption.** `PROJECT.md` Key Decisions says the gap "self-explains" via Education. Partly true, partly not: it self-explains to a human who reaches **page 2**; it does **not** cover the ~14-month post-graduation window at all; and its dates **scramble in extraction**, so a parser-built timeline may not bind Aug 2021–May 2023 to IU. The decision to delete the row is still defensible — but the *reason* needs replacing, and the posture needs to be chosen deliberately rather than inherited.

**Also present in `main.tex`, relevant below:** `\justifying` on every bullet (2 definitions); `\raggedright` globally; 16 `\resumeTopic` bold lead-ins; section named `Technical Skills`; Skills renders as 4 lines; month abbreviations carry periods (`Jul.`, `Sep.`); career-break `\resumeSubheading` argument 2 is `{}` so that entry currently has **no dates at all**; `index.html` contains `Senior Machine Learning Engineer` **3 times**.

---

## Phase vocabulary used in this document

`PROJECT.md` lists target features but not phases. I map pitfalls onto these, and **recommend adding Phase 0** — every other phase needs its gate:

| Phase | Scope |
|---|---|
| **Phase 0 — Parse & Fit Harness** *(recommended addition)* | `make verify`: pdftotext round-trip in ≥2 modes, page-1 fit assertion, contrast check, link/URL check. Built **before** content edits |
| **Phase 1 — Career-Break Removal & Gap Posture** | Delete the row; decide the on-resume device (or deliberately decide "none"); write the off-resume screening-call note |
| **Phase 2 — Adobe Section Rebuild** | Evidence-bound rewrite, inference-framework thesis |
| **Phase 3 — Keyword Coverage Pass** | JD-derived vocabulary into evidence-true phrasing |
| **Phase 4 — Skills-Section Stretch** | Interview-defensible adjacent tech, user-approved |
| **Phase 5 — Accent Palette** | 2–3 proposals rendered as PDFs, user picks |
| **Phase 6 — Site Hero/About Sync** | `index.html` alignment |
| **Phase 7 — Final Fit & Parse Gate** | Full re-verify, cross-artifact consistency, prep-note finalisation |

---

# Critical Pitfalls

## (a) Removing the career-break entry

### Pitfall 1: Deleting the row also deletes the only sanctioned on-resume device for the gap

**What goes wrong:**
The career-break row is removed, nothing replaces it, and the resume now presents Swiggy `Jan. 2019 – Jul. 2021` directly above Adobe `Jul. 2024 – Present` with no acknowledgement of the 36-month interval. A recruiter's date-math is instant and the gap becomes the first question in their head — but there is nothing on page 1 that answers it, so the resume answers it with silence. Silence at staff level reads as either "laid off and struggled" or "hiding something", both worse than the truth.

**Why it happens:**
The deletion is framed as a *subtraction* ("remove the awkward row") rather than a *substitution* ("replace a weak device with a stronger one"). `PROJECT.md` reinforces it by asserting the gap "self-explains" through Education — which is true only for a reader who reaches page 2 and does the arithmetic themselves.

**How to avoid:**
The r/EngineeringResumes wiki names exactly three triggers that justify a summary/profile block: *"you're a senior/staff engineer or above, making a career change, or addressing an unemployment gap/returning to the workforce."* **Two of the three apply here simultaneously.** So the aligned move is a ≤2-sentence summary at the top that does double duty — states the staff-level inference-framework thesis *and* absorbs the education window in passing (e.g. leading with 10 years of ML platform work and the MS, so the reader never has to reconstruct the timeline). `main.tex:141-142` already has a commented-out `\section{Summary}` scaffold, so this is a revive-not-invent change. The wiki also independently recommends a brief summary for 10+ YoE engineers. If the user declines a summary, that is a legitimate choice — but it must be *recorded as a decision with the gap posture accepted*, not left as an unexamined default.

**Warning signs:**
- The diff for this phase is pure deletion with no compensating addition anywhere.
- Nobody can state, in one sentence, what a recruiter sees between Jul 2021 and Jul 2024 without turning to page 2.
- The phase is called "remove career break" rather than "replace career-break row with summary".

**Phase to address:** Phase 1 (decide + implement the device), re-checked in Phase 7.

---

### Pitfall 2: Over-trusting Education to cover the gap — it covers 22 of 36 months and its dates scramble in extraction

**What goes wrong:**
The plan assumes `Aug. 2021 – May 2023` neutralises the gap. Measured reality: it leaves **~14 months uncovered** (the May 2023 → Jul 2024 window), and in default-mode extraction the Education block emits `Bloomington, IN` **before** `Indiana University, Bloomington`, with `Aug. 2021 – May 2023` landing in a **detached block**. A parser doing NER date-range binding may therefore never associate those dates with the institution — meaning the mitigation is invisible in the structured record even where it is visible to a human eye.

**Why it happens:**
The author reads their own PDF visually, where the two-column `tabular*` looks perfect. The scramble is only observable by running an extractor, which nobody does unless there's a harness that forces it.

**How to avoid:**
1. **Do the arithmetic explicitly** in the requirements and design for the *residual* ~14 months, not the whole 36.
2. **Make the Education dates bind.** The `\resumeSubheading` argument order currently puts location in the top-right and dates in the bottom-right; a single-line-per-entry form (`Institution — Degree, GPA` with the date range as the only right-hand element on the *same* row) collapses the scramble surface. Verify by extraction, not by eye.
3. **Note the season-label problem:** the Research/Teaching entries that narrow the visible tail use `Summer 2023` / `Spring 2023`. The wiki is explicit — *"If you choose to include months in addition to years, strictly use them and don't mix in seasons or semesters."* Season labels are also unparseable as date ranges. They are human-only mitigation.

**Warning signs:**
- `pdftotext AshutoshTiwari.pdf` shows the Education institution and its date range on non-adjacent lines (this is the **current** state — it is already failing).
- Requirements say "Education covers the gap" without a month count.

**Phase to address:** Phase 0 (detect it), Phase 1 (fix the binding + set the posture).

---

### Pitfall 3: Papering over the gap by fudging dates or inventing filler

**What goes wrong:**
The tempting fixes are all worse than the gap: (i) stretching Swiggy's end date or Adobe's start date; (ii) switching to years-only (`2019 – 2021`, `2024 – Present`) to blur boundaries; (iii) inserting a "Consultant / Independent ML Engineer, 2023–2024" row with no client, no deliverable and no commit evidence; (iv) reformatting into a functional/skills-first resume that suppresses chronology entirely.

**Why it happens:**
Each feels like a small cosmetic choice rather than a factual claim. But employment dates and titles are precisely what pre-employment verification checks against payroll and prior-employer HR records — a discrepancy discovered *after* an offer is a rescission-class problem, not an awkward-conversation-class problem. And a "consulting" row is a lie that a staff-level interviewer will probe for exactly the thing it lacks: a client, a scope, an outcome.

**How to avoid:**
`PROJECT.md` already forbids this — *"Changing employment dates or titles — never fabricate"* is in Out of Scope, and bullets must be commit-evidenced. Make it **mechanically enforced**, not merely stated:
- Phase 0 harness asserts the five date strings (`Jul. 2024 – Present`, `Jan. 2019 – Jul. 2021`, `Sep. 2017 – Jan. 2019`, `Sep. 2016 – Sep. 2017`, `Sep. 2015 – Aug. 2016`) and the printed titles are **byte-identical** to the pre-milestone PDF. Any diff there fails the build.
- Keep month-level precision. Years-only is a recognised gap-hiding tell and *loses* information a 10-YoE candidate benefits from.
- The honest alternative, if the gap ever *does* cost interviews: the **paid RA** role (`main.tex:265`, "Working as a paid RA") and the three TA positions are genuinely paid work and would legitimately belong in Work Experience per the wiki's *"Only include PAID work experience in this section"*. That is a real, truthful lever — but it only reaches Summer 2023 and so does not close the material window. **Do not present it as closing the gap.** The user has already declined an RA/TA replacement row; record that as decided, with this as the documented fallback.

**Warning signs:**
- Any date or title string in the diff.
- A new Experience row whose bullets cite no repo, ticket, or artifact.
- "Should we just use years only?" appearing in discussion.

**Phase to address:** Phase 0 (assertion), Phase 1 (posture), Phase 7 (final diff audit).

---

### Pitfall 4: Preparing the resume but not the 30-second spoken answer

**What goes wrong:**
The resume ships clean, the recruiter screen opens with "I see a gap between 2021 and 2024 — walk me through that," and the answer is improvised, apologetic, or over-explained. A hesitant answer converts a non-issue into the memorable feature of the call.

**Why it happens:**
The milestone's artifacts are `main.tex` and `index.html`, so verbal preparation has no natural home and gets dropped.

**How to avoid:**
Produce a short **off-resume** note (e.g. `.planning/screening-prep.md`) with: the exact date arithmetic so it is never recomputed live; a 2–3 sentence unapologetic framing (full-time master's, publications, TA/RA work, then Adobe); and one sentence for the post-graduation window. Explicit constraint: **this note is never resume or site content** — the resume states facts, the call supplies narrative. Also record the LinkedIn implication: if LinkedIn shows a differently-shaped 2021–2024 than the resume, the discrepancy — not the gap — becomes the question (see Pitfall 21).

**Warning signs:**
- No deliverable in the milestone that is not `.tex` or `.html`.
- The gap posture exists as a rendering decision but nobody has said it out loud.

**Phase to address:** Phase 1 (draft), Phase 7 (finalise).

---

## (b) Keyword-optimising for ATS

### Pitfall 5: Chasing density instead of coverage

**What goes wrong:**
The target JD vocabulary gets repeated across summary, bullets, and skills on the theory that more mentions score higher. It doesn't: retrieval is via an **inverted index** and **Boolean queries** — presence is binary. The second and third mention buy **zero** retrieval benefit while consuming the ~4.5-line page-1 budget and making the prose read like SEO spam to the human who actually decides.

**Why it happens:**
"Keyword optimisation" borrows its mental model from 2010-era SEO. Vendor tooling that reports a percentage "match score" reinforces it, even though the vendor's own architecture description says the mechanism is an index plus recruiter-set Boolean filters, and Orosz's recruiters say no one sorts on the score.

**How to avoid:**
Run Phase 3 as a **coverage checklist, not a density dial**:
1. Enumerate target terms from real Staff MLE / inference-framework postings.
2. Split into **evidenced** (`torch.compile`, ONNX Runtime, FSDP/FSDP2, Flash Attention, context parallelism, vLLM, Ray, Kubernetes, KEDA, distributed inference, A100/H100, Rust, Spark, Iceberg, fault tolerance…) and **unevidenced** (TensorRT/TRT-LLM, CUDA graphs, speculative decoding, quantization, MoE/TP/PP — the `CODEBASE-EVIDENCE.md` prohibition list).
3. Target **exactly one strong placement** per evidenced term, preferring a bullet over the Skills list (a term inside an accomplishment sentence satisfies both the index *and* the human; the same term in a comma list satisfies only the index).
4. Assert the checklist against extracted text, not against the `.tex` source — a term present in LaTeX but glued or dropped in extraction is not indexed.
5. **Unevidenced terms get zero placements in Experience.** Skills-section treatment is a separate, user-approved decision (Pitfall 9).

**Warning signs:**
- The same term appears 3+ times across summary/bullets/skills.
- A bullet reads as a list of nouns rather than a thing that happened.
- The keyword list is checked against `main.tex` rather than `pdftotext` output.

**Phase to address:** Phase 3, gated by Phase 0's extraction assertion.

---

### Pitfall 6: Verbatim JD phrasing pasted into bullets

**What goes wrong:**
JD sentences ("fault-tolerant high-concurrency distributed inference for text/image/multimodal workloads") get lifted into bullets. Two failures compound: the bullet now describes a *job opening* rather than something the candidate **did**, and it is instantly recognisable to the hiring manager who wrote or approved that JD — reading as flattery-by-copy-paste and, worse, as a claim to the entire scope of the role.

**Why it happens:**
The JD is the most convenient source of "correct" vocabulary, and copying maximises literal term overlap.

**How to avoid:**
Adopt the JD's **nouns**, never its **sentences**. Every bullet must survive the wiki's test — *"your resume is not your job description"* — and be traceable to `CODEBASE-EVIDENCE.md`. Concretely: `styx_enrichment`'s SQS-fed batched GPU inference on A100/H100 with exponential-backoff-plus-jitter retry, `asyncio.to_thread` offload so CUDA work never blocks the event loop, and lease/TTL heartbeats + DLQ + circuit breakers **is** fault-tolerant high-concurrency distributed inference — described as work performed, with its own specifics, which is far more convincing than the JD's abstraction. Keep the JD-derived phrasing (if any) in the summary line where forward-looking framing is legitimate; keep bullets in past-tense accomplishment form.

**Warning signs:**
- A bullet phrase appears verbatim in the source posting.
- A bullet has no corresponding entry in `CODEBASE-EVIDENCE.md`.
- Bullets are noun-phrases without a verb + outcome.

**Phase to address:** Phase 2 (Adobe rebuild) and Phase 3 (keyword pass) jointly.

---

### Pitfall 7: Invisible-text stuffing (white font, 1pt, off-page, hidden layers)

**What goes wrong:**
Hidden keyword blocks are added on the theory that the parser sees them and the human doesn't. Both halves are wrong. Text extraction is colour-, size-, and position-blind: I extracted this PDF's full text layer in three modes and the extraction carries **everything** in the content stream regardless of rendering. So the block appears in the recruiter-visible parsed record, in the pasted plain-text application field, and in any AI screening summary — as a naked keyword dump. In LaTeX it is also trivially visible in the source diff.

**Why it happens:**
It is the single most-repeated "ATS hack" online, and it is technically easy in LaTeX (`\textcolor{white}{...}`, `\hspace*{-10cm}`).

**How to avoid:**
Phase 0 harness assertion: **every glyph in the text layer must be visible in the rendered page**. Cheap approximations — fail the build if any text is set in white or near-white; fail if extracted text contains content absent from a human-read of the PDF; fail on any `\textcolor{white}` / `\phantom` / negative-`\hspace*` text construct. Note the corollary: because extraction is faithful, the honest content genuinely *is* fully indexed — hiding buys nothing that legitimate placement doesn't already give.

**Warning signs:**
- `pdftotext` output contains lines you cannot point to on the page.
- Any zero-visibility text construct in the diff.
- Extracted character count grows far faster than visible content.

**Phase to address:** Phase 0 (assertion), enforced in Phase 3.

---

### Pitfall 8: The two-column header defeats company/title/date binding

**What goes wrong:**
Every role header is a `tabular*` with `@{\extracolsep{\fill}}` (`main.tex:82-88`). In default-mode extraction this yields:

```
Senior Machine Learning Engineer (ML Platform & Frameworks)
<blank>
Jul. 2024 – Present
<blank>
ADOBE FIREFLY
GENERATIVE AI, COMPUTER VISION, LARGE LANGUAGE MODELS
```

Title, dates, and employer arrive as **three separate blocks**. A parser binding `Organization` to `Date Range` by line adjacency can mis-associate or drop the link, and in the Education block the order actively **inverts**. Jobscan's mechanism description matches what I measured — parsers "read a document as a continuous, linear stream of text" and side-by-side content produces "text-layer scrambling" where "a PDF's visual layout doesn't match its underlying data structure."

**Why it happens:**
This is the standard Jake-Gutierrez-lineage LaTeX resume idiom. It renders beautifully and the defect is invisible without running an extractor. Note the precise mechanism: the PDF contains **no table structure at all** (PDFs carry no table semantics unless tagged) — the risk is that two text runs on one baseline separated by a large `\fill` gap force the extractor to guess whether they are one line or two, and poppler guesses "separate blocks".

**How to avoid:**
- Phase 0: assert that for each role, employer, title, and date range appear within a small line window of each other in extracted text. This is a **regression test on existing behaviour**, so expect it to fail on day one — that is the point.
- Reduce the gap-guessing surface: put the employer on the **same** line as the title (`Adobe Firefly — Senior Machine Learning Engineer ... Jul 2024 – Present`), so at most one split can occur and it splits *dates* off a line that already contains both employer and title. Jobscan's "umbrella" guidance points the same way: employer named once, at the top of the stack.
- Do **not** rewrite the whole layout for this. It is a real but bounded risk (Orosz: parsing is "basic", used for auto-fill and indexing, not filtering), and the milestone's hard constraint is page-1 fit. Fix the header shape, keep the visual system.

**Warning signs:**
- `pdftotext` shows a blank line between a title and its dates.
- Education emits the location before the institution (current state).
- Research/Teaching dates appear as an orphan block (current state).

**Phase to address:** Phase 0 (detect), Phase 2 (fix header shape while the Adobe block is already being rewritten).

---

## (c) Stretching the skills section / overclaiming

### Pitfall 9: Skills-list bloat past ~3 lines — every addition devalues the rest

**What goes wrong:**
The stretch mandate ("add interview-defensible adjacent tech") is read as "add everything defensible", and Skills grows from its current 4 rendered lines to 6–8 lines / 40+ items. The r/EngineeringResumes guidance names the exact failure: *"This is not a section to spew every buzzword on every technology you've ever touched. Find a balance between enough skills ... while not showing too many so that the reader makes it seem like none of them are important."* At 40 items no single item signals anything, and the reader's inference flips from "deep" to "padded".

**Why it happens:**
Skills additions feel costless — they're on page 2, they're comma-separated, they don't disturb layout. And the coverage checklist from Phase 3 creates pressure to dump every uncovered term here.

**How to avoid:**
- **Hard cap: 3 rendered lines** (wiki: *"Use 3 lines or less, in a single column format"*). Current is 4 — so the stretch starts from a **deficit**, and every addition must displace something. That constraint is what forces quality.
- **Order most→least important** and apply the wiki's own follow-up test: *"Consider whether the ones at the end should even be there."* Present-day candidates for removal: `Django`, `Matplotlib`, `Sklearn`, `Tensorflow`, `Faiss`, `AWS Sagemaker` — none of which serve a Staff MLE inference-framework thesis, while `Rust`, `Kubernetes`, `Iceberg`, `DuckDB`, `ONNX Runtime`, `Triton`-adjacent terms and `torch.compile` do.
- **Enforce the bullets↔skills invariant** (wiki: *"Repeat things that you use in your bullet points. If you have Java in your skills, your bullet points in job descriptions should include Java, and vice versa"*). A skill with no bullet anywhere is the definition of padding. Exception, deliberately taken by this milestone: the user-approved adjacent-tech stretch — which is exactly why it needs the interview-defence gate in Pitfall 10, not a formatting gate.
- **Rename the section to `Skills`** (wiki: *"This section should simply be named Skills, not 'Technical Skills'"*) — also the more standard heading for parsers keying on canonical section names. One-word change, zero risk.
- Split slashed pairs (wiki: *"Use 'C, C++' not 'C/C++'"*) so each is an independently indexable token. Applies to `Frameworks/Libraries/Tools` sub-labels too.

**Warning signs:**
- Skills renders to 4+ lines after the stretch.
- An item appears in Skills and nowhere else on the resume *and* the user hasn't explicitly signed off on it.
- The list is alphabetical or grouped-by-vendor rather than ordered by relevance.

**Phase to address:** Phase 4, with the line-count assertion in Phase 0.

---

### Pitfall 10: "Defensible" is self-assessed rather than tested

**What goes wrong:**
`PROJECT.md` permits Skills to include "adjacent tech the user can defend in interviews." Without a concrete test, "can defend" silently degrades to "have read about". Then a staff loop asks the obvious follow-up and the answer is thin — which damages credibility for the *whole* resume, because the interviewer now discounts the evidenced claims too. That contagion is the real cost, and it is asymmetric: one unsupportable item taints twenty supportable ones.

**Why it happens:**
The honesty boundary in `PROJECT.md` is drawn at the right place (bullets = commit-evidenced; skills = defensible) but "defensible" has no operational definition, and the person judging it is the person who wants the keyword.

**How to avoid:**
Define a **two-question standard** for every stretch item and record the answers in the approval artifact:
1. *"Can you describe one specific thing you did with this, including a decision you made and its tradeoff?"*
2. *"Can you name one way it fails or one thing it's bad at?"*
An item that survives both is defensible; an item that survives only the first is recognition, not experience — cut it. Attach a **tier label** in the planning record (not on the resume): `built` / `operated` / `evaluated`. Only `built` and `operated` items enter Skills. This makes the user's approval a *review of evidence* rather than a yes/no on a list.

**Warning signs:**
- The approved list is longer than the list of items the user volunteered a specific story for.
- Any of `TensorRT`, `TRT-LLM`, `CUDA graphs`, `speculative decoding`, `quantization`, `MoE`, `tensor parallelism`, `pipeline parallelism` appears — `CODEBASE-EVIDENCE.md` marks all of these as no-evidence, and they are exactly the terms a staff inference-framework interviewer will open with.
- Approval happens as a single "looks good" on a finished list rather than item-by-item.

**Phase to address:** Phase 4 (the gate is the phase's checkpoint, not an afterthought).

---

### Pitfall 11: Blurring "built on X" into "built X" — the operated-vs-authored line

**What goes wrong:**
Compression pressure turns precise claims into ambiguous ones, and ambiguity always resolves upward in the reader's mind. `CODEBASE-EVIDENCE.md` is explicit about where the lines are, and each has a safe and an unsafe rendering:

| Evidence | Safe | Unsafe (implies internals work) |
|---|---|---|
| vLLM — operated / platform context | "built online inference **on** vLLM + Ray" | "optimised vLLM", "vLLM internals", "tuned the vLLM scheduler" |
| FSDP/FSDP2 — built modules for, ran multi-node | "designed a plugin-based strategy pattern **over** FSDP/FSDP2" | "implemented FSDP", "wrote FSDP sharding" |
| `torch.compile(mode="max-autotune")` — his, in production | "introduced `torch.compile` max-autotune on the CLIP encoder + classifier in production" | "optimised torch.compile", "worked on Inductor" |
| Flash Attention 2/3, context parallelism | "**integrated** Flash Attention 2/3 and context parallelism for DiT text-to-image/video training" | "implemented Flash Attention", "wrote the attention kernels" |
| ONNX Runtime CUDA EP — his | "built the CAI fingerprint embedding generator on ONNX Runtime CUDAExecutionProvider" | "optimised ONNX Runtime", "wrote a CUDA EP kernel" |
| Styx OTel Rust instrumentation — **branch-only prototype** | "prototyped" / "designed" | "shipped", "rolled out" |
| ff-data-engineering access-monitoring — **unmerged branch** | "in progress" or omit | any completed-work verb |
| asml DAG scaffold, ff-data-ingestion skeleton — **teammates authored** | "hardened", "owned reliability of", "root-caused" | "built the pipeline", "created the DAGs" |
| Ray Data benchmark — **his module**, others' engine + doc | "his AIDE module benchmarked on the Ray Data engine at 109 rows/s over 1.09M rows on 8×A100" | "benchmarked Ray Data", "built the Ray engine" |

**Why it happens:**
The honest verb is usually longer than the dishonest one, and page 1 has zero slack (measured) — so every editing pass applies pressure in exactly the wrong direction. `built on X` → `built X` saves 3 characters and changes the claim entirely.

**How to avoid:**
- Maintain a **verb→evidence-tier map** as a reviewable artifact: `built/designed/implemented` require authored code; `integrated/introduced/adopted` mean wired an external component in; `operated/ran/tuned configs for` mean execution without authorship; `prototyped/designed` for branch-only work; `hardened/owned/root-caused` for inherited systems.
- Phase 2 review question, per bullet: **"if an interviewer reads this and asks me to walk through the internals, is that a fair reading of my sentence?"** If yes and you can't, the verb is wrong.
- **Preserve the currently-safe phrasings.** `main.tex:154` ("Built online inference **on** vLLM + Ray") and `main.tex:160` ("strategy pattern **over** FSDP/FSDP2") are already correct — the risk here is a *regression* introduced by the rebuild, not an existing defect. Diff the verbs specifically.
- Watch two live overreaches while rewriting: `main.tex:151` "**Leading** parts of the org's MLOps platform" and `main.tex:152` "Designed and **led engineering for** the org's online and offline inference systems" — `CODEBASE-EVIDENCE.md` supports substantial ownership of `styx_enrichment`, Glimmer module onboarding and the Content Gate subsystem, but "the org's ... systems" claims org-wide scope that the evidence does not itemise. Keep leadership language attached to the **named** things he led.

**Warning signs:**
- A verb changed in the diff without the evidence changing.
- Any bullet where the subject of the sentence is a framework rather than a system he built.
- The word "optimized" adjacent to a third-party project name.

**Phase to address:** Phase 2 (primary), re-audited in Phase 7.

---

## (d) Senior → Staff repositioning

### Pitfall 12: Bullets that inventory scope instead of demonstrating impact

**What goes wrong:**
The current Adobe block is 16 `\resumeTopic` entries of the form **`Bold Topic`: description of what the thing is**. That is a *catalogue of surface area*, which reads as senior-level breadth: "I was near a lot of systems." Staff-level reading wants the opposite shape — fewer items, each with a problem, a decision under ambiguity, and a consequence. As it stands `Enrichment Service` and `Data Quality Framework` describe **what the component does**, not what changed because he did it.

**Why it happens:**
The topic-colon-description form is genuinely efficient at packing scope into limited space, and it *feels* senior because it lists a lot. The wiki names the trap directly: *"Simply listing job duties will not make your resume any different from others: your resume is not your job description."*

**How to avoid:**
- Apply **STAR/CAR/XYZ** — "Accomplished [X] as measured by [Y] by doing [Z]" — and the wiki's placement rule: *"If you're able to quantify your achievements/results, move the metrics towards the start of each bullet."* Front-loaded numbers survive a 6-second scan; trailing numbers don't.
- `CODEBASE-EVIDENCE.md` supplies numbers most engineers don't have — **use them as bullet openers**: 202.6M-row migration; 24.8M video clips across 618 shards on a 16-pod Indexed Job; ~700M-asset catalog growing 35–38M images/month; 24×A100-40GB per job × 9 queues; **64 H100s** in a parallel enrichment wave; 40-node daily EMR; 160-executor Spark steps; +27,135-line Rust governance subsystem with a 9,722-line integration test; **a root-caused 6-week silent outage** plus the CI smoke test that would have caught it.
- The wiki's 10+-YoE guidance is specifically about **influence, not just output**: *"Mention not only your impact but also your influence"* and *"Mention 'soft' achievements on top of the business results."* Staff-flavoured evidence already present: "introduced `torch.compile(max-autotune)`" (a technical direction others adopted); a training framework "adopted across the org"; the frozen **cross-runtime contract document** (422 lines) — a contract other teams must build against is textbook staff-scope artifact; the **"Simplica-free" architecture migration** he led.
- Also apply Will Larson's staff-project characteristics as a **selection filter** for which 3–4 items get depth: *complex and ambiguous*, *numerous and divided stakeholders*, *a named bet where failure matters*. Content Gate (cross-runtime contract, immutable evidence, lineage — many consumers, high failure cost) and the enrichment/inference platform both qualify. The Data Quality Framework probably doesn't and should compress to a clause.

**Warning signs:**
- More than ~5 topics under Adobe.
- A bullet that would be equally true of a teammate on the same team.
- Numbers at the end of bullets, or absent.
- Every topic gets equal weight — no visible thesis.

**Phase to address:** Phase 2.

---

### Pitfall 13: "Ten years that reads like five" — old roles keeping their page-1 real estate

**What goes wrong:**
Swiggy (4 topics + 2 sub-bullets), Flipkart (4 topics + 1 sub-bullet), Groupon and NetSpeed together occupy a large share of page 1. Two costs: (i) with zero measured slack, they are directly competing with the Adobe rebuild for space; (ii) proportional weighting tells the reader that 2015–2019 work is comparably important to 2024–present work, which flattens the seniority arc — the resume reads as "a series of similar jobs" rather than "escalating scope".

**Why it happens:**
Existing content is sunk cost and reads fine in isolation. Nobody's job in the milestone is "delete good old content", so it survives by default — and then the Adobe section gets squeezed instead.

**How to avoid:**
- Wiki, 10+ YoE: *"Make your earlier work experiences more concise."* Concretely: NetSpeed and Groupon → one line each (they are already 1 topic each; drop to a single compressed clause). Flipkart → collapse the `ML Workflow Automation` sub-bullet into its parent. Swiggy → keep the online-inference-platform topic (it is genuinely on-thesis: online inference serving 18M+ users) and its strongest sub-bullet; compress `DAQ` and `Forecasting`.
- Budget explicitly: Adobe should hold the clear plurality of page-1 lines. **Write the target line allocation into the phase plan before editing**, so space is granted rather than fought over.
- Note the thesis test: Swiggy's online-inference-platform and Flipkart's runtime-DAG-generating Airflow framework both *support* the inference/platform narrative. Keep the on-thesis old content and cut the off-thesis old content — don't cut uniformly by age.

**Warning signs:**
- Adobe has fewer page-1 lines than the pre-2021 roles combined.
- The Adobe rebuild gets trimmed to fit while older roles are untouched.
- No line-allocation target exists.

**Phase to address:** Phase 2 (allocation set here, since it is the phase that needs the space).

---

### Pitfall 14: Narrative dilution — five co-equal Adobe topics and no thesis

**What goes wrong:**
The Adobe block currently presents `Distributed Inference Frameworks`, `Foundation Model Training Framework`, `Build & Deployment System`, `Enrichment Service`, and `Data Quality Framework` at equal weight. For an inference-framework role this reads as a generalist platform engineer, not an inference specialist. Training frameworks, build systems and data quality are all *evidence of range* — and range, presented co-equally, actively competes with depth.

**Why it happens:**
Everything in the list is true and was real work; cutting or subordinating any of it feels like discarding accomplishment. And keyword coverage creates pressure to keep every topic as a keyword host.

**How to avoid:**
- Pick **one thesis sentence** for the Adobe block — e.g. *fault-tolerant distributed GPU inference at ~700M-asset scale* — and make each retained topic either **serve** it or **compress** to a supporting clause.
- Suggested shape: inference (lead, deepest); fault tolerance / reliability (elevate from where it is scattered — lease/TTL heartbeats, DLQs, circuit breakers, idempotent re-runs, checkpoint caches, the STS assume-role storm fix — this maps *directly* onto the JD's "fault-tolerant high-concurrency" and is currently under-represented); scale numbers as a spine through both; then training framework + Rust control plane / governance as demonstrated range in one or two lines each.
- Explicitly do **not** delete the range — subordinate it. Staff readers want a specialist who can operate broadly, which is a different signal from a generalist.

**Warning signs:**
- Nobody can state the Adobe thesis in one sentence.
- Five topics of similar length.
- "Fault tolerance" appears nowhere as an organising idea despite being one of the strongest evidenced themes.

**Phase to address:** Phase 2.

---

### Pitfall 15: Title inflation, or its opposite — pre-emptive self-demotion

**What goes wrong:**
Two symmetric failures. (i) The printed title drifts toward "Staff" or a hedge like "Senior/Staff MLE" to match the target level — which is a factual misstatement that employment verification will contradict. (ii) Overcorrection: the resume so scrupulously avoids leadership language that genuine staff-scope work (org-wide framework adoption, cross-runtime contracts, leading an architecture migration) is buried, and the resume argues *against* the level being targeted.

**Why it happens:**
(i) The gap between current and target title feels like the thing standing in the way. (ii) A strong honesty constraint, applied without a positive rule, biases toward understatement.

**How to avoid:**
- `PROJECT.md` already bars title changes — make it a **build assertion** (Pitfall 3): printed titles byte-identical to baseline.
- The **level argument lives in scope language, not the title.** You do not need the word "Staff" anywhere; you need bullets whose scope reads as staff. That is Pitfall 12's job.
- Do not invent a fake scope descriptor either. The existing parenthetical `(ML Platform & Frameworks)` is a truthful specialisation marker and is doing useful work — keep it.

**Warning signs:**
- Any variant of "Staff" near the Adobe title.
- A slash-hedged title.
- Zero leadership/influence language anywhere despite evidence supporting it.

**Phase to address:** Phase 0 (assertion), Phase 2 (scope language), Phase 6 (site must not inflate either).

---

## (e) LaTeX / ATS parsing failures specific to this document

### Pitfall 16: Zero literal URLs in the text layer — and a corrupted LinkedIn handle

**What goes wrong:**
Two measured defects, one silent and one outright broken.

1. **No URL is recoverable from text.** Every link is `\href{URL}{\underline{anchor text}}`, and the anchors are masked: `Linkedin@ashutosh--tiwari`, `Homepage/Portfolio`, `Github@thunderock`. The 26 `/URI` annotations exist but live inside **compressed object streams** (PDF 1.7 objstm). A parser reading the text layer only — the common case — gets **no** LinkedIn URL, **no** GitHub URL, **no** portfolio URL. For a candidate whose portfolio site is a milestone deliverable, this means the site is invisible to exactly the pipeline that is supposed to reach it.
2. **The visible LinkedIn handle is wrong.** `linkedin.com/in/ashutosh--tiwari` contains a double hyphen; LaTeX renders `--` as an **en-dash**, so the anchor text renders and extracts as `Linkedin@ashutosh–tiwari` (U+2013). The link still works when clicked; anyone who reads, retypes, or copies the extracted handle lands nowhere. `\pdfgentounicode=1` does not help — it faithfully maps the en-dash glyph, because the en-dash is genuinely what was typeset.

**Why it happens:**
Masking links behind pretty anchor text is standard LaTeX-resume practice and looks better than a raw URL. The `--` ligature is a classic LaTeX gotcha that is invisible unless you compare rendered text to the source string character by character.

**How to avoid:**
- Wiki, unambiguously: *"Don't mask your email address, GitHub profile, and portfolio website"*; *"Write out your email address, GitHub profile, and portfolio website in plain text"*; *"Don't include https://www. for your URLs"*; and *"Don't underline, italicize, or color your email address/GitHub URL/portfolio URL."* So the header should read `linkedin.com/in/ashutosh--tiwari` · `github.com/thunderock` · `thunderock.github.io` as literal text — keeping the `\href` for clickability but making the anchor the URL itself.
- Fix the ligature with `\mbox{ashutosh-{}-tiwari}` or `\texttt{}`/`\detokenize`, then **assert the exact string** in extracted text. Do not rely on visual inspection — an en-dash and two hyphens look nearly identical at 9pt.
- Phase 0 assertion: extracted text must contain `linkedin.com/in/ashutosh--tiwari`, `github.com/thunderock`, `thunderock.github.io`, and `findashutoshtiwari@gmail.com` as literal substrings.
- Note the space cost is ~zero: these strings are comparable in length to the current anchors, and they sit in the header (page 1, but above the Experience block) — verify against the fit assertion anyway.

**Warning signs:**
- `grep -oE '(https?://|linkedin\.com|github\.com)' <(pdftotext resume.pdf -)` returns nothing (**current state**).
- The rendered handle contains `–` where the URL contains `--` (**current state**).

**Phase to address:** Phase 0 (assertions), fixed in Phase 6 alongside the site sync — it is the same "is my site reachable" concern.

---

### Pitfall 17: En-dash bullet markers and three-level nesting that flattens

**What goes wrong:**
`\labelitemiii` is redefined to `\textendash` (`main.tex:114`), and article's `labelitemii` is already an en-dash — so **every** bullet at both levels is `–` (U+2013). Two consequences: (i) `–` is not one of the conventionally-recognised bullet markers, so a parser may keep it as literal leading text (each bullet begins with a stray dash) or, in a date-hunting pass, misread it as a range separator; Jobscan's safe-separator list is specifically `|`, `•`, and commas. (ii) The visual three-level hierarchy (`role → topic → sub-bullet`) **flattens to a single level** in extraction — I verified sub-bullets under `Distributed Inference Frameworks` come out indistinguishable from the topics above them, so the logical grouping a human sees is not present in the parsed text at all.

**Why it happens:**
The en-dash was chosen for looks (`main.tex:113` comment: "a small en-dash for a clean look"). Nesting depth accreted as content grew. Neither defect is visible without extraction.

**How to avoid:**
- Switch bullet markers to `\textbullet` at both levels. Purely cosmetic in LaTeX, removes the literal-dash and range-separator ambiguity, and matches the guidance. Verify with extraction that page-1 fit is unchanged (marker width differs slightly).
- **Reduce to two levels.** Wiki: *"Avoid the excess use of sub-bullet points — they can clutter your resume, making it more verbose and harder to read."* This also serves Pitfall 12 (fewer, deeper items) and Pitfall 13 (space). Since level-3 doesn't survive extraction anyway, you are giving up nothing machine-readable.
- **Free win, already proven:** drop `\justifying` from `\resumeItem` and `\resumeTopic`. I built this variant — identical pagination and **byte-identical extraction** in both modes, so there is literally no risk. It satisfies the wiki's and Stanford's guidance (*"Don't justify your text since it creates inconsistent spacing between words"*) at zero cost. Bullets fall back to the document's global `\raggedright`.

**Warning signs:**
- Extracted bullets start with `–`.
- Sub-bullets and topics are indistinguishable in extracted text (**current state**).

**Phase to address:** Phase 2 (nesting reduction happens during the rewrite), Phase 0 (marker + fit assertions).

---

### Pitfall 18: Trusting one extractor — the default-vs-stream-order divergence

**What goes wrong:**
The document is checked with one tool, it looks fine, and the check is declared passed. But the *same* PDF produces materially different text depending on extraction strategy. Default poppler mode gives clean prose. Content-stream order (`pdftotext -raw`) **glues words together**: `ADOBEFIREFLY`, `MASTEROFSCIENCEINCOMPUTATIONALDATASCIENCE`, `SeniorMachineLearning`, `Falcon-40BandLlama270B`, `Aug. 2021–May2023`. Under that extractor the token `Adobe` does not exist — a Boolean search for `Adobe` would not retrieve this candidate, and the degree name is unsearchable.

**Why it happens:**
One tool, one mode, one pass. And the failure is counter-intuitive: the *simpler* extraction mode is the one that fails, so a passing check in the sophisticated mode gives false confidence.

**How to avoid:**
- Phase 0 harness runs **at least two modes** (poppler default + `-raw`) and reports both. Treat default-mode as the assertion target and `-raw` as a **monitored worst case** — do not gate the build on `-raw`, because it is not fixable in LaTeX.
- **Do not chase the gluing with LaTeX changes.** I tested the obvious hypothesis — that `\justifying`'s variable inter-word glue caused it — and it is **false**: removing `\justifying` left `-raw` output byte-identical. The gluing is an extractor limitation in how pdfTeX's kerned `TJ` arrays are interpreted, not a document defect. Spending the milestone's budget here would be waste.
- Calibrate severity honestly: Orosz's recruiters describe parsing as "basic" auto-fill plus indexing, and mainstream ATS parsers use library stacks closer to the layout-aware default than to naive stream order. So `-raw` is a tail risk worth *knowing about*, not a blocker.
- Cheap real-world proxy for the whole class: paste the PDF into a plain-text field (or run it through any resume-parsing preview) once at Phase 7 and read what comes out.

**Warning signs:**
- The verification step names exactly one command.
- "It parses fine" asserted without naming which extractor.

**Phase to address:** Phase 0 (build the two-mode harness), Phase 7 (final read-through).

---

### Pitfall 19: Page-2 orphaning of the section keyword search most needs

**What goes wrong:**
Skills, Education, Publications, Projects all live after the explicit `\newpage` (`main.tex:219`). Jobscan's worked example shows a parser that "picked up the work experience section, but ignored everything else. No skills, no 'About' section, no contact info, and no links to work samples." If page 2 is partially dropped or its section headings aren't recognised, the milestone's entire Phase 4 output — the stretched Skills list — evaporates from the index, along with the Master's that partially covers the gap.

**Why it happens:**
The two-page structure is a deliberate, sensible design (`PROJECT.md` validates it), and page-2 content renders perfectly. The risk is invisible from the author's side.

**How to avoid:**
- **Don't restructure** — the wiki explicitly sanctions two pages at this level (*"If you decide to go with a second page, you should be in the position to at least be considered for a senior/staff role"*), and page-1 has zero slack so there is nowhere to move content to.
- **De-risk instead.** (i) Assert in Phase 0 that page-2 text extracts and that each section heading appears (`SKILLS`, `EDUCATION`, `PUBLICATIONS`, `SELECTED PROJECTS`) — currently verified working. (ii) Rely on **redundancy**: every Phase 3 keyword that matters must have at least one **page-1** placement (a bullet), so page-2 Skills is reinforcement rather than sole carrier. This is the same rule as Pitfall 5's "prefer bullets over the skills list", now motivated by page position as well as human weight.
- Keep the section names canonical and unstyled in wording — the small-caps rendering is fine (it extracts as literal uppercase, verified), but do not rename sections to anything creative.

**Warning signs:**
- A Phase 3 target keyword exists only in the page-2 Skills list.
- Page-2 headings absent from extracted text.

**Phase to address:** Phase 0 (assertion), Phase 3 (page-1 redundancy rule).

---

## (f) Colour and design

### Pitfall 20: A palette change that breaks contrast, grayscale, or leaves dead colour definitions

**What goes wrong:**
A new accent is picked on screen aesthetics and one of four things breaks: (i) it drops below readable contrast for the **text** it is applied to (the current `accentdark` carries the name, all section headings, every job title, and every link — it is body-weight text, not decoration); (ii) it collapses in grayscale, so the printed copy an interviewer carries into the room has washed-out headings; (iii) the 1pt/2pt rules become invisible; (iv) `accentlight` (`main.tex:19`) is left at its old teal because it is **currently unused** and nobody notices — a latent inconsistency that surfaces the first time someone uses it.

**Why it happens:**
Palette selection is evaluated as a screen-rendered PDF on a bright display. Grayscale conversion and contrast ratios are never computed, and an unused colour definition is invisible to review.

**How to avoid:**
The current palette sets a measured bar to hold. Make these **numeric acceptance criteria** for Phase 5:

| Criterion | Threshold | Current value |
|---|---|---|
| Any accent used on **text** vs white | **≥ 7:1** (WCAG AAA) | `accentdark` #0E463E = **10.69:1** ✓ |
| Any accent used on **rules/lines** vs white | **≥ 3:1** (WCAG non-text) | `accent` #17685C = 6.62:1 ✓ |
| Grayscale (BT.601 luma) of text accent vs white | **≥ 4.5:1** | `accentdark` → #343434 = **12.45:1** ✓ |
| Grayscale of rule accent vs white | **≥ 3:1** | `accent` → #4E4E4E = 8.32:1 ✓ |
| Unused colour definitions | **0** | `accentlight` is dead — use it or delete it |

- Render each proposal **and a grayscale conversion of it**, per `PROJECT.md`'s "rendered as PDF samples" requirement. Judge on both.
- Note the current two accents differ by only **1.61:1**, so any proposal built on "a dark tone and a lighter tone of the same hue" is really a single-tone system. That's fine — just don't rely on the pair reading as distinct.
- Wiki caution to respect: *"Don't use grey-colored fonts since they're hard to read. Stick to black. Make sure to use a color that is printable in grey-scale."* A saturated dark accent at 10:1+ is a defensible deviation from "stick to black"; a mid-tone accent is not.
- **Recruiter-bias caveat, MEDIUM-LOW confidence:** I did not load a recruiter survey on colour preference at senior+ levels. The conservative reading of the sources I did load is that restrained single-accent colour with strong contrast is uncontroversial, while multi-colour or decorative design is not. `PROJECT.md`'s fallback ("teal stays if none win") is the right default — the current palette already clears every measurable bar, so **the burden of proof is on the challenger.**

**Warning signs:**
- A proposal evaluated only as a colour swatch, not as a rendered + grayscaled PDF.
- Any accent applied to text below 7:1.
- `accentlight` unchanged in the palette diff.

**Phase to address:** Phase 5, with the contrast/grayscale check automated in Phase 0.

---

### Pitfall 21: Style collisions the guidance specifically warns against

**What goes wrong:**
The document stacks emphasis mechanisms that are meant to be used alone. `\resumeSubheading` renders argument 3 as `\textit{\small ...}` while the content is typed in **ALL CAPS** (`ADOBE FIREFLY`, `MASTER OF SCIENCE IN COMPUTATIONAL DATA SCIENCE`) — italic + all-caps together. Argument 1 is bold + coloured. Links are coloured **and** underlined. The wiki is explicit on all three: *"Avoid excessive italicization, bolding, and ALL CAPS. If you do use one, use it independently of each other"*; *"Italicization, ALL-CAPS, and bolding, if used, should be used independently"*; *"Don't italicize text since it can decrease the readability"*; *"Don't underline, italicize, or color your email address/GitHub URL/portfolio URL."* Cumulatively the header region has four emphasis signals competing, which flattens hierarchy rather than creating it.

**Why it happens:**
Each was added separately and looks fine on its own. The interaction is what's wrong, and interactions don't show up in a per-change review.

**How to avoid:**
- Pick **one** signal per element: employer = ALL-CAPS **or** italic, not both (dropping italic from the all-caps line is the cheaper, higher-readability choice); title = bold + colour is acceptable as the single strongest element; links = colour **or** underline, not both (drop `\underline`, keep `accentdark` — and per Pitfall 16 the contact-line URLs should carry neither).
- Treat the 16 bold `\resumeTopic` lead-ins as a **deliberate tradeoff, not a rule violation.** The wiki says *"Don't bold keywords within your bullet points, it's distracting"*, but bold topic lead-ins are a widely used and genuinely skimmable pattern for dense senior resumes. Keeping them is defensible; keeping them *and* reducing their count (Pitfall 14) is better, because 16 bold anchors is past the point where bold still means "look here".
- Removing `\underline` and one italic layer also buys a small amount of horizontal room — relevant given zero page-1 slack.

**Warning signs:**
- More than two emphasis mechanisms on any single line.
- Underlined coloured text anywhere.

**Phase to address:** Phase 5 (it is the styling phase), with the link change coordinated with Phase 6.

---

## (g) One-page-fit pressure

### Pitfall 22: Buying space with font/margin tricks instead of with editing

**What goes wrong:**
Page 1 is **full to the exact bottom of its text block** — measured 27.7pt bottom whitespace against a symmetric 27.3pt top, i.e. **zero free lines**. So the first added line overflows, and the reflexive fixes are all damaging: shrinking the body font below ~10pt; widening `\textwidth` further (already `+1in` beyond `fullpage`, giving ≈0.4in side margins — at or past the wiki's *"minimum 0.4 inches"* floor); compressing `itemsep`/`topsep` to zero; adding `\vspace{-Xpt}` hacks; or relying on justification to squeeze a wrapped word back onto a line. Each trades legibility for room, and the margin/leading changes actively degrade the 6-second scan the resume exists to survive.

**Why it happens:**
The overflow is discovered *after* the content is written and loved, at which point formatting feels like the only remaining lever.

**How to avoid:**
- **Spend the measured budget, don't manufacture one.** Removing the career-break block frees exactly **50.0pt ≈ 4.5 lines at the document's 11.0pt line height**. That is the whole allowance for Phase 2 + Phase 3 additions on page 1, before any old-role compression (Pitfall 13) is credited.
- **Sequence matters:** do Phase 1 (removal) and the Pitfall 13 compressions **before** Phase 3 additions, so there is real space to add into. Adding first and cutting later guarantees a panic edit.
- Phase 0 assertion, as a hard gate: **page count == 2**, `Experience` content confined to page 1, and page-1 bottom whitespace ≥ the current 27.7pt — so the fit constraint cannot be met by eating the bottom margin.
- Assert the **geometry itself is unchanged**: no diffs to `\oddsidemargin`, `\evensidemargin`, `\textwidth`, `\topmargin`, `\textheight`, or the `\setlist` spacing values. Force space to come from words.
- Legitimate space wins available for free: drop `\underline` from links; drop `\justifying` (proven zero-impact); collapse level-3 sub-bullets into their parents; remove the month periods (`Jul.` → `Jul`, per wiki — tiny but also correctness); fix the *"Don't spill bullets onto the following line with only 1–4 words on it"* orphans.

**Warning signs:**
- Any geometry or `\setlist` value in the diff.
- Body font below 10pt.
- A `\vspace{-...}` appearing to "just make it fit".
- PDF page count becomes 3.

**Phase to address:** Phase 0 (gate), sequencing enforced across Phases 1→3.

---

### Pitfall 23: Cutting the quantified impact and keeping the descriptive filler

**What goes wrong:**
When the fit gate fails, the easiest lines to delete are the longest ones — which are precisely the ones carrying numbers and mechanism (`10–50× faster image loading and 3–8K images/sec on 32 GPUs`, the scale figures, the reliability specifics). Meanwhile short descriptive lines survive because they're cheap (`Cyclops: Worked on Cyclops, an interface between Customer Representatives and internal services`). The resume gets shorter and simultaneously weaker — the exact inversion of the milestone's goal.

**Why it happens:**
Cutting is optimised for bytes-per-edit rather than value-per-line. Long, dense, quantified bullets have the best value-per-line and the worst bytes-per-edit.

**How to avoid:**
- **Rank before cutting.** Score every page-1 line on (a) carries a number, (b) supports the inference-framework thesis, (c) is commit-evidenced. Cut from the bottom of that ranking. Wiki: *"Bullet points should be ordered from most relevant/impressive to least"* and *"put your best stuff first."*
- **Protect the numbers explicitly.** Phase 0 can assert a floor: the count of digit-bearing bullets on page 1 must not decrease across the milestone. Crude, but it makes the failure mode loud.
- Pre-designate the cut list in the phase plan — Groupon's `Cyclops` line, NetSpeed compression, `DAQ`, `Forecasting & Correlation Platform`, the Flipkart sub-bullet — so the decision is made calmly rather than under gate pressure.

**Warning signs:**
- A bullet containing a metric appears in the deletion diff.
- Page-1 digit-bearing bullet count drops.
- Cuts are chosen by line length.

**Phase to address:** Phase 2 (cut list decided up front), Phase 7 (verify the floor held).

---

## (h) Resume ↔ site ↔ LinkedIn consistency

### Pitfall 24: Three artifacts telling three different stories

**What goes wrong:**
The resume gets a staff-level inference-framework thesis; `index.html` still carries the old framing (it contains `Senior Machine Learning Engineer` in **3 places**, plus hero/about copy); LinkedIn carries a third version — and it is the one place the **career break may still be listed as an entry**. A recruiter who cross-references sees: a resume with an unexplained 2021–2024 gap, a LinkedIn that fills it with a career-break entry the resume omits, and a portfolio describing a different scope of work. The discrepancy becomes the topic, and it reads as inconsistency at best.

**Why it happens:**
`PROJECT.md` scopes LinkedIn **out** ("Cover letters / LinkedIn profile rewrite — separate artifact, separate effort") — which is a reasonable scope decision but leaves the highest-visibility surface unaligned. And `index.html` sync is scoped to "hero/about text", so occurrences elsewhere in a 42KB file can be missed.

**How to avoid:**
- **Sweep, don't spot-edit.** Phase 6 must enumerate *all* occurrences (3 title strings plus experience-section copy), not just the hero. Add a Phase 0/7 consistency check: the title string, employer names, and date ranges present in `index.html` must not contradict the PDF.
- **Keep the title truthful in all three.** `Senior Machine Learning Engineer` is correct and stays. Sync the *positioning* (what he specialises in and the scale he works at), not the title. This is the same boundary as Pitfall 15.
- **Make the LinkedIn decision explicit even though it's out of scope.** The minimum viable action is not a rewrite: it is deciding whether LinkedIn's 2021–2024 presentation *contradicts* the resume, and if so, adding a one-line follow-up to the backlog. Note the asymmetry in the reference guidance — the wiki argues LinkedIn URLs on a resume are unnecessary because *"if they want to find you on LinkedIn, they can simply search your name"*; that cuts both ways, since it means recruiters **will** find the profile whether or not you link it.
- Scope claims must match: if the resume says "led engineering for X", the site must not say "contributed to X" (or vice versa). Pick the evidenced wording once and reuse the same phrases.

**Warning signs:**
- `grep -c 'Senior Machine Learning Engineer' index.html` ≠ the number of places you edited.
- The site describes scope the resume doesn't claim, or vice versa.
- Nobody has looked at LinkedIn during the milestone.

**Phase to address:** Phase 6 (sweep + sync), Phase 7 (cross-artifact check), backlog item for LinkedIn.

---

### Pitfall 25: Rebuilding the Adobe section and silently losing true, strong claims

**What goes wrong:**
The rebuild is evidence-driven and additive-minded, so nobody diffs *what was removed*. Existing content that is both true and strong — the `10–50×` image-loading improvement, `3–8K images/sec on 32 GPUs`, `Falcon-40B` / `Llama 2 70B` model names, `KEDA`-autoscaled-on-SQS-depth, `Source → Transform → Sink` with no pod-to-pod communication — disappears in the rewrite. Net effect: a differently-worded section that is *weaker* than what it replaced.

**Why it happens:**
"Rebuild from evidence" invites starting from `CODEBASE-EVIDENCE.md` rather than from the current text, so anything the evidence file happens not to restate looks like it was never there. Some current claims (the `10–50×` figure, specific served model names) are **not** in `CODEBASE-EVIDENCE.md` — which does not make them false, only unverified by this particular mining pass.

**How to avoid:**
- Produce an explicit **retain / revise / retire** table for every current Adobe line before writing new text. Nothing gets dropped implicitly.
- For current claims absent from `CODEBASE-EVIDENCE.md`, ask the user directly rather than deleting or keeping by default. The `10–50×` / `3–8K images/sec` numbers are the most valuable quantified claims on page 1 and deserve an explicit keep-or-cut decision with a source.
- Phase 7 audit: diff old vs new Adobe text and justify every removal.

**Warning signs:**
- The new section has fewer numbers than the old one.
- No retain/revise/retire artifact exists.
- A quantified claim vanished without a recorded decision.

**Phase to address:** Phase 2 (build the table first), Phase 7 (removal audit).

---

# Technical Debt Patterns

Shortcuts that look reasonable during this milestone but cost later.

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|---|---|---|---|
| Delete the career-break row, add nothing | 4.5 lines freed; the awkward row is gone | Unexplained 36-month interval with no on-resume device; the question lands cold in every screen | Only if the gap posture is an explicit recorded decision (Pitfall 1) |
| Skip Phase 0; verify by looking at the PDF | Starts content work immediately | Every parse defect stays invisible; page-1 overflow found late, under pressure, fixed with formatting hacks | **Never** — five of the measured defects are invisible without extraction |
| Put unevidenced JD terms in Skills instead of bullets | Full keyword coverage, honesty boundary technically respected | Staff interviewers open on exactly those terms; one thin answer discounts the whole resume | Only for `built`/`operated`-tier items that pass the two-question test (Pitfall 10) |
| Grow Skills to 5–6 lines to host every keyword | Maximum index coverage in the cheapest space | Reader concludes nothing on the list is real; the strong items lose their signal | **Never** — 3 lines is the cap; displace, don't append |
| Buy page-1 space with margins/font/leading | Fit gate passes instantly | Degrades the 6-second scan the resume exists to survive; margins already at the 0.4in floor | **Never** — assert geometry unchanged |
| Keep `\justifying` because "it looks tidy" | Zero work | Contradicts the readability guidance for no gain | Free to remove — proven zero layout/extraction impact |
| Keep masked link anchors (`Homepage/Portfolio`) | Prettier header | Portfolio site is unreachable from the text layer — defeating Phase 6 | Only if literal URLs genuinely break page-1 fit (they don't; header is above Experience) |
| Sync only `index.html`'s hero, ignore LinkedIn | Milestone stays small and shippable | The most-viewed surface contradicts the resume, including on the gap | Acceptable **if** the contradiction check is run and a backlog item filed |
| Leave the `--`→en-dash LinkedIn handle | Nothing to do | Human-readable and extracted handle is broken today | **Never** — it is a live defect, one-line fix |
| Rebuild Adobe from the evidence file alone | Clean, fully-evidenced section | Silently drops the strongest existing numbers (`10–50×`, `3–8K img/s`) | Only with a retain/revise/retire table (Pitfall 25) |

---

# Integration Gotchas

Mistakes when the resume meets the systems that consume it.

| Integration | Common Mistake | Correct Approach |
|---|---|---|
| ATS resume parser (Greenhouse / Lever / Workday / iCIMS — 67% of detected market combined) | Believing it auto-rejects, and optimising against a score | It builds an inverted index for recruiter Boolean search and auto-fills fields; a human decides. Optimise for **term presence + clean field binding**, not score |
| ATS text extraction | Verifying with one tool in one mode | Run ≥2 modes; assert on layout-aware output, monitor stream-order as worst case |
| ATS structured fields (NER) | Assuming visual adjacency = parsed adjacency | Assert employer/title/dates land within a small line window; currently they don't |
| ATS link handling | Relying on `/URI` annotations to convey the portfolio | Put literal URLs in the **text**; annotations live in compressed object streams and text-only parsers never see them |
| Recruiter Boolean search | Assuming synonyms match | Presence is literal. `torch.compile` and `PyTorch compile` are different tokens — choose the form the JDs use |
| Plain-text application fields ("paste your resume") | Never testing it | Paste once at Phase 7 and read the result — cheapest real-world proxy for the whole parse-risk class |
| Grayscale printing | Judging colour on screen only | Render a grayscale conversion of every palette proposal; hold luma-contrast ≥ 4.5:1 for text accents |
| LinkedIn | Treating it as out of scope entirely | It is the surface recruiters reach *without* a link. Run a contradiction check even if the rewrite is deferred |
| `index.html` | Editing the hero and calling it synced | Sweep all occurrences (3 title strings + experience copy); assert no contradiction with the PDF |
| `make build` toolchain | Assuming a passing build means a good artifact | `latexmk` exit 0 says nothing about extraction, fit, contrast, or links. Add `make verify` |

---

# Scaling Traps

Things that work at the current content volume and break as content is added. *(Template's "Performance Traps", translated to this domain — the scaling axis here is content volume against fixed page space.)*

| Trap | Symptoms | Prevention | Breaks at |
|---|---|---|---|
| Page-1 overflow | PDF becomes 3 pages, or Experience spills onto page 2 above Publications | Spend only the freed 50.0pt ≈ 4.5 lines; cut before adding | **The very first added line** — bottom whitespace is 27.7pt against a 27.3pt top, i.e. the text block is full |
| Skills-list dilution | List exceeds 3 rendered lines; reader stops reading it | Hard 3-line cap; displace rather than append | ~25–30 items / 4th line |
| Topic proliferation under Adobe | 6+ bold lead-ins; no discernible thesis | One thesis sentence; subordinate the rest to clauses | Past ~5 topics |
| Bold-emphasis saturation | 16+ bold anchors on page 1; bold stops meaning "look here" | Reduce topic count (Pitfall 14); one emphasis signal per element | Already at 16 |
| Sub-bullet nesting | Level-3 items multiply; hierarchy invisible in extraction | Cap at two levels | Already — level 3 flattens today |
| Keyword repetition | Same term in summary + bullet + skills | One strong placement per term, bullet-first | 2nd occurrence (zero index gain) |
| Old-role creep | Pre-2021 roles hold more page-1 lines than Adobe | Written line-allocation target before editing | When Adobe loses plurality |

---

# Truthfulness & Verification Risks

*(Template's "Security Mistakes", translated: the adversarial checks here are employment verification and the staff interview loop.)*

| Mistake | Risk | Prevention |
|---|---|---|
| Adjusting an employment date to shrink the gap | Contradicted by payroll/HR verification; offer-rescission class, not awkward-conversation class | Build assertion: all five date strings byte-identical to baseline |
| Printing a title above the one held | Same verification exposure; also destroys trust on everything else | Build assertion on printed titles; argue level through scope language only |
| Inventing a consulting/freelance row | Interviewer probes for client, scope, outcome — none exist | `PROJECT.md` Out of Scope; no Experience row without a citable artifact |
| `built on X` → `built X` verb drift | Staff loop asks for internals ("walk me through the tensor-parallel setup") and the answer collapses | Verb→evidence-tier map; per-bullet fair-reading test; diff verbs specifically |
| Claiming branch-only work as shipped | Discoverable in review; contradicts the evidence file's own caveats | Styx OTel and ff-data-engineering access-monitoring stay `prototyped` / `in progress` / omitted |
| Claiming teammates' scaffolding | Reference checks and internal reviewers know who wrote what | asml DAG scaffold + ff-data-ingestion skeleton → `hardened` / `owned reliability of` / `root-caused` |
| Org-wide scope language | "the org's inference systems" over-claims relative to itemised evidence | Attach leadership language to the **named** systems he led |
| Invisible-text keyword stuffing | Appears verbatim in the recruiter-visible parsed record; instant credibility loss | Assert every extracted glyph is visibly rendered |
| Unevidenced JD terms in Skills without the defence test | The interviewer opens on exactly those terms | Two-question defensibility gate; `built`/`operated` tiers only |

---

# Reader-Experience Pitfalls

*(Template's "UX Pitfalls" — the user here is a recruiter or hiring manager doing a ~6-second scan.)*

| Pitfall | Reader Impact | Better Approach |
|---|---|---|
| Numbers at the end of bullets | The scan ends before reaching them | Front-load metrics (wiki: move metrics toward the start) |
| Topic-colon-description form | Reads as a job description, not accomplishments | STAR/CAR/XYZ: problem → action → measured result |
| Five co-equal Adobe topics | No thesis; reads generalist for a specialist role | One thesis, everything else subordinate |
| Gap with no acknowledgement anywhere on page 1 | Reader's first question is unanswered; assumes the worst | ≤2-sentence summary doing double duty (level + timeline) |
| Four emphasis mechanisms in the header | Hierarchy flattens; nothing stands out | One signal per element |
| Justified text | Uneven word spacing, rivers | Remove `\justifying` (free, proven) |
| Bullets wrapping to 1–4 orphan words | Wasted lines in a zero-slack budget | Tighten to whole lines |
| Masked link anchors | Reader can't see or retype the portfolio URL | Literal URLs as anchor text |
| Skills list of 40 items | "None of these are real" | ≤3 lines, ordered by relevance |

---

# "Looks Done But Isn't" Checklist

Run before declaring any phase complete.

- [ ] **Career-break removal:** often missing the *replacement* device — verify a summary exists **or** the no-summary gap posture is a written decision.
- [ ] **Gap mitigation:** often missing the arithmetic — verify the residual **~14 uncovered months** is stated, not just "Education covers it".
- [ ] **Education dates:** often missing extraction verification — verify `Indiana University` and `Aug 2021 – May 2023` are line-adjacent in `pdftotext` output (**fails today**).
- [ ] **Keyword pass:** often missing the extraction check — verify each target term is in `pdftotext` output, not just in `main.tex`.
- [ ] **Keyword pass:** often missing page-1 redundancy — verify no critical term lives only in page-2 Skills.
- [ ] **Skills stretch:** often missing the line cap — verify ≤3 rendered lines and section renamed to `Skills`.
- [ ] **Skills stretch:** often missing per-item sign-off — verify each stretch item has a recorded `built`/`operated` tier and two-question answers.
- [ ] **Adobe rebuild:** often missing the removal audit — verify a retain/revise/retire table exists and the `10–50×` / `3–8K img/s` claims got an explicit decision.
- [ ] **Adobe rebuild:** often missing verb discipline — verify `on`/`over`/`integrated` survived and no `optimised <third-party project>` appeared.
- [ ] **Contact header:** often missing the ligature fix — verify extracted text contains literal `ashutosh--tiwari` (two hyphens), not `ashutosh–tiwari` (**fails today**).
- [ ] **Contact header:** often missing literal URLs — verify `github.com/thunderock` and `thunderock.github.io` appear as text (**fails today**).
- [ ] **Palette change:** often missing grayscale — verify a grayscale render was reviewed and contrast thresholds computed, not eyeballed.
- [ ] **Palette change:** often missing `accentlight` — verify the dead definition at `main.tex:19` was updated or removed.
- [ ] **Page-1 fit:** often missing the margin check — verify bottom whitespace ≥ 27.7pt and **no geometry/`\setlist` diffs**.
- [ ] **Page-1 fit:** often missing the metric floor — verify the count of digit-bearing page-1 bullets did not drop.
- [ ] **Site sync:** often missing occurrences — verify all 3 `Senior Machine Learning Engineer` strings plus experience copy were reviewed.
- [ ] **Site sync:** often missing LinkedIn — verify a contradiction check ran (rewrite may stay deferred).
- [ ] **Whole milestone:** often missing the spoken answer — verify the off-resume screening-prep note exists and is **not** in the resume or on the site.
- [ ] **Whole milestone:** often missing the paste test — verify the PDF was pasted into a plain-text field once and the output read.

---

# Recovery Strategies

| Pitfall | Recovery Cost | Recovery Steps |
|---|---|---|
| Page-1 overflow discovered late | LOW | `git` revert the last content commit; apply the Pitfall 13 compressions; re-add within the 4.5-line budget. Cheap **only** because commits are atomic — which is why they must be |
| Parse defect found after sending applications | MEDIUM | Fix `main.tex`, rebuild, re-upload where the ATS allows resume replacement; re-apply where it doesn't. Prior submissions keep the defect permanently |
| Broken LinkedIn handle already circulated | MEDIUM | Fix + rebuild; the link itself always worked, so damage is limited to people who retyped it. Unrecoverable for already-sent copies |
| Unsupportable skill surfaced in an interview | HIGH | Not recoverable in that loop. Answer honestly ("used it, haven't built with it"), then remove the item before the next application. Prevention is the only real control |
| Date/title discrepancy found in verification | **VERY HIGH** | Effectively unrecoverable — offer-stage failure. Prevention (build assertion) is the only acceptable strategy |
| Palette shipped and looks wrong in print | LOW | One-line `\definecolor` revert; `PROJECT.md`'s "teal stays if none win" is the documented fallback |
| Quantified claim dropped in the rebuild | LOW | Recover from `git log` — the pre-milestone `main.tex` is the source of truth for what existed |
| Resume/site/LinkedIn divergence spotted by a recruiter | MEDIUM | Align immediately; expect to address it verbally in that process. Cheap to prevent, awkward to explain |
| Gap question fumbled in a screen | MEDIUM | Write the note, rehearse once, recover in the next screen. Not recoverable in the current one |

---

# Pitfall-to-Phase Mapping

| # | Pitfall | Prevention Phase | Verification |
|---|---|---|---|
| 1 | No replacement device for the gap | Phase 1 | Summary exists, or no-summary posture is a written decision |
| 2 | Over-trusting Education to cover the gap | Phase 0 detect / Phase 1 fix | Residual month count stated; institution↔dates line-adjacent in extraction |
| 3 | Date/title fudging, filler rows | Phase 0 assert / Phase 1 | 5 date strings + all titles byte-identical to baseline |
| 4 | No prepared spoken answer | Phase 1 draft / Phase 7 final | `screening-prep.md` exists; contains no resume-bound text |
| 5 | Keyword density over coverage | Phase 3 | Coverage checklist green against extracted text; no term ≥3× |
| 6 | Verbatim JD phrasing | Phase 2 + 3 | Every bullet traceable to `CODEBASE-EVIDENCE.md`; no verbatim JD sentence |
| 7 | Invisible-text stuffing | Phase 0 assert | Every extracted glyph visibly rendered; no white/phantom/negative-offset text |
| 8 | Header splits title/date/employer | Phase 0 detect / Phase 2 fix | Employer, title, dates within a small line window in extraction |
| 9 | Skills bloat | Phase 4 (+ Phase 0 assert) | ≤3 rendered lines; section named `Skills`; slashed pairs split |
| 10 | "Defensible" untested | Phase 4 checkpoint | Per-item tier + two-question answers recorded; zero prohibition-list terms |
| 11 | Operated→built verb drift | Phase 2 (+ Phase 7 audit) | Verb→tier map applied; `on`/`over` preserved; no `optimised <vendor>` |
| 12 | Scope inventory instead of impact | Phase 2 | Every retained topic has a metric or an influence claim; metrics front-loaded |
| 13 | Old roles holding page-1 space | Phase 2 | Written line allocation met; Adobe holds the plurality |
| 14 | Narrative dilution | Phase 2 | One-sentence thesis exists; ≤5 topics; fault tolerance elevated |
| 15 | Title inflation / self-demotion | Phase 0 assert / Phase 2 / Phase 6 | No "Staff" in titles; influence language present where evidenced |
| 16 | No literal URLs; broken LinkedIn handle | Phase 0 assert / Phase 6 fix | 4 literal strings present in extracted text incl. `ashutosh--tiwari` |
| 17 | En-dash bullets, 3-level nesting | Phase 2 / Phase 0 | Bullets are `•`; ≤2 levels; `\justifying` removed; fit unchanged |
| 18 | Single-extractor verification | Phase 0 build / Phase 7 | Harness reports ≥2 modes; Phase 7 paste test performed |
| 19 | Page-2 orphaning | Phase 0 assert / Phase 3 | Page-2 headings extract; every critical term has a page-1 placement |
| 20 | Palette breaks contrast/grayscale | Phase 5 (+ Phase 0 check) | 5 numeric criteria met; grayscale render reviewed; `accentlight` handled |
| 21 | Style collisions | Phase 5 (+ Phase 6 for links) | ≤2 emphasis mechanisms per line; no coloured+underlined text |
| 22 | Space bought with formatting tricks | Phase 0 gate; sequencing 1→3 | Pages == 2; bottom whitespace ≥ 27.7pt; zero geometry/`\setlist` diffs |
| 23 | Cutting metrics, keeping filler | Phase 2 cut list / Phase 7 | Page-1 digit-bearing bullet count did not decrease |
| 24 | Resume/site/LinkedIn divergence | Phase 6 / Phase 7 | All `index.html` occurrences swept; no contradiction; LinkedIn check run |
| 25 | Rebuild loses true strong claims | Phase 2 table / Phase 7 audit | Retain/revise/retire table complete; every removal justified |

**Recommended roadmap consequences:**

1. **Add Phase 0 (Parse & Fit Harness) before any content edit.** It is the verification for 14 of the 25 pitfalls. `PROJECT.md` does not currently list it; without it, "ATS-parsable" and "fits page 1 exactly" are opinions rather than gates. Concretely: extend the `Makefile` with `make verify`.
2. **Order Phase 1 and the old-role compressions before Phase 3.** Space must exist before content is added; the reverse order forces the formatting hacks in Pitfall 22.
3. **Make Phase 4's user approval a per-item evidence review**, not a sign-off on a finished list — it is the only control against Pitfall 10, whose failure mode lands in an interview rather than in the repo.
4. **Expect Phase 0 to fail on the current PDF.** Five defects are live today (Education order, detached dates, no literal URLs, en-dash LinkedIn handle, split role headers). That is the harness working, not a regression.

---

# Sources

**Primary — community standard for this exact document class**
- r/EngineeringResumes wiki, index — https://old.reddit.com/r/EngineeringResumes/wiki/index (formatting, dates, bullets, skills, senior/10+ YoE, contact info, accessibility). **HIGH** for norms; consensus-based, not vendor-driven; the milestone's document is a LaTeX resume of exactly the lineage this wiki targets.
- r/EngineeringResumes wiki, ATS page — https://old.reddit.com/r/EngineeringResumes/wiki/ats (curated source list). **HIGH** as a pointer set.

**ATS mechanics — the two sides**
- Gergely Orosz, *The Tech Resume Inside Out*, "Application Tracking Systems and ATS Myths Busted" — https://thetechresume.com/samples/ats-myths-busted. **HIGH** for the no-auto-reject and PDF-is-fine claims: quotes named tech recruiters (Amy Miller — Amazon/Google/Microsoft; Csudi Csudutov; José Marchena) and explicitly discloses that the opposing claims trace to resume-service vendors. Caveat: dated "as of 2020".
- Jobscan, "What Is an Applicant Tracking System? The Complete 2026 Guide" — https://www.jobscan.co/blog/8-things-you-need-to-know-about-applicant-tracking-systems/ (Apr 10 2026). **MEDIUM** — vendor with a commercial interest in the threat. Used only for mechanism (inverted index, Boolean search, NER date ranges, knockout questions) and market share (Greenhouse 19.3% / Lever 16.6% / Workday 15.9% / iCIMS 15.3%; 98.4% of Fortune 500). Its own text concedes "an ATS rarely 'rejects' a candidate automatically" and "ATS software doesn't actually rank candidates".
- Jobscan, "Why ATS Tables and Columns Ruin Your Resume" — https://www.jobscan.co/blog/resume-tables-columns-ats/ (Apr 9 2026). **MEDIUM** for severity, **HIGH** for mechanism — the "text-layer scrambling" description matches what I measured independently. Source of the safe-separator list (`|`, `•`, commas), the "umbrella" multi-role pattern, and the keep-a-separate-designed-version-for-portfolio advice.
- Lever, "5 ATS Myths, Debunked" — https://www.lever.co/blog/applicant-tracking-system-myths/ — **FETCH FAILED** (redirects to the blog category index; article appears retired). Cited by the wiki; not independently verified here.

**Staff-level positioning**
- Will Larson, *Staff Engineer*, "Staff projects" — https://staffeng.com/guides/staff-projects/. **HIGH** for the scope characteristics used as a selection filter (complex and ambiguous; numerous and divided stakeholders; a named bet where failure matters) and for the caution that staff impact often comes from a track record rather than a capstone.
- Levels.fyi, "How To Apply The STAR Method To Resumes" — https://www.levels.fyi/blog/applying-star-method-resumes.html (Dec 21 2020). **MEDIUM** — generic but concrete on converting scope statements into quantified bullets.

**Accessibility / typography**
- Stanford University IT, accessible typography — https://uit.stanford.edu/accessibility/concepts/typography (cited by the wiki for the don't-justify and contrast guidance). **HIGH** for the justification and contrast principles; the contrast **numbers** in this document are my own computation, not from this page.

**Primary measurement (this repository, 2026-08-21)**
- `docs/AshutoshTiwari.pdf` — poppler `pdftotext` in 3 modes (default / `-raw` / `-bbox`); `pdffonts`; `pdfinfo`; object-stream inflation for `/URI` annotation recovery; WCAG 2.x relative-luminance contrast + ITU-R BT.601 grayscale luma computed directly; controlled rebuild with `\justifying` removed (`latexmk`, BasicTeX). **HIGH** — all page-geometry, extraction, font, link, and colour figures in this document are measured, reproducible, and specific to this artifact.
- `docs/main.tex`, `Makefile`, `index.html`, `.planning/PROJECT.md`, `.planning/research/CODEBASE-EVIDENCE.md`.

**Fetch failures (not used; gaps flagged inline)**
- https://www.askamanager.org/2019/07/how-to-explain-gaps-in-your-resume.html — 404
- https://www.themuse.com/advice/how-to-explain-employment-gap-resume — 404
- https://www.jobscan.co/blog/employment-gap/ and …/how-to-explain-employment-gaps-on-your-resume/ — 404
- https://lethain.com/staff-plus-job-search/ — 404
- https://blog.pragmaticengineer.com/software-engineering-resume/ — 404
- https://huyenchip.com/2023/01/24/what-we-look-for-in-a-candidate.html — 404
- https://earnbetter.com/blog/debunking-myths-the-truth-about-applicant-tracking-systems-ats/ — returned an empty shell
- Brave Search unavailable (`BRAVE_API_KEY` not set); no Exa/Firecrawl MCP in this environment — so discovery was limited to known URLs, which is why the gap-norms and colour-bias topics are thinner than the rest.

**Confidence summary**

| Area | Confidence | Basis |
|---|---|---|
| Document mechanics (extraction, geometry, fonts, links, colour) | **HIGH** | Direct measurement + a controlled rebuild |
| ATS behaviour and what parse quality buys | **MEDIUM** | Two credible sources disagree; resolved by scoping claims to retrieval + field-binding + human scan, and disclosing the split |
| Resume-convention norms (formatting, skills, bullets, senior 10+ YoE) | **HIGH** | Detailed, specific, consensus-based community standard |
| Staff-vs-senior scope signals | **MEDIUM-HIGH** | Larson is authoritative on scope but writes about promotion, not resumes; the resume translation is my reasoning |
| Recruiter norms on a ~1-year gap | **MEDIUM-LOW** | All four targeted sources 404'd; the gap *arithmetic* is HIGH (computed), gap *reception* is reasoned + the wiki's summary rule |
| Colour bias at senior+ levels | **MEDIUM-LOW** | No recruiter survey loaded; the contrast/grayscale thresholds themselves are HIGH (computed) |
| Page-1 fit and the line budget | **HIGH** | Measured to 0.1pt |

---
*Pitfalls research for: Staff MLE resume repositioning on an existing LaTeX resume + portfolio site*
*Researched: 2026-08-21*



