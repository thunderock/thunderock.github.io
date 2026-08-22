# Spike Manifest

## Idea

Audit Ashutosh's personal GitHub (`thunderock`) and turn the findings into concrete recommendations for the resume's Selected Projects section (page 2), optimized for Staff MLE / inference-framework profiles. Milestone research already flagged the current 7-item grad-school Projects section as the resume's biggest anti-feature (~22 lines at 10 YoE) — this spike decides, with evidence, what replaces it: which repos earn space, what the bullets say, or whether the section shrinks/dies. Read-only against GitHub (personal account token via `gh auth token -u thunderock`); no pushes.

## Requirements

- Read-only GitHub access; never switch the global `gh` active account (use per-command `GH_TOKEN`)
- Recommendations must respect the milestone honesty boundary (claims match repo reality) and page-2 line budget (~53.5pt slack; Projects currently ~22 lines)
- Private repos may inform analysis but only public repos can be recommended for the resume (recruiters must be able to click through)
- "Cut the section entirely" must be evaluated honestly, not assumed away
- DECIDED (spike 002): Projects section = rollout + graph_ml (Variant A); ~5 lines
- DECIDED (spike 002): privatize `random_walk` during milestone build (spike stayed read-only)
- Prerequisite: fix rollout README stale "pre-implementation" status line before resume ships
- Prerequisite: user confirms rollout capability wording (survives "walk me through it")
- inferno/dynamite/pulse remain private (internal refs); skills-tier interview material only

## Spikes

| # | Name | Type | Validates | Verdict | Tags |
|---|------|------|-----------|---------|------|
| 001 | github-repo-audit | standard | Given the thunderock account, when every repo (+ external PR contributions) is inventoried and scored against staff-MLE/inference criteria, then a ranked shortlist with per-repo evidence exists | VALIDATED | github, resume, audit |
| 002 | projects-section-reco | standard | Given the ranked shortlist + milestone research, when Projects-section variants are drafted with line costs, then 2-3 concrete recommendations are presented side-by-side vs current | VALIDATED | resume, projects, latex |
