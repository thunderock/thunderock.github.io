# Phase 6: Palette & Site Sync - Context

**Gathered:** 2026-08-24
**Status:** Ready for planning

<domain>
## Phase Boundary

Ship the artifact set for milestone v1.0 — two mutually-independent artifacts:

1. **Palette (VIS-01):** Choose the résumé's accent palette against the now-frozen content. Render 2–3 challenger palettes + the teal incumbent as side-by-side PDF samples of the **final** résumé, each with a grayscale conversion, measured against a fixed WCAG bar; the user picks (teal staying is legitimate); apply the choice via the **2 hex literals** in `docs/main.tex` and delete the dead `accentlight` definition.

2. **Site sync (SITE-01 / SITE-02):** Resync `index.html` so the public portfolio tells the same story as the rebuilt résumé — mirror the résumé's sections, replace the grad-school Projects with `rollout` + `graph_ml`, remove the retired page-1 figures and the site's own career-break entry, and prune the off-message grad-era sections.

**Independence (roadmap-locked):** palette and site share **zero color and zero build**. Palette work touches only `docs/main.tex` (LaTeX); the site keeps its own CSS (`css/style.css`, unrelated blue `#00BFFF`) — **the site is NOT re-colored this phase.**

**Out of scope:** page 1 (byte-frozen at `798c0fb`), all résumé content already finalized in Phases 1–5, full portfolio-site redesign / layout / CSS rework (PORT-01, v2 backlog), any employment date/title change, LinkedIn profile rewrite (CRED-03, v2).

</domain>

<decisions>
## Implementation Decisions

### Palette (VIS-01)

- **D-01: Candidate set = navy / oxblood / graphite-mono + teal baseline.** Render the three researched challengers — **deep navy** (classic/conservative), **oxblood** (deep burgundy, distinctive-but-professional), **graphite mono** (charcoal, palette-minimal / max print-safety) — **side-by-side with today's teal**, each column accompanied by its **grayscale conversion**. All three are higher-contrast than teal, which already clears every bar, so "teal stays" is an explicitly legitimate outcome and the challenger carries the burden of proof.
- **D-02: Each proposal is a single-hue family.** Text = a dark shade of the hue (≥7:1 vs white); rules = the same hue (≥3:1 vs white). This mirrors today's restrained, effectively-one-tone look (`accentdark` vs `accent` are only 1.61:1 apart) and keeps every swap to exactly 2 hex literals. **No** genuinely-distinct two-tone pairing — rejected as a larger departure from the current visual system.
- **D-03: Build + apply mechanics.** Build sample variants with a **`sed` + `latexmk` harness** (plain `make build` hardcodes `JOBNAME` and cannot emit variants). Acceptance is the fixed numeric bar (see Canonical Refs → PITFALLS.md Pitfall 20): text ≥7:1, rules ≥3:1, grayscale text ≥4.5:1, grayscale rule ≥3:1, **unused color definitions = 0**. Apply the chosen palette by editing the **2 hex literals** (`accent` `:18`, `accentdark` `:20`) and **delete the dead `accentlight` `:19`** in the same change. A palette swap has **zero layout effect** (pure color; 13 consumption sites, all color).
- **D-04: The palette pick is a blocking `checkpoint:decision`.** The user selects from the rendered samples (VIS-01, per the ROADMAP Checkpoints table) — the planner must model this as a hard checkpoint (like EXP-08 / PG2-04 were), not Claude's discretion. — **Reversibility:** reversible — any palette is a 2-hex-literal swap, but the *selection* requires the user against real samples.

### Site sync scope (SITE-01)

- **D-05: Mirror the résumé + prune grad-era.** Faithfully sync every section the résumé has (Experience, Education, Publication, Research, Teaching, hero/about), **replace the 8 grad-school `Projects` entries with `rollout` + `graph_ml`** (mirroring the résumé's shipped `\section{Selected Projects}` body), and **drop the two off-message grad-era sections that have no résumé counterpart: "Competitive D.S. Experience"** (6 AnalyticsVidhya/MachineHack/Humana hackathon ranks) **and "Certifications"** (Udacity / IISc PG Diploma / School of AI / Udemy). This is the same staff-positioning logic that cut 7 grad projects from the résumé. **Content-only edits inside existing containers** — no layout/CSS redesign, so it stays clear of PORT-01. — **Reversibility:** reversible — pruned sections remain in git history; restorable if v2 wants them.
- **D-06: Education mirrors résumé D-06/D-07 exactly.** Drop both GPAs (`3.87/4.0`, `8.32/10.0`), drop the city `Bloomington` (`Indiana University, Bloomington` → `Indiana University`), and align the B-Tech range to the résumé's `Aug 2011 – May 2015` (site currently shows `Jul 2011 - Jun 2015`). Sweep the hero/about paragraph, which also says `Indiana University, Bloomington`. Site and résumé then agree exactly on Education.
- **D-07: Research keeps its 3 entries.** Unlike the pruned hackathons/certs, Research is **on-message** — it backs the first-author Publication the milestone deliberately keeps (the graph/fairness/recsys identity) — and the site has no page-space constraint. Leave the 3 entries (IUNI debiasing, Kelly RA "User Intent as a Network", NLP-Lab TieML) as portfolio depth; fix wording only if it contradicts the résumé (it does not). This is a deliberate, sanctioned divergence from the résumé's D-04 one-line compression, which existed only for page budget.

### Site Experience / Adobe block (SITE-01)

- **D-08: Rewrite the Adobe block to the rebuilt-résumé voice.** The site's Adobe bullets (`index.html:195-201`, resolve by content) are the pre-Phase-3 version opening on generic "Leading parts of ML Platform" voice. Reshape them to match the résumé's thesis: **fault-tolerance / distributed-inference lead**, add **`torch.compile(mode="max-autotune")`**, explicitly frame the **Rust governance/lineage subsystem** — staying within the same evidence rules (`CODEBASE-EVIDENCE.md`). The **two retired figures** (`3–8K images/sec on 32 GPUs`, `10–50× faster image loading`) at `index.html:196` are removed regardless. Falcon-40B / Llama 2 70B **stay** (they survived the résumé rebuild — not contradictions).
- **D-09: Public register = the generalized résumé.** Match the résumé's deliberately-generalized public register (the owner generalized page 1 after external review): **no hard fleet/throughput numbers**; use the same "billions of images/videos" / generalized framing. Keep the keyword-level technical stack nouns that already survived (`vLLM`, `Ray`, `FSDP`/`FSDP2`, `Flash Attention`, `torch.compile`, `KEDA`, `Cerberus`, `Rust`). Nothing on the public web is more exposed than the PDF. — **Reversibility:** reversible.

### Career-break entry (SITE-02)

- **D-10: Remove the site's career-break timeline entry** (`index.html:207-226`, "Career Break — Master's Degree", resolve by content) so résumé and site agree — the résumé deleted the equivalent row in Phase 2 (EXP-01). Non-negotiable per SITE-02.

### Site-sync verification gate

- **D-11: Add a site-sync regression net.** A lightweight grep net over `index.html` (e.g. `scripts/verify-site-regressions.sh`) asserting the durable invariants: the two retired figures **absent**, career-break entry **absent**, `rollout` + `graph_ml` **present**, GPAs (`3.87`/`8.32`) **absent**, pruned sections ("Competitive D.S." / "Certifications") **absent** — **wired into `make verify`** alongside `REGRESS2`–`REGRESS5`, each assertion class proven failable. Matches the project's machine-enforce culture and catches a silent *public* regression before push. — **Reversibility:** reversible. **Note:** the net greps the **raw `index.html` source** directly, so the "multi-word literals → `$SQUEEZED`" rule (a `pdftotext` line-wrap artifact of the résumé nets) **does not apply here** — HTML source is not reflowed.

### Claude's Discretion

- **Exact palette hex values** for each of navy / oxblood / graphite — chosen to clear the D-03 numeric bar; the D-01 families are fixed, the specific shades are not.
- **Hero/about wording sweep:** make the three `Senior Machine Learning Engineer` occurrences (intro `:41`, about `:43`, Adobe title `:191`) consistent and drop the city per D-06; align positioning language to the résumé within "mirror faithfully."
- **Publication framing** on the site: keep the first-author citation + venues + Poster link; align framing to fairness-aware graph ML (matches résumé D-03); no contradiction to introduce.
- **Teaching** is left at 3 TA items (already matches résumé D-05 — no change).
- **Site-net wiring/wording** follows the established `REGRESS` pattern (standalone target + chained into `make verify`; each assertion `--gate`/fixture-failable in the net's own idiom).

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase contract
- `.planning/ROADMAP.md` — Phase 6 goal + 5 success criteria (palette samples of final content + WCAG bar; palette applied via 2 hex literals with `accentlight` gone; `index.html` synced across all mirrored sections incl. the retired figures at `:196`; career-break entry gone; final `make verify` + plain-text paste test) + the **Checkpoints table row (VIS-01 = pick the palette from rendered samples)**.
- `.planning/REQUIREMENTS.md` — VIS-01 (palette), SITE-01 (full résumé→site sync, scope expanded 2026-08-23), SITE-02 (career-break removal). Note PORT-01 (full site refresh) is v2 backlog.

### STATE.md — load-bearing Phase-6 handoff records (read verbatim)
- `.planning/STATE.md` → `[Phase 3 / 03-02]` **SITE HANDOFF TO PHASE 6** — the two retired figures duplicated at `index.html:196`, the career-break entry at `index.html:207-225`, and the fact the site is published by `.github/workflows/jekyll.yml` on push to `master`. "Treat `index.html:196` and `:207-225` as one greppable site-sync obligation."
- `.planning/STATE.md` → `### Blockers/Concerns [Phase 6]` — SITE-01 scope-expansion record: `index.html` (756 lines) is stale on more than the two known spots (Projects / Education / Publication / Experience the résumé rewrote); syncs once here against the fully-settled résumé; **no push happens until the owner pushes**.
- `.planning/STATE.md` → standing rules that still bind: **resolve every `docs/main.tex` line reference by CONTENT** (never a stored number); **single-file LaTeX** (no `\input`/`\include`); artifacts ride in the source commit; **never `make clean`** (deletes the `G0.3` freshness md5); gate on `bash scripts/verify-resume.sh` (exit 0) — `make verify` is corroboration only (Make collapses exit 1/2); **page 1 byte-frozen at `798c0fb`**.

### Palette research (already computed — do NOT re-derive)
- `.planning/research/PITFALLS.md` → **Pitfall 20** — the numeric acceptance table (text ≥7:1, rules ≥3:1, grayscale text ≥4.5:1, grayscale rule ≥3:1, unused defs = 0) **with current teal values** (`accentdark` #0E463E = 10.69:1 text; `accent` #17685C = 6.62:1 rules; grayscale BT.601 → #343434 12.45:1 / #4E4E4E 8.32:1; `accentdark` vs `accent` = 1.61:1).
- `.planning/research/ARCHITECTURE.md` §1.5 + §4 — palette propagation model: exactly **2 hex literals** matter (`accent` `:18` = rules only, 2 sites; `accentdark` `:20` = all text, 11 sites; `accentlight` `:19` = **0 sites, dead code, delete**); blast radius = 2 literals, no macro/body/CSS; résumé↔site coupling is text-only.
- `.planning/research/SUMMARY.md` — the 3 palette proposals (deep navy / oxblood / graphite mono) + grayscale conversions, the `sed`+`latexmk` build note, and the "teal stays is legitimate / burden of proof on the challenger" framing.

### Source artifacts (the sync targets + source of truth)
- `docs/main.tex` — color defs at `:17-26` (`\usepackage{xcolor}`, `accent`/`accentlight`/`accentdark`); and the **shipped résumé content the site must mirror**, resolve each by content: the Adobe block, `\section{Selected Projects}` (= `rollout` + `graph_ml`), `\section{Education}`, `\section{Publications}`. Live company-name accent lines at write time: 149/172/186/199/206.
- `index.html` (756 lines) — the sync target. Section map (resolve by content; line anchors at write time): hero/about `34-55`, Education `79-113`, Publications `114-135`, Research `136-175`, Experience `176-324` (Adobe `182-206`, retired figures `:196`, career-break `207-226`, Swiggy/Flipkart/Groupon/Netspeed below), Teaching `326-366`, **Competitive D.S. Experience `368-475` (PRUNE)**, **Projects `478-616` (REPLACE → rollout+graph_ml)**, **Certifications `620-739` (PRUNE)**.
- `.github/workflows/jekyll.yml` — publishes `index.html` to GitHub Pages on push to `master` (context: the sync goes live on push; commits stay local until the owner pushes).

### Gate surfaces
- `scripts/verify-resume.sh` — must stay green after the palette swap (palette is color-only → no content gate impact) and after any résumé touch; the DONE signal is `bash scripts/verify-resume.sh` exit 0.
- `scripts/verify-phase4-regressions.sh` / `scripts/verify-phase5-regressions.sh` — the **model** for the new site net (standalone target + chained into `make verify`; each assertion class proven failable). The site net greps HTML source directly — the `$SQUEEZED` multi-word rule does not carry over.
- `docs/verify/manifest.txt` — no palette gate lives here (color is not asserted); referenced only so a palette edit is understood to be gate-neutral.

### Evidence / honesty boundary (for the Adobe-block rewrite)
- `.planning/research/CODEBASE-EVIDENCE.md` — binds the site Adobe rewrite to the same honest framing as the résumé: NO retired figures, NO speculative decoding / Go / TensorRT-LLM / MoE-TP-PP as accomplishments; fault-tolerance / distributed-inference / torch.compile / Rust-governance are the evidenced themes.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- **`docs/main.tex` xcolor block** (`:17-26`): three `\definecolor` lines today; after this phase, two (`accent`, `accentdark`) — `accentlight` deleted. `hyperref` link/cite/url colors (`:23-25`) follow `accentdark` automatically.
- **`sed` + `latexmk` variant build** for palette samples (`make build` hardcodes `JOBNAME`, cannot emit variants) — copy `main.tex` to scratch, substitute the 2 hex literals, build, `pdftotext`/measure. Same isolated-scratch discipline the harness research used.
- **`index.html` section containers** are uniform Bootstrap/timeline markup: `<ul class="timeline">` + `<li class="timeline-item">` for Experience/Education/Research/Teaching; `col-md-4 col-sm-12` cards for the Projects/Competitive grids. Pruning/replacing is container-scoped, no CSS change.
- **`REGRESS2`–`REGRESS5` nets** (`scripts/verify-phase{2..5}-regressions.sh`, wired in `make verify`) — the pattern for the new site net (numbered assertions, each failable, standalone target + `make verify` chain).

### Established Patterns
- **Resolve every `docs/main.tex` and `index.html` line reference by CONTENT**, never by a stored number — every prior wave shifted line numbers.
- **Single-file LaTeX**; artifacts (`.pdf`/`.log`/`.fdb_latexmk`/`.aux`/`.fls`/`.out`) ride in the **source commit**; **never `make clean`**; gate on `bash scripts/verify-resume.sh` exit 0 (`make verify` collapses exit 1/2).
- **Palette = 2 hex literals, zero layout/CSS effect**; **palette ↔ site independence** (résumé LaTeX color only; site CSS untouched).
- **Site net greps raw HTML** — no `pdftotext` reflow, so no `$SQUEEZED` multi-word handling needed (unlike the résumé nets).

### Integration Points
- `docs/main.tex:18,20` (apply palette) + `:19` (delete `accentlight`) — the only palette edit sites.
- `Makefile` — add the site net as a target and chain it into `make verify` (alongside `REGRESS2`–`REGRESS5`).
- `index.html` — section-scoped edits (Adobe rewrite, Education trim, Projects replace, Competitive/Certifications prune, career-break removal, hero/about sweep).
- `.github/workflows/jekyll.yml` — the publish path; the sync ships publicly on the owner's push (not before).

</code_context>

<specifics>
## Specific Ideas

- Palette samples: **4 columns** (navy, oxblood, graphite, teal), each a single-hue family, each paired with its grayscale conversion, all rendering the **final** résumé content; built via the `sed`+`latexmk` harness; judged on the fixed WCAG bar. VIS-01 pick is a blocking checkpoint; **teal stays** is a valid pick.
- Site `rollout` + `graph_ml` content should **mirror the résumé's shipped `\section{Selected Projects}`** (source of truth = `docs/main.tex`, resolve by content) — same capability wording the owner already confirmed (GH-03), rendered for the web.
- Site Adobe block: fault-tolerance / distributed-inference lead + `torch.compile(max-autotune)` + Rust governance/lineage, at the generalized public register (D-08/D-09).
- Final acceptance (criterion 5, résumé side): `make verify` green + the **plain-text paste test** (paste the PDF as plain text into a form field, read order + handle + URLs intact) — run once.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope. (Full portfolio-site content refresh remains **PORT-01, v2 backlog** per REQUIREMENTS.md; re-coloring the *site* stays out of scope — palette is résumé-only, roadmap-locked. A genuinely distinct two-tone palette was considered and rejected in favor of single-hue, D-02 — a decision, not a deferral.)

</deferred>

---

*Phase: 6-palette-site-sync*
*Context gathered: 2026-08-24*
