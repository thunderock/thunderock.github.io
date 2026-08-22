# Requirements: thunderock.github.io — Milestone v1.0 Staff MLE Resume Optimization

**Defined:** 2026-08-21
**Core Value:** The resume gets past ATS keyword screens and recruiter scans for Staff MLE / inference-framework roles — every claim on it interview-defensible.

## v1 Requirements

Requirements for milestone v1.0. Each maps to roadmap phases.

### Verification Harness

- [ ] **VERIFY-01**: `make verify` fails when the PDF ≠ 2 pages or Experience content crosses the page-1 boundary (the LaTeX build is otherwise silent on overflow — page count is the only reliable gate)
- [ ] **VERIFY-02**: `make verify` asserts ATS text-layer integrity via pdftotext round-trip — required keywords present, LinkedIn handle extracts correctly, no glyph/ligature corruption
- [ ] **VERIFY-03**: `make verify` asserts honesty gates — all employment date strings and titles byte-identical to the recorded baseline

### Experience (Page 1)

- [ ] **EXP-01**: Career-break entry removed; Experience runs Swiggy → Adobe (Education section carries the master's dates)
- [ ] **EXP-02**: Adobe section rebuilt leading with fault-tolerance + distributed-inference language (Tier-1 keyword family: 63% normalized DF, 92% of surveyed companies)
- [ ] **EXP-03**: `torch.compile(mode="max-autotune")` production claim present with compiler-bridge phrasing (honestly earns CUDA graphs / Triton / kernel fusion per official PyTorch docs)
- [ ] **EXP-04**: Both unverified page-1 numbers ("10–50× faster image loading", "3–8K images/sec on 32 GPUs") replaced with evidence-backed figures from `.planning/research/CODEBASE-EVIDENCE.md`: 1.09M-row / 8×A100 Ray benchmark, 24×A100-40GB × 9 model queues, 64-H100 enrichment wave, 202.6M-row resumable migration, 24.8M video clips, ~700M-asset catalog (+35–38M/month), 40-node daily EMR
- [ ] **EXP-05**: Groupon + NetSpeed folded into a compact earlier-experience block (~8 lines freed); NetSpeed retains C++/Network-on-Chip wording as C++ evidence
- [ ] **EXP-06**: LinkedIn en-dash defect fixed (handle currently extracts as `ashutosh–tiwari`); portfolio URL present as literal text in the text layer
- [ ] **EXP-07**: Swiggy/Flipkart bullets tightened to staff-signal formulas (adoption-count + failure-class-closure slots)
- [ ] **EXP-08**: Cost-savings + mentoring/leadership bullets drafted with provisional figures, explicitly ⚠-flagged as UNVERIFIED, and shipped only after user's explicit sign-off at a checkpoint (never silently)

### Page 2 Restructure

- [ ] **PG2-01**: Projects section = `rollout` + `graph_ml` exactly, using spike Variant A LaTeX drafts (see `.opencode/skills/spike-findings-thunderock-github-io/references/projects-section.md`)
- [ ] **PG2-02**: Publication entry trimmed to citation + one-line contribution (abstract paragraph cut)
- [ ] **PG2-03**: Research/Teaching sections compressed; Education tightened (institution-before-city parse-order fix, GPAs dropped)
- [ ] **PG2-04**: Skills section rebuilt on keyword tiers with exact-match forms (`vLLM`, `torch.compile`, `Kubernetes`, `FSDP`, `Ray`, `ONNX Runtime`, `A100`/`H100`, `CUDA graphs`, `Triton`, `Rust`, `C++`, `PyTorch Lightning`, `Flash Attention`, `KEDA`, `Spark`, `Iceberg`)
- [ ] **PG2-05**: Explicitly-labeled concept-vocabulary Skills group (tensor parallelism, pipeline parallelism, Mixture of Experts (MoE) parallelism, KV-cache management, continuous batching); `speculative decoding` and `Go` appear nowhere on the document
- [ ] **PG2-06**: C++ claim evidenced via NetSpeed NoC modules + graph_ml C++/Cython kernels in skills phrasing

### GitHub Presence

- [ ] **GH-01**: `random_walk` repo privatized (`gh api -X PATCH` with personal token)
- [ ] **GH-02**: `rollout` README status line fixed to reflect actual implemented state (currently says "spec / pre-implementation"; tree shows 18 crates, 197 test paths, CI)
- [ ] **GH-03**: `rollout` capability wording confirmed with user before the resume ships (must survive "walk me through it")

### Visual

- [ ] **VIS-01**: 2–3 accent-palette proposals rendered as side-by-side PDF samples meeting WCAG ≥7:1 text / ≥3:1 rules / ≥4.5:1 grayscale; user picks (teal stays if none win); chosen palette applied (2 hex literals; dead `accentlight` definition cleaned up)

### Site Sync

- [ ] **SITE-01**: `index.html` hero/about text synced with the new resume positioning
- [ ] **SITE-02**: Site's own career-break timeline entry (index.html:207-225) removed for resume/site consistency

## v2 Requirements

Deferred to future milestones. Tracked but not in current roadmap.

### Credibility Levers

- **CRED-01**: One merged upstream OSS PR to vLLM or SGLang (unlocks "open-source contributions to inference frameworks" — 7/24 companies name it)
- **CRED-02**: Live ATS scan (Jobscan or recruiter-side Lever/Greenhouse test) of the final PDF
- **CRED-03**: LinkedIn profile rewrite synced with resume positioning (currently unknown state; minimum action this milestone = no new contradictions)

### Portfolio

- **PORT-01**: Full portfolio site content refresh beyond hero/about

## Out of Scope

| Feature | Reason |
|---------|--------|
| Speculative decoding (anywhere) | Inapplicable to non-autoregressive models; highest interview-risk-per-ATS-point term in corpus |
| Go (anywhere) | User has never used Go — zero defensibility |
| TensorRT-LLM / TRT-LLM claims | No evidence, no hands-on spike done; skills-stretch boundary excludes it |
| Summary/headline section | User chose fold-only; freed lines fund the Adobe rebuild instead |
| Any employment date or title change | Honesty hard gate; byte-identical assertion in VERIFY-03 |
| Fabricated cost/mentoring numbers shipping without review | EXP-08 requires explicit user sign-off checkpoint |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| VERIFY-01 | Phase 1 | Pending |
| VERIFY-02 | Phase 1 | Pending |
| VERIFY-03 | Phase 1 | Pending |
| EXP-01 | Phase 2 | Pending |
| EXP-05 | Phase 2 | Pending |
| EXP-06 | Phase 2 | Pending |
| EXP-02 | Phase 3 | Pending |
| EXP-03 | Phase 3 | Pending |
| EXP-04 | Phase 3 | Pending |
| EXP-07 | Phase 3 | Pending |
| EXP-08 | Phase 3 | Pending |
| PG2-01 | Phase 4 | Pending |
| PG2-02 | Phase 4 | Pending |
| PG2-03 | Phase 4 | Pending |
| GH-01 | Phase 4 | Pending |
| GH-02 | Phase 4 | Pending |
| GH-03 | Phase 4 | Pending |
| PG2-04 | Phase 5 | Pending |
| PG2-05 | Phase 5 | Pending |
| PG2-06 | Phase 5 | Pending |
| VIS-01 | Phase 6 | Pending |
| SITE-01 | Phase 6 | Pending |
| SITE-02 | Phase 6 | Pending |

**Coverage:**
- v1 requirements: 23 total
- Mapped to phases: 23
- Unmapped: 0 ✓

> **Count correction (roadmap creation, 2026-08-21):** this section previously read "21 total". The v1 list enumerates **23** requirement IDs — 3 VERIFY + 8 EXP + 6 PG2 + 3 GH + 1 VIS + 2 SITE = 23. The ID list is authoritative; the earlier total was an arithmetic error. No requirements were added or removed.

**Phase distribution:** Phase 1 → 3 · Phase 2 → 3 · Phase 3 → 5 · Phase 4 → 6 · Phase 5 → 3 · Phase 6 → 3

---
*Requirements defined: 2026-08-21*
*Last updated: 2026-08-21 after roadmap creation (traceability populated, 23/23 mapped)*
