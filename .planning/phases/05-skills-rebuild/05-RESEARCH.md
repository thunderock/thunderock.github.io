# Phase 5: Skills Rebuild - Research

**Researched:** 2026-08-24
**Domain:** LaTeX resume Skills-block rewrite + pdftotext/ATS keyword extraction + shell verification-harness mechanics (single-file `docs/main.tex`, no external packages)
**Confidence:** HIGH (every load-bearing claim verified this session against the committed artifact, the manifest, and the three verify scripts)

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
Copied verbatim from `05-CONTEXT.md` `<decisions>`. Do NOT re-derive or re-litigate these.

- **D-01 (taxonomy & layout, PG2-04):** Rebuild as **3 functional tiers** — `Languages & Inference` / `Training & Distributed` / `Concepts` — and **repeat all 17 required exact-match forms inside Skills** even when they already appear in a page-1/page-2 bullet. Recommended starting draft (tier membership + exact wording refined at execution by measurement):
  ```
  Languages & Inference: Rust, C++, Python, vLLM, ONNX Runtime, Triton, torch.compile, CUDA graphs, A100, H100
  Training & Distributed: PyTorch Lightning, FSDP, Flash Attention, Ray, Kubernetes, KEDA, Spark, Iceberg
  Concepts: tensor parallelism, pipeline parallelism, Mixture of Experts (MoE) parallelism, KV-cache management, continuous batching
  ```
  Of the 17 forms, CONTEXT names `ONNX Runtime, H100, CUDA graphs, Iceberg, PyTorch Lightning (exact casing)` as "strictly new" — **corrected by measurement below** (only 4 are strictly new to the *document*; `PyTorch Lightning` already extracts x1 from page 1). `PyTorch Lightning` also satisfies the bare `PyTorch` required keyword by substring.
- **D-02 (curation/purge, PG2-04):** Skills becomes **purely the inference-framework keyword tiers + Concepts**. Drop all research-identity tokens (Graph Neural Networks, Contrastive Learning, Recommendations, Search Relevance, Fairness-Aware Modeling, Large Language Models) and all generalist/grad tools (Tensorflow, Sklearn, Numpy, Pandas, Matplotlib, HDFS, Kafka, Flink, AWS Sagemaker, DynamoDB, Faiss, Django, Scala, PyTorch Geometric). Identity is carried by the page-2 Publication + `graph_ml`. Reversible.
- **D-03 (concept framing, PG2-05):** Label the concept group exactly **`Concepts:`** — compact, on its own line. Compactness is a fit lever (concept content ≈120 chars; a long label risks wrapping to a 4th line).
- **D-04 (C++ anchor, PG2-06):** Anchor `C++` by **implicit co-occurrence** — list `C++` in Skills, rely on the reader connecting it to the NetSpeed NoC bullet (page 1) and the `graph_ml` C++/Cython kernels (page 2). No explicit parenthetical. Reversible.
- **D-05 (concept tier, PG2-05):** All **5 concept items are conversant/evaluated vocabulary** — none claimed as built or operated (including `continuous batching` and `KV-cache management`). Reversible.
- **D-06 (evidence tiers):** Ship every keyword with an **internal built/operated/evaluated tier** backing per-item approval — **never printed on the resume**. Built: Rust, C++, Python. Operated: vLLM, torch.compile, Triton, CUDA graphs, A100, H100, FSDP, Flash Attention, Ray, Kubernetes, KEDA, Spark, ONNX Runtime, PyTorch Lightning. Evaluated/conversant: tensor parallelism, pipeline parallelism, MoE parallelism, KV-cache management, continuous batching, **Iceberg**. Iceberg ships at the evaluated tier and is flagged for explicit checkpoint confirmation.
- **D-07 (per-item approval, PG2-04/05, criterion 5):** The per-item approval is a **blocking `checkpoint:decision`** run AFTER the block is rebuilt and `bash scripts/verify-resume.sh` is green, presenting each **stretch item + its proposed tier** for an individual verdict against the rendered PDF. **A single blanket "looks good" is the documented failure mode — do not accept one.** Stretch set: the 5 Concepts, Iceberg, H100, CUDA graphs, ONNX Runtime, PyTorch Lightning. Core built items (Rust/C++/Python) and already-shipped page-1 operated items (torch.compile/A100/Triton/FSDP/Flash Attention/Ray/Kubernetes/KEDA/Spark/vLLM) ship without a per-item turn. Cannot auto-advance (STATE.md hard-gate convention, as EXP-08 was). Reversible (rejection is a valid green outcome).

### Claude's Discretion
- Exact tier membership rebalancing and final token order **within** the 3-tier scheme, driven by measured ≤3-line fit (D-01 draft is a starting point, not frozen).
- Whether to list bare `PyTorch` in addition to `PyTorch Lightning` (redundant by substring; a fit/space call).
- Exact wording of the checkpoint prompt per stretch item (must show the tier and be per-item, per D-07).

### Deferred Ideas (OUT OF SCOPE)
None deferred. Explicitly NOT in scope this phase: page 1 (byte-frozen at `798c0fb`, never touch L140–210), all other page-2 sections (Phase 4, done), palette (VIS-01, Phase 6), site sync (SITE-01/02, Phase 6), any summary/headline section (milestone decision). `Go` and `speculative decoding` appear nowhere. The graph/fairness/recsys identity dropped from Skills in D-02 is NOT deferred — it stays on page 2 via the Publication + `graph_ml`, by design.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| **PG2-04** | Skills rebuilt on keyword tiers with the 17 exact-match forms (`vLLM`, `torch.compile`, `Kubernetes`, `FSDP`, `Ray`, `ONNX Runtime`, `A100`/`H100`, `CUDA graphs`, `Triton`, `Rust`, `C++`, `PyTorch Lightning`, `Flash Attention`, `KEDA`, `Spark`, `Iceberg`) | §ATS Exact-Match Parsing (which forms already extract, which are new, wrap risk); §Harness Mechanics (promotions + H100 flip); §Validation Architecture (G6.5 + P5.x net) |
| **PG2-05** | Explicitly-labeled concept-vocabulary group (tensor parallelism, pipeline parallelism, MoE parallelism, KV-cache management, continuous batching); `speculative decoding` and `Go` appear nowhere | §Honesty Boundary; §≤3-Line Fit (Concepts wrap risk); §Validation Architecture (prohibited-term gates already green — keep at 0) |
| **PG2-06** | C++ claim evidenced via NetSpeed NoC + `graph_ml` C++/Cython kernels | §C++ Anchor — both usages verified present in the committed document; D-04 implicit co-occurrence needs no new prose |
</phase_requirements>

## Summary

This is not a research-heavy phase — CONTEXT.md locks the taxonomy, purge, labels, tiers, and checkpoint design. The real work is **mechanical and measured**: rewrite one `itemize` block into three tier lines, make each tier render on exactly one line (so Skills goes 4→≤3 lines), land 4 strictly-new exact forms, and discharge a precise set of same-commit harness obligations that STATE.md has been accumulating for two phases. Everything below is verified against the committed PDF, the manifest, and the three verify scripts this session.

**Three findings materially sharpen the plan:**
1. **Only 4 forms are strictly new to the document** (`ONNX Runtime`, `H100`, `CUDA graphs`, `Iceberg` — all x0 today). `PyTorch Lightning` (exact casing) **already extracts x1 from page 1** (`docs/main.tex:155`), so it is new to *Skills* only, needs no promotion, and its required-keyword coverage (bare `PyTorch`, x5 today) is already satisfied. The manifest's `KEYWORDS_TARGET` correctly lists exactly those 4 new forms.
2. **The harness's own G6.5 keyword gate greps the RAW gate stream, not squeezed** (`scripts/verify-resume.sh:1736`). So a promoted **multi-word** required keyword (`ONNX Runtime`, `CUDA graphs`, plus already-required `Flash Attention`) that lands across a pdftotext wrap point will make **G6.5 FAIL** (loud, not a false-green). This makes "keep each tier on one rendered line" a hard correctness constraint, not just a line-count nicety. It is separate from — and additional to — the Phase-4-close standing rule that the *new regression net* asserts multi-word literals on `$SQUEEZED`.
3. **The D-01 draft plausibly fits 3 lines, with the `Concepts` line the sole wrap risk.** Measured page-2 Skills line-1 capacity is ~132 content chars; draft tiers measure ≈107 / ≈102 / ≈129 chars. Tier 3 (`Concepts`, ~129) is within ~3 chars of capacity — and char count is only a proxy for typeset width (Phase 3 measured a 134-char candidate wrap where 133 fit), so **the plan must MEASURE via `make build` + pdftotext, never predict.** Tier 3 carries no required multi-word keyword, so a Concepts wrap breaks only G6.14 (line count), not G6.5.

**Primary recommendation:** Rewrite the block as three `\\`-separated tier lines inside the existing `\begin{itemize}[leftmargin=0.15in, label={}] \small{\item{...}}` shape; land `ONNX Runtime`, `H100`, `CUDA graphs`, `Iceberg` in the same commit that promotes each `KEYWORDS_TARGET`→`KEYWORDS_REQUIRED`, flips `P3.44`/`P3.65` back for H100, and adds a new Phase-5 `$SQUEEZED`/`$GATE` regression net wired into `make`; measure line count and G6.5 before running the blocking per-item checkpoint.

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Skills content (3 tiers) | `docs/main.tex` `\section{Technical Skills}` (source of truth, single-file) | — | One LaTeX file; no `\input`/`\include` (STATE.md single-file constraint, verified: only `.tex` in repo) |
| Exact-match keyword presence | pdftotext text layer (ATS proxy) | manifest `KEYWORDS_REQUIRED`/`KEYWORDS_TARGET` | ATS scanners parse the PDF text layer; the manifest is the promotion ledger |
| Line-count fit (≤3) | rendered PDF measured by `G6.14` / pdftotext | LaTeX `itemize` typesetting | Fit is MEASURED from the build, never predicted |
| Keyword promotion gate | `scripts/verify-phase3-regressions.sh` promotion triple (`P3.42`–`P3.45`) + new Phase-5 net | manifest tiers | `G6.5`/`G6.6` are convention, not a gate (STATE.md, verified) |
| Honesty (Go / speculative decoding = 0) | harness `G6.7`/prohibited gates + new net | — | Whole-document text-layer scan |
| Per-item defensibility | blocking `checkpoint:decision` (human) | evidence-tier record (plan) | Only the interviewee can accept a stretch claim |

## Standard Stack

No external software packages are installed or added this phase. The toolchain is fixed and already present:

| Tool | Verified | Purpose |
|------|----------|---------|
| `pdflatex` / `latexmk` (via `make build`) | `Makefile:130` build target `[VERIFIED: Makefile:130]` | Compile `docs/main.tex` → `docs/AshutoshTiwari.pdf` |
| `pdftotext` (poppler) | `/opt/homebrew/bin/pdftotext` present `[VERIFIED: which pdftotext, this session]` | Extract text layer (ATS proxy); default mode = `$GATE`, squeezed = `$SQUEEZED` |
| `bash` / `grep` (`LC_ALL=C`, fixed-string) | `scripts/verify-*.sh` `[VERIFIED]` | Run harness + regression nets |

**No `npm`/`pip`/`cargo` install step exists or is needed.** This phase edits one `.tex` file, one manifest, three (or four) shell scripts, and the `Makefile`.

## Package Legitimacy Audit

**Not applicable — this phase installs zero external packages.** No registry lookups, no `postinstall` risk, no slopsquatting surface. The `## Package Legitimacy Audit` gate is satisfied vacuously: the "packages" named on the resume (`vLLM`, `Ray`, `ONNX Runtime`, etc.) are *keyword strings printed in a document*, not dependencies pulled into a build.

## ATS Exact-Match Parsing (PG2-04)

### How ATS / pdftotext extracts the 17 forms

ATS keyword scanners read the PDF **text layer**, which pdftotext reproduces. The harness pins two streams (both defined identically in every net — verified `scripts/verify-phase4-regressions.sh:270-284`):
- **`$GATE`** — `pdftotext` default mode, form-feeds → newlines (`tr '\f' '\n'`). Preserves line breaks; a phrase pdftotext wrapped across two lines is split here. `[VERIFIED: scripts/verify-phase4-regressions.sh:270-283]`
- **`$SQUEEZED`** — the whole text layer collapsed to one whitespace-normalized line (`tr -s ' \t\n' ' '`). A wrapped multi-word literal still matches. `[VERIFIED: scripts/verify-phase4-regressions.sh:280-284]`

### Which of the 17 already extract vs. which are strictly NEW

Measured against the committed `docs/AshutoshTiwari.pdf` this session (`pdftotext … | tr -s | grep -oF | wc -l`) `[VERIFIED: pdftotext count, this session]`:

| Exact form | Count in current doc | Status | Where |
|------------|---------------------:|--------|-------|
| `vLLM` | 4 | present | pages 1/2 bullets + current Skills |
| `torch.compile` | 1 | present | `docs/main.tex:155` Adobe bullet (promoted 03-05) |
| `Kubernetes` | 2 | present | page 1 |
| `FSDP` | 2 | present | page 1 |
| `Ray` | 3 | present | page 1 + current Skills |
| `A100` | 1 | present | `docs/main.tex:155` (`8×A100`) |
| `Triton` | 1 | present | `docs/main.tex:155` (promoted 03-05) |
| `Rust` | 4 | present | page 1 |
| `C++` | 4 | present | NetSpeed (p1) + `graph_ml` (p2) — see §C++ Anchor |
| `PyTorch Lightning` | **1** | **present (page 1)** | `docs/main.tex:155` "Ray Data + PyTorch Lightning" — **NOT strictly new** |
| `PyTorch` (bare, required kw) | 5 | present | pages 1/2 |
| `Flash Attention` | 1 | present | page 1 |
| `KEDA` | 2 | present | page 1 |
| `Spark` | 3 | present | pages 1/2 + current Skills |
| **`ONNX Runtime`** | **0** | **STRICTLY NEW** | lands only in Skills |
| **`H100`** | **0** | **STRICTLY NEW** (removed from p1 at `798c0fb`) | lands only in Skills |
| **`CUDA graphs`** | **0** | **STRICTLY NEW** (p1 ships hyphenated singular `CUDA-graph capture`, which the plural never matches) | lands only in Skills |
| **`Iceberg`** | **0** | **STRICTLY NEW** | lands only in Skills |

`[VERIFIED: pdftotext + docs/main.tex:155 read this session]`

**Correction to CONTEXT D-01's "strictly new" list:** CONTEXT names 5 (adding `PyTorch Lightning`). Measurement shows **only 4** are strictly new to the *document*; `PyTorch Lightning` already extracts once from page 1 line 155. This is consistent with the manifest, which carries exactly those 4 as targets: `KEYWORDS_TARGET=ONNX:5|CUDA graphs:3|Iceberg:5|H100:5` `[VERIFIED: docs/verify/manifest.txt:60]`. `PyTorch Lightning` is a **casing fix within Skills** (current source has `Pytorch Lightning`, lowercase-t, `docs/main.tex:293`) — it earns nothing case-sensitively today, but earns nothing *new* to the document either, so it needs no promotion.

### Which multi-word forms risk pdftotext line-wrapping

Multi-word forms among the 17: `ONNX Runtime`, `CUDA graphs`, `Flash Attention`, `PyTorch Lightning`, plus the concept phrases. **Two distinct wrap concerns:**

1. **Harness G6.5 (raw stream) — a real BLOCKER risk.** `G6.5` counts each `KEYWORDS_REQUIRED` entry with `grep -oF "$KW" "$WORK/gate.txt"` — the **RAW** gate stream `[VERIFIED: scripts/verify-resume.sh:1736]`. After promotion, `ONNX Runtime` and `CUDA graphs` join `Flash Attention` as required multi-word keywords. If any lands at a pdftotext wrap point in the Skills block, its raw-stream count is 0 → `G6.5 FAIL` (BLOCKER). **Mitigation:** keep the tier carrying each on a single rendered line (Tier 1 draft is ~107 chars, well under the ~132 capacity, so its `ONNX Runtime` and `CUDA graphs` are safe; Tier 2 ~102 chars keeps `Flash Attention` safe). Token *ordering within a tier* should avoid pushing a multi-word form to a tier's tail where it could straddle a wrap.
2. **New regression net (squeezed stream) — the standing rule.** Per STATE.md `[Phase 04 / close]`, the new net's **multi-word literals (`CUDA graphs`, `Flash Attention`, `ONNX Runtime`, `PyTorch Lightning`) MUST assert against `$SQUEEZED`**, never `$GATE`, because a raw-stream absence check false-passes on a wrapped regression. Single-token needles (`A100`, `H100`, `Triton`, `Rust`, `KEDA`, `Iceberg`, `vLLM`) stay on `$GATE`. `[VERIFIED: .planning/STATE.md line 40, 64]`

These are not contradictory: G6.5's raw presence-check FAILs loudly on a wrap (safe); the net's squeezed check exists so a *deletion regression* can never false-pass. Both hold simultaneously.

## ≤3-Line LaTeX Fit (PG2-04, criterion 1)

### Current state (measured this session)

The current Skills block renders **4 lines**: two source lines (`docs/main.tex:292-293`), each wrapping to 2 rendered lines. `[VERIFIED: pdftotext docs/AshutoshTiwari.pdf, this session]`

Measured rendered content width (default `$GATE` stream, leading pdftotext space stripped):
```
132 chars: Search Relevance, ... Computer Vision, DL, Spark,          <- line-1, wraps here
132 chars: Frameworks/Libraries/Tools: Ray, ... Matplotlib, HDFS,     <- line-1, wraps here
```
So **Skills `itemize` line-1 capacity ≈ 132 content characters** on page 2. This matches the Phase-3 page-1 measurements (itemize line-1 ≈ 133–137 chars). `[VERIFIED: pdftotext measurement, this session]`

### Will the D-01 draft fit 3 lines?

Measured character lengths of the D-01 draft tiers `[VERIFIED: awk length, this session]`:

| Tier | Draft content | Chars | Fit assessment |
|------|---------------|------:|----------------|
| `Languages & Inference:` | Rust, C++, Python, vLLM, ONNX Runtime, Triton, torch.compile, CUDA graphs, A100, H100 | ~107 | Comfortable — 1 line |
| `Training & Distributed:` | PyTorch Lightning, FSDP, Flash Attention, Ray, Kubernetes, KEDA, Spark, Iceberg | ~102 | Comfortable — 1 line |
| `Concepts:` | tensor parallelism, pipeline parallelism, Mixture of Experts (MoE) parallelism, KV-cache management, continuous batching | ~129 | **AT RISK — within ~3 chars of the ~132 capacity** |

**Verdict:** the draft plausibly renders in exactly 3 lines, IF each tier is one source line (`\\`-separated) and stays under the measured capacity. **The `Concepts` line is the sole wrap-to-4 risk** (D-03 already anticipated this: "the concept content is ~120 chars, so a long label risks wrapping to a 4th rendered line"). Levers if it wraps (all reversible, all under Claude's discretion per CONTEXT):
- Keep the label minimal — exactly `Concepts:` (D-03), never a longer label.
- The bold tier labels (`\textbf{...}`) are slightly wider than body text; if wrap is marginal, the label glyphs matter.
- Reorder/abbreviate within the concept list only as a last resort — but D-05 fixes the 5 concept strings as vocabulary, so wording latitude is limited; prefer fitting via the other two tiers' slack if any rebalancing helps.

**MANDATORY method (Phase 2/3 standing rule):** exact fit is MEASURED at build, never predicted. Character count is a proxy for typeset width, not the width itself — Phase 3 measured a 134-char candidate wrap where 133 fit (STATE.md `[Phase 3 / 03-08]`). The plan MUST: edit → `make build` → `pdftotext` → read `G6.14`'s reported line count → iterate. Do not assume 3 lines from the char counts above. `[VERIFIED: .planning/STATE.md 03-08 record; scripts/verify-resume.sh:1982-1998]`

### Page-2 budget headroom

Page 2 closed Phase 3 at **`G3.2` p2 +53.5pt (+4.65 lines)** of the independent page-2 budget `[VERIFIED: .planning/STATE.md 03-08 record]`. Skills currently 4 lines → shrinking to ≤3 frees room. The binding constraint is not page-2 overflow; it is **shrinking to ≤3 lines while ADDING 4 new keywords** (the tiers get denser as identity tokens are purged and framework tokens repeated).

## Harness Mechanics — The Same-Commit Obligations (load-bearing)

The Skills rebuild forces a precise set of harness edits, most of which STATE.md has been carrying as explicit Phase-5 debts. **Each lands in the SAME commit that lands the corresponding keyword in Skills** (promotion is same-commit-as-content; `$GATE`/`$SQUEEZED` are whole-document, so a keyword added without its promotion/flip reddens the P3 net mid-phase).

### (a) H100 needle flip + re-promotion — MANDATORY, same commit as H100 in Skills

STATE.md `[Post-Phase-3 / Page-1 Finalization]` and `### Blockers/Concerns [Phase 5]` record this as owed. `[VERIFIED: .planning/STATE.md lines 42, 118]`

- **`P3.44`**: currently `assert_absent "…demoted…" 'H100' "$SQUEEZED"` at `scripts/verify-phase3-regressions.sh:886` → flip to **`assert_promoted "…" 'H100'`** `[VERIFIED: scripts/verify-phase3-regressions.sh:886]`
- **`P3.65`**: currently `assert_absent "…demoted…" 'H100' "$GATE"` at `scripts/verify-phase3-regressions.sh:1015` → flip to **`assert_present "…" 'H100' "$GATE"`** `[VERIFIED: scripts/verify-phase3-regressions.sh:1014-1017]`
- **Manifest**: move `H100` from `KEYWORDS_TARGET` to `KEYWORDS_REQUIRED`, stripping the `:5` suffix. Current: `KEYWORDS_TARGET=ONNX:5|CUDA graphs:3|Iceberg:5|H100:5` `[VERIFIED: docs/verify/manifest.txt:60]`
- **ID preservation:** IDs are auto-numbered by call order via `emit()` (`P3_SEQ=$((P3_SEQ + 1))`, `scripts/verify-phase3-regressions.sh:239`), so **flipping an assertion in place — same call position — preserves its `P3.xx` id.** `assert_absent` takes 4 args (label, needle, file, remedy); `assert_promoted` takes 2 (label, literal); `assert_present` takes 3 (label, needle, file). Replacing the call at the same position keeps P3.44 / P3.65. Do not renumber. `[VERIFIED: scripts/verify-phase3-regressions.sh:238-244]`
- **`assert_promoted` needs the manifest:** it reads `KEYWORDS_REQUIRED`/`KEYWORDS_TARGET` as data (conjuncts: present in `$GATE` AND a whole pipe-field of `KEYWORDS_REQUIRED` AND no `KEYWORDS_TARGET` field left with the `H100:` prefix). It requires the net be run with `--manifest`. `[VERIFIED: scripts/verify-phase3-regressions.sh:393-438]`

### (b) Promote ONNX / CUDA graphs / Iceberg — same commit as each lands

Each moves from `KEYWORDS_TARGET` to `KEYWORDS_REQUIRED` (suffix stripped) in the commit that lands its exact form in Skills. Target keys as written: `ONNX:5` (the *required* keyword is `ONNX`, a substring of the printed `ONNX Runtime`), `CUDA graphs:3` (multi-word pipe-field), `Iceberg:5`. `[VERIFIED: docs/verify/manifest.txt:60]`

- Post-promotion `KEYWORDS_REQUIRED` gains fields `ONNX`, `CUDA graphs`, `Iceberg`, `H100` → G6.5 will grep all four against `$GATE` (raw). `CUDA graphs` is multi-word → must not wrap (see §ATS). `ONNX` is a single token (substring), safe. `Iceberg`, `H100` single tokens, safe.

### (c) Extend the promotion triple `P3.42`–`P3.45` — the ONLY machine-backed promotion gate

STATE.md `[Phase 3 / 03-08]`: "`G6.5`/`G6.6` are the promotion CONVENTION, not a promotion GATE … the only machine backing for same-commit promotion anywhere in this repo is the new P3 net's promotion triple — `P3.42`–`P3.45` … Phase 5 adds keywords and inherits this: a promotion it lands outside that triple's coverage has no gate behind it." `[VERIFIED: .planning/STATE.md line 98]`

- The existing triple: `P3.42` torch.compile (`:877`), `P3.43` A100 (`:878`), `P3.44` H100 (`:886`, demoted — re-covered by the flip in (a)), `P3.45` Triton (`:888`). `[VERIFIED: scripts/verify-phase3-regressions.sh:877-888]`
- **The H100 flip in (a) already re-covers H100.** For the three genuinely-new promotions (`ONNX`, `CUDA graphs`, `Iceberg`), the plan needs `assert_promoted` coverage. **Recommendation:** carry these three `assert_promoted` assertions in the **new Phase-5 regression net** (option A, preferred — it is the natural owner, mirrors how Phase 4's net owns Phase-4 invariants, and needs its own copy of the `assert_promoted` helper + `--manifest` plumbing), rather than appending to the Phase-3 net (option B — would grow `P3_SEQ` past 72 and mix Phase-5 promotions into Phase 3's oracle). Either satisfies STATE.md's "extend it for ONNX/CUDA graphs/Iceberg"; the planner picks and records. The H100 flip stays in the Phase-3 net regardless because `P3.44`/`P3.65` physically live there and STATE.md mandates their in-place flip.

### (d) New Phase-5 Skills regression net — modeled on `verify-phase4-regressions.sh`

STATE.md `[Phase 04 / close]` and `05-CONTEXT.md` name `scripts/verify-phase4-regressions.sh` (38 P4.x, green on arrival, each `--gate-text`-failable, multi-word on `$SQUEEZED`) as the exact model. `[VERIFIED: scripts/verify-phase4-regressions.sh, this session]`

- **Structure to copy:** `assert_present`/`assert_absent`/`assert_count` helpers (`:181-228`), the two-stream setup (`:270-284`), `--gate-text` / `--tex` fixture overrides (`:117-118`), `mktemp -d` scratch + EXIT trap (`:251-256`), anchored footer `RESULT P5.<n> PASS/FAIL`. `[VERIFIED: scripts/verify-phase4-regressions.sh:181-290]`
- **Assertion classes:**
  - Multi-word literals on `$SQUEEZED`: `CUDA graphs`, `Flash Attention`, `ONNX Runtime`, `PyTorch Lightning` (and any multi-word concept phrase asserted, e.g. `tensor parallelism`, `Mixture of Experts (MoE)`, `KV-cache management`, `continuous batching`).
  - Single-token needles on `$GATE`: `A100`, `H100`, `Triton`, `Rust`, `KEDA`, `Iceberg`, `vLLM`, `Spark`, `Ray`, `FSDP`, `Kubernetes`.
  - Absence assertions (honesty): `Go` (word-boundary — note `grep -oF`/`gcount -Fc` is substring; use the harness's own `-w` approach or assert against the source/text carefully; `Go` currently x0 by word-boundary) and `speculative decoding` (x0 today, keep 0). Consider asserting the purged research-identity tokens absent from the *Skills region* if a region slice is added — optional.
  - Each assertion class **proven failable with `--gate-text`** (green on arrival, but a crafted fixture flips it red) — the Phase-1 rule "an assertion never observed failing is not a gate."
- **Wire into `make`:** add `REGRESS5 := scripts/verify-phase5-regressions.sh` beside `REGRESS4` (`Makefile:32`), and chain `@bash $(REGRESS5)` in both the `verify:` recipe (after `:200`) and the `verify-regressions:` recipe (after `:234`). `[VERIFIED: Makefile:29-32, 197-234]`
- **Gating invocation stays** `bash scripts/verify-resume.sh` (exit 0) as the oracle; `make verify` is corroboration only (GNU Make 3.81 collapses exit 1/2 → 2). `[VERIFIED: .planning/STATE.md; Makefile:194]`

### (e) G6.14 WARN → pass — automatic once Skills renders ≤3 lines

`G6.14` is WARN-tier (owner Phase 5): it reports the rendered non-empty line count of the Skills region against `SKILLS_MAX_LINES`. `[VERIFIED: scripts/verify-resume.sh:1982-1998; docs/verify/manifest.txt:49 "SKILLS_MAX_LINES=3"; WARN_OWNERS "...|G6.14:5|..." at manifest:66]`

- It **cannot FAIL** (warn-tier) — assert the **value in its message** (line count), not an exit code. Today it warns "renders 4 … against a target of 3". At ≤3 it warns "within the target of 3". No manifest change needed for `SKILLS_MAX_LINES` (already 3). The owner tag `G6.14:5` can stay or be re-pointed to `none`/`any` once satisfied — a judgment call, not required.
- **Region-measurement caveat:** `G6.14` reuses `section_region` and exercises its **terminal-section EOF fallback** because `TECHNICAL SKILLS` is the last `SECTIONS` entry. A helper returning an empty range would count 0 lines and false-OK under a max of 3 — the load-bearing fallback (STATE.md `[Phase 1 / 01-02]`). Do not disturb `SECTIONS` ordering. `[VERIFIED: scripts/verify-resume.sh:1975-1989; .planning/STATE.md line 51]`

### Note: Triton is already promoted (03-05) — PG2-04's Triton is ADDITIVE

`Triton` was promoted to `KEYWORDS_REQUIRED` in 03-05 (x1, `P3.45` PASS). Its Skills-tier form is a **second surface for the same keyword**, not a re-promotion. Do not re-promote or read the early promotion as PG2-04 already discharged. `[VERIFIED: docs/verify/manifest.txt:59 (Triton in REQUIRED); .planning/STATE.md line 99]`

## C++ Anchor (PG2-06)

Both halves of the D-04 implicit-co-occurrence anchor are present in the committed document — **no new prose needed**:
- **NetSpeed NoC (page 1):** the folded earlier-experience block retains C++/Network-on-Chip wording (EXP-05, `docs/main.tex` NetSpeed subheading; `C++` x4 total in doc). `[VERIFIED: pdftotext C++ x4; EXP-05 complete per REQUIREMENTS.md:22]`
- **`graph_ml` C++/Cython kernels (page 2):** `docs/main.tex:281` (`Python, PyTorch Geometric, C++/Cython`) and `:283` ("optimized C++/Cython random-walk kernels"). The Phase-4 net already guards `C++/Cython` on `$SQUEEZED` (`P4` assertion at `scripts/verify-phase4-regressions.sh:307`). `[VERIFIED: docs/main.tex:281,283; scripts/verify-phase4-regressions.sh:307]`

Criterion 4 ("verifiable by a reader from the document itself") is satisfied by these two existing usages. Listing `C++` in Skills (D-01 Tier 1) plus these anchors completes PG2-06. Do not remove the `graph_ml` phrasing (per `05-CONTEXT.md` canonical refs).

## Per-Item Approval Checkpoint (D-07, criterion 5)

### The model to reuse: Phase 3's EXP-08 blocking checkpoint

The Phase-3 EXP-08 checkpoint (`03-07-PLAN.md`) is the exact template. `[VERIFIED: .planning/phases/03-adobe-rebuild-staff-signal-bullets/03-07-PLAN.md, this session]`

- **Structure:** a single `<task type="checkpoint:decision" gate="blocking">`, run AFTER the rebuild is proven green (all suites: harness exit 0, P2/P3/P4 nets green, self-test green) — presenting drafts against a green document so the user's one sign-off is not wasted. `[VERIFIED: 03-07-PLAN.md:60-99]`
- **One verdict per item, recorded behind a greppable marker.** Phase 3 recorded `[Phase 3 / EXP-08]` with one verdict per draft ID (approved/rejected/revised-with-wording). Rejection is a fully green outcome (a rejected item is simply absent). `[VERIFIED: 03-07-PLAN.md:17,19,151-157; STATE.md [Phase 3 / EXP-08] record]`
- **Cannot auto-advance.** "an attended gate must be presented for real even where an auto-advance setting exists. Silence is not approval." `[VERIFIED: 03-07-PLAN.md:151,201]`
- **Evidence packet per item.** Phase 3 assembled, per draft: the ⚠ text, the evidence line its magnitude leans on, the carrying topic, and the estimated cost — plus opened `docs/AshutoshTiwari.pdf` so the user judged against the real page. `[VERIFIED: 03-07-PLAN.md:71-75,139]`

### Phase-5 checkpoint design

Present **each stretch item + its proposed evidence tier** for an individual verdict against the rendered PDF. Stretch set (D-07): the **5 Concepts** (all `evaluated/conversant`), **Iceberg** (`evaluated` — the one operated-*looking* tier placement resting on an evaluated-only defense, flag explicitly), **H100** (`operated`), **CUDA graphs** (`operated`, via `torch.compile(mode="max-autotune")`), **ONNX Runtime** (`operated`, CUDAExecutionProvider), **PyTorch Lightning** (`operated`). Core built items (Rust/C++/Python) and already-shipped page-1 operated items ship without a per-item turn.

- **A single blanket "looks good" is the documented failure mode (criterion 5) — do not accept one.** Present concrete per-item proposals (keyword + tier), recommendation-first, for confirm/reject.
- Evidence backing (from `CODEBASE-EVIDENCE.md`, for the packet): ONNX Runtime CUDAExecutionProvider (`:56`), `torch.compile(mode="max-autotune")` + CUDA-graph capture (`:54`), FSDP/FSDP2 + Flash Attention, Ray Data benchmark (`:58`), 64-H100 wave (`:98`), Iceberg tables in FCU0 export (`:104`). The 5 concepts have **NO commit evidence — vocabulary only** (`:9`). `[VERIFIED: .planning/research/CODEBASE-EVIDENCE.md:9,54,56,58,98,104]`
- Record the outcome behind a greppable `[Phase 5 / …]` marker in STATE.md, one verdict per item, rejections as decisions. **Never reproduce a machine-read marker literal inside prose the same grep scans** (STATE.md standing rule). `[VERIFIED: .planning/STATE.md line 95]`

## Validation Architecture

> Nyquist validation is enabled (`workflow.nyquist_validation` not disabled). Every success criterion maps to a machine check below.

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Shell verification harness + regression nets (no unit-test framework; the PDF text layer is the fixture) |
| Config / manifest | `docs/verify/manifest.txt` (thresholds, keyword tiers, section list) |
| Quick run command | `bash scripts/verify-resume.sh` (the oracle, exit 0) |
| Full suite command | `bash scripts/verify-resume.sh && bash scripts/verify-phase2-regressions.sh && bash scripts/verify-phase3-regressions.sh && bash scripts/verify-phase4-regressions.sh && bash scripts/verify-phase5-regressions.sh && make verify-selftest` |
| Build | `make build` → `docs/AshutoshTiwari.pdf` (measure fit AFTER build) |

### Phase Requirements → Test Map

| Criterion (ROADMAP Phase 5) | Behavior | Machine check | Command | Exists? |
|-----------------------------|----------|---------------|---------|---------|
| 1 — Skills ≤3 lines | Skills region renders ≤3 non-empty lines | `G6.14` message line count vs `SKILLS_MAX_LINES=3` | `bash scripts/verify-resume.sh` (read G6.14) | ✅ (WARN-tier; assert the value) |
| 1 — 17 exact forms present | each required keyword in text layer (raw) | `G6.5` per `KEYWORDS_REQUIRED` field, `grep -oF` on `$GATE` | `bash scripts/verify-resume.sh` | ✅ (BLOCKER) |
| 1 — new forms promoted same-commit | present ∧ whole `KEYWORDS_REQUIRED` field ∧ no leftover `TARGET` | `assert_promoted` for `H100` (`P3.44`, flipped) + `ONNX`/`CUDA graphs`/`Iceberg` (new `P5.x`) | run nets with `--manifest` | ❌ Wave 0 (new net + P3 flips) |
| 1 — multi-word forms present despite wrap | `ONNX Runtime`/`CUDA graphs`/`Flash Attention`/`PyTorch Lightning` in squeezed layer | `assert_present … "$SQUEEZED"` in Phase-5 net | `bash scripts/verify-phase5-regressions.sh` | ❌ Wave 0 |
| 2 — labeled concept group | 5 concept phrases present, read as vocabulary | `assert_present` (multi-word → `$SQUEEZED`) in Phase-5 net | `bash scripts/verify-phase5-regressions.sh` | ❌ Wave 0 |
| 3 — Go / speculative decoding = 0 | zero occurrences whole-document | `G6.7` prohibited-word (`-w` for `Go`) + prohibited-phrase; + `assert_absent` in Phase-5 net | `bash scripts/verify-resume.sh` | ✅ + ❌ Wave 0 (net belt-and-suspenders) |
| 4 — C++ anchored | `C++` present; `C++/Cython` present; NetSpeed C++ present | `G6.5` (C++) + Phase-4 net `C++/Cython` (`$SQUEEZED`) | existing suites | ✅ |
| 5 — per-item approval recorded | blocking checkpoint verdicts recorded per item | `checkpoint:decision` gate + greppable STATE.md marker | manual (blocking, no auto-advance) | ❌ Wave (checkpoint) |

### Sampling Rate
- **Per task commit:** `make build` then `bash scripts/verify-resume.sh` (read G6.5 + G6.14) — and the same-commit promotion/flip means the P3 net + Phase-5 net must also be green in that commit.
- **Per wave merge / phase gate:** full suite green (all 5 nets + self-test) before `/gsd-verify-work`.

### Wave 0 Gaps
- [ ] `scripts/verify-phase5-regressions.sh` — new net (model: `verify-phase4-regressions.sh`); multi-word on `$SQUEEZED`, single-token on `$GATE`, each class `--gate-text`-failable; carries `assert_promoted` for `ONNX`/`CUDA graphs`/`Iceberg` (option A).
- [ ] `Makefile` — add `REGRESS5` var + chain in `verify:` and `verify-regressions:`.
- [ ] `scripts/verify-phase3-regressions.sh` — in-place flip of `P3.44` (`assert_absent`→`assert_promoted 'H100'`) and `P3.65` (`assert_absent`→`assert_present 'H100' "$GATE"`), same commit as H100 in Skills.
- [ ] `docs/verify/manifest.txt` — move `H100`, `ONNX`, `CUDA graphs`, `Iceberg` from `KEYWORDS_TARGET` to `KEYWORDS_REQUIRED` (suffix stripped), each in the commit landing its keyword.
- [ ] No new test-framework install needed — the harness exists.

## Common Pitfalls

### Pitfall 1: Multi-word required keyword wraps → G6.5 BLOCKER
**What goes wrong:** `ONNX Runtime` or `CUDA graphs` lands at a pdftotext wrap point; `G6.5`'s raw-stream `grep -oF` returns 0 → BLOCKER FAIL.
**Why:** `G6.5` reads `$GATE` (raw), not squeezed (`scripts/verify-resume.sh:1736`).
**Avoid:** keep each carrying tier on one rendered line; order tokens so multi-word forms aren't at a tier's tail. Measure after build.
**Warning sign:** `G6.5 FAIL` naming a multi-word keyword despite it visibly appearing in Skills.

### Pitfall 2: Concepts line wraps to a 4th rendered line
**What goes wrong:** Tier 3 (~129 chars) exceeds the ~132 typeset capacity after real rendering; Skills stays 4 lines; G6.14 keeps warning "4 against 3".
**Why:** char count is a proxy for proportional-font width (Phase 3: 134 wrapped where 133 fit).
**Avoid:** keep the label exactly `Concepts:`; MEASURE; rebalance only within CONTEXT's latitude.
**Warning sign:** G6.14 message reports 4 lines after build.

### Pitfall 3: Skipping the H100 same-commit flip → P3 net reddens mid-phase
**What goes wrong:** H100 added to Skills but `P3.44`/`P3.65` still `assert_absent 'H100'` → whole-document streams see H100 → P3 net FAILs.
**Why:** `$GATE`/`$SQUEEZED` are whole-document.
**Avoid:** flip both in the same commit + promote in manifest.
**Warning sign:** `P3.44`/`P3.65 FAIL` after adding H100.

### Pitfall 4: Renumbering P3 assertions when flipping
**What goes wrong:** replacing `assert_absent` with `assert_promoted`/`assert_present` at a different call position shifts `P3_SEQ` ids; every STATE.md citation of `P3.44`/`P3.65` breaks.
**Avoid:** flip in place — same call position (ids are auto-numbered by call order, `:239`). `assert_promoted` = 2 args, `assert_present` = 3 args, `assert_absent` = 4 args.

### Pitfall 5: Treating a promoted keyword as gated by G6.5/G6.6
**What goes wrong:** relying on `G6.5`/`G6.6` to enforce same-commit promotion — they are convention, not a gate (`G6.6` warns unconditionally at any count).
**Avoid:** back every promotion with an `assert_promoted` (H100 via the P3.44 flip; ONNX/CUDA graphs/Iceberg via the new net).

### Pitfall 6: Reproducing a machine-read marker in prose
**What goes wrong:** writing a `[Phase 5 / …]` marker literal (or a criterion token) inside a STATE.md sentence that the same grep scans → collides, breaks uniqueness assertions.
**Avoid:** describe markers; cite where defined; keep exactly one occurrence of any greppable marker.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Extract PDF text for ATS check | custom PDF parser | `pdftotext` (`$GATE`/`$SQUEEZED` streams already defined) | The harness pins the extraction convention; a custom parser diverges from what ATS/pdftotext sees |
| Keyword promotion gate | new deferral construct | the `assert_promoted` triple + manifest tiers | STATE.md: "Do not add any other deferral construct" (`verify-resume.sh:1725`) |
| New regression net from scratch | fresh script | copy `verify-phase4-regressions.sh` structure | Proven `--gate-text`-failable, two-stream, `mktemp` scratch pattern |
| Line-count measurement | predicting from char counts | `make build` + `G6.14`/pdftotext | Fit is typeset width, measured never predicted |

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| `pdftotext` (poppler) | all text-layer gates | ✓ | `/opt/homebrew/bin/pdftotext` | none needed |
| `pdflatex`/`latexmk` | `make build` | ✓ (PDF builds; committed artifact present) | — | none needed |
| `bash`/`grep` | harness + nets | ✓ | `/bin/bash` 3.2.57 (harness targets this) | none needed |

No missing dependencies. `[VERIFIED: which pdftotext; docs/AshutoshTiwari.pdf present, this session]`

## Project Constraints (from AGENTS.md / repo conventions)

`AGENTS.md` exists at repo root (not read in full; contains agent guidance). Binding conventions surfaced from STATE.md / CONTEXT.md that the plan MUST honor:
- **Single-file LaTeX:** entire resume in `docs/main.tex`; no `\input`/`\include`. `[VERIFIED: STATE.md line 100]`
- **Resolve every `docs/main.tex` line reference by CONTENT, never by a stored number** — every wave that adds a source line shifts downstream literals. `[VERIFIED: STATE.md 03-06 record line 90]`
- **Never `make clean`** — deletes the `.fdb_latexmk` md5 the `G0.3` freshness gate reads. Artifacts (`.pdf`/`.log`/`.fdb_latexmk`/`.aux`/`.fls`/`.out`) ride in the source commit. `[VERIFIED: 05-CONTEXT.md code_context]`
- **Page 1 byte-frozen at `798c0fb`** — never edit `docs/main.tex` L140–210 to satisfy a red gate. `[VERIFIED: STATE.md line 42]`
- **Strengthen-never-weaken** applies to assertion logic (not to superseded needle literals). `[VERIFIED: STATE.md line 42]`
- **Gating oracle is `bash scripts/verify-resume.sh`** (exit 0); `make verify` is corroboration only (Make 3.81 collapses exit 1/2). `[VERIFIED: STATE.md; Makefile:194]`
- **Never reproduce a machine-read marker literal inside prose the same grep scans.** `[VERIFIED: STATE.md line 95]`
- **No internal-tooling terminology in shipped artifacts** (global rule): commit messages/code describe the change, not the workflow.

## Honesty Boundary (binding)

- `speculative decoding` and `Go` MUST appear **zero times** in the extracted text of the entire document (criterion 3). Both currently x0 (`Go` by word-boundary; `speculative decoding` x0). Keep at 0 — assert in the new net. `[VERIFIED: pdftotext + grep -owF, this session; manifest PROHIBITED_WORDS=Go, PROHIBITED_PHRASES=speculative decoding at docs/verify/manifest.txt:45-46]`
- The **5 concept-vocab items have NO commit evidence** — vocabulary only. Do NOT propose claiming them as accomplishments (D-05; `CODEBASE-EVIDENCE.md:9`). `[VERIFIED: CODEBASE-EVIDENCE.md:9]`
- No tensor/pipeline/MoE parallelism as accomplishments; no TensorRT-LLM; no invented figures. `[VERIFIED: CODEBASE-EVIDENCE.md:9; REQUIREMENTS.md Out of Scope]`

## State of the Art

| Old (current Skills) | New (Phase 5) | Impact |
|----------------------|---------------|--------|
| 2 undifferentiated lines: research-identity + a flat "Frameworks/Libraries/Tools" list (`main.tex:292-293`) | 3 functional tiers (`Languages & Inference` / `Training & Distributed` / `Concepts`) | Denser ATS keyword anchor; identity moves to Publication + graph_ml |
| `Pytorch Lightning`, `Pytorch` (lowercase-t) — earn nothing case-sensitively | `PyTorch Lightning` exact casing | Case-sensitive ATS + G6.5 credit |
| 4 rendered lines | ≤3 rendered lines | Criterion 1 (G6.14) |
| `ONNX Runtime`/`H100`/`CUDA graphs`/`Iceberg` absent | all 4 present + promoted | 4 new exact-match forms |

**Deprecated/outdated:** the flat "Frameworks/Libraries/Tools" label and all generalist/grad tokens (D-02).

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | The D-01 draft renders in exactly 3 lines after build (char counts suggest fit; Concepts ~129 vs ~132 capacity) | ≤3-Line Fit | LOW-MED — if Concepts wraps, G6.14 stays at 4; MEASURED at build, reversible via label/rebalance. This is flagged as MEASURE-not-predict, so the plan already treats it as unverified until build. |
| A2 | Placing `ONNX Runtime`/`CUDA graphs` in the ~107-char Tier 1 keeps them off any wrap point, so G6.5 passes | ATS Parsing | LOW — Tier 1 is well under capacity; confirmed only at build. |
| A3 | Option A (Phase-5 net owns the 3 new `assert_promoted`) is the cleaner home vs. appending to the P3 net | Harness (c) | LOW — both satisfy STATE.md; planner decides and records. |
| A4 | `assert_promoted` with `--manifest` in a *new* net works identically to the P3 net copy | Harness (c)/(d) | LOW — the helper is self-contained (reads `KEYWORDS_REQUIRED`/`TARGET`); needs the same `--manifest` plumbing copied. Verify by running the new net with `--manifest`. |

**If any Concepts-line wrap or G6.5 wrap risk materializes, it surfaces loudly at build/verify — none is a silent failure.**

## Open Questions

1. **Where do the 3 new `assert_promoted` assertions live — new Phase-5 net or appended to the P3 net?**
   - Known: STATE.md says "extend the triple"; the H100 flip must stay in the P3 net (P3.44/P3.65 are there).
   - Unclear: whether growing `P3_SEQ` past 72 (option B) is acceptable vs. isolating Phase-5 promotions (option A).
   - Recommendation: **option A** — Phase-5 net carries its own `assert_promoted` copy + `--manifest`; P3 net only gets the in-place H100 flip. Record the choice.
2. **Does the bare `PyTorch` token stay listed alongside `PyTorch Lightning` in Skills?**
   - Known: bare `PyTorch` is x5 already (satisfied); `PyTorch Lightning` satisfies it by substring.
   - Recommendation: Claude's discretion (CONTEXT) — a fit/space call; drop bare `PyTorch` from Skills if space is tight (it stays required-keyword-satisfied by the page-1/page-2 occurrences and the Lightning substring).

## Sources

### Primary (HIGH confidence — read/measured this session)
- `docs/main.tex:60-72, 148-158, 281-295` — Skills block, itemize shape, page-1 PyTorch Lightning/torch.compile/A100/Triton bullet, graph_ml C++/Cython.
- `docs/verify/manifest.txt:45-66` — prohibited terms, `SKILLS_MAX_LINES=3`, `KEYWORDS_REQUIRED`/`KEYWORDS_TARGET`, `WARN_OWNERS`.
- `scripts/verify-resume.sh:1723-1756, 1975-1998` — G6.5/G6.6 (raw-stream keyword gate), G6.14 (Skills line count).
- `scripts/verify-phase3-regressions.sh:167,232-244,393-438,877-888,1004-1074` — emit() id numbering, assert_promoted, promotion triple, P3.44/P3.65 H100 slots.
- `scripts/verify-phase4-regressions.sh:181-290, 303-401` — net model (helpers, two streams, --gate-text, C++/Cython anchor).
- `.planning/phases/03-…/03-07-PLAN.md` — EXP-08 blocking checkpoint model.
- `.planning/STATE.md` (lines 40, 42, 51, 64-67, 85-99, 118) — standing rules, H100 flip debt, promotion-gate finding, single-file constraint.
- `.planning/research/CODEBASE-EVIDENCE.md:9,54,56,58,98,104` — evidence tiers + honesty rules.
- pdftotext measurements of `docs/AshutoshTiwari.pdf` (17-form counts, 4-line render, ~132-char capacity) — this session.

### Secondary / Tertiary
- None — no web/library research required (self-contained LaTeX + shell repo).

## Metadata

**Confidence breakdown:**
- Standard stack / environment: HIGH — toolchain fixed, verified present.
- ATS parsing (which forms new, wrap risk): HIGH — every count measured against the committed PDF this session.
- ≤3-line fit: MEDIUM-HIGH — char measurements exact; final render is MEASURE-at-build by design.
- Harness mechanics: HIGH — every file:line and value read from source this session.
- Checkpoint model: HIGH — 03-07 plan read directly.

**Research date:** 2026-08-24
**Valid until:** stable (self-contained repo); re-measure line counts after any `docs/main.tex` change since line references shift by content.
