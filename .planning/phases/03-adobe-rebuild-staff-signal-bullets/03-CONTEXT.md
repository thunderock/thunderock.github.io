# Phase 3: Adobe Rebuild & Staff-Signal Bullets - Context

**Gathered:** 2026-08-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Rebuild the page-1 Adobe Firefly block on commit-verified evidence (fault-tolerance / distributed-inference lead, `torch.compile` production claim, evidence-backed figures replacing the two unverified numbers), tighten Swiggy/Flipkart bullets to staff-signal formulas, and draft cost-savings + mentoring bullets behind an explicit user sign-off checkpoint — with `make verify` staying green throughout. Requirements: EXP-02, EXP-03, EXP-04, EXP-07, EXP-08. No Skills work (Phase 5), no page-2 work (Phase 4), no palette/site work (Phase 6), no summary/headline section (milestone decision).

</domain>

<decisions>
## Implementation Decisions

### Adobe block shape (EXP-02)
- **D-01:** Rewrite the generic lead bullet ("Leading parts of the org's MLOps platform…") into fault-tolerance / distributed-inference voice. Keep the existing `\resumeTopic` group structure — no flattening, no restructure into dense groups.
- **D-02:** Add a **new governance topic group** for the Content Gate work: +27,135-line production Rust training-data governance/lineage subsystem (idempotent claim/receipt registration, immutable S3 evidence layouts, 9.7k-line integration test). Framed as "fault-tolerant distributed systems in Rust" — **never** as inference optimization (CODEBASE-EVIDENCE binding rule).
- **D-03:** **Retain all 5 existing topics** (Distributed Inference, Training Framework, Build & Deployment, Enrichment, Data Quality), revised tighter. Retire nothing. Criterion 1's retain/revise/retire record must log a decision per topic: 5× retain-and-revise + 1× add (governance). Falcon-40B, Llama 2 70B, and KEDA-on-SQS-depth claims survive the rewrite.
- **D-04:** Name fault-tolerance mechanisms **inline where they occurred**: exponential backoff + full jitter, concurrency-safe S3 checkpoint caches, lease/TTL heartbeats, DLQs, circuit breakers, idempotent re-runs. No aggregate FT bullet, no implicit-only outcomes.

### Evidence picks (EXP-03, EXP-04)
- **D-05:** The offline-inference bullet's "10–50× faster image loading" and "3–8K images/sec on 32 GPUs" are replaced by the **1.09M-row / 8×A100 Ray Data benchmark** (16 fractional-GPU actors). Attribution-safe phrasing: his AIDE module *benchmarked on* the Ray Data engine — not "achieved" as if he built the engine.
- **D-06:** Remaining scale figures **spread by owning topic**: 202.6M-row resumable migration + 24.8M video clips (enrichment/migration), ~700M-asset catalog +35–38M/month (data platform), 24×A100-40GB × 9 queues + 64-H100 wave (fleet operations), 40-node EMR daily (ingestion). Every figure traces to a named CODEBASE-EVIDENCE entry (criterion 3). Digit-bearing page-1 bullet count must not drop below baseline **8** (criterion 4; G5.4 floor is 7).
- **D-07:** `torch.compile` phrasing: **production claim + honest compiler bridge** — "introduced `torch.compile(mode="max-autotune")` on CLIP encoder + classifier head in production" with compiler-bridge clause naming what max-autotune honestly buys (Triton-generated kernels, CUDA-graph capture per official PyTorch docs semantics). Anchored to genie #1611/#1619.
- **D-08:** **Accepted implication:** the CUDA-graphs config verification moves INTO Phase 3 (was parked as a Phase-5 concern in STATE.md). Before the bridge wording ships, one read of the glimmer content-type-classifier compile config must confirm no `max-autotune-no-cudagraphs` / `triton.cudagraphs=False`. If the read fails: fall back to bridge-minus-CUDA-graphs wording (Triton kernels only). Record the read's outcome.

### Swiggy/Flipkart staff-signal pass (EXP-07)
- **D-09:** Swiggy: **sharpen existing numbers** — Online Inference Platform carries the adoption count (18M+ monthly transacting users, platform-adoption framing); Feature Store keeps 4Bn rows / 10K QPS; the routing bullet gains a failure-class-closure clause (fault isolation across clusters, backpressure-aware scheduling, sustained low P99). No new claims requiring new evidence.
- **D-10:** Flipkart: **ML Workflow Automation carries the closure story** — first automated train→deploy workflow at Flipkart plus the error class it closed (manual-deploy drift / missing data+model validations). Search Intent Models keeps its "millions every day" adoption framing.
- **D-11:** **Line-budget policy:** Swiggy/Flipkart edits are line-neutral (in-place rewording; no net growth or shrink). Only the Adobe block grows, spending the +50.5pt slack. This preserves the 7.0pt G7.2 probe margin — do NOT free additional lines this phase (re-compression of the Groupon/NetSpeed descriptors stays untouched unless Adobe needs the room, per D-08/Phase-2 handoff).

### Cost/mentoring bullets + sign-off (EXP-08)
- **D-12:** Draft **both families**: one cost/efficiency bullet (candidates: STS assume-role storm fix eliminating thousands of throttled calls/sec; 6-week silent-outage root-cause + smoke-test CI; preemptible-fleet idempotent autorecovery) and one mentoring/leadership line (framework adoption across org, founding-member/led framings).
- **D-13:** Provisional figures are **evidence-implied magnitudes only** (e.g. "thousands of STS calls/sec eliminated", "6-week outage class closed"). Never invented dollar amounts. Each draft carries an explicit ⚠ UNVERIFIED flag until user confirmation.
- **D-14:** **Ship rule = absent-by-default.** The rebuilt section ships WITHOUT these bullets; they enter `docs/main.tex` only after explicit recorded per-bullet approval. The phase can close green with them absent — rejection is a valid outcome, not a failure.
- **D-15:** **Checkpoint mechanics:** one blocking `checkpoint:decision` late in the phase, AFTER the Adobe rebuild is verified green. User reviews drafts against rendered PDF context, gives per-bullet verdicts; decisions recorded in the SUMMARY. Cannot auto-advance past it (STATE.md hard gate).

### the agent's Discretion
- Exact bullet wording and ordering within each topic group (decisions above fix content, evidence anchors, and mechanism lists — not sentences).
- Topic-group ordering within the Adobe block (governance before/after Training Framework — pick what reads best at rendered width).
- Whether the milestone-audit obligations (wire `scripts/verify-phase2-regressions.sh` into a make target; claim G6.13/WR-01 ownership) land as a wave-0 plan task or fold into the harness-touching plan — both must land somewhere in this phase (see canonical refs).
- Keyword placement for G6.6's absent target keywords (torch.compile, A100, H100 land naturally via D-05/D-06/D-07; ONNX/CUDA graphs/Iceberg/Triton appear only where evidence-true — no keyword stuffing).

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Evidence (the phase's content source — every figure must trace here)
- `.planning/research/CODEBASE-EVIDENCE.md` — commit-verified accomplishments + binding honest-framing rules (NO TensorRT/TRT-LLM, CUDA graphs, speculative decoding, quantization, MoE/TP/PP as accomplishments; Ray-benchmark attribution; Content Gate framing; asml/ff-data-ingestion role framing)

### Harness contract (the acceptance oracle)
- `docs/verify/manifest.txt` — KEYWORDS_REQUIRED (13 must stay present), KEYWORDS_TARGET promotion mechanism (present ⇒ promote to REQUIRED in same commit), DIGIT_BULLET_FLOOR=7, WARN_OWNERS (G5.4 + G6.6 owned by Phase 3)
- `docs/verify/baseline-frozen.txt` — Adobe/Swiggy/Flipkart dates, titles, employers byte-frozen; geometry hash
- `scripts/verify-resume.sh` — `bash scripts/verify-resume.sh` exit 0 is the DONE signal; never `make verify` for gating (Make collapses exit codes); never `make clean` (deletes the G0.3 freshness record)
- `scripts/verify-phase2-regressions.sh` — P2.1–P2.27 standing net protecting career-break absence + locked D-05/D-06 descriptor literals (incl. the `C++ graph algorithms` anchor). **Phase 3 must wire this into a make target and run it after every content edit** — the Groupon/NetSpeed descriptors it protects are the designated re-compression lever this phase might pull.
- `.planning/v1.0-MILESTONE-AUDIT.md` — IG-01/IG-02 (regression-net wiring + documentation are Phase-3 obligations), IG-03 (claim G6.13/WR-01 FLIPKART employer-order WARN ownership), spend-before-freeing constraint

### Phase-2 handoff (budget + constraints)
- `.planning/phases/02-page-1-budget-text-layer-defects/02-02-SUMMARY.md` — Next Phase Readiness: +50.5pt/+4.39-line slack, 7.0pt G7.2 margin (if Phase 3 nets >~7pt additional recovery, PROBE_LINES must be raised by smallest increment with G7.1 re-proven), WARN-tier owners
- `.planning/STATE.md` — Phase-02 decisions (descriptor carrier shape, PROBE_LINES raise-only rule, artifacts-ride-with-source commit convention, EXP-08 hard checkpoint flag)

### Current content (what gets rewritten)
- `docs/main.tex` :146-167 (Adobe block — lead bullet + 5 topic groups), :169-181 (Swiggy), :183-195 (Flipkart)
- `git 0dafdbc:docs/Ashutosh_Tiwari.pdf` — 2021 resume (wording provenance for older roles; not a Phase-3 source but the established provenance pattern)

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `\resumeTopic{Name}{Claim}` + nested `\resumeItemListStart/\resumeItem` (main.tex Adobe block) — the topic-group shape D-01/D-02 keep; governance group reuses it
- `scripts/verify-phase2-regressions.sh` — pattern for standing content-regression assertions (P2.x namespace, squeezed-stream + raw-line dual checks); Phase 3 may add P3.x assertions for its own locked literals using the same shape
- Harness self-test `make verify-selftest` — run after content edits to prove G7.2 stays armed (7.0pt margin)

### Established Patterns
- Edit → `make build` → `bash scripts/verify-resume.sh` → read RESULT lines; re-measure G3.2 headroom after every batch (budget arithmetic is measured, never predicted — Phase 2's core lesson)
- Frozen-string discipline: title/date/employer lines untouchable (G5.1/G5.2/G5.5 at exactly 1); bullets are free text
- Wrap-proof literal assertions: multi-word literals checked against whitespace-squeezed stream, short tokens against raw lines
- Artifacts ride in the source commit (`.pdf`, `.log`, `.fdb_latexmk` together) so every commit passes G0.3 on fresh checkout
- Descriptor-unique anchors beat vacuous token checks (bare `C++` was already ×2 from page 2; `C++ graph algorithms` is the load-bearing anchor)

### Integration Points
- `docs/main.tex:146-167` — Adobe block rewrite site (lead + topics + new governance group)
- `docs/main.tex:169-195` — Swiggy/Flipkart line-neutral edits
- `Makefile` — new target (or `verify` chaining) for `verify-phase2-regressions.sh` (IG-01 closure; keep `--skip-freshness` out of the Makefile)
- `docs/verify/manifest.txt` KEYWORDS_TARGET — any target keyword the rebuild lands (torch.compile, A100, H100…) must be promoted to KEYWORDS_REQUIRED in the same commit that adds it (manifest's own promotion rule)

</code_context>

<specifics>
## Specific Ideas

- Lead-bullet voice target: fault-tolerance/distributed-inference language replacing "Leading parts of the org's MLOps platform…" — criterion 2 requires the block to *open* on it, not merely contain it.
- Ray-benchmark phrasing must survive an interview probe: "his AIDE module benchmarked on the Ray Data engine (1×p4d.24xlarge, 8×A100, 16 fractional-GPU actors, 1.09M rows)" — the engine and the benchmark doc are Joel C.'s; the module is his.
- Content Gate group should carry the idempotent claim/receipt + manifest-after-data publication vocabulary — that's the "fault-tolerant distributed systems in Rust" evidence EXP-02 names.
- The retain/revise/retire record (criterion 1) is a plan artifact, not a main.tex artifact — a table in the plan or SUMMARY listing each current bullet and its disposition, written BEFORE new text.

</specifics>

<deferred>
## Deferred Ideas

- CUDA-graphs claim upgrade beyond the compiler-bridge phrasing — only if the D-08 config read confirms and Phase 5's skills work wants it (PG2-04's `CUDA graphs` exact-match form is Phase 5's).
- Groupon/NetSpeed descriptor re-compression — sanctioned lever, but pull it ONLY if the Adobe rebuild measurably runs out of room (D-11); protected by P2 regression assertions either way.

</deferred>

---

*Phase: 3-Adobe Rebuild & Staff-Signal Bullets*
*Context gathered: 2026-08-22*
