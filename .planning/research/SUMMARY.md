# Project Research Summary

**Project:** thunderock.github.io — Resume & Portfolio
**Milestone:** v1.0 Staff MLE Resume Optimization
**Domain:** ATS-constrained LaTeX resume repositioning (Senior → Staff MLE / inference-framework), plus portfolio-site text sync
**Researched:** 2026-08-21
**Confidence:** HIGH

> **Research files:** [`STACK.md`](STACK.md) (keyword corpus, 428 postings) · [`FEATURES.md`](FEATURES.md) (staff-level content patterns) · [`ARCHITECTURE.md`](ARCHITECTURE.md) (LaTeX/site integration + measured page budget) · [`PITFALLS.md`](PITFALLS.md) (25 milestone-specific pitfalls) · [`CODEBASE-EVIDENCE.md`](CODEBASE-EVIDENCE.md) (the evidence baseline all four are grounded in)
>
> **Also settled after research, via spikes 001/002** (`.planning/spikes/MANIFEST.md`): Projects section = `rollout` + `graph_ml` (Variant A); privatize `random_walk`; `rollout` README status-line fix is a prerequisite. Treated below as decided input, not open questions.

---

## Executive Summary

This milestone is not a writing task, it is a **constrained-optimization task with two hard gates and one honesty invariant.** The document is already good: it builds reproducibly, its ATS text layer is clean (zero ligature corruption, standard section names, single column), and its palette already clears WCAG AAA. What is wrong is *allocation* — page 1 is measured **99.98% full (0.15pt of slack)** and spends 20 of its 59 lines on an Adobe section written in job-description voice, while the candidate's three strongest and most JD-aligned assets are **entirely absent from the PDF**: `torch.compile` (0 occurrences), the A100/H100 fleet numbers (0 each), ONNX/CUDA (0 each), and a +27,135-line production Rust subsystem (`Rust` appears once). The keyword corpus independently confirms these are not vanity items — they are the exact vocabulary 24 companies use across 428 postings.

The research converges on a single strategy: **spend an earned budget, don't manufacture one.** Deleting the career-break row frees a measured **48.9pt ≈ 4.25 lines** — that is the entire page-1 allowance, and it must be created *before* the Adobe rewrite is drafted, because until then every draft silently overflows. "Silently" is literal and is the milestone's most dangerous finding: `\raggedbottom` suppresses underfull warnings and LaTeX has no overfull-page warning, so a **3-page overflow produces a clean, exit-0 `make build` with zero warnings.** Page count is the only signal. Both ARCHITECTURE and PITFALLS therefore land on the same recommendation from opposite directions — add a **Phase 0 parse-and-fit harness (`make verify`)** before touching content. It is the verification mechanism for **14 of the 25 pitfalls**, and it is expected to *fail* on the current PDF, which is the point: five defects are live today (broken LinkedIn handle, zero literal URLs in the text layer, Education reading-order scramble, detached role dates, flattened bullet hierarchy).

The honesty constraint is where the research is most opinionated, and it cuts both ways. Two page-1 claims — **"10–50× faster image loading"** and **"3–8K images/sec on 32 GPUs"** — have **no provenance anywhere in the mined evidence**, sit in the highest-visibility position on the resume, and **block the Adobe rewrite** (rewriting around numbers that may have to go means redoing the page-1 fit). Symmetrically, the research found one genuinely free win: `torch.compile(mode="max-autotune")` shipped in production **enables CUDA graphs by default on GPU and executes Inductor-generated Triton kernels** per official PyTorch docs — so three target-JD keywords the project scoped out as unevidenced are actually claimable, *as compiler-mediated facts*, with no fabrication. Meanwhile `speculative decoding` should be **omitted outright**: it is inapplicable to non-autoregressive vision/embedding models and is the highest interview risk per unit of ATS gain in the entire corpus. The pattern to hold throughout: **coverage, not density** — ATS retrieval is an inverted index plus recruiter Boolean queries, so presence is binary and the second mention of a term buys exactly zero while costing 11.5pt of the scarcest resource in the project.

---

## Key Findings

### Target Vocabulary — the keyword corpus (from `STACK.md`)

428 postings from 24 companies were pulled from the companies' own public ATS APIs and **machine-counted, not recalled** (94% last-updated in 2026). The headline metric is `normDF` — company-normalized document frequency — which stops NVIDIA's 104 postings from dictating the corpus. The example JD in `PROJECT.md` was traced to a real live posting (Together AI, "LLM Inference Frameworks and Optimization Engineer"), and **two Adobe-internal postings are near-perfect targets**, proving a lateral move is possible without leaving the domain.

**The five findings that should drive the rewrite:**

1. **`fault-tolerant` / `fault tolerance` / `reliability` is the #1 keyword in the corpus — 63% normDF, 92% of companies — and it is the candidate's single strongest evidenced asset** (DLQs, circuit breakers, lease/TTL heartbeats, idempotent re-runs, converging shards, the STS storm fix, the 6-week silent-outage root cause). It currently appears **once** in the PDF. This is the largest asset/exposure mismatch in the milestone, and it outranks every GPU-optimization term by 3–5×.
2. **The `torch.compile` bridge pays for three keywords for free.** Official PyTorch docs state verbatim that `max-autotune` "enables CUDA graphs by default on GPU" and leverages Triton-based matmuls/convolutions. His production config at `glimmer/modules/dp/content_type_classifier/module.py:76-77` therefore licenses `CUDA graphs`, `Triton` (via Inductor codegen), and `kernel fusion` / `graph compilation` — **as compiler-mediated claims only.** Never "implemented CUDA graph capture" or "wrote Triton kernels." One caveat carries into planning: CUDA graphs can silently fall back, so the config must be confirmed not to be `max-autotune-no-cudagraphs` / `triton.cudagraphs=False`.
3. **`C++` (36% normDF / 71% co%) and `Go` (29% / 71%) are the largest recoverable gaps** — zero evidence in the seven mined Adobe repos. Mitigating context: three of the postings phrase the ask as a *systems-language list* ("Python and at least one of Go, C++, Rust, or Java"), which **Rust satisfies literally**; it does not satisfy CoreWeave Staff Inference or xAI. **Partial closure from spike 001:** `graph_ml` is public C++/Cython random-walk kernel code — enough to land the `C++` token honestly in Projects + Skills, not enough to claim production C++ in an Experience bullet.
4. **`speculative decoding` = omit entirely** (13% normDF, 42% co%). It requires autoregressive decoding, which his classifiers/detectors/embedders do not do. The strong honest line is the inverse: "my inference work is batch/throughput-oriented on vision and embedding models, so the KV-cache/continuous-batching layer isn't mine — here's the batching and scheduling work that is." Same verdict for `KV cache`, `PagedAttention`, `chunked prefill`, `prefix caching`, invented `p99`/`TTFT` numbers, and `custom CUDA kernels` (46% of companies ask — and it is a first-question disqualifier).
5. **Exact-match forms matter, because matchers are substring-literal.** Write `vLLM` (never `VLLM` — 0 body occurrences), `torch.compile` **with the dot** ("torch compile" won't match), `Kubernetes` spelled out (`K8s` appears in 3/259 postings), `TensorRT-LLM (TRT-LLM)` **both forms** (unrelated strings), `Mixture of Experts (MoE)` both, `Go` not `Golang` (5× rarer), `quantization` with a z, and the **longer** parallelism forms (`tensor parallelism` ⊃ `tensor parallel`). One trap: bare **`Triton` reads as the kernel DSL, not the server** — 57 postings vs 6 for `Triton Inference Server`.

**Also worth carrying forward:** `AI infrastructure` (41 postings) and `ML infrastructure` (34) outrank `ML platform` **~5:1** — prefer them in the headline. Staff bands cluster at **8–10+ years**. `lineage` / `provenance` / `governance` (21% normDF, 11 companies) is a surprise win that maps directly onto the +27k-line Content Gate.

### Resume Content Verdicts (from `FEATURES.md`)

Grounded in the r/EngineeringResumes wiki (the governing community standard), Chip Huyen (ML-infra hiring manager), Will Larson's StaffEng, Tanya Reilly on glue work, and Orosz's *The Tech Resume Inside Out*. Everything reduces to five rules, of which the load-bearing one is **Rule 5: every claim survives an interview** — the documented failure mode being a candidate whose "served 10M DAU" bullet turned out to be S3 data-wrangling ("this interview was a waste of time for both of us").

**Blocking — must be resolved before the Adobe rewrite:**

| Claim on the current resume | Status | Required action |
|---|---|---|
| "10–50× faster image loading" | **No provenance in `CODEBASE-EVIDENCE.md`** | Source + workload, or delete |
| "3–8K images/sec on 32 GPUs" | **No provenance.** The only Ray benchmark in evidence is 8×A100 / 1.09M rows / 109 rows/s — and it is *his module on someone else's engine* | Source + which pipeline, or replace with the evidenced benchmark |
| "sustained low P99 under high QPS" (Swiggy) | Adjective wearing a metric costume | A real number, or drop the clause |
| "Designed and led … **the org's** inference systems" | Over-claims; vLLM plugins + the H100 throughput ladder are explicitly others' work | Narrow the object; use "the platform runs vLLM…" for others' work |
| Any mentoring claim | **No evidence exists** | Ask the user; do not invent |

**Absent from the resume and must be added** (each is both a top differentiator and a corpus keyword):
- The **+27,135-line Rust governance subsystem** (9.7K-line integration suite, 422-line frozen cross-runtime contract) — the biggest unforced omission; authoring the contract other runtimes conform to *is* the textbook staff signal.
- **`torch.compile(max-autotune)` in production** — the one high-demand optimization keyword that is fully defensible.
- **GPU-fleet scale:** 64×H100 wave, 24×A100-40GB × 9 queues, 8×A100 benchmark. Most MLE resumes cannot produce a GPU count at all.
- **Fault-tolerance mechanism detail** — maps 1:1 onto the JD's "fault-tolerant high-concurrency."
- **Cross-repo end-to-end ownership** (his FCU0 export feeds his own enrichment DAGs) — one clause; essentially impossible to fabricate.
- **Incident leadership with a systemic fix** (6-week silent outage → CI smoke-test gate). Fixing the bug is senior; closing the *class* of bug is staff.

**Summary section — verdict: include it, ≤2 lines.** Sources genuinely disagree, but the candidate hits **three of r/ER's four inclusion triggers simultaneously**: staff-targeting, a repositioning, and an education gap that is about to lose its explanatory Experience row. Two drafts exist (scale-led vs technology-led); render both. Note the budget collision in §Page Budget below — with its `\section` header this costs ~3–4 lines of a 4.25-line dividend.

**Projects section — DECIDED via spike 002 (Variant A).** `rollout` + `graph_ml` only, ~5 rendered lines, replacing 7 grad-school entries (2017–2022) that FEATURES independently flagged as the resume's dominant anti-feature. This is a strictly better outcome than FEATURES' own "cut to 0–2" recommendation, because the two chosen repos are current, public, and land the two hardest Tier-1 gaps that Experience bullets *cannot* cover: **Rust systems** and **C++**. Two synthesis consequences the roadmapper should note:
- `rollout` contains a **vLLM backend crate** — which upgrades `vLLM` from "operated / platform context only, Skills-line at best" to a personally-authored integration he can narrate. That is a genuine keyword unlock the keyword research could not see.
- Spike-recorded prerequisites become milestone requirements: fix the `rollout` README's stale "pre-implementation" status line (a recruiter clicking a featured project must not read that), confirm the capability wording survives "walk me through it", and privatize `random_walk` (a 3-commit empty repo whose description oversells — a click-through liability one hop from a featured repo).

**Other page-2 verdicts:** cut the 4-line publication abstract (keep citation + venues + first-author + link); strip both GPAs; compress Research → 1 line and Teaching → 1 line; **retain Education's `2021–2023` date range** (not just a graduation year — it is the only remaining artifact explaining the gap); rename "Selected Projects" → "Projects" and "Technical Skills" → "Skills"; Skills reordered inference-first with a hard **≤3 rendered lines** cap (currently 4, so the "stretch" starts from a deficit and every addition must displace something).

### Document Integration & Page Budget (from `ARCHITECTURE.md`)

Every number below was produced by copying `docs/main.tex` to `/tmp`, applying one isolated edit, building with `latexmk`, and reading `pdfinfo` + `pdftotext -bbox`. The baseline probe reproduced the committed PDF exactly (page-1 content bottom = 764.3pt in both), so probe deltas transfer directly.

**The hard numbers:**

| Quantity | Measured | Consequence |
|---|---|---|
| Text-block ceiling / page-1 content bottom | 764.4pt / **764.3pt** | **Page 1 is 99.98% full — 0.15pt of slack** |
| Career-break block (`main.tex:169-174`) | **−48.9pt = 4.25 lines** | This is the *entire* page-1 budget. (PITFALLS independently measured 50.0pt ≈ 4.5 lines using an 11.0pt line height — the two agree within ~1pt; **plan against the conservative 48.9pt / 4.25 lines**) |
| Cost of one added single-line L2 item | **11.5pt**, verified linear over 4 additions | The 5th addition tips to 3 pages |
| Adobe section footprint | 223pt = **20 of page 1's 59 lines (30%)** | The rewrite target |
| GROUPON removal / NETSPEED removal | −49.3pt measured / ≈−49pt est. | Folding both frees **≈8 more lines** — the cheapest honest budget source |
| Free formatting levers (`:71` itemsep, `:117` role gap) | −8.4pt + −4.0pt = **12.4pt** | A final nudge, not a strategy |
| Page-2 slack | **53.5pt ≈ 4.6 lines**; **+4 skills lines is the safe cap** | Skills is the cheap surface — zero page-1 cost |
| Palette blast radius | **exactly 2 hex literals** (13 consumption sites, all pure color) | A palette swap cannot change layout. `accentlight` is dead code (0 use sites) |
| Resume ↔ site coupling | **Text only.** Zero shared color, zero shared build | Palette phase and site-sync phase are fully independent |

**The overflow-detection trap — the single most important mechanical finding.** Across three probe builds: baseline → 2 pages, 0 warnings; +4 lines → 2 pages, 0 warnings; **+5 lines → 3 pages, 0 warnings, 0 errors.** `\raggedbottom` (`:46`) suppresses underfull-vbox warnings and there is no "overfull page" warning to begin with. **`make build` succeeding proves nothing about the page-1 gate; `pdfinfo | Pages: 2` is the build's real exit code.** A second trap sits inside the gate design itself: on the 3-page artifact, page-1 *headroom* still reads a misleadingly green `+2.7pt`, because once content spills, page 1 is no longer the binding page. Fill measurement can never substitute for the page count. And the boundary assertion must test what page 2 **starts with** (`PUBLICATIONS`) — a probe proved that testing for the *absence* of company names on page 2 returns a **false OK**, because a partial spill left the orphan fragment `Breakdown.`, which matches no company.

**Three live text-layer defects, all cheap:**
1. **LinkedIn handle is corrupted.** `main.tex:134` writes `ashutosh--tiwari`; LaTeX's `--` ligature renders it as a single **en dash (U+2013)**, so the extracted/human-readable handle is `ashutosh–tiwari` — **the wrong handle.** The `\href` URL is fine; only the text layer and anything a human retypes is broken. Fix by breaking the ligature (`ashutosh-{}-tiwari`). **Zero layout cost.**
2. **Zero literal URLs in the text layer.** All 26 `/URI` annotations live inside compressed object streams; every anchor is masked (`Homepage/Portfolio`, `Github@thunderock`). A text-only parser gets **no** LinkedIn, GitHub, or portfolio URL — which defeats the site-sync phase's entire purpose. Fix: make the anchor text the literal URL, keeping `\href` for clickability. Space cost ≈ zero, and it sits in the header above Experience.
3. **Education parse-order defect.** In default-mode extraction `Bloomington, IN` is emitted **before** `Indiana University, Bloomington`, and `Aug. 2021 – May 2023` lands in a **detached block** — so a parser doing NER date-range binding may never associate the dates with the institution. Same class of defect splits every role header into three non-adjacent blocks (title / dates / employer) and detaches all Research/Teaching dates.

**What NOT to do:** don't shrink the body font (already `\small` ≈9pt) or the margins (already 0.378in/0.384in, near the ~0.25in printer clip zone); don't widen `\textwidth` (re-flows and invalidates every measurement here); don't reintroduce negative `\vspace` (a preamble comment records that decision being deliberately reversed); don't move `\newpage` (it *is* the gate); never remove `\pdfgentounicode=1`. Also: keep the single-row `tabular*` headers — Jobscan's "avoid tables" warning targets **page-level two-column designs**, and this construct empirically extracts in correct order in all three `pdftotext` modes.

### Critical Pitfalls (from `PITFALLS.md`)

25 pitfalls, mapped to phases. The framing matters: the two most credible source families **directly contradict each other** on whether ATS auto-rejects. Resolution used throughout — parse quality does **not** gate rejection; it gates three concrete things: **retrievability** (inverted index + recruiter Boolean queries → presence is binary), **structured-field auto-fill** (company↔title↔dates binding), and **the human ~6-second scan**, which is the actual decision point.

1. **Trusting a green build** (AP1 / Pitfall 22). Measured: a 3-page overflow is warning-free and exit-0. → `make verify` with `pdfinfo` page count as the gate; assert geometry and `\setlist` values are **unchanged** so space can only come from words.
2. **Deleting the career-break row without a replacement device** (Pitfall 1). The deletion is framed as subtraction rather than substitution, leaving Swiggy `Jul 2021` directly above Adobe `Jul 2024` with nothing on page 1 acknowledging it. Corrected arithmetic: Education covers **22 of 36 months**, leaving **~14 months uncovered** (~12–13 after crediting season-labelled Research entries) — and its dates *scramble in extraction*. → The r/ER-sanctioned device is the ≤2-line summary doing double duty; if the user declines, that must be a **recorded decision with the posture accepted**, not an unexamined default. Plus an **off-resume** `screening-prep.md` for the spoken 30-second answer (never resume or site content).
3. **Writing the Adobe rebuild before deleting the career break** (AP2). The budget is 0.15pt until `:169-174` is gone, so every draft overflows silently and a too-long draft is indistinguishable from a correct one.
4. **Rebuilding Adobe and silently losing true, strong claims** (Pitfall 25). "Rebuild from evidence" invites starting from `CODEBASE-EVIDENCE.md` rather than from the current text, so anything the evidence file happens not to restate looks like it was never there — including `Falcon-40B`/`Llama 2 70B`, KEDA-on-SQS-depth, and the very numbers flagged as unverified (unverified ≠ false). → Produce an explicit **retain / revise / retire table before writing new text**; nothing gets dropped implicitly. Corollary (Pitfall 23): when the fit gate fails, the easiest lines to cut are the longest — which are exactly the ones carrying numbers. Rank before cutting, and assert the count of digit-bearing page-1 bullets never drops.
5. **`built on X` → `built X` verb drift** (Pitfall 11) and **"defensible" being self-assessed** (Pitfall 10). Compression pressure shortens honest verbs, and ambiguity always resolves *upward* in the reader's mind. Note the currently-**safe** phrasings that must not regress: "Built online inference **on** vLLM + Ray" (`:154`), "strategy pattern **over** FSDP/FSDP2" (`:160`). → Maintain a verb→evidence-tier map (`built/designed` = authored; `integrated/introduced` = wired in; `operated/ran` = execution; `prototyped` = branch-only; `hardened/root-caused` = inherited), and gate every Skills stretch item on a **two-question test** ("one specific thing you did with it, including a decision and its tradeoff" + "one way it fails") with a recorded `built`/`operated`/`evaluated` tier. One unsupportable item discounts the twenty supportable ones — the cost is asymmetric and contagious.

**Honorable mentions the roadmapper should not lose:** chasing keyword *density* instead of coverage (2nd mention = zero index gain, 11.5pt cost); pasting verbatim JD sentences (adopt the nouns, never the sentences); invisible-text stuffing (extraction is color/size/position-blind, so it lands *visibly* in the recruiter's parsed record); narrative dilution across five co-equal Adobe topics with no thesis; and three artifacts telling three stories — `index.html` contains `Senior Machine Learning Engineer` in **3 places** and carries **its own career-break timeline entry** (`index.html:207-225`) that the milestone's headline decision would contradict.

**One proven free win, honestly reported as a negative result:** removing `\justifying` produces **byte-identical extraction in both modes and unchanged pagination**. It satisfies the readability guidance at literally zero risk — and it also **disproves** the hypothesis that justification causes the `-raw` word-gluing (`ADOBEFIREFLY`, `MASTEROFSCIENCEIN…`). That gluing is an extractor limitation, **not fixable in LaTeX** — monitor it, never spend budget on it.

---

## Implications for Roadmap

Suggested structure: **8 phases (0–7).** Two are new relative to `PROJECT.md`'s Active list and both are load-bearing; one is a page-2 restructure that the spikes made concrete. The ordering is not a preference — it is forced by a measured dependency: **the budget must exist before content is added, and the gate must exist before the budget is spent.**

### Phase 0: Parse & Fit Harness (`make verify`)
**Rationale:** The verification mechanism for **14 of the 25 pitfalls**, and the only thing standing between "ATS-parsable / fits page 1" as an *opinion* and as a *gate*. `make build` is provably silent on the only hard constraint. Not in `PROJECT.md` — **recommend adding it.**
**Delivers:** `make verify` target wrapping the 5-gate script drafted in `ARCHITECTURE.md:§6.3` — (1) `pdfinfo` page count == 2; (2) `\newpage` boundary held, asserted positively (page 2 *starts at* `PUBLICATIONS`); (3) per-page headroom in lines at 11.5pt; (4) ATS text-layer integrity (no ligatures, section headings present, literal `ashutosh--tiwari`); (5) evidence-backed keyword presence as `WARN`. Merged with `PITFALLS.md`'s additional assertions: five date strings + printed titles **byte-identical to baseline**, every extracted glyph visibly rendered, literal URLs present, Skills ≤3 rendered lines, digit-bearing page-1 bullet floor, **zero geometry/`\setlist` diffs**, two extraction modes reported.
**Avoids:** Pitfalls 2, 3, 7, 8, 9, 15, 16, 17, 18, 19, 20, 22, 23 (detection half).
**Note:** `touch docs/main.tex` before building is not cosmetic — `make` is mtime-gated, so after a revert the PDF can be newer than the source and the gate silently verifies a stale artifact.
**Expect this phase to FAIL on the current PDF.** Five defects are live. That is the harness working, not a regression.

### Phase 1: Claim Verification & Decision Gate
**Rationale:** The two unverified numbers sit in the highest-visibility position on page 1. Rewriting around them and *then* discovering they must go means redoing the page-1 fit — the one thing the 0.15pt budget cannot absorb. This phase is mostly **user input, not engineering.**
**Delivers:** sourced-or-cut decisions on "10–50×", "3–8K images/sec on 32 GPUs", Swiggy's "low P99"; the C++/Go answer; the gap-posture decision (summary vs recorded no-summary); the Groupon/NetSpeed fold decision; `rollout` capability wording confirmed; `torch.compile` production config checked for CUDA-graph enablement. Plus the off-resume `screening-prep.md` draft with the ~14-month arithmetic pre-computed.
**Avoids:** Pitfalls 1, 3, 4, 25 (decision half); `FEATURES.md:§4.5` blocking questions.

### Phase 2: Career-Break Removal + Zero-Cost Defect Fixes
**Rationale:** **Creates the 48.9pt budget every later phase spends.** The zero-cost fixes are folded in here because they are independent, risk-free, and get verified early against a freshly-green harness.
**Delivers:** delete `main.tex:169-174` (−48.9pt / 4.25 lines); break the LinkedIn `--` ligature; convert masked link anchors to literal URLs; remove `\justifying` (proven zero-impact); fix Education's date binding so institution↔dates are line-adjacent in extraction; drop month periods.
**Avoids:** Pitfalls 2, 16, 22 (sequencing).

### Phase 3: Adobe Firefly Section Rebuild
**Rationale:** Largest block (223pt / 20 lines) and highest-signal content; its final size determines what is left for older roles, so optimizing them first risks redoing the work.
**Delivers:** a **retain/revise/retire table first**, then the rewrite from `CODEBASE-EVIDENCE.md` using `FEATURES.md:§1.4` (bullets B1–B11) and `STACK.md:§9` (phrase bank + bullet skeletons). One thesis sentence (fault-tolerant distributed GPU inference at ~700M-asset scale); ≤4 topics with sub-bullets on the top 2 only; ≤2 nesting levels (level 3 flattens in extraction anyway, so nothing machine-readable is lost); metrics **front-loaded**; role-header shape fixed so employer+title share a line; verb→tier discipline applied and diffed.
**Adds:** the Rust subsystem, `torch.compile(max-autotune)`, GPU-fleet numbers, fault-tolerance mechanisms, cross-repo ownership, the outage→CI-gate story.
**Avoids:** Pitfalls 6, 8, 11, 12, 13, 14, 23, 25.

### Phase 4: Page-2 Restructure (Projects swap + compressions)
**Rationale:** Page 2 has its own independent 53.5pt budget and **zero dependency on the page-1 gate** — it can run in parallel with Phase 3 if convenient. The Projects decision is already made, so this phase is execution, not deliberation.
**Delivers:** Projects → **Variant A** (`rollout` + `graph_ml`, ~5 lines, LaTeX drafts already written in `.planning/spikes/002-projects-section-reco/README.md`); publication abstract cut to citation + venues + first-author + link; both GPAs stripped with the `2021–2023` range retained; Research → 1 line; Teaching → 1 line; sections renamed to `Projects` / `Skills`. Side tasks: **privatize `random_walk`**, **fix the `rollout` README status line** (prerequisite before the resume ships).
**Frees:** ~24 page-2 lines by direct count (~9 Projects + ~5 abstract + ~6 Research + ~3 Teaching + ~1 GPAs).
**Avoids:** the dominant anti-feature (7 grad projects at 10 YoE); click-through credibility liabilities.

### Phase 5: Skills Stretch + Summary + Older-Role Keyword Pass
**Rationale:** Skills must be **derived from** finalized bullet vocabulary, not the reverse ("if you have Java in your skills, your bullets should include Java, and vice versa"). Skills is also the cheapest and highest-leverage surface — page 2, and 76.4% of surveyed recruiters start their search from skills.
**Delivers:** Skills reordered inference-first, **≤3 rendered lines** (from 4 — the stretch starts in deficit, so every addition displaces), slashed pairs split, each stretch item carrying a recorded tier + two-question answers; the 2-line summary (Drafts A and B both rendered); a coverage-checklist keyword pass on Swiggy/Flipkart with **one strong placement per term, bullet-first**, asserted against extracted text rather than `.tex`; page-1 redundancy rule (no critical term lives only in page-2 Skills).
**Budget collision to plan for:** the summary costs ~3–4 lines of the 4.25-line dividend, i.e. nearly all of it. It pays for itself **only if** the Groupon+NetSpeed fold (≈8 lines) happens in the same pass — which is why Phase 1 must settle that decision.
**Avoids:** Pitfalls 5, 9, 10, 19.

### Phase 6: Final Fit & Accent Palette
**Rationale:** Fit-tuning against non-final content is wasted work, and palette samples must render **the artifact the user will actually ship** or the choice is made against the wrong document.
**Delivers:** contingent fit levers applied cheapest-first (`:71` −8.4pt → `:117` −4.0pt → drop weakest topic −11.5pt → weakest sub-bullet −22.1pt → fold pre-2018 roles −49pt each); 3 palette proposals (deep navy / oxblood / graphite mono) rendered **plus grayscale conversions**, judged against 5 numeric criteria (text accent ≥7:1, rules ≥3:1, grayscale luma ≥4.5:1 / ≥3:1, zero unused color definitions — i.e. `accentlight` must be used or deleted). Build them with the `sed`+`latexmk` harness, since `make build` hardcodes `JOBNAME` and cannot emit variants.
**Note:** all three proposals are *higher*-contrast than today's teal, and today's teal already clears every measurable bar — **the burden of proof is on the challenger**, and "teal stays" is a legitimate outcome.
**Avoids:** Pitfalls 20, 21, 22 (execution half).

### Phase 7: Site Sync & Cross-Artifact Consistency
**Rationale:** Site text mirrors settled resume language; syncing earlier means syncing twice. Palette is *not* part of this — the two artifacts share zero color and zero build.
**Delivers:** `index.html:41` hero + `:43` about synced to the new positioning; **sweep all 3 `Senior Machine Learning Engineer` occurrences** plus the 7 Adobe timeline bullets (`:195-201`) for contradictions with the rebuilt resume; the **explicit scope decision on `index.html:207-225`** (the site's own career-break timeline — remove, or keep deliberately); a LinkedIn *contradiction check* (rewrite stays out of scope, but a contradiction gets a backlog item); final full `make verify`; and the **plain-text paste test** — the cheapest real-world proxy for the entire parse-risk class, run exactly once.
**Avoids:** Pitfalls 4, 15, 18, 24; AP6.

### Phase Ordering Rationale

- **Gate before budget before content.** Phase 0 → 2 → 3 is forced, not chosen: the harness must exist because the failure is silent; the budget must exist because it is 0.15pt; the content must come last because it is the thing being sized. Reversing any pair produces the panic edit that Pitfall 22 describes and Pitfall 23 turns into deleted metrics.
- **Phase 1 is blocking and cheap.** Its cost is a conversation; its avoided cost is redoing the page-1 fit. It also front-loads every user decision into one place instead of scattering approval checkpoints across four phases.
- **Phase 4 is parallelizable.** Page 2 is behind a hard one-way `\newpage` boundary with its own independent 53.5pt. It has no page-1 dependency and can run alongside Phase 3.
- **Skills after bullets, always.** The skills↔bullets invariant is bidirectional in principle but has a correct execution order: finalize bullet vocabulary, derive Skills from it.
- **Palette last-but-one, site last.** Palette touches exactly 2 hex literals with zero layout effect, so it is safely deferred to frozen content. Site sync consumes settled resume language.
- **Crosswalk to `PITFALLS.md`'s own numbering** (its pitfall-to-phase table uses a different scheme — the roadmapper should map, not assume): its Phase 0 = ours 0; its Phase 1 (career break) ≈ ours 1+2; its Phase 2 (Adobe) = ours 3; its Phase 3 (keyword) + Phase 4 (skills) ≈ ours 5; its Phase 5 (palette) ≈ ours 6; its Phase 6 (site) + Phase 7 (final gate) ≈ ours 7. Our Phase 4 (page-2 restructure) has no counterpart there — it came from the spikes.

### Research Flags

**No phase requires `/gsd-plan-phase --research-phase`.** This is unusual and worth stating plainly: because all four research files were measured against the actual artifacts (17 `latexmk` probes, three-mode extraction, 428 machine-counted postings, commit-verified evidence) and the Projects question was closed by two spikes, planning inputs are already concrete — down to runnable gate scripts, copy-ready bullet skeletons, and LaTeX drafts.

Phases with standard patterns (skip research):
- **Phase 2, 3, 4, 6, 7** — inputs are fully specified: exact line numbers, measured costs, evidence anchors, verbatim phrase banks, computed contrast ratios, ready LaTeX.

Phases needing *inputs* rather than research at planning time:
- **Phase 0** — needs **consolidation, not discovery**: `ARCHITECTURE.md:§6.3` ships a 5-gate script and `PITFALLS.md` specifies ~7 further assertions. Neither list is complete alone. Merge them when planning.
- **Phase 1** — needs **user answers**, and is blocking. Plan it as a decision checkpoint, not an implementation task.
- **Phase 5** — needs a **per-item user approval loop** (`PITFALLS.md` Pitfall 10 is explicit that a single "looks good" on a finished list is the failure mode), plus one small verification errand: read the production `torch.compile` config to confirm CUDA graphs are not disabled.

---

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| **Keyword corpus** (`STACK.md`) | **HIGH** | 428 postings / 24 companies pulled from companies' own public ATS APIs (full posting bodies, not search snippets); 94% updated in 2026; machine-counted and company-normalized. Exact-match forms are case-sensitive literal counts. MEDIUM on **tier boundaries** (19%/8% normDF thresholds are a judgment call — both numbers are published so the rewrite can re-tier). MEDIUM-LOW on LLM-subcorpus % for selector terms (inflated by construction). Meta/Google/ByteDance not harvestable; low tier risk since their vocabulary overlaps in-corpus companies. |
| **Content patterns** (`FEATURES.md`) | **HIGH** on bullet formulas, section structure, anti-features — the sources are the governing community standard plus an ML-infra hiring manager and StaffEng primary material. **MEDIUM** on inference-specific quantification norms (no source enumerates "good numbers for inference work"; the tiering is a derived synthesis) and on the **summary verdict** (sources genuinely disagree; resolved by trigger-counting). |
| **Document integration** (`ARCHITECTURE.md`) | **HIGH** for everything about the artifacts — 17 `latexmk` probes, baseline reproduced to 0.1pt, three-mode `pdftotext`, locally computed WCAG/BT.601 values. **MEDIUM** for external ATS-vendor guidance and for palette convention (template corpus, not a controlled study). NETSPEED's ≈49pt is *estimated* by structural symmetry, not measured. |
| **Pitfalls** (`PITFALLS.md`) | **HIGH** on document mechanics (direct measurement + a controlled rebuild). **MEDIUM** on ATS behaviour — two credible sources contradict each other and the disagreement is disclosed rather than papered over, with claims scoped to retrieval + field-binding + human scan. **MEDIUM-LOW** on recruiter norms for a ~1-year gap (four targeted sources 404'd) and on colour bias at senior+ levels (no recruiter survey loaded) — though the gap *arithmetic* and the contrast *numbers* are both HIGH because they are computed. |
| **Evidence baseline** (`CODEBASE-EVIDENCE.md`) | **HIGH** | Commit- and email-verified attribution; two other Adobe "Ashutosh"s explicitly excluded. Its honest-framing rules are treated as binding by all four files. |

**Overall confidence: HIGH** — with the important qualifier that the *highest-risk* items are not low-confidence research, they are **known unknowns requiring user input** (below).

### Gaps to Address

| Gap | Handling |
|---|---|
| **The two unverified page-1 numbers** ("10–50×", "3–8K img/s on 32 GPUs") | **Blocking.** Phase 1 decision: source them or cut them. Unverified ≠ false — do not silently delete (Pitfall 25). |
| **C++ / Go production experience — UNKNOWN** | Largest recoverable ATS gap (36%/29% normDF, 71% co% each). Ask in Phase 1. Partially closed already: `graph_ml`'s public C++/Cython kernels earn the token in Projects + Skills; production C++ in an Experience bullet still requires an answer. |
| **No cost / GPU-hour number anywhere** | 18% normDF across 18 of 24 companies, and the one metric that translates platform work into business terms. Ask in Phase 1; if none exists, accept the loss — do not estimate. |
| **No mentoring evidence** | Four of StaffEng's five staff behaviors have evidence; mentorship has none. Ask the user; **do not invent.** One honest clause beats the whole Teaching section. |
| **No latency percentiles / TTFT** | Structural, not fixable. Never fabricate. Compensate with throughput, rows/s, GPU counts, asset counts, utilization — all abundant. |
| **`torch.compile` CUDA-graph enablement unverified** | `max-autotune-no-cudagraphs` or `triton.cudagraphs=False` would invalidate the §11 bridge. One config read during Phase 5; until then, the interview-safe answer is "I inherited the default and here's how I'd verify capture." |
| **No live ATS scan was ever run** | No Jobscan/Lever/Greenhouse account; claims are three-mode `pdftotext` simulation. Mitigated by the Phase 7 plain-text paste test. `pdfminer`/Tika cross-check was blocked in the research environment. |
| **`-raw` extraction glues words** (`ADOBEFIREFLY`) | **Not fixable in LaTeX** — proven, not assumed. Monitor as a worst case; never gate the build on it; do not spend budget chasing it. |
| **Line-budget arithmetic differs slightly between files** | Career-break footprint 48.9pt/4.25 lines (ARCHITECTURE, 11.5pt line) vs 50.0pt/4.5 lines (PITFALLS, 11.0pt line); page-1/page-2 "whitespace" vs "slack" figures are measured against different reference lines (physical page vs text-block ceiling). Not contradictions. **Plan against the conservative pair: 48.9pt, 4.25 lines, 11.5pt/line, ceiling 764.4pt.** |
| **Page-2 freed-lines estimate** | `FEATURES.md` estimated ~34–38 lines; the spike's direct count of the Projects section (~14 lines + heading, not ~22) puts the realistic total near **~24**. Use direct counts. Page 2 only has 4.6 lines of slack anyway — these cuts create working room, not overflow relief. |
| **LinkedIn is out of scope but is the surface recruiters reach without a link** | Minimum viable action is a *contradiction check* in Phase 7, plus a backlog item if the 2021–2024 presentation disagrees with the resume. |
| **Zero external OSS PRs (confirmed by spike 001)** | `STACK.md`'s highest-ROI action outside the resume — one merged vLLM/SGLang PR would simultaneously make `vLLM`, `SGLang`, and `open-source contributions` defensible. Out of milestone scope; **backlog it.** |
| **The site has no `<meta name="description">` and no Open Graph tags** | Positioning text is invisible to link previews and search snippets. Logged, out of scope, backlog candidate. |

### Open Questions for the Requirements Phase

Consolidated from all four files plus the spike prerequisites — these are the decisions that change downstream arithmetic and should be settled in Phase 1:

1. **Do you have production C++ and/or Go** (NetSpeed era or elsewhere)? Highest-value single unknown in the corpus.
2. **Approve or reject the "concept vocabulary" Skills grouping** for `tensor parallelism` / `pipeline parallelism` / `MoE` / `KV cache` / `continuous batching`? It is the only way those target-JD terms reach the page, and it carries mandatory interview obligations (know why TP is latency-bound on NVLink, why PP creates bubbles, why EP needs all-to-all).
3. **Any defensible cost or GPU-hour savings figure?** Currently the single highest-value absent metric.
4. **Any real mentoring evidence** off-commit? If not, the mentorship gap is conceded deliberately.
5. **Fold Groupon + NetSpeed into an "Earlier Experience" block on page 2?** Buys ≈8 page-1 lines — the difference between "summary fits" and "summary competes with the Adobe rebuild". Trade-off: splits Work Experience across the page boundary, slightly weakening the "Experience fits page 1" formatting story.
6. **Summary-line budget trade-off:** the summary (with its `\section` header) costs ~3–4 of the 4.25 freed lines. Include it (recommended — three of four inclusion triggers apply), and if so, is Q5 approved to pay for it?
7. **Source or cut** "10–50×" and "3–8K images/sec on 32 GPUs" (and Swiggy's "low P99")?
8. **The site's own career-break timeline** (`index.html:207-225`) — remove for consistency, or keep deliberately?
9. **Confirm `rollout` capability wording** — which v1 rows are complete vs in-progress, so the Projects bullet survives "walk me through it"?
10. Optional, high-ROI, out of scope: **one upstream OSS PR** to vLLM or SGLang, and/or a weekend TensorRT-LLM conversion of one of his own ONNX classifiers — each converts a Tier-1 fabrication risk into a narratable fact.

---

## Sources

Full source tables with per-item credibility ratings live in each research file. Aggregated by tier:

### Primary (HIGH confidence)
- **428 job postings / 24 companies**, harvested live 2026-08-21 from companies' own public ATS APIs (Greenhouse `boards-api`, Ashby `posting-api`, Workday `cxs`, `amazon.jobs`, Eightfold). The target JD is a real posting: Together AI, "LLM Inference Frameworks and Optimization Engineer". 40 load-bearing URLs listed in `STACK.md:§13`.
- **Direct measurement of this repository** (2026-08-21): 17 `latexmk` probe builds in `/tmp` (repo tree never modified), `pdfinfo`, `pdftotext` in default/`-layout`/`-raw`/`-bbox` modes, `pdffonts`, object-stream inflation for `/URI` recovery, `\typeout` geometry probe (`\textheight=737.15378pt`), locally computed WCAG relative-luminance and ITU-R BT.601 luma, and a controlled rebuild with `\justifying` removed. `docs/main.tex`, `docs/AshutoshTiwari.pdf`, `docs/AshutoshTiwari.log`, `Makefile`, `index.html`, `css/style.css`.
- **`CODEBASE-EVIDENCE.md`** — commit- and email-verified accomplishments mined from seven Adobe repos; attribution disambiguated against two other Adobe "Ashutosh"s.
- **PyTorch official docs** — `torch.compile` mode semantics (the `max-autotune` → CUDA graphs / Triton bridge).
- **r/EngineeringResumes wiki** (index + samples + ATS pages) — the de-facto community standard for this exact document class, and cited in turn by the hiring-manager sources.
- **Chip Huyen**, "What we look for in a resume" — ML-infra-specific hiring-manager primary source (read via Wayback; live URL 404s). Also relays Kyle Kranen (NVIDIA) on cookie-cutter projects.
- **Will Larson / StaffEng** — "What do Staff engineers actually do?", "Promotion packets", "Staff projects", "Staff archetypes".
- **Tanya Reilly**, "Being Glue" — canonical on IC leadership without a title; artifacts as evidence.
- **Gergely Orosz**, *The Tech Resume Inside Out* — resume structure + "ATS Myths Busted" (names the recruiters backing the no-auto-reject claim).
- **Stanford University IT** accessible typography — the don't-justify and contrast principles.
- **Spikes 001 / 002** (`.planning/spikes/`) — 98-repo GitHub inventory scored against staff-MLE criteria; Projects-section variants with measured line costs.

### Secondary (MEDIUM confidence)
- **Jobscan** — ATS mechanics (inverted index, Boolean search, NER date-range binding, blessed separators `|` `•` `,`), market share (Greenhouse 19.3% / Lever 16.6% / Workday 15.9% / iCIMS 15.3%), and the recruiter-survey figures (99.7% keyword filters; 10.6× job-title effect; 76.4% skills-first). **Vendor with a commercial interest in the threat being large** — used for *mechanism*, which was independently verified by measurement, and deliberately down-weighted against Orosz on *consequence*.
- **LaTeX resume template corpus** (code search): `sb2nov/resume`, `jakegut/resume`, `santifer/career-ops`, `posquit0/Awesome-CV`, `mitchelloharawild/vitae`, `jankapunkt/latexcv` — `\pdfgentounicode` lineage and palette conventions. Counter-example flagged: `liantze/AltaCV` *reintroduces* ligature codepoints.
- **Levels.fyi** STAR-method walkthrough; **Nick Singh** 36 resume rules (used only for the 15-second-scan and business-terms points — his target audience is new-grads).

### Tertiary / not obtained (needs validation)
- **No live ATS scan** — the largest unclosed verification gap; mitigated by the Phase 7 paste test.
- **Recruiter norms on a ~1-year employment gap** — all four targeted sources returned 404; the gap *arithmetic* is computed and HIGH, its *reception* is reasoned.
- **Colour preference at senior+ levels** — no recruiter survey located; contrast/grayscale thresholds themselves are computed and HIGH.
- **Google's X-Y-Z formula** primary write-up returned HTTP 403 — the formula is independently attested by two HIGH sources.
- **Meta / Google / ByteDance / Apple / Uber postings** — not machine-harvestable; absence does not shift tier assignments.

---
*Research completed: 2026-08-21*
*Ready for roadmap: yes*
