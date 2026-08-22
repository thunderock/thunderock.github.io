# Feature Research — Staff MLE Resume Content Patterns

**Domain:** Staff / Senior-Staff MLE resumes, inference & ML-platform specialization (2-page IC resume, ~10 YoE, research background)
**Researched:** 2026-08-21
**Confidence:** HIGH on bullet formulas, section structure, page budget, anti-features. MEDIUM on inference-specific quantification norms (derived from general principles + one ML-infra hiring-manager exemplar; no source enumerates "good numbers for inference work"). MEDIUM on the summary-section verdict (sources genuinely disagree; see §5).

**Grounding:** every example bullet in §1 is rewritten from `.planning/research/CODEBASE-EVIDENCE.md`. No bullet introduces a technology absent from that file. Two numbers currently on the resume have **no evidence backing** and are flagged in §4.4 as blocking questions.

---

## 0. The five rules everything else follows from

| # | Rule | Source |
|---|------|--------|
| 1 | **Achievements, not work statements.** "Led the design and analysis of X" → "Designed X, reducing charge times by 23%" → "…generating $123M in sales annually". Each rung up the ladder is strictly better. | [r/ER-samples] |
| 2 | **Demonstrated expertise beats keywords.** A skills-box entry proves nothing; the same technology inside a bullet with scale and outcome proves everything. | [Huyen] |
| 3 | **Metrics need a denominator and an owner.** A number without task/baseline/hardware, or without your contribution scoped, reads as padding — sometimes worse than no number. | [Huyen] |
| 4 | **Impact *and* influence.** At 10+ YoE the resume must show not just what you shipped but what changed because of you across the org. | [r/ER] |
| 5 | **Every claim survives an interview.** The canonical failure: a candidate wrote "deployed an online prediction model that served 10M DAU"; in interview it emerged he wrangled data from an S3 bucket. "This interview was a waste of time for both of us." | [Huyen] |

Rule 5 is the research-side confirmation of this milestone's honesty constraint. It is not a nice-to-have; it is the mechanism by which keyword-stuffed resumes lose offers at the stage that matters.

---

## 1. Bullet formulas that work at staff level

### 1.1 The three canonical frames

All three are endorsed by the r/EngineeringResumes wiki; pick per bullet, don't mix inside a bullet.

- **XYZ (Google):** "Accomplished **[X]** as measured by **[Y]**, by doing **[Z]**." [r/ER, citing Google recruiters]
- **STAR:** Situation, Task, Action, Results — compresses to one bullet: action + context + quantified outcome. [Levels]
- **CAR:** Challenge, Action, Result — best frame for incident/outage and reliability bullets.

Mechanics the wiki is explicit about, all of which apply here:
- Start with a **strong past-tense action verb**. Good: analyzed, architected, automated, built, created, decreased, **designed**, developed, implemented, improved, optimized, published, reduced, refactored. Banned as superfluous: spearheaded, orchestrated, pioneered, engineered, enhanced, leveraged, utilized, headed. ("**Led** is the past tense of **lead**.") [r/ER]
- **1–2 lines per bullet, aim for one sentence.** Order most-impressive-first — some readers only read the first.
- **If you can quantify, move the metric toward the front of the bullet.** [r/ER]
- No personal pronouns. No trailing periods. No bolding inside bullets. Digits, not spelled-out numbers.
- **Avoid excess sub-bullets** — "they clutter your resume, making it more verbose and harder to read."

### 1.2 The ML-platform variant

The single best exemplar of a platform bullet comes from an ML-infra hiring manager comparing two candidates who both listed Flink:

> - Candidate A has Flink as one of the 30 items on their Technical skills box.
> - Candidate B explained how they used Flink in their last job: "*worked on a feature computation platform built on top of Apache Flink which processes 100,000 events per second and serves 10 different ML models*."
>
> If during our interview, candidate B can tell me why they chose Flink over other stream processing engines, what issues they've encountered, and what changes they wish to see in Flink, I'd be sold! — [Huyen]

Extract the shape: **`<system built> + <on which technology> + <throughput with unit> + <breadth of consumers>`**. Note there is no percentage and no dollar figure — for platform work, **throughput + consumer count is the impact**. That is the template for this candidate's strongest material.

### 1.3 Staff-level bullet anatomy

```
[led/designed verb] the [system, named as a platform not a task]
  + [scale: GPUs × type, rows, models, queues]
  + [named technology you can defend live]
  + [outcome: what became true that wasn't before]
  + [breadth: how many pipelines/teams/models depend on it]
```
The last two slots are what separate staff from senior. A senior bullet stops at "built it and it works." A staff bullet states the invariant it established or the class of failure it closed, and how far that reaches.

### 1.4 Eleven bullets rewritten from this candidate's real evidence

Every bullet below is traceable to `CODEBASE-EVIDENCE.md`. "Ev:" gives the anchor.

**Flagship — GPU batch inference**

> **B1.** Designed and built the org's GPU batch-inference plugin (5.9K lines) running 3 production image models as SQS-fed batched pipelines on A100-80GB and H100 Kubernetes fleets, moving CUDA execution off the asyncio event loop so queue consumption never stalls behind GPU work
>
> *Ev: orion §A (#307/#357/#447, +5.9k lines; AIDE / HydraNet / ResNet50; `p4de.24xlarge` A100-80GB default, `p5.48xlarge` H100 supported; `asyncio.to_thread` offload, commit `1404e2c77`).* Why it works: three technologies he can debug live, a fleet-type reader recognizes, and a concurrency outcome that invites the exact interview question he wants.

> **B2.** Introduced `torch.compile(mode="max-autotune")` into the org's production inference modules, compiling both the CLIP ViT-B/32 encoder and the classification head of the content-type classifier that scores 11 feature-store partitions per daily run
>
> *Ev: genie §A (#1611/#1619; `content_type_classifier/module.py:76-77`; 11 daily partitions/run).* Why it works: "introduced" is an adoption verb — it says the technique wasn't there before him. This is the highest-value keyword on the resume that is also 100% defensible.

> **B3.** Ported the AIDE generative-image detector into the inference framework (1.1K lines — 30 SRM high-pass filter banks, DCT patch decomposition, dual ResNet-50 branches, frozen OpenCLIP ConvNeXt-XXL, MLP fusion head), then raised throughput by moving batch size 64→128 and loader threads 2→4; benchmarked at 1.09M rows per run on 8×A100
>
> *Ev: genie §A (#2060 +1,091 ln; TF32 matmul; tuning commit `350288acb`; Ray-engine benchmark 1×p4d.24xlarge / 16 fractional-GPU actors / 1,087,682 rows).* Why it works: the before→after tuning numbers (64→128, 2→4) are the most credible kind of optimization claim — small, specific, reproducible.

> **B4.** Built the ONNX Runtime CUDA-execution-provider embedding generator behind duplicate detection for the content catalog, and onboarded 4 production models onto the batch-inference framework across image classification, embeddings, and generative-content detection
>
> *Ev: genie §A (#2035/#2037 +555 ln ONNX Runtime CUDAExecutionProvider; 4 models: CTC, vector-asset classifier, CAI embeddings, AIDE).*

**Fleet operation & scale**

> **B5.** Operated the Firefly data-release enrichment fleet across 9 production model queues, each running 24×A100-40GB over 3 multi-node jobs, owning the config and launch path for every module in the release cut
>
> *Ev: genie §B (9 modules incl. aesthetics, CTC, ConvNeXt+ResNet50 GenAI detection, HydraNet, language classifier, people detection, text presence; `--num-nodes 3 --num-gpus 8 --accelerator-type NVIDIA_A100_40GB`).*

> **B6.** Made the 64×H100 daily enrichment wave (8 feature modules × 8 GPUs) survive preemption by treating queue drain rather than noisy job state as the authoritative success signal, adding idempotent re-runs and stale-queue reclamation, and capping concurrent GPU modules at 6
>
> *Ev: asml-img-data-dags (8 modules × 8×H100-80GB = 64 H100s; Glimmer-queue drain authoritative; `skip_existed=true`; stale-queue drop-before-create; Airflow pool cap 6).* Why it works: this is the JD's "fault-tolerant high-concurrency" requirement answered with mechanism, not adjectives.

**Correctness judgment — the strongest staff signal in the evidence**

> **B7.** Migrated a 202.6M-row image catalog onto the platform's dataset service using resumable, deterministically sharded Kubernetes Indexed Jobs so re-runs converge instead of duplicating — post-send timeouts are terminal and reconciled by the next run's probe rather than blind-resent
>
> *Ev: orion §C (branch `ashutosh/image-dataset-migration`, 27 commits; stable-hash sharding; `unknown_timeout` reconciliation; asymmetric retry + circuit breaker; atomic report persistence via tmp+`os.replace`; DuckDB streaming scan; prod 200k/shard × 4 shards).* Why it works: "re-runs converge instead of duplicating" is a distributed-systems correctness invariant. Senior engineers add retries; staff engineers reason about what a retry means at 200M rows.

**Incident leadership without a manager title**

> **B8.** Root-caused a 6-week silent outage in the daily enrichment pipeline — dependency rot breaking framework installs with no failure signal — then closed the class of failure with install/import smoke tests in CI and SHA-pinned framework builds
>
> *Ev: asml-img-data-dags (package rot broke `genie[glimmer]` venv installs; added install/import smoke-test CI "that would have caught it"; SHA-pinned genie builds).* Why it works: fixing the bug is senior; adding the gate that makes the bug unrepeatable is staff. The "6-week silent" framing quantifies severity without a fabricated dollar figure.

> **B9.** Eliminated a thousands-of-calls-per-second `AssumeRole` storm in the shared feature-registry library by adding a negative session cache with a 60s cooldown and a single half-open retry across all 9 credential getters, proven by an 8-thread thundering-herd regression test
>
> *Ev: ff-data-engineering (`46665c4`, +457 ln; failed AssumeRole never populated caches → STS throttling; circuit-breaker semantics; env-tunable duration; thundering-herd collapse test).* Why it works: shared-library blast radius = cross-team impact, stated without claiming authority over other teams.

**Platform authorship & org-wide adoption**

> **B10.** Built the training-data governance subsystem in Rust — 27K lines with a 9.7K-line integration suite — covering checkpoint lineage events, canonical sample identity, idempotent claim/receipt registration, and manifest-after-data publication, published as a frozen cross-runtime contract with an automated contract checker
>
> *Ev: orion §B (`531905c1f` #1706, +27,135 lines solely his; `fingerprint.rs` 520, `sample_index.rs` 1,387, `validation.rs` 3,025; 6 SQL migrations; 422-ln frozen contract doc; 9,722-ln integration test; 1,710-ln contract checker).* Why it works: authoring the contract other runtimes conform to *is* setting technical direction — the core StaffEng definition [StaffEng-what].

> **B11.** Built the data platform's first output-validation framework for model pipelines and drove it into ~20 production feature pipelines with per-pipeline threshold gating, and led the architecture migration of the inference path onto a pluggable executor with per-record/per-batch and GPU/CPU routing
>
> *Ev: colligo §A (`AssetValidationRunner` wired into ~20 model pipelines, `fdfc2b1b8d3`/`fd8becce47b`; "Led 'Simplica-free' architecture migration", `FeatureComputeUnit2ABC` w/ pluggable `pipeline_executor`, migrated Depth + LAION-aesthetics).* Why it works: **~20 pipelines is the single best adoption number on the resume.** Adoption counts are the IC substitute for headcount (§2.3).

### 1.5 Before → after on the candidate's current bullets

| Current | Diagnosis | Rewrite |
|---|---|---|
| "Leading parts of the org's MLOps platform for building, deploying, and monitoring GPU-accelerated data pipelines and model inference on Kubernetes, spanning the full ML lifecycle from data ingestion to inference." | Job-description voice, not achievement voice [r/ER: "your resume is not your job description"]. "Leading **parts of**" hedges away the very claim it's making. Zero scale, zero outcome. 3 lines spent on nothing verifiable. | Delete as an opener. Replace the role-level framing with B1 as the lead bullet — a concrete system with fleet types — and let the summary (§5) carry the scope statement. |
| "Built offline inference on Ray Data + PyTorch Lightning, achieving 10–50× faster image loading and 3–8K images/sec on 32 GPUs." | **Numbers have no provenance in CODEBASE-EVIDENCE.md.** The only Ray benchmark in evidence is 8×A100 / 1.09M rows / 109 rows/s on *his AIDE module*, benchmarked by a colleague. "32 GPUs" and "10–50×" appear nowhere. Unanchored ranges are the highest interview risk on the resume. | Either supply provenance, or replace with B3's evidenced benchmark. **Blocking question — see §4.4.** |
| "Designed and led engineering for the org's online and offline inference systems powering experimentation and production at scale." | "the org's … systems" claims the whole surface. Evidence shows vLLM plugins and the H100 throughput ladder were **others' work** (explicitly flagged "platform context — others"). Fails Rule 5. | Narrow the object to what is his: "Designed and led the batch-inference path of the org's ML platform…" Use "the platform runs vLLM…" framing for others' work, per the evidence file's own rule. |
| "Wrote the org's first data quality framework on Cerberus, used across enrichment pipelines to validate the correctness of feature-generation outputs." | Weaker than the truth. "used across enrichment pipelines" hides the adoption count that makes it impressive. | B11 — name the ~20 pipelines and the threshold gating. |
| "Implemented routing/dispatch on an Akka-style actor framework … at sustained low P99 under high QPS." (Swiggy) | "low P99" and "high QPS" are adjectives wearing metric costumes. No baseline, no number. | Keep the actor-framework mechanism (it is distinctive); drop the unquantified P99/QPS claim or attach the real numbers. The adjacent Feature Store bullet already has real numbers (4Bn rows, 10K QPS) — lean on those. |

---

## 2. Staff-level vs senior-level signals

### 2.1 The distinction table

Derived from StaffEng's definition of the role — "setting and editing technical direction, providing sponsorship and mentorship, injecting engineering context into organizational decisions, exploration, and … being glue" [StaffEng-what] — crossed with the promotion-packet questions [StaffEng-promo].

| Dimension | Reads as **senior** | Reads as **staff** | This candidate's evidence |
|---|---|---|---|
| **Object of the sentence** | a service, a job, a model | a platform others build on | Rust contract subsystem (B10); pluggable executor (B11) |
| **Verb** | Built, Implemented | **Designed and led**, **Introduced … across**, **Drove … into** | "Led" the Simplica-free migration; "introduced" torch.compile |
| **Breadth** | "in production" | "adopted by N pipelines / N model queues / N runtimes" | ~20 pipelines; 9 model queues; 4 models onboarded |
| **Problem definition** | implemented a defined spec | scoped an undefined problem | 6-week *silent* outage root-cause (B8) |
| **Failure handling** | fixed the bug | closed the **class** of bug | smoke-test CI + SHA pins (B8); negative cache + half-open retry (B9) |
| **Standards** | followed them | **wrote** them | 422-line frozen cross-runtime contract; 425-line ARCHITECTURE.md + 364-line runbook |
| **Blast radius** | one repo | cross-repo / cross-runtime / shared library | FCU0 export in one repo feeds his own DAGs in another; shared FR library STS fix |
| **Correctness reasoning** | happy path + retries | invariants under partial failure | converging re-runs, terminal timeouts (B7); lease/TTL heartbeats; DLQs |
| **Force multiplication** | shipped code | others ship faster because of an artifact you made | one-command Airflow-node provisioning (100% his); runbooks; integration test harness |

### 2.2 Staff behaviors → resume-able evidence

StaffEng names five staff activities. Four of them have real evidence here; one does not. Do not fake the fifth.

| Staff behavior [StaffEng-what] | Resume-able? | Evidence to use |
|---|---|---|
| **Setting technical direction** | ✅ Strong | Frozen cross-runtime contract; pluggable executor migration; introducing torch.compile as a practice |
| **Exploration** (ambiguous, important, poorly-scoped problems) | ✅ Strong | 6-week silent outage; STS storm root cause; `greenlet_spawn` async-SQLAlchemy root cause |
| **Being glue** (invisible work that ships the project) | ⚠️ Frame carefully | Deployment tooling, launch templates, release-cut operation. **Must carry a technical outcome or it reads as "not technical enough"** [Reilly] |
| **Providing engineering perspective** in org decisions | ⚠️ Thin | Contract doc + capacity API imply it; no direct evidence of decision forums |
| **Mentorship and sponsorship** | ❌ **No evidence** | TA rows are the only proxy. **Do not invent a mentoring bullet.** If real mentoring exists off-commit, ask the user; one honest clause is worth more than the whole Teaching section |

### 2.3 Phrasing leadership without a manager title

Six techniques, each backed:

1. **Adoption counts replace headcount.** You cannot write "led a team of 6," but "drove it into ~20 production pipelines" carries the same weight and is verifiable. The promo-packet question is literally "What is the quantifiable impact of your projects?" — not "how many reports did you have?" [StaffEng-promo]
2. **Use `led`/`designed`/`drove`, never the inflated synonyms.** r/ER bans spearheaded, orchestrated, pioneered, headed as "superfluous/awkward." "Led the architecture migration" is both stronger and shorter than "spearheaded."
3. **Cite artifacts as leadership proof.** Tanya Reilly's prescription for glue workers is exactly this: "she needs artifacts of her work that show her impact and tell the story… design proposals, meeting notes… crucial points where she made the thing happen," and credit should be given "not for **helping**, but for **leading**" [Reilly]. The resume-able artifacts here are the 422-line frozen contract, the 425-line ARCHITECTURE.md, the 364-line runbook, the 1,710-line contract checker, the one-command provisioning script. Naming an artifact converts invisible influence into a checkable claim.
4. **Never write coordination without an outcome.** "Coordinated across teams" is the phrase that gets a candidate told they're "not technical enough" [Reilly]. Compare: *"Decoupled the hydration worker from the control-plane database (−193 lines of coupling) so the two services deploy independently"* — same glue work, stated as an engineering result. (*Ev: colligo `f85a7bff644`.*)
5. **Own the end-to-end seam explicitly.** The strongest untold story in the evidence: the FCU0 daily export he owns in `ff-data-ingestion` is the input to the enrichment DAGs he owns in `asml-img-data-dags`. One clause — "owning the daily export end-to-end into the enrichment wave it feeds" — signals platform thinking that is essentially impossible to fabricate.
6. **State the invariant, not the effort.** "Made re-runs converge" > "worked hard on reliability."

### 2.4 The promo-packet as a bullet checklist

Run the Adobe section against these seven questions [StaffEng-promo]. Any question with no answer is a gap the resume should either fill or deliberately concede:

1. What were your staff projects, what did you do, what was the impact, what made them complex? → B1, B7, B10
2. What are the high-leverage ways you've improved the organization? → B8, B9, B11
3. What is the quantifiable impact? → §4
4. Who have you mentored, through what accomplishments? → **gap**
5. What glue work do you do, and what's its impact? → §2.3 item 4
6. Which teams and leaders are advocates for your work? → not resume-surfaceable; belongs in references
7. What skill/behavior gaps might hold you back? → internal use only

Note also that a "staff project" is not universally required — many reach the title through "a track record of success over a longer period without a single capstone," and switching companies is one of the two main routes [StaffEng-projects]. This candidate's resume should therefore present a **coherent multi-year track record in one domain**, not hunt for a single mythic capstone. The domain is: distributed GPU batch inference and the data/fault-tolerance platform underneath it.

---

## 3. Section structure & page budget

### 3.1 Section order

| Source | Prescription for 10+ YoE IC |
|---|---|
| [r/ER] | *Work Experience > Skills > Education*, or *Skills > Work Experience > Education*. "Move your education section to the bottom." |
| [TTR] | "Work Experience at or near the top." "**Have a Languages and Technologies section on the first page.**" Education shrinks with seniority. |
| [Huyen] | "If you've been working, put your work experience first." |

**Recommended order:** Summary (2 lines) → Work Experience (page 1) → **Skills** → Publications → Education → Research → Projects (if any).

⚠️ **One real conflict to resolve:** [TTR] wants Skills on **page 1**; the current layout has it last on page 2, and page 1 is fully consumed by Experience (hard constraint). Options: (a) accept Skills on page 2 — most recruiters will reach it on a 2-pager, and ATS parses either position; (b) fold a compact one-line "Core: distributed GPU inference · PyTorch · CUDA · Kubernetes · Rust" into the summary block on page 1 as a keyword beachhead, keeping the full Skills section on page 2. **(b) is the recommendation** — it satisfies TTR's intent at a cost of one line and front-loads the ATS keywords where a 15-second scan lands [Singh Tip #6].

### 3.2 Table stakes (expected — absence is penalized, presence earns nothing)

| Feature | Why expected | Complexity | Notes |
|---|---|---|---|
| Reverse-chronological Work Experience, first section | Universal | LOW | ✅ already correct |
| Achievement bullets in XYZ/STAR/CAR with numbers | Baseline at every level | **HIGH** | ⚠️ current bullets are largely descriptive; this is the milestone's core work |
| Strong past-tense action verb opening every bullet | [r/ER] | LOW | ⚠️ several bullets open with gerunds ("Leading…") |
| Skills section, single column, comma-separated, categorized | [r/ER], [TTR] | LOW | ⚠️ exists but unordered and over-long |
| Education present, GPA-free, at the bottom | [r/ER], [TTR], [Huyen] all agree at 5+ YoE | LOW | ⚠️ two GPAs currently listed |
| ATS-parsable PDF, standard section names, no columns/graphics | [r/ER-ats] | LOW | ✅ `\pdfgentounicode=1`, single column |
| ≤2 pages | [r/ER]: "1 page per decade… try not to go over 2 pages" | LOW | ✅ exactly 2 |
| Bullets 1–2 lines, no orphan trailing words | [r/ER] | MEDIUM | Check after rewrite |
| Named technologies appearing in **both** bullets and Skills | [r/ER]: "Repeat things that you use in your bullet points" | MEDIUM | ⚠️ Skills lists Scala/Django/Faiss with no bullet support |

### 3.3 Differentiators (this candidate's actual edge — protect these)

| Feature | Value proposition | Complexity | Notes |
|---|---|---|---|
| **Verifiable GPU-fleet scale** (64×H100 wave; 24×A100 × 9 queues; 8×A100 benchmark) | The exact numbers inference-platform hiring managers screen for. Most MLE resumes cannot produce a GPU count at all | LOW (already known) | Highest ROI content on the resume |
| **Rust + Python production systems** (27K-line subsystem) | Rare on MLE resumes; reads as systems credibility for an inference-framework role | LOW | Currently **absent from the resume entirely** — biggest unforced omission |
| **Fault-tolerance mechanism detail** (converging re-runs, circuit breakers, lease/TTL heartbeats, DLQs, idempotency) | Maps 1:1 onto the target JD's "fault-tolerant high-concurrency distributed inference" | MEDIUM | Currently absent |
| **First-author publication** (NetSci 2023 + IC2S2 2023) | Genuinely uncommon on an MLE resume; signals research depth adjacent to model work | LOW | ✅ present — needs compressing, not cutting |
| **Cross-repo end-to-end ownership** (his export feeds his own enrichment DAGs) | Platform thinking that is very hard to fabricate | LOW | Absent; one clause fixes it |
| **Incident leadership with systemic fix** (6-week silent outage → CI gate) | Staff-level judgment signal; also an interview story he controls | LOW | Absent |
| **`torch.compile` max-autotune in production** | The one high-demand optimization keyword that is fully defensible | LOW | ✅ Absent from resume; must be added |
| Populated GitHub + live portfolio | [Huyen], [Singh Tip #28]: links validate real output | LOW | ✅ present |

### 3.4 Anti-features (seem good, actively hurt)

| Anti-feature | Why it's tempting | Why it's problematic | Do instead |
|---|---|---|---|
| **Grad-school course projects at 10 YoE** (BiasNet, DeepFoodie, BlindNet, CDS, Humana, AnalyticsVidhya) | Fills space, shows breadth | Kyle Kranen (NVIDIA senior DL engineer) "discouraged candidates from listing cookie-cutter projects… as they take away space for things that are uniquely your strengths"; [Huyen] sees them in ⅓ of resumes and says course projects belong only "if you think they're better than the average course project"; [r/ER] Projects is for "real projects, not mandatory school projects"; [TTR] "the more work experience you have, the less relevant outside-work projects tend to become" | Cut to 0–2. An 11th-place case-competition rank on a Staff MLE resume actively **undersells**. Reclaims ~10 lines |
| **Publication abstract paragraph** (4 lines of prose) | Shows the research is substantive | A resume is not a paper; prose blocks violate "bullet points, not paragraphs" [r/ER] and consume the space differentiators need | Citation + venue + first-author + link, 2 lines. Link Google Scholar; keep name bolded [Huyen] |
| **GPA at 10 YoE** (3.87 and 8.32/10) | It's a good GPA | All three sources say remove once Education moves to the bottom / past 2–5 YoE. The 8.32/10 additionally forces the reader to do unit conversion | Delete both |
| **Keyword-stuffing Skills / claiming unevidenced JD tech** (TensorRT, CUDA graphs, speculative decoding, MoE/TP/PP) | ATS pressure | "I'm skeptical of people who claim to be experts in too many things"; long skill lists are "unconvincing" and "can weaken your resume" [Huyen]. Recruiters report self-rated experts "would often get rejected based on not having enough depth" [TTR]. And Rule 5 | Hard ceiling: every Skills item must be interview-defensible. Get ATS coverage from the *defensible* keywords in bullets (CUDA, Kubernetes, ONNX Runtime, torch.compile, FSDP, Flash Attention, Rust, Iceberg, Spark) |
| **Team credit as personal credit** ("Designed and led the org's inference systems") | Reads more senior | Fails Rule 5 in the exact documented pattern [Huyen] | Narrow the object; use "the platform runs X" for others' work |
| **Unanchored metrics** ("10–50× faster", "3–8K images/sec", "low P99 under high QPS") | Numbers look rigorous | "not all that are quantifiable are impactful"; a metric without task/baseline "leaves me more confused than impressed" [Huyen] | Attach workload + hardware, or remove. §4.4 |
| **Soft skills in Skills** | Seems well-rounded | [r/ER]: "Demonstrate via your bullet points… not just by listing them out" | Already avoided ✅ |
| **Three-level bullet nesting** | Organizes a dense role | "Avoid the excess use of sub-bullet points" [r/ER] | Cap: only the top 2 topics get sub-bullets |
| **Hedged openers** ("Leading parts of…") | Feels honest | Signals uncertainty about your own scope; costs a line and gains nothing | State the narrower true claim confidently |
| **The commented-out summary** (NLP/Graph ML/"fintech, health, and e-commerce") | It's already written | Positions him for the 2023 job hunt, not this one. Contains "Proven ability to…" and "Committed to leveraging…" — exactly the generic filler [Singh Tip #11] warns about | Do **not** uncomment. Write fresh per §5 |
| **Career-break row in Work Experience** | Explains the gap in place | [r/ER]: "Only include **PAID** work experience in this section" | ✅ already scoped for removal; Education's date range carries it (§3.5) |
| **Long tail of TA rows** (3 entries) | Shows teaching/mentoring | 3 lines for the weakest available mentorship evidence at 10 YoE | Compress to 1 line, or cut if space is needed |

### 3.5 Page-2 verdicts and line budget

Estimates from `docs/main.tex`. Line counts are approximate rendered lines.

| Section | Now | Verdict | Target | Saves | Reasoning |
|---|---|---|---|---|---|
| **Publications** | ~9 (header + accepted-at line + citation + 4-line abstract) | **KEEP, compress hard** | ~4 | **~5** | Earns its space: first-author, two venues, rare on MLE resumes. The abstract does not. [Huyen]: link Scholar, bold your name |
| **Education** | ~5 | **KEEP, strip GPAs** | ~4 | ~1 | ⚠️ **Must retain the 2021–2023 date range**, not just a graduation year — with the career-break row deleted, Education is the only artifact explaining the Swiggy→Adobe gap. This is a deliberate, justified exception to [r/ER]'s "graduation date only" rule |
| **Research / Independent Study** | ~8 (3 multi-line items) | **SHRINK to 1 line** or fold under Education | ~1–2 | **~6** | The IUNI debiasing line backs the publication — keep that one. The paid-RA "User Intent as a Network" and NLP Lab/TieML lines are 4–5 years stale and off-theme for inference roles. [r/ER] permits research inside Work Experience if paid — but that would re-open the gap the milestone is closing, so keep it here, compressed |
| **Teaching** | ~4 | **COMPRESS to 1 line** | ~1 | **~3** | Only mentorship-adjacent evidence available (§2.2) — worth one line, not four. "Teaching Assistant — Network Science (×2), Machine Learning · Indiana University" |
| **Projects** ("Selected Projects", 7 items) | ~22 | **CUT to 0–2** | 0–4 | **~18–22** | The dominant anti-feature (§3.4 row 1). If keeping one, keep *Investigating Bias Manifolds* — it's the only one that reinforces the publication narrative. Also rename to "Projects" [r/ER] |
| **Skills** | ~5 (32 items, one run-on + one list) | **KEEP, restructure** | ~4 | ~1 | Reorder inference-first; drop Django, Matplotlib, Sklearn, Numpy/Pandas, Faiss unless bullet-supported; keep ≤3 lines [r/ER] |
| | | | | **≈ 34–38 lines freed** | |

**What the freed space buys.** Page-2 cuts do *not* directly help page 1 (Experience must still end at the `\newpage`). But ~35 freed lines on page 2 unlock a structural option worth surfacing:

> **Option: move Groupon + NetSpeed to a compact "Earlier Experience" block at the top of page 2** (2–3 lines total). This frees ~8 page-1 lines for the Adobe section — the highest-value real estate on the resume — while keeping the full career history visible. Justified by [TTR]: "For people with 10+ years of experience, your work experience beyond 10 years is less interesting… Shorten these sections, and consider removing or skipping ones that are not relevant."
>
> **Trade-off:** it splits Work Experience across a page boundary, which slightly weakens the "Experience fits page 1" formatting story. Present both variants as rendered PDFs and let the user choose — consistent with the milestone's recommendation-first workflow.

---

## 4. Quantification norms for inference / platform work

**Confidence: MEDIUM.** No source enumerates "the right numbers for inference work." This tiering is derived from the Flink exemplar [Huyen §1.2], the impact ladder [r/ER-samples], and the "metrics tied to business objectives + your contribution" test [Huyen], applied to the evidence file.

### 4.1 Tier 1 — screens well, fully defensible, use these

| Metric type | Why it lands | This candidate's |
|---|---|---|
| **GPU count + type + topology** | Reviewers for inference roles read GPU counts as the proxy for real fleet experience — it cannot be faked by a side project | 64×H100-80GB parallel wave; 24×A100-40GB × 9 queues; 8×A100 with 16 fractional-GPU actors; A100-80GB default / H100 supported |
| **Corpus scale** | Absolute scale of the thing you operate on | 202.6M rows; 24.8M clips / 618 shards; ~700M enriched assets; 206.8M largest single dataset |
| **Steady-state rate** (per month/day) | Implies sustained operation, not a one-off demo — more credible than a peak number | 35–38M images/month; 11 feature-store partitions/daily run; 40-node EMR daily |
| **Throughput *with its hardware*** | The Flink pattern: rate is meaningless without the denominator | "1.09M rows per run on 8×A100" ≫ "109 rows/s" |
| **Adoption counts** | The IC substitute for headcount (§2.3) | ~20 pipelines; 9 model queues; 4 models onboarded; 3 models in the plugin; 9 credential getters |
| **Before→after tuning deltas** | Small, specific, reproducible — the most credible optimization claim shape | batch 64→128; threads 2→4; concurrency cap 6; partitions 10–2,500 targeting 10–30k records each |
| **Cluster/job shape** | Concrete infra fluency | 16-pod Indexed Job; 160 executors × 3 cores; 3 multi-node × 8 GPUs |
| **Code volume — sparingly** | Signals authorship scope *only* when large, solely attributable, and paired with a test ratio | 27K-line Rust subsystem + 9.7K-line integration suite; 5.9K-line plugin. **Use at most twice on the whole resume** — LOC is otherwise exactly the "quantifiable but not impactful" trap [Huyen] |

### 4.2 Tier 2 — high value, only with provenance

- **Latency percentiles.** The target JD cares. `CODEBASE-EVIDENCE.md` contains **no latency data at all**. The existing "sustained low P99 under high QPS" (Swiggy) is an adjective, not a metric — get a number or drop the clause.
- **Cost / GPU-hours.** Nothing in evidence. If any instance-count or GPU-hour reduction exists, it is the **single highest-value number the resume could add** — it is the one metric that translates platform work into business terms [Singh Tip #10], and it is completely absent.
- **Speedup multiples.** Legitimate *if* they describe measured variance across configurations. Currently unanchored (§4.4).

### 4.3 Tier 3 — avoid

Straight from the hiring-manager's list of metrics that confused rather than impressed [Huyen]:
- Accuracy with no task and no baseline — *"Built a Transformer-based model that achieved an accuracy of 89%"*
- Activity counts instead of outcomes — *"Participated in over 300+ code reviews"*, *"Work on 15 different domains"*
- Percentages with no baseline — "improved efficiency by 30%"
- Aggregate totals you cannot attribute to yourself

### 4.4 Honest presentation — seven operating rules

1. **Scope the team when the number belongs to a system.** The hiring manager's own model bullet opens *"Part of a 2-data-scientist team that owns feature engineering for a fraud detection system…"* — scoping the team did not weaken it, it made it credible [Huyen]. For platform work: "on the platform I build" vs "that I built" is a meaningful and cheap distinction.
2. **"Platform that…" framing for others' work.** Already the rule in `CODEBASE-EVIDENCE.md`. vLLM throughput ladders and the O(1B)-scale producer jobs are platform *context*: "the platform runs vLLM…", never "I optimized vLLM."
3. **Ranges are honest — bare ranges are not.** "3–8K images/sec" is fine *with* the workload and hardware named; without them it is unverifiable. Same for "10–50×": name what got 10× and what got 50×.
4. **Approximation markers read as honest.** "~700M assets", "over 200M rows", "~20 pipelines" — the tilde signals you know the difference between a measurement and an estimate.
5. **Every number needs an answer to "how did you measure that?"** If the answer isn't a dashboard, a benchmark doc, or a commit, cut the number.
6. **Never name a technology in an Experience bullet you can't debug live.** This is the load-bearing rule behind keeping TensorRT/TRT-LLM, CUDA graphs, speculative decoding, quantization, and MoE/TP/PP out of bullets. Research confirms the milestone's existing decision — the failure mode is documented, not hypothetical [Huyen, Rule 5].
7. **Prefer "prototyped/designed" for branch-only work.** The OTel Rust instrumentation (~60 commits, branch-only) and the access-monitoring system (+29.5k lines, unmerged) are legitimately claimable as "prototyped" or "in progress" — never as shipped.

### 4.5 🚩 Blocking questions for the user

| Claim on current resume | Status | Needed |
|---|---|---|
| "10–50× faster image loading" | **No provenance in CODEBASE-EVIDENCE.md** | Source + workload, or delete |
| "3–8K images/sec on 32 GPUs" | **No provenance**; the only Ray benchmark in evidence is 8×A100 / 1.09M rows / 109 rows/s | Source + which pipeline, or replace with B3 |
| "sustained low P99 under high QPS" (Swiggy) | Unquantified adjective | A real P99 number, or drop the clause |
| "adopted across the org" (training framework) | Evidence says he "built modules for and ran" the framework, not that he led it | Narrow to modules he authored, or supply evidence of leading |
| Any mentoring claim | No evidence exists | Ask user; do not invent (§2.2) |

---

## 5. Summary / headline section

### 5.1 Verdict: **include it — 2 lines, no more**

Sources genuinely disagree, so here is the actual tally:

| Source | Position |
|---|---|
| [r/ER] | "Do **not** include a summary/profile **unless you're a senior/staff engineer or above**, making a career change, or addressing an unemployment gap." And under 10+ YoE: "Consider including a brief summary (<2 sentences)" |
| [TTR] | Lukewarm — "a section recruiters and hiring managers rarely read. There are some cases, where it's still worth adding it, though" |
| [Singh Tip #11] | "Remove the Summary / Objective" — but his target is the generic-objective genre ("I am a hard-working, innovative developer looking for…"), and his advice is aimed at students/new-grads |

**This candidate hits three of r/ER's four inclusion triggers simultaneously:** staff-targeting, a repositioning (Senior MLE → Staff MLE / inference frameworks), and a 2021–2023 education gap that just lost its explanatory row in Experience. That is the strongest possible case for a summary.

### 5.2 What it must do (and nothing else)

Four jobs no other section can do, in ≤2 lines:
1. **Assert level + track** — "Staff" is not on his current title; the summary is the only place to state the target without lying about the printed title.
2. **Name the domain narrowly** — distributed GPU inference / ML platform, not "machine learning."
3. **Front-load one scale number** — the 15-second scan lands here [Singh Tip #6].
4. **Absorb the gap and the language pivot** — pre-empt "why the 2021–2023 break."

It must **not** contain: adjectives about himself, "proven ability", "committed to leveraging", or a list of industries.

### 5.3 Two drafts (evidence-checked)

**Draft A — platform-scale lead (recommended):**
> ML platform engineer, 10 years, specializing in distributed GPU inference and the fault-tolerant data systems underneath it. Builds and operates the batch-inference and enrichment platform behind a ~700M-asset generative-AI training catalog on A100/H100 Kubernetes fleets, in Python and Rust.

**Draft B — inference-framework lead (tighter to the JD):**
> Senior MLE (ML Platform & Frameworks) at Adobe Firefly targeting staff-level inference-framework work. Designs GPU batch-inference systems on A100/H100 Kubernetes fleets — `torch.compile` max-autotune, ONNX Runtime CUDA EP, FSDP — and the fault-tolerant orchestration around them, at 200M+ row and 64-GPU scale.

Every claim in both drafts traces to `CODEBASE-EVIDENCE.md`. Draft A leads with scale (better for recruiter scan); Draft B leads with named technology (better for ATS keyword match on inference-framework JDs). **Recommend rendering both.**

Optional keyword beachhead line beneath it (§3.1 option b):
> **Core:** distributed GPU inference · PyTorch / `torch.compile` · CUDA · ONNX Runtime · Kubernetes · Rust · Spark

---

## 6. One-page Experience density

### 6.1 Bullets per role by recency

Both authorities say the same thing: [r/ER] "Make your earlier work experiences more concise"; [TTR] "Spend less space on old positions… work experience beyond 10 years is less interesting… there's little point in listing obsolete technologies."

| Role | Dates | Relevance | Share of section | Structure |
|---|---|---|---|---|
| **Adobe Firefly** | Jul 2024–Present | ⭐ Target | **~55–60%** | 4 topics (down from 5). Only the top 2 carry sub-bullets, max 2 each. Lead with GPU batch inference (B1) |
| **Swiggy** | Jan 2019–Jul 2021 | ⭐ High — online inference platform + feature store are directly on-theme | ~20% | 3 topics. Keep Online Inference Platform + Feature Store (real numbers: 4Bn rows, 10K QPS, 18M users). **Cut DAQ** (API scraping — weakest, off-theme) |
| **Flipkart** | Sep 2017–Jan 2019 | ◐ Off-theme (search/NLP) but shows ML-workflow platform work | ~12% | 4 topics → 2. **Keep ML Workflow Automation** (first train→deploy automation at Flipkart, runtime-generated Airflow DAGs — reads as platform work). Keep Search Intent Models as the marquee. Cut Tail Query Classifier + Cascading pipelines |
| **Groupon** | Sep 2016–Sep 2017 | ○ Low | 1 line | ✅ already 1 line |
| **NetSpeed (→ Intel)** | Sep 2015–Aug 2016 | ○ 10 years back, obsolete domain | **1 line or drop** | See below |

**NetSpeed decision.** Two defensible options:
- **(a) Keep as a header + no bullet** (~2 lines). Retains the Intel-acquisition credential and a hard-systems/graph-algorithms signal, and keeps the career unbroken.
- **(b) Drop, or fold into "Earlier Experience" on page 2** (saves ~4 page-1 lines). Justified by [TTR] on 10+ year-old roles and obsolete tech.

**Recommendation: (b)**, folded rather than deleted — it buys the Adobe section 4 lines, which is where marginal space has the highest return. Never silently delete a role that leaves an unexplained gap; folding avoids that.

### 6.2 Topic-grouping pattern — keep it, but cap the nesting

The existing `\resumeTopic` pattern (**bold topic**: sentence, optional sub-bullets) is a genuine strength and should survive the rewrite:
- It matches [TTR]'s prescription: "If you have spent a long time at one workplace, list out the key projects you shipped."
- It gives ATS keyword density plus a scannable left-edge for the 15-second scan.
- It reads as platform ownership: each topic is a *system*, not a task.

Two corrections:
1. **Cap nesting.** Adobe currently runs section → topic → sub-bullet (3 levels) across 5 topics. [r/ER]: "Avoid the excess use of sub-bullet points — they can clutter your resume." Cap at **4 topics, sub-bullets on the top 2 only**.
2. **Make every topic line self-sufficient.** A reader who ignores all sub-bullets should still get the scale and the outcome. Currently several topic lines are pure scope statements ("Orchestration and abstraction layer over…") with the substance pushed down or absent.

### 6.3 Formatting deltas vs the community standard

Cheap wins, all currently non-conforming. None is a blocker; all are one-line LaTeX edits. Ordered by value:

| Item | Current | Standard | Impact |
|---|---|---|---|
| Trailing periods on bullets | Present | "Don't end bullet points with periods" [r/ER] | Consistency + a hair of space |
| Justified text | `\justifying` in `\resumeItem` | "Don't justify your text since it creates inconsistent spacing between words" — cites Stanford accessibility [r/ER] | Readability; **but** it may perturb the page-1 fit — test before adopting |
| Month abbreviations | `Jul. 2024` | "Don't use periods when abbreviating months" [r/ER] | Cosmetic |
| ALL-CAPS role-context field | "GENERATIVE AI, COMPUTER VISION, …" | "Avoid excessive italicization, bolding, and ALL CAPS… use independently of each other" [r/ER] — currently small-caps + ALL-CAPS + italics coexist | Reduces visual noise; the field is also doing keyword work, so keep the field, consider title case |
| Section name "Selected Projects" | Non-standard | Name it "Projects" [r/ER] | ATS + convention |
| Section name "Technical Skills" | Acceptable | [r/ER] prefers "Skills"; [TTR] says the name matters less than contents | Optional |

---

## 7. Feature dependencies

```
Resolve unverified numbers (§4.5)
    └──blocks──> Adobe section rewrite (B1–B11)
                     └──requires──> Skills reorder (skills must mirror bullet vocabulary)
                     └──requires──> Summary draft (front-loads the headline number)

Cut Projects + Publications abstract + GPAs
    └──frees──> ~35 page-2 lines
                     └──unlocks──> "Earlier Experience" on page 2 (optional)
                                       └──frees──> ~8 page-1 lines
                                                       └──enables──> deeper Adobe section

Summary added (2 lines)
    └──consumes──> page-1 lines ──conflicts with──> "Experience fits page 1"
                                                   (net: still positive if Groupon+NetSpeed fold)

Career-break row removed
    └──requires──> Education retains 2021–2023 date range (gap explanation moves there)
    └──requires──> Summary absorbs the repositioning narrative
```

### Dependency notes

- **Unverified numbers block the rewrite.** The two Ray/throughput claims sit in the highest-visibility position on the resume. Rewriting around them and then discovering they must go means redoing the page-1 fit. Resolve first.
- **Skills ↔ bullets is bidirectional.** [r/ER]: "If you have Java in your skills, your bullet points should include Java, and vice versa." Finalize bullet vocabulary, then derive Skills from it — not the other way round.
- **Summary conflicts with page-1 fit.** It costs 2–3 lines on the most constrained page. It pays for itself only if the earlier-roles compression happens in the same pass.
- **Career-break removal creates a dependency on Education's formatting.** Deleting the row without keeping the 2021–2023 range in Education produces an unexplained 3-year gap — worse than the row it replaced. [Huyen] is relaxed about gaps ("Personally, I don't care about gaps"), but a *silent* gap invites the wrong inference.
- **Page-2 cuts do not directly help page 1.** Only the fold-earlier-roles move converts page-2 slack into page-1 space.

---

## 8. MVP definition

### Launch with (v1.0 — this milestone)

- [ ] **Resolve the two unverified numbers** — blocking, cheap, highest interview-risk reduction
- [ ] **Rebuild the Adobe section** on B1–B11: GPU batch inference lead, `torch.compile`, Rust governance subsystem, converging-re-run correctness, 64×H100 wave, ~20-pipeline adoption
- [ ] **Add the Rust work** — currently absent, and it is the top differentiator for inference-framework roles
- [ ] **Cut Projects** to 0–2 items — funds everything else
- [ ] **Cut the publication abstract**; keep citation + venues + first-author + link
- [ ] **Strip both GPAs**; keep the 2021–2023 range for gap coverage
- [ ] **Compress Research → 1 line, Teaching → 1 line**
- [ ] **Reorder + prune Skills** inference-first; every item interview-defensible; every item mirrored in a bullet
- [ ] **Add a 2-line summary** (Draft A and B rendered for comparison)
- [ ] **Compress Flipkart/Swiggy topics**; decide the NetSpeed fold
- [ ] Verify page-1 Experience fit + ATS parsability (existing hard gates)

### Add after validation (v1.x)

- [ ] Accent-palette PDF proposals (already in milestone scope)
- [ ] `index.html` hero/about sync (already in milestone scope)
- [ ] Google Scholar link on the publication [Huyen]
- [ ] Formatting deltas from §6.3 (periods, justification, month abbreviations)
- [ ] A per-JD tailoring pass — "If you are applying for 20 different jobs, you should have 20 different CVs" [TTR, recruiter Victoria Farelly]

### Future consideration (v2+)

- [ ] Cost / GPU-hour metric if one can be sourced — the highest-value missing number (§4.2)
- [ ] A mentoring clause if real evidence surfaces (§2.2)
- [ ] Separate IC vs management resume variants [r/ER] — not needed while targeting IC only

---

## 9. Prioritization matrix

| Change | Candidate value | Cost | Priority |
|---|---|---|---|
| Resolve unverified numbers | HIGH (removes offer-stage risk) | LOW | **P1** |
| Adobe section rebuilt on evidence bullets | HIGH | HIGH | **P1** |
| Add Rust / 27K-line subsystem | HIGH (top differentiator, currently absent) | LOW | **P1** |
| Add `torch.compile` max-autotune | HIGH (defensible high-demand keyword) | LOW | **P1** |
| Cut Projects section | HIGH (removes anti-feature + funds space) | LOW | **P1** |
| Add 2-line summary | HIGH (only place to assert staff level) | LOW | **P1** |
| Skills reorder + prune | MEDIUM-HIGH (ATS + credibility) | LOW | **P1** |
| Add GPU-fleet scale numbers (64×H100, 24×A100×9) | HIGH | LOW | **P1** |
| Add fault-tolerance mechanism detail | HIGH (matches JD language honestly) | MEDIUM | **P1** |
| Publication compression | MEDIUM | LOW | **P2** |
| Strip GPAs; compress Research/Teaching | MEDIUM | LOW | **P2** |
| Add cross-repo ownership clause | MEDIUM-HIGH (hard-to-fake platform signal) | LOW | **P2** |
| Compress Flipkart/Swiggy | MEDIUM (buys Adobe space) | MEDIUM | **P2** |
| Fold Groupon + NetSpeed to page 2 | MEDIUM (buys ~8 page-1 lines) | MEDIUM (splits section) | **P2 — user decision** |
| Formatting deltas (§6.3) | LOW | LOW | **P3** |
| Google Scholar link | LOW | LOW | **P3** |
| Cost / GPU-hour metric | HIGH **if sourceable** | Unknown | **P3 (blocked on data)** |

---

## 10. Sources

| Tag | Source | URL | Credibility |
|---|---|---|---|
| [r/ER] | r/EngineeringResumes wiki — index (community standard for US/CA engineering resumes; the "Senior Engineers and Above (10+ YoE)" section is the directly governing guidance) | `https://old.reddit.com/r/EngineeringResumes/wiki/index` | **HIGH** — the de-facto standard, cited in turn by [Huyen] |
| [r/ER-samples] | r/EngineeringResumes wiki — sample bullet points (the achievement-ladder "General rule" + Software examples) | `https://old.reddit.com/r/EngineeringResumes/wiki/sample-bullet-points` | **HIGH** |
| [Huyen] | Chip Huyen, "What we look for in a resume" — hiring manager, **infra and ML roles specifically**; the closest thing to a primary source for ML-platform resume screening | `https://huyenchip.com/2023/01/24/what-we-look-for-in-a-candidate.html` (live URL 404s; read via `https://web.archive.org/web/20231229010754/…`) | **HIGH** — primary, ML-infra-specific. Also relays Kyle Kranen (senior DL engineer, NVIDIA) on cookie-cutter projects |
| [StaffEng-what] | Will Larson, "What do Staff engineers actually do?" — the five staff behaviors | `https://staffeng.com/guides/what-do-staff-engineers-actually-do/` | **HIGH** — primary; based on interviews with Staff-plus engineers |
| [StaffEng-promo] | Will Larson, "Promotion packets" — the seven questions a staff case must answer | `https://staffeng.com/guides/promo-packets/` | **HIGH** |
| [StaffEng-projects] | Will Larson, "Staff projects" — most engineers reach staff without a single capstone | `https://staffeng.com/guides/staff-projects/` | **HIGH** |
| [StaffEng-arch] | Will Larson, "Staff archetypes" — Tech Lead / Architect / Solver / Right Hand | `https://staffeng.com/guides/staff-archetypes/` | **HIGH** — used to frame §2 (this candidate reads as **Architect** for a specific technical domain) |
| [Reilly] | Tanya Reilly (then Principal SWE, Squarespace), "Being Glue" — glue work as technical leadership; artifacts as evidence; credit "for **leading**, not **helping**"; the "not technical enough" failure mode | `https://noidea.dog/glue` | **HIGH** — primary, canonical on IC leadership without a title |
| [TTR] | Gergely Orosz, *The Tech Resume Inside Out* — Ch. 5 "Resume Structure" sample, incl. recruiter Victoria Farelly (Uber, Booking.com, ING) | `https://thetechresume.com/samples/resume-structure` | **HIGH** — book excerpt + named recruiter |
| [Singh] | Nick Singh (ex-Facebook/Google), "36 Resume Rules for Software Engineers" | `https://www.nicksingh.com/posts/36-resume-rules-for-software-engineers` | **MEDIUM** — credible author, but aimed at students/new-grads targeting top-tier companies; several rules (one page always, high-school SAT scores) do not transfer to a 10-YoE staff IC. Used only for the 15-second-scan and business-terms points |
| [Levels] | Levels.fyi, "How To Apply The STAR Method To Resumes" | `https://www.levels.fyi/blog/applying-star-method-resumes.html` | **MEDIUM** — useful STAR→bullet compression walkthrough; the worked example is marketing, not engineering |
| [XYZ] | Google's X-Y-Z formula ("Accomplished [X] as measured by [Y], by doing [Z]") | Cited by [r/ER] and [Huyen]; primary Inc. write-up returned HTTP 403 | **MEDIUM-HIGH** — the formula itself is uncontested and independently attested by two HIGH sources; the primary article could not be fetched |
| — | Evidence base for all example bullets | `.planning/research/CODEBASE-EVIDENCE.md` | **HIGH** — commit- and email-verified |

**Sources sought but not found:** no authoritative source enumerates credible quantification specifically for inference/ML-platform resumes (throughput vs GPU count vs latency percentiles). §4's tiering is therefore MEDIUM confidence — a synthesis of the Flink exemplar, the impact ladder, and the metrics-with-contribution test, not a citation. No staff-level ML resume teardown with published before/after bullets was located; §1.4's bullets are constructed from first principles against the candidate's evidence rather than pattern-matched to a published staff MLE exemplar.

**Excluded as LOW credibility:** the DuckDuckGo result set for "machine learning engineer resume bullet points" returned almost exclusively SEO/content-farm resume-builder sites (atsresumeschecker.com, thecvedge.com, resumeinminutes.com, job-kit.app, cvcraftor.com, thetailorcv.com, applytop.com, resumevera.com, resumestart.ai). None cites a hiring manager or recruiter; several appear to be AI-generated listicles. All excluded.

---
*Feature research for: Staff MLE / inference-framework resume content*
*Researched: 2026-08-21*
