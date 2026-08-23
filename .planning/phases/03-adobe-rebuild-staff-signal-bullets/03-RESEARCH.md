# Phase 3: Adobe Rebuild & Staff-Signal Bullets - Research

**Researched:** 2026-08-22
**Domain:** LaTeX resume content engineering under a measured page-1 line budget, gated by a bespoke bash verification harness
**Confidence:** HIGH (every load-bearing number below was measured live this session against the committed artifact; no page-budget or gate claim is `[ASSUMED]`)

## Summary

Phase 3 is not a writing task with a verification step bolted on — it is a **line-budget allocation problem with a fixed, measured ceiling of exactly +4 rendered page-1 lines**, inside which all of D-01 through D-11 must fit. I built five scratch variants of `docs/main.tex` in `/tmp` and ran the real harness against each: `+1 → +4` lines all stay green with page-1 headroom falling linearly `50.5 → 39.0 → 27.6 → 16.1 → 4.7pt` (11.4–11.5pt per line, i.e. `LINE_PT=11.5` is exactly calibrated for this line class), and **`+5` lines produces a 3-page PDF with `G1.1 FAIL` + `G2.1 FAIL`**. The locked governance topic group as drafted (a `\resumeTopic` plus one nested `\resumeItem`) measures **4 rendered lines — the entire Phase-2 budget** — so the group must ship without its nested item, or existing text must be tightened to pay for it.

Three mechanics that the harness documentation does not make obvious, all verified: **(1)** `G3.1`/`G3.2` are *not* the overflow alarm — at `+5` lines `G3.1` still PASSes (LaTeX breaks the page rather than overrunning the ceiling) and only `G1.1`/`G2.1` go red, so the measure-after-every-build loop must read `G1.1` first and treat `G3.2`'s p1 figure as the remaining-headroom meter. **(2)** `G6.6` is `warn`-only *unconditionally* — the KEYWORDS_TARGET→REQUIRED promotion rule is a documented process obligation with **zero machine enforcement**, and promoting an entry while keeping its `:phase` suffix makes `G6.5` grep for the literal `torch.compile:3` and FAIL (reproduced). **(3)** Eleven of the thirteen BLOCKER-tier `KEYWORDS_REQUIRED` have all their carriers inside the exact three blocks this phase rewrites, and **five are single-point-of-failure**: `Rust` ×1, `SQS` ×1, `Flash Attention` ×1, `FSDP` ×2-from-one-string (all four in the Adobe block) and `fault` ×1 (Swiggy). A careless rewording of any one of those lines turns the phase gate red.

D-08 cannot be discharged from this repo or this machine: `~/code` contains no `genie` checkout, and `~/code/ai-platform/aidoc/{genie,glimmer}` are documentation trees with no `modules/dp/content_type_classifier`. `CODEBASE-EVIDENCE.md:54` records the mode string as `max-autotune` (which rules out the `max-autotune-no-cudagraphs` half by citation), but says nothing about the separate `torch._inductor.config.triton.cudagraphs` surface — so the read needs a `checkpoint:human-verify`, or the phase takes D-08's Triton-only fallback wording.

**Primary recommendation:** budget the phase as `4 rendered lines available → governance topic (2, no nested item) + D-05 Ray replacement (1) + 1 line of margin`, land D-04's mechanisms and D-06's figures inside the **≈480 characters of free tail room measured on already-wrapped Adobe bullets (zero pt cost)**, order every task spend-before-free (net-freeing ≥1 line raises slack past the 57.5pt probe and FAILs `G7.2` — reproduced), and gate with `bash scripts/verify-resume.sh && bash scripts/verify-phase2-regressions.sh` after every single edit.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Adobe block shape (EXP-02)**
- **D-01:** Rewrite the generic lead bullet ("Leading parts of the org's MLOps platform…") into fault-tolerance / distributed-inference voice. Keep the existing `\resumeTopic` group structure — no flattening, no restructure into dense groups.
- **D-02:** Add a **new governance topic group** for the Content Gate work: +27,135-line production Rust training-data governance/lineage subsystem (idempotent claim/receipt registration, immutable S3 evidence layouts, 9.7k-line integration test). Framed as "fault-tolerant distributed systems in Rust" — **never** as inference optimization (CODEBASE-EVIDENCE binding rule).
- **D-03:** **Retain all 5 existing topics** (Distributed Inference, Training Framework, Build & Deployment, Enrichment, Data Quality), revised tighter. Retire nothing. Criterion 1's retain/revise/retire record must log a decision per topic: 5× retain-and-revise + 1× add (governance). Falcon-40B, Llama 2 70B, and KEDA-on-SQS-depth claims survive the rewrite.
- **D-04:** Name fault-tolerance mechanisms **inline where they occurred**: exponential backoff + full jitter, concurrency-safe S3 checkpoint caches, lease/TTL heartbeats, DLQs, circuit breakers, idempotent re-runs. No aggregate FT bullet, no implicit-only outcomes.

**Evidence picks (EXP-03, EXP-04)**
- **D-05:** The offline-inference bullet's "10–50× faster image loading" and "3–8K images/sec on 32 GPUs" are replaced by the **1.09M-row / 8×A100 Ray Data benchmark** (16 fractional-GPU actors). Attribution-safe phrasing: his AIDE module *benchmarked on* the Ray Data engine — not "achieved" as if he built the engine.
- **D-06:** Remaining scale figures **spread by owning topic**: 202.6M-row resumable migration + 24.8M video clips (enrichment/migration), ~700M-asset catalog +35–38M/month (data platform), 24×A100-40GB × 9 queues + 64-H100 wave (fleet operations), 40-node EMR daily (ingestion). Every figure traces to a named CODEBASE-EVIDENCE entry (criterion 3). Digit-bearing page-1 bullet count must not drop below baseline **8** (criterion 4; G5.4 floor is 7).
- **D-07:** `torch.compile` phrasing: **production claim + honest compiler bridge** — "introduced `torch.compile(mode="max-autotune")` on CLIP encoder + classifier head in production" with compiler-bridge clause naming what max-autotune honestly buys (Triton-generated kernels, CUDA-graph capture per official PyTorch docs semantics). Anchored to genie #1611/#1619.
- **D-08:** **Accepted implication:** the CUDA-graphs config verification moves INTO Phase 3 (was parked as a Phase-5 concern in STATE.md). Before the bridge wording ships, one read of the glimmer content-type-classifier compile config must confirm no `max-autotune-no-cudagraphs` / `triton.cudagraphs=False`. If the read fails: fall back to bridge-minus-CUDA-graphs wording (Triton kernels only). Record the read's outcome.

**Swiggy/Flipkart staff-signal pass (EXP-07)**
- **D-09:** Swiggy: **sharpen existing numbers** — Online Inference Platform carries the adoption count (18M+ monthly transacting users, platform-adoption framing); Feature Store keeps 4Bn rows / 10K QPS; the routing bullet gains a failure-class-closure clause (fault isolation across clusters, backpressure-aware scheduling, sustained low P99). No new claims requiring new evidence.
- **D-10:** Flipkart: **ML Workflow Automation carries the closure story** — first automated train→deploy workflow at Flipkart plus the error class it closed (manual-deploy drift / missing data+model validations). Search Intent Models keeps its "millions every day" adoption framing.
- **D-11:** **Line-budget policy:** Swiggy/Flipkart edits are line-neutral (in-place rewording; no net growth or shrink). Only the Adobe block grows, spending the +50.5pt slack. This preserves the 7.0pt G7.2 probe margin — do NOT free additional lines this phase (re-compression of the Groupon/NetSpeed descriptors stays untouched unless Adobe needs the room, per D-08/Phase-2 handoff).

**Cost/mentoring bullets + sign-off (EXP-08)**
- **D-12:** Draft **both families**: one cost/efficiency bullet (candidates: STS assume-role storm fix eliminating thousands of throttled calls/sec; 6-week silent-outage root-cause + smoke-test CI; preemptible-fleet idempotent autorecovery) and one mentoring/leadership line (framework adoption across org, founding-member/led framings).
- **D-13:** Provisional figures are **evidence-implied magnitudes only** (e.g. "thousands of STS calls/sec eliminated", "6-week outage class closed"). Never invented dollar amounts. Each draft carries an explicit ⚠ UNVERIFIED flag until user confirmation.
- **D-14:** **Ship rule = absent-by-default.** The rebuilt section ships WITHOUT these bullets; they enter `docs/main.tex` only after explicit recorded per-bullet approval. The phase can close green with them absent — rejection is a valid outcome, not a failure.
- **D-15:** **Checkpoint mechanics:** one blocking `checkpoint:decision` late in the phase, AFTER the Adobe rebuild is verified green. User reviews drafts against rendered PDF context, gives per-bullet verdicts; decisions recorded in the SUMMARY. Cannot auto-advance past it (STATE.md hard gate).

### the agent's Discretion
- Exact bullet wording and ordering within each topic group (decisions above fix content, evidence anchors, and mechanism lists — not sentences).
- Topic-group ordering within the Adobe block (governance before/after Training Framework — pick what reads best at rendered width).
- Whether the milestone-audit obligations (wire `scripts/verify-phase2-regressions.sh` into a make target; claim G6.13/WR-01 ownership) land as a wave-0 plan task or fold into the harness-touching plan — both must land somewhere in this phase (see canonical refs).
- Keyword placement for G6.6's absent target keywords (torch.compile, A100, H100 land naturally via D-05/D-06/D-07; ONNX/CUDA graphs/Iceberg/Triton appear only where evidence-true — no keyword stuffing).

### Deferred Ideas (OUT OF SCOPE)
- CUDA-graphs claim upgrade beyond the compiler-bridge phrasing — only if the D-08 config read confirms and Phase 5's skills work wants it (PG2-04's `CUDA graphs` exact-match form is Phase 5's).
- Groupon/NetSpeed descriptor re-compression — sanctioned lever, but pull it ONLY if the Adobe rebuild measurably runs out of room (D-11); protected by P2 regression assertions either way.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| **EXP-02** | Adobe section rebuilt leading with fault-tolerance + distributed-inference language (Tier-1 keyword family) | §Budget Arithmetic gives the 4-line ceiling the rebuild must fit; §Fragile-Keyword Map shows which words the rewrite must not drop; §Patterns P-1/P-2 give the `\resumeTopic` shapes and measured per-shape char capacity; §Validation V-EXP-02 gives an automated first-bullet assertion for criterion 2's "opens on" clause (no existing gate covers it) |
| **EXP-03** | `torch.compile(mode="max-autotune")` production claim present with compiler-bridge phrasing | §Pitfall 3 verifies plain `"` renders/extracts as **ASCII U+0022** (no curly-quote / `G6.4` risk) and that `torch.compile` **never** breaks across a wrap; §Keyword Promotion Mechanics gives the exact manifest edit; §Open Question OQ-1 + §Assumptions A1 scope the D-08 read that gates the CUDA-graph clause |
| **EXP-04** | Both unverified numbers replaced with evidence-backed figures from CODEBASE-EVIDENCE.md | §D-05 Measured Replacement: the swap costs exactly **+1 rendered line**, keeps `G5.4` at 8, keeps `G6.4` PASS, and lands `A100`×1; §Pitfall 4 warns criterion 3's absence assertions must use the **EN DASH** form `10–50` (the ASCII `10--50` is vacuous); §Pitfall 5 shows `G5.4` cannot see a figure that wrapped onto a continuation line (live example: Swiggy Feature Store's `4Bn rows, 10K QPS`) |
| **EXP-07** | Swiggy/Flipkart bullets tightened to staff-signal formulas | §Fragile-Keyword Map: `fault`×1 lives in the exact Swiggy bullet D-09 rewords, `Spark`×1-on-page-1 in the Feature Store bullet; §Budget Arithmetic confirms D-11's line-neutral rule is the only safe policy (net-freeing trips `G7.2`); §Current-Content Inventory gives the per-bullet source-line anchors for the criterion-1 record |
| **EXP-08** | Cost/mentoring bullets drafted, ⚠-flagged, shipped only after explicit sign-off | §Checkpoint Mechanics gives the verbatim `checkpoint:decision gate="blocking"` schema from `01-01-PLAN.md` plus the absent-by-default wave-ordering consequence; §Validation V-EXP-08 gives the automated post-checkpoint assertion for both outcomes (approved → literal present; rejected → literal absent) |
</phase_requirements>

## Architectural Responsibility Map

This phase has no runtime tiers. The equivalent question — *which artifact owns which capability* — matters just as much here, because the phase touches four files with very different mutability rules.

| Capability | Primary Tier (owner artifact) | Secondary Tier | Rationale |
|------------|------------------------------|----------------|-----------|
| Resume content (bullets, topics, figures, mechanisms) | `docs/main.tex` :146-195 | — | Free text. The only file the content decisions D-01…D-10 legitimately mutate. |
| Rendered artifact (page fit, text layer) | `docs/AshutoshTiwari.pdf` + `.log` + `.fdb_latexmk` | — | Derived, but **tracked**, and must ride in the *source* commit (`G0.3` reads the latexmk md5 — a source-only commit refuses at exit 2 on fresh checkout). |
| Mutable thresholds + keyword tiers + WARN ownership | `docs/verify/manifest.txt` | — | Phase-mutable by design. Phase 3's legitimate edits: `KEYWORDS_REQUIRED`/`KEYWORDS_TARGET` promotion, `WARN_OWNERS` `G6.13:unassigned`→`3`. **Not** `PROBE_LINES` (raise-only, and only at a measured stable end-state), **not** `DIGIT_BULLET_FLOOR` (lowering it to match a regression deletes the gate). |
| Honesty invariants (dates, titles, employers, geometry hash) | `docs/verify/baseline-frozen.txt` | — | **Immutable this phase.** Nothing in D-01…D-15 changes a date, title, employer or geometry declaration. Any diff here is a defect. |
| Gate logic (assertions G0–G8) | `scripts/verify-resume.sh` | — | Touch only to *add* strength (e.g. WR-01's employer-first clause). Phase 2 froze its RESULT-line count (83) and distinct-ID count (39) in a reviewed plan — additions move numbers a reviewed plan pinned, so prefer a separate script. |
| Standing content-regression assertions | `scripts/verify-phase2-regressions.sh` (P2.x) + a new P3.x sibling | `Makefile` (invocation) | The established pattern for "assert a locked literal that no G-gate covers", explicitly invited by CONTEXT `<code_context>`. Keeps the harness's frozen counts intact. |
| Harness reachability (IG-01) | `Makefile` | — | The P2 net has **zero invokers** today (verified: only `.github/workflows/jekyll.yml` exists, and it builds the Jekyll site — it never runs either resume script). A make target is the audit's prescribed closure. |
| Decision record (retain/revise/retire, D-08 outcome, EXP-08 verdicts) | `PLAN.md` / `SUMMARY.md` / `STATE.md` | — | CONTEXT `<specifics>` is explicit: criterion 1's record is a **plan artifact, not a main.tex artifact**. |

## Standard Stack

This phase installs **nothing**. Its whole toolchain is already present and pinned by the repo.

### Core
| Tool | Version (measured) | Purpose | Why standard |
|---|---|---|---|
| `latexmk` | 4.86a | `docs/main.tex` → `AshutoshTiwari.pdf`; writes the `.fdb_latexmk` md5 record `G0.3` reads | Already the `Makefile`'s builder; the freshness proof depends on its record format |
| `pdflatex` (pdfTeX / TeX Live 2025) | 3.141592653-2.6-1.40.27 | engine | pinned by BasicTeX install path `/Library/TeX/texbin` |
| `pdftotext` (poppler) | 26.08.0 | the ATS text layer both gates measure | the repo's pinned extraction convention (default mode + form-feed→newline) |
| `pdfinfo` (poppler) | 26.08.0 | page count for `G1.1` | same |
| `python3` | 3.11.12 | inlined measurement blocks inside the harness (bbox parsing, glyph census, probe injection) | already a `make check` dependency |
| `bash` | `/bin/bash` **3.2.57** (PATH `bash` is 5.3.15) | both gate scripts | ⚠ see Pitfall 10 — new P3.x assertions must stay **3.2-safe** even though PATH bash is 5.x |
| GNU `make` | **3.81** | target orchestration only | ⚠ collapses every failed recipe to its own exit 2 — never gate on `make verify` |
| `shellcheck` | 0.11.0 | lint any new P3.x script (`-f gcc`, 0 findings is the Phase-2 bar) | already the established quality bar for the P2 net |

### Supporting
| Tool | Purpose | When to use |
|---|---|---|
| `pdftotext -bbox-layout` | per-line `xMin/yMin/xMax/yMax` — the only way to measure per-block vertical cost and indent depth | when attributing a headroom change to a specific bullet |
| `git show <rev>:path` into `mktemp -d` | negative controls against the pre-change artifact pair (basename **must** stay `main.tex` — the freshness record is looked up by source filename) | proving a new P3 assertion is not a tautology |
| `bash scripts/verify-resume.sh --pdf X --tex Y` | run the real gate against a scratch variant without touching the repo | the budget-probing loop used throughout this research |

### Alternatives Considered
| Instead of | Could use | Tradeoff |
|---|---|---|
| a new `scripts/verify-phase3-regressions.sh` | new `G6.x` assertions inside `verify-resume.sh` | Rejected: Phase 2's `02-02-PLAN.md` criterion 11 pinned the harness's 83 RESULT lines / 39 IDs, and `G7`/`G8` controls count them. A sibling script keeps those numbers stable — the same reasoning the P2 net's own header records. |
| extending the P2 net with P3 assertions | a separate P3 file | Either works; a separate file keeps "Phase 2 invariants" and "Phase 3 invariants" independently retirable, and the `P3.` ID prefix cannot collide. Extending P2 means one fewer make target. **Recommend a separate `P3.` file + one make target that runs both.** |
| `$\sim$700M` for the ~700M figure | `\textasciitilde{}700M` | **Mandatory:** `$\sim$` extracts as **U+223C**, which is *not* in `NONASCII_ALLOW` → `G6.4` FAIL (BLOCKER). Verified both ways. See Pitfall 2. |

**Installation:** none. `make check` confirms all seven dependencies present.

## Package Legitimacy Audit

**Not applicable — this phase installs zero external packages.** No npm, PyPI, crates, or Homebrew formula is added; the only external dependency in the whole repo is `poppler`, installed at 26.08.0 and already audited in `01-RESEARCH.md:117-128`. Consistent with Phase 1's recorded finding (`01-01-PLAN.md:360`, threat `T-01-SC`: "This phase installs zero npm/PyPI/crates packages"), no slopcheck run and no `checkpoint:human-verify` install gate is required.

**Packages removed due to slopcheck [SLOP] verdict:** none
**Packages flagged as suspicious [SUS]:** none

## Page-1 Budget Arithmetic (measured — research focus #1)

> Every figure in this section was produced this session by building a scratch variant of `docs/main.tex` under `/tmp` and running the committed harness against it with `--pdf`/`--tex`. The repo working tree was never modified (`git status --porcelain` before and after: `?? .omc/` only, pre-existing).

### The ceiling: +4 rendered lines, hard

| Added itemize-2 rendered lines | Pages | p1 content bottom | `G3.2` p1 headroom | Verdict |
|---|---|---|---|---|
| 0 (committed baseline) | 2 | 713.9pt | **+50.5pt (+4.39 lines)** | green, 0 BLOCKERs |
| +1 | 2 | 725.4pt | +39.0pt (+3.39 lines) | green |
| +2 | 2 | 736.8pt | +27.6pt (+2.40 lines) | green |
| +3 | 2 | 748.3pt | +16.1pt (+1.40 lines) | green |
| **+4** | **2** | **759.7pt** | **+4.7pt (+0.40 lines)** | **green, 0 BLOCKERs — the last safe step** |
| +5 | **3** | 760.3pt (p1) | p1 +4.1pt | **`G1.1` FAIL + `G2.1` FAIL** |

**Measured cost per rendered line = 11.4–11.5pt**, perfectly linear across the sweep. `LINE_PT=11.5` in the manifest is exactly calibrated for this line class, so integer arithmetic is safe: `floor(50.5 / 11.5) = 4`.

### `G3.1`/`G3.2` are NOT the overflow alarm — `G1.1` is

At `+5` lines the harness still printed `RESULT G3.1 PASS deepest content bottom 760.3pt vs ceiling 764.4pt`. LaTeX **breaks the page** rather than overrunning `\textheight`, so the ceiling comparison never fires; the overflow shows up as a third page. What actually went red:

```
RESULT G1.1  FAIL  page tree reports 3 page(s) but manifest PAGES=2
RESULT G2.1  FAIL  page 2 opens at 'Structural Latency Breakdown.', expected 'PUBLICATIONS'
RESULT G2.3  PASS  page 1 carries the last experience employer 'NETSPEED SYSTEMS (Acquired by Intel)'   <-- still green!
RESULT G2.4  INFO  experience employer names appearing on page 2: 0                                      <-- still 0!
```

`G2.3` and `G2.4` both stayed green on a 3-page document, because only the NetSpeed descriptor's *continuation* line spilled — the employer line itself stayed on page 1. **A verification step that checks `G2.3`/`G2.4` for fit is checking the wrong thing.** The harness says so itself: `RESULT G4.5 INFO … which is why the page count (G1.1) is the primary fit gate`.

**The measure-after-every-build loop, in the order the plans should assert it:**
1. `make build`
2. `bash scripts/verify-resume.sh` → read **`G1.1`** first (fit), then **`G2.1`** (boundary), then **`G3.2` p1** (remaining headroom in pt *and* lines), then `G5.4` (digit-bullet count), then `G6.6` (which target keywords landed).
3. `bash scripts/verify-phase2-regressions.sh` → 27 PASS / exit 0.
4. Record the `G3.2` p1 figure in the task's evidence. Phase 2's core lesson: budget arithmetic is measured, never predicted.

### Free tail room: ~480 characters at zero pt cost

An already-wrapped bullet's last rendered line has unused width. Filling it costs **nothing**. Verified: I appended ~145 characters across three Adobe bullets' tails (`SQS queue depth.`, `correctness of feature-generation outputs.`, `experimentation and production at scale.`) and the harness reported **`G3.2` p1 unchanged at +50.5pt (+4.39 lines)**, 2 pages, 0 overfull. A separate sweep pushed one tail to a measured **124 characters** with still-zero cost.

| Adobe entry | `main.tex` | gate lines | rendered | last-line chars | free chars (cap 120) |
|---|---|---|---|---|---|
| lead `\resumeItem` | :151 | 11–12 | 2 | 76 | ~44 |
| `\resumeTopic{Distributed Inference Frameworks}` | :152 | 13–14 | 2 | 40 | ~80 |
| · vLLM + Ray item | :154 | 15 | 1 | 110 | ~18 |
| · **offline-inference item (D-05 target)** | :155 | 16 | 1 | **128** | **~0 — at capacity** |
| · Modeled pipelines (KEDA/SQS) | :156 | 17–18 | 2 | 16 | ~104 |
| `\resumeTopic{Foundation Model Training Framework}` | :158 | 19–20 | 2 | 51 | ~69 |
| · FSDP/FSDP2 item | :160 | 21 | 1 | 109 | ~19 |
| · Flash Attention item | :161 | 22 | 1 | **130** | **~0 — at capacity** |
| `\resumeTopic{Build \& Deployment System}` | :163 | 23–24 | 2 | 97 | ~23 |
| `\resumeTopic{Enrichment Service}` | :164 | 25–26 | 2 | 71 | ~49 |
| `\resumeTopic{Data Quality Framework}` | :165 | 27–28 | 2 | 42 | ~78 |
| **Adobe total** | :151-165 | **11–28** | **18** | | **≈484 free chars, 0pt** |

**Measured per-shape one-line capacity** (proportional font, so these are observed maxima not hard limits): itemize-2 first line **124–138 chars** (a bold `\resumeTopic{Name}:` prefix costs width — the `Distributed Inference Frameworks` topic wrapped at 124 while a plain `\resumeItem` reached 138); itemize-3 single line **128–130 chars**; continuation lines **≥124 chars**.

So the Adobe block's total additive text room is **≈480 free chars (0pt) + ≈500 chars across the 4 purchasable lines ≈ 980 chars**, but only the second half spends budget. **D-04's mechanism lists and D-06's spread figures should be written into tails wherever the owning topic already wraps.**

### What the locked content actually costs

| Locked item | Shape built and measured | Rendered lines | pt | Headroom left |
|---|---|---|---|---|
| **D-02** governance group, `\resumeTopic` **only** | 2-line topic (idempotent claim/receipt + immutable S3 evidence layouts + manifest-after-data + 9.7k-ln test) | **2** | 22.4 | **+28.1pt (2.44 lines)** |
| **D-02** governance group **+ nested `\resumeItemListStart` with one item** | topic 2 lines + nested item 2 lines | **4** | 44.8 | **+5.7pt (0.49 lines)** ← eats the whole budget |
| **D-05** Ray replacement on the offline-inference item | 1-line item → 2-line item | **+1** | 11.0 | +39.5pt (3.44 lines) |
| Nested `\resumeItemListStart`/`End` structural overhead | itemize-3 `topsep=0.5pt` open + close | **0** | **≈0** | — (matches Phase 2's measured 1.5pt-for-two-folds) |

**The binding conclusion:** governance-with-nested-item (4 lines) + D-05 (1 line) = **5 lines = 3 pages**. The plan must pick one:
- **(a) Recommended — governance topic only, no nested item.** 2 + 1 = 3 lines, leaving 1 line (11.5pt) of margin for D-01/D-04/D-06 overflow. D-02's full content (idempotent claim/receipt registration, immutable S3 evidence layouts, 9.7k-line integration test, the 27,135-line figure) all fit in the 2-line topic — measured and rendered above with 0 overfull.
- **(b) Keep the nested item, pay by tightening.** Each existing 2-line Adobe topic that drops to 1 line frees 11.5pt. Six candidates exist (lead, DIF, FMTF, B&D, Enrichment, DQF). ⚠ Subject to the `G7.2` ordering rule below.
- **(c) D-08 lever (Groupon/NetSpeed re-compression).** CONTEXT `<deferred>` sanctions it only if Adobe "measurably runs out of room". Each descriptor is 2 rendered lines; dropping either to 1 frees 11.5pt. Protected by P2.7–P2.27 either way — the literals must survive, so this is a *reword-shorter*, not a *delete*.

### The `G7.2` direction — confirmed, and the exact trip point

Phase 2 handed forward a **7.0pt armed margin** (probe `5 × 11.5 = 57.5pt` vs slack `50.5pt`). Direction verified both ways:

- **Spending is safe and makes the guard stronger.** Margin = `57.5 − slack`. Spending shrinks slack, so the probe overflows *more* easily. At the `+4` end-state (slack 4.7pt) the margin is 52.8pt. `G7.2` cannot be endangered by spending.
- **Net-freeing ≥1 rendered line breaks it.** Reproduced: I shortened the Data Quality topic from 2 rendered lines to 1, rebuilt, and got `G3.2 INFO … p1 +61.4pt (+5.34 lines)`. I then replicated the harness's own probe injection verbatim (`+5 \resumeItem` at the last `\resumeItemListEnd` inside the page-1 region — the anchor still resolves at `begin=127 break=211 insert=207`, unchanged from Phase 2) and the probe PDF came out at **2 pages** — i.e. `G7.2` would emit `FAIL … a +5 probe NO LONGER overflows page 1 and the self-test would prove nothing`.

**Ordering rule for the plans:** *spend before you free, at every commit boundary.* `G7` only runs under `--selftest`, so a transient net-free does **not** redden `bash scripts/verify-resume.sh` — it reddens `make verify-selftest`, which `02-VALIDATION.md` runs **per wave**. So the constraint is: no wave may end in a net-freed state. `PROBE_LINES` is raise-only; raise it only at a measured stable end-state, and only if the end-state genuinely leaves >57.5pt of slack (it will not, under D-11).

## Keyword Mechanics (research focus #2)

### Which KEYWORDS_TARGET entries the locked content lands

`KEYWORDS_TARGET=torch.compile:3|A100:3|H100:3|ONNX:5|CUDA graphs:3|Iceberg:5|Triton:5` — the `:N` suffix is the **owning phase**, and the harness confirms that suffix **wins** over the categorical `WARN_OWNERS G6.6:3` entry. All seven currently measure ×0.

| Target | Owner | Does locked Phase-3 content land it? | Evidence / caveat |
|---|---|---|---|
| `torch.compile` | 3 | **YES** — D-07 requires the literal, and ROADMAP criterion 2 asserts it with the dot | Verified: `torch.compile` **never breaks across a line wrap** (two wrap-stress probes both moved the whole token). Safe to promote. |
| `A100` | 3 | **YES** ×≥2 — D-05's `8×A100` and D-06's `24×A100-40GB` | Verified live: the D-05 swap alone produced `G6.6 WARN target keyword 'A100' x1`. |
| `H100` | 3 | **YES** ×1 — D-06's `64-H100` wave | Verified live in the tail-growth probe: `'H100' x1`. |
| `CUDA graphs` | **3** | **PROBABLY NOT** — D-07's phrasing is *CUDA-graph capture* (hyphenated, singular) | `G6.6` greps the fixed string `CUDA graphs` case-sensitively. Probe confirmed: a line containing `CUDA graphs and CUDA-graph capture` matches; a line with only `CUDA-graph capture` does **not**. CONTEXT `<deferred>` assigns the exact-match form to **Phase 5 / PG2-04**, so leaving this at ×0 is correct — the WARN just persists with owner `Phase 3`. **Do not stuff it to clear the WARN.** |
| `Triton` | **5** | **RISK — likely yes** | D-07's compiler-bridge clause names "Triton-generated kernels". That lands `Triton` ×1 in a Phase-3 commit even though the manifest assigns it to Phase 5. See the governance question below. |
| `ONNX` | 5 | No | ONNX Runtime CUDAExecutionProvider is genie work (`CODEBASE-EVIDENCE.md:56`) but no locked decision places it on page 1. Phase 5 / PG2-04 owns it. |
| `Iceberg` | 5 | No | D-06's ingestion figure is "40-node EMR daily"; `Iceberg` belongs to the ff-data-ingestion FCU0 story (`:104`) which Phase 5's Skills tier carries. |

### The promotion workflow, concretely — and its two traps

The manifest's rule (`manifest.txt:51-52`): *"Promotion = move an entry from KEYWORDS_TARGET to KEYWORDS_REQUIRED in the same commit that adds the keyword."*

**Trap A — the `:phase` suffix must be stripped.** Reproduced: moving `torch.compile:3` verbatim into `KEYWORDS_REQUIRED` makes `G6.5` grep for the literal string `torch.compile:3`:

```
RESULT G6.5   FAIL  required keyword absent from the text layer (case-sensitive): 'torch.compile:3'
!! FAIL: 1 blocking failure(s) in: G6.5
```

The correct edit is two independent line edits:
```diff
-KEYWORDS_REQUIRED=inference|distributed|…|Flash Attention
+KEYWORDS_REQUIRED=inference|distributed|…|Flash Attention|torch.compile|A100|H100
-KEYWORDS_TARGET=torch.compile:3|A100:3|H100:3|ONNX:5|CUDA graphs:3|Iceberg:5|Triton:5
+KEYWORDS_TARGET=ONNX:5|CUDA graphs:3|Iceberg:5|Triton:5
```

**Trap B — `G6.6` never fails, so nothing enforces the promotion.** Read the harness (`verify-resume.sh:1747-1756`): the target loop counts occurrences and then calls `warn` **unconditionally** — there is no branch on `N`. A commit that adds `torch.compile` and forgets to promote it leaves `bash scripts/verify-resume.sh` at exit 0 with a WARN that reads `target keyword 'torch.compile' x1`. The promotion is a *process* obligation with zero machine backing.

**Consequence for the plan:** the task that lands each keyword must carry an `<automated>` check that pairs the two facts, e.g.

```bash
# both must hold, in the same commit
pdftotext docs/AshutoshTiwari.pdf - | tr '\f' '\n' | LC_ALL=C grep -qF 'torch.compile' \
  && LC_ALL=C grep -q '^KEYWORDS_REQUIRED=.*|torch\.compile\(|\|$\)' docs/verify/manifest.txt \
  && ! LC_ALL=C grep -q '^KEYWORDS_TARGET=.*torch\.compile' docs/verify/manifest.txt
```

Once promoted, `G6.5` becomes a **BLOCKER** on that literal — which is the point: a later phase that reworded the bullet away would then go red instead of silently losing an ATS keyword.

### `Triton` — a real governance question for the planner

If D-07's honest bridge clause says "Triton-generated kernels", then `Triton` becomes present in a Phase-3 commit while `manifest.txt` records its owner as `5`. Three defensible resolutions, in preference order:

1. **Promote it anyway** (`Triton` → `KEYWORDS_REQUIRED`, drop `Triton:5` from targets) and record in the SUMMARY that Phase 3 landed a Phase-5-owned target early. The rule is "the commit that adds it promotes it" — ownership is a *WARN routing* label, not a permission. Phase 5's PG2-04 still adds the Skills-tier exact-match form; `G6.5` at ×1 is already satisfied so PG2-04's addition is additive, not a duplicate obligation.
2. **Phrase around it** ("Inductor-generated kernels") so the target stays absent for Phase 5. Loses a Tier-1 ATS keyword the evidence licenses for free (`STACK.md:466-476`) — the research explicitly calls this a free win, so this is the weakest option.
3. Leave it present-but-unpromoted. **Rejected:** silently violates the manifest's own documented rule, and `G6.6` will not catch it.

### KEYWORDS_REQUIRED that must not regress — the fragile-keyword map

All 13 `KEYWORDS_REQUIRED` pass today (`G6.5` ×13 PASS). **Eleven have all their carriers inside the three blocks this phase rewrites.** Gate-line numbers are page-1 `pdftotext` lines (Adobe 11–28, Swiggy 36–46, Flipkart 54–62; >81 = page 2).

| Keyword | Total | Carrier lines | In Phase-3 edit scope | Risk |
|---|---|---|---|---|
| `inference` | 8 | Adobe 11,12,13,15,16,24,25 + Swiggy 36 | **all 8** | low (8 copies) |
| `distributed` | 2 | Adobe **21, 22** (both FMTF sub-items) | **both** | ⚠ **HIGH** — capital-D `Distributed Inference Frameworks` does **not** count (case-sensitive). Reword both sub-items away from the lowercase word and `G6.5` FAILs. |
| `Kubernetes` | 2 | Adobe 12, 23 | both | medium |
| `PyTorch` | 3 | Adobe 16, 19 + p2 127 | 2 of 3 | low (page 2 survives) |
| **`FSDP`** | 2 | Adobe **21 only** — `FSDP/FSDP2` yields **2 matches from one string** | **one line** | ⚠ **CRITICAL — single point of failure** |
| `Ray` | 3 | Adobe 15, 16 + p2 163 | 2 of 3 | low |
| `vLLM` | 2 | Adobe 15 + p2 164 | 1 of 2 | low |
| **`Rust`** | **1** | Adobe **24** (`a Rust control plane`, inside `\resumeTopic{Build \& Deployment System}` :163) | **yes** | ⚠ **CRITICAL — single occurrence, in a topic D-03 revises.** D-02's Rust governance group adds a second copy — land it *before or with* the B&D rewrite. |
| **`SQS`** | **1** | Adobe **18** (`SQS queue depth`, :156) | **yes** | ⚠ **CRITICAL — single occurrence.** D-03 explicitly preserves the KEDA-on-SQS-depth claim; this is why. |
| `KEDA` | 2 | Adobe 17, 23 | both | medium |
| **`Flash Attention`** | **1** | Adobe **22** (:161) | **yes** | ⚠ **CRITICAL — single occurrence** |
| `Spark` | 3 | Swiggy 43 + p2 161, 164 | 1 of 3 | low |
| **`fault`** | **1** | Swiggy **40** (`fault isolation across clusters`, :175) | **yes** | ⚠ **CRITICAL — single occurrence, in the exact bullet D-09 rewords.** D-09 names "fault isolation across clusters" verbatim, so the decision already protects it — but the criterion-1 record should carry a keyword column so this is checked, not hoped. |

**Actionable:** give the criterion-1 retain/revise/retire table a **"keywords carried"** column, and add a P3.x assertion for each of the five single-occurrence keywords (the P2 net's `assert_present` shape, matched against the whitespace-squeezed stream for `Flash Attention` and against raw lines for the short tokens — exactly the dual-stream pattern the P2 net documents).

## D-08: the CUDA-graphs config read (research focus #3)

### Where the read targets, and why it cannot be discharged here

`CODEBASE-EVIDENCE.md:54` cites `glimmer/modules/dp/content_type_classifier/module.py:76-77`. `STACK.md:466-483` carries the full official-docs basis and the exact question (`STACK.md:592` lists it as milestone open question #4):

> *"`max-autotune` … **It enables CUDA graphs by default on GPU.**"* / *"`max-autotune-no-cudagraphs` is a mode similar to `max-autotune` but without CUDA graphs."*
> — <https://docs.pytorch.org/docs/2.13/generated/torch.compile.html> `[CITED]` (recorded verbatim in STACK.md, verified 2026-08-21)

**The genie source repo is not on this machine.** Verified:
- `~/code` contains `ai-platform asml-img-data-dags colligo-deploy dataset_migration fetools ff-data-engineering ff-data-ingestion notebooks orion piat piat_slim` — **no `genie`**.
- `find ~ -maxdepth 4 -type d -name genie` → only `/Users/ashutosh/code/ai-platform/aidoc/genie`; `find ~ -maxdepth 6 -type d -name glimmer` → `.../aidoc/glimmer` plus two Pluto proto/service dirs. `.../aidoc/glimmer` contains `developer-guide faq.md glimmer-queue index.md limitations.md OWNERS quickstart user-guide` — **documentation only, no `modules/dp/content_type_classifier`, no `module.py`**.
- A repo-wide grep of `~/code/ai-platform` for `max-autotune|max_autotune|cudagraph|torch.compile` returns nothing.

### What the recorded citation does and does not settle

| Clause of D-08's read | Discharged by `CODEBASE-EVIDENCE.md:54`? |
|---|---|
| mode is **not** `max-autotune-no-cudagraphs` | **Effectively yes.** The citation records the mode string as `max-autotune` and `STACK.md:428/466` repeats it. The variant is a *different string*, so a recorded reading of `max-autotune` excludes it. Tag `[CITED]`, not `[VERIFIED]` — it is a research paraphrase of a source line, not the source line itself. |
| `torch._inductor.config.triton.cudagraphs` is **not** `False` | **NO.** That is a separate configuration surface (an Inductor config toggle, not the `mode=` argument). Nothing in `CODEBASE-EVIDENCE.md`, `STACK.md`, or any local checkout speaks to it. `STACK.md:483` also flags a third failure mode the citation cannot cover: CUDA graphs can **silently fall back** on input mutation, dynamic shapes, or graph breaks. |

### Recommendation

**Discharge D-08 with a `checkpoint:human-verify` (not a decision checkpoint), placed in the wave that writes the D-07 bridge wording, with a pre-authorized fallback so it cannot block the phase.** The user has the genie checkout; the agent does not. Concretely:

- **Ask:** run this against your genie checkout and paste the output —
  ```bash
  sed -n '70,85p' glimmer/modules/dp/content_type_classifier/module.py
  grep -rn 'cudagraph\|max-autotune\|max_autotune\|_inductor' glimmer/modules/dp/content_type_classifier/
  ```
- **Green branch** (mode is `max-autotune` and no `triton.cudagraphs=False` / `max-autotune-no-cudagraphs`): ship D-07's full bridge clause naming CUDA-graph capture.
- **Fallback branch** (read fails, is unavailable, or shows either disabling form): ship the **Triton-only** bridge. What the fallback drops is exactly the CUDA-graph capture clause; what survives is `Triton`-generated kernels + compiler-driven fusion + the unqualified `torch.compile(mode="max-autotune")` production claim, which is the highest-value part and needs no config read. **The `torch.compile` keyword, ROADMAP criterion 2, and EXP-03's core all land on the fallback branch too** — so the phase cannot be blocked by an unavailable read.
- **Record** the outcome (which branch, what was read or why not) in the SUMMARY. D-08 requires this explicitly, and STATE.md's `[Phase 5]` blocker line should be updated/closed by whichever branch fires.

**Do not** promote `CUDA graphs` into `KEYWORDS_REQUIRED` on either branch — the exact-match form is Phase 5's (CONTEXT `<deferred>`), and D-07's hyphenated phrasing does not land it anyway (verified).

## Harness Wiring: IG-01 / IG-02 / IG-03 (research focus #4)

### IG-01 confirmed: zero invokers

Repo-wide search for `verify-phase2-regressions` finds it referenced only in its own header, `03-CONTEXT.md`, `v1.0-MILESTONE-AUDIT.md`, and `02-VALIDATION.md` — **no `Makefile` target, no CI**. The only workflow is `.github/workflows/jekyll.yml`, which builds the Jekyll site in a container and never runs either resume script. The net itself is healthy: `bash scripts/verify-phase2-regressions.sh` → **27 RESULT lines, 27 PASS, exit 0** (also green under `/bin/bash` 3.2.57).

### The concrete Makefile change

Two facts constrain the design, both measured on this GNU Make 3.81:
- **A failed recipe line aborts the recipe** — a following line never runs (`make A` with `exit 1` then `echo two` printed only `one`).
- **make's own exit is 2** regardless of what the recipe returned. So `make verify` remains assertable only as "exits non-zero", exactly as the Makefile's existing comment block documents.

**Recommended shape** — a standalone target plus chaining, with the net **first** in the `verify` recipe:

```make
# in .PHONY, extend the existing list:
.PHONY: all help install brew mactex tex-deps poppler check build view open watch \
        verify verify-regressions verify-selftest verify-baseline clean distclean

REGRESS := scripts/verify-phase2-regressions.sh

# Content-regression net. Deliberately has NO $(PDF) prerequisite: the net's own
# contract is to read whatever artifact is on disk and never rebuild (it exits 2
# with a 'run make build' remedy if the PDF is missing), so a prerequisite here
# would turn it into build-then-verify -- the same wart CR-03 documents on
# `verify`. --gate-text must never appear in this recipe: the script's own help
# says a run carrying it certifies nothing, which is the same rule that keeps
# --skip-freshness out of `verify`.
verify-regressions:  ## Standing content-regression net (P2.x): career-break absence + locked descriptor literals
	@bash $(REGRESS)

# The net runs FIRST: it is <1s and content-only, so a content regression is
# reported before the slower page/geometry harness, and a red harness cannot
# short-circuit it (Make 3.81 aborts a recipe at the first failing line).
verify: $(PDF)  ## Gate the PDF: page budget, page-1 boundary, ATS text layer, honesty freeze
	@bash $(REGRESS)
	@bash $(VERIFY)
```

Also add `#   make verify-regressions - standing content-regression assertions (P2.x)` to the header comment block (lines 4–15) — that block is the file's own documented target index and is part of IG-02's "documented on a canonical surface" obligation.

**Rejected alternatives:**
- `verify: verify-regressions` as a *prerequisite* — prerequisites run before the recipe and a failing one aborts, which is the same short-circuit with worse readability.
- Chaining the net **after** `bash $(VERIFY)` — a red harness (the normal state mid-edit) would then hide the net entirely.
- `|| true` / `-` prefix — hides failures; defeats the purpose.
- Adding a CI job — out of scope for the audit's prescription ("wire into `make`"), and the existing workflow is site-scoped. Worth a Deferred Ideas note, not a Phase-3 task.

**Non-negotiable:** `bash scripts/verify-resume.sh && bash scripts/verify-phase2-regressions.sh` remains the *gating* invocation. `make verify` collapses exit 1/2 and is a convenience, not an oracle (`02-VALIDATION.md:29`).

### IG-02: documenting the net

The audit's complaint is that the net's only documentation is the phase-local `02-VALIDATION.md`. Phase 3 closes it by naming `scripts/verify-phase2-regressions.sh`, the `C++ graph algorithms` anchor, and the new make target in: the Makefile header block (above), `.planning/STATE.md` → `### Decisions` (a `[Phase 3]`-marked bullet), and the phase's own `03-VALIDATION.md` + SUMMARY. `03-CONTEXT.md` already names all three — that half is done.

### IG-03: claiming `G6.13` / WR-01

`G6.13` today emits **five** WARNs — every role block is "split across non-adjacent blocks", not just Flipkart:

```
RESULT G6.13  WARN  role block 'ADOBE FIREFLY' … line span 4 against a window of 3 … (owner: unassigned)
RESULT G6.13  WARN  role block 'SWIGGY' … span 4 … (owner: unassigned)
RESULT G6.13  WARN  role block 'FLIPKART (a Walmart company)' … span 5 … (owner: unassigned)
RESULT G6.13  WARN  role block 'GROUPON' … span 4 … (owner: unassigned)
RESULT G6.13  WARN  role block 'NETSPEED SYSTEMS (Acquired by Intel)' … span 4 … (owner: unassigned)
```

Claiming ownership is a **one-line manifest edit**, matching the manifest's own comment format (`# --- Sentinels: none … unassigned … any …`) and the existing `G5.4:3`/`G6.6:3` entries:

```diff
-WARN_OWNERS=G4.3:none|G5.4:3|G6.6:3|G6.13:unassigned|G6.14:5|G6.4:any
+WARN_OWNERS=G4.3:none|G5.4:3|G6.6:3|G6.13:3|G6.14:5|G6.4:any
```

`warn_owner` renders a numeric token as `Phase 3`, so all five lines then read `(owner: Phase 3)`. Note `ROLE_BIND_WINDOW=3` is a deliberate **local constant**, not a manifest key — `01-02` recorded that the commit which *promotes* `G6.13` to a BLOCKER is the commit that should add the key. **Phase 3 is claiming the WARN, not promoting the gate**, so do not add `ROLE_BIND_WINDOW` to the manifest.

### WR-01's employer-order flip — measured, and it self-heals

WR-01 records that the Flipkart employer line currently extracts **after** its subtitle (`SEARCH RELEVANCE, QUERY INTENT, NLP` at gate line 52, `FLIPKART (a Walmart company)` at 53), a position-sensitive `pdftotext` `tabular*` row-order artifact. Measured across the whole sweep:

| Variant | Flipkart order | Other four blocks |
|---|---|---|
| committed baseline | **FLIPPED** (sub@52, emp@53) | all employer-first |
| tail-growth only (0 new lines) | **FLIPPED** | all employer-first |
| **+1 line** | employer-first ✅ | all employer-first |
| **+2 / +3 / +4 lines** | employer-first ✅ | all employer-first |

So **any** Adobe growth of ≥1 rendered line resolves the flip as a side effect. That is a y-position accident, not a property — and it can flip back at some other growth amount, or flip for a *different* employer. Guidance:

- **Do** measure all five blocks' employer-vs-subtitle order at the end-state and record it (the check is a 10-line python one-liner; see §Code Examples E-4).
- **Do not** claim WR-01 as "fixed" without that measurement, and do not depend on it.
- **Consider but weigh carefully** WR-01 option (b) — a `region_first_nonempty`-style employer-first assertion per Work Experience role. Adding it as a **BLOCKER** would make an unrelated future y-shift able to redden the gate on a cosmetic extraction artifact; adding it as a **WARN owned by Phase 4** (which shifts page 2, not page 1) is the low-risk version. WR-01's option (a) — document the wobble — is already partly satisfied by `03-CONTEXT.md`'s canonical-refs pointer to the audit; making it explicit in `03-VALIDATION.md` + SUMMARY is the cheapest complete closure. ⚠ Note NT-02: `region_first_nonempty` has an unguarded empty-arg case; a second caller must add `case $1$2 in *[!0-9]*|'') return 0;; esac`.

## Checkpoint Mechanics for EXP-08 (research focus #5)

### The verbatim schema (confirmed against `01-01-PLAN.md:139`)

This GSD version expresses a blocking decision checkpoint as a `<task>` with `type="checkpoint:decision" gate="blocking"` and this child-element set, in this order:

```xml
<task type="checkpoint:decision" gate="blocking">
  <name>Task N: …</name>
  <decision>The single question, phrased as a question</decision>
  <context>
Why it cannot be decided by the agent; what each artifact says; the measured
state; the blast radius of each answer.
  </context>
  <options>
    <option id="short-slug">
      <name>Human-readable option</name>
      <pros>…</pros>
      <cons>…</cons>
    </option>
    <!-- one <option> per answer -->
  </options>
  <read_first>
    - file:line ranges the user should look at before answering
  </read_first>
  <how-to-verify>
1. numbered steps the USER performs
  </how-to-verify>
  <resume-signal>Select: id-a, id-b, or …</resume-signal>
  <files>.planning/STATE.md</files>
  <action>
Present the decision above and wait. Do not guess…
Once the user answers, record the outcome in … under a literal marker.
  </action>
  <verify>
    <automated>a shell command asserting the record exists and is well-formed</automated>
    <human-check>what the human confirms</human-check>
  </verify>
  <acceptance_criteria>
    - one bullet per checkable property
  </acceptance_criteria>
  <done>What is now unblocked.</done>
</task>
```

Two details worth copying from the Phase-1 instance: the `<action>` block names a **literal marker string** (`[Phase 1 / A1]`) that the record must contain, and `<verify><automated>` then greps for exactly that marker with `grep -Fc … | grep -q '^1$'` — i.e. the checkpoint's own completion is machine-checkable even though its *content* is human. Use the same pattern with a `[Phase 3 / EXP-08]` marker.

### The absent-by-default ship rule drives wave ordering

D-14/D-15 combine into a hard sequencing constraint:

1. **Drafts live in the plan document, never in `docs/main.tex`.** Writing a ⚠-flagged draft into the source — even commented out — risks it shipping. A `%`-commented draft is invisible to `pdftotext` and to both gates, so **no gate would catch it graduating from comment to live text**; and the D-13 `⚠ UNVERIFIED` marker itself would be unassertable. Keep drafts in `03-0N-PLAN.md` (and echo them into the checkpoint's `<context>` so the user reads them in-place).
2. **The checkpoint must come AFTER the Adobe rebuild is verified green** (D-15, verbatim). So the phase is at least two waves: `wave N` = rebuild + verify green; `wave N+1` = the checkpoint; `wave N+2` (conditional) = apply approved bullets, rebuild, re-verify, re-measure the budget.
3. **The conditional wave must be budgeted.** Each approved bullet is +1 or +2 rendered lines against whatever headroom survived the rebuild. If the rebuild lands at the `+4` end-state (headroom **+4.7pt**), **there is no room for even one more line** and an approval would force either a compensating tightening or a 3-page overflow. **Recommendation: leave ≥1 rendered line (11.5pt) of headroom unspent through the rebuild specifically to fund a possible EXP-08 approval**, and say so in the checkpoint's `<context>` so the user's decision is informed by the real cost.
4. **Rejection is a green outcome** (D-14). Both branches need an assertion — see §Validation V-EXP-08.
5. **STATE.md already carries the hard gate** (`### Blockers/Concerns` → `[Phase 3]: EXP-08 carries a hard user sign-off checkpoint … cannot auto-advance past it`). `.planning/config.json` has **no `workflow.auto_advance` key**, so nothing would auto-approve today — but Phase 1's recorded lesson (`general.md`, 2026-07-17) is that an attended gate must be presented for real even when `auto_advance` is true. Present it.

## Current Content Inventory — the criterion-1 baseline

ROADMAP criterion 1 demands a retain/revise/retire decision for **every** current Adobe bullet, recorded *before* new text. Here is the complete enumeration with source anchors, rendered cost, and the keywords each entry carries — the four columns the record needs.

| # | `main.tex` | Shape | gate lines | rendered | Digit-bearing (`G5.4`) | Keywords carried | D-03 disposition |
|---|---|---|---|---|---|---|---|
| A1 | :151 | `\resumeItem` (lead) | 11–12 | 2 | no | `inference`×2, `Kubernetes` | **revise** → D-01 fault-tolerance / distributed-inference voice |
| A2 | :152 | `\resumeTopic{Distributed Inference Frameworks}` | 13–14 | 2 | no | `inference`×1 | retain-and-revise |
| A3 | :154 | nested `\resumeItem` (vLLM + Ray, Falcon-40B, Llama 2 70B) | 15 | 1 | **yes** | `inference`, `Ray`, `vLLM` | retain-and-revise (D-03: Falcon/Llama survive) |
| A4 | :155 | nested `\resumeItem` (offline inference) | 16 | 1 | **yes** | `inference`, `Ray`, `PyTorch` | **revise** → D-05 Ray-benchmark replacement (**+1 line**) |
| A5 | :156 | nested `\resumeItem` (Source→Transform→Sink, KEDA, SQS) | 17–18 | 2 | no | `KEDA`, **`SQS`** ⚠ | retain-and-revise (D-03: KEDA-on-SQS-depth survives) |
| A6 | :158 | `\resumeTopic{Foundation Model Training Framework}` | 19–20 | 2 | no | `PyTorch` | retain-and-revise |
| A7 | :160 | nested `\resumeItem` (FSDP/FSDP2 strategy pattern) | 21 | 1 | **yes** | **`FSDP`×2** ⚠, `distributed` ⚠ | retain-and-revise |
| A8 | :161 | nested `\resumeItem` (Flash Attention 2/3, context parallelism) | 22 | 1 | **yes** | **`Flash Attention`** ⚠, `distributed` ⚠ | retain-and-revise |
| A9 | :163 | `\resumeTopic{Build \& Deployment System}` | 23–24 | 2 | no | `KEDA`, `Kubernetes`, **`Rust`** ⚠, `inference` | retain-and-revise |
| A10 | :164 | `\resumeTopic{Enrichment Service}` | 25–26 | 2 | no | `inference` | retain-and-revise (D-06: migration/clips figures land here) |
| A11 | :165 | `\resumeTopic{Data Quality Framework}` | 27–28 | 2 | no | — | retain-and-revise |
| **A12** | *new* | `\resumeTopic{…Governance (Rust)}` | — | **+2** | yes (27,135) | `Rust`, `fault`(-tolerant) | **add** (D-02) |

**Adobe totals today: 11 entries, 18 rendered lines, 4 digit-bearing bullet lines.**

Swiggy (`:172-179`, gate 36–46, 8 rendered lines, **2** digit-bearing) and Flipkart (`:186-192`, gate 54–62, 9 rendered lines, **1** digit-bearing) are line-neutral per D-11. Their per-bullet anchors: Swiggy `:172` Online Inference Platform (18M+, `inference`), `:174` routing item, `:175` Akka item (**`fault`** ⚠), `:177` Feature Store (`Spark`; ⚠ its `4Bn rows, 10K QPS` figures sit on a *continuation* line and are invisible to `G5.4` — see Pitfall 5), `:178` Forecasting, `:179` DAQ (15M). Flipkart `:186` Search Intent Models ("millions every day", no digit), `:187` Tail Query Classifier, `:188` ML Workflow Automation (D-10's closure story), `:190` Airflow framework item, `:192` Large-Scale Data Pipelines (4Bn+).

**Digit-bearing page-1 baseline = 8** (Adobe 4 + Swiggy 2 + Flipkart 1 + Groupon 1; NetSpeed 0). `DIGIT_BULLET_FLOOR=7`, criterion 4 requires **≥8**. Verified: the D-05 swap alone keeps it at 8; adding the governance topic takes it to 9.

## Architecture Patterns

### Content-flow diagram (what the phase actually does, and where each gate reads)

```
                     ┌──────────────────────────────────────────┐
  CODEBASE-EVIDENCE   │  binding honest-framing rules + every    │
  .md  (source of ────►│  figure's provenance (criterion 3)      │
  truth for claims)   └─────────────────┬────────────────────────┘
                                        │ every number must trace to a named entry
                                        ▼
  03-CONTEXT.md      ┌──────────────────────────────────────────┐
  D-01…D-15      ────►│  PLAN.md                                 │
                      │   · retain/revise/retire table (crit. 1) │
                      │   · EXP-08 drafts (⚠ UNVERIFIED, D-14)   │
                      └───────┬──────────────────────┬───────────┘
                              │ approved content     │ drafts stay here
                              ▼                      │ until the checkpoint
              ┌───────────────────────────────┐      │
              │  docs/main.tex :146-195       │      │
              │   Adobe :151-165 (grows ≤4 ln)│◄─────┘ (only post-approval)
              │   Swiggy :172-179 (neutral)   │
              │   Flipkart :186-192 (neutral) │
              └───────────────┬───────────────┘
                              │ make build  (latexmk → writes .fdb_latexmk md5)
                              ▼
     ┌────────────────────────────────────────────────────────┐
     │ docs/AshutoshTiwari.pdf  +  .log  +  .fdb_latexmk      │
     │ (tracked; MUST ride in the SOURCE commit — G0.3)       │
     └───────┬──────────────────────────┬─────────────────────┘
             │ pdfinfo                  │ pdftotext ──► gate.txt (form-feed→\n)
             │                          │                └─► squeezed.txt (tr -s)
             ▼                          ▼
  ┌──────────────────────┐   ┌──────────────────────────────────────────┐
  │ G1.1 page count      │   │ G2.x boundary · G3.x fill(bbox) · G5.x   │
  │  ◄── PRIMARY FIT GATE│   │ honesty+digits · G6.x glyphs/keywords    │
  └──────────────────────┘   └──────────────────────────────────────────┘
             ▲                          ▲                    ▲
             │ reads thresholds         │                    │ reads frozen strings
     ┌───────┴────────────┐   ┌─────────┴─────────┐  ┌───────┴──────────────┐
     │ manifest.txt       │   │ P2.x net (27)     │  │ baseline-frozen.txt  │
     │ (Phase-3 MUTABLE:  │   │ + NEW P3.x net    │  │ (IMMUTABLE this      │
     │  KEYWORDS_*,       │   │  ◄── wired into   │  │  phase)              │
     │  WARN_OWNERS)      │   │      make (IG-01) │  └──────────────────────┘
     └────────────────────┘   └───────────────────┘
```

### Recommended layout (no new files under `docs/`)

```
docs/
├── main.tex                  # :151-165 Adobe rebuild · :172-179 Swiggy · :186-192 Flipkart
├── AshutoshTiwari.{pdf,log,fdb_latexmk}   # regenerated; commit WITH the source
└── verify/
    ├── manifest.txt          # KEYWORDS_REQUIRED/TARGET promotion + WARN_OWNERS G6.13:3
    └── baseline-frozen.txt   # DO NOT TOUCH
scripts/
├── verify-resume.sh          # do not touch (frozen RESULT/ID counts)
├── verify-phase2-regressions.sh   # do not touch; now invoked from make
└── verify-phase3-regressions.sh   # NEW (P3.x) — locked Phase-3 literals
Makefile                      # NEW target verify-regressions + chaining + header entry
```

### Pattern P-1: `\resumeTopic` group with optional nested list

```latex
% Level itemize,2 — the role's main list. Topic name is bold, then ": ", then the claim.
% Measured one-line capacity at this level: 124 chars with a bold prefix, up to 138 plain.
\resumeTopic{Topic Name}{Claim sentence carrying the figures for this topic.}
  \resumeItemListStart          % itemize,3 — topsep 0.5pt, itemsep 0.25pt: ~0pt overhead
    \resumeItem{Sub-claim. Measured one-line capacity at this level: 128-130 chars.}
  \resumeItemListEnd
```
**When to use:** every Adobe entry. D-01/D-02/D-03 all keep this shape (no flattening).
**Cost:** `⌈chars / capacity⌉` rendered lines × 11.5pt. The nested list wrapper itself is free.

### Pattern P-2: write into the tail, not into a new line

**What:** when a topic already wraps to 2 rendered lines, append D-04 mechanism names / D-06 figures to the *existing* second line rather than creating a third.
**Why:** measured zero pt cost (see §Budget Arithmetic). ~480 free chars exist across the Adobe block.
**How:** check the current last-line length against ~120 chars (`pdftotext` + `awk '{print length}'`), then append at most that difference.

### Pattern P-3: standing content-regression assertion (the P2 net's shape)

```bash
# multi-word literals -> whitespace-SQUEEZED stream (pdftotext breaks them at wrap points)
assert_present "EXP-03 torch.compile production claim" 'torch.compile(mode="max-autotune")' "$SQUEEZED"
# short whitespace-free tokens -> RAW lines too, so the squeeze can never be what passes it
assert_present "EXP-04 A100 fleet figure" 'A100' "$GATE"
# removed figures -> absent in BOTH streams, using the EN DASH form (see Pitfall 4)
assert_absent  "EXP-04 unverified speedup retired" '10–50' "$SQUEEZED" "Restore an evidenced figure; do not reintroduce the unprovenanced range."
```
**When to use:** every locked Phase-3 literal that no `G`-gate covers — the five single-occurrence keywords, `torch.compile`, the two retired figures, and the criterion-2 lead-bullet anchor.

### Anti-patterns to avoid

- **Predicting the budget instead of measuring it.** Phase 2's central lesson; it cost that phase a superseded ROADMAP figure and a superseded D-08 estimate. Rebuild and read `G3.2` after *every* batch.
- **Lowering a threshold to match a regression.** `DIGIT_BULLET_FLOOR` and `PROBE_LINES` are the two temptations. Phase 1 recorded the principle: *"a generator that raises a BLOCKER threshold to match a document that moved away from it deletes the gate exactly the way re-freezing a changed employment date defeats VERIFY-03."*
- **Checking `G2.3`/`G2.4` for page fit.** Both stayed green on the 3-page `+5` variant. `G1.1` is the fit gate.
- **Deferring artifacts to a trailing `build(resume):` commit.** A source-only commit makes a fresh checkout of *that* commit refuse at `G0.3` exit 2. Phase 2's Decision 5 / `02-PATTERNS 6`: artifacts ride in the source commit.
- **`make clean` before verifying.** Deletes the `.fdb_latexmk` record `G0.3` reads and disarms the `G8.3` staleness control (documented in the Makefile itself).
- **Gating on `make verify`.** GNU Make 3.81 collapses exit 1 and 2 to its own 2. `bash scripts/verify-resume.sh` is the oracle.
- **Keyword stuffing to clear a `G6.6` WARN.** `G6.6` never fails; a WARN at ×0 for a Phase-5-owned target is the correct state. CONTEXT is explicit: "no keyword stuffing".
- **Framing the Content Gate work as inference optimization.** `CODEBASE-EVIDENCE.md:12` binding rule; D-02 restates it.
- **Writing EXP-08 drafts into `main.tex` as LaTeX comments.** Invisible to both gates, so nothing prevents a later uncomment from shipping an unapproved claim.

## Don't Hand-Roll

| Problem | Don't build | Use instead | Why |
|---|---|---|---|
| "Did the page-1 content still fit?" | a custom pt-counting script, or eyeballing the PDF | `bash scripts/verify-resume.sh` → `G1.1` + `G3.2` | The build is **silent** on overflow (exit 0, zero warnings — `G7.1` proves this numerically). `G3.1` alone is not enough (green on a 3-page doc). |
| "Is this multi-word literal in the text layer?" | `grep` on raw `pdftotext` output | the P2 net's `$SQUEEZED` stream (`tr -s ' \t\n' ' '`) | `pdftotext` breaks every wrapped phrase mid-literal; a raw whole-line grep returns 0 on a perfectly correct document. |
| "Does this section heading / employer extract once?" | substring grep | `grep -Fxc … == 1` (the honesty-freeze idiom) | A substring test cannot tell a real line from a longer one containing it; an at-least-one test cannot detect a duplicate. |
| "Which pt cost did this edit have?" | arithmetic from char counts | `pdftotext -bbox-layout` + the harness's `G3.2` | Proportional font + `\raggedbottom` + `\justifying` make char-count arithmetic an estimate only. Measured pitch is 11.4–11.5pt/line. |
| "Is a new assertion actually stronger?" | trusting that it passes | Phase 2's **negative control**: `git show <pre-change>:docs/main.tex` into `mktemp -d` (basename `main.tex`!) + `--skip-freshness`, and require the FAIL | A green gate reached by weakening a clause is worse than the red one you started with. |
| "Did the self-test change anything?" | `git status --porcelain` emptiness | `G7.4`'s BEFORE/AFTER delta + tracked-input checksums | Absolute emptiness conflates "the self-test changed nothing" with "the caller had no edits in progress" — and Phase 3 legitimately dirties `main.tex` + the PDF. |
| Approx-tilde, times sign, quotes, ranges in LaTeX | hand-rolled math-mode escapes | `\textasciitilde{}`, `$\times$`, plain `"`, `--` | Three of the four have a measured wrong answer (Pitfalls 1–4). |

**Key insight:** everything expensive in this phase has already been built and *proven to fail on a broken input* (Phase 1's `G8.x` controls, Phase 2's negative controls, the P2 net's per-class FAIL demonstrations). The failure mode here is not missing tooling — it is **not running the tooling often enough**, which is exactly what IG-01 (a 27-assertion net with zero invokers) is.

## Runtime State Inventory

> Included because Phase 3 performs targeted string removal (D-05 retires two figures) and mutates derived/threshold state. Most categories are genuinely empty for a static-document repo — stated explicitly rather than left blank.

| Category | Items found | Action required |
|---|---|---|
| Stored data | **None** — verified: this repo has no database, cache, or datastore. Tracked files are 47 `.md`, 7 `.xml`, 4 `.json` (all planning/spike data), 3 `.pdf`, 2 `.txt`, 2 `.sh`, 2 `.html`, 1 `.yml`, 1 `.tex`, plus images and build aux. No `.db`/`.sqlite`/`.env`. | none |
| **Live service config** | ⚠ **ONE REAL ITEM — `index.html:194-200` carries a parallel Adobe block that duplicates the retired figures.** `index.html:196` reads *"…Ray Data + PyTorch Lightning for offline inference achieving **3–8K images/sec on 32 GPUs** (**10–50× faster image loading**)."* It is published to GitHub Pages by `.github/workflows/jekyll.yml` on every push to `master`. ROADMAP criterion 3 is **PDF-scoped** ("survives anywhere in the PDF"), and `SITE-01`/`SITE-02` are **Phase 6**, so this is *not* Phase-3 scope — but after Phase 3 the live public site will contradict the resume on exactly the two claims the honesty requirement removed. The audit already notes "no assertion anywhere checks resume↔site agreement" (`IG` evidence for SITE-02). | **Phase 3 must RECORD this, not fix it.** Add an explicit `[Phase 3]` handoff bullet to `.planning/STATE.md` naming `index.html:196` (retired figures) alongside the already-known `index.html:207-225` (career-break entry, SITE-02) so Phase 6 / SITE-01 inherits a concrete obligation. See OQ-2. |
| OS-registered state | **None** — verified: no launchd/cron/Task-Scheduler entry references this repo; both gate scripts are invoked by hand or by `make`. | none |
| Secrets / env vars | **None** — verified: the harness reads only `VERIFY_PDF`, `VERIFY_TEX`, `VERIFY_TMPDIR`, `ALLOW_FROZEN_UPDATE`; the P2 net reads the first three. All are optional path/flag overrides; no credential is read, written, or logged. | none |
| Build artifacts / derived state | **FOUR real items.** (1) `docs/AshutoshTiwari.{pdf,log,fdb_latexmk}` are tracked and must be regenerated and committed **with** the source (`G0.3` md5). (2) `docs/AshutoshTiwari.{aux,fls,out}` are tracked and may change. (3) `docs/verify/manifest.txt` `KEYWORDS_REQUIRED`/`KEYWORDS_TARGET` — a **code edit** (how future runs are judged), not a data migration; must land in the same commit as the text that lands the keyword. (4) `WARN_OWNERS` `G6.13` ownership — same. | rebuild + commit together; two one-line manifest edits |
| Retired-string reachability | In-scope surfaces: **only** `docs/main.tex:155` + the derived PDF/text layer. Verified absent from `docs/verify/*` and all `scripts/`. Out-of-scope-but-present: `index.html:196` (row above) and `.planning/` prose (ROADMAP:69, REQUIREMENTS:21, PROJECT.md:64, `research/{SUMMARY,FEATURES,PITFALLS}.md`) — the planning corpus retains them **by design** as the record of what was retired and why, and must **not** be rewritten. | source edit + rebuild is sufficient for the PDF; do not "clean" `.planning/` |

**The canonical question — after every file in the repo is updated, what still has the old string?** Answer for this phase: **the tracked build artifacts (regenerated by `make build` in the same commit) and `index.html:196` (Phase 6 / SITE-01).** There is no database, service, or OS registration holding a stale copy. The `index.html` duplicate is the one item a grep-only audit of `docs/` would have missed entirely — which is precisely why this section exists.

## Validation Architecture

> `workflow.nyquist_validation` is absent from `.planning/config.json` → treated as **enabled**. This section is the input to `03-VALIDATION.md`. Every command below was run live this session against the committed artifact.

### Test Framework

| Property | Value |
|----------|-------|
| **Framework** | bespoke **bash gate harness** — no pytest / jest / any test runner. `scripts/verify-resume.sh` (gate groups G0–G8; **83 RESULT lines, 39 distinct IDs**; today 60 PASS / 0 FAIL / 15 WARN / 8 INFO) driven by `docs/verify/manifest.txt` (mutable thresholds) + `docs/verify/baseline-frozen.txt` (honesty freeze). Plus `scripts/verify-phase2-regressions.sh` — the standing content net, **27 RESULT lines (P2.1–P2.27), 27 PASS, exit 0**. |
| **Config files** | `docs/verify/manifest.txt` · `docs/verify/baseline-frozen.txt` |
| **Inverted controls** | `make verify-selftest` → `bash scripts/verify-resume.sh --selftest` emits **10** `G7`/`G8` RESULT lines: `G7.1–G7.4` (the `+PROBE_LINES` overflow probe — proves the build accepts +5 lines *silently*, that the probe genuinely overflows, that `G1.1`+`G2.1` both catch it, and that the committed artifact was byte-unchanged) and `G8.1–G8.6` (one negative control per assertion class: honesty, geometry, staleness, glyph, keyword). Runs against the **default** inputs only. |
| **Quick run command** | `bash scripts/verify-phase2-regressions.sh` (<1s, content only, no rebuild) |
| **Full suite command** | `make build && bash scripts/verify-resume.sh && bash scripts/verify-phase2-regressions.sh && make verify-selftest` |
| **Estimated runtime** | build ~2s · harness ~3s · P2 net <1s · self-test ~14s → **~20s full** |

**Exit vocabulary (identical in both scripts):** `0` = every assertion passed · `1` = the document is wrong · `2` = cannot verify (missing tool/artifact/anchor — never reported as a pass).

**Three standing prohibitions, all measured:**
- **Never gate on `make verify`.** GNU Make 3.81 collapses a recipe's exit 1 *and* exit 2 into its own **2** (reproduced this session). `bash scripts/verify-resume.sh` is the only invocation that exposes the three-way vocabulary. ROADMAP criterion 5 says "`make verify` passes" — satisfy it by asserting the underlying `bash` invocations, and record `make verify` exit 0 as corroboration.
- **Never `make clean` before verifying.** It deletes `*.fdb_latexmk`, the record `G0.3`'s md5 freshness proof reads, and degrades the `G8.3` staleness control to SKIP.
- **Never put `--skip-freshness` (harness) or `--gate-text` (P2 net) in a Makefile recipe.** Both scripts' own help text says a run carrying them certifies nothing.

**bash portability:** PATH `bash` here is 5.3.15 but `/bin/bash` is **3.2.57**, and both existing scripts are deliberately 3.2-safe (no arrays, no `mapfile`, no `local`, no `[[`, no `${x,,}`). Both verified green under `/bin/bash` this session. Any new P3 script must hold that bar or a 5.x-only construct will pass locally and break for the next reader.

### Phase Requirements → Test Map

| Req ID | Behavior to prove | Test type | Automated command | File exists? |
|--------|------------------|-----------|-------------------|--------------|
| **EXP-02** a | Adobe block **opens** on fault-tolerance / distributed-inference language (ROADMAP crit. 2, second clause) — *no existing gate covers this* | regression (new) | `bash scripts/verify-phase3-regressions.sh` → `P3.1`: the first non-empty extracted line strictly **after** the `GENERATIVE AI, COMPUTER VISION, LARGE LANGUAGE MODELS` subtitle must match one of the locked lead anchors (`fault-tolerant`, `fault-tolerance`, `distributed inference`) — a `region_first_nonempty`-shaped clause, anchor-free w.r.t. the rest of the bullet | ❌ **Wave 0** |
| **EXP-02** b | Governance topic group present and framed as Rust fault-tolerant distributed systems, **never** as inference optimization | regression (new) | `P3.2–P3.4`: `assert_present` on `$SQUEEZED` for `27,135`, `claim/receipt`, `immutable S3 evidence layouts`; `assert_absent` on the source for the forbidden framing tokens (e.g. `governance … throughput`, `governance … latency`) | ❌ **Wave 0** |
| **EXP-02** c | No true claim disappeared implicitly (crit. 1) — Falcon-40B, Llama 2 70B, KEDA-on-SQS-depth survive | regression (new) + gate | `P3.5–P3.7`: `assert_present` `Falcon-40B`, `Llama 2 70B`, `SQS queue depth` on `$SQUEEZED`; plus `bash scripts/verify-resume.sh` → `G6.5` ×13 all PASS (the fragile-keyword map is the reason) | ❌ **Wave 0** |
| **EXP-02** d | The rebuild still fits page 1 | gate | `bash scripts/verify-resume.sh` → **`G1.1` PASS** (2 pages — *primary* fit gate), `G2.1` PASS, `G2.2`/`G2.3` PASS, `G3.1` PASS, `G3.4` PASS (0 words outside the page box), and record `G3.2` p1 headroom | ✅ |
| **EXP-03** a | `torch.compile` present in the text layer **with the dot** (ROADMAP crit. 2, first clause) | gate + regression | `bash scripts/verify-resume.sh` → `G6.5 PASS … 'torch.compile'` **after** promotion; pre-promotion, `P3.8`: `assert_present 'torch.compile(mode="max-autotune")' "$SQUEEZED"` | ✅ / ❌ Wave 0 |
| **EXP-03** b | Promotion actually happened in the same commit (unenforced by `G6.6` — see §Keyword Mechanics Trap B) | regression (new) | `P3.9`: `torch.compile` present in the text layer **AND** listed in `KEYWORDS_REQUIRED` **AND** absent from `KEYWORDS_TARGET`; same triple for `A100`, `H100` (`P3.10–P3.11`) | ❌ **Wave 0** |
| **EXP-03** c | D-08 outcome recorded; bridge wording matches the branch taken | checkpoint + manual | `checkpoint:human-verify` (see §D-08). Automated half: `grep -Fc '[Phase 3 / D-08]' .planning/STATE.md` returns 1 and names either `cudagraphs-confirmed` or `triton-only-fallback`; if fallback, `P3.12`: `assert_absent 'CUDA' "$SQUEEZED"` scoped to the Adobe bridge clause | ❌ **Wave 0** |
| **EXP-04** a | Neither retired figure survives **anywhere** in the PDF (crit. 3) | regression (new) | `P3.13–P3.16`: `assert_absent` in **both** streams for `10–50` and `3–8K images/sec on 32 GPUs` — ⚠ **EN DASH U+2013 form, not the ASCII `10--50`** (Pitfall 4). Verified 0/0 on the measured replacement. | ❌ **Wave 0** |
| **EXP-04** b | Every replacement figure present and traceable to a named `CODEBASE-EVIDENCE.md` entry | regression (new) + doc | `P3.17+`: `assert_present` on `$SQUEEZED` for each shipped figure (`1.09M`, `8` + `A100`, `24` + `A100-40GB`, `64` + `H100`, `202.6M`, `24.8M`, `700M`, `35–38M`, `40-node`) — only for the figures actually shipped. Traceability itself is a **doc assertion**: the plan/SUMMARY table maps figure → `CODEBASE-EVIDENCE.md` line. | ❌ **Wave 0** |
| **EXP-04** c | Glyph hygiene survives the new figures | gate | `bash scripts/verify-resume.sh` → **`G6.4` PASS** (every non-ASCII codepoint declared in `NONASCII_ALLOW`). ⚠ `$\sim$` → U+223C is **not** allowed → BLOCKER; use `\textasciitilde{}` (Pitfall 2). Verified: the D-05 swap keeps `G6.4` PASS with U+2013 38→36, U+00D7 unchanged at 1. | ✅ |
| **EXP-07** a | Swiggy + Flipkart each carry an adoption-count or failure-class-closure claim (crit. 4, first clause) | regression (new) | `P3.20+`: `assert_present` on `$SQUEEZED` for `18M+` (Swiggy adoption), `4Bn rows`, `10K QPS`, `fault isolation across clusters` (D-09 closure) and Flipkart's `first workflow at Flipkart` + its named error class (D-10) | ❌ **Wave 0** |
| **EXP-07** b | Digit-bearing page-1 bullet count **≥ baseline 8** (crit. 4, second clause) | gate | `bash scripts/verify-resume.sh` → `G5.4` message must read **8 or higher** against `DIGIT_BULLET_FLOOR=7`. ⚠ `G5.4` is `warn`-tier and does **not** gate, and it cannot see a digit that wrapped onto a continuation line (Pitfall 5) — so the plan must assert the *number in the message*, not merely "no FAIL". Do **not** lower `DIGIT_BULLET_FLOOR`. | ✅ (assert the value) |
| **EXP-07** c | Line-neutrality of the Swiggy/Flipkart edits (D-11) | gate (differential) | rendered-line count of gate regions 36–46 (Swiggy, **8** today) and 54–62 (Flipkart, **9** today) unchanged before/after; corroborated by `G3.2` p1 moving by exactly the Adobe delta | ✅ |
| **EXP-08** a | Pre-approval: drafts are **absent** from `docs/main.tex` (D-14 absent-by-default) | regression (new) | `P3.30+`: `assert_absent` in **both** the source *and* the text layer for each draft's distinctive literal (e.g. `STS`, `AssumeRole`, `6-week`, `mentored`) — asserted **before** the checkpoint. Catches the LaTeX-comment leak that no `G`-gate can see. | ❌ **Wave 0** |
| **EXP-08** b | Post-approval: exactly the approved bullets shipped, each still ⚠-scoped, and the record exists | checkpoint + regression | `checkpoint:decision gate="blocking"` (schema in §Checkpoint Mechanics). Automated: `grep -Fc '[Phase 3 / EXP-08]' .planning/STATE.md` returns 1; then per-bullet — **approved** → `assert_present` its literal; **rejected** → `assert_absent` its literal. **Both outcomes are green** (D-14). | ❌ **Wave 0** |
| **EXP-08** c | Approved bullets did not blow the budget | gate | re-run the full fit block (`G1.1`, `G2.1`, `G3.2`) after the conditional wave; ⚠ at the `+4` end-state only **+4.7pt** remains — reserve ≥1 line (11.5pt) through the rebuild to fund an approval | ✅ |
| **IG-01** | The P2 net is reachable from `make` | gate | `make verify-regressions` exits 0 and prints 27 PASS; `make -n verify` shows `bash scripts/verify-phase2-regressions.sh` in the recipe | ❌ **Wave 0** (Makefile edit) |
| **IG-03** | `G6.13` WARN ownership claimed | gate | `bash scripts/verify-resume.sh` → all five `G6.13` lines read `(owner: Phase 3)`; `grep -c 'G6.13:unassigned' docs/verify/manifest.txt` returns 0 | ✅ (one-line manifest edit) |
| **anti-tautology** (every new P3 assertion) | Each new assertion has been **observed FAILING** | negative control | `git show <pre-Phase-3>:docs/main.tex` → `mktemp -d` (basename **must** stay `main.tex` — the freshness record is looked up by source filename), rebuild there, run the P3 net against it, and require the FAIL. Phase 1's rule: *an assertion never observed failing is not a gate.* | ❌ **Wave 0** |

### Sampling Rate

- **After every task commit** (max feedback latency ~6s):
  ```bash
  make build && bash scripts/verify-resume.sh && bash scripts/verify-phase2-regressions.sh && bash scripts/verify-phase3-regressions.sh
  ```
  Then **read, in this order**: `G1.1` (fit — the primary alarm) → `G2.1` (page-1 boundary) → **`G3.2` p1 headroom in pt *and* lines (record it in the task evidence)** → `G5.4` value → `G6.5` ×13 → `G6.6` (which targets landed) → `G6.4` (glyph census).
- **After every plan wave** (~20s): add `make verify-selftest` and require exit 0 with **10** `G7`/`G8` PASS and **no SKIP**. This is where the `G7.2` margin is checked:
  - `G7.2` margin = `PROBE_LINES × LINE_PT − p1 slack` = `57.5pt − <G3.2 p1>`.
  - **Spending grows the margin** (safe): at the `+4` end-state the margin is 52.8pt.
  - **Net-freeing ≥1 rendered line breaks it** — reproduced: freeing one line took slack to 61.4pt and the +5 probe rendered only 2 pages, i.e. `G7.2 FAIL`. **No wave may end in a net-freed state.** `PROBE_LINES` is raise-only; do not raise it to paper over a mid-phase free.
- **Budget re-measure after every build** (not every commit — every *build*): `G3.1` deepest-bottom and `G3.2` p1 headroom. The ceiling is **+4 rendered lines from the 713.9pt baseline**; `+5` is a 3-page document. Predicting instead of measuring is the specific failure Phase 2 recorded.
- **Before `/gsd-verify-work`:** full suite green, plus `make verify` exit 0 recorded as ROADMAP-criterion-5 corroboration, plus the five-employer extraction-order readout (WR-01, §Code Examples E-4).

### Wave 0 Requirements

Wave 0 is a real, non-trivial wave for this phase — the harness covers page fit, glyphs, honesty and keyword *presence*, but **nothing** currently asserts a single one of Phase 3's own locked literals, its lead-bullet voice, the keyword-promotion pairing, or the EXP-08 absent-by-default rule.

- [ ] **`Makefile`** — add `verify-regressions` target, add it to `.PHONY`, chain it **first** in the `verify` recipe, and add its line to the header target index (IG-01 + IG-02). *No `$(PDF)` prerequisite; no `--gate-text`.*
- [ ] **`docs/verify/manifest.txt`** — `WARN_OWNERS`: `G6.13:unassigned` → `G6.13:3` (IG-03). *Do not add `ROLE_BIND_WINDOW`; Phase 3 claims the WARN, it does not promote the gate.*
- [ ] **`scripts/verify-phase3-regressions.sh`** — new standing net, `P3.` ID namespace, mirroring the P2 net exactly: `set -uo pipefail` (no `errexit` — every assertion must run and aggregate), `emit`/`die2`/`gcount`/`assert_present`/`assert_absent`/`assert_whole_line_once` helpers, dual `gate.txt` (form-feed→newline) + `squeezed.txt` (`tr -s ' \t\n' ' '`) streams, `mktemp -d` scratch with an inline trap, `LC_ALL=C` on every grep, bash 3.2-safe, `shellcheck -f gcc` clean, exit 0/1/2. Assertion groups: **EXP-02a** lead-bullet voice (region-first clause) · **EXP-02b/c** governance literals + retained true claims · **EXP-03** `torch.compile` literal + promotion triple · **EXP-04** the two retired figures absent (EN DASH) + replacement figures present · **EXP-07** Swiggy/Flipkart claim literals · **EXP-08** draft literals absent pre-approval. *Keep it a separate file, not new `G6.x` gates — Phase 2's `02-02-PLAN.md` criterion 11 pinned the harness's 83 RESULT lines / 39 IDs and the `G7`/`G8` controls count them.*
- [ ] **Negative controls** for every new P3 assertion class, proven against the pre-Phase-3 artifact pair via `git show` into `mktemp -d` with the basename preserved.

*Framework install: none needed — `latexmk`, `pdftotext`, `pdfinfo`, `python3`, `bash`, `make`, `shellcheck` are all present (§Environment Availability).*

### Manual-Only Verifications

| Behavior | Why not automatable | Mitigation |
|---|---|---|
| **D-08 config read** — genie's `content_type_classifier` compile config carries no `max-autotune-no-cudagraphs` / `triton.cudagraphs=False` | The genie source repo is **not on this machine** (verified: no `~/code/genie`; `~/code/ai-platform/aidoc/{genie,glimmer}` are docs trees with no `modules/dp/content_type_classifier`) | `checkpoint:human-verify` with a copy-pasteable `sed`+`grep` command and a **pre-authorized Triton-only fallback**, so an unavailable read cannot block the phase. Outcome recorded behind a `[Phase 3 / D-08]` marker (that half *is* automated). |
| **EXP-08 per-bullet approval** | Requires the user's judgment on provisional figures against the rendered PDF | `checkpoint:decision gate="blocking"`; the *record* is grep-asserted and each verdict yields an automated present/absent assertion afterwards. |
| **"Reads as staff signal, not job description"** (crit. 2's qualitative half) | Prose quality is not machine-checkable | The P3.1 region-first clause automates the mechanical part ("opens on FT/DI language"); the qualitative read belongs to the EXP-08 checkpoint's `<context>`, where the user is already reading the rendered block. |

### Validation Sign-Off Checklist (for `03-VALIDATION.md`)

- [ ] Every task has an `<automated>` verify or a named Wave 0 dependency
- [ ] No 3 consecutive tasks without an automated verify
- [ ] Wave 0 covers all ❌ rows above (Makefile, manifest, `verify-phase3-regressions.sh`, negative controls)
- [ ] No watch-mode flags (`latexmk -pvc` never appears in a verify path)
- [ ] Feedback latency < 20s
- [ ] Every new P3 assertion observed FAILING on the pre-change artifact
- [ ] `nyquist_compliant: true` set in frontmatter

## Common Pitfalls

### Pitfall 1 — `G3.1`/`G3.2` do not fire on overflow; `G1.1` does
**What goes wrong:** a plan verifies "page fit" by checking `G3.1 PASS` and ships a 3-page PDF.
**Why:** with `\raggedbottom`, LaTeX *breaks the page* instead of overrunning `\textheight`, so the ceiling comparison stays green. Measured at `+5` lines: `G3.1 PASS (760.3pt vs 764.4pt)`, `G2.3 PASS`, `G2.4 INFO 0` — and `G1.1 FAIL` + `G2.1 FAIL`.
**Avoid:** read `G1.1` first, always. `G4.5`'s own INFO line says so.
**Warning sign:** `G3.2` reporting a *third* page (`p3 +53.5pt`).

### Pitfall 2 — `$\sim$` for "~700M" is a BLOCKER
**What goes wrong:** D-06's `~700M-asset catalog` written as `$\sim$700M` extracts as **U+223C**, which is not in `NONASCII_ALLOW=2013,2019,2022,2192,2206,00D7,2014,201C,201D` → `G6.4 FAIL`.
**Verified both ways:** `$\sim$` → `∼` U+223C (census shows it); `\textasciitilde{}` → plain ASCII `~` U+007E, census clean.
**Avoid:** `\textasciitilde{}700M`, or word forms (`about`, `nearly`, `700M+`).
**Also verified:** a bare `~` in LaTeX is a **non-breaking space** and silently extracts as a space (`700M asset`) — the tilde vanishes with no warning.

### Pitfall 3 — quotes and `torch.compile` are safe; verified, not assumed
**What could go wrong:** `torch.compile(mode="max-autotune")` produces curly quotes (U+201C/U+201D) or the token breaks across a wrap, defeating the `G6.5` substring match.
**Measured:** neither happens. Plain `"` renders and extracts as **ASCII U+0022** (`sourcesanspro` + `\pdfgentounicode=1`); the census showed **zero** U+201C/U+201D added. Two wrap-stress probes moved the whole `torch.compile(...)` token to the next line rather than splitting it.
**So:** write the literal plainly. `\texttt{}` and `\char34` also work but are unnecessary. `%`, `$`, `#`, `&` still need their normal escapes; `_` would too (none of the locked strings contain one — `max-autotune-no-cudagraphs` and `triton.cudagraphs=False` are hyphen/dot only, both verified to typeset and extract cleanly).

### Pitfall 4 — criterion 3's absence assertions must use the EN DASH
**What goes wrong:** asserting `assert_absent '10--50'` (ASCII) trivially passes on *today's* document — the source writes `10--50` but the text layer contains `10–50` (U+2013). The assertion is vacuous and would never catch a reintroduction.
**Verified:** on the measured replacement both `10–50` and `10--50` return 0, but only the EN DASH form was ever non-zero.
**Avoid:** assert the **rendered** form (`10–50`, `3–8K images/sec on 32 GPUs`) against both the gate and squeezed streams, under `LC_ALL=C` for byte-exactness. Optionally *also* assert the source form absent from `docs/main.tex` — that catches the source-side reintroduction (the P2 net uses exactly this dual source+text-layer shape for its forbidden forms).

### Pitfall 5 — `G5.4` cannot see a figure that wrapped
**What goes wrong:** D-06 spreads scale figures across topics; a figure appended to a topic's *continuation* line does not increase the digit-bullet count, so criterion 4's "≥ baseline" can silently stall.
**Why:** the regex is `^[[:space:]]*(•|▪|◦|·|–|—|\*|-).*[0-9]` over page-1 text — it matches only lines that **begin with a bullet glyph** (here U+2013, from `\labelitemiii`/the itemize-2 default) and contain a digit. A wrapped continuation starts with a word.
**Live proof:** Swiggy's Feature Store bullet carries `(4Bn rows, 10K QPS)` on gate line 43, a continuation — and line 43 is **absent** from the `G5.4` match set (which is 15, 16, 21, 22, 36, 46, 61, 70 = 8).
**Avoid:** put at least one digit on each bullet's **first** rendered line when the count matters; assert the *number in the `G5.4` message*, not the absence of a FAIL.

### Pitfall 6 — the promotion trap (both halves)
`G6.6` is `warn`-only **unconditionally** — nothing fails if you add a target keyword and forget to promote it. And promoting with the `:phase` suffix intact makes `G6.5` grep for `torch.compile:3` and **FAIL** (reproduced). Strip the suffix; pair the text edit and the manifest edit in one commit; assert the pairing (§Keyword Mechanics).

### Pitfall 7 — five single-occurrence BLOCKER keywords live in the rewrite zone
`Rust` ×1 (Adobe `:163`), `SQS` ×1 (`:156`), `Flash Attention` ×1 (`:161`), `FSDP` ×2-from-one-string (`:160`), `fault` ×1 (Swiggy `:175`) — plus `distributed` ×2 both inside the two FMTF sub-items, and `Kubernetes` ×2 both in Adobe. Any careless reword turns `G6.5` red. Give the criterion-1 table a "keywords carried" column and add P3 presence assertions.

### Pitfall 8 — the governance group with a nested item eats the entire budget
Measured: `\resumeTopic` + nested `\resumeItemListStart` with one item = **4 rendered lines**, leaving `+5.7pt`. Add D-05's `+1` line and the document is 3 pages. Ship the topic **without** the nested item (2 lines, leaves `+28.1pt`), or pay by tightening — never both additively.

### Pitfall 9 — freeing budget breaks the self-test
Reproduced: shortening one Adobe topic from 2 rendered lines to 1 raised slack to **61.4pt**, and the replicated `+5` probe rendered 2 pages → `G7.2 FAIL`. Spend before you free; no wave may end net-freed. Note `G7` runs only under `--selftest`, so `bash scripts/verify-resume.sh` stays green and this failure is *only* visible if the wave actually runs `make verify-selftest`.

### Pitfall 10 — bash 3.2 vs 5.3, and shell-safety idioms
`/bin/bash` is 3.2.57 while PATH `bash` is 5.3.15. A new P3 script using arrays, `mapfile`, `local`, `[[`, or `${x,,}` passes locally and breaks under `/bin/bash`. Also copy three non-obvious idioms from the P2 net: `emit` must never run inside a pipeline or command substitution (the `FAILURES` increment would be lost in a subshell — feed `while read` from a redirect or here-doc); `grep -Fc` prints `0` and exits 1 on no match but prints **nothing** on an unreadable file, so normalize to the sentinel `-1` and report it as FAIL/unmeasurable; and `set -uo pipefail` **without** `errexit`, so one zero-count grep cannot abort the run.

### Pitfall 11 — commit shape
Artifacts (`.pdf`, `.log`, `.fdb_latexmk`) ride in the **source** commit. A source-only commit makes a fresh checkout of *that* commit refuse at `G0.3` exit 2. And the negative-control copy must keep the basename `main.tex` — the freshness record is looked up by source filename, so a renamed copy silently escalates to the L2 arbiter and disarms the staleness control.

### Pitfall 12 — rebuilding from the evidence file alone
`PITFALLS.md:689-696` names this the phase's signature failure: starting from `CODEBASE-EVIDENCE.md` makes anything it does not restate look like it was never there. Falcon-40B, Llama 2 70B, `Source → Transform → Sink`, KEDA-on-SQS-depth are **not** all in the evidence file — that makes them unverified-by-that-pass, not false. D-03 mandates retain-and-revise; the criterion-1 table written **before** new text is the mechanism.

## Code Examples

### E-1 — the per-commit measurement loop
```bash
make build \
  && bash scripts/verify-resume.sh \
  && bash scripts/verify-phase2-regressions.sh \
  && bash scripts/verify-phase3-regressions.sh
# read in this order:
bash scripts/verify-resume.sh 2>/dev/null \
  | grep -E '^RESULT (G1\.1|G2\.1|G3\.1|G3\.2|G5\.4|G6\.4)|^RESULT G6\.[56] '
```

### E-2 — probe a candidate edit without touching the repo
```bash
W=$(mktemp -d); cp docs/main.tex "$W/main.tex"      # basename MUST stay main.tex
# ...edit "$W/main.tex"...
( cd "$W" && latexmk -pdf -interaction=nonstopmode -halt-on-error -jobname=AshutoshTiwari main.tex )
bash scripts/verify-resume.sh --pdf "$W/AshutoshTiwari.pdf" --tex "$W/main.tex" \
  | grep -E 'G1\.1|G2\.1|G3\.2|G5\.4'
```

### E-3 — measure per-line vertical cost and indent depth
```bash
pdftotext -bbox-layout docs/AshutoshTiwari.pdf /tmp/bbox.html
python3 - <<'PY'
import re
h=open('/tmp/bbox.html',encoding='utf-8').read()
p1=re.findall(r'<page [^>]*>(.*?)</page>', h, re.S)[0]
ls=re.findall(r'<line xMin="([\d.]+)" yMin="([\d.]+)" xMax="([\d.]+)" yMax="([\d.]+)">(.*?)</line>', p1, re.S)
prev=None
for xm,ym,xM,yM,body in ls:
    t=re.sub(r'\s+',' ',re.sub(r'<[^>]+>','',body)).strip(); y=float(ym)
    print(f"x={float(xm):6.1f} y={y:6.1f} dY={'' if prev is None else f'{y-prev:+.2f}'}  {t[:60]}")
    prev=y
PY
# measured: intra-item pitch 10.96pt; inter-item 11.21-11.46pt; itemize-2 x=48.4/48.9,
# itemize-3 x=60.9, continuations x=57.1/68.8; nested-list overhead ~0pt
```

### E-4 — WR-01: employer-vs-subtitle extraction order, all five roles
```bash
pdftotext docs/AshutoshTiwari.pdf - | python3 -c '
import sys
t=sys.stdin.read().split("\f")[0].split("\n")
emp={"ADOBE FIREFLY":"GENERATIVE AI, COMPUTER VISION, LARGE LANGUAGE MODELS",
     "SWIGGY":"DATA SCIENCE PLATFORM, TIME SERIES FORECASTING",
     "FLIPKART (a Walmart company)":"SEARCH RELEVANCE, QUERY INTENT, NLP",
     "GROUPON":"BACKEND ENGINEERING",
     "NETSPEED SYSTEMS (Acquired by Intel)":"GRAPH ALGORITHMS, NETWORK ON CHIP"}
for e,s in emp.items():
    ie = t.index(e)+1 if e in t else None; isu = t.index(s)+1 if s in t else None
    ok = "employer-first" if (ie and isu and ie<isu) else "FLIPPED"
    print(f"{e:38s} emp@{ie} sub@{isu} -> {ok}")'
# baseline: FLIPKART is FLIPPED. Any Adobe growth of >=1 rendered line resolves it
# (measured at +1/+2/+3/+4). Treat as a y-position accident, not a property.
```

### E-5 — the promotion pairing assertion (EXP-03b)
```bash
kw_promoted() {  # kw_promoted <literal>
  pdftotext docs/AshutoshTiwari.pdf - 2>/dev/null | tr '\f' '\n' \
    | LC_ALL=C grep -qF -- "$1" || return 1
  LC_ALL=C grep '^KEYWORDS_REQUIRED=' docs/verify/manifest.txt \
    | tr '|' '\n' | LC_ALL=C grep -qxF -- "$1" || return 1
  LC_ALL=C grep '^KEYWORDS_TARGET=' docs/verify/manifest.txt \
    | tr '|' '\n' | LC_ALL=C grep -q "^$(printf '%s' "$1" | sed 's/[.[\*^$]/\\&/g'):" && return 1
  return 0
}
for k in torch.compile A100 H100; do kw_promoted "$k" && echo "OK $k" || echo "BAD $k"; done
```

### E-6 — count the free tail room before writing into it
```bash
pdftotext docs/AshutoshTiwari.pdf - | sed -n '1,/\f/p' | awk 'NR>=11 && NR<=28 {printf "%2d %3d  %s\n", NR, length($0), substr($0,1,50)}'
# a last-rendered-line under ~120 chars has (120 - length) free chars at ZERO pt cost
# (verified: +145 chars across three tails left G3.2 p1 unchanged at +50.5pt)
```

### E-7 — anti-tautology negative control
```bash
PRE=$(git rev-parse HEAD)                      # capture BEFORE the phase's first content commit
W=$(mktemp -d); git show "$PRE:docs/main.tex" > "$W/main.tex"   # basename preserved
( cd "$W" && latexmk -pdf -interaction=nonstopmode -halt-on-error -jobname=AshutoshTiwari main.tex )
bash scripts/verify-phase3-regressions.sh --pdf "$W/AshutoshTiwari.pdf" --tex "$W/main.tex"
# MUST exit 1 and name the P3 IDs the phase added. Exit 0 means the assertion is a tautology.
```

## State of the Art

No external library is adopted, so there is little to date. The one currency-sensitive fact:

| Old understanding | Current | When changed | Impact |
|---|---|---|---|
| `max-autotune` is "just autotuning" | Official PyTorch docs state verbatim that `max-autotune` *"leverages Triton or template based matrix multiplications … and Triton based convolutions on GPU"* and **"enables CUDA graphs by default on GPU"**, with `max-autotune-no-cudagraphs` as the opt-out variant | documented in `torch.compile` docs; recorded in `STACK.md:466-470`, verified 2026-08-21 against <https://docs.pytorch.org/docs/2.13/generated/torch.compile.html> | This is what licenses D-07's compiler-bridge clause (`Triton`, CUDA-graph capture, kernel fusion) as **compiler-mediated** claims with zero fabrication — three Tier-1 keywords for free. It is also why D-08's config read matters: the two disabling forms would revoke the CUDA-graph half. |

**Deprecated / must not appear** (`REQUIREMENTS.md` Out of Scope + `CODEBASE-EVIDENCE.md:9`): TensorRT / TRT-LLM, speculative decoding (also `PROHIBITED_PHRASES`), `Go` (`PROHIBITED_WORDS`), quantization, MoE / tensor / pipeline parallelism as *accomplishments*, and any summary/headline section. `G6.7` gates the first two families' literal forms; the rest are honesty rules the plan must hold by construction.

## Assumptions Log

| # | Claim | Section | Risk if wrong |
|---|---|---|---|
| **A1** | The mode string in genie's `content_type_classifier` is `max-autotune` and **not** `max-autotune-no-cudagraphs` | §D-08 | `[CITED: CODEBASE-EVIDENCE.md:54 / STACK.md:428,466]` — a research paraphrase of a source line, not the line itself. If wrong, D-07's CUDA-graph clause is unsupported. **Mitigated** by the D-08 checkpoint + pre-authorized Triton-only fallback. |
| **A2** | `torch._inductor.config.triton.cudagraphs` is not set to `False` in that module | §D-08 | `[ASSUMED]` — **no** artifact in this repo or on this machine speaks to it. Same mitigation as A1. This is the half the citation genuinely cannot discharge. |
| **A3** | ~120 chars is a safe conservative continuation-line capacity for the free-tail estimate | §Budget Arithmetic | `[VERIFIED: measured to 124 chars with zero pt cost]` at itemize-3 depth; the font is proportional so the true limit varies with glyph mix. If the estimate is optimistic, a tail append costs +1 line — caught immediately by `G3.2`. Low risk because the loop measures every build. |
| **A4** | Each approved EXP-08 bullet costs 1–2 rendered lines | §Checkpoint Mechanics | `[ASSUMED]` — depends on final wording. **Mitigated** by the recommendation to reserve ≥1 line (11.5pt) through the rebuild and to re-measure in the conditional wave. |
| **A5** | ROADMAP criterion 3's "anywhere in the PDF" is PDF-scoped and does not reach `index.html` | §Runtime State Inventory | `[VERIFIED: ROADMAP.md:69 verbatim]` — the criterion says "in the PDF". If a reviewer reads it as project-wide, `index.html:196` becomes Phase-3 scope. **Mitigated** by recording the handoff rather than silently ignoring it (OQ-2). |

## Open Questions

1. **OQ-1 — How is D-08's config read discharged?**
   - *What we know:* the read targets `glimmer/modules/dp/content_type_classifier/module.py:76-77`; the mode string is recorded as `max-autotune`; the fallback wording (Triton-only) is pre-decided by D-08 itself; `EXP-03`'s core and ROADMAP criterion 2 land on **either** branch.
   - *What's unclear:* the genie source repo is not on this machine, so the agent cannot read it; and the `triton.cudagraphs` surface is unaddressed by any recorded citation.
   - *Recommendation:* a `checkpoint:human-verify` in the wave that writes the bridge wording, with the two-command copy-paste, both branches pre-authorized, and the outcome recorded behind a `[Phase 3 / D-08]` marker. **Do not** block the phase on it.

2. **OQ-2 — Who fixes `index.html:196`?**
   - *What we know:* the live site repeats both retired figures verbatim and is published by `.github/workflows/jekyll.yml`; `SITE-01`/`SITE-02` are Phase 6; the audit already records that nothing asserts resume↔site agreement.
   - *What's unclear:* whether leaving an unprovenanced claim on the public site for three phases is acceptable given the milestone's honesty framing.
   - *Recommendation:* **Phase 3 records, Phase 6 fixes.** Add a `[Phase 3]` bullet to `.planning/STATE.md` naming `index.html:196` (retired figures) next to the known `index.html:207-225` (career break), so SITE-01 inherits a concrete, greppable obligation. Escalate to the user only if they want it pulled forward.

3. **OQ-3 — Promote `Triton` in a Phase-3 commit, or phrase around it?**
   - *What we know:* D-07's honest bridge names Triton-generated kernels; `manifest.txt` assigns `Triton:5`; the manifest's rule is "the commit that adds it promotes it"; `G6.6` will not catch a miss.
   - *Recommendation:* **promote it** and record that Phase 3 landed a Phase-5-owned target early — ownership is a WARN-routing label, not a permission, and PG2-04's Skills-tier form remains additive. Worth one line in the plan so it is a decision, not an accident.

4. **OQ-4 — Does the phase add a Work-Experience employer-first assertion (WR-01 option b)?**
   - *What we know:* the Flipkart flip self-heals at ≥1 line of Adobe growth (measured), but it is a y-position accident; `region_first_nonempty` exists and carries the NT-02 empty-arg caveat.
   - *Recommendation:* **document + measure (option a) this phase**, and note the assertion as a Phase-4 candidate (Phase 4 shifts page 2, so it can own a page-1-stable clause). Adding it as a BLOCKER now lets a future cosmetic y-shift redden the gate. This sits inside the agent's discretion per CONTEXT.

## Environment Availability

| Dependency | Required by | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| `latexmk` | `make build`, `G7` probe, all scratch measurement | ✓ | 4.86a | — |
| `pdflatex` (pdfTeX) | the build engine | ✓ | 3.141592653-2.6-1.40.27 (TeX Live 2025) | — |
| `sourcesanspro.sty` | the document font (`make check` gates it) | ✓ | `kpsewhich` resolves | — |
| `pdftotext` (poppler) | text layer for `G2`/`G5`/`G6` + both nets | ✓ | 26.08.0 | — |
| `pdfinfo` (poppler) | `G1.1` page count, `G7.2` probe count | ✓ | 26.08.0 | — |
| `python3` | harness bbox parsing, glyph census, probe injection | ✓ | 3.11.12 | — |
| `bash` | both gate scripts | ✓ | `/bin/bash` **3.2.57** · PATH `bash` 5.3.15 | — (write 3.2-safe; see Pitfall 10) |
| GNU `make` | target orchestration | ✓ | **3.81** | — (never gate on its exit code) |
| `shellcheck` | lint the new P3 net (`-f gcc`, 0 findings) | ✓ | 0.11.0 | skip lint; would drop below Phase 2's recorded quality bar |
| `git` | negative controls via `git show` | ✓ | 2.50.1 (Apple Git-155) | — |
| **genie source repo** (`glimmer/modules/dp/content_type_classifier/module.py`) | **D-08 config read only** | ✗ | — | **✓ pre-authorized:** D-08's Triton-only bridge wording; or a `checkpoint:human-verify` asking the user to read their own checkout |

**Missing dependencies with no fallback:** none.
**Missing dependencies with fallback:** the genie checkout (D-08) — fallback is decision-level and already locked by D-08 itself, so it cannot block the phase.

## Security Domain

> `security_enforcement` is absent from `.planning/config.json` → treated as **enabled**. This is a static-document repository with no network surface, no user input, and no runtime; the honest reading is that most ASVS categories are structurally inapplicable, and the real integrity control is the honesty freeze.

### Applicable ASVS Categories

| ASVS Category | Applies | Standard control |
|---------------|---------|------------------|
| V2 Authentication | **no** | No auth surface. The only credentialed operation in the milestone is `GH-01` (`gh api -X PATCH`) — **Phase 4**, not here. |
| V3 Session Management | **no** | No sessions. |
| V4 Access Control | **partially** | The meaningful analogue is *artifact* access control: `docs/verify/baseline-frozen.txt` is immutable this phase, and the harness refuses to regenerate the honesty freeze without `ALLOW_FROZEN_UPDATE=1` **and** a printed unified diff — a reviewed-edit gate, not a regeneration. Phase 3 must not set that variable. |
| V5 Input Validation | **yes** | `docs/verify/manifest.txt` is read **line-wise** by `manifest_get`/`manifest_list` and is *never sourced and never eval'd*, so a value containing shell metacharacters is inert data (the manifest's own header states this). Any new P3 script must preserve that property: read the manifest the same way, quote every expansion, and never `eval`. |
| V6 Cryptography | **no** (hashing only, not secrecy) | `G0.3` uses the latexmk **md5** record and `G4.1` a **sha256** geometry hash. Both are *change-detection*, not security primitives — do not "upgrade" md5 here; the value must match what latexmk writes. |
| V7 Error Handling & Logging | **yes** | Both scripts' exit-2 "cannot verify" channel is the security-relevant property: an unmeasurable assertion must never be reported as a pass. The P3 net must reproduce the `gcount` `-1` sentinel and the `die2`-with-no-RESULT-line discipline. |
| V12 File & Resource | **yes** | Scratch workspaces come from `mktemp -d` only, never from user input; removal is guarded by a non-empty + is-a-directory check inside an inline trap; nothing is ever written under `docs/`. Reuse verbatim. |
| V14 Configuration | **yes** | `--skip-freshness` (harness) and `--gate-text` (P2 net) are the two "certifies nothing" waivers and must never appear in a Makefile recipe. Adding a target that carries either is the one configuration change that would silently disarm the gate. |

### Known Threat Patterns for this stack

| Pattern | STRIDE | Standard mitigation |
|---|---|---|
| Unapproved claim ships (EXP-08 draft graduates from comment to live text) | **Tampering / Repudiation** | D-14 absent-by-default + drafts live only in the plan doc + `P3.30+` `assert_absent` on the draft literals in **both** source and text layer (a `%`-commented draft is invisible to every existing gate) |
| Threshold weakened to make a red gate green (`DIGIT_BULLET_FLOOR`, `PROBE_LINES`) | **Tampering** | Phase 1's recorded rule: a raise is a reviewed edit, never a regeneration; `PROBE_LINES` is raise-only; assert the *value* in the `G5.4` message rather than the absence of a FAIL |
| Honesty freeze edited to match a moved document | **Tampering** | `baseline-frozen.txt` untouched; `ALLOW_FROZEN_UPDATE` never set; `G5.1`/`G5.2`/`G5.5` exact-once whole-line assertions (×15 today, all PASS) |
| Stale artifact certified as fresh | **Spoofing** | `G0.3` md5 against the latexmk record, with the L2 scratch-rebuild arbiter as fallback; artifacts ride in the source commit; never `make clean` before verifying |
| New assertion that cannot fail (tautology) | **Repudiation** | mandatory negative control per assertion class against the pre-change artifact pair (E-7) |
| Unverifiable claim presented as verified | **Repudiation** | every figure traces to a named `CODEBASE-EVIDENCE.md` entry (criterion 3); `[ASSUMED]`/`[CITED]` tagging in this document; A1/A2 escalated as OQ-1 |
| Supply-chain | **Tampering** | **N/A** — zero packages installed (§Package Legitimacy Audit) |

## Sources

### Primary (HIGH confidence — measured or read directly this session)
- **Live harness runs** against the committed artifact and eight scratch variants (`+1/+2/+3/+4/+5` lines, tail-growth, `−1` line, governance-topic A/B, D-05 replacement) — every budget, gate, glyph, keyword and extraction-order figure in this document
- `scripts/verify-resume.sh` — `G5.4` regex (:1699-1705), `G6.5`/`G6.6` loops (:1733-1756), `warn`/`warn_owner`/`manifest_get`/`manifest_list` (:121-221), `G7` probe injection + anchor logic (:809-931), flag surface (:57-108)
- `scripts/verify-phase2-regressions.sh` — the full P2 pattern (dual streams, assertion helpers, exit vocabulary, bash-3.2 constraints); live run: 27/27 PASS
- `docs/verify/manifest.txt` (all 60 lines), `docs/main.tex` (:1-219), `Makefile` (:1-214)
- `.planning/phases/01-verification-harness/01-01-PLAN.md:139-…` — the verbatim `checkpoint:decision gate="blocking"` schema
- `.planning/phases/02-page-1-budget-text-layer-defects/02-VALIDATION.md`, `02-02-SUMMARY.md` (Next Phase Readiness), `02-REVIEW.md` (WR-01, NT-01, NT-02, NT-03)
- `.planning/v1.0-MILESTONE-AUDIT.md` (IG-01/IG-02/IG-03/IG-04, tech_debt, close-out order)
- `.planning/research/CODEBASE-EVIDENCE.md`, `.planning/research/STACK.md:313,384,428,460-495,592`, `.planning/research/PITFALLS.md:642,689-696,723,809`, `.planning/research/SUMMARY.md:21,34`
- Environment probes: `latexmk`, `pdflatex`, `pdftotext`, `pdfinfo`, `python3`, `bash`, `make`, `shellcheck`, `git` versions; `~/code` inventory; `find` for `genie`/`glimmer`/`content_type_classifier`; `.github/workflows/` inventory

### Secondary (MEDIUM confidence — recorded verbatim from an official source by an earlier pass)
- `torch.compile` `max-autotune` semantics — <https://docs.pytorch.org/docs/2.13/generated/torch.compile.html>, quoted verbatim in `STACK.md:466-470` and verified 2026-08-21. Not re-fetched this session; the quotation is what D-07's bridge rests on.

### Tertiary (LOW confidence — flagged for validation)
- A2 (`triton.cudagraphs` not disabled) — supported by **no** source. Escalated as OQ-1 with a pre-authorized fallback.

### Not consulted (and why)
- Context7 / web search — this phase adopts no library and no API; the only external doc claim (`max-autotune`) is already recorded verbatim with a URL and a verification date.
- `.opencode/skills/spike-findings-thunderock-github-io` — read; its scope is the **page-2 Projects section + GitHub presence** (`rollout` + `graph_ml`, `random_walk` privatization, README status line). Nothing applies to Phase 3 except two general constraints it restates and this document already honors: claims match repo reality, and the line budget is measured (it cites the page-**2** ~53.5pt slack, which Phase 3 does not touch).

## Metadata

**Confidence breakdown:**
- **Page-1 budget arithmetic — HIGH.** Eight scratch builds, harness-verified, linear at 11.4–11.5pt/line, ceiling located exactly (`+4` green / `+5` = 3 pages).
- **Gate mechanics (`G1.1` vs `G3.1`, `G5.4` regex, `G6.5`/`G6.6`, `G7.2` direction) — HIGH.** Each read from the harness source and then reproduced as a live run, including the two failure modes (`G6.5` on a suffixed promotion; `G7.2` on a net-freed source).
- **Fragile-keyword map — HIGH.** Computed from the actual text layer; every carrier line enumerated.
- **LaTeX pitfalls (tilde, times, quotes, wrap behaviour, en dash) — HIGH.** Two dedicated probe documents, glyph census on each.
- **Harness wiring / Make 3.81 behaviour — HIGH.** Ordering and exit-collapse both reproduced in a scratch Makefile.
- **Checkpoint schema — HIGH.** Read verbatim from the Phase-1 instance in this repo.
- **D-08 discharge path — MEDIUM.** The *unavailability* is HIGH-confidence (filesystem-verified); the recommended checkpoint+fallback is a judgment call, and A2 remains unsupported by any source.
- **EXP-08 line cost — MEDIUM.** Depends on final wording (A4); mitigated by the reserve-one-line recommendation.

**Repo state:** unchanged by this research — `git status --porcelain` reported `?? .omc/` (pre-existing) before and after; every measurement ran under `/tmp` with `--pdf`/`--tex` overrides.

**Research date:** 2026-08-22
**Valid until:** ~2026-09-21 (30 days). Re-measure the budget table if `docs/main.tex`, `docs/verify/manifest.txt`, or `scripts/verify-resume.sh` changes — the 713.9pt baseline and the `+4`-line ceiling are properties of the current document, not constants.

---
*Phase: 03-adobe-rebuild-staff-signal-bullets*
*Researched: 2026-08-22*
