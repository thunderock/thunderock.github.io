---
name: spike-findings-thunderock-github-io
description: Implementation blueprint from spike experiments. Requirements, proven patterns, and verified knowledge for building thunderock.github.io (Staff MLE resume optimization — Projects section + GitHub presence). Auto-loaded during implementation work.
---

<context>
## Project: thunderock.github.io

Audit of the `thunderock` personal GitHub account turned into concrete, user-approved recommendations for the resume's Selected Projects section (page 2), optimized for Staff MLE / inference-framework profiles. Milestone research had flagged the 7-item grad-school Projects section as the resume's biggest anti-feature; the spikes replaced guesswork with a ranked repo inventory and a decided section layout.

Spike sessions wrapped: 2026-08-21
</context>

<requirements>
## Requirements

- Read-only GitHub access during analysis; never switch the global `gh` active account (per-command `GH_TOKEN=$(gh auth token -u thunderock)`)
- Recommendations respect the milestone honesty boundary (claims match repo reality) and page-2 line budget (~53.5pt slack)
- Only public repos can be featured on the resume (recruiters must be able to click through)
- DECIDED (spike 002): Projects section = rollout + graph_ml (Variant A); ~5 lines
- DECIDED (spike 002): privatize `random_walk` during milestone build
- Prerequisite: fix rollout README stale "pre-implementation" status line before resume ships
- Prerequisite: user confirms rollout capability wording (survives "walk me through it")
- inferno/dynamite/pulse remain private (internal Adobe refs); skills-tier interview material only
</requirements>

<findings_index>
## Feature Areas

| Area | Reference | Key Finding |
|------|-----------|-------------|
| Projects Section | references/projects-section.md | rollout (Rust multi-node LLM-RL framework, vLLM backend, 197 test files) + graph_ml (only public C++ evidence) replace 7 grad projects; LaTeX drafts ready; random_walk privatized; README self-descriptions proven unreliable both directions |

## Source Files

Original spike source files are preserved in `sources/` for complete reference (incl. the full ranked repo scoring in `sources/001-github-repo-audit/scored.json`).
</findings_index>

<metadata>
## Processed Spikes

- 001-github-repo-audit
- 002-projects-section-reco
</metadata>
