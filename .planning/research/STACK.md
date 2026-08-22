# Keyword Corpus — Staff MLE / Inference-Framework / ML-Platform Job Postings

**Domain:** ATS keyword vocabulary for 2025–2026 Staff/Senior-Staff MLE roles in inference-framework development, LLM serving, and ML platform engineering
**Researched:** 2026-08-21
**Confidence:** HIGH for keyword frequency and exact-match forms (primary-source postings, machine-counted). MEDIUM for tier boundaries (judgment call on thresholds). HIGH for evidence-mapping (grounded in `CODEBASE-EVIDENCE.md`).
**Downstream:** requirements definition (which keywords must land) + resume-rewrite phase (exact phrasing to copy).

---

## 0. Corpus and Method

Keywords were **counted, not recalled.** All job descriptions were pulled from companies' own public ATS APIs (Greenhouse `boards-api`, Ashby `posting-api`, Workday `cxs`, `amazon.jobs`, Eightfold), which return the full posting body — not search-engine snippets.

| Metric | Value |
|--------|-------|
| Unique postings harvested | **428** |
| Distinct companies | **24** |
| Freshness | **404 / 428 (94%) last-updated in 2026**; 21 in 2025; 3 in 2024 |
| Engineering-role subset (recruiters/PM/sales/SDET/new-grad excluded) | 369 |
| **Primary corpus** — "core-eng": titles matching inference / serving / kernel / compiler / performance / GPU / LLM / runtime / ML-platform / infrastructure | **259 postings, 24 companies** |
| **Secondary corpus** — "LLM-serving-stack": postings whose *body* names a modern serving engine or inference-specific optimization | **98 postings, 20 companies** |

**Postings per company (core-eng):** NVIDIA 104, Waymo 46, Cerebras 31, OpenAI 26, Anthropic 20, Together AI 20, Reddit 19, Pinterest 18, Nebius 18, Adobe 18, CoreWeave 14, Baseten 13, Databricks 11, Cohere 10, SambaNova 10, Tenstorrent 10, xAI 8, Scale AI 7, Perplexity 7, Fireworks AI 5, Deepgram 5, Amazon/AWS 5, Anyscale 2, Modal 1.

### Frequency columns used throughout

| Column | Meaning |
|--------|---------|
| **normDF** | *Company-normalized* document frequency: average across the 24 companies of "share of that company's postings containing the term." **This is the headline number** — it stops NVIDIA's 104 postings from dictating the corpus. |
| **co%** | Share of the 24 companies with ≥1 posting containing the term. Measures *breadth* — a term at 75% co% is table stakes everywhere even if each company mentions it in only some postings. |
| **LLM%** | Share of the 98-posting LLM-serving-stack subcorpus. Read as: *"if the role is genuinely an LLM-serving job, how likely is this word to appear?"* |
| **†** | Term was part of the selector that *defined* the LLM subcorpus → its LLM% is inflated by construction. **Use normDF/co% for these.** |

---

## 1. The Target JD Is a Real Posting — Found and Cited

The example JD language in `PROJECT.md` is **verbatim** from a live posting:

> **Together AI — "LLM Inference Frameworks and Optimization Engineer"**
> <https://job-boards.greenhouse.io/togetherai/jobs/4687884007>
>
> *"Design and develop fault-tolerant, high-concurrency distributed inference engine for text, image, and multimodal generation models."*
> *"Implement and optimize distributed inference strategies, including Mixture of Experts (MoE) parallelism, tensor parallelism, pipeline parallelism for high-performance serving."*
> *"Apply CUDA graph optimizations, TensorRT/TRT-LLM graph optimizations, and PyTorch-based compilation (torch.compile), and speculative decoding to enhance efficiency and scalability."*
> Must-have: *"3+ years of experience in deep learning inference frameworks, distributed systems, or high-performance computing."* · *"Familiar with at least one LLM inference frameworks (e.g., TensorRT-LLM, vLLM, SGLang, TGI(Text Generation Inference))."*

**Three consequences for the resume:**

1. The bar is **"3+ years … or high-performance computing"** and **"familiar with at least one"** framework — not "expert in all." The candidate's 4+ years of GPU batch-inference platform work clears the stated bar; the framework list is the gap.
2. That JD's optimization list (CUDA graphs / TRT-LLM / torch.compile / speculative decoding) is one sentence in one posting. Corpus-wide, **CUDA graphs appear in 1% normDF and speculative decoding in 13%** — do not over-index on this single sentence at the cost of Tier-1 terms.
3. **Two Adobe-internal postings are near-perfect targets** and prove he can move without leaving the domain: *Staff Applied Scientist – VLLM Inference* (R170044) and *Senior MLE, AI Platform* (R166678, body literally opens "As a **Staff** Machine Learning Platform Engineer"). Both are quoted throughout §9's phrase bank.

---

## 2. Tier 1 — Must Appear on the Resume

Threshold: **normDF ≥ 19% or co% ≥ 60%.** These are the terms an ATS screen and a recruiter scan expect.

| Keyword (canonical form) | normDF | co% | LLM% | Evidence status |
|---|---|---|---|---|
| **fault-tolerant / fault tolerance / reliability** | 63% | 92% | 47% | ✅ **Strongest asset** — DLQs, circuit breakers, lease/TTL heartbeats, idempotent re-runs |
| **Python** | 55% | 88% | 74%† | ✅ Primary language |
| **ownership / own end-to-end** | 66% | 92% | 70% | ✅ Cross-repo ownership (FCU0 → asml DAGs) |
| **PyTorch** | 41% | 83% | 64% | ✅ Glimmer/PyTorch-Lightning modules, AIDE architecture |
| **distributed systems** | 41% | 79% | 35% | ✅ K8s Indexed Jobs, Rust services, control plane |
| **observability / monitoring** | 37% | 75% | 26% | ✅ Merged Grafana/Loki/Alloy/Tempo, ServiceMonitors, PromQL |
| **Kubernetes** (also `K8s`) | 37% | 67% | 31% | ✅ Pluto/K8s GPU pipelines, Indexed Jobs, cluster-capacity API |
| **cross-functional** | 36% | 75% | 30% | ⚠️ True but unstated — needs explicit phrasing |
| **C++** | 36% | 71% | 54% | ❌ **No evidence in mined repos** — see §10 |
| **stakeholders / partner with** | 37% | 75% | 29% | ⚠️ Needs explicit phrasing |
| **CUDA** | 32% | 75% | 57% | 🟡 Runtime-level only (CUDAExecutionProvider, TF32, CUDA-work offload) — see §11 |
| **profiling / benchmarking / bottleneck analysis** | 28% (profiling) / 27% (benchmarking) | 71% / 79% | 54% / 39% | ✅ Ray-engine benchmark (109 rows/s), batch 64→128 throughput tuning, vLLM throughput ladder (platform) |
| **Go / Golang** | 29% | 71% | 22% | ❌ No evidence — see §10 |
| **vLLM** | 29% | 67% | 81%† | 🟡 Platform/operated context only — Skills-only |
| **mentoring** | 29% | 62% | 26% | ⚠️ Needs explicit phrasing |
| **GPU utilization / capacity efficiency / cost efficiency** | 28% / 18% | 75% / 75% | 23% | ✅ Cluster-capacity API, Airflow pool caps, fractional-GPU actors |
| **multimodal** (image / video / audio) | 24% | 58% | 26% | ✅ **Under-used asset** — image + 24.8M video clips + audio modules |
| **influence / org-wide impact** | 23% | 67% | 21% | ⚠️ Needs explicit phrasing |
| **SGLang** | 23% | 62% | 62%† | ❌ No evidence — see §10 |
| **scale (millions / billions of …)** | 23% | 58% | 17% | ✅ 202.6M rows, ~700M assets, 24.8M clips |
| **TensorRT-LLM** (also `TRT-LLM`) | 22% | 58% | 59%† | ❌ No evidence — see §10 |
| **roadmap** | 21% | 75% | 16% | ⚠️ Needs explicit phrasing |
| **lineage / provenance / governance** | 21% | 46% (11 cos) | — | ✅ **Surprise win** — the +27k-line Content Gate maps directly here |
| **low-latency + high-throughput** (as a pair) | ~20% combined | 71% | high | 🟡 "High-throughput" is fully true; "low-latency" only for the Rust API / control-plane work |
| **quantization** | 19% | 62% | 27% | 🟡 TF32/mixed-precision only, no INT8/FP8 — see §10 |
| **Triton** (kernel DSL, *not* the server) | 19% | 67% | 42% | 🟡 Inductor-generated Triton via `max-autotune` — see §11 |

### Tier-1 noun phrases (what to *call* the work)

ATS parsers and recruiters match on these role-nouns. Posting counts out of 259:

| Phrase | Postings | Use it as |
|---|---|---|
| `model serving` | 28 | The umbrella term. Highest-frequency single noun phrase. |
| `inference stack` | 28 | "…across the inference stack" |
| `inference engine` / `inference engines` | 24 / 14 | Reserve for the FCU/`pipeline_executor` abstraction work |
| `inference infrastructure` | 20 | Section/summary framing |
| `inference platform` | 20 | Section/summary framing |
| `distributed inference` | 15 | **Highest-value phrase he can honestly own** |
| `large-scale inference` | 10 | Alternative to "distributed inference" |
| `inference runtime` | 6 | Anthropic/OpenAI/Baseten team names |
| `inference at scale` | 4 | Weaker variant — prefer "distributed inference" |
| `AI infrastructure` | 41 | Very high — good summary-line noun |
| `ML infrastructure` | 34 | Very high — good summary-line noun |
| `ML platform` / `machine learning platform` | 8 / 2 | Lower than expected; **"AI infrastructure" and "ML infrastructure" outrank "ML platform" 5:1** |

---

## 3. Tier 2 — Common Differentiators

Threshold: **normDF 8–19% or co% 30–60%.** Include where evidenced; these are what separate a shortlist from a pile.

| Keyword | normDF | co% | LLM% | Evidence status |
|---|---|---|---|---|
| distributed training | 18% | 54% | 12% | ✅ FSDP/FSDP2 + DDP multi-node (framework he built modules for and ran) |
| cost efficiency / cost per token / TCO | 18% | 75% | — | 🟡 Needs a number he can defend |
| AWS (GCP / Azure) | 18% | 54% | 9% | ✅ S3, SQS, EMR, DynamoDB, IRSA, Aurora, CloudFront/WAF, STS |
| internal platform / developer experience / self-service | 16% | 67% | — | ✅ One-command provisioning, on-demand triggers, runbooks |
| KV cache | 16% | 46% | 27%† | ❌ No evidence |
| Rust | 16% | 46% | 16% | ✅ **+27,135 lines production Rust** — strong differentiator |
| JAX | 14% | 54% | 16% | ❌ No evidence — omit |
| InfiniBand / RDMA / RoCE | 14% | 46% | 18% | ❌ No evidence (he didn't tune fabric) |
| Ray / Ray Data / Ray Serve | 13% | 42% | 12% | 🟡 His AIDE module benchmarked on Ray Data engine — Ray Data yes, Ray Serve no |
| speculative decoding | 13% | 42% | 23%† | ❌ No evidence — and **not applicable** to his non-autoregressive models |
| autoscaling / KEDA / HPA | 13% | 42% | 10% | 🟡 Platform framing (KEDA-on-SQS-depth is the platform he built plugins in) |
| FlashAttention / FlashInfer | 13% | 33% | 22% | 🟡 FlashAttention present in the training framework he worked in |
| technical leadership | 12% | 58% | 19% | ⚠️ Needs explicit phrasing |
| NCCL / collective communication | 12% | 50% | 22% | 🟡 Implicit in multi-node A100/H100 jobs — defensible at "operated," not "tuned" |
| XLA / MLIR / LLVM | 12% | 38% | 10% | ❌ Omit |
| data pipelines / ETL | 11% | 50% | 5% | ✅ Abundant — but **compress**; low JD value per line |
| design docs / design reviews / RFCs | 11% | 46% | 10% | ✅ 425-ln ARCHITECTURE.md, 364-ln runbook, 422-ln frozen contract |
| Docker / containerization | 11% | 42% | 10% | ✅ Per-model slim images, BuildKit→ECR |
| prefill/decode disaggregation | 11% | 38% | 24%† | ❌ No evidence |
| FP8 | 10% | 46% | 13% | ❌ No evidence (TF32 ≠ FP8) |
| continuous / in-flight / dynamic batching | 9% | 46% | 20%† | 🟡 He tuned *batch size* (64→128), not *continuous* batching — phrase carefully |
| CI/CD | 9% | 46% | 13% | ✅ Smoke-test CI, SHA-pinned builds, k3d-gated tests |
| CUTLASS / cuBLAS / cuDNN | 9% | 42% | 16% | ❌ Omit |
| TensorRT (base, not -LLM) | 9% | 38% | 22% | ❌ No evidence |
| Terraform / IaC | 9% | 38% | 5% | ✅ Loki Terraform |
| 0-to-1 / from scratch / greenfield | 9% | 33% | 5% | ✅ Enrichment plugin, Content Gate, job-queue stats system |
| p95 / p99 / tail latency | 9% | 29% | 12% | ❌ No evidence — do not fabricate percentiles |
| custom CUDA kernels | 8% | 46% | 20% | ❌ **Never claim** |
| NVLink | 8% | 38% | 12% | ❌ Omit |
| Spark / EMR | 8% | 25% | 8% | ✅ 40-node EMR, 160-executor steps — **compress to one clause** |
| incident response / postmortem / MTTR | 10% | 42% | — | ✅ 6-week silent-outage root cause, STS storm fix |
| open-source upstream contributions | 5% | 38% | 10% | ❌ **Cheapest gap to close** — see §10 |

---

## 4. Tier 3 — Niche / Company-Specific

Low aggregate frequency. **Do not spend Experience-bullet space here.** Skills-line mentions only, and only where honest.

| Keyword | normDF | co% | Who asks | Note |
|---|---|---|---|---|
| tensor parallelism | 4% | 25% | NVIDIA, Cerebras, Amazon, OpenAI, Perplexity | 11% of LLM subcorpus — **in his target JD**, no evidence |
| pipeline parallelism | 3% | 21% | NVIDIA, Cerebras, Together AI | Same |
| MoE / Mixture of Experts | 3% | 29% | NVIDIA, Baseten, Cerebras, CoreWeave, Nebius | Same |
| expert parallelism | 2% | 21% | NVIDIA, Cerebras, Baseten, Nebius | Same |
| NVIDIA Dynamo | 4% | 21% | NVIDIA, Baseten, Nebius, Together AI, Amazon | Newest entrant — rising fast, watch it |
| ONNX / ONNX Runtime | 3% | 21% | Baseten, NVIDIA, Waymo, Adobe, Cerebras | ✅ **He has this** — low frequency but genuinely his |
| FSDP | 3% | 12% | Adobe, NVIDIA | ✅ His; low ATS value but high interview value |
| torch.compile | 2% | 17% | Anthropic, NVIDIA, Perplexity, Together AI | ✅ **His, in production** — low frequency, high credibility |
| TTFT / TPOT / ITL / tokens-per-second | 2% | 17% | Cerebras, NVIDIA, Nebius | Serving metrics — he has none |
| CUDA graphs | 1% | 8% | NVIDIA, Together AI | Only 3 postings corpus-wide. See §11 for the honest bridge |
| chunked prefill | 1% | 17% | Baseten, Cerebras, NVIDIA, Nebius | No evidence |
| prefix caching / radix attention | 1% | 21% | Cerebras, NVIDIA, Nebius, Together AI, Waymo | No evidence |
| PagedAttention | 2% | 8% | Amazon, Together AI | Surprisingly rare as a literal string |
| Triton Inference Server (full name) | 3% | 17% | Adobe, Cerebras, NVIDIA, Nebius | Only 6 postings use the full name |
| TGI / Text Generation Inference | 5% | 12% | Adobe, Nebius, Scale AI, Together AI | Declining |
| DeepSpeed | 2% | 17% | Adobe, NVIDIA, SambaNova | Declining |
| AWQ / GPTQ / SmoothQuant / GGUF | <1% | 4% | Nebius only | **Effectively dead in JDs** — skip entirely |
| MLOps | 5% | 29% | — | ✅ His, but weaker signal than "AI/ML infrastructure" |
| feature store / feature registry | 3% | 8% | Amazon, OpenAI, Reddit, Waymo | ✅ His (Feature Registry) — one mention max |
| Airflow / DAG orchestration | 4% | 17% | Baseten, Reddit | ✅ His — one mention max |
| MLflow / W&B | 3% | 17% | Databricks, Fireworks | Omit |
| llama.cpp · TensorFlow Serving · KServe · Seldon · BentoML · ZeRO · 3D parallelism | 0–1% | ≤4% | — | **Zero or near-zero. Do not include.** |

---

## 5. Exact-Match Forms — Casing and Hyphenation That Matters

ATS keyword matchers are frequently case-insensitive but **substring-literal**, so hyphens and spaces decide matches. Counts are postings out of the 259 core-eng corpus.

### Write it exactly this way

| Canonical form to write | Postings | Rival forms seen | Rule |
|---|---|---|---|
| **`vLLM`** | 73 | `vllm` (1), `VLLM` (0 — though Adobe's *title* is "VLLM Inference") | Lowercase-v, capital LLM. Never "VLLM" in body text. |
| **`SGLang`** | 55 | `sglang` (1), `SGlang` (1) | Capital S-G-L. |
| **`TensorRT-LLM`** | 46 | `TRT-LLM` (11), `TensorRT LLM` (2), `TRTLLM` (1) | **Write both:** `TensorRT-LLM (TRT-LLM)`. Hyphen, not space. |
| **`TensorRT`** | 64 | — | One word, capital T-R-T. |
| **`PyTorch`** | 106 | `Pytorch` (7), `torch` (15) | Capital P, capital T. `torch` alone only inside `torch.compile`. |
| **`torch.compile`** | 7 | `torch compile` (1), `TorchInductor` (2), `TorchDynamo` (2) | Lowercase, with the dot. **The dot matters** — "torch compile" won't match. |
| **`CUDA`** | 95 | `cuda` (1) | All caps. |
| **`Kubernetes`** | 68 | `K8s` (1), `k8s` (2) | **Spell it out.** "K8s" appears in only 3 of 259 postings. |
| **`Mixture of Experts (MoE)`** | `MoE` 15 · `Mixture-of-Experts` 2 · `Mixture of Experts` 1 | | Acronym dominates 5:1. Write **`Mixture of Experts (MoE)`** once to catch both spellings, then `MoE`. |
| **`KV cache`** | 12 | `KV-cache` (13), `KV caching` (4), `KV Cache` (1) | Hyphen and space are **tied**. Write `KV cache` and let a nearby `KV-cache` variant appear once if space allows. |
| **`FlashAttention`** | 12 | `FlashInfer` (12), `Flash Attention` (4), `flash-attention` (2) | One word is canonical. `FlashInfer` is a *different library*, equally frequent — don't conflate. |
| **`tensor parallelism`** | 10 | `tensor parallel` (10) | Exactly tied. `tensor parallelism` also substring-matches `tensor parallel`… no it doesn't — but `tensor parallel` **is** a substring of `tensor parallelism`. **So write the longer form:** `tensor parallelism` matches both queries. Same logic for `pipeline parallelism`, `expert parallelism`. |
| **`FSDP`** | 5 | `Fully Sharded Data Parallel` (0) | Acronym only. Nobody spells it out. |
| **`speculative decoding`** | 21 | `EAGLE` (2), `Medusa` (1) | Spell out; skip the algorithm names. |
| **`continuous batching`** | 14 | `dynamic batching` (2), `request batching` (1), bare `batching` (31) | `continuous batching` is the term of art; bare "batching" is the safe honest fallback. |
| **`disaggregated` / `prefill/decode`** | 13 / 6 | `disaggregation` (8), `prefill-decode` (3) | Slash form beats hyphen. |
| **`quantization`** | 32 | `FP8` (15), `FP4` (7), `INT8` (6), `INT4` (6), `NVFP4` (2), `MXFP4` (1) | American -z spelling (`quantisation` = 0 hits). |
| **`NCCL`** | 34 | `InfiniBand` (23), `RDMA` (19), `NVLink` (17), `RoCE` (16) | All acronyms/CamelCase as shown. `InfiniBand` has a capital B. |
| **`Nsight Systems` / `Nsight Compute`** | — | `PyTorch Profiler`, `py-spy` | Profiler names are named explicitly by Baseten/CoreWeave/NVIDIA. |
| **`Triton`** | 57 | `Triton Inference Server` (6), `OpenAI Triton` (4), `Triton kernels` (2) | ⚠️ **Ambiguity trap** — see below. |
| **`Go`** | `Go,` 28 · `Golang` 6 | | Prefer bare `Go` in a comma-list (`Python, Go, Rust`); `Golang` is 5× rarer. |
| **`A100` / `H100` / `H200` / `B200` / `GB200`** | 1 / 4 / 2 / 4 / 3 | `Blackwell` (3), `Hopper` (1) | Low literal frequency — GPU model numbers are **credibility signals for humans, not ATS keywords.** Keep them, but don't count on ATS. |
| **`p99` / `P99`** | 2 / 5 | `P95/P99` pairs common | Capital P slightly more common. |
| **`TTFT` / `time to first token`** | 8 / 3 | `time-to-first-token` (1) | Acronym dominates. |
| **`large language model` + `LLM`** | 34 / 123 | `LLMs` (41), `foundation model` (21), `frontier model` (27), `generative AI` (34) | Use `LLM` heavily; add `large language model` once for spelled-out matchers. `generative AI` and `frontier model` are high-value adjacent terms. |
| **`multimodal`** | 23 | `multi-modal` (5), `Multimodal` (21) | Unhyphenated 4:1. |

### ⚠️ The "Triton" ambiguity trap

`Triton` appears in 57 postings, but only **6** say `Triton Inference Server`. In this corpus "Triton" almost always means **the OpenAI/Inductor kernel DSL** — it co-occurs with CUDA, CUTLASS, and "write and tune GPU kernels."

**Implication:** writing a bare `Triton` in a Skills list will be read by an inference-team interviewer as *"I write Triton kernels."* If the intent is the NVIDIA server, **write `Triton Inference Server` in full.** If the intent is the kernel language, see §11 for the only honest framing.

### Long-form-beats-short-form rule

Because most matchers use substring containment, prefer the longer string whenever the short one is a prefix of it:

- `tensor parallelism` ⊃ `tensor parallel` ✅ write the long one
- `pipeline parallelism` ⊃ `pipeline parallel` ✅
- `expert parallelism` ⊃ `expert parallel` ✅
- `TensorRT-LLM` ⊅ `TRT-LLM` ❌ **unrelated strings — write both**
- `Mixture of Experts` ⊅ `MoE` ❌ **write both**
- `Kubernetes` ⊅ `K8s` ❌ — but K8s is only 3/259, so just write `Kubernetes`

---

## 6. Verbs and Quantification Patterns

### Bullet-leading verbs, by frequency in responsibility bullets (259 postings)

| Rank | Verb | Count | Rank | Verb | Count |
|---|---|---|---|---|---|
| 1 | **Develop** | 66 | 8 | **Own** | 20 |
| 2 | **Build** | 57 | 9 | **Optimize** | 19 |
| 3 | **Design** | 54 | 10 | **Improve** | 18 |
| 4 | **Collaborate** | 50 | 11 | **Define** | 17 |
| 5 | **Drive** | 36 | 12 | **Implement** | 14 |
| 6 | **Partner** | 28 | 13 | **Debug** | 13 |
| 7 | **Lead** | 24 | 14 | **Architect** | 11 · **Profile** 9 · **Mentor** 8 |

### Compound verb phrases (copy these constructions)

| Phrase | Postings |
|---|---|
| `Design and implement` | 10 |
| `Design and develop` | 4 |
| `Design and architect` | 3 |
| `Define and drive` | 3 |
| `Profile and optimize` / `Profile and analyze` | 2 / 3 |
| `Build and maintain` / `Build and improve` | 4 / 3 |
| `Optimize and debug` | 2 |

### Staff-level competency language, by posting share

| Phrase | Share | Phrase | Share |
|---|---|---|---|
| `debug` | 39% | `deep expertise` | 13% |
| `at scale` | 32% | `production-grade` | 11% |
| `collaborate with` | 32% | `design and implement` | 11% |
| contains a `%` figure | **29%** | `technical direction` | 8% |
| `end-to-end` | 27% | `high-impact` | 8% |
| `partner with` | 25% | `technical leadership` | 8% |
| `benchmark` | 25% | `autonomously` | 8% |
| `ownership` | 23% | `mission-critical` | 7% |
| `cross-functional` | 23% | `architect and` | 7% |
| `state-of-the-art` | 22% | `root cause` | 7% |
| `mentor` | 22% | `identify bottlenecks` | 5% |
| `tune` | 19% | `ambiguity` | 5% |
| `influence` | 16% | `technical strategy` | 4% |
| `profile` | 15% | `technical roadmap` | 3% |
| `own the` | 14% | `drive alignment` · `define and drive` | 3% |

### Seniority calibration (years-of-experience asks in staff/senior-titled postings)

`5+ years` 55 mentions · `3+` 30 · `8+` 25 · `10+` 14 · `6+` 9 · `7+` 9 · `12+` 7 · `15+` 4

**Staff bands cluster at 8–10+ years** (CoreWeave Staff: "8–12+ years"; Databricks Staff Model Serving: "10+ years"; Adobe Staff Platform: "7+ years"; Databricks GenAI Inference Staff: "6+ years"). Senior inference roles ask 5+.

### Quantification patterns actually used

Postings don't ask for "increased X by Y%" — they ask for **metrics-driven** work. Copyable framings:

- *"deliver measurable improvements to latency, throughput, and reliability"* (CoreWeave)
- *"Experience improving system performance using metrics-driven approaches (e.g., latency, throughput, utilization)"* (CoreWeave Staff)
- *"Implement advanced optimizations … and quantify impact"* (CoreWeave)
- *"Proven track record improving tail latency (P95/P99) and service reliability through metrics-driven work"* (CoreWeave)
- *"drive improvements in time to first token, throughput, tail latency, and capacity efficiency"* (Cerebras Staff)

**Preferred metric families, in JD order of appearance:** throughput → latency → GPU/resource utilization → cost (cost-per-token / TCO) → reliability (SLO, error rate) → scale (rows, assets, GPUs).

---

## 7. Mapping — Candidate Evidence → Exact JD Keyword

Every row below is anchored to a commit-verified item in `CODEBASE-EVIDENCE.md`. **These are safe for Experience bullets.**

### 7.1 Inference / serving (the money rows)

| Evidence (from CODEBASE-EVIDENCE.md) | JD keywords it earns | Tier |
|---|---|---|
| `styx_enrichment` — 3 production image models as SQS-fed **batched GPU inference pipelines** on K8s/Pluto, writing to Feature Registry (#307/#357/#447, +5.9k ln) | `distributed inference`, `model serving`, `inference pipelines`, `GPU inference`, `Kubernetes`, `multi-model`, `high-throughput`, `production-grade` | **1** |
| colligo FCU — **led "Simplica-free" architecture migration**: `FeatureComputeUnit2ABC` with pluggable `pipeline_executor`, **per-record vs per-batch inference toggle**, GPU-vs-CPU pipeline routing | `inference engine`, `inference framework`, `batching strategies`, `request routing`, `Design and architect`, `Lead`, `architecture migration` | **1** |
| GPU inference offloaded to background thread (`asyncio.to_thread`) so the async SQS/IO event loop is never blocked by **CUDA work** (`1404e2c77`) | `CUDA`, `high-concurrency`, `concurrency`, `throughput optimization`, `runtime`, `bottleneck analysis` | **1** |
| `torch.compile(mode="max-autotune")` on CLIP ViT-B/32 encoder + classifier, **in production** (#1611/#1619) | `torch.compile`, `PyTorch-based compilation`, `graph compilation`, **`CUDA graphs`** and **`Triton`** (see §11), `kernel fusion` (compiler-driven) | **1 / 3** |
| ONNX Runtime **CUDAExecutionProvider** fingerprint embedding generator (#2035/#2037) | `ONNX Runtime`, `inference runtime`, `CUDA`, `embeddings`, `model deployment` | **3** |
| AIDE detector throughput tuning: **batch 64→128, threads 2→4**, removed 1M-row LIMIT for full-span run (`350288acb`); **TF32** matmul | `throughput`, `batching`, `mixed precision`, `tune`, `Optimize`, `GPU utilization`, `performance tuning` | **1 / 2** |
| AIDE module **benchmarked on Ray Data engine**: 1×p4d.24xlarge (8×A100), 16 **fractional-GPU actors (0.5 GPU each)**, 1,087,682 rows @ **109 rows/s** steady | `Ray` / `Ray Data`, `benchmark`, `GPU utilization`, `A100`, `multi-GPU`, `metrics-driven`, `quantify impact` | **1 / 2** |
| Sep-2025 release fleet: 9 production modules, `--num-nodes 3 --num-gpus 8 A100-40GB` = **24×A100 per model job × 9 queues** | `multi-node`, `multi-GPU`, `distributed inference`, `GPU fleet`, `A100`, `at scale` | **1 / 2** |
| asml enrichment wave: 8 feature modules × 8×**H100**-80GB = **64 H100s** in parallel | `H100`, `multi-node`, `GPU fleet`, `large-scale inference` | **1 / 2** |
| GPU allocation/scheduling fixes on **shared inference cluster** (CoCa, LLaVA-OCR, HED/Mask2Former, language classifier) | `GPU scheduling`, `multi-tenant`, `shared GPU fleet`, `resource management`, `capacity efficiency` | **1 / 2** |
| Concurrency control: capped concurrent GPU modules at **6** via Airflow pool | `admission control`, `concurrency`, `request scheduling`, `resource management` | **2** |
| Per-model slim Docker images (extras-driven `uv pip compile`), declarative per-model `batch.yaml` | `Docker`, `containerization`, `declarative`, `model packaging`, `deployment` | **2** |

### 7.2 Fault tolerance and reliability (his single strongest keyword family — 63% normDF, 92% of companies)

| Evidence | JD keywords | Tier |
|---|---|---|
| Redis consumer groups, **DLQ**, delivery-count retry (cap 5), **lease/TTL heartbeat (30s TTL extended every 20s, 3600s cap)**, transient-vs-permanent error classification, `ConsecutiveFailureTracker` **circuit breaker** | `fault-tolerant`, `fault tolerance`, `reliability`, `failure recovery`, `retries`, `graceful degradation`, `distributed systems` | **1** |
| Preemptible GPU fleet: Glimmer-queue drain as authoritative success signal, **idempotent re-runs**, stale-queue drop-before-create, window fallback to latest `_SUCCESS`, `--preemptible --enable-autorecovery v2` | `fault tolerance`, `preemption`, `elastic restart`, `auto-recovery`, `self-healing`, `idempotency` | **1 / 2** |
| 202.6M-row migration: deterministic sharding by stable hash + **resumable scan**, asymmetric retry + **circuit breaker**, post-send timeouts terminal & reconciled by next run's probe (never blind-resent), atomic report persistence (tmp + `os.replace`) | `fault-tolerant`, `at scale`, `reliability`, `idempotency`, `resumable`, `sharding`, `correctness` | **1** |
| `checkpoints.py` — concurrency-safe S3 **checkpoint cache** on local SSD: file locking with stale-lock PID detection, ETag/size revalidation, **fail-open to known-good cache** | `caching`, `checkpointing`, `graceful degradation`, `fault tolerance`, `concurrency` | **1 / 2** |
| Skip-rate guard hardening (`22242ca0a`) — data-corruption **circuit breaker**, lock-protected counters with lock-free fast path, **concurrency regression tests** | `fault tolerance`, `concurrency`, `regression tests`, `data quality` | **1 / 2** |
| **STS assume-role storm** fix (`46665c4`, +457 ln): shared negative cache with 60s cooldown + exactly-one half-open retry (circuit-breaker semantics); 8-thread thundering-herd collapse test | `root cause`, `circuit breaker`, `reliability`, `debug`, `production incident` | **1 / 2** |
| **Root-caused 6-week silent outage** (package rot broke `genie[glimmer]` venv installs); added install/import smoke-test CI; SHA-pinned builds | `root cause`, `incident response`, `debug`, `CI/CD`, `regression prevention` | **1 / 2** |
| RS256 JWT minting with **graceful 503 degradation**, redacting `Debug`, compile-time no-token-leak probes (#1870) | `graceful degradation`, `security`, `Kubernetes` (Secret-mounted key), `production-grade` | **2** |

### 7.3 Distributed systems, Rust, platform

| Evidence | JD keywords | Tier |
|---|---|---|
| **Content Gate (Rust), +27,135 lines solely his** — fingerprint/sample-index/routers, 6 SQL migrations, 422-ln frozen cross-runtime contract, idempotent claim/receipt registration, manifest-after-data publication, 9,722-ln integration test | `Rust`, `distributed systems`, `fault-tolerant`, **`lineage`**, **`provenance`**, **`governance`**, `API design`, `idempotency`, `design docs`, `production-grade`, `0-to-1` | **1 / 2** |
| **K8s cluster-capacity API** in Rust (#675): cluster capacity + per-pod scheduling status, surfaces `FailedScheduling`/`Unschedulable`, batched event LIST, k3d-gated tests | `Kubernetes`, `capacity planning`, `GPU scheduling`, `Rust`, `observability`, `orchestration` | **1** |
| Pluto control plane — **job-queue stats system (3 services + worker, +1,049 ln)**: monitor (entity search → Redis, 60s per-queue rate limit), worker (throughput calc), update service (batched entity updates 50/batch, 3s flush) | `control plane`, `observability`, `throughput` metrics, `rate limiting`, `distributed systems`, `0-to-1` | **1 / 2** |
| Decoupled hydration worker from ECS control-plane DB (−193 ln coupling); auto-start enrichment on hydration completion + service-principal permission check (+751 ln incl. 440 tests) | `service boundaries`, `orchestration`, `self-service`, `automation`, `internal platform` | **2** |
| `fetools` — Rust/Axum + Vue console: status-preserving proxy, cursor pagination, MSW + wiremock test layers, path-traversal-proof key validation | `Rust`, `internal platform`, `developer experience`, `security`, `API design` | **2** |
| Observability merged: Loki **Terraform** (#692), alloy-gateway OTLP `memory_limiter` (#732), +2,048-ln telemetry-pipeline-health **Grafana** section + ServiceMonitors for Alloy/Loki-write/**Tempo** (#779), PromQL guard (#878) | `observability`, `monitoring`, `Prometheus`, `Grafana`, `OpenTelemetry`, `telemetry pipelines`, `dashboards`, `Terraform` | **1 / 2** |
| Deployment tooling (100% his): one-command Airflow-node provisioning on Pluto (`launch_airflow_node.sh`, 31 commits), on-demand enrichment triggers, operational queue driver, per-table FR version pinning | `internal platform`, `developer experience`, `self-service`, `provisioning automation`, `operational tooling` | **2** |
| CI-runner fleet: preemptible allocation, fixed silently-skipped tarball checksum verification, per-pod work-dir isolation stopping cross-pod git-worktree corruption | `CI/CD`, `preemption`, `reliability`, `debug` | **2** |

### 7.4 Training-side and data (compress — real but lower JD value)

| Evidence | JD keywords | Tier | Space guidance |
|---|---|---|---|
| FSDP/FSDP2 + DDP multi-node, FlashAttention, context parallelism in the genie training framework he built modules for and ran | `distributed training`, `FSDP`, `FlashAttention`, `multi-node` | 2 / 3 | One clause; keep for interview leverage |
| AIDE architecture as Glimmer module: 30 SRM high-pass filters, DCT patch decomposition, dual ResNet-50 branches, frozen OpenCLIP ConvNeXt-XXLarge (laion2B), MLP fusion head (+1,091 ln) | `PyTorch`, `model architecture`, `vision`, `multimodal`, `research-to-production` | 1 / 2 | Worth a clause — proves he reads papers and ships them |
| 24.8M video clips / 618 parquet shards / 16-pod K8s Indexed Job (#1139) · ~700M-asset catalog · +35–38M images/month | `multimodal` (video), `at scale`, `millions of`, `data pipelines` | 1 | Numbers only, no mechanism detail |
| FCU0 daily **Spark** job joining **Iceberg** tables → Feature Registry parquet + DynamoDB pointer upload; dynamic partition count 10–2,500; 40-node **EMR** daily; 160-executor entitlements sync | `Spark`, `data pipelines`, `ETL`, `performance tuning`, `AWS` | 2 | **One clause maximum** — 8% normDF |
| `AssetValidationRunner` into ~20 model pipelines with per-pipeline threshold gating | `evaluation`, `validation`, `quality gating`, `regression infrastructure` | 1 / 2 | Pairs well with "benchmark/evaluation" (27% normDF, 79% co%) |
| DuckDB SQL joins over disco-feature-store parquet; `clio4_genie_multi_700M.yaml`; Feature Registry | `feature store`, `data curation`, `training data` | 3 | One mention |

### 7.5 Staff-level competency — evidence exists, phrasing is missing

These have **no keyword problem, only a wording problem.** All four are Tier 1 by frequency.

| Competency | JD keyword | Evidence available to phrase it with |
|---|---|---|
| Technical leadership | `technical leadership` (58% co%), `technical direction` (8%), `architect` | "**Led** the Simplica-free architecture migration"; owned Content Gate's frozen cross-runtime contract that other runtimes must implement |
| Cross-functional | `cross-functional` (75% co%), `partner with` (75%) | FCU0 export (his) feeds asml DAGs (his) feeds Glimmer modules (his) — cross-repo, cross-team; co-authored #1139 with J. Mracek |
| Mentoring | `mentor` (62% co%) | 425-ln ARCHITECTURE.md + 364-ln runbook + 422-ln contract doc + 1,710-ln contract checker = enabling other engineers (frame as "documented and enabled," not fabricated 1:1s) |
| Roadmap / ownership | `roadmap` (75% co%), `own the` (14%) | Owns FCU0 export evolution end-to-end; owns enrichment fleet operation across 9 model queues |

---

## 8. Tier-1 Keywords With NO Evidence — Gap Table

Ranked by ATS cost of omission. Verdicts respect the honesty rule: **bullets stay evidence-true; Skills may stretch to interview-defensible only.**

| Keyword | normDF / co% | Interview defensibility today | Verdict |
|---|---|---|---|
| **C++** | 36% / 71% | **UNKNOWN — ask the user.** Zero C++ in the seven mined Adobe repos (Python/Rust). NetSpeed Systems (NoC IP) is a plausible C++ source. | 🔴 **Highest-value single gap.** If he has real C++ from NetSpeed → Skills, immediately. If not → omit and accept the loss; Rust partially substitutes, because many postings phrase the ask as a *language list*, not as C++ specifically: Adobe R166678 — *"Python and at least one systems language (Go, C++, Rust, or Java)"*; Reddit ML Efficiency — *"Proficiency in at least one systems language (Go, C++, Rust, or Java) preferred"*; Scale AI — *"one or more languages (e.g., Python, Go, Rust, C++)"*. **Rust satisfies the literal requirement in those three.** It does **not** at CoreWeave Staff Inference (*"Go, Python, or C++"*) or xAI (C++ in the title). |
| **Go / Golang** | 29% / 71% | **UNKNOWN — ask the user.** No evidence. | 🟠 Skills only if genuine. Same "systems language" substitution applies — Rust covers it in the postings that phrase it as a list. |
| **vLLM** | 29% / 67% | **MEDIUM.** Evidence file: "vLLM (operated/platform context)." The platform he works in runs vLLM plugins and an OTS vLLM H100 throughput ladder (concurrency 8→128, 8,192-token) — *others' work*. He can discuss what the platform does but not what he built in it. | 🟡 **Skills: yes** (67% of companies; omitting it is expensive). **Bullets: never.** Prep: be able to explain continuous batching + PagedAttention + why the throughput ladder saturates. A "platform that serves … via vLLM" framing is honest if the sentence subject is the platform, not him. |
| **SGLang** | 23% / 62% | **LOW today.** No exposure at all. | 🟡 Skills only **after** a genuine hands-on spike (an afternoon: `pip install sglang`, serve a small model, compare against vLLM on the same prompt set). Without that, a "have you used SGLang?" question ends badly. Cheap to fix — recommend doing it. |
| **TensorRT-LLM (TRT-LLM)** | 22% / 58% | **LOW.** Explicitly out-of-scope in `PROJECT.md`. | 🟠 **Split decision.** ATS cost of omission is real (58% of companies). Recommendation: **omit unless he does a weekend spike** (convert one of his own ONNX classifiers through TRT-LLM/TensorRT and record the speedup). That spike is cheap, plausible given his ONNX Runtime experience, and converts a fabrication into a fact he can narrate. If he won't spike it, lean on the honest neighbors: `ONNX Runtime`, `torch.compile`, `TensorRT` ecosystem literacy. |
| **CUDA (kernel-level)** | 32% / 75% | **PARTIAL — genuinely defensible at runtime level.** CUDAExecutionProvider, TF32 matmul, CUDA-work-off-the-event-loop, `max-autotune`, A100/H100 fleets. Zero hand-written kernels. | 🟢 **Skills: `CUDA` yes** — the word is honestly earned at runtime/EP level. **Never** write "CUDA kernel development," "custom kernels," or "kernel authoring" (8% normDF but 46% co% — tempting and disqualifying). If asked "have you written a kernel?" the correct answer is "no — I've worked a layer up: Inductor-generated Triton, ONNX Runtime CUDA EP, and keeping CUDA off the async event loop." That answer is respected. |
| **quantization / FP8 / INT8** | 19% / 62% | **PARTIAL.** TF32 mixed precision only. | 🟡 Write `mixed precision (TF32)` — true, and substring-adjacent to the mixed-precision asks (CoreWeave: *"Familiarity with mixed precision (BF16, FP8)"*). Do **not** write FP8/INT8/AWQ/GPTQ. `quantization` as a bare Skills word is a stretch — include only if user accepts a "familiar, not shipped" answer. |
| **MoE / tensor / pipeline / expert parallelism** | 3% / 4% / 3% / 2% aggregate (but 9–17% in LLM subcorpus, **and in the target JD**) | **MEDIUM-LOW.** He has FSDP/FSDP2 + DDP + context parallelism from the training framework — real adjacent parallelism literacy, wrong axis. | 🟡 **Skills line phrased on his axis:** `distributed training & inference parallelism (FSDP/FSDP2, DDP, context parallelism)` — that string honestly contains `parallelism` and `distributed`. Add `tensor parallelism, pipeline parallelism, Mixture of Experts (MoE)` **only** in a clearly separate "working knowledge" grouping **with user approval**, because the target JD names them and ATS will look. Interview prep is mandatory if listed: know why TP is latency-bound on NVLink, why PP creates bubbles, why EP needs all-to-all. |
| **KV cache / continuous batching / PagedAttention / chunked prefill / prefix caching** | 16% / 9% / 2% / 1% / 1% | **LOW.** His models are classifiers/detectors/embedders — **non-autoregressive**, so KV cache literally does not apply to them. | 🟢 **Omit from bullets; this is a feature, not a bug.** The honest, strong line is: "my inference work is batch/throughput-oriented on vision and embedding models, so the KV-cache/continuous-batching layer isn't mine — here's the batching and scheduling work that is." `batching strategies` and `batch-size/throughput tuning` are his and are honest. |
| **speculative decoding** | 13% / 42% | **LOW, and inapplicable** (no autoregressive decoding in his models). | 🔴 **Omit entirely.** Highest interview risk per unit of ATS gain in the whole corpus. |
| **CUDA graphs** | 1% / 8% | **DEFENSIBLE via torch.compile** — see §11. | 🟢 Include via the §11 framing only. Only 3 postings corpus-wide use the literal string, so the ATS stake is near-zero — but it's in the target JD, and §11 makes it free. |
| **InfiniBand / RDMA / NVLink / NCCL** | 14% / 8% / 12% | NCCL implicit in his multi-node A100/H100 jobs (defensible as "operated," not "tuned"). Fabric-level work: none. | 🟡 `NCCL` acceptable in Skills. **Omit InfiniBand/RDMA/RoCE/NVLink** — those postings want fabric debugging he hasn't done. |
| **p95 / p99 / tail latency / TTFT** | 9% / 2% | None — he has no serving-latency numbers. | 🔴 **Never invent percentiles.** Use throughput, rows/s, GPU-count, asset-count, and utilization numbers, which he has in abundance. |
| **JAX · XLA/MLIR · CUTLASS · TensorRT(base) · Triton kernels · llama.cpp · KServe · ZeRO** | 14% / 12% / 9% / 9% / — | None. | 🔴 Omit all. |
| **open-source upstream contributions** | 5% / 38% (12 companies) | None in evidence. | 🟠 **Cheapest high-leverage gap in the whole corpus.** NVIDIA, Baseten, CoreWeave, Cerebras, Databricks, Nebius, SambaNova all list OSS contributions to vLLM/SGLang/TRT-LLM/FlashInfer as a stand-out. **One merged docs or small-bugfix PR to vLLM or SGLang would simultaneously make `vLLM`, `SGLang`, `open-source contributions`, and "contributed to inference frameworks" defensible.** Highest ROI action available outside the resume itself. |

---

## 9. Copy-Ready Phrase Bank

### 9.1 Verbatim JD phrases he can honestly mirror

Each line is a real posting phrase (source in brackets) that his evidence supports. These are the exact strings to echo.

| JD phrase (verbatim) | Source | His backing |
|---|---|---|
| "fault-tolerant, high-concurrency distributed inference" | Together AI | DLQ/lease/circuit-breaker + `asyncio.to_thread` CUDA offload + SQS-fed GPU pipelines |
| "Architect and optimize **distributed multimodal inference pipelines** for large-scale image, video, and audio" | **Adobe R170044** | `styx_enrichment` 3 image models + 24.8M video clips + audio modules |
| "Design distributed processing systems capable of handling **billions of media assets** across heterogeneous compute environments" | **Adobe R170044** | ~700M-asset catalog, 202.6M-row migration |
| "extracting **maximum utilization from large GPU fleets**" | **Adobe R166678** | cluster-capacity API, fractional-GPU actors, Airflow pool caps |
| "serving inference at **low latency and high throughput** under real traffic" | **Adobe R166678** | high-throughput yes; use "high throughput" alone unless the Rust API is the subject |
| "Build and maintain **fault-tolerant, high-performance systems** for serving LLMs workloads at scale" | Scale AI | Reliability family, verbatim-compatible |
| "**Improve GPU and general resource utilization** through scheduling, resource management, caching, and workload optimization" | Reddit ML Efficiency | Checkpoint cache, GPU/CPU routing, pool caps, capacity API |
| "Develop tooling that helps ML engineers **debug, profile, optimize, and monitor** model performance" | Reddit ML Efficiency | Job-queue stats system, Grafana telemetry-health, runbooks |
| "**Ensure reliability, reproducibility, and fault tolerance** in the inference pipelines, including A/B launches, rollback, and model versioning" | Databricks Staff GenAI | Idempotent re-runs, resumable shards, S3-versioned model loading, FR version pinning |
| "**Own and drive the architecture, design, and implementation** of the inference engine" | Databricks Staff GenAI | Led FCU `pipeline_executor` migration |
| "Design and operate **distributed systems** that run large-scale training and … inference reliably **across thousands of accelerators**" | **Adobe R166678** | 24×A100×9 queues; 64×H100 wave — say "dozens of GPUs per job across a fleet," not "thousands" |
| "**Profile and optimize** the inference framework … " | NVIDIA | Ray benchmark, batch/thread tuning, event-loop bottleneck fix |
| "**identify bottlenecks** and drive performance improvements" | Reddit / NVIDIA | Event-loop blocking, skewed S3 writes, STS storm, 6-week outage |
| "**Lead cross-functional initiatives**" / "Drive cross-functional alignment" | Cerebras / Adobe | Cross-repo FCU0 → DAGs → Glimmer ownership |
| "**Mentor** engineers in distributed systems, scalable ML infrastructure" | **Adobe R170044** | Architecture docs, runbooks, contract checker |
| "**Represent the team externally** through benchmarks … and open-source contributions" | Databricks Staff | ❌ Gap — see §8 OSS row |

### 9.2 Bullet skeletons (JD-shaped, evidence-true)

Fill the brackets from `CODEBASE-EVIDENCE.md`. Each opens with a Tier-1 verb and lands ≥2 Tier-1 keywords.

- **Designed and built** a *fault-tolerant distributed inference* pipeline serving **[3]** production **[image/multimodal]** models on **[A100/H100]** *GPU* fleets under *Kubernetes*, with **[SQS-driven]** *batching*, *checkpoint caching*, and *graceful degradation* — **[N]** assets enriched.
- **Led** the *architecture* migration of the *inference engine* to a pluggable **`pipeline_executor`**, adding *per-record vs per-batch* **batching strategies** and *GPU/CPU routing*, and migrated **[2]** production models onto it.
- **Optimized** *inference throughput* by keeping *CUDA* execution off the async event loop, raising *batch size* **[64→128]** and worker threads **[2→4]**, and introducing **`torch.compile(mode="max-autotune")`** — *PyTorch graph compilation* with *CUDA graph* capture — on the **[CLIP ViT-B/32]** encoder + classifier in production.
- **Built** *fault tolerance* for *inference* on **preemptible GPU** fleets: *idempotent* re-runs, queue-drain success signals, lease/TTL heartbeats, DLQs, and *circuit breakers* — **[6]** concurrent GPU modules under *admission control*.
- **Owned** a **[+27,135-line]** production *Rust* subsystem for training-data *lineage* and *governance*: idempotent claim/receipt registration, immutable evidence layouts, and a frozen cross-runtime contract other services implement.
- **Drove** *observability* for the *ML platform* — *Grafana*/*Loki*/*OpenTelemetry* telemetry-pipeline health dashboards and *ServiceMonitors* — and a *Kubernetes* *capacity* API surfacing per-pod GPU *scheduling* status.
- **Root-caused** and fixed **[a 6-week silent outage / an STS request storm]**, then **added** the *CI* *regression* guard that prevents recurrence.
- **Benchmarked** **[his]** *inference* module on the *Ray Data* engine — **[16]** *fractional-GPU actors* on **[8×A100]**, **[1.09M]** rows at **[109 rows/s]** steady-state.

### 9.3 Summary/headline vocabulary

Highest-density Tier-1 nouns for the top line: `AI infrastructure` (41 postings) · `ML infrastructure` (34) · `distributed inference` (15) · `model serving` (28) · `inference platform` (20) · `fault-tolerant` · `high-throughput` · `GPU` · `multimodal` · `Kubernetes` · `PyTorch` · `Rust`.

Note "**AI infrastructure**" and "**ML infrastructure**" beat "**ML platform**" ~5:1 in this corpus. Prefer them in the headline.

---

## 10. What NOT to Write

| Anti-pattern | Why | Instead |
|---|---|---|
| `custom CUDA kernels`, `kernel authoring`, `kernel development` | 46% of companies ask — first interview question kills it | `CUDA` (runtime/EP level); "Inductor-generated Triton kernels via `torch.compile`" |
| `speculative decoding` | Inapplicable to non-autoregressive models; instant tell | Omit |
| Invented `p99`/`TTFT` numbers | Trivially probed; he has no serving-latency data | throughput, rows/s, GPU count, asset count, utilization |
| Bare `Triton` in Skills | Reads as the kernel DSL (57 vs 6 postings) | `Triton Inference Server` if the server is meant; else omit |
| `VLLM` (all caps) | 0 body occurrences; looks unfamiliar | `vLLM` |
| `K8s` instead of `Kubernetes` | 3/259 postings | `Kubernetes` |
| `Golang` | 5× rarer than `Go` | `Go` |
| `AWQ`, `GPTQ`, `SmoothQuant`, `GGUF`, `llama.cpp`, `KServe`, `Seldon`, `BentoML`, `ZeRO`, `3D parallelism`, `TensorFlow Serving` | ≤1 posting each — **zero ATS value, nonzero credibility cost** | Omit |
| `tensor parallel` (short form) | `tensor parallelism` substring-matches both | `tensor parallelism` |
| Long Spark/Airflow/EMR detail | 8% / 4% normDF — cheap keywords, expensive lines | One compressed clause |
| `MLOps` as the headline term | 5% normDF | `AI infrastructure` / `ML infrastructure` |
| `low-latency` on batch pipelines | Provably wrong for batch enrichment | `high-throughput`; reserve `low-latency` for the Rust API/control-plane work |

---

## 11. The `torch.compile` Bridge — Verified, and It Pays for Three Keywords

**This is the single highest-value honesty finding in the research.**

The candidate shipped `torch.compile(mode="max-autotune")` in production (`glimmer/modules/dp/content_type_classifier/module.py:76-77`). Official PyTorch documentation states, verbatim:

> *"`max-autotune` is a mode that leverages Triton or template based matrix multiplications on supported devices and Triton based convolutions on GPU. **It enables CUDA graphs by default on GPU.**"*
> *"`max-autotune-no-cudagraphs` is a mode similar to `max-autotune` but without CUDA graphs."*
> — <https://docs.pytorch.org/docs/2.13/generated/torch.compile.html> (HIGH confidence, official docs, verified 2026-08-21)

Therefore his production GPU inference path **did** run with CUDA graph capture and **did** execute Inductor-generated **Triton** kernels, with Inductor's pointwise/epilogue **fusion**.

| JD keyword | Honest claim it licenses |
|---|---|
| `CUDA graphs` / "CUDA graph optimizations" (in the target JD) | "shipped `torch.compile(mode="max-autotune")`, which enables CUDA graph capture by default on GPU" |
| `Triton` | "compiled inference through Inductor's Triton codegen" — **not** "wrote Triton kernels" |
| `kernel fusion` / `graph optimization` / `graph compilation` | "compiler-driven operator fusion and graph capture" |
| `PyTorch-based compilation (torch.compile)` (target JD, verbatim) | Direct, unqualified match |

**Guardrails — he must be able to say all of this:**
1. It applies to the **GPU + Inductor** path. State the mode string exactly.
2. CUDA graphs can **silently fall back** (input mutation, dynamic shapes, graph breaks). The credible answer to "did you verify capture?" is either "yes, via `TORCH_LOGS=perf_hints`" or an honest "I inherited the default and didn't verify capture — here's how I'd check." **He should verify against his own config before interviews**, since `max-autotune-no-cudagraphs` or a `triton.cudagraphs=False` option would invalidate the claim.
3. **Never** upgrade this into "implemented CUDA graph capture" or "hand-wrote Triton kernels." The claim is *compiler-mediated*, and saying so is what makes it credible.

---

## 12. Recommended Skills-Section Composition

Grouping maximizes Tier-1 coverage per character while keeping every entry defensible. **Items marked ⚠ require user approval / a spike first.**

| Group | Contents |
|---|---|
| **Languages** | Python, Rust, SQL, Bash ⚠+ C++, Go *(only if genuine — §8)* |
| **ML / Inference** | PyTorch, PyTorch Lightning, `torch.compile` (max-autotune), ONNX Runtime (CUDA EP), CUDA, Triton (via Inductor codegen), mixed precision (TF32), FSDP/FSDP2, DDP, context parallelism, Ray Data, Hugging Face, OpenCLIP ⚠+ vLLM ⚠+ SGLang ⚠+ TensorRT-LLM (TRT-LLM) |
| **Inference / Serving concepts** | distributed inference, model serving, batching strategies, GPU scheduling & utilization, admission control, checkpoint caching, benchmarking & throughput tuning ⚠+ tensor parallelism, pipeline parallelism, Mixture of Experts (MoE), KV cache, continuous batching *(concept-vocabulary grouping, user-approved only)* |
| **Infrastructure** | Kubernetes, Docker, KEDA autoscaling, Terraform, AWS (S3, SQS, EMR, DynamoDB, Aurora, IRSA), Ray, Slurm-class schedulers (Pluto/Run:ai), NVIDIA A100/H100, NCCL |
| **Reliability / Observability** | fault-tolerant distributed systems, idempotency, circuit breakers, DLQs, lease/TTL heartbeats, graceful degradation, Prometheus, Grafana, OpenTelemetry, Loki, Tempo, CI/CD |
| **Data / Platform** | Spark, Iceberg, Parquet, DuckDB, Airflow, feature store / Feature Registry, data lineage & governance |

Coverage check against Tier 1: this composition lands **every Tier-1 keyword except** `C++`, `Go`, `SGLang`, `TensorRT-LLM` (all gated on §8 decisions) and `p99`/`TTFT` (correctly refused).

---

## 13. Sources

All URLs verified live on 2026-08-21 via the companies' public ATS APIs. **24 companies, 428 postings**; the 40 most load-bearing are listed.

| Company | Role | URL |
|---|---|---|
| **Together AI** | LLM Inference Frameworks and Optimization Engineer *(= the target JD)* | https://job-boards.greenhouse.io/togetherai/jobs/4687884007 |
| Together AI | Staff Software Engineer, Inference / Compute Infrastructure Engineering | https://job-boards.greenhouse.io/togetherai/jobs/5214645007 |
| **Anthropic** | Staff Software Engineer, Inference | https://job-boards.greenhouse.io/anthropic/jobs/5150472008 |
| Anthropic | Staff+ Software Engineer, Inference Runtime | https://job-boards.greenhouse.io/anthropic/jobs/5257650008 |
| Anthropic | Staff + Sr. Software Engineer, Cloud Inference | https://job-boards.greenhouse.io/anthropic/jobs/5231496008 |
| Anthropic | Performance Engineer, Inference Systems | https://job-boards.greenhouse.io/anthropic/jobs/5224564008 |
| Anthropic | Performance Engineer, GPU | (Greenhouse board `anthropic`, GPU/ML-Accelerator family) |
| **OpenAI** | Software Engineer, Model Inference | https://jobs.ashbyhq.com/openai/83b6755d-7785-4186-9050-5ef3ad127941 |
| OpenAI | Software Engineer, Inference – Performance Optimization | https://jobs.ashbyhq.com/openai/85fceac9-fb8a-4d71-a524-a8e5f1e9b01b |
| **NVIDIA** | Senior Performance Engineer – LLM Inference Frameworks | https://nvidia.wd5.myworkdayjobs.com/NVIDIAExternalCareerSite/job/Israel-Yokneam/Senior-Performance-Engineer---LLM-Inference-Frameworks_JR2016624 |
| NVIDIA | Senior Software Engineer, AI Inference | https://nvidia.wd5.myworkdayjobs.com/NVIDIAExternalCareerSite/job/Canada-Toronto/Senior-Software-Engineer--AI-Inference_JR2016014 |
| NVIDIA | Senior Software Engineer, Quantized Inference | https://nvidia.wd5.myworkdayjobs.com/NVIDIAExternalCareerSite/job/US-WA-Redmond/Senior-Software-Engineer--Quantized-Inference_JR2021844 |
| NVIDIA | Senior System Software Engineer, Agentic Inference – Dynamo | https://nvidia.wd5.myworkdayjobs.com/NVIDIAExternalCareerSite/job/US-CA-Santa-Clara/Senior-System-Software-Engineer--Agentic-Inference---Dynamo_JR2021665-1 |
| NVIDIA | AI Computing Development Engineer, TensorRT and TensorRT-LLM | https://nvidia.wd5.myworkdayjobs.com/NVIDIAExternalCareerSite/job/China-Shanghai/AI-Computing-Development-Engineer--TensorRT-and-TensorRT-LLM-AIGV_JR2018990 |
| NVIDIA | Inference Performance Engineer, Agent Driven Inference Optimization | (Workday `NVIDIAExternalCareerSite`, JR2021689) |
| NVIDIA | DL Performance Software Engineer – LLM Inference; Senior DL Algorithms Engineer – Inference Performance; Engineering Manager, Inference Benchmarking | (Workday `NVIDIAExternalCareerSite`) |
| **Databricks** | Staff Software Engineer – GenAI inference | https://databricks.com/company/careers/open-positions/job?gh_jid=8202698002 |
| Databricks | Staff Software Engineer, Model Serving | https://databricks.com/company/careers/open-positions/job?gh_jid=8211647002 |
| Databricks | Staff Software Engineer, Foundational Model Serving | https://databricks.com/company/careers/open-positions/job?gh_jid=8224683002 |
| **Adobe** | Staff Applied Scientist – VLLM Inference | https://adobe.wd5.myworkdayjobs.com/external_experienced/job/San-Jose/Staff-Applied-Scientist_R170044 |
| **Adobe** | Senior MLE, AI Platform *("As a Staff Machine Learning Platform Engineer…")* | https://adobe.wd5.myworkdayjobs.com/external_experienced/job/San-Jose/Senior-Machine-Learning-Engineer_R166678 |
| **CoreWeave** | Staff Software Engineer, Inference | https://coreweave.com/careers/job?4670593006&board=coreweave&gh_jid=4670593006 |
| CoreWeave | Senior Software Engineer – GPU Kernel Authoring & Optimization | https://coreweave.com/careers/job?4697100006&board=coreweave&gh_jid=4697100006 |
| CoreWeave | Senior Software Engineer I, Inference · Senior SWE, Inference · Applied AI Engineer, Inference · GPU Fabric Observability | (Greenhouse board `coreweave`) |
| **Cerebras** | Staff Software Engineer, GPU Inference | https://jobs.ashbyhq.com/cerebras/b418fbca-9a33-4ac5-adb3-24dd57b1c678 |
| Cerebras | Sr. Staff Software Engineer, Inference Platform | https://jobs.ashbyhq.com/cerebras/ef15b7be-2fa3-4343-81aa-47ef65171af0 |
| Cerebras | Senior Performance Engineer, Inference | https://jobs.ashbyhq.com/cerebras/50e42a6b-89b3-49e9-b907-624447e40d82 |
| Cerebras | Staff Python/PyTorch Developer – Frontend Inference Compiler · Principal SRE – AI Inference | (Ashby board `cerebras`) |
| **Baseten** | Software Engineer – Model Performance | https://jobs.ashbyhq.com/baseten/d29e748c-7209-460d-a024-8f77ae0a3d4d |
| Baseten | Software Engineer – Model Performance Systems | https://jobs.ashbyhq.com/baseten/75d7beac-0298-40fa-b206-2e0c0c08a64f |
| Baseten | Software Engineer – Baseten Inference Stack | https://jobs.ashbyhq.com/baseten/c8701794-bdc1-4932-bffa-a444ce57ed73 |
| Baseten | Software Engineer – GPU Networking & Distributed Systems | https://jobs.ashbyhq.com/baseten/1f7d7fda-5540-4205-890b-cdbf774f0814 |
| **Perplexity** | Member of Technical Staff (AI Inference Engineer) | https://jobs.ashbyhq.com/perplexity/8a976851-9bef-4b07-8d36-567fa9540aef |
| **Fireworks AI** | Software Engineer, LLM Infrastructure | https://jobs.ashbyhq.com/fireworks/82013447-2713-46ca-aab1-b0a34f7b565a |
| **Modal** | Member of Technical Staff – Research, Inference | https://jobs.ashbyhq.com/modal/73c97bbc-8e27-4c5d-b38b-90b3afdb0d93 |
| **xAI** | Software Engineer – Training/Inference (C++) | https://job-boards.greenhouse.io/xai/jobs/4533894007 |
| xAI | Member of Technical Staff – RL Inference | https://job-boards.greenhouse.io/xai/jobs/5180223007 |
| **Scale AI** | AI Infrastructure Engineer, Model Serving Platform | https://job-boards.greenhouse.io/scaleai/jobs/4520320005 |
| **Nebius** | Senior MLE, LLM Inference Optimization | https://careers.nebius.com/?gh_jid=4921522101 |
| Nebius | ML Infrastructure Engineer | https://careers.nebius.com/?gh_jid=4864833101 |
| **Cohere** | Staff Software Engineer, Inference Infrastructure | https://jobs.ashbyhq.com/cohere/41f23dad-9da2-451a-bd1e-a1800437cb64 |
| Cohere | Audio Inference Engineer, Model Efficiency | https://jobs.ashbyhq.com/cohere/e912d84c-8399-422d-8a7d-918422a3e4b1 |
| **Anyscale** | Distributed LLM Inference Engineer | https://jobs.ashbyhq.com/anyscale/1cf38233-8aa0-47f8-9d85-65ce27bc3047 |
| **Waymo** | Senior Software Engineer, Bulk/Interactive Inference | https://careers.withwaymo.com/jobs?gh_jid=7466529 |
| Waymo | Senior Staff MLE, LLM/VLM Model Architecture & Optimization | https://careers.withwaymo.com/jobs?gh_jid=8022298 |
| **Amazon / AWS** | Senior Inference Engineer, AGI | https://www.amazon.jobs/en/jobs/10503632/senior-inference-engineer-agi |
| Amazon / AWS | Sr. MLE, Prime Video ML Platform | https://www.amazon.jobs/en/jobs/10477319/sr-mle-prime-video-ml-platform |
| **Reddit** | Staff Machine Learning Engineer, ML Efficiency | https://job-boards.greenhouse.io/reddit/jobs/8018527 |
| Reddit | Senior Staff MLE, GenAI Platform | https://job-boards.greenhouse.io/reddit/jobs/7772274 |
| Reddit | Senior ML Infrastructure Engineer, Embedding Platform | https://job-boards.greenhouse.io/reddit/jobs/8127022 |
| **SambaNova** | Inference Systems Performance Architect | https://sambanova.ai/sambanova-available-positions/?gh_jid=6144835004 |
| **Pinterest** | Director of Engineering, Core & Ads Serving Platform | https://www.pinterestcareers.com/jobs/?gh_jid=8035163 |
| **Tenstorrent** | Sr. Engineer, Kernel Development and Optimization | https://job-boards.greenhouse.io/tenstorrent/jobs/5053384007 |
| **Deepgram** | Backend Engineer – Inference Services | (Ashby board `deepgram`) |
| **Netflix** | Inference Specialist, Creative Technology (ML-platform postings sparse at harvest time) | https://explore.jobs.netflix.net |

**Technical reference (not a posting):** PyTorch `torch.compile` mode semantics — <https://docs.pytorch.org/docs/2.13/generated/torch.compile.html> (used in §11).

**Companies attempted but not harvestable:** Meta (metacareers GraphQL, JS-gated), Google/DeepMind (Greenhouse board `deepmind` returned 10 non-inference postings; Google's careers API endpoint changed), ByteDance/Seed (API returned empty), Apple (endpoint moved), Uber (RPC handler removed), LinkedIn (no public API). Their absence does not change tier assignments — the 24 harvested companies span frontier labs, hyperscalers, GPU clouds, inference startups, chip vendors, and consumer-scale ML platforms.

---

## 14. Confidence Assessment

| Area | Confidence | Basis / caveat |
|---|---|---|
| Keyword frequencies (normDF, co%) | **HIGH** | Machine-counted over 259 primary-source postings, 94% updated in 2026. Company-normalized to prevent NVIDIA skew. |
| Exact-match forms (casing, hyphenation) | **HIGH** | Case-sensitive literal counts over the full corpus text. |
| Tier boundaries | **MEDIUM** | Thresholds (19% / 8% normDF) are a judgment call. Terms near a boundary (`quantization` 19%, `continuous batching` 9%) could reasonably shift one tier. Both numbers are shown so the resume-rewrite phase can re-tier. |
| LLM-subcorpus percentages for † terms | **MEDIUM-LOW** | Selection-biased upward by construction. Always defer to normDF/co% for those rows. |
| Evidence → keyword mapping | **HIGH** | Every row anchored to a specific commit/PR/file in `CODEBASE-EVIDENCE.md`. |
| `torch.compile` → CUDA graphs / Triton bridge | **HIGH** | Verbatim from official PyTorch docs; caveats stated in §11. |
| No-evidence flags | **HIGH** | Cross-checked against the binding honest-framing rules in `CODEBASE-EVIDENCE.md` §"Honest-framing rules". |
| C++ / Go availability | **UNKNOWN — user input required** | Zero evidence in the seven mined Adobe repos. Together these are 36% + 29% normDF / 71% co% each — the largest recoverable gap in the corpus. |
| Coverage of Meta / Google / ByteDance vocabulary | **MEDIUM** | Not harvested (§13). Their inference vocabulary is widely reported to overlap heavily with NVIDIA/OpenAI/Anthropic, all of which *are* in-corpus, so tier risk is low. |

### Open questions for the requirements phase

1. **Does he have production C++ and/or Go** (NetSpeed era or elsewhere)? Highest-value unknown in this document.
2. **Will he do the two cheap spikes** — (a) hands-on SGLang/vLLM serve-and-benchmark, (b) one TensorRT-LLM conversion of his own ONNX model? Each converts a Tier-1 fabrication risk into a fact. (b) also unlocks `TensorRT`.
3. **Will he land one upstream OSS PR** to vLLM or SGLang? Single highest-ROI action outside the resume (§8).
4. **Does his production `torch.compile` config leave CUDA graphs enabled** (i.e. not `max-autotune-no-cudagraphs`, not `triton.cudagraphs=False`)? Determines whether §11's `CUDA graphs` claim is fully safe.
5. **Approve or reject the "concept vocabulary" Skills grouping** for `tensor parallelism` / `pipeline parallelism` / `MoE` / `KV cache` / `continuous batching`? It is the only way those target-JD terms reach the page, and it carries interview obligations.
6. **Any defensible cost or GPU-hour savings number?** `cost efficiency / cost per token / TCO` is 18% normDF across 18 of 24 companies and he currently has no figure for it.

---
*Keyword corpus research for: Staff MLE / inference-framework / LLM-serving / ML-platform ATS optimization*
*Researched: 2026-08-21 · 428 postings · 24 companies · 94% updated in 2026*
