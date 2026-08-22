# Phase 3: Adobe Rebuild & Staff-Signal Bullets - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-08-22
**Phase:** 3-adobe-rebuild-staff-signal-bullets
**Areas discussed:** Adobe block shape, Evidence picks, Swiggy/Flipkart staff-signal pass, Cost/mentoring bullets + sign-off shape

---

## Adobe block shape — retain/revise/retire + fault-tolerance lead

| Option | Description | Selected |
|--------|-------------|----------|
| Rewrite lead bullet, keep topic-group structure | Fault-tolerance/distributed-inference voice in the lead, `\resumeTopic` groups stay | ✓ |
| Lead with GPU batch-inference topic | styx_enrichment story first, platform framing second | |
| Restructure into 3 dense groups | Inference/Training/Governance flattening — bigger rewrite | |

| Option | Description | Selected |
|--------|-------------|----------|
| New governance topic group | +27,135-line Rust Content Gate as its own topic (fault-tolerant Rust framing) | ✓ |
| Fold into Build & Deployment | One denser line, no new group | |
| Leave it off page 1 | Spend the budget on inference/training depth | |

| Option | Description | Selected |
|--------|-------------|----------|
| Retain all 5, revise wording | Recorded retain/revise per topic; retire nothing | ✓ |
| Retire Data Quality topic | Fund governance/FT depth | |
| Retire Data Quality + Enrichment | Maximum room | |

| Option | Description | Selected |
|--------|-------------|----------|
| Name mechanisms inline | backoff+jitter, checkpoint caches, lease/TTL heartbeats, DLQs, circuit breakers, idempotent re-runs named where they occurred | ✓ |
| One aggregate FT bullet | Patterns aggregated, other bullets outcome-focused | |
| Implicit in outcomes | No mechanism list | |

**User's choice:** All four recommended options.
**Notes:** Criterion 1's per-bullet disposition record = 5× retain-and-revise + 1× add (governance).

---

## Evidence picks — numbers + torch.compile phrasing

| Option | Description | Selected |
|--------|-------------|----------|
| 1.09M-row / 8×A100 Ray benchmark | Direct like-for-like replacement, attribution-safe | ✓ |
| 24×A100 × 9 queues fleet | Bigger number, operated not benchmarked | |
| 64-H100 enrichment wave | Largest GPU figure | |

| Option | Description | Selected |
|--------|-------------|----------|
| Spread by owning topic | Each figure sits where a reader can probe it | ✓ |
| Concentrate top 3 | Biggest figures in lead + inference | |
| Minimal number set | Claim-led, not number-led | |

| Option | Description | Selected |
|--------|-------------|----------|
| Production claim + honest compiler bridge | max-autotune claim + Triton/CUDA-graph-capture semantics per PyTorch docs | ✓ |
| Bare claim, no bridge | Zero stretch risk, weaker keywords | |
| Bridge minus CUDA-graphs until verified | Conservative pending config read | |

**User's choice:** All three recommended options, then "Next area (accept config-read implication)".
**Notes:** Accepted implication — the CUDA-graphs config read moves INTO Phase 3 (D-08); fallback is bridge-minus-CUDA-graphs if the read fails.

---

## Swiggy/Flipkart staff-signal pass

| Option | Description | Selected |
|--------|-------------|----------|
| Sharpen existing numbers | 18M+ adoption framing, 4Bn/10K QPS kept, routing gets failure-class-closure clause | ✓ |
| Compress to 3 topics | Merge DAQ, free a line for Adobe | |
| Minimal touch | Only the two criterion-4 slots | |

| Option | Description | Selected |
|--------|-------------|----------|
| Automation = closure story | First train→deploy automation + error class closed | ✓ |
| Intent models = closure story | Named failure-class-closure on intent models | |
| Both + merge tail-query | Two slots, tail-query folds in | |

| Option | Description | Selected |
|--------|-------------|----------|
| Line-neutral S/F, Adobe spends slack | No net S/F growth/shrink; 7.0pt G7.2 margin preserved | ✓ |
| S/F may shrink for Adobe | Up to ~2 lines each, accepts G7.2 interaction | |
| Reserve 7pt explicitly | Hard cap keeping ≥7pt unspent | |

**User's choice:** All three recommended options.

---

## Cost/mentoring bullets + sign-off shape

| Option | Description | Selected |
|--------|-------------|----------|
| Draft both families | Cost/efficiency + mentoring/leadership | ✓ |
| Cost bullet only | Mentoring stays implicit | |
| Mentoring only | Skip cost claims | |

| Option | Description | Selected |
|--------|-------------|----------|
| Evidence-implied magnitudes only | No invented dollars; ⚠ UNVERIFIED flags | ✓ |
| Dollar placeholders to react to | Concrete but higher fabrication risk | |
| Qualitative drafts, no numbers | User adds numbers at checkpoint | |

| Option | Description | Selected |
|--------|-------------|----------|
| Absent-by-default, add on approval | Resume ships without them; per-bullet approval adds | ✓ |
| In-tex gated, approve-or-strip | Drafts in main.tex behind the checkpoint | |
| Per-bullet decision at checkpoint | Drafts live only in plan docs | |

| Option | Description | Selected |
|--------|-------------|----------|
| Single late checkpoint, per-bullet verdicts | After Adobe rebuild verified green; review against rendered PDF | ✓ |
| Early text approval + late confirm | Wording locks first | |
| Approve during verify-work | No dedicated checkpoint task | |

**User's choice:** All four recommended options.

---

## the agent's Discretion

- Exact bullet wording/ordering within topic groups
- Governance group placement within the block
- Where the milestone-audit obligations (regression-net make target, G6.13/WR-01 claim) land among plans
- Evidence-true keyword placement for G6.6 targets

## Deferred Ideas

- CUDA-graphs claim upgrade beyond the compiler bridge (pending D-08 read + Phase 5 skills work)
- Groupon/NetSpeed descriptor re-compression (pull only if Adobe runs out of room; P2-protected)
