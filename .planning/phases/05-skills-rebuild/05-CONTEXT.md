# Phase 5: Skills Rebuild - Context

**Gathered:** 2026-08-24
**Status:** Ready for planning

<domain>
## Phase Boundary

Rebuild the `\section{Technical Skills}` block of the LaTeX resume (`docs/main.tex`, page 2, resolve by CONTENT — currently ~L289–295) so it earns maximum ATS keyword coverage from the now-finalized bullet vocabulary, rendering in **≤3 lines (down from 4 today)**, with **every stretch item interview-defensible and per-item approved**. Requirements: **PG2-04, PG2-05, PG2-06**.

**In scope:** the Skills block rewrite + the harness surfaces it forces — manifest keyword promotions (`ONNX`, `CUDA graphs`, `Iceberg`, `H100`), the `P3.44`/`P3.65` H100 needle-flips, a new Phase-5 Skills regression net, and the `G6.14`/`SKILLS_MAX_LINES` WARN→pass.

**Out of scope:** page 1 (byte-frozen at `798c0fb` — never touch L140–210), all other page-2 sections (Phase 4, done), palette (VIS-01, Phase 6), site sync (SITE-01/02, Phase 6). No summary/headline section (milestone decision). No `Go`, no `speculative decoding` anywhere.

</domain>

<decisions>
## Implementation Decisions

### Taxonomy & layout (PG2-04)
- **D-01:** Rebuild as **3 functional tiers** — `Languages & Inference` / `Training & Distributed` / `Concepts` — and **repeat all 17 required exact-match forms inside Skills** even when they already appear in a page-1/page-2 bullet. Rationale: the Skills block is the ATS/recruiter keyword anchor; a self-contained tier block scans better than relying on prose occurrences. Recommended starting draft (tier membership + exact wording refined at execution by measurement):
  ```
  Languages & Inference: Rust, C++, Python, vLLM, ONNX Runtime, Triton, torch.compile, CUDA graphs, A100, H100
  Training & Distributed: PyTorch Lightning, FSDP, Flash Attention, Ray, Kubernetes, KEDA, Spark, Iceberg
  Concepts: tensor parallelism, pipeline parallelism, Mixture of Experts (MoE) parallelism, KV-cache management, continuous batching
  ```
  Of the 17 forms, only **`ONNX Runtime`, `H100`, `CUDA graphs`, `Iceberg`, `PyTorch Lightning` (exact casing)** are strictly new to the document — the rest already extract from page 1/2 (see code_context). `PyTorch Lightning` also satisfies the bare `PyTorch` required keyword by substring.

### Curation / purge (PG2-04)
- **D-02:** Skills becomes **purely the inference-framework keyword tiers + Concepts**. Drop from Skills **all research-identity tokens** (Graph Neural Networks, Contrastive Learning, Recommendations, Search Relevance, Fairness-Aware Modeling, Large Language Models) and **all generalist/grad tools** (Tensorflow, Sklearn, Numpy, Pandas, Matplotlib, HDFS, Kafka, Flink, AWS Sagemaker, DynamoDB, Faiss, Django, Scala, PyTorch Geometric). The graph/fairness/recsys identity is **not lost** — it is carried by the page-2 first-author Publication + `graph_ml` project, so it need not dilute the keyword tiers. — **Reversibility:** reversible.

### Concept-vocabulary framing (PG2-05)
- **D-03:** Label the concept group **`Concepts:`** — compact, neutral, on its own line, visually distinct from the tool tiers so it reads as a topic list rather than a build claim. (Compactness is also a fit lever: the concept content is ~120 chars, so a long label risks wrapping to a 4th rendered line.)
- **D-05:** All **5 concept items are conversant/evaluated vocabulary** — none is claimed as built or operated. Even `continuous batching` and `KV-cache management` stay conversant (the user configures vLLM, does not implement the algorithms). This keeps the `Concepts` line honestly a vocabulary list. — **Reversibility:** reversible.

### C++ anchor (PG2-06)
- **D-04:** Anchor `C++` by **implicit co-occurrence** — list `C++` in Skills and rely on the reader connecting it to the **NetSpeed NoC** bullet (page 1) and the **`graph_ml` C++/Cython kernels** (page 2), both already in the document. No explicit parenthetical in the keyword list (it would spend budget and read oddly). Criterion 4's "verifiable by a reader from the document itself" is satisfied by the two existing usages. — **Reversibility:** reversible.

### Evidence tiers & the per-item approval checkpoint (PG2-04/05, criterion 5)
- **D-06:** Ship every keyword with an **internal built/operated/evaluated tier** backing the user's per-item approval — the tier is a defense record (plan + checkpoint), **never printed on the resume**. Proposed classification:
  - **Built:** Rust, C++, Python
  - **Operated (production):** vLLM, torch.compile, Triton, CUDA graphs (via `torch.compile(mode="max-autotune")`), A100, H100, FSDP, Flash Attention, Ray, Kubernetes, KEDA, Spark, ONNX Runtime, PyTorch Lightning
  - **Evaluated / conversant:** tensor parallelism, pipeline parallelism, Mixture of Experts (MoE) parallelism, KV-cache management, continuous batching, **Iceberg**
  - **Iceberg specifically ships at the evaluated/conversant tier** (user has not run it in production — knows it conceptually: table format, schema evolution, time-travel). It still lives in a functional tools tier on the printed resume (the tier label is not printed), but this is the one operated-looking placement resting on an evaluated-only defense — **flag it for explicit confirmation at the checkpoint.**
- **D-07:** The **per-item approval is a blocking `checkpoint:decision`** at execution, run AFTER the block is rebuilt and `bash scripts/verify-resume.sh` is green, presenting each **stretch item with its proposed tier** for an individual verdict against the rendered PDF. **A single blanket "looks good" is the documented failure mode (criterion 5) — do not accept one.** Stretch set requiring per-item sign-off: the **5 Concepts**, **Iceberg**, **H100** (generalized off page 1, re-appears here), **CUDA graphs** (exact plural form, new to the doc), **ONNX Runtime** (new to Skills), **PyTorch Lightning** (casing fix). Core built items (Rust/C++/Python) and already-shipped page-1 operated items (torch.compile/A100/Triton/FSDP/Flash Attention/Ray/Kubernetes/KEDA/Spark/vLLM) are already owner-approved and ship without a per-item turn. Cannot auto-advance past this checkpoint (STATE.md hard-gate convention, as EXP-08 was). — **Reversibility:** reversible (rejection is a valid, green outcome — a rejected keyword is simply absent, exactly as EXP-08 rejections were).

### Claude's Discretion
- Exact tier membership rebalancing and final token order **within** the 3-tier scheme, driven by the measured ≤3-line fit (D-01 draft is a starting point, not frozen wording).
- Whether to list bare `PyTorch` in addition to `PyTorch Lightning` (redundant by substring; a fit/space call).
- Exact wording of the checkpoint prompt per stretch item (must show the tier and be per-item, per D-07).

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase contract
- `.planning/ROADMAP.md` — Phase 5 goal + 5 success criteria (the 17 exact-match forms, the concept group, `speculative decoding`/`Go` zero, C++ anchor, per-item approval) + the Checkpoints table row (PG2-04/05 per-item approval with recorded evidence tier).
- `.planning/REQUIREMENTS.md` — PG2-04 (keyword tiers + exact forms), PG2-05 (concept-vocab group + Go/speculative-decoding zero), PG2-06 (C++ evidenced via NetSpeed NoC + `graph_ml`).

### STATE.md — the load-bearing Phase-5 obligations (read these records verbatim)
- `.planning/STATE.md` → `[Phase 04 / close + code review]` — **STANDING RULE:** the new Skills net's **multi-word literals (`CUDA graphs`, `Flash Attention`, `ONNX Runtime`, `PyTorch Lightning`) MUST assert against `$SQUEEZED`, never the raw `$GATE` stream** (`pdftotext` wraps phrases across lines → a raw-stream absence check false-passes on a wrapped regression). Single-token needles (`A100`, `H100`, `Triton`, `Rust`, `KEDA`, `Iceberg`, `vLLM`) stay on `$GATE`.
- `.planning/STATE.md` → `[Post-Phase-3 / Page-1 Finalization + Gate Reconciliation]` **and** `### Blockers/Concerns [Phase 5]` — **H100 NEEDLE-FLIP owed:** when Skills re-adds `H100`, the SAME commit MUST flip `P3.44` → `assert_promoted 'H100'`, `P3.65` → `assert_present 'H100' "$GATE"`, and re-promote `H100` from `KEYWORDS_TARGET` → `KEYWORDS_REQUIRED` (strip the `:5`). `$GATE`/`$SQUEEZED` are whole-document, so skipping the flip reddens the P3 net mid-phase.
- `.planning/STATE.md` → `[Phase 3 / 03-08]` (three records) — the **promotion triple `P3.42`–`P3.45`** is the ONLY machine-backed promotion gate (`G6.5`/`G6.6` are a convention, not a gate); a promotion landed outside that triple's coverage has no gate — extend it for `ONNX`/`CUDA graphs`/`Iceberg`. `Triton` is already promoted (03-05); PG2-04's Triton is **additive**, not a re-promotion. Single-file LaTeX constraint. Resolve every `docs/main.tex` line reference by CONTENT. **Never reproduce a machine-read marker literal inside prose the same grep scans.**
- `.planning/STATE.md` → `[Phase 3 / D-08]` — `CUDA graphs` stays an unpromoted `KEYWORDS_TARGET` (x0) owned by Phase-5 PG2-04 because page 1 ships the hyphenated singular `CUDA-graph capture`, which the fixed-string plural never matches. Skills must land the literal **`CUDA graphs`** and promote it.

### Evidence (backs the operated/evaluated tiers + the honesty boundary)
- `.planning/research/CODEBASE-EVIDENCE.md` — commit-verified themes backing operated claims (ONNX Runtime CUDA EP, 64-H100 waves, `torch.compile` max-autotune + CUDA-graph capture, FSDP/FSDP2 + Flash Attention, Ray Data benchmark) **and** the binding honest-framing rules: NO speculative decoding, NO Go, NO tensor/pipeline/MoE parallelism as accomplishments (they are vocabulary only).
- `.opencode/skills/spike-findings-thunderock-github-io/references/projects-section.md` — the `graph_ml` C++/Cython kernel facts that are the page-2 half of the C++ anchor (PG2-06); do not remove that phrasing.

### Harness surfaces (edited this phase)
- `docs/main.tex` — `\section{Technical Skills}` block (resolve by content).
- `docs/verify/manifest.txt` — `KEYWORDS_REQUIRED` (16 today), `KEYWORDS_TARGET=ONNX:5|CUDA graphs:3|Iceberg:5|H100:5` (all 4 owner Phase 5), `SKILLS_MAX_LINES=3` (WARN until ≤3 achieved), `SECTIONS`.
- `scripts/verify-resume.sh` — `G6.14` (SKILLS_MAX_LINES WARN owned by Phase 5), `G6.5`/`G6.6` keyword gates, the `$GATE` (raw) and `$SQUEEZED` streams. Gate on `bash scripts/verify-resume.sh` (exit 0); `make verify` is corroboration only (Make collapses exit 1/2).
- `scripts/verify-phase3-regressions.sh` — `P3.44`/`P3.65` (H100 needles to flip), `P3.42`–`P3.45` (promotion triple to extend).
- `scripts/verify-phase4-regressions.sh` — the page-2 content net and the **model for the new Phase-5 Skills net** (multi-word on `$SQUEEZED`, single-token on `$GATE`, each assertion class proven failable with `--gate-text`).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- Current Skills shape: `\begin{itemize}[leftmargin=0.15in, label={}]` → `\small{\item{ ... \\ ... }}` with `\textbf{Label}{: tokens}` group labels and `\\` line breaks. Reuse this shape; swap the two current content lines for the 3 tiers.
- `scripts/verify-phase4-regressions.sh` (38 P4.x assertions, green on arrival, each `--gate-text`-failable, multi-word on `$SQUEEZED`) — the exact pattern for the new Phase-5 Skills regression net.
- `docs/AshutoshTiwari.pdf` + `pdftotext -layout` → the `TECHNICAL SKILLS` region is how line count (criterion 1 / `G6.14`) and keyword presence are measured.

### Established Patterns
- **Line count is measured from the build, never predicted** — Skills measures 4 today; the ≤3 target is proven only by rebuilding and reading `G6.14`/pdftotext. Exact-fit (esp. the `Concepts` line's wrap risk) is an execution measurement.
- **Multi-word literals → `$SQUEEZED`; single tokens → `$GATE`** (Phase-4 close BLOCKER). Applies to the new Skills net.
- **Promotion is same-commit-as-content** and only the `P3.42`–`P3.45` triple gates it. Extend the triple for each newly-promoted target in the commit that lands the keyword.
- Artifacts (`.pdf`/`.log`/`.fdb_latexmk`/`.aux`/`.fls`/`.out`) ride **in the source commit**; never `make clean` (deletes the `G0.3` freshness md5). Single-file LaTeX — no `\input`/`\include`. Resolve `docs/main.tex` line refs by content. Never reproduce a machine-read marker literal in prose. Strengthen-never-weaken applies to assertion logic (not to superseded needle literals).

### Integration Points
- `docs/verify/manifest.txt` `KEYWORDS_TARGET` → `KEYWORDS_REQUIRED` promotions for `ONNX`, `CUDA graphs`, `Iceberg`, `H100` — each in the same commit that lands the keyword in Skills.
- `scripts/verify-phase3-regressions.sh` `P3.44`/`P3.65` H100 flips + `P3.42`–`P3.45` triple extension — same commit as the H100 re-add.
- `G6.14` WARN → pass once Skills renders ≤3 lines.
- Page-2 budget is the **independent +53.5pt** one (page 1 uncoupled); Skills currently 4 lines → shrinking to ≤3 frees room, so no page-2 fit risk, but the shrink-while-adding-keywords balance is the real constraint.

</code_context>

<specifics>
## Specific Ideas

- Target block draft is the 3-tier structure in D-01 — a concrete starting point for the planner, not frozen wording.
- Concept group label is exactly `Concepts:` (D-03).
- Iceberg ships at the evaluated/conversant tier (D-06) and is one of the items explicitly confirmed at the per-item checkpoint (D-07).
- Recommendation-first workflow (PROJECT.md): the checkpoint should present concrete per-item proposals (keyword + tier) for the user to confirm/reject, not abstract questions.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope. (The graph/fairness/recsys research identity dropped from Skills in D-02 is **not** deferred: it remains present on page 2 via the Publication + `graph_ml`, by design.)

</deferred>

---

*Phase: 5-skills-rebuild*
*Context gathered: 2026-08-24*
