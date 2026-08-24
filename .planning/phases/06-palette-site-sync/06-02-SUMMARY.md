---
phase: 06-palette-site-sync
plan: 02
subsystem: public-site
tags: [site-sync, index.html, honesty-boundary, content-edit]
status: complete
requires:
  - "docs/main.tex finalized résumé (source of truth the site mirrors)"
  - ".planning/research/CODEBASE-EVIDENCE.md honest-framing rules"
provides:
  - "index.html synced to the rebuilt résumé (Adobe voice, Projects, Education, career-break)"
affects:
  - "the live public GitHub Pages site (on the owner's next push to master)"
tech-stack:
  added: []
  patterns:
    - "container-scoped HTML content edits (no CSS/layout change)"
    - "anchor-based programmatic deletion of whole Bootstrap section rows"
key-files:
  created: []
  modified:
    - "index.html"
decisions:
  - "Mirrored the résumé Adobe block at the generalized public register (D-08/D-09): no hard fleet/throughput numbers; torch.compile(max-autotune) framed as a compiler bridge (compiler-generated Triton kernels — never 'wrote Triton kernels'); Rust governance/lineage subsystem named."
  - "Dropped the site's 'Patna' city and both GPAs; kept the site's 'B-Tech (Computer Science & Engineering)' degree wording (not a résumé contradiction) per the plan's flagged ASSUMPTION (drop-city, keep-degree-wording)."
metrics:
  duration: "~20m"
  completed: "2026-08-24"
actuals:
  tokens: 7400
  tasks: 3
  commits: 3
---

# Phase 6 Plan 02: Site Content Sync (index.html) Summary

Resynced the public portfolio (`index.html`) to the rebuilt résumé — Adobe block rewritten to the fault-tolerance / distributed-inference / torch.compile / Rust-governance voice at the generalized public register, both retired page-1 figures byte-removed, Education mirrored, Projects replaced with `rollout` + `graph_ml`, the two off-message grad-era sections pruned, and the site's own career-break entry removed. Content-only edits inside existing containers; no CSS/layout change; `docs/main.tex` byte-unchanged.

## What was built

### Task 1 — Adobe block rewrite + retired-figure strip (commit e9bd863)
Rewrote the Adobe timeline-item's `<ul>` bullets in place (container/markup untouched):
- **Lead** now reads fault-tolerant distributed inference and training infrastructure surviving node loss / partial failure.
- Online inference on **vLLM + Ray** for **Falcon-40B** and **Llama 2 70B** (both kept per D-08); offline on **Ray Data + PyTorch Lightning** introducing **torch.compile(mode="max-autotune")** as a compiler bridge (compiler-generated Triton kernels, operator fusion, CUDA-graph capture — compiler-mediated, never "wrote Triton kernels").
- Source → Transform → Sink plugins **KEDA-autoscaled on SQS**; **FSDP/FSDP2 + Flash Attention 2/3** training framework; Rust control plane + MCP build/deploy system; **Rust training-data governance/lineage** subsystem; **Cerberus** data-quality framework.
- **Byte-removed** the sentence carrying `3–8K images/sec on 32 GPUs` and `10–50×`.
- Generalized public register (D-09): no hard fleet/throughput numbers; kept generalized "billions of images and videos" + stack nouns.

### Task 2 — Education mirror + hero/about sweep (commit 662a516)
- Deleted `<p><b>GPA - 3.87/4.0</b></p>` and `<p><b>CGPA - 8.32/10.0</b></p>`.
- `Indiana University, Bloomington` → `Indiana University` (Education heading **and** the `#about` paragraph).
- `National Institute of Technology, Patna` → `National Institute of Technology`.
- B-Tech range `Jul 2011 - Jun 2015` → `Aug 2011 – May 2015` (en dash U+2013).
- Master's date row `Aug 2021 - May 2023` preserved.

### Task 3 — Projects replace + prune + career-break removal (commit 7e4dea7)
- Replaced the 8 grad-school `col-md-4` cards (BiasNet, Bias Manifolds, BlindNet, DeepFoodie, Flipkart Hackday, Groupon Geekon, Continuous Dominant Set, Snake and Ladders) with exactly **two** cards — **rollout** then **graph_ml** — each linking its repo and carrying the résumé's Selected-Projects capability wording (adapted to the card shell).
- Deleted the **Competitive D.S. Experience** section whole (`div.row.alternate_row`, 6 hackathon cards).
- Deleted the **Certifications** section whole (`div.row` "Online Section": Udacity / IISc / School of AI / Udemy).
- Deleted the **Career Break — Master's Degree** timeline item; Experience now runs Adobe → Swiggy → Flipkart → Groupon → Netspeed with no dangling item.
- Research (3 entries) and Teaching (3 items) left byte-unchanged.

## Exact byte-removals / additions
- Removed: `3–8K images/sec on 32 GPUs`, `10–50×`, `GPA - 3.87/4.0`, `CGPA - 8.32/10.0`, `, Bloomington` (×2), `, Patna`, `Career Break — Master's Degree` item, Competitive D.S. Experience section, Certifications section, 8 grad-project cards.
- Added: `github.com/thunderock/rollout` card, `github.com/thunderock/graph_ml` card, torch.compile / Rust-governance Adobe bullets, `Aug 2011 – May 2015`.

## Final grep verification (all pass)
| Check | Expected | Actual |
|-------|----------|--------|
| `3–8K images/sec` | 0 | 0 |
| `10–50×` | 0 | 0 |
| `torch.compile` | ≥1 | 1 |
| `Falcon-40B` / `Llama 2 70B` | ≥1 | 1 / 1 |
| `3.87` / `8.32` | 0 | 0 / 0 |
| `Aug 2011 – May 2015` | ≥1 | 1 |
| `Senior Machine Learning Engineer` | 3 | 3 |
| `github.com/thunderock/rollout` / `.../graph_ml` | ≥1 | 1 / 1 (rollout before graph_ml) |
| `Competitive D.S. Experience` / `Certifications` / `Career Break` | 0 | 0 / 0 / 0 |
| `Bloomington` | 0 | 0 |
| all 8 grad-project titles | 0 | 0 each |
| prohibited terms (speculative decoding / TensorRT / MoE-TP-PP) | 0 | 0 |
| `<div>`/`</div>` balance | equal | 96 / 96 |
| `git diff --quiet docs/main.tex` | clean | clean (byte-unchanged) |

## Deviations from Plan
None — plan executed exactly as written. The flagged Education ASSUMPTION was resolved as specified (drop `, Patna` city, keep `B-Tech (Computer Science & Engineering)` degree wording).

## Notes for 06-03
- index.html is left in the state 06-03's site-sync regression net expects: retired figures / career-break / GPAs / Competitive / Certifications gone; `rollout` + `graph_ml` present; `torch.compile`, `Falcon-40B`, `Aug 2011 – May 2015` present.
- **SITE-01 / SITE-02 are NOT ticked here** — they tick at 06-03 (last-plan precedent), which also asserts these invariants in the net.
- No push happened; the sync goes public only on the owner's push to `master`.

## Self-Check: PASSED
- index.html modified across 3 atomic commits (e9bd863, 662a516, 7e4dea7) — all present in git log.
- 06-02-SUMMARY.md created on disk.
