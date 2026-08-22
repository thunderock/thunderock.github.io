---
spike: 001
name: github-repo-audit
type: standard
validates: "Given the thunderock account, when every repo (+ external PR contributions) is inventoried and scored against staff-MLE/inference criteria, then a ranked shortlist with per-repo evidence exists"
verdict: VALIDATED
related: []
tags: [github, resume, audit]
---

# Spike 001: GitHub Repo Audit

## What This Validates

Given the `thunderock` GitHub account, when every repo (98 total: 63 public / 35 private / 33 forks / 3 archived) plus external merged PRs are inventoried and scored, then a ranked shortlist with per-repo evidence exists for the Projects-section decision.

## How to Run

```bash
GH_TOKEN=$(gh auth token -u thunderock) gh api user/repos --paginate -f affiliation=owner --jq '...' > repos_raw.json
python3 score.py   # produces scored.json (embedded in this dir)
```

Read-only; per-command `GH_TOKEN` — global `gh` active account never switched.

## What to Expect

`repos_raw.json` (full inventory) and `scored.json` (ranked: relevance × substance + public bonus).

## Investigation Trail

1. Full inventory: 98 repos. Non-forks sorted by push date — recent activity is private-heavy (ashutosh_setup, slurm_scripts, myth) but four public 2024-2026 repos stand out.
2. Substance probes (languages, commit counts, README size) on 9 candidates: `random_walk` exposed as near-empty (3 commits, 180 bytes Python) despite a C++/Cython description — a click-through liability, not an asset. `residual2vec_` has 406 commits (the NetSci paper repo). `rollout` has 1.2MB Rust.
3. `rollout` deep-dive: 18 crates (coordinator, transport, storage, snapshots, plugin-host, **backend-vllm**, cloud-aws/gcp, algo-sft/rm, harnesses), 197 test paths, CI, commits through 2026-06-29. README banner falsely says "spec / pre-implementation" — stale; the tree contradicts it.
4. Private trio (`inferno`, `dynamite`, `pulse`): directly on-JD (Ray+vLLM multi-node with tensor parallelism; Ray Data+Lightning inference; DuckDB distributed queues) but READMEs reference Adobe-internal systems (Pluto, `GLIMMER_DB`) and duplicate Adobe Experience bullets → **cannot be featured or published as-is** (IP + redundancy). They DO evidence hands-on vLLM/TP operation for the skills-stretch tier.
5. External merged PRs: 11, all in `skojaku/Biased-Sampling` (research collab) — confirms STACK.md's finding of zero infra-OSS contributions.

## Results

**Verdict: VALIDATED** — ranked shortlist exists with evidence.

| Rank | Repo | Score | Resume-eligible | Key fact |
|------|------|-------|-----------------|----------|
| 1 | `rollout` | 27 | ✓ public | Rust multi-node LLM-RL framework; vLLM backend crate; 263 commits, 197 test paths, CI; pushed Jun 2026 |
| 2 | `graph_ml` | 18 | ✓ public | sklearn-style Graph-ML lib on PyTorch/PyG with C++/Cython kernels + CI — only public C++ evidence |
| 3 | `vector` | 14 | ✓ public | Rust macOS terminal, WGSL GPU renderer; systems breadth, not ML |
| 3 | `residual2vec_` | 14 | ✓ public | NetSci 2023 paper code — already linked from Publications (featuring twice = redundant) |
| 5-7 | `dynamite`/`inferno`/`pulse` | 8/8/6 | ✗ private+IP | On-JD topics; internal refs; duplicate Adobe bullets |
| 8+ | All 7 current resume projects | ≤6 | public | 2017-2022, course/competition work; DeepFoodie archived |

**Surprises:**
- The single best staff-MLE artifact on the account (`rollout`) is absent from the resume, while 7 weaker 2017-2022 projects occupy ~22 lines.
- `random_walk` (public) is a credibility liability: description oversells an empty repo. Recommend: delete, privatize, or backfill (the real implementation lives in `graph_ml`).
- `rollout`'s own README undersells it ("pre-implementation") — needs a status-line fix before being featured anywhere.
- Zero external infra-OSS PRs — the STACK.md "one merged vLLM/SGLang PR" lever remains open.

**Impact on spike 002:** strong evidence AGAINST cutting the Projects section entirely — `rollout` + `graph_ml` are differentiated, current, and on-JD. The recommendation question becomes "which 2-3, and what do the bullets say."
