# Phase 4: Page-2 Restructure & GitHub Presence - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-08-23
**Phase:** 4-page-2-restructure-github-presence
**Areas discussed:** GitHub mutations, rollout wording (GH-03), Text compression, Education

---

## GitHub mutations — execution method (initial ask)

| Option | Description | Selected |
|--------|-------------|----------|
| You run via ! in-session | I prep exact commands/diff; you paste with `!` | |
| I run with per-command token | I run `gh api` during execute-phase | |
| You handle out-of-band | I only produce commands + diff | |

**User's choice:** "isnt random walk public? Dont need to change anything on github...only change my resume"
**Notes:** Triggered a scope-clarification — the answer conflicted with the rollout-README selection below.

## random_walk action (GH-01)

| Option | Description | Selected |
|--------|-------------|----------|
| Privatize it | PATCH private=true → 404 to anonymous | |
| Privatize + interview note | + keep C++/Cython as interview talking point | |
| Leave public, clean README | keep public, rewrite overselling README | |

**User's choice:** "dont do anything"
**Notes:** random_walk is not linked from the resume; leaving it public has no click-through impact. Confirmed left untouched.

## rollout bullet wording (GH-03, resume side)

| Option | Description | Selected |
|--------|-------------|----------|
| Ship as-is | spike draft, all facts verified from tree | ✓ |
| Trim it shorter | drop some algorithm/mechanism enumeration | |
| Let me adjust it | free-text wording | |

**User's choice:** Ship as-is
**Notes:** The "walk me through it" checkpoint (GH-03) is satisfied on the resume side — wording approved.

## rollout README status line (GH-02) + scope resolution

Initial selection was "State implemented v1", which conflicted with "only change my resume". Resolved with a follow-up:

| Option | Description | Selected |
|--------|-------------|----------|
| Resume only, no GitHub | leave random_walk public + rollout README as-is; GH-01/02/03 → deferred | ✓ |
| Fix rollout README only | fix the one contradicting line; random_walk untouched | |
| Both GitHub fixes | README + privatize (full spike/roadmap plan) | |

**User's choice:** Resume only, no GitHub (exec method: N/A — resume only)
**Notes:** GH-01 + GH-02 deferred by owner decision. Accepted, documented trade-off: the featured `rollout` link still reads "spec / pre-implementation". Ready commands/diff preserved in CONTEXT.md Deferred Ideas.

## Text compression — Publication (PG2-02)

| Option | Description | Selected |
|--------|-------------|----------|
| Debiasing GNNs, contrastive | mirrors exact paper title | |
| Fairness-aware graph ML | broader framing, debiased recommendations | ✓ |
| Let me write it | free text | |

**User's choice:** Fairness-aware graph ML
**Notes:** Keep citation + venues + first-author; cut the abstract paragraph.

## Text compression — Research (PG2-03)

| Option | Description | Selected |
|--------|-------------|----------|
| Feature the debiasing study | one thread (IUNI debiasing) | |
| One line, all three | IUNI debiasing + User-Intent RA + NLP-Lab TieML/LLMs | ✓ |
| Let me specify | free text | |

**User's choice:** One line, all three

## Text compression — Teaching (PG2-03)

| Option | Description | Selected |
|--------|-------------|----------|
| One line, courses named | TA: Network Science (I606) & ML (B555) | |
| One line, no course codes | TA for Network Science & ML | |
| Let me specify | free text | |

**User's choice:** "leave them as is"
**Notes:** Owner override — Teaching stays 3 TA items, overriding ROADMAP criterion 4's "Teaching → one line".

## Education (PG2-03)

| Option | Description | Selected |
|--------|-------------|----------|
| Keep cities, drop GPAs only | 'Indiana University, Bloomington' stays; no gate change | |
| Drop cities too | institution names only; update manifest EDU_INSTITUTION | ✓ |
| Let me specify | free text | |

**User's choice:** Drop cities too
**Notes:** Drop both GPAs; drop "Bloomington"; keep both date ranges. Manifest EDU_INSTITUTION → "Indiana University" in the same commit so G6.12 stays green.

## Claude's Discretion

- Exact one-line wording for the Publication contribution line and the compressed Research line, within the chosen framings.
- Which Research hyperlinks survive the one-line compression.

## Deferred Ideas

- GH-01 privatize `random_walk` — deferred (resume-only; account hygiene, not resume-linked).
- GH-02 fix `rollout` README stale status → "v1 implemented…" — deferred (resume-only; accepted trade-off).
- Teaching one-line compression — dropped by owner (kept as 3 items).
