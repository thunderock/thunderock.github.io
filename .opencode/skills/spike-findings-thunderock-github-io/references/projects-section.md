# Projects Section (Resume + GitHub Presence)

## Requirements

Non-negotiable decisions from spiking — the build MUST honor these:

- Projects section = **rollout + graph_ml exactly** (Variant A, user-selected). ~5 rendered lines; frees ~9 page-2 lines vs the current 7-entry section.
- Only public repos may be featured (recruiters must click through). `inferno`/`dynamite`/`pulse` stay private — internal Adobe references (Pluto, `GLIMMER_DB`); usable ONLY as skills-tier interview talking points.
- Honesty boundary: bullet claims come from verified artifact facts (tree contents, crate list, test counts, CI), never from README self-descriptions.
- `random_walk` gets **privatized** during the build (user-selected; mutation was deferred — spikes stayed read-only). Command: `GH_TOKEN=$(gh auth token -u thunderock) gh api -X PATCH repos/thunderock/random_walk -f private=true`
- Prerequisite before the resume ships: fix `rollout` README's stale "spec / pre-implementation" status line (tree contradicts it: implemented crates, 197 test paths, CI). A recruiter must not read "pre-implementation" under a featured project.
- Prerequisite: user confirms rollout capability wording (must survive "walk me through it").
- Page-2 budget: all variants shrink the section; ~53.5pt slack unaffected. Line cost model: 11.5pt/line (measured in milestone ARCHITECTURE.md).

## How to Build It

Replace main.tex:281-314 (`\section{Selected Projects}` body, 7 entries) with exactly two entries. Starting LaTeX (drafted from verified facts, ready to drop in):

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

Keyword coverage this lands (per milestone STACK.md tiers): **Rust**, **C++ (Tier-1 gap — only public evidence on the account)**, vLLM, distributed, reinforcement learning, PyTorch, fault tolerance (snapshots), testing/CI culture.

Verified facts backing the rollout bullet (from spike 001 deep-dive, GitHub API):
- 18 crates incl. `rollout-backend-vllm`, `rollout-coordinator`, `rollout-transport`, `rollout-storage`, `rollout-snapshots`, `rollout-plugin-host`, `rollout-cloud-aws`/`gcp`, `rollout-algo-sft`/`rm`, harnesses (text/tool/eval)
- 263 commits, 197 test-path entries, GitHub Actions CI, last push 2026-06-30, ★4
- Languages: Rust 1.23MB, Python 33KB

Verified facts backing graph_ml: 128 commits, Python 22.7KB + C++ 5.5KB + Cython 1.8KB, CI badge, ★2, pushed 2024-10-14.

GitHub reads use per-command token, never account switch: `GH_TOKEN=$(gh auth token -u thunderock) gh api ...`

## What to Avoid

- **Do NOT feature `residual2vec_`** (406 commits, the NetSci paper repo) — already hyperlinked from the Publications section (main.tex:228); featuring twice reads as padding.
- **Do NOT trust README self-descriptions** — proven unreliable in both directions: `random_walk` oversells an empty repo (3 commits, 180 bytes); `rollout` undersells implemented code ("pre-implementation" banner).
- **Do NOT add throughput/perf numbers to rollout bullets** — none are verified; spike deliberately excluded them.
- **Do NOT publish or reference inferno/dynamite/pulse** — on-JD topics but internal refs + duplicate Adobe Experience bullets (redundancy + IP).
- **Do NOT keep**: DeepFoodie (archived repo), AnalyticsVidhya (bullet-less), Humana-Mays/BlindNet/CDSproject/bias_manifold/BiasNet — 2017-2022 course/competition work; the milestone research flagged exactly this as the top anti-feature at 10 YoE. (BiasNet was offered as Variant B; user chose A.)
- Zero external infra-OSS PRs exist (11 merged PRs, all in the research collab `skojaku/Biased-Sampling`) — do not claim OSS contributions; the "one merged vLLM/SGLang PR" lever from STACK.md remains open as future work.

## Constraints

- Account inventory (2026-08-21): 98 repos — 63 public / 35 private / 33 forks / 3 archived. Full ranked scoring in `sources/001-github-repo-audit/scored.json`.
- gh keyring holds both accounts; `thunderock` is NOT the active account — always per-command `GH_TOKEN`.
- GitHub mutations (privatize, README edits on rollout) are milestone-build actions, not spike actions.
- Resume layout: `\resumeProjectHeading` + single `\resumeItem` ≈ 2.5 lines/entry; page-2 slack ~53.5pt.

## Origin

Synthesized from spikes: 001, 002
Source files available in: sources/001-github-repo-audit/, sources/002-projects-section-reco/
