---
spike: 002
name: projects-section-reco
type: standard
validates: "Given the ranked shortlist + milestone research, when Projects-section variants are drafted with line costs, then 2-3 concrete recommendations are presented side-by-side vs current"
verdict: VALIDATED
related: [001]
tags: [resume, projects, latex]
---

# Spike 002: Projects Section Recommendations

## What This Validates

Given spike 001's ranked shortlist and the milestone research (FEATURES.md anti-feature warning: 7 grad projects at 10 YoE; ARCHITECTURE.md page-2 budget), when Projects-section variants are drafted with line costs and honest bullet wording, then concrete pick-one recommendations exist.

## Current State (main.tex:281-314)

7 entries, ~14 rendered lines + heading (~160pt of page 2): BiasNet, DeepFoodie (ARCHIVED), BlindNet, CDSproject, Humana-Mays, AnalyticsVidhya, bias_manifold. All 2017–2022 course/competition work. Zero overlap with the inference-framework narrative; DeepFoodie is an archived repo; AnalyticsVidhya has no bullet at all.

## Recommendations

### Variant A — Flagship + Kernels (RECOMMENDED)

2 entries, ~5 rendered lines (frees ~9 lines of page-2 space):

```latex
\resumeProjectHeading
    {\textbf{rollout} $|$ \emph{Rust, Distributed Training \& Inference, RL for LLMs, vLLM, PyO3, Postgres}}{\href{https://github.com/thunderock/rollout}{\underline{github.com/thunderock/rollout}}}
    \resumeItemListStart
      \resumeItem{Multi-node reinforcement-learning framework for LLMs in Rust (18 crates, 197 test files, CI): PPO/GRPO/DPO/SFT/RM algorithms, vLLM-backed batch + online inference, actor/learner split with work-stealing, training-state and CRIU process snapshots, PyO3 in-process plugins.}
    \resumeItemListEnd
\resumeProjectHeading
    {\textbf{graph\_ml} $|$ \emph{Python, PyTorch Geometric, C++/Cython}}{\href{https://github.com/thunderock/graph_ml}{\underline{github.com/thunderock/graph_ml}}}
    \resumeItemListStart
      \resumeItem{sklearn-style Graph-ML library on PyTorch/PyTorch Geometric with optimized C++/Cython random-walk kernels; CI-tested.}
    \resumeItemListEnd
```

Keywords landed (STACK.md tiers): **Rust**, **C++** (Tier-1 gap!), vLLM, distributed, reinforcement learning, PyTorch, fault tolerance (snapshots), CI/testing culture.

### Variant B — A + Research Thread

Variant A + keep **BiasNet** (1 entry, 2 lines): "Reinforcement Learning for Street Fighter II with GNN-induced relational bias — Actor-Critic, PyTorch." Preserves an RL-continuity story (grad RL project → rollout) and one visual/fun hook. Cost: 2 lines, weaker substance signal.

### Variant C — Cut Section Entirely (evaluated, NOT recommended)

Rejected on evidence: `rollout` + `graph_ml` are current (2024–2026), public, differentiated, and land the two hardest Tier-1 keyword gaps (Rust systems + C++) that Experience bullets can't cover with personal artifacts. Cutting wastes the account's only staff-signal projects. FEATURES.md's "cut projects" advice targeted the *grad-school* projects, which A/B do cut.

## Prerequisites (become milestone requirements if A or B chosen)

1. **Fix `rollout` README status line** — currently says "spec / pre-implementation"; tree contradicts it (implemented crates, tests, CI). A recruiter clicking through must not read "pre-implementation" under a featured project. Reword to reflect actual state honestly (e.g., "v1 core implemented; N crates, tests in CI; UI deferred").
2. **User confirms `rollout` capability wording** — which v1 table rows are complete vs in-progress; bullet must survive "walk me through it" (honesty boundary).
3. **`random_walk` cleanup** — privatize, delete, or point description at `graph_ml` (its description promises what `graph_ml` actually contains; empty repo = credibility hit one click from a featured repo).
4. Private repos (`inferno`/`dynamite`/`pulse`) stay private; usable only as skills-tier interview talking points (vLLM tensor-parallel operation, Ray Data inference) — never resume-featured while carrying internal references.

## Investigation Trail

1. Counted current section cost from main.tex:281-314 (7 headings, 6 with 1-line bullets, 1 bare).
2. Drafted rollout bullet from verified tree facts only (crate list, test-path count, CI, algorithms named in README v1 table) — avoided throughput/perf claims (none verified).
3. Checked redundancy: residual2vec_ already hyperlinked from Publications (main.tex:228) — featuring in Projects would duplicate; excluded from all variants.
4. Line costs use ARCHITECTURE.md's measured 11.5pt/line; page-2 slack (53.5pt) unaffected by all variants (all shrink the section).

## Results

**Verdict: VALIDATED** — user selected **Variant A** (rollout + graph_ml, ~5 lines, frees ~9 page-2 lines) and **privatize `random_walk`**.

Decisions recorded as milestone requirements:
1. Projects section = rollout + graph_ml exactly (LaTeX drafts above are the starting text)
2. `random_walk` gets privatized (mutation deferred to milestone build — spike stayed read-only)
3. rollout README status-line fix is a prerequisite before the resume ships
4. User must confirm rollout capability wording during the rewrite phase
5. inferno/dynamite/pulse stay private; skills-tier talking points only
