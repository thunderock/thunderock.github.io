# Spike Wrap-Up Summary

**Date:** 2026-08-21
**Spikes processed:** 2
**Feature areas:** Projects Section (resume + GitHub presence)
**Skill output:** `./.opencode/skills/spike-findings-thunderock-github-io/`

## Processed Spikes

| # | Name | Type | Verdict | Feature Area |
|---|------|------|---------|--------------|
| 001 | github-repo-audit | standard | VALIDATED | Projects Section |
| 002 | projects-section-reco | standard | VALIDATED | Projects Section |

## Key Findings

- 98-repo inventory (63 public / 35 private / 33 forks / 3 archived) scored against staff-MLE/inference criteria; ranked output in `scored.json`.
- Flagship discovery: `rollout` — Rust multi-node LLM-RL framework (18 crates incl. a vLLM backend, actor/learner split, CRIU snapshots, 263 commits, 197 test paths, CI, active Jun 2026) — absent from the resume while 7 weaker 2017-2022 grad projects occupied the section.
- `graph_ml` closes the C++ Tier-1 keyword gap (only public C++ evidence on the account).
- DECIDED: Projects section = rollout + graph_ml (Variant A, ~5 lines, frees ~9 page-2 lines); LaTeX bullet drafts ready in the skill reference.
- DECIDED: privatize `random_walk` (overselling description on a 3-commit empty repo — click-through liability).
- Prerequisites recorded: rollout README status-line fix; user confirms rollout capability wording.
- `inferno`/`dynamite`/`pulse` are on-JD but IP-flagged (Pluto/`GLIMMER_DB`) — interview talking points only, never featured.
- Zero external infra-OSS PRs — STACK.md's "one merged vLLM/SGLang PR" lever remains open.
- Pattern proven twice: README self-descriptions are unreliable (random_walk oversells, rollout undersells) — resume claims must come from verified artifact facts.
