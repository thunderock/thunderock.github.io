# Phase 2: Page-1 Budget & Text-Layer Defects - Context

**Gathered:** 2026-08-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Free the page-1 line budget the later phases spend (career-break row removal + Groupon/NetSpeed fold) and clear the three live text-layer defects (masked contact literals, en-dash handle, Education parse order) — `make verify` goes green for the first time. Requirements: EXP-01, EXP-05, EXP-06. No Adobe-section content work (Phase 3), no Skills work (Phase 5), no palette work (Phase 6).

</domain>

<decisions>
## Implementation Decisions

### Contact line (EXP-06)
- **D-01:** Header displays **bare URLs as the visible link text**: `669-292-7534 | findashutoshtiwari@gmail.com | linkedin.com/in/ashutosh--tiwari | thunderock.github.io | github.com/thunderock`. Every item remains a clickable `\href`. Phone and email keep their current forms.
- **D-02:** The en-dash defect is fixed in the DISPLAY text (break the `--` ligature so the text layer carries two ASCII hyphens); the `\href` TARGET at main.tex:134 is already correct and does not change. Handle is `ashutosh--tiwari` (frozen in manifest, user-confirmed via live LinkedIn probe — STATE.md [Phase 1 / A1]).
- **D-03:** Gate contract: after the change, `CONTACT_LITERALS` (email, `ashutosh--tiwari`, `github.com/thunderock`, `thunderock.github.io`) all extract literally; `FORBIDDEN_LITERAL` (en-dash form) extracts zero times.

### Earlier-roles fold (EXP-05)
- **D-04:** Groupon + NetSpeed compress to **compact header rows + ONE italic descriptor line each** (user explicitly rejected header-only rows). Both remain inline at the bottom of Work Experience — no new section heading (the frozen 7-entry `SECTIONS` manifest stays untouched).
- **D-05:** **Groupon descriptor:** customer segmentation and deal-recommendation ML (NSVD unsupervised collaborative filtering on Neo4j) + Cyclops customer-service platform live in every Groupon country. Segmentation claim is user-confirmed interview-defensible (rests on user's word; reco/Neo4j documented in the 2021 resume's Geekon 2017 project — see git `0dafdbc:docs/Ashutosh_Tiwari.pdf`).
- **D-06:** **NetSpeed descriptor:** graph algorithms for Network-on-Chip interconnects in C++, WITH module names for concreteness: Virtual Channel Arbitration, Polarity-based Arbitration, Multi-Cast Filtering, Structural Latency Breakdown (wording source: 2021 resume). Preserves the C++/NoC evidence EXP-05 requires (feeds PG2-06 skills anchoring).
- **D-07:** Frozen strings are untouchable: dates (`Sep. 2016 – Sep. 2017`, `Sep. 2015 – Aug. 2016` extracted forms) and titles (`Software Development Engineer`, `Software Engineer`) must stay byte-identical in the text layer; company display names (GROUPON, NETSPEED SYSTEMS (Acquired by Intel)) and their hyperlinks are preserved.
- **D-08:** **Budget consequence (supersedes ROADMAP crit 5's "≥12 lines"):** fold-with-descriptors frees ~5–6 lines, + ~4.25 from career-break removal ≈ **10–11 lines total**. The harness headroom expectation must be set to the measured post-change value, not 12. The two descriptor lines are the FIRST re-compression lever if Phase 3's Adobe rebuild runs out of room.

### Education fix (EXP-01-adjacent defect, assigned to this phase by Phase-1 research Q1)
- **D-09:** **Drop the redundant city cells** (`Bloomington, IN`, `Patna, India`) rather than minimal arg-swap: institution lines already carry the city; dates move up to the header's right side. Fixes the parse-order defect structurally and removes the duplicate-institution-string wrinkle flagged in Phase 1. GPAs stay (Phase 4 / PG2-03 owns their removal).

### Career-break removal (EXP-01)
- **D-10:** Delete the entry outright (milestone decision, PROJECT.md Key Decisions) — Experience runs Swiggy → Adobe; the master's stays visible via Education dates (`Aug. 2021 -- May 2023`). No replacement row, no summary line (fold-only decision).

### the agent's Discretion
- Exact LaTeX for the fold rows (reuse `\resumeSubheading` vs a slimmer two-cell tabular) — pick whatever keeps the frozen strings' extracted forms identical and reads cleanly.
- Line-wrap handling if the contact line runs wide at `\small` (letter-spacing/separator tweaks allowed; dropping an item is not).
- Whether the harness's frozen-baseline geometry hash update (layout legitimately changes) happens via `--write-baseline` with `ALLOW_FROZEN_UPDATE=1` or hand-edit + reviewed commit — follow Phase 1's documented guard either way.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Harness contract (the phase's acceptance oracle)
- `docs/verify/manifest.txt` — CONTACT_LITERALS / FORBIDDEN_LITERAL / SECTIONS the changes must satisfy; WARN owners
- `docs/verify/baseline-frozen.txt` — 15 byte-frozen strings (dates/titles) + geometry hash; legitimate layout changes require the guarded update path (`ALLOW_FROZEN_UPDATE=1`, diff printed)
- `scripts/verify-resume.sh` — assertion semantics; `bash scripts/verify-resume.sh` exit 0 is this phase's DONE signal (`make verify` exits non-zero only via Make's collapse — use the script for the gate)
- `.planning/phases/01-verification-harness/01-VERIFICATION.md` — Phase 1 closure state; documents the build-then-verify caveat (`make verify` on edited source rebuilds the PDF — expected during this phase)

### Defect specifics
- `.planning/phases/01-verification-harness/01-02-SUMMARY.md` — the 5 live FAIL lines with per-defect remedy text and main.tex line references (G6.9 ×3 → :134-136 anchors; G6.10 → :134 ligature; G6.12 → :240-242 reorder)
- `.planning/STATE.md` — [Phase 1 / A1] handle decision; ROADMAP Phase-2 criterion 3's single-hyphen literal is a superseded transcription error (do NOT "fix" the manifest backwards)

### Content sources
- git `0dafdbc:docs/Ashutosh_Tiwari.pdf` (2021 resume) — original Groupon Geekon (NSVD/Neo4j) and NetSpeed module-list wording the descriptors derive from
- `.planning/research/CODEBASE-EVIDENCE.md` — honesty rules (bullets evidence-true)

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `\resumeSubheading` (main.tex:82-88): two-line tabular header — candidate for fold rows (or slim variant)
- Harness self-test (`make verify-selftest`) — run after every edit batch; proves the gates still fire

### Established Patterns
- Edit → `make build` → `bash scripts/verify-resume.sh` → read RESULT lines; page count is the only overflow signal (build is silent)
- Frozen-string discipline: any date/title wording change fails G5 loudly; layout-only changes need the geometry-hash update path

### Integration Points
- main.tex:129-137 (header center block) — contact-line rewrite
- main.tex:169-174 (career-break entry) — delete
- main.tex:203-215 (Groupon + NetSpeed blocks) — fold
- main.tex:238-246 (Education) — city-cell drop + date relocation

</code_context>

<specifics>
## Specific Ideas

- Groupon/NetSpeed descriptor wording drafted and user-approved during discussion (see D-05/D-06) — planner should carry these phrases into the plan verbatim as the starting text.
- User's mental model for the fold: "highlight customer segmentation efforts in Groupon and graph algorithms / graph-ML efforts in NetSpeed" — the staff-MLE narrative arc (ML signal even in 2015-17 roles) matters more than maximum line savings.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope. (Note: "customer segmentation" has no documentary evidence in repo history; recorded as user-attested. If a future employer-verification concern arises, the fallback wording is D-05 without "segmentation".)

</deferred>

---

*Phase: 2-Page-1 Budget & Text-Layer Defects*
*Context gathered: 2026-08-22*
