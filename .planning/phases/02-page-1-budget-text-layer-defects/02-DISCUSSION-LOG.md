# Phase 2: Page-1 Budget & Text-Layer Defects - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-08-22
**Phase:** 2-page-1-budget-text-layer-defects
**Areas discussed:** Contact line, Earlier-roles fold, Education fix

---

## Contact line — how the header displays literal URLs

| Option | Description | Selected |
|--------|-------------|----------|
| A — bare URLs (Recommended) | ATS-standard; what you see is the URL; measured to fit one line at \small | ✓ |
| B — hybrid with in/ prefix | Shortens LinkedIn to in/ashutosh--tiwari; still passes the gate | |
| You decide | Pick during execution by line-width measurement | |

**User's choice:** A — bare URLs
**Notes:** All items remain clickable \href; en-dash ligature broken in display text; \href target already correct.

---

## Earlier-roles fold — the compressed block's shape

| Option | Description | Selected |
|--------|-------------|----------|
| B — header-only rows (Recommended) | Two lines total, ~8 lines freed, C++/NoC in role-designation slot | initially ✓, then overridden |
| A — compact rows w/ one-liners | One italic descriptor per role, ~6 lines freed | ✓ (via freeform override) |
| You decide | Based on Phase 3's space needs | |

**User's choice:** Freeform override of the initial header-only selection: "no not header only rows ... lets highlight customer segmentation efforts in groupon and add some graph algorithms and graph ml efforts in netspeed.. you might have to check older versions of AshutoshTiwari.pdf in the repo.."
**Notes:** Repo archaeology (git 0dafdbc:docs/Ashutosh_Tiwari.pdf, 2021) surfaced: Groupon Geekon 2017 deal-recommendation NSVD/Neo4j project; NetSpeed module list (Virtual Channel Arbitration, Polarity-based Arbitration, Multi-Cast Filtering, Structural Latency Breakdown). "Customer segmentation" appears in NO committed resume version — user explicitly confirmed it as interview-defensible on their own word. Follow-ups: keep segmentation + reco ✓; add NetSpeed module names ✓. Placement follow-up (inline vs sub-label) was overridden by the same freeform response; fold stays inline under Work Experience (no new heading).

---

## Education fix — swap args or drop redundant city

| Option | Description | Selected |
|--------|-------------|----------|
| B — drop redundant city cells (Recommended) | Remove 'Bloomington, IN'/'Patna, India'; dates move to header right; structural fix | ✓ |
| A — minimal arg swap | Smallest diff; reorder tabular args only | |

**User's choice:** B — drop redundant city cells
**Notes:** Removes the duplicate-institution-string wrinkle Phase 1 flagged; GPAs untouched (Phase 4 owns).

## the agent's Discretion

- Exact LaTeX construct for fold rows (reuse \resumeSubheading vs slimmer tabular), provided frozen extracted forms stay identical
- Contact-line wrap handling at \small (separators/spacing; never drop an item)
- Geometry-baseline update path (--write-baseline guarded run vs hand-edit + reviewed commit)

## Deferred Ideas

None. (Recorded caveat: fallback Groupon wording without "segmentation" noted in CONTEXT.md deferred section should verification concerns arise.)
