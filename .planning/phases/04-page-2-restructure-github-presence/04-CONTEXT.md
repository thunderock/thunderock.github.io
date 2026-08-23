# Phase 4: Page-2 Restructure & GitHub Presence - Context

**Gathered:** 2026-08-23
**Status:** Ready for planning

<domain>
## Phase Boundary

Restructure **page 2 of the LaTeX resume** (`docs/main.tex`, everything behind the `\newpage` at line ~213) so it leads with current, click-through-safe artifacts instead of seven grad-school entries. Page 1 (Experience, lines ~140–210) is **FINAL and byte-frozen at `798c0fb`** and is not touched. Page 2 has its own independent ~53.5pt budget (zero page-1 coupling).

**Active scope this phase (owner-scoped down to resume-only):** PG2-01 (Projects), PG2-02 (Publication), PG2-03 (Education + Research; Teaching left as-is by owner override).

**Descoped this phase:** GH-01/GH-02 (GitHub mutations) — deferred, resume-only. GH-03 satisfied on the resume side (wording confirmed). Skills (PG2-04/05/06), palette (VIS-01), and site sync (SITE-01/02) remain Phases 5–6.
</domain>

<decisions>
## Implementation Decisions

### Projects (PG2-01)
- **D-01:** Replace **all seven** grad-school Selected-Projects entries (BiasNet, DeepFoodie, BlindNet, Continuous Dominant Set Repair, Humana-Mays, AnalyticsVidhya, Investigating Bias Manifolds) with **exactly `rollout` + `graph_ml`** (in that order), using the spike Variant A LaTeX drafts **verbatim / ship-as-is**. The rollout bullet wording was confirmed to survive "walk me through it" (GH-03, resume side). Resolve the edit's source line range by **CONTENT** (the `\section{Selected Projects}` body), never by the spike's stale `main.tex:281-314` — every prior wave shifted line numbers.
- **D-02:** Only public repos are featured; bullet claims come from verified tree facts, never README self-descriptions. Do **NOT** re-feature `residual2vec_` (already linked from Publications), and add **no** unverified perf/throughput numbers to rollout.

### Publication (PG2-02)
- **D-03:** Keep the NetSci 2023 / IC2S2 2023 **first-author** citation (the `thebibliography` bibitem + venue links + Poster link). **Cut the abstract paragraph** (`docs/main.tex:224`). Add ONE contribution line framed as **fairness-aware graph ML** (debiased recommendations) rather than the exact paper title — e.g. "fairness-aware graph representation learning: a contrastive framework for debiasing GNN embeddings toward more organic recommendations." Final wording set at execution; first-author + venues stay intact.

### Research / Independent Study (PG2-03)
- **D-04:** Compress the **3 items into ONE line** covering all three threads: IUNI debiasing independent study (Profs YY Ahn & S Kojaku), the paid RA "User Intent as a Network", and the NLP-Lab TieML / fine-tuned-LLM work (Prof D Cavar). Keep the key hyperlinks that fit on one line; drop the per-item semester stamps to make it fit.

### Teaching (owner override)
- **D-05:** **Leave Teaching AS-IS** — the three TA items (Network Science INFO-I 606 ×2, Machine Learning CSCI-B 555) are unchanged. This **overrides ROADMAP Phase 4 criterion 4's** "Teaching renders as one line." Explicit owner decision. — **Reversibility:** reversible.

### Education (PG2-03)
- **D-06:** **Drop both GPAs** (`3.87/4.0`, `8.32/10.0`). **Drop cities** — `Indiana University, Bloomington` → `Indiana University`; National Institute of Technology has no city today and stays as written. **Keep both date ranges**: `Aug. 2021 -- May 2023` (arg #4 — required so EXP-01/G6.12 still extract the master's dates) and `Aug. 2011 -- May 2015`. Institution stays `\resumeSubheading` arg #1 (institution-first, per Phase-2 D-09 / G6.12).
- **D-07:** In the **SAME commit** as the D-06 source edit, update `docs/verify/manifest.txt` `EDU_INSTITUTION` from `Indiana University, Bloomington` → `Indiana University` so G6.12 (institution = first non-empty extracted line in the EDU region) stays green. `EDU_DATE` stays `Aug. 2021 – May 2023`. This is a needle-literal update **following the document** (same principle as the 2026-08-23 gate reconciliation), not gate-weakening. — **Reversibility:** reversible.

### GitHub Presence (GH-01 / GH-02 / GH-03)
- **D-08:** **Resume-only this pass — no GitHub mutations.** GH-01 (privatize `random_walk`) and GH-02 (fix `rollout` README) are **DEFERRED by owner decision**. `random_walk` stays public and untouched (it is **not** linked from the resume — only `rollout` + `graph_ml` are — so leaving it public has no click-through impact; privatization was account-hygiene only). `rollout`'s README stays `Status: spec / pre-implementation. v1 in design.` — an **accepted, documented trade-off**: a recruiter clicking the featured `github.com/thunderock/rollout` link reads a stale status. **GH-03 is satisfied on the resume side** — the rollout bullet wording is confirmed ("ship as-is"). — **Reversibility:** reversible (the GitHub fixes can be done any time later; the exact fix is recorded in Deferred Ideas).

### Budget / gate awareness
- **D-09:** All edits are page-2 only; `docs/main.tex` lines ~140–210 (page-1 Experience) stay **byte-identical to `798c0fb`**. Page-2 slack is ~53.5pt and the net change is strongly negative (Projects 7→2 frees ~9 rendered lines; Research 3→1; Publication abstract cut), so there is no fit risk. `make verify` must stay green end-to-end (2 pages, page 2 still opens at `PUBLICATIONS`, G6.12 green with the updated `EDU_INSTITUTION`). Single-file LaTeX constraint holds — no `\input`/`\include`.

### Claude's Discretion
- Exact one-line wording for the Publication contribution line (D-03) and the compressed Research line (D-04), within the framings chosen above.
- Which hyperlinks survive the Research one-line compression (fit-driven).
</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Projects (PG2-01) — ready drafts
- `.opencode/skills/spike-findings-thunderock-github-io/references/projects-section.md` — the **ready-to-drop-in** `rollout` + `graph_ml` Variant A LaTeX, the verified facts backing each bullet (18 crates / 197 test files / CI for rollout; C++/Cython kernels for graph_ml), and the explicit "what to avoid" list. Ship the LaTeX as-is per D-01.

### Phase artifacts
- `.planning/ROADMAP.md` — Phase 4 goal + success criteria. **Note the owner overrides:** criteria 2 & 3 (GH-02/GH-01) are deferred (D-08); criterion 4's "Teaching → one line" is overridden (D-05).
- `.planning/REQUIREMENTS.md` — PG2-01/02/03 and GH-01/02/03 requirement texts.
- `.planning/STATE.md` — the 2026-08-23 gate-reconciliation record, the **Phase-5 H100 needle-flip obligation**, the page-1-FINAL constraint, and the single-file-LaTeX constraint.

### Gate surfaces (edited by D-07 only)
- `docs/verify/manifest.txt` — `EDU_INSTITUTION`, `EDU_DATE`, `EDU_BIND_WINDOW`, `PAGE2_OPENS_WITH`, `SECTIONS`.
- `docs/main.tex` — page-2 section anchors: `\section{Publications}` (214), `\section{Education}` (232), `\section{Research Experience / Independent Study}` (254), `\section{Teaching Experience}` (264), `\section{Selected Projects}` (275), `\section{Technical Skills}` (312, Phase 5).
- `scripts/verify-resume.sh` — G6.12 Education ordering gate (reads the manifest EDU_* keys).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `\resumeProjectHeading` + `\resumeItemListStart`/`\resumeItem` — the Projects entry shape the spike drafts already use (~2.5 rendered lines per entry).
- `\resumeSubheading{arg1}{arg2}{arg3}{arg4}` — Education entries; arg1 = institution (must extract first for G6.12), arg4 = date range.
- `\resumeItemListStart`/`\resumeItem` — Research and Teaching item lists.
- `thebibliography` block (Publications) — citation carrier; the abstract paragraph is a plain paragraph after the `\bibitem`.

### Established Patterns
- **Resolve every `docs/main.tex` line reference by CONTENT, never by a stored number** — page-1 growth shifted page-2 lines repeatedly (Phase-3 standing rule).
- Regenerated artifacts (`.pdf`/`.log`/`.fdb_latexmk`/`.aux`/`.fls`/`.out`) ride **in the source commit**; never `make clean` (it deletes the `.fdb_latexmk` md5 G0.3 needs).
- Gate on `bash scripts/verify-resume.sh` directly (exit 0); `make verify` is corroboration only (GNU Make 3.81 collapses exit 1/2).
- Single-file LaTeX — everything in `docs/main.tex`, no local `\input`/`\include`.

### Integration Points
- G6.12 (Education ordering) reads `EDU_INSTITUTION`/`EDU_DATE` from the manifest — D-07 keeps them in sync with the D-06 source edit.
- The P2 and P3 regression nets guard page-1 content, which this phase does not touch — they must stay green (27 PASS / 72 PASS).
- `rollout` + `graph_ml` landing here are the **C++ anchor** Phase 5 (PG2-06) will reference — do not remove the graph_ml C++/Cython phrasing.

</code_context>

<specifics>
## Specific Ideas

- `rollout` and `graph_ml` bullets are taken **verbatim** from the spike `projects-section.md` (D-01) — the rollout bullet was read and approved for the "walk me through it" test.
- Publication framing is **fairness-aware graph ML**, not the literal paper title (owner choice).
- Research is **one line, all three threads** (owner choice); Teaching stays **three items** (owner choice).
- Education shows **institution names only** (no cities), **no GPAs**, dates retained (owner choice).

</specifics>

<deferred>
## Deferred Ideas

- **GH-01 — privatize `random_walk`.** Deferred (owner: resume-only). Account-hygiene only; the repo is public, ~empty (4KB, 3 commits), and not linked from the resume, so it has no resume click-through impact. Ready command if reactivated: `GH_TOKEN=$(gh auth token -u thunderock) gh api -X PATCH repos/thunderock/random_walk -f private=true`.
- **GH-02 — fix `rollout` README stale status.** Deferred (owner: resume-only). Accepted trade-off: the featured `rollout` link keeps reading `Status: spec / pre-implementation. v1 in design.` Ready fix if reactivated: replace that line with `Status: v1 implemented — 18 crates; PPO/GRPO/DPO/SFT/RM; vLLM batch + online inference; CI across 197 test files.` (matches the existing `status-v1.0` badge and the verified tree).
- **Teaching one-line compression** — dropped by owner (D-05); kept as three TA items. Recorded so a later reader does not treat it as unfinished.

</deferred>

---

*Phase: 4-page-2-restructure-github-presence*
*Context gathered: 2026-08-23*
