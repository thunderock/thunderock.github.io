# Roadmap: thunderock.github.io — Resume & Portfolio

## Overview

Milestone v1.0 repositions the LaTeX resume (and the site text that mirrors it) for Staff MLE / inference-framework roles. This is a constrained-optimization job, not a writing job: page 1 is measured **99.98% full (0.15pt of slack)** and `make build` is provably **silent on a 3-page overflow** (exit 0, zero warnings). So the journey is forced by mechanics, not preference — **build the gate, earn the budget, then spend it.** Phase 1 stands up `make verify` (expected to *fail* on today's PDF — five defects are live; that is the harness working). Phase 2 frees the ≈12 page-1 lines that everything downstream spends, and clears the zero-cost text-layer defects. Phase 3 spends that budget on the Adobe Firefly rebuild and the staff-signal bullet pass. Phase 4 restructures page 2 behind its independent 53.5pt budget and makes the GitHub repos it links to click-through-safe. Phase 5 derives Skills from the now-finalized bullet vocabulary. Phase 6 chooses a palette against the document the user will actually ship and syncs `index.html`.

**Scope note for downstream planners:** the research recommended a ≤2-line summary/headline section. `REQUIREMENTS.md` **Out of Scope** overrides it ("User chose fold-only; freed lines fund the Adobe rebuild instead"). No phase includes a summary section — do not re-add it during planning.

**Requirement count correction:** `REQUIREMENTS.md` states "21 total" but enumerates **23** requirement IDs (3 VERIFY + 8 EXP + 6 PG2 + 3 GH + 1 VIS + 2 SITE = 23). The ID list is authoritative; the total was an arithmetic error. All **23/23** are mapped below.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Verification Harness** - `make verify` turns "fits page 1 / ATS-parsable / dates untouched" from opinion into an exit code (completed 2026-08-22)
- [x] **Phase 2: Page-1 Budget & Text-Layer Defects** - Free the ≈12 lines the rebuild spends; fix the broken LinkedIn handle and masked URLs (completed 2026-08-22)
- [ ] **Phase 3: Adobe Rebuild & Staff-Signal Bullets** - Spend the budget on evidenced fault-tolerance / distributed-inference content
- [ ] **Phase 4: Page-2 Restructure & GitHub Presence** - Projects → `rollout` + `graph_ml`; compress page 2; make linked repos click-through-safe
- [ ] **Phase 5: Skills Rebuild** - Derive keyword-tier Skills from finalized bullets, every item interview-defensible
- [ ] **Phase 6: Palette & Site Sync** - Palette chosen against frozen content; `index.html` tells the same story

## Phase Details

### Phase 1: Verification Harness
**Goal**: The page-1 fit gate, ATS text-layer integrity, and the honesty invariants are machine-enforced before any content is touched — a silent overflow becomes impossible to ship
**Depends on**: Nothing (first phase)
**Requirements**: VERIFY-01, VERIFY-02, VERIFY-03
**Success Criteria** (what must be TRUE):
  1. `make verify` exits non-zero when the built PDF is not exactly 2 pages — demonstrated against a deliberate +5-line probe that today's `make build` accepts warning-free and exit-0
  2. `make verify` exits non-zero unless page 2 *starts at* `PUBLICATIONS`, asserted positively (testing for the absence of company names on page 2 returns a false OK on a partial spill)
  3. `make verify` exits non-zero when the `pdftotext` layer is missing a required keyword, contains a corrupted glyph/ligature, or fails to yield the LinkedIn handle and portfolio URL as literal text
  4. `make verify` exits non-zero if any of the five employment date strings or printed titles differs by a single byte from the recorded baseline, or if page geometry / `\setlist` values have drifted
  5. `make verify` run against today's committed PDF **FAILS and names each live defect** (en-dash handle, zero literal URLs, Education parse order) — and refuses to verify a PDF older than `docs/main.tex` instead of greenlighting a stale artifact
**Plans**: 3 plans (sequential, waves 1→2→3)
- [x] 01-01-PLAN.md — Baseline manifests, harness scaffolding, G0 preconditions + freshness proof
- [x] 01-02-PLAN.md — Structure gates (G1–G3), geometry + honesty freezes (G4–G5), ATS text layer (G6)
- [x] 01-03-PLAN.md — Overflow self-test (G7), negative controls, Makefile integration

### Phase 2: Page-1 Budget & Text-Layer Defects
**Goal**: The page-1 line budget every later phase spends actually exists, and the three live text-layer defects are gone — with `make verify` green for the first time
**Depends on**: Phase 1
**Requirements**: EXP-01, EXP-05, EXP-06
**Success Criteria** (what must be TRUE):
  1. Experience runs Swiggy → Adobe with no career-break row, and the master's dates are still visible in Education
  2. Groupon and NetSpeed render as one compact earlier-experience block that still reads C++ and Network-on-Chip
  3. `pdftotext` output contains `ashutosh-tiwari` (correct hyphenated handle) and zero occurrences of `ashutosh–tiwari` (en dash)
  4. The text layer carries the portfolio, GitHub, and LinkedIn URLs as literal strings a text-only parser can read — not as masked anchors
  5. `make verify` passes end-to-end, and the harness's headroom report shows **≥12 lines** of page-1 space recovered vs baseline (≈4.25 from the career-break row + a **measured 0.13 lines / 1.5pt from the fold** — this parenthetical's original fold term, ≈8 lines, is a prediction **superseded by D-08**; see the note below)

**Superseded literals** (bind these; a verification pass must not correct them backwards):
  - Criterion 3's `ashutosh-tiwari` (single hyphen) is a transcription error. The handle is **`ashutosh--tiwari`** (two ASCII hyphens), user-confirmed against a live LinkedIn probe and frozen in `docs/verify/manifest.txt` `CONTACT_LITERALS` — see STATE.md `[Phase 1 / A1]`.
  - Criterion 5's "**≥12 lines**" is superseded by decision **D-08** (`02-CONTEXT.md`): the fold keeps one descriptor line per role, so the assertion is the **measured** post-change headroom, recorded at phase close — not a hardcoded 12. Planning measurement (`02-01-PLAN.md` §measured_width_budget) puts the realistic recovery near the career-break's **4.25 lines**: `\resumeSubheading`'s two-row header must survive for `G5`'s whole-line matching of the frozen title/date/employer, so the fold itself is worth at most one rendered line per role. Measured figure: **50.4pt / 4.39 lines recovered** against the +0.1pt arrival baseline (`G3.2` page-1 headroom +0.1pt → +50.5pt; deepest content bottom 764.3pt → 713.9pt). Breakdown: career-break deletion **48.9pt / 4.26 lines** (matching manifest `CAREER_BREAK_PT=48.9` exactly), Groupon + NetSpeed fold **1.5pt / 0.13 lines** — itemize `topsep`/`itemsep` overhead only, because both descriptors wrap to two rendered lines at their locked D-05/D-06 length (167 and 164 chars against a measured 137–141-char one-line capacity), so the fold recovers zero *rendered* lines per role. This also corrects D-08's own "10–11 lines" prediction downward. No manifest threshold was moved and no locked content was shortened to improve it — D-08 designates the two descriptors as Phase 3's first re-compression lever. Measured by `02-01`; recorded here by `02-02` Task 3.

**Plans**: 2 plans (sequential, waves 1→2)
- [x] 02-01-PLAN.md — Contact line bare-URL rewrite + ligature break, career-break deletion, Groupon/NetSpeed fold, measured budget
- [x] 02-02-PLAN.md — Education city-cell drop, `EDU_CITY`/`PROBE_LINES` harness reconciliation with negative control, green gate + artifact

### Phase 3: Adobe Rebuild & Staff-Signal Bullets
**Goal**: Page-1 Experience carries the evidenced staff signal — fault tolerance, distributed GPU inference, the Rust governance subsystem, `torch.compile` — with every number traceable and no unapproved claim shipped
**Depends on**: Phase 2 (the budget must exist first — at 0.15pt of slack every draft written before Phase 2 overflows silently)
**Requirements**: EXP-02, EXP-03, EXP-04, EXP-07, EXP-08
**Success Criteria** (what must be TRUE):
  1. A retain / revise / retire decision is recorded for **every** current Adobe bullet *before* new text is written — no true claim (Falcon-40B, Llama 2 70B, KEDA-on-SQS-depth) disappears implicitly
  2. `pdftotext` output contains `torch.compile` (with the dot), and the Adobe block opens on fault-tolerance / distributed-inference language rather than job-description voice
  3. Neither "10–50×" nor "3–8K images/sec on 32 GPUs" survives anywhere in the PDF, and every figure that replaced them traces to a named entry in `CODEBASE-EVIDENCE.md`
  4. Swiggy and Flipkart bullets each carry an adoption-count or failure-class-closure claim, and the count of digit-bearing page-1 bullets is no lower than baseline (compression never silently ate the metrics)
  5. `make verify` passes with the rebuilt section in place, and the cost-savings / mentoring bullets are either shipped with the user's **explicit recorded sign-off** or absent — never present unapproved
**Plans**: 8 plans in 6 waves (wave 1 runs three plans in parallel; waves 2-6 serialize on `docs/main.tex`)
- [x] 03-01-PLAN.md — P3.x standing regression net, red on arrival, every assertion class observed failing
- [x] 03-02-PLAN.md — wire the Phase-2 net into `make`, claim the G6.13 WARN, record both on STATE.md (IG-01/IG-02/IG-03)
- [x] 03-03-PLAN.md — criterion-1 disposition record, figure→evidence traceability, budget ledger, EXP-08 drafts
- [x] 03-04-PLAN.md — Adobe rebuild: fault-tolerance lead bullet, Rust governance topic, mechanisms + figures into free tails
- [ ] 03-05-PLAN.md — D-08 config-read checkpoint, retire both unverified figures for the Ray benchmark, `torch.compile` bridge + promotion
- [ ] 03-06-PLAN.md — Swiggy/Flipkart staff-signal pass, rendered-line neutral
- [ ] 03-07-PLAN.md — EXP-08 blocking per-bullet sign-off against the rendered page
- [ ] 03-08-PLAN.md — apply approved bullets, wire the P3 net into `make`, measure and record the end state

### Phase 4: Page-2 Restructure & GitHub Presence
**Goal**: Page 2 leads with current, click-through-safe artifacts instead of seven grad-school entries, and every repo it links to says what the resume says
**Depends on**: Phase 1 (gate). Page 2 sits behind the one-way `\newpage` boundary with its own independent 53.5pt budget, so this phase has **no page-1 dependency and may run in parallel with Phase 3**
**Requirements**: PG2-01, PG2-02, PG2-03, GH-01, GH-02, GH-03
**Success Criteria** (what must be TRUE):
  1. Projects contains exactly two entries — `rollout` and `graph_ml`, rendered from the spike Variant A LaTeX drafts — and all seven 2017–2022 grad-school entries are gone
  2. A recruiter clicking `github.com/thunderock/rollout` reads a status line matching the implemented tree (18 crates, 197 test paths, CI), not "spec / pre-implementation"
  3. `github.com/thunderock/random_walk` returns 404 to an anonymous visitor
  4. The publication entry is citation + one contribution line (abstract paragraph gone); Research and Teaching each render as one line; Education emits institution before city with no GPAs and the `2021–2023` range retained
  5. The user has confirmed the `rollout` capability wording against a spoken "walk me through it" prompt, and `make verify` still passes
**Plans**: TBD

### Phase 5: Skills Rebuild
**Goal**: Skills earns maximum ATS keyword coverage from the finalized bullet vocabulary without a single item the user cannot defend in an interview
**Depends on**: Phase 3 (Skills must be *derived from* final bullet vocabulary, never the reverse) and Phase 4 (`graph_ml` featured, page-2 lines freed)
**Requirements**: PG2-04, PG2-05, PG2-06
**Success Criteria** (what must be TRUE):
  1. Skills renders in **≤3 lines** (down from 4) and `pdftotext` output contains the exact-match forms `vLLM`, `torch.compile`, `Kubernetes`, `FSDP`, `Ray`, `ONNX Runtime`, `A100`, `H100`, `CUDA graphs`, `Triton`, `Rust`, `C++`, `PyTorch Lightning`, `Flash Attention`, `KEDA`, `Spark`, `Iceberg`
  2. A visibly-labeled concept-vocabulary group carries tensor parallelism, pipeline parallelism, Mixture of Experts (MoE) parallelism, KV-cache management, and continuous batching — reading as vocabulary, not as claimed accomplishments
  3. `speculative decoding` and `Go` appear **zero** times in the extracted text of the entire document
  4. The `C++` token is anchored to NetSpeed NoC modules and `graph_ml`'s C++/Cython kernels, both verifiable by a reader from the document itself
  5. Every stretch item carries a recorded evidence tier (built / operated / evaluated) plus the user's **per-item** approval — not one blanket "looks good" on a finished list
**Plans**: TBD

### Phase 6: Palette & Site Sync
**Goal**: The artifact set ships — palette chosen against the document the user will actually send, and site text telling the same story as the rebuilt resume
**Depends on**: Phase 5 (palette samples must render frozen content; site text mirrors settled resume language). Palette and site are mutually independent — the two artifacts share zero color and zero build
**Requirements**: VIS-01, SITE-01, SITE-02
**Success Criteria** (what must be TRUE):
  1. 2–3 palette proposals plus grayscale conversions render as side-by-side PDF samples **of the final content**, each measured against text ≥7:1, rules ≥3:1, grayscale ≥4.5:1 / ≥3:1
  2. The user has picked a palette (teal staying is a legitimate outcome), it is applied via the 2 hex literals, and no unused color definition (`accentlight`) remains
  3. `index.html` hero and about text match the new resume positioning, with no remaining occurrence of a title or claim the rebuilt resume contradicts
  4. The site's own career-break timeline entry is gone from `index.html`, so resume and site agree
  5. A final `make verify` passes, and the PDF pasted as plain text into a form field reads in correct order with the handle and URLs intact
**Plans**: TBD
**UI hint**: yes

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5 → 6 (Phase 4 may run in parallel with Phase 3)

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Verification Harness | 3/3 | Complete    | 2026-08-22 |
| 2. Page-1 Budget & Text-Layer Defects | 2/2 | Complete    | 2026-08-22 |
| 3. Adobe Rebuild & Staff-Signal Bullets | 4/8 | In Progress|  |
| 4. Page-2 Restructure & GitHub Presence | 0/TBD | Not started | - |
| 5. Skills Rebuild | 0/TBD | Not started | - |
| 6. Palette & Site Sync | 0/TBD | Not started | - |

## Ordering Rationale

- **Gate before budget before content.** Phase 1 → 2 → 3 is forced, not chosen. The harness must exist because the failure mode is silent (a 3-page overflow builds clean, exit-0, zero warnings). The budget must exist because page 1 has 0.15pt of slack. The content comes last because it is the thing being sized.
- **Page 2 is parallelizable.** Phase 4 sits behind a one-way `\newpage` boundary with its own 53.5pt budget and zero page-1 coupling.
- **Skills after bullets, always.** Skills is derived from finalized bullet vocabulary — hence Phase 5 after Phases 3 and 4.
- **GitHub presence rides with the Projects swap.** GH-01/02/03 are off the LaTeX critical path, but they exist *because* `rollout` and `graph_ml` become featured links in Phase 4 — GH-02 fixes what a recruiter reads, GH-03 gates the bullet wording. Both land well before the resume is declared done.
- **Palette last-but-one, site last.** Palette touches exactly 2 hex literals with zero layout effect, so it is safely deferred to frozen content; site sync consumes settled resume language, and syncing earlier means syncing twice.

## Checkpoints

Phases carrying a mandatory user decision (planning must model these as checkpoints, not tasks):

| Phase | Requirement | What needs the user |
|-------|-------------|---------------------|
| 3 | EXP-08 | Explicit sign-off on provisional cost-savings / mentoring figures — ⚠-flagged as UNVERIFIED, never shipped silently |
| 4 | GH-03 | Confirm `rollout` capability wording survives "walk me through it" |
| 5 | PG2-04, PG2-05 | Per-item Skills approval with recorded evidence tier (a single blanket approval is the documented failure mode) |
| 6 | VIS-01 | Pick the palette from rendered samples (teal stays if none win) |

---
*Roadmap created: 2026-08-21*
