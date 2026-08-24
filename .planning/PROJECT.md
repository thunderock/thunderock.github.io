# thunderock.github.io — Resume & Portfolio

## What This Is

Ashutosh Tiwari's personal portfolio site (GitHub Pages) and LaTeX resume. The resume (`docs/main.tex` → `docs/AshutoshTiwari.pdf`, built via `make build`) is the primary job-search artifact; `index.html` is the public portfolio face. Both present his ML platform/frameworks engineering career (Adobe Firefly, Swiggy, Flipkart, Groupon, NetSpeed).

## Core Value

The resume gets past ATS keyword screens and recruiter scans for Staff MLE / inference-framework roles — every claim on it interview-defensible.

## Requirements

### Validated

<!-- Inferred from existing repo state. -->

- ✓ LaTeX resume builds reproducibly via `make build` (latexmk, BasicTeX, sourcesanspro)
- ✓ ATS-parsable PDF (`\pdfgentounicode=1`, machine-readable text layer)
- ✓ Two-page structure: Experience on page 1, Publications/Education/Research/Teaching/Projects/Skills on page 2
- ✓ Consistent visual system: teal accent palette (#17685C/#0E463E), small-caps section heads, uniform vertical rhythm
- ✓ Portfolio site live at thunderock.github.io with hero/about/experience sections

### Active

<!-- Milestone v1.0 scope. -->

- [x] Verification harness: page-1 fit, ATS text-layer, honesty invariants machine-enforced (`make verify` / `verify-selftest`) — Validated in Phase 1: Verification Harness
- [x] Career-break entry removed from Experience (Swiggy → Adobe; Education carries the master's) — Validated in Phase 2
- [x] Adobe Firefly section rebuilt on commit-verified evidence, positioned for inference-framework/optimization roles — Validated in Phase 3: Adobe Rebuild & Staff-Signal Bullets (fault-tolerance/distributed-inference lead, Rust governance topic, torch.compile compiler bridge, all figures evidence-traced; EXP-08: 3 drafts rejected, mentoring line approved+shipped)
- [x] Language keyword-optimized against Staff MLE / inference-framework job postings (research-driven) — Validated in Phase 5: Skills Rebuild (page-1 half landed in Phase 3; Skills half now landed — 3-tier taxonomy carrying all 17 exact-match forms incl. ONNX Runtime/H100/CUDA graphs/Iceberg, rendered in ≤3 lines)
- [x] Skills section stretched only to interview-defensible adjacent tech (user approves final list) — Validated in Phase 5: Skills Rebuild (per-item approval checkpoint: 10 stretch items each individually confirmed with a recorded evidence tier — built/operated/evaluated; concept-vocabulary group labeled `Concepts:`; Go/speculative-decoding zero whole-document)
- [x] 2–3 accent palette proposals rendered as PDF samples; user picks (teal stays if none win) — Validated in Phase 6: Palette & Site Sync (navy/oxblood/graphite + teal rendered side-by-side with grayscale, all clearing the WCAG bar; user picked the teal incumbent at the blocking VIS-01 checkpoint, dead `accentlight` definition removed; page 1 byte-frozen)
- [x] `index.html` synced with the finalized resume across all mirrored sections — Validated in Phase 6: Palette & Site Sync (scope expanded beyond hero/about: Adobe block rewritten to the rebuilt-resume voice with retired figures gone, Projects → `rollout`+`graph_ml`, grad-era Competitive/Certifications pruned, career-break entry removed, Education mirrored; a `verify-site-regressions.sh` net wired as `REGRESS6` machine-guards it)
- [x] Experience section still fits page 1 exactly; PDF stays ATS-parsable — Validated through milestone close (page 1 byte-frozen at `798c0fb` across Phases 3–6; final `make verify` green — 2 pages, ATS text layer intact, six regression nets passing)

### Out of Scope

- Fabricated JD keywords as accomplishments (TensorRT/TRT-LLM, CUDA graphs, speculative decoding, MoE/tensor/pipeline parallelism have no commit evidence) — interview risk; bullets stay evidence-true
- Full portfolio site redesign — only hero/about text sync this milestone; bigger refresh deferred
- Changing employment dates or titles — never fabricate; printed title stays truthful
- Cover letters / LinkedIn profile rewrite — separate artifact, separate effort

## Context

- Repo: personal GitHub Pages site, master branch, clean tree.
- Resume owner works as Senior MLE (ML Platform & Frameworks) at Adobe Firefly since Jul 2024; targeting Staff MLE / inference-framework roles (example JD: fault-tolerant high-concurrency distributed inference for text/image/multimodal; MoE/tensor/pipeline parallelism; CUDA graphs; TensorRT/TRT-LLM; torch.compile; speculative decoding).
- Commit-verified accomplishment evidence mined from ~/code/ Adobe repos (orion, genie, colligo, asml-img-data-dags, ff-data-ingestion, ff-data-engineering, fetools) is persisted at `.planning/research/CODEBASE-EVIDENCE.md`. Attribution was email-verified; two other Adobe "Ashutosh"s excluded.
- Strongest evidenced themes: distributed GPU batch inference (SQS-fed, batched, A100/H100 fleets), torch.compile max-autotune in production, ONNX Runtime CUDA EP, FSDP/FSDP2 + Flash Attention + context parallelism (training framework), fault tolerance (lease/TTL heartbeats, DLQs, circuit breakers, idempotent re-runs, checkpoint caches), scale (202.6M-row migration, 24.8M video clips, ~700M-asset catalog, 64-H100 enrichment waves), Rust services (+27k-line governance subsystem).
- Evidence gap (do not claim as accomplishments): TensorRT/TRT-LLM, CUDA graphs, speculative decoding, MoE/TP/PP.

## Constraints

- **Layout**: Experience section must fit page 1 exactly (current `\newpage` boundary) — formatting quality is a hard gate
- **Honesty**: Experience bullets claim only commit-evidenced work; Skills may include adjacent tech the user can defend in interviews, user approves the list
- **Toolchain**: LaTeX via existing Makefile (`make build`); no new build dependencies without need
- **ATS**: PDF must remain machine-parsable (`pdfgentounicode`, no exotic glyph tricks, standard section names)
- **Delivery**: commits stay local; user pushes (never auto-push)

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Delete career-break entry outright (no RA/TA replacement row) | User preference; Education section already shows IU 2021–2023, gap self-explains | — Pending |
| Replace unverified page-1 numbers with evidence-backed figures | "10–50×"/"3–8K images/sec" have no recorded source; verified figures survive interview probing | — Pending |
| Fold Groupon+NetSpeed, no summary section | Freed lines fund the Adobe rebuild; summary would consume ~3-4 of 4.25 freed lines | — Pending |
| Concept-vocabulary skills group, explicitly labeled | Only honest path for tensor/pipeline/MoE parallelism keywords to reach the page | — Pending |
| C++ via NetSpeed NoC + graph_ml kernels; Go omitted everywhere | User confirmation 2026-08-21; never used Go | — Pending |
| Projects = rollout + graph_ml (spike 002 Variant A) | Only current, public, staff-signal artifacts; lands Rust + C++ Tier-1 keywords | — Pending |
| Cost/mentoring bullets: provisional figures behind a sign-off checkpoint | User wants drafts to react to; honesty gate requires explicit approval before ship | — Pending |
| Skills-stretch/bullets-true honesty boundary | Max ATS coverage without interview risk in accomplishments | — Pending |
| Recommendation-first workflow | User iterates on a concrete proposal faster than answering abstract questions | — Pending |
| Milestone scope = resume + site hero text only | Keep milestone shippable; full site refresh deferred | — Pending |

## Current Milestone: v1.0 Staff MLE Resume Optimization

**Goal:** Reposition the resume (and site hero) for Staff MLE / inference-framework roles — career break removed, Adobe section rebuilt on commit-verified evidence, language keyword-optimized against staff-level job postings — while Experience still fits page 1.

**Target features:**
- Career-break entry removed from Experience
- Adobe section rebuilt from mined evidence, inference-framework positioning
- Job-posting language research → keyword-optimized phrasing
- Skills section stretch (interview-defensible only, user-approved)
- Accent palette proposals with rendered PDF samples
- Site hero/about text synced
- Page-1 experience fit + ATS parsability preserved

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-08-24 after Phase 6 (Palette & Site Sync) completion — **milestone v1.0 complete (6/6 phases)**. Palette chosen at the VIS-01 checkpoint (teal incumbent kept, dead `accentlight` removed); `index.html` fully synced to the rebuilt resume with a `REGRESS6` site net; final `make verify` green (2 pages, ATS layer intact, six regression nets passing) and the plain-text paste test approved. Commits are local — the site publishes only on the owner's push to `master`.*
