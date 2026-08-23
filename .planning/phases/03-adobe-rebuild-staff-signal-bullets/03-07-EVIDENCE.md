# Plan 03-07 — EXP-08 sign-off evidence packet

**Purpose.** Everything the per-bullet sign-off decision needs, and nothing else. No recommendation
appears anywhere in this file: the judgment on provisional magnitudes is the whole reason the gate
exists, and an agent opinion would contaminate it.

Measured against commit `e2fc8f9` (the plan 03-06 end state). `git status --porcelain docs/` is empty
— this plan changed no content.

---

## 1. Precondition — the rebuild is verified green, measured not assumed

D-15 requires the rebuild be proven green **before** the ask. All four suites were run directly, in
order, on the committed artifact:

| Suite | Invocation | Result |
|---|---|---|
| Build | `make build` | **exit 0** (`Nothing to be done` — the committed PDF is already current) |
| Harness | `bash scripts/verify-resume.sh` | **exit 0**, 83 `RESULT` lines, **zero** FAIL, **zero** SKIP |
| Phase-2 content net | `bash scripts/verify-phase2-regressions.sh` | **exit 0**, **27** anchored `^RESULT P2\.[0-9]+ +PASS` lines, 0 anchored FAIL |
| Phase-3 content net | `bash scripts/verify-phase3-regressions.sh` | **exit 0**, **72** anchored `^RESULT P3\.[0-9]+ +PASS` lines, 0 anchored FAIL |
| Self-test | `make verify-selftest` | **exit 0**, **10** `G7`/`G8` PASS, **zero** anchored SKIP |

The P2 net emits **28** lines containing the word `PASS`; the 28th is the `>> PASS:` human summary.
The anchored form is the count that means anything — 27.

`make verify` also exits **0**, recorded as ROADMAP criterion 5 corroboration only. It is **not** the
oracle: GNU Make 3.81 collapses a recipe's exit 1 and exit 2 into its own exit 2, so `make verify`
cannot distinguish "the document is wrong" from "cannot verify". The direct `bash` invocations above
are the oracle.

Overflow alarm state, read first as the ledger requires:

```
RESULT G1.1   PASS  page tree reports 2 page(s), manifest PAGES=2
RESULT G3.1   PASS  deepest content bottom 747.3pt vs ceiling 764.4pt (p1 747.3pt, p2 710.9pt)
RESULT G7.2   PASS  the probe PDF is 3 page(s), above the manifest PAGES=2 budget, so the +5 probe is a genuine overflow
```

`G7.2` still PASSing is the proof that hard rail 2 held — page-1 slack was never net-freed, so the
anti-rot probe is still armed.

**Absent-by-default state right now.** All six Class D assertions are PASS, i.e. no draft has leaked
into the document in source or text layer:

```
RESULT P3.67  PASS  EXP-08a/03-07 provisional draft literal absent by default (source):     'AssumeRole' is absent from docs/main.tex (count 0)
RESULT P3.68  PASS  EXP-08a/03-07 provisional draft literal absent by default (text layer): 'AssumeRole' is absent from the extracted text layer (count 0)
RESULT P3.69  PASS  EXP-08a/03-07 provisional draft literal absent by default (source):     '6-week' is absent from docs/main.tex (count 0)
RESULT P3.70  PASS  EXP-08a/03-07 provisional draft literal absent by default (text layer): '6-week' is absent from the extracted text layer (count 0)
RESULT P3.71  PASS  EXP-08a/03-07 provisional draft literal absent by default (source):     'mentored' is absent from docs/main.tex (count 0)
RESULT P3.72  PASS  EXP-08a/03-07 provisional draft literal absent by default (text layer): 'mentored' is absent from the extracted text layer (count 0)
```

The suggested needle for candidate (c), `drop-before-create`, also reads **×0** in both `docs/main.tex`
and the extracted text layer today — so it is still available as a distinctive needle.

---

## 2. The rendered Adobe block — extracted text, not LaTeX source

Region re-derived from **boundaries**, never from stored line numbers: the frozen subtitle
`GENERATIVE AI, COMPUTER VISION, LARGE LANGUAGE MODELS` matched as a whole extracted line (gate 10),
then the walk to the next blank line (gate 32). Result: **gate 11–31, 21 rendered lines**.

Extraction convention is the repo's pinned one — `pdftotext` default mode, form feeds normalized to
newlines. This is what an ATS parser and a recruiter's copy-paste both see.

```
11 | – Lead fault-tolerant distributed inference and training infrastructure for the org’s ML platform: GPU pipelines on Kubernetes engineered to
12 | survive node loss and partial failure, from 40-node daily EMR ingestion through production model inference.
13 | – Distributed Inference Frameworks: Designed and led engineering for the org’s online and offline inference systems powering
14 | experimentation and production at scale, reaching 24×A100-40GB per model job across 9 model queues and 64 H100s in one parallel wave.
15 | – Built online inference on vLLM + Ray for rapid experimentation with LLMs such as Falcon-40B and Llama 2 70B.
16 | – Built offline inference on Ray Data + PyTorch Lightning; a module benchmarked on that engine at 1.09M rows, 8×A100, 16 fractional-GPU
17 | actors. Introduced torch.compile(mode="max-autotune") in production: compiler-generated Triton kernels, fusion, CUDA-graph capture.
18 | – Modeled pipelines as horizontally-scaling Source → Transform → Sink plugins with no pod-to-pod communication, KEDA-autoscaled on
19 | SQS queue depth; batched sends retry on exponential backoff with full jitter, and undeliverable work drains to a DLQ.
20 | – Foundation Model Training Framework: Leading development of a PyTorch-based training framework adopted across the org for training
21 | generative models on billions of images and videos.
22 | – Designed a plugin-based strategy pattern over FSDP/FSDP2 to make distributed training strategies pluggable.
23 | – Integrated Flash Attention 2/3, context parallelism, and distributed attention for DiT text-to-image and text-to-video training.
24 | – Build & Deployment System: Built a CLI-driven build system (BuildKit images on KEDA-scaled Kubernetes jobs, pushed to ECR), fronted by
25 | a Rust control plane and an MCP interface for AI-agent-driven builds, deployments, and inference.
26 | – Enrichment Service: Orchestration over the inference framework; migrated its 202.6M-row and 24.8M-clip datasets on idempotent re-runs;
27 | ran fire-and-forget pipelines behind a concurrency-safe S3 checkpoint cache, lease/TTL heartbeats and a circuit breaker.
28 | – Training-Data Governance: Solely authored the org’s fault-tolerant training-data lineage subsystem in Rust (27,135 lines): idempotent
29 | claim/receipt registration, immutable S3 evidence layouts, and manifest-after-data publication, proven by a 9.7k-line integration test.
30 | – Data Quality Framework: Wrote the org’s first data quality framework on Cerberus, used across enrichment pipelines to validate the
31 | correctness of feature-generation outputs across a ~700M-asset catalog growing 35–38M images/month.
```

The nine topic-carrying entries, in document order, are the candidate landing sites named in §4:
lead bullet (11–12), `Distributed Inference Frameworks` (13–14) with three nested items (15–19),
`Foundation Model Training Framework` (20–21) with two nested items (22–23),
`Build & Deployment System` (24–25), `Enrichment Service` (26–27), `Training-Data Governance` (28–29),
`Data Quality Framework` (30–31).

---

## 3. Measured page-1 headroom, and what an approval actually costs

Verbatim from the harness on the committed artifact:

```
RESULT G3.2   INFO  headroom at 11.5pt/line: p1 +17.1pt (+1.49 lines), p2 +53.5pt (+4.65 lines)
```

| Quantity | Measured value |
|---|---|
| `G3.2` page-1 headroom | **+17.1pt** |
| Same, in lines at `LINE_PT=11.5` | **+1.49 lines** |
| Cost of one rendered page-1 line | **11.4–11.5pt**, linear across the whole +1…+5 sweep |
| **Rendered lines available for an approval right now** — `floor(17.1 / 11.5)` | **1** |

Arithmetic of the two cases, stated so no step is implicit:

- **A 1-line approval:** `17.1 − 11.5 = +5.6pt` remaining. That is above the ladder's back-out rung
  (+4.7pt), so it fits without touching protected content.
- **A 2-line approval:** `17.1 − 23.0 = −5.9pt`. Page 1 has no room for a second line. The measured
  behaviour past the +4-line ceiling is a **3-page PDF with `G1.1` FAIL and `G2.1` FAIL**.

**Contingency-ladder position: reserve INTACT.** +17.1pt sits above the ≥ +16.1pt top rung, by 1.0pt.
The sanctioned Groupon/NetSpeed reword-shorter lever was **not** pulled in waves 2–4, so this plan
inherits **no** same-commit obligation. The approval fund is exactly the one rendered line the ledger
reserved for it.

⚠ **`G3.1`/`G3.2` are not the overflow alarm — `G1.1` is.** With `\raggedbottom`, LaTeX breaks the
page rather than overrunning `\textheight`, so at +5 lines `G3.1`, `G2.3` and `G2.4` all measured
green on a 3-page document. Read `G1.1` first; treat `G3.2` p1 as the remaining-headroom meter.

**All costs here are estimates and are re-measured at 03-08.** Phase 2's rule applies without
exception: the real cost is read from the build, never trusted from an estimate. 03-08 rebuilds and
reads `G1.1`, then `G3.2` p1, before accepting any approval.

---

## 4. The four drafts

Each draft is quoted **verbatim** from `03-DECISION-RECORD.md` Section D. Character lengths were
measured on the draft prose plus the 2-character `– ` bullet prefix, and divided by the measured
per-shape rendered width to give a derived line estimate alongside the decision record's own.

Measured per-shape widths on this committed artifact (characters, not bytes — the U+2013 bullet
prefix is 3 bytes, `×` is 2, `’` is 3):

| Shape | Measured line width |
|---|---|
| itemize-2 (lead bullet, `\resumeTopic` lines) | **124–140 characters** |
| itemize-3 (nested `\resumeItem` lines) | **109–135 characters**, line-1 capacity **135** |

### Candidate (a) — STS assume-role storm fix · needle `AssumeRole`

> Closed a credential-refresh failure class in the feature-registry client library where a failed
> AssumeRole never populated the session cache, driving thousands of throttled STS calls per second
> under role chaining; fixed with a shared negative cache on a 60s cooldown and exactly-one
> half-open retry, proven by an 8-thread thundering-herd collapse test.

| | |
|---|---|
| **Marker** | ⚠ UNVERIFIED |
| **Being asked to confirm** | that "thousands of throttled calls per second eliminated" is a fair characterisation of the storm this fix ended |
| **Evidence citation** | `CODEBASE-EVIDENCE.md:111` — "**STS assume-role storm fix** (`46665c4`, +457 ln): failed AssumeRole never populated session caches → thousands of STS calls/sec + throttling (trigger: 12h session duration rejected under role chaining). Fix: shared negative cache w/ 60s cooldown + exactly-one half-open retry (circuit-breaker semantics) … 8-thread thundering-herd colla…" |
| **Owning topic if approved** | **A10 `\resumeTopic{Enrichment Service}`** (rendered 26–27), as a nested `\resumeItem` — the feature-registry session layer is what every enrichment pipeline writes through (`CODEBASE-EVIDENCE.md:22`) |
| **Decision-record cost estimate** | **2 rendered lines** (longest of the three) |
| **Measured length** | 353 characters + 2 prefix = **355**; `355 / 135` = **2.63** → derived **3 rendered lines** |
| **Figures carried** | `thousands … per second`, `60s cooldown`, `exactly-one half-open retry`, `8-thread` — all `CODEBASE-EVIDENCE.md:111`. No dollar amount, no headcount, no percentage |
| **Needle casing** | must ship byte-exact `AssumeRole` (CamelCase, one word). Not `assume-role`, `Assume Role`, `assumerole` |

### Candidate (b) — 6-week silent outage root-cause + smoke-test CI · needle `6-week`

> Root-caused a 6-week silent enrichment outage — dependency rot had broken the framework's venv
> installs with no failing signal — and closed the class with install/import smoke-test CI plus
> SHA-pinned builds, so the same rot now fails the build instead of the data.

| | |
|---|---|
| **Marker** | ⚠ UNVERIFIED |
| **Being asked to confirm** | that "a 6-week silent-outage class closed" is a fair framing of a root-cause plus the CI that would have caught it |
| **Evidence citation** | `CODEBASE-EVIDENCE.md:94` — "**Root-caused 6-week silent outage** (package rot broke genie[glimmer] venv installs); fixed + added install/import smoke-test CI that would have caught it; SHA-pinned genie builds." |
| **Owning topic if approved** | **A9 `\resumeTopic{Build \& Deployment System}`** (rendered 24–25) — the remedy is build-and-CI reliability |
| **Decision-record cost estimate** | **1–2 rendered lines** |
| **Measured length** | 264 characters + 2 prefix = **266**; `266 / 135` = **1.97** → derived **2 rendered lines** |
| **Figures carried** | `6-week` → `CODEBASE-EVIDENCE.md:94`. No dollar amount, no headcount, no percentage |
| **Needle casing** | must ship byte-exact `6-week` (digit, ASCII hyphen, lowercase). Not `six-week`, `6 week`, and **not** `6--week`, which LaTeX renders as an en dash |
| **Encoding note** | the draft carries **two** U+2014 em dashes; the document carries one today. `G6.4` asserts each non-ASCII **codepoint class** is declared in `NONASCII_ALLOW`, not a count, and U+2014 is already declared — so this adds no new codepoint class |

### Candidate (c) — preemptible-fleet idempotent autorecovery · ⚠ NO LOCKED NEEDLE

> Made preemptible-GPU enrichment backfills survive node loss: queue drain promoted to the
> authoritative success signal over preemption-noisy job state, idempotent re-runs, stale-queue
> drop-before-create, and window fallback to the last successful day.

| | |
|---|---|
| **Marker** | ⚠ UNVERIFIED |
| **Being asked to confirm** | that a fault-tolerance claim with **no magnitude at all** is worth a page-1 line |
| **Evidence citation** | `CODEBASE-EVIDENCE.md:95` — "**Fault tolerance on preemptible GPU fleets:** made Glimmer-queue drain the authoritative success signal (Pluto job state noisy under preemption); idempotent re-runs (`skip_existed=true`); stale-queue drop-before-create; window fallback to latest `_SUCCESS` day; `--preemptible --enable-autorecovery v2` backfills." |
| **Owning topic if approved** | **A10 `\resumeTopic{Enrichment Service}`** (rendered 26–27) — the same topic D-06's `64 H100s` fleet figure lands in |
| **Decision-record cost estimate** | **1–2 rendered lines** |
| **Measured length** | 250 characters + 2 prefix = **252**; `252 / 135` = **1.87** → derived **2 rendered lines** |
| **Figures carried** | none — no numeral at all |
| ⚠ **Recorded gap** | this candidate has **no Class D absence needle**. The three locked needles are `AssumeRole`, `6-week` and `mentored`; none belongs to (c), so it is not covered by an absent-by-default assertion. **If (c) is approved, 03-08 must add its needle in the SAME commit that ships it** — otherwise the bullet enters the document with no machine record that it was ever gated. Suggested needle `drop-before-create`, measured ×0 in both source and text layer today; `pdftotext` does not hyphenate it, so it survives a wrap |

### Mentoring / leadership line · needle `mentored` (lowercase, mid-sentence)

> Grew the platform's engineering bench: mentored applied-ML and platform engineers onto the
> training and inference frameworks, authoring the architecture guide, runbook and multi-node launch
> templates teams onboard with, and reviewing their module integrations through to production.

| | |
|---|---|
| **Marker** | ⚠ UNVERIFIED |
| **Being asked to confirm** | **the people relationship itself** — see the honesty note below; this is a different kind of ask from the cost family's |
| **Evidence citations** | `CODEBASE-EVIDENCE.md:26` (425-ln ARCHITECTURE.md + 364-ln runbook), `:61` (multi-node launch templates across 9 production modules), `:30` (422-ln frozen cross-runtime contract doc), `:53` (production model onboarding, 4 models merged to main) |
| **Owning topic if approved** | **A6 `\resumeTopic{Foundation Model Training Framework}`** (rendered 20–21) — the topic whose claim the people dimension extends |
| **Decision-record cost estimate** | **1–2 rendered lines** |
| **Measured length** | 282 characters + 2 prefix = **284**; `284 / 135` = **2.10** → derived **3 rendered lines** |
| **Figures carried** | **none, deliberately** — the draft carries no numeral, because D-13 forbids an invented headcount and "mentored N engineers" is exactly that. The claim is qualitative on purpose |
| **Needle casing** | must ship lowercase `mentored`, **mid-sentence**. A sentence-initial `Mentored …` leaves `assert_absent 'mentored'` reading 0 forever, so 03-08's absent→present flip would report a **false absence on a bullet that is actually on the page** |

⚠ **Honesty note, quoted because it changes what is being asked.** The cost-family drafts restate
facts already in `CODEBASE-EVIDENCE.md` and ask only for approval of the framing and the magnitude.
The mentoring draft is different: the mined commits show the *artifacts* (guides, runbooks, templates,
model onboardings) but **cannot show a mentoring relationship** — commit history does not record who
learned what from whom. This draft asks for confirmation of a **fact the evidence pass could not
reach**, not merely a framing.

**What the document does not already claim.** The three closest existing lines are artifact or
self-role claims; none carries a people dimension:

| Existing line | What it already claims | What it does not claim |
|---|---|---|
| A6, rendered 20 | a training framework "adopted across the org" | adoption of an artifact — nothing about who was brought along |
| Swiggy S5, rendered 47 | "Founding member" of the forecasting platform | his own seat, not other engineers' growth |
| Flipkart F5, rendered 64–65 | Cascading/HDFS pipelines, `4Bn+` datapoints | nothing about people or leadership at all |

---

## 5. Consequence table — what each verdict costs

| Verdict | Rendered-line delta | Consequence |
|---|---|---|
| **Reject a draft** | 0 | Nothing changes. `assert_absent` for its needle stays PASS exactly as it is today. **D-14 makes absence the default and rejection a fully green outcome** — rejecting all four closes the phase green and leaves +17.1pt as reserve for later phases |
| **Approve one draft that renders as 1 line** | +1 | Fits the measured fund. p1 lands at ≈ **+5.6pt**, above the +4.7pt back-out rung. No protected content is touched. 03-08 flips that needle's `assert_absent` → `assert_present` in the same commit |
| **Approve anything that renders as 2+ lines** | +2 or more | **Exceeds the measured fund.** Requires the sanctioned Groupon/NetSpeed reword-shorter, in the **SAME commit** as the addition, so the net delta is zero and the `G7.2` margin is never transiently widened. A two-commit sequence would leave one commit net-freed, which hard rail 2 forbids |
| **Revise a draft's wording** | re-measured | The replacement wording is recorded verbatim and 03-08 ships exactly that text — nothing reconstructed. Cost is measured on the revised string, not the original |
| **Approve past the +4-line ceiling** | — | Measured outcome is a **3-page PDF with `G1.1` FAIL and `G2.1` FAIL**. The ladder's instruction at that point is **back the edit out** — never tighten a frozen surface, never lower a threshold |

### The reword lever's preconditions and the literals it must preserve

The lever is available only when **all three** hold: (1) the rebuild has measurably run out of room —
a recorded `G3.2` figure, not a prediction; (2) **every** P2-protected literal survives; (3) neither
forbidden shortened form appears. The two descriptors are reworded **shorter**, never deleted.

Current source lines, resolved by **content** (not by a stored line number — every wave that adds a
source line invalidates a written-down one):

- Groupon — `docs/main.tex:200`, rendered gate 73–74
- NetSpeed — `docs/main.tex:207`, rendered gate 82–83

`scripts/verify-phase2-regressions.sh` P2.7–P2.27 assert all of the following. A reword that loses any
one of them is a BLOCKER:

**Eleven literals, whitespace-squeezed text layer** (both descriptors wrap, so `pdftotext` breaks them
mid-phrase and the squeezed stream is the only honest place to match them):

```
Virtual Channel Arbitration
Polarity-based Arbitration
Multi-Cast Filtering
Structural Latency Breakdown
Network-on-Chip
C++ graph algorithms
NSVD
Neo4j
Cyclops
customer-service platform
live in every Groupon country
```

**One case-insensitive literal:** `customer segmentation` — sentence-initial in the shipped descriptor,
so it renders as `Customer segmentation`.

**Five tokens again, against the raw extracted lines**, so whitespace normalization can never be the
thing that makes an assertion pass: `Cyclops`, `NSVD`, `Neo4j`, `C++`, `Network-on-Chip`.

**Two forbidden forms, asserted absent in BOTH the text layer and the source:**

| Forbidden form | Why it is forbidden |
|---|---|
| `Virtual Channel and Polarity-based Arbitration` | merging the two names dissolves two of the four locked module names |
| `Cyclops service platform` | drops the `customer-service` and `live` elements |

⚠ **`C++ graph algorithms` is the load-bearing anchor.** Bare `C++` already extracts three times from
page 2 (the Continuous Dominant Set project line and the Skills line), so a bare presence test would
PASS even with the NetSpeed descriptor's C++ evidence entirely gone. The multi-word form measured 0
before Phase 2 wrote the descriptor, so it can only come from there — and **ROADMAP Phase 5
criterion 4 rests on exactly this anchor.**

---

## 6. Digit-bearing count, and where a figure has to sit to be counted

```
RESULT G5.4   WARN  page-1 digit-bearing bullet lines: 11 against manifest DIGIT_BULLET_FLOOR=7 -- crude metric, kept non-gating (owner: Phase 3)
```

Current count **11**, against `DIGIT_BULLET_FLOOR=7`. ROADMAP criterion 4 needs ≥ 8. Breakdown by
block: **Adobe 6** (gate 15, 16, 22, 23, 26, 28), Swiggy 3 (39, 45, 49), Flipkart 1 (64), Groupon 1
(73), NetSpeed 0.

`G5.4` counts with `^[[:space:]]*(•|▪|◦|·|–|—|\*|-).*[0-9]` against the page-1 gate stream — it only
sees lines that **start with a bullet glyph**. The consequence for an approved draft:

- a figure on the draft's **first** rendered line **raises** `G5.4`;
- a figure that wraps onto a **continuation** line does not — it is invisible to the metric even
  though a human reads it perfectly well.

Live proof already in the document: Adobe gate 14 carries `24×A100-40GB`, `9 model queues` and
`64 H100s`, and gate 17 carries `torch.compile(mode="max-autotune")` — both continuation lines, both
correctly absent from the match set.

`G5.4` is **warn-tier and cannot fail**, so the value in its message is the thing to read, not its
status. `DIGIT_BULLET_FLOOR` is never lowered, and by the same Phase-1 rule it is not raised to match
a document either.

Per-draft implication, stated as arithmetic only: (a) `60s`/`8-thread` and (b) `6-week` and the
mentoring line's zero numerals each land wherever the wrap puts them, which 03-08 measures after the
build. (c) carries no numeral at all, so it cannot move `G5.4` in either direction.

---

## 7. What is being asked

One verdict per draft ID — `(a)`, `(b)`, `(c)`, `mentoring` — each **approve**, **reject**, or
**revise** with the replacement wording. Plus one explicit `staff-signal: yes` or
`staff-signal: no — <what still reads as job description, and what it should say instead>` line for
ROADMAP criterion 2's qualitative half, which no assertion in this repo can measure.

Rejection of every draft is a green outcome. Silence is the only answer that produces a false record.
