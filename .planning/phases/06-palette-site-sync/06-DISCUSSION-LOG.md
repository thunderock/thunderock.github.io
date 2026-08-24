# Phase 6: Palette & Site Sync - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-08-24
**Phase:** 6-palette-site-sync
**Areas discussed:** Site sync scope, Site Adobe block, Palette candidates, Site-sync gate

---

## Gray-area selection

Four gray areas were surfaced (palette was noted as heavily pre-decided by research; the site sync carried the real open judgment calls). User selected **all four** to work through.

---

## Site sync scope

### Sync philosophy

| Option | Description | Selected |
|--------|-------------|----------|
| Mirror + prune grad-era | Sync every section the résumé has + replace 8 grad Projects with rollout+graph_ml, then DROP off-message grad-era extras (Competitive D.S. hackathons, Certifications). Content-only, no redesign. | ✓ |
| Sync shared, keep extras | Fix shared sections but leave Competitive D.S. + Certifications as portfolio breadth. | |
| Contradiction-only | Only remove/fix what the résumé actively contradicts + Projects→rollout/graph_ml; leave everything else. | |

**User's choice:** Mirror + prune grad-era
**Notes:** Same staff-positioning logic that cut 7 grad projects from the résumé. Content-only edits inside existing containers — no layout/CSS redesign, stays clear of PORT-01.

### Education

| Option | Description | Selected |
|--------|-------------|----------|
| Mirror D-06 exactly | Drop both GPAs and 'Bloomington' (→ 'Indiana University'), align B-Tech dates to 'Aug 2011 – May 2015', sweep hero/about city too. | ✓ |
| Drop GPAs, keep cities | Drop GPAs but leave cities and existing dates. | |
| Leave Education as-is | GPAs/cities aren't factual contradictions; keep untouched. | |

**User's choice:** Mirror D-06 exactly
**Notes:** Site and résumé then agree exactly on Education.

### Research

| Option | Description | Selected |
|--------|-------------|----------|
| Keep 3 entries | Leave the 3 Research entries as portfolio depth; on-message (backs the kept Publication); fix wording only if contradictory (it isn't). | ✓ |
| Compress to 1 | Mirror the résumé's D-04 one-line compression on the site too. | |

**User's choice:** Keep 3 entries
**Notes:** Research backs the first-author Publication the milestone preserves; site has no space constraint, so the résumé's page-budget compression need not carry over.

---

## Site Adobe block

### Reshape depth

| Option | Description | Selected |
|--------|-------------|----------|
| Rewrite to rebuilt voice | Reshape to the résumé's thesis: fault-tolerance / distributed-inference lead, add torch.compile(max-autotune), frame the Rust governance/lineage subsystem; retired figures gone; within CODEBASE-EVIDENCE rules. | ✓ |
| Strip contradictions only | Remove just the two retired figures + anything contradicted; keep generic lead + existing wording. | |

**User's choice:** Rewrite to rebuilt voice
**Notes:** Removing the two retired figures at :196 is mandatory regardless. Falcon-40B / Llama 2 70B stay (survived the résumé rebuild).

### Public register

| Option | Description | Selected |
|--------|-------------|----------|
| Mirror generalized résumé | Match the résumé's deliberately-generalized public register — no hard figures — keep the technical stack nouns that survived. Tightest parity; nothing more exposed on the web than the PDF. | ✓ |
| Allow concrete specifics | Let the site carry more concrete figure/technical detail than the generalized résumé (evidence-true, no retired figures). | |

**User's choice:** Mirror generalized résumé
**Notes:** Owner generalized page 1 after external review; the site is more public than the PDF.

---

## Palette candidates

### Candidate set

| Option | Description | Selected |
|--------|-------------|----------|
| Navy/oxblood/graphite+teal | Render the 3 researched challengers (deep navy, oxblood, graphite mono) side-by-side with teal baseline, each with grayscale. All pre-validated; teal stays legitimate. | ✓ |
| Reshape the set | Swap/narrow candidates (fewer, head-to-head, warmer family). | |

**User's choice:** Navy/oxblood/graphite+teal
**Notes:** Spans conservative → distinctive → minimal, plus the incumbent.

### Tone structure

| Option | Description | Selected |
|--------|-------------|----------|
| Single-hue family | Each proposal = one accent hue: dark shade for text (≥7:1), same hue for rules (≥3:1). Mirrors today's one-tone look; swap stays 2 hex literals. | ✓ |
| Distinct two-tone | Genuinely distinct rule tone vs text tone per palette; larger departure from the current effectively-monochrome design. | |

**User's choice:** Single-hue family
**Notes:** Keeps the swap to exactly 2 hex literals and stays faithful to the current visual system.

---

## Site-sync gate

| Option | Description | Selected |
|--------|-------------|----------|
| Add a site-sync net | Grep net over index.html (retired figures absent, career-break absent, rollout+graph_ml present, GPAs absent, pruned sections absent) wired into make verify like REGRESS2-5, each assertion failable. | ✓ |
| Manual sync + paste test | No standing site net; sync once, verify by eye, rely on final make verify (PDF) + plain-text paste test. | |

**User's choice:** Add a site-sync net
**Notes:** Matches the project's machine-enforce culture; the two retired figures at :196 are live and public now, and nothing checks résumé↔site agreement today.

---

## Claude's Discretion

- Exact palette hex values for each of navy / oxblood / graphite (families fixed by D-01; shades chosen to clear the WCAG bar).
- Hero/about wording sweep — three "Senior Machine Learning Engineer" occurrences consistent, city dropped per D-06, positioning aligned.
- Publication framing on the site aligned to fairness-aware graph ML (matches résumé D-03).
- Teaching left at 3 TA items (already matches résumé D-05).
- Site-net wiring/wording follows the established REGRESS pattern.

## Deferred Ideas

None — discussion stayed within phase scope. (PORT-01 full site refresh remains v2 backlog; re-coloring the site stays out of scope — palette is résumé-only. Distinct two-tone palette was considered and rejected in favor of single-hue.)
