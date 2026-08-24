# Phase 5: Skills Rebuild - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-08-24
**Phase:** 5-skills-rebuild
**Areas discussed:** Taxonomy & ≤3-line layout, What survives the purge, Concept-vocab framing, Evidence tiers & defense

---

## Taxonomy & ≤3-line layout

| Option | Description | Selected |
|--------|-------------|----------|
| 3 functional tiers | Languages & Inference / Training & Distributed / Concepts — dense, scannable by function | ✓ |
| 2 tiers + concepts | One dense 'Core stack' line + concept line; fewer labels, less scannable | |
| Re-curate current 2-group shape | Keep today's skills line + 'Frameworks/Libraries/Tools:', purge, fold concepts in | |

**User's choice:** 3 functional tiers.

| Option | Description | Selected |
|--------|-------------|----------|
| Yes, repeat all 17 | Skills carries every exact form even if already in a page-1/2 bullet (ATS density; self-contained block) | ✓ |
| Only add the missing ones | Skills lists only forms not already on page 1 (leaner, thinner block for scanners) | |

**User's choice:** Repeat all 17 exact forms in Skills.
**Notes:** Only ONNX Runtime / H100 / CUDA graphs / Iceberg / PyTorch Lightning are strictly new to the document; the rest already extract from page 1/2.

---

## What survives the purge

| Option | Description | Selected |
|--------|-------------|----------|
| Drop all research-identity from Skills | Skills stays inference-focused; graph/fairness/recsys identity carried by page-2 Publication + graph_ml | ✓ |
| Keep GNN + Contrastive Learning only | Back the publication + graph_ml directly; drop the rest; costs keyword room | |
| Keep a broader ML line | GNN, Contrastive Learning, LLMs, Recommendations as a 4th group; risks the ≤3-line budget | |

**User's choice:** Drop all research-identity tokens from Skills.

| Option | Description | Selected |
|--------|-------------|----------|
| Cut all generalist tools | Remove Tensorflow, Sklearn, Numpy, Pandas, Matplotlib, HDFS, Kafka, Flink, Sagemaker, DynamoDB, Faiss, Django, Scala, PyTorch Geometric | ✓ |
| Keep a few | Retain some (e.g. Kafka/Flink, PyTorch Geometric); adds breadth, spends budget | |

**User's choice:** Cut all generalist tools.

---

## Concept-vocab framing

| Option | Description | Selected |
|--------|-------------|----------|
| `Concepts:` | Compact, neutral, own line, reads as a topic list not a build claim; safest for the ≤3-line fit | ✓ |
| `Conversant in:` | Most explicit honesty signal; ~6 chars longer but fits | |
| `Concept vocabulary:` | Names it as vocabulary outright; longest label, tightest against the wrap risk | |

**User's choice:** `Concepts:`

---

## Evidence tiers & defense

| Option | Description | Selected |
|--------|-------------|----------|
| Implicit co-occurrence (C++ anchor) | Skills C++ + NetSpeed NoC (p1) + graph_ml kernels (p2), already in the doc; no parenthetical | ✓ |
| Explicit parenthetical | 'C++ (NetSpeed NoC, graph_ml kernels)' in Skills; unambiguous but spends chars, reads oddly | |

**User's choice:** Implicit co-occurrence.

| Option | Description | Selected |
|--------|-------------|----------|
| All 5 concepts conversant | tensor/pipeline/MoE parallelism, KV-cache, continuous batching all evaluated/vocabulary | ✓ |
| Split: 2 operated, 3 conversant | continuous batching + KV-cache as operated (via vLLM); parallelism as conversant | |

**User's choice:** All 5 concepts conversant.

| Option | Description | Selected |
|--------|-------------|----------|
| Iceberg operated | Ran Iceberg tables in production; operated tier alongside Spark | |
| Iceberg evaluated/conversant only | Knows it conceptually, hasn't shipped it; conversant framing | ✓ |
| Drop Iceberg | Cut if not defensible at any tier; flag the criterion-1 conflict | |

**User's choice:** Iceberg = evaluated/conversant only.
**Notes:** Ships in a functional tools tier on the printed resume (tier label not printed) but rests on an evaluated-only defense — flagged for explicit confirmation at the per-item checkpoint.

---

## Claude's Discretion

- Exact tier membership rebalancing and final token order within the 3-tier scheme, driven by the measured ≤3-line fit.
- Whether to list bare `PyTorch` in addition to `PyTorch Lightning` (redundant by substring; a space call).
- Exact wording of the per-item checkpoint prompt (must show the tier, be per-item).

## Deferred Ideas

None — discussion stayed within phase scope. (Research identity dropped from Skills remains present on page 2 via the Publication + graph_ml, by design — not deferred.)
