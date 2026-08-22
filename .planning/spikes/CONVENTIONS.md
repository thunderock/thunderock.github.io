# Spike Conventions

Patterns and stack choices established across spike sessions. New spikes follow these unless the question requires otherwise.

## Stack

- GitHub analysis via `gh api` + inline `python3` scoring scripts; artifacts as JSON next to the spike README

## Structure

- Spike dirs hold `README.md` (frontmatter + investigation trail) plus data artifacts (`repos_raw.json` = raw API dump, `scored.json` = distilled ranking); wrap-up copies only the distilled artifacts into the skill's `sources/`

## Patterns

- Personal-account GitHub reads use per-command `GH_TOKEN=$(gh auth token -u thunderock)` — never `gh auth switch`; the global active account stays work
- Spikes against external accounts/services stay read-only; mutations (privatize, README edits) are recorded as milestone requirements instead
- Resume-facing claims are drafted only from verified artifact facts (tree contents, commit/test counts) — never from README self-descriptions, which spike 001 proved can both oversell (random_walk) and undersell (rollout)
- Decision spikes end with a `question` checkpoint whose answer is recorded as DECIDED lines in MANIFEST Requirements

## Tools & Libraries

- `gh` CLI (both accounts in keyring), python3 stdlib json — no extra deps
