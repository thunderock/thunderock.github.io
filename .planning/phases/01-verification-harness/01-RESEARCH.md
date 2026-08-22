# Phase 1: Verification Harness - Research

**Researched:** 2026-08-21
**Domain:** Bash/Makefile verification harness over a pdfTeX LaTeX artifact (page-count gate, `pdftotext` text-layer assertions, byte-frozen honesty invariants) on macOS
**Confidence:** HIGH — every mechanism in this document was executed against the real repo artifacts in this session (poppler 26.08.0, latexmk/BasicTeX, 4 scratch `latexmk` probe builds in `mktemp -d`; `git status --porcelain` empty before and after)

---

## Summary

Phase 1 needs **no discovery** — it needs **consolidation plus mechanism verification**, exactly as `SUMMARY.md:181` predicted. Two assertion lists already exist (`ARCHITECTURE.md` §6.3 ships a runnable 5-gate script; `PITFALLS.md` specifies ~15 further assertions scattered across 25 pitfalls). Neither is complete alone, they disagree on two measurements, and — the finding that matters most — **naively merging them produces a harness that makes ROADMAP Phase 2's own success criterion 5 unachievable.** This document delivers the merged canonical spec with severity tiers that resolve that, plus verified tooling for every assertion class.

Everything measurable was re-measured this session and **all five live defects reproduced exactly**: LinkedIn handle extracts as `Linkedin@ashutosh–tiwari` (U+2013), zero literal URLs in the text layer, `Bloomington, IN` emitted before `Indiana University, Bloomington` with the date range in a detached block, role headers split into three non-adjacent blocks, level-2/level-3 bullets both flattening to `–`. The +5-line overflow probe reproduced perfectly: `latexmk` exit 0, **zero** overfull/underfull warnings, **3 pages**. Page 2 of the committed PDF starts at exactly `PUBLICATIONS`.

Four findings change the plan and are not in the upstream research:

1. **`grep -Fx` (line-exact), not `grep -F`, is the correct matcher for the frozen manifest.** Measured: `Software Development Engineer` (Groupon, bare) is a *substring* of `Software Development Engineer (Search Relevance)` (Flipkart), so `grep -F` returns 2 and cannot detect that Groupon's title changed. Every one of the 10 frozen strings occupies its own extracted line, so `grep -Fxc == 1` is exact and unambiguous.
2. **ROADMAP Phase 2 criterion 3 contains a wrong handle spelling.** It requires `pdftotext` output to contain `ashutosh-tiwari` (one hyphen). The real handle — per `docs/main.tex:134`'s own `/URI` and per `PITFALLS.md:481` — is `ashutosh--tiwari` (**two** hyphens). Measured: `grep -Fc 'ashutosh-tiwari'` = **0** against the correct double-hyphen form. Asserting ROADMAP's literal string would bake a broken handle into the gate.
3. **Staleness is provable, not heuristic — and mtime is measurably useless here.** `docs/main.tex` and `docs/AshutoshTiwari.pdf` currently carry *identical* mtimes (`1787351282`), because `git checkout` stamps every file at checkout time. But `docs/AshutoshTiwari.fdb_latexmk` is **git-tracked** and records `"main.tex" <mtime> 20113 729318505f45209be4838bdff42044c4` — latexmk's own MD5 of the source it built from, which **matches the current file**. That is a content-hash freshness proof that survives checkout. A 1.11s scratch rebuild + text-layer compare is the definitive arbiter.
4. **A naive structural anchor for the self-test probe silently targets the `\newcommand` definition.** First hit for `\resumeSubHeadingListEnd` is line **119** (the macro definition), not line 217 (the Experience usage) — which made the first probe attempt crash. The correct anchor is the page-1 region `\begin{document}`(127) … `\newpage`(219), excluding `\newcommand` lines.

**Primary recommendation:** implement `make verify` as one bash script emitting a machine-readable `RESULT <id> <PASS|FAIL|WARN|SKIP> <message>` line per assertion, with **three severity tiers** (`BLOCKER` = exit 1, `WARN` = printed with owning phase, `INFO` = reported metric) and a **two-tier manifest** (`baseline-frozen.txt` = honesty invariants, write-protected; `manifest.txt` = phase-mutable thresholds/keywords/headings). Only assertions that **Phase 2 can turn green** are BLOCKERs; everything the research recommends but `REQUIREMENTS.md` does not mandate is WARN. Zero new dependencies — poppler is already installed.

---

## Project Constraints

No `CONTEXT.md` exists for this phase (`has_context: false`), so there are no locked user decisions to copy verbatim. The binding constraints come from `ROADMAP.md`, `REQUIREMENTS.md`, `STATE.md`, and `AGENTS.md`:

| Constraint | Source | Effect on this phase |
|---|---|---|
| `make verify` must **FAIL** on today's committed PDF, naming each live defect | ROADMAP Ph1 crit 5; STATE.md:41 | Red-on-arrival is the deliverable, not a bug. No allowlist / no baseline-of-failures mechanism. |
| Gate → budget → content ordering is forced by measurement | STATE.md:40 | Phase 1 ships before any content edit. The harness may not depend on any Phase 2+ artifact. |
| Employment dates and titles: **byte-identical**, hard gate | REQUIREMENTS.md:73 (Out of Scope), VERIFY-03 | Frozen manifest; a diff fails the build. Highest-severity assertion in the milestone. |
| Summary/headline section stays Out of Scope | REQUIREMENTS.md:72; STATE.md:42 | The harness must **not** assert a Summary section exists, despite research recommending one. |
| `speculative decoding` and `Go` appear nowhere | REQUIREMENTS.md:69-70, PG2-05 | Prohibited-term assertion. **Word-boundary matching is mandatory** — measured: naive `grep -c 'Go'` returns 1, matching `Goal` (`main.tex:265`). |
| Spike findings route through the project skill | AGENTS.md | Read at `.opencode/skills/spike-findings-thunderock-github-io/` (not loadable as a skill in this runtime; files read directly). Nothing in it constrains the harness. |
| Zero new dependencies beyond poppler if needed | Task brief | Verified: poppler 26.08.0 already installed. **No new dependency required at all.** |
| Commit style: small, atomic, Conventional Commits; no internal tooling names in commit messages | Global conventions | `feat(verify): ...` / `test(verify): ...`. Never name the planning tool. |
| Personal projects ship a Makefile with `setup`/`setup-dev`/`run_tests`/`lint` | Global conventions | Existing Makefile uses `install`/`check`/`build`/`view`. See Open Question 5 — do **not** rename existing targets in this phase. |

---

## Phase Requirements

| ID | Description | Research Support |
|---|---|---|
| **VERIFY-01** | `make verify` fails when the PDF ≠ 2 pages or Experience content crosses the page-1 boundary | Assertion group **G1** (page count, 3 verified methods) + **G2** (positive boundary assertion) + **G3** (fill/headroom report, proven *insufficient alone*). Self-test **G7** reproduces the silent 3-page overflow: measured exit 0, 0 warnings, 3 pages. |
| **VERIFY-02** | `make verify` asserts ATS text-layer integrity via `pdftotext` round-trip — required keywords present, LinkedIn handle extracts correctly, no glyph/ligature corruption | Assertion group **G6**. Glyph gate upgraded from 5 ligature chars to a 4-class codepoint gate (ligature / PUA / U+FFFD / allowlist census) against the measured baseline: U+2013×40, U+2019×6, U+2022×6, U+2192×3, U+2206×2, U+00D7×1, U+2014×1, U+201C×1, U+201D×1, PUA=0, FFFD=0, ligatures=0. Keyword tiers measured (present today: `inference`10 `PyTorch`3 `Ray`3 `Spark`3 `distributed`3 `Kubernetes`2 `FSDP`2 `vLLM`2 `KEDA`2 · absent: `torch.compile` `A100` `H100` `ONNX` `CUDA` `Iceberg` `Triton` all 0). |
| **VERIFY-03** | `make verify` asserts honesty gates — all employment date strings and titles byte-identical to the recorded baseline | Assertion group **G5** (10 frozen strings, `grep -Fxc == 1`, all verified count 1) + **G4** (geometry/`\setlist` normalized hash `8b13a46b…`, line-number independent). Matcher choice is load-bearing — see Finding 1. |

---

## Architectural Responsibility Map

The "tiers" here are the layers a resume artifact passes through. Getting these wrong is how an assertion ends up unable to observe the thing it claims to gate.

| Capability | Primary Tier | Secondary Tier | Rationale |
|---|---|---|---|
| Page count / pagination | **PDF structure** (`pdfinfo`) | text layer (form-feeds) | Pagination is a property of the PDF page tree. `\raggedbottom` means the *source* cannot report it and the *log* is silent (measured: 0 warnings on a 3-page build). |
| Page-1 boundary held | **Text layer, page-scoped** (`pdftotext -f/-l`) | — | Requires per-page extraction. Cannot be observed from source or from whole-document extraction. |
| Page fill / headroom | **PDF geometry** (`pdftotext -bbox`) | — | Coordinate data only exists in the bbox XML. **Proven insufficient as a gate** — a 3-page artifact reads a misleadingly green `+2.7pt` on page 1. |
| Paper size | **PDF structure** (`pdfinfo` Page size) | — | Measured 612×792. Detects a paper-size change only, **not** `\textheight` drift. |
| Text-block geometry / `\setlist` drift | **LaTeX source** (pattern extract → hash) | PDF bbox top extent (corroborating) | `\textheight` is not recoverable from the PDF. The declaration is the only reliable observation point. |
| Employment dates & titles | **Text layer** (`grep -Fx`) | LaTeX source | The gate must assert what a *recruiter/ATS* reads, not what the source says. A source-only check misses a rendering defect (exactly how the en-dash handle survived). |
| Glyph / ligature corruption | **Text layer** (codepoint census) | — | Corruption is by definition an extraction-time property. |
| Contact literals (URLs, handle, email) | **Text layer** | LaTeX source (`\href` target) | Measured: 26 `/URI` annotations exist inside compressed object streams and are invisible to text extraction. The text layer is the only tier that matters. |
| Invisible-text stuffing | **LaTeX source** (construct blacklist) | PDF bbox (off-page words) | Extraction is colour/size-blind, so the text layer cannot distinguish hidden from visible. Source constructs + bbox-outside-page-box are the observable proxies (measured: 1218 words, 0 outside the page box). |
| Artifact freshness | **Build provenance** (`.fdb_latexmk` MD5) | scratch rebuild + text compare | mtime is measurably unreliable (identical mtimes after checkout). |
| Overflow-detection self-test | **Scratch build** (`mktemp -d`, alternate jobname) | — | Must never touch `docs/AshutoshTiwari.pdf`. Verified: repo stayed clean (0 dirty files). |

---

## Standard Stack

### Core

| Tool | Version (verified this session) | Purpose | Why standard |
|---|---|---|---|
| `pdfinfo` (poppler) | **26.08.0** at `/opt/homebrew/bin/pdfinfo` | Page count, paper size | `ARCHITECTURE.md:598` — "the single most important verification command". Structural read of the page tree; immune to text-layer quirks. |
| `pdftotext` (poppler) | **26.08.0** | Text-layer extraction: default (gate), `-raw` (monitored), `-bbox` (fill), `-f/-l` (per page) | Vendor-neutral ATS proxy; the exact tool both research files measured with. |
| `python3` | 3.x at `/Users/ashutosh/.pyenv/shims/python3` | bbox XML parsing, codepoint census, probe injection | Already required by `ARCHITECTURE.md`'s draft gate. stdlib only (`xml.etree`, `collections`, `unicodedata`, `re`). |
| `latexmk` + `pdflatex` (BasicTeX) | at `/Library/TeX/texbin` | Build; scratch probe builds | Already the project's builder. |
| `grep` / `shasum` / `md5` / `mktemp` | macOS base | Byte-exact matching, hashing, scratch dirs | Zero install. **`LC_ALL=C grep -Fx`** is the load-bearing form — verified byte-exact against a UTF-8 en dash. |
| GNU `make` | macOS base | `verify` / `verify-selftest` / `verify-baseline` targets | Extends the existing Makefile. |

### Supporting / considered-and-rejected

| Tool | Status | Verdict |
|---|---|---|
| `mdls -name kMDItemNumberOfPages` | present (`/usr/bin/mdls`), returned `2` | **Do not use.** Spotlight-dependent — returns null on unindexed volumes and on freshly-written files before indexing. `pdfinfo` is deterministic. |
| form-feed counting (`pdftotext … \| tr -cd '\f' \| wc -c`) | verified = `2` (one FF per page incl. last) | **Fallback only.** Exactly equals page count today. Keep as a documented cross-check if poppler's `pdfinfo` is ever unavailable; not the primary. |
| `qpdf` | **NOT installed** | Not needed. Nothing in the assertion set requires object-level PDF surgery. Do not add. |
| `gs` (Ghostscript) | present at `/usr/local/bin/gs` (MacTeX-supplied, not brew) | Not needed for Phase 1. Reserve for Phase 6 grayscale palette rendering (VIS-01). |
| `pdffonts` / `pdfimages` | present (poppler) | `INFO`-tier only. `pdffonts` could assert every font carries `uni=yes`; nice-to-have, not required by any criterion. |
| `pdfminer.six` / Apache Tika | not installed | **Reject.** Would add a Python/Java dependency to satisfy `PITFALLS.md`'s "≥2 extractors" — but that requirement is satisfied by poppler's ≥2 *modes* (default + `-raw`), which is what `PITFALLS.md:522` actually specifies. |
| `slopcheck` | N/A | No language-registry packages are installed by this phase. See Package Legitimacy Audit. |

**Installation:** none required. Poppler is already present. For a clean machine, the correct `make install` addition is:

```bash
brew install poppler        # formula name verified: `poppler`, installed 26.08.0
```

`make check` should gain `pdfinfo` / `pdftotext` / `python3` rows alongside the existing `pdflatex` / `latexmk` / `tlmgr` rows, and `make verify` must fail-fast with that exact `brew install poppler` hint if either binary is missing.

### Alternatives considered

| Instead of | Could use | Tradeoff |
|---|---|---|
| One bash script | Python script | Python gives better structure, but bash keeps the harness readable as a Makefile citizen and matches `ARCHITECTURE.md`'s draft. **Chosen: bash orchestrator + small inlined `python3 - <<'PY'` blocks** for bbox XML and the codepoint census only. |
| `bats` / `shunit2` test framework | — | Adds a dependency to test a ~300-line script whose entire contract is an exit code and `RESULT` lines. The self-test target (G7) covers it. **Reject.** |
| Freezing the whole text layer | Frozen manifest of 10 strings | Bullets change every phase, so a whole-text-layer freeze would fail on every commit and get disabled. **Freeze only the honesty invariants** (task brief item 3). |

---

## Package Legitimacy Audit

This phase installs **zero** language-registry packages (no npm, no PyPI, no crates). The only external dependency is the Homebrew formula `poppler`, which is already installed and is the upstream tool both research files measured with.

| Package | Registry | Age | Downloads | Source repo | slopcheck | Disposition |
|---|---|---|---|---|---|---|
| `poppler` | Homebrew core | upstream project since 2005 (`Copyright 2005-2026 The Poppler Developers`, printed by the installed binary) | n/a (brew formula) | poppler.freedesktop.org | **N/A** — brew formula, not an npm/PyPI package | **Approved.** Already installed 26.08.0, verified via `brew info` and `ls -l /opt/homebrew/bin/pdftotext` → `../Cellar/poppler/26.08.0/bin/pdftotext`. |

**Packages removed due to slopcheck [SLOP] verdict:** none — no candidate packages existed.
**Packages flagged as suspicious [SUS]:** none.

`slopcheck` was **not run**: it targets npm/PyPI/crates namespaces and this phase adds no package from any of them. The hallucination vector it defends against (a plausible-sounding registry name) does not apply to a formula whose binary is already on disk, whose provenance was read from the Cellar symlink, and whose version string was printed by the executable itself. Recorded as `[VERIFIED: local binary + brew metadata]`, not `[VERIFIED: npm registry]`.

---

## Assertion-List Merge: Reconciliations (do these before writing the spec)

`SUMMARY.md:181` flagged that the two lists must be merged. Six reconciliations are needed; two are measurement conflicts and four are semantic. **Reconciliation R6 is the one that changes the phase plan.**

### R1 — Line height: 11.5pt vs 11.0pt → **11.5pt** `[VERIFIED: session measurement]`

`ARCHITECTURE.md:170` measured 11.5pt/line (linear across 4 additions); `PITFALLS.md:42` measured a modal 11.0pt. `SUMMARY.md:211` directs the conservative pair. **11.5 is the conservative choice for headroom *reporting*** because a larger divisor yields a smaller line count: page-2 slack 53.5pt reads `+4.65 lines` at 11.5 vs `+4.86` at 11.0. Harness constant: `LINE_PT=11.5`. Verified this session: bbox page-2 headroom `+53.5pt (~+4.65 lines)`.

### R2 — Career-break block: 48.9pt vs 50.0pt → **48.9pt / 4.25 lines**

Conservative = the smaller budget. Not a Phase 1 *assertion* but it is the number the harness's headroom report is read against by ROADMAP Phase 2 criterion 5 ("≥12 lines recovered"). Record `48.9pt / 4.25 lines` in `manifest.txt` as `CAREER_BREAK_PT`.

### R3 — "Page-1 fullness" reference line: ceiling 764.4pt vs bottom whitespace 27.7pt → **not a conflict; different reference lines**

`792 − 764.3 = 27.7`. `ARCHITECTURE.md` measures headroom down from the text-block ceiling (764.4pt → `+0.1pt` slack); `PITFALLS.md:625` measures whitespace up from the physical page edge (27.7pt). Identical measurement, two framings — verified this session: `p1 top=27.3 bottom=764.3 headroom=+0.1pt`.

**The reconciliation is about *intent*, not arithmetic.** `PITFALLS.md`'s "bottom whitespace ≥ 27.7pt" is not a page-fit gate — as a fit gate it is the same fill measurement the research proved insufficient (a 3-page artifact reads green). Its real intent, stated in the same bullet, is *"so the fit constraint cannot be met by eating the bottom margin"* — a **margin-integrity** assertion. The direct enforcement of that is the geometry-source freeze (R-next), not a bbox threshold. **Resolution:** adopt the ceiling framing (764.4pt) for the headroom report; keep bottom-whitespace as an `INFO` metric for traceability; make the geometry freeze the hard margin gate.

### R4 — Geometry drift observation point → **LaTeX source, pattern-extracted and hashed**

`PITFALLS.md:626` requires zero diffs to `\oddsidemargin`, `\evensidemargin`, `\textwidth`, `\topmargin`, `\textheight` and the `\setlist` values. `pdfinfo` reports only paper size (612×792) and **cannot** see `\textheight`. Line-number extraction is wrong because line numbers shift as content changes (they will, every phase). **Resolution:** regex-extract, normalize whitespace, sort, hash.

Verified this session — extraction is line-number independent and yields a stable hash:

```
\addtolength{\evensidemargin}{-0.5in}
\addtolength{\oddsidemargin}{-0.5in}
\addtolength{\textheight}{1.2in}
\addtolength{\textwidth}{1in}
\addtolength{\topmargin}{-.6in}
\setlist[itemize]{leftmargin=1.4em, labelsep=0.4em, parsep=0pt, partopsep=0pt}
\setlist[itemize,2]{itemsep=0.5pt, topsep=1pt}
\setlist[itemize,3]{itemsep=0.25pt, topsep=0.5pt, leftmargin=1.3em}
→ sha256 8b13a46bf5716cb9bb9042a4e1bb60a9d6919fd5f347a34ecdc6122d7f465a56
```

Note the `\setlist[itemize]` declaration spans **two source lines** (`main.tex:69-70`) — a per-line grep misses half of it. Use the brace-balanced regex in Code Examples.

### R5 — Section-heading names → **manifest-mutable, assert what exists TODAY**

`ARCHITECTURE.md:483` asserts `WORK EXPERIENCE / EDUCATION / TECHNICAL SKILLS / SELECTED PROJECTS`. `PITFALLS.md:545` asserts `SKILLS / EDUCATION / PUBLICATIONS / SELECTED PROJECTS` and *separately* (Pitfall 9) mandates renaming `Technical Skills`→`Skills`; `SUMMARY.md:69` adds `Selected Projects`→`Projects`.

**`REQUIREMENTS.md` mandates neither rename.** PG2-03 and PG2-04 do not mention section names, and ROADMAP Phase 4/5 criteria do not either. A harness that hardcodes `SKILLS` fails on day one for a defect nobody is chartered to fix; one that hardcodes `TECHNICAL SKILLS` blocks a legitimate future rename. **Resolution:** section headings live in the **mutable** manifest, seeded with today's verified strings (`WORK EXPERIENCE`, `PUBLICATIONS`, `EDUCATION`, `RESEARCH EXPERIENCE / INDEPENDENT STUDY`, `TEACHING EXPERIENCE`, `SELECTED PROJECTS`, `TECHNICAL SKILLS`). A renaming phase edits one manifest line in the same commit. Flagged as Open Question 2.

### R6 — Severity: which assertions may exit non-zero? → **THE PLAN-CHANGING RECONCILIATION**

`ROADMAP.md` Phase 2 criterion 5 states: *"`make verify` passes end-to-end."* Phase 3 criterion 5 and Phase 4 criterion 5 repeat it. But `PITFALLS.md` assigns several "Phase 0 assert" items to defects whose **fix is owned by a later phase or by no requirement at all**:

| Live defect / assertion | Fix owned by | In `REQUIREMENTS.md`? | If a BLOCKER in Phase 1 → |
|---|---|---|---|
| en-dash LinkedIn handle | **Phase 2** (EXP-06) | ✅ yes | fine — Phase 2 turns it green |
| zero literal URLs in text layer | **Phase 2** (EXP-06 + ROADMAP Ph2 crit 4) | ✅ yes | fine |
| Education parse order (`Bloomington, IN` before institution) | **Phase 4** (PG2-03) — but Phase 2 already edits Education via EXP-01 | ✅ yes (Phase 4) | ❌ **breaks Phase 2 crit 5** unless the fix moves to Phase 2 |
| Skills > 3 rendered lines (measured: **4** today) | **Phase 5** (ROADMAP Ph5 crit 1) | ROADMAP only | ❌ **breaks Phase 2, 3 and 4 crit 5** |
| role header splits employer/title/dates | nobody (research recommendation; `SUMMARY.md:137` suggests Phase 3) | ❌ no | ❌ breaks Phases 2–6 permanently |
| bullets are `–` not `•`; 3-level nesting flattens | nobody | ❌ no | ❌ breaks Phases 2–6 permanently |
| `\justifying` present | nobody | ❌ no | ❌ breaks Phases 2–6 permanently |
| palette contrast criteria | **Phase 6** (VIS-01) | ✅ yes (Phase 6) | ❌ breaks Phases 2–5 |
| `index.html` ↔ PDF contradiction | **Phase 6** (SITE-01/02) | ✅ yes (Phase 6) | ❌ breaks Phases 2–5 |
| `torch.compile`, `A100`, `H100`, `ONNX`, `CUDA`, `Iceberg`, `Triton` keywords (all **0** today) | **Phase 3 / Phase 5** | ✅ yes | ❌ breaks Phase 2 crit 5 |

**Resolution — three severity tiers, and the BLOCKER set is defined by "what Phase 2 can turn green":**

- **BLOCKER** — exits non-zero. Either passes today, or is one of the defects ROADMAP Phase 1 criterion 5 names and Phase 2 fixes.
- **WARN** — printed with `RESULT <id> WARN … (owner: Phase N)`, does not affect exit code. A later phase **promotes** it to BLOCKER by editing one manifest line in the same commit that fixes it. This is the promotion mechanism, and it is *not* an allowlist: nothing is ever silently excused, every WARN prints with its owner on every run.
- **INFO** — a reported metric (headroom in lines, `-raw` divergence, bottom whitespace, non-ASCII census).

ROADMAP Phase 1 criterion 5 names exactly three live defects — *en-dash handle, zero literal URLs, Education parse order*. The first two are Phase 2 (EXP-06). The third is nominally Phase 4 (PG2-03) but **Phase 2 already rewrites Education under EXP-01** ("Education section carries the master's dates"), and the fix is a `\resumeSubheading` argument reorder with no page-1 cost. **Recommendation:** make Education parse order a BLOCKER and record in the plan that Phase 2 lands it (double-covered by PG2-03 as a re-assert). That is the only assignment under which Phase 1 crit 5 and Phase 2 crit 5 are simultaneously satisfiable. Flagged as Open Question 1 — the planner should confirm rather than assume.

---

## The Canonical Assertion Spec

One deduplicated list. **Source** column: `A` = `ARCHITECTURE.md` §6.3, `B` = `PITFALLS.md`, `D` = derived/new this session. **Today** = measured behaviour against the committed `docs/AshutoshTiwari.pdf` this session.

### G0 — Preconditions (fail fast, before any assertion)

| ID | Assertion | Source | Serves | Guards | Sev | Today |
|---|---|---|---|---|---|---|
| G0.1 | `pdfinfo`, `pdftotext`, `python3` on PATH; else exit 2 with `brew install poppler` hint | D | all | — | BLOCKER | PASS (all present) |
| G0.2 | `docs/AshutoshTiwari.pdf` and `docs/main.tex` exist and are non-empty | D | all | — | BLOCKER | PASS |
| G0.3 | **PDF was provably built from the current `main.tex`** — else refuse (exit 2), do not verify | A:503, ROADMAP Ph1 crit 5b | 01 | P22 | BLOCKER | PASS — `.fdb_latexmk` MD5 `729318505f…` == current `md5 docs/main.tex` |
| G0.4 | mtime relationship reported, never gated | D | 01 | — | INFO | main.tex and PDF mtimes **identical** (`1787351282`) — `-nt` is indeterminate |

### G1 — Page count (VERIFY-01)

| ID | Assertion | Source | Serves | Guards | Sev | Today |
|---|---|---|---|---|---|---|
| G1.1 | `pdfinfo … \| awk '/^Pages:/{print $2}'` == `2` | A-G1, B:625 | 01 | P22 | **BLOCKER** | PASS (2) |
| G1.2 | form-feed count in default extraction == page count (cross-check) | D | 01 | P22 | INFO | PASS (2 == 2) |

### G2 — Page-1 boundary (VERIFY-01)

| ID | Assertion | Source | Serves | Guards | Sev | Today |
|---|---|---|---|---|---|---|
| G2.1 | **first non-empty line of page 2 matches the manifest's page-2 opening heading (`PUBLICATIONS`), case-insensitively** | A-G2c | 01 | P19, P22 | **BLOCKER** | PASS — measured byte-exact `PUBLICATIONS\n` |
| G2.2 | page 1 contains the Experience section heading (`WORK EXPERIENCE`) | A-G2a | 01 | P19 | **BLOCKER** | PASS |
| G2.3 | page 1 contains the **last** Experience employer name from the manifest (`NETSPEED SYSTEMS (Acquired by Intel)`) | A-G2b | 01 | P22 | **BLOCKER** | PASS (`grep -Fxc` = 1) |
| G2.4 | zero Experience employer names appear on page 2 | D | 01 | P22 | INFO **only** | PASS — *and proven unsafe as a gate*, see below |

> **G2.4 is INFO because it returns false OK — reconfirmed independently this session.** A +4-line probe produced a **3-page** document whose page 2 begins `Software Engineer / Sep. 2015 – Aug. 2016 / GRAPH ALGORITHMS, NETWORK ON CHIP` — the NetSpeed *title* line spilled ahead of the employer. A negative test for `swiggy|flipkart|groupon|netspeed|adobe` happened to catch that one (the employer landed on p2 line 6), but the +5-line probe's page 2 opened with `Groupon operates.` and `ARCHITECTURE.md:504` recorded a third probe opening with `Breakdown.` — **which matches no company name at all.** The spill fragment is a function of the injection point and cannot be enumerated. G2.1's positive assertion discriminated correctly on every probe state measured (committed, +4, +5).

### G3 — Fill / headroom (VERIFY-01 support)

| ID | Assertion | Source | Serves | Guards | Sev | Today |
|---|---|---|---|---|---|---|
| G3.1 | every page's content bottom ≤ ceiling **764.4pt** | A-G3 | 01 | P22 | **BLOCKER** | PASS (p1 764.3, p2 710.9) |
| G3.2 | per-page headroom reported in pt **and in lines at 11.5pt/line** | A-G3, R1 | 01 | P22, P23 | INFO | p1 `+0.1pt (+0.01 lines)`, p2 `+53.5pt (+4.65 lines)` |
| G3.3 | page-1 bottom whitespace vs the 27.7pt baseline | B:625, R3 | 01 | P22 | INFO | 27.7pt (identical framing to G3.1) |
| G3.4 | zero words positioned outside the page box (`xMin<0 \|\| yMin<0 \|\| xMax>W \|\| yMax>H`) | D, B:245 | 02 | P7 | **BLOCKER** | PASS (1218 words, 0 outside) |

> **G3.1 alone can never replace G1.1.** Verified again: on the 3-page artifact, page-1 headroom reads positive because once content spills, page 1 is no longer the binding page.

### G4 — Geometry & spacing freeze (VERIFY-03; ROADMAP Ph1 crit 4 second clause)

| ID | Assertion | Source | Serves | Guards | Sev | Today |
|---|---|---|---|---|---|---|
| G4.1 | normalized sha256 of the five `\addtolength` geometry declarations + the three `\setlist` declarations == frozen value | B:626 | 03 | P22 | **BLOCKER** | PASS (`8b13a46b…`) |
| G4.2 | `pdfinfo` `Page size` == `612 x 792 pts (letter)` | D | 03 | P22 | **BLOCKER** | PASS |
| G4.3 | page-1 top content extent within `27.3 ± 1.0pt` (corroborates `\topmargin`) | D | 03 | P22 | WARN (owner: n/a — corroboration) | PASS (27.3) |
| G4.4 | ATS switch intact: source contains `\input{glyphtounicode}` **and** `\pdfgentounicode=1` | A:195 | 02 | — | **BLOCKER** | PASS (`main.tex:15,60`) |
| G4.5 | source contains `\raggedbottom` (documents *why* G1.1 exists; its removal would change overflow semantics) | D | 01 | P22 | INFO | PASS (`main.tex:46`) |

### G5 — Honesty freeze (VERIFY-03; ROADMAP Ph1 crit 4 first clause)

| ID | Assertion | Source | Serves | Guards | Sev | Today |
|---|---|---|---|---|---|---|
| G5.1 | each of the **5 employment date strings** appears **exactly once as a whole extracted line** (`LC_ALL=C grep -Fxc` == 1) | B:157 | 03 | P3, P15 | **BLOCKER** | PASS ×5 |
| G5.2 | each of the **5 printed titles** appears exactly once as a whole extracted line | B:157, B:452 | 03 | P3, P15 | **BLOCKER** | PASS ×5 |
| G5.3 | zero occurrences of `Staff` and of a slash-hedged title (`/Staff`, `Senior/`) anywhere in the extracted text | B:452, B:858 | 03 | P15 | **BLOCKER** | PASS (0) |
| G5.4 | count of digit-bearing page-1 bullet-initial lines ≥ manifest floor | B:649 | 03 | P23 | WARN (owner: Phase 3) | 7 today |
| G5.5 | the 5 **employer names** each appear exactly once as a whole extracted line | D | 03 | P8, P25 | **BLOCKER** | PASS ×5 |

> **G5's matcher is load-bearest.** `grep -F` cannot do this job: `Software Development Engineer` (Groupon) is a substring of `Software Development Engineer (Search Relevance)` (Flipkart), so `grep -Fc` returns **2** for the bare form and would report PASS even if Groupon's title were deleted. Measured: every one of the 10 frozen strings is its own extracted line, so `grep -Fxc` returns exactly **1** for each — including the ambiguous pair. Use `LC_ALL=C grep -Fxc` and require `== 1`, not `>= 1`.
>
> **Store the extracted form, not the source form.** The frozen dates in the text layer use **U+2013** (`Jul. 2024 – Present`) because LaTeX converts the source's `--`. Verified: `LC_ALL=C grep -F` matches a UTF-8 en-dash needle byte-exactly. The manifest must be UTF-8 and matched under `LC_ALL=C`.
>
> **Do not freeze `Career Break for Master's Degree`.** It sits in a `\resumeSubheading` title slot but is not an employment title, and Phase 2 (EXP-01) deletes it legitimately. Freezing it would block Phase 2.

### G6 — ATS text-layer integrity (VERIFY-02)

| ID | Assertion | Source | Serves | Guards | Sev | Today |
|---|---|---|---|---|---|---|
| G6.1 | zero ligature codepoints U+FB00–U+FB06 | A-G4a | 02 | P17 | **BLOCKER** | PASS (0) |
| G6.2 | zero Private-Use-Area codepoints U+E000–U+F8FF | D | 02 | P17 | **BLOCKER** | PASS (0) |
| G6.3 | zero U+FFFD replacement characters | D | 02 | P17 | **BLOCKER** | PASS (0) |
| G6.4 | every non-ASCII codepoint present is in the manifest allowlist | D | 02 | P17 | WARN (owner: any phase adding punctuation) | PASS — census exactly U+2013×40, U+2019×6, U+2022×6, U+2192×3, U+2206×2, U+00D7×1, U+2014×1, U+201C×1, U+201D×1 |
| G6.5 | every manifest `required-now` keyword present, **case-sensitive** | A-G5 promoted | 02 | P5, P19 | **BLOCKER** | PASS — `inference`10 `PyTorch`3 `Ray`3 `Spark`3 `distributed`3 `Kubernetes`2 `FSDP`2 `vLLM`2 `KEDA`2 `Flash Attention`1 `Rust`1 `SQS`1 `fault`1 |
| G6.6 | every manifest `target` keyword, with its owning phase printed | A-G5 | 02 | P5 | WARN (owner: Phase 3/5) | `torch.compile` `A100` `H100` `ONNX` `CUDA` `Iceberg` `Triton` = **0** each |
| G6.7 | zero occurrences of prohibited terms — `speculative decoding`, `Go` (**word-boundary**) | B:853, REQ:69-70 | 02 | P10 | **BLOCKER** | PASS — `grep -owc 'Go'` = 0 |
| G6.8 | every manifest canonical section heading extracts | A-G4b, B:545 | 02 | P19 | **BLOCKER** | PASS ×7 |
| G6.9 | contact literals present: `findashutoshtiwari@gmail.com`, `ashutosh--tiwari` (two ASCII hyphens), `github.com/thunderock`, `thunderock.github.io` | B:481, A-G4c | 02 | P16 | **BLOCKER** | **FAIL** — email ✅ 1; handle ❌ 0; `github.com/thunderock` ❌ 0; `thunderock.github.io` ❌ 0 |
| G6.10 | **zero** occurrences of the corrupted handle `ashutosh–tiwari` (U+2013) | ROADMAP Ph2 crit 3 | 02 | P16 | **BLOCKER** | **FAIL** — 1 occurrence |
| G6.11 | `-raw` mode extraction run and its divergence reported | B:522 | 02 | P18 | INFO | reports word-gluing (`ADOBEFIREFLY`, …) — **never gate on this** |
| G6.12 | Education: institution line and its date-range line within N lines of each other (`N` from manifest, default 3) | B:140, B:845 | 02 | P2, P8 | **BLOCKER** *(see R6)* | **FAIL** — `Bloomington, IN`(12) → `Indiana University, Bloomington`(14) → `Aug. 2021 – May 2023`(**17**), and the city precedes the institution |
| G6.13 | each role: employer, title and date range within a small line window | B:276 | 02 | P8 | WARN (owner: unassigned) | FAIL — split into 3 non-adjacent blocks |
| G6.14 | Skills section rendered line count ≤ manifest target | B:852 | 02 | P9 | WARN (owner: Phase 5) | 4 today, target 3 |
| G6.15 | source contains no invisible-text construct: `\textcolor{white}`, `\color{white}`, `\phantom`, `\hspace*{-`, `\vspace*{-`, or a `\definecolor` whose luma > 0.9 | B:245 | 02 | P7 | **BLOCKER** | PASS — but note `accentlight #E4EFEC` is 92.3% gray and **defined-but-unused**; assert *usage*, not definition, or this false-positives (Open Question 4) |

### G7 — Self-test (ROADMAP Ph1 crit 1)

| ID | Assertion | Source | Serves | Guards | Sev | Today |
|---|---|---|---|---|---|---|
| G7.1 | probe build (`+N` injected `\resumeItem` lines, scratch dir, alternate jobname) exits 0 with **zero** overfull/underfull — proving the premise "today's `make build` accepts it warning-free" | ROADMAP crit 1 | 01 | P22 | **BLOCKER** | PASS — measured exit 0, 0 warnings |
| G7.2 | the probe PDF is **>2 pages** — guards against probe rot as headroom grows | D | 01 | P22 | **BLOCKER** | PASS (3 pages at N=5) |
| G7.3 | `verify --pdf <probe>` exits non-zero **and** emits `RESULT G1.1 FAIL` and `RESULT G2.1 FAIL` | ROADMAP crit 1 | 01 | P22 | **BLOCKER** | PASS (both fail on the probe) |
| G7.4 | `docs/AshutoshTiwari.pdf` byte-unchanged and `git status --porcelain` empty after the self-test | D | 01 | — | **BLOCKER** | PASS — 0 dirty files, docs/ mtime unchanged |

### Deferred out of Phase 1 (documented so they are not silently lost)

| Assertion | Source | Owner | Why not now |
|---|---|---|---|
| Palette contrast: text ≥7:1, rules ≥3:1, grayscale ≥4.5:1 / ≥3:1, zero unused colour definitions | B:567-575 | **Phase 6** (VIS-01) | Needs the palette-sample harness and `gs` grayscale conversion; asserting today's values adds no gate value since today's palette already clears every bar. |
| `index.html` title/employer/date strings must not contradict the PDF | B:672 | **Phase 6** (SITE-01/02) | Cross-artifact; the resume side is not final until Phase 5. |
| bullets are `•`; ≤2 nesting levels; `\justifying` removed | B:860 | **unassigned** | Not in `REQUIREMENTS.md`. Ship as G6.13-class WARN or omit; do **not** gate. |
| "no term appears ≥3×" (keyword-density ceiling) | B:848 | Phase 3 | Measured `inference`=10 today. A ceiling of 3 would fail immediately for a defect nobody is chartered to fix. Report the count as INFO. |
| `PyTorch` exact-match casing | D | Phase 5 (PG2-04) | New finding: the Skills line writes `Pytorch` (4×) while bullets write `PyTorch` (3×). ATS matching is literal, so `Pytorch` earns nothing. Worth a WARN; belongs to the Skills rebuild. |

---

## Tooling per Assertion Class (all commands executed this session)

### Class 1 — Page count

| Method | Command | Result | Verdict |
|---|---|---|---|
| **`pdfinfo`** | `pdfinfo "$PDF" \| awk '/^Pages:/{print $2}'` | `2` | **Primary.** Deterministic structural read. |
| form-feeds | `pdftotext "$PDF" - \| tr -cd '\f' \| wc -c` | `2` | Cross-check. `pdftotext` emits one `\f` per page **including the last**, so the raw count equals the page count (do *not* add 1). |
| `mdls` | `mdls -name kMDItemNumberOfPages -raw "$PDF"` | `2` | **Reject.** Spotlight index dependency — returns `(null)` on unindexed volumes / not-yet-indexed files. |
| `gs` | `gs -q -dNODISPLAY -c "…pdfpagecount…"` | invocation failed | **Reject.** Fragile PostScript invocation, no benefit over poppler. |

### Class 2 — Page-boundary detection

```bash
p2first=$(pdftotext -f 2 -l 2 "$PDF" - | grep -m1 .)
printf '%s' "$p2first" | grep -qi '^PUBLICATIONS$' || fail
```

Measured on the committed PDF: `od -c` of the first non-empty page-2 line is exactly `P U B L I C A T I O N S \n` — byte-clean, no leading whitespace. `\scshape` (`main.tex:54`) round-trips to real uppercase, so match case-insensitively and anchor. `-f 2 -l 2` behaves correctly on 3-page artifacts (tested).

### Class 3 — Fill / headroom (`pdftotext -bbox`)

```bash
pdftotext -bbox "$PDF" "$TMP/bbox.xml"
```

Parsed with stdlib `xml.etree`. Measured: `p1 pageW=612 pageH=792 top=27.3 bottom=764.3 headroom=+0.1pt`, `p2 top=27.4 bottom=710.9 headroom=+53.5pt`.

**Determinism caveat (new finding):** two independent builds of identical source produce `-bbox` XML that differs **only** in two lines:

```
<meta name="CreationDate" content="2026-08-21T20:46:24-07"/>
<meta name="ModDate"      content="2026-08-21T20:46:24-07"/>
```

Everything else — every word coordinate — is byte-identical. So `-bbox` output *is* usable for build-to-build comparison after filtering: `grep -v 'name="\(Creation\|Mod\)Date"'`. This makes a **layout-aware** staleness/drift check possible, stronger than the text-layer compare.

### Class 4 — Keyword checks

Two match modes are required and conflating them is a bug:

| Mode | Use for | Command | Why |
|---|---|---|---|
| case-sensitive fixed | ATS exact-match forms | `LC_ALL=C grep -oF "$kw" \| wc -l` | `STACK.md`: matchers are substring-literal. Measured: `vLLM` cs=2 / `VLLM` cs=0; `PyTorch` cs=3 but ci=7 (the 4 extra are the mis-cased `Pytorch` in Skills). A ci match would report `PyTorch` present when the *indexable* form partly is not. |
| case-sensitive **word-boundary** | short prohibited tokens | `LC_ALL=C grep -owc 'Go'` | **Measured trap:** naive `grep -c 'Go'` = **1** (matches `Goal`, `main.tex:265`); `grep -owc 'Go'` = **0**. Without `-w`, PG2-05's "Go appears nowhere" assertion fails on today's document for a false reason. |

### Class 5 — Glyph / ligature corruption

Four-class codepoint gate, superseding the 5-character ligature check:

| Class | Rule | Today |
|---|---|---|
| ligatures | zero U+FB00–U+FB06 | 0 ✅ |
| PUA | zero U+E000–U+F8FF | 0 ✅ |
| replacement | zero U+FFFD | 0 ✅ |
| allowlist | every non-ASCII codepoint ∈ manifest | exact match ✅ |

Full measured census (complete, no truncation): `U+2013 EN DASH ×40`, `U+2019 RIGHT SINGLE QUOTATION MARK ×6`, `U+2022 BULLET ×6`, `U+2192 RIGHTWARDS ARROW ×3`, `U+2206 INCREMENT ×2`, `U+00D7 MULTIPLICATION SIGN ×1`, `U+2014 EM DASH ×1`, `U+201C ×1`, `U+201D ×1`. This reproduces `ARCHITECTURE.md:230` exactly.

### Class 6 — Date / title byte-exactness

```bash
LC_ALL=C grep -Fxc "Jul. 2024 – Present" "$TXT"      # must be exactly 1
```

Verified for all 15 frozen candidates (5 dates, 5 titles, 5 employers) — `grep -Fxc` returned **1** for every one, including `Software Development Engineer` where `grep -Fc` returns 2. `LC_ALL=C` + `-F` matches the UTF-8 en dash byte-exactly (verified with a `printf '\xe2\x80\x93'` needle).

### Class 7 — Staleness (three layers, ranked)

| Layer | Mechanism | Cost | Robustness | Verified |
|---|---|---|---|---|
| **L1 (primary)** | `md5 -q docs/main.tex` == the hash latexmk recorded for `"main.tex"` in `docs/AshutoshTiwari.fdb_latexmk` | free | **survives `git checkout`** (content hash, not timestamp) | ✅ both `729318505f45209be4838bdff42044c4` |
| **L2 (arbiter)** | scratch `latexmk` build from current source into `mktemp -d`, then compare `pdftotext` output (or filtered `-bbox`) against the committed PDF | **1.11s** | definitive; needs no stamp file and no committed aux | ✅ text layers **identical** → committed PDF is fresh |
| L3 (report only) | `[ "$PDF" -nt docs/main.tex ]` | free | **unreliable — measured** | ❌ mtimes identical (`1787351282` both) after checkout, so `-nt` is false on a *fresh* artifact |

**Caveats to record in the plan:**
- `.fdb_latexmk` is git-tracked today (`git ls-files docs/` confirms `.aux .fdb_latexmk .fls .log .out .pdf`), **but `make clean` deletes it** (`Makefile:132`). The harness must treat "absent `.fdb_latexmk`" as *unknown*, not *fresh*, and escalate to L2.
- L2's text-layer compare cannot see purely-visual drift (a palette change alters no text). Use the filtered `-bbox` compare instead of the plain text compare if layout-drift sensitivity is wanted (relevant from Phase 6 on).
- PDF **bytes** differ between builds of identical source (embedded `CreationDate`/`/ID`), so `cmp` on the PDFs is not a usable freshness test. Verified.
- ARCHITECTURE's draft gate opens with `touch docs/main.tex && make build`, which **mutates the working tree and the committed artifact**. Prefer L1+L2 (read-only) so `make verify` is safe to run on a clean checkout and in CI.

### Class 8 — Geometry / `\setlist` drift

Source-side, pattern-extracted, whitespace-normalized, sorted, hashed → `8b13a46bf5716cb9bb9042a4e1bb60a9d6919fd5f347a34ecdc6122d7f465a56`. See R4 and Code Examples. Corroborated PDF-side by `pdfinfo` page size (612×792) and bbox top extent (27.3pt).

### Environment probe result

```
pdftotext  /opt/homebrew/bin/pdftotext   → poppler 26.08.0
pdfinfo    /opt/homebrew/bin/pdfinfo
pdffonts   /opt/homebrew/bin/pdffonts
python3    /Users/ashutosh/.pyenv/shims/python3
latexmk    /Library/TeX/texbin/latexmk
pdflatex   /Library/TeX/texbin/pdflatex
gs         /usr/local/bin/gs      (MacTeX-supplied, not brew)
mdls       /usr/bin/mdls
qpdf       NOT INSTALLED          (not needed)
mutool     NOT INSTALLED          (not needed)
brew       /opt/homebrew/bin/brew  → formula `poppler` installed 26.08.0
```

---

## Baseline Manifest Design

Two files, because the two kinds of baseline have opposite update policies. Collapsing them into one is the design error that makes the harness either un-updatable or un-trustworthy.

```
docs/verify/
├── baseline-frozen.txt     # honesty invariants — changing this is a reviewed act
├── manifest.txt            # phase-mutable thresholds, keywords, headings, severities
└── (scratch lives in `mktemp -d`, never in the repo)
```

### `docs/verify/baseline-frozen.txt` — the honesty freeze

Hand-authored once from measured output, then **never regenerated casually**. UTF-8. Contains only what `REQUIREMENTS.md:73` forbids changing plus the geometry hash:

```
# Frozen honesty invariants. Matched with: LC_ALL=C grep -Fxc  → must equal exactly 1.
# Strings are the pdftotext DEFAULT-MODE extracted forms (en dash = U+2013, "&" not "\&").
# Editing this file requires an explicit reviewed commit. See VERIFY-03 / REQUIREMENTS.md:73.

[dates]
Jul. 2024 – Present
Jan. 2019 – Jul. 2021
Sep. 2017 – Jan. 2019
Sep. 2016 – Sep. 2017
Sep. 2015 – Aug. 2016

[titles]
Senior Machine Learning Engineer (ML Platform & Frameworks)
Software Dev Engineer II (ML Platform)
Software Development Engineer (Search Relevance)
Software Development Engineer
Software Engineer

[employers]
ADOBE FIREFLY
SWIGGY
FLIPKART (a Walmart company)
GROUPON
NETSPEED SYSTEMS (Acquired by Intel)

[geometry-sha256]
8b13a46bf5716cb9bb9042a4e1bb60a9d6919fd5f347a34ecdc6122d7f465a56
```

Design notes, each grounded in a measurement:

- **Exactly 15 strings.** Not the whole text layer — bullets change in Phases 2, 3, 4 and 5, so a full-text freeze would fail on every commit and be disabled within a day (task brief item 3).
- **`Career Break for Master's Degree` is deliberately absent.** It occupies a title slot but is not an employment title, and Phase 2/EXP-01 deletes it.
- **Employer names included** (beyond the two research lists) because G2.3 needs the last one and G5.5 makes the Pitfall-25 "silently lost content" failure mode loud at zero cost. All 5 verified `grep -Fxc` = 1.
- **`&` not `\&`.** The frozen form is the *extracted* string; the source writes `ML Platform \& Frameworks`.
- **Hand-written, not generated.** A generator would happily re-freeze a *changed* date, which is precisely the failure this file exists to prevent.

### `docs/verify/manifest.txt` — the mutable side

```
PAGES=2
CEILING_PT=764.4
LINE_PT=11.5                      # R1: conservative pair
CAREER_BREAK_PT=48.9              # R2: conservative pair (4.25 lines)
P1_BOTTOM_WS_PT=27.7              # R3: INFO only
P1_TOP_PT=27.3
PAGE_SIZE=612 x 792 pts (letter)
PAGE2_OPENS_WITH=PUBLICATIONS
EXPERIENCE_HEADING=WORK EXPERIENCE
EDU_BIND_WINDOW=3
DIGIT_BULLET_FLOOR=7
SKILLS_MAX_LINES=3                # today 4; owner Phase 5 → WARN until then
PROBE_LINES=5
SECTIONS=WORK EXPERIENCE|PUBLICATIONS|EDUCATION|RESEARCH EXPERIENCE / INDEPENDENT STUDY|TEACHING EXPERIENCE|SELECTED PROJECTS|TECHNICAL SKILLS
CONTACT_LITERALS=findashutoshtiwari@gmail.com|ashutosh--tiwari|github.com/thunderock|thunderock.github.io
FORBIDDEN_LITERAL=ashutosh–tiwari
PROHIBITED_WORDS=Go
PROHIBITED_PHRASES=speculative decoding
NONASCII_ALLOW=2013,2019,2022,2192,2206,00D7,2014,201C,201D
KEYWORDS_REQUIRED=inference|distributed|Kubernetes|PyTorch|FSDP|Ray|vLLM|Rust|fault|KEDA|SQS|Spark|Flash Attention
KEYWORDS_TARGET=torch.compile:3|A100:3|H100:3|ONNX:5|CUDA graphs:3|Iceberg:5|Triton:5
WARN_OWNERS=G5.4:3|G6.6:3|G6.13:unassigned|G6.14:5|G6.4:any
```

- `KEYWORDS_TARGET` entries carry `keyword:owning-phase`, so every WARN prints who owns it. **Promotion = move the line from `KEYWORDS_TARGET` to `KEYWORDS_REQUIRED` in the same commit that adds the keyword.** That is the whole promotion mechanism — no allowlist, no suppression file, no "known failures" list.
- `make verify-baseline` regenerates **`manifest.txt` only**, and refuses to touch `baseline-frozen.txt` unless `ALLOW_FROZEN_UPDATE=1` is exported — in which case it prints a unified diff first and requires the env var to be set in the same command. This makes accidentally re-freezing a changed employment date impossible-by-accident while keeping the mutable side maintainable.

---

## The Overflow Self-Test (`make verify-selftest`) — ROADMAP criterion 1

Fully built and executed this session; the design below is the one that ran clean.

### Verified mechanics

```
page-1 region = lines 127..219   (\begin{document} .. \newpage)
anchor        = line 215         (last \resumeItemListEnd inside that region)
injected      = 5 \resumeItem lines
latexmk exit  = 0
overfull/underfull = 0
pages         = 3
p2 first line = "– VERIFY SELFTEST probe filler line 1 — must overflow page 1."
repo dirty    = 0 files;  docs/AshutoshTiwari.pdf mtime unchanged
```

That single run establishes criterion 1's premise (*"today's `make build` accepts it warning-free and exit-0"*) **and** that G1.1 + G2.1 catch it.

### Design decisions

| Decision | Choice | Why |
|---|---|---|
| Where artifacts live | `mktemp -d` (override `VERIFY_TMPDIR`) | Zero repo pollution, nothing to gitignore, auto-cleanable. Verified: `git status --porcelain` = 0 after the run. If a deterministic path is wanted for debugging, add `docs/verify/tmp/` to `.gitignore` (currently `.gitignore` contains only `.idea/*`). |
| Jobname | `probe` | `docs/AshutoshTiwari.pdf` is *structurally* unreachable — different directory *and* different jobname. `ARCHITECTURE.md:331`'s note that `JOBNAME` is fixed applies to `make build`, not to a direct `latexmk` call. |
| Does the temp build resolve inputs? | yes | `main.tex`'s only `\input` is `glyphtounicode`, found via kpathsea in the TeX tree. No repo-relative includes. Verified: 4 scratch builds succeeded, 1.11s each. |
| Injection anchor | structural: first `\begin{document}` → first `\newpage`, then the **last** `\resumeItemListEnd` in that span, **skipping lines containing `\newcommand`** | **Verified trap:** the naive "first `\resumeSubHeadingListEnd`" resolves to **line 119, the `\newcommand` definition**, not line 217 — which made the first attempt crash with `IndexError`. Content anchors (`'Data Quality Framework'`) are worse: Phase 3 rebuilds that section and deletes the topic. |
| Injection count | `PROBE_LINES=5` from the manifest | Satisfies criterion 1 literally. |
| Probe rot | G7.2 asserts the probe PDF is **>2 pages**, failing loudly if it ever stops overflowing | **This is essential.** 5 lines × 11.5pt = 57.5pt. Today's page-1 slack is 0.15pt so it overflows massively. But if Phase 4's Groupon/NetSpeed fold (≈90–98pt) lands without content being added back, page-1 headroom could exceed 57.5pt and a +5 probe would **pass** — silently turning the self-test into a no-op. G7.2 converts that into `RESULT G7.2 FAIL — probe no longer overflows (headroom +Xpt); raise PROBE_LINES in manifest.txt`. |
| Adaptive alternative | `PROBE_LINES = max(5, ceil(headroom_pt / 11.5) + 2)` | Self-healing, but makes the self-test's behaviour depend on the artifact it is testing. **Recommend the fixed 5 + loud G7.2 guard** — it satisfies the criterion verbatim and keeps the failure visible rather than absorbed. |
| How `verify` runs against the probe | `verify --pdf <path> --tex <path>` (or `VERIFY_PDF`/`VERIFY_TEX`) | Needed anyway; also makes the harness CI-testable. The `--tex` pairing keeps G0.3 freshness meaningful for the probe instead of forcing a skip flag. |
| How the self-test knows the *right* gates fired | greps the structured output for `RESULT G1.1 FAIL` and `RESULT G2.1 FAIL` | Without this, a probe that failed only on the pre-existing en-dash defect would count as a pass and the self-test would prove nothing. **This is why per-assertion `RESULT` lines are a hard design requirement, not a nicety.** |

### Structured output contract

```
RESULT <id> <PASS|FAIL|WARN|INFO|SKIP> <human message>
```

One line per assertion, always, in a stable order. It is what makes criterion 5 ("FAILS and names each live defect") mechanically checkable, what lets G7.3 assert *which* gates fired, and what a future CI step would parse. Add a human summary block after it; keep the `RESULT` lines machine-first.

---

## Expected-Failure Bootstrapping (ROADMAP criterion 5)

The harness must be **red on arrival**, then turn green in Phase 2. Recommended flow — deliberately the simplest thing that satisfies the criteria (task brief item 5):

1. **No allowlist. No suppression file. No "known failures" baseline.** Phase 1's deliverable is a script that exits 1 with three named BLOCKER failures. Nothing marks them as expected.
2. **Each live defect gets its own assertion ID and an actionable message naming the fix owner.** Verified expected Phase-1 output:

```
RESULT G6.9  FAIL  contact literal missing from text layer: 'ashutosh--tiwari' (0 occurrences)
                   -> docs/main.tex:134 renders '--' as U+2013; break the ligature
                      (ashutosh-{}-tiwari). Owner: Phase 2 / EXP-06.
RESULT G6.9  FAIL  contact literal missing from text layer: 'github.com/thunderock' (0)
RESULT G6.9  FAIL  contact literal missing from text layer: 'thunderock.github.io' (0)
                   -> anchors are masked ('Github@thunderock', 'Homepage/Portfolio');
                      make the anchor text the literal URL. Owner: Phase 2 / EXP-06.
RESULT G6.10 FAIL  corrupted handle present: 'ashutosh–tiwari' (U+2013) x1
                   -> same root cause as G6.9. Owner: Phase 2 / EXP-06.
RESULT G6.12 FAIL  Education binding: 'Bloomington, IN' extracts BEFORE
                   'Indiana University, Bloomington', and 'Aug. 2021 – May 2023' is 3 lines
                   away (window=3, city-first) -> reorder \resumeSubheading args at
                   docs/main.tex:240-242. Owner: Phase 2 (EXP-01 already edits Education;
                   re-asserted by Phase 4 / PG2-03).
```

3. **Everything else is green today** (verified: G1.1, G2.1, G2.2, G2.3, G3.1, G3.4, G4.1–G4.4, G5.1–G5.3, G5.5, G6.1–G6.8, G6.11, G6.15 all PASS) — so Phase 2 fixing EXP-06 + the Education reorder flips the exit code to 0 and satisfies Phase 2's criterion 5 with no mechanism change.
4. **Phase-1 acceptance is inverted and must be stated in the plan:** the phase is done when `make verify; echo $?` prints **1** and the three named defects appear, and when `make verify-selftest` prints **0**. A planner who writes "`make verify` passes" as Phase 1's acceptance criterion has inverted the deliverable.
5. **The exit-code vocabulary carries the distinction:** `0` = all BLOCKERs pass · `1` = ≥1 BLOCKER failed (the document is wrong) · `2` = harness could not run (missing tool, missing artifact, stale PDF). Criterion 5's "refuses to verify a stale PDF" is exit **2**, semantically distinct from "verified and found wrong".

---

## Architecture Patterns

### Harness data flow

```
             docs/main.tex ──────────────┬───────────────────────────────┐
                    │                    │ (source-side assertions)      │
                    │                    ▼                               ▼
                    │        G4.1 geometry+setlist regex→hash   G6.15 invisible-text
                    │        G4.4 ATS switch present                 construct scan
                    │
                    │  md5 ─────► G0.3 freshness proof ◄──── docs/AshutoshTiwari.fdb_latexmk
                    │             (L1 hash; L2 = scratch rebuild arbiter)
                    │
    docs/AshutoshTiwari.pdf
        │
        ├── pdfinfo ─────────────────► G1.1 Pages==2      G4.2 page size
        │
        ├── pdftotext (default) ─────► G5.* frozen strings (grep -Fxc==1)
        │                              G6.1-G6.8 glyphs / keywords / headings
        │                              G6.9-G6.10 contact literals
        │                              G6.12-G6.14 binding, Skills lines
        │
        ├── pdftotext -f N -l N ─────► G2.1 page-2 opens at PUBLICATIONS  (positive)
        │                              G2.2 G2.3 page-1 containment
        │                              G5.4 digit-bearing p1 bullet floor
        │
        ├── pdftotext -bbox ─────────► G3.1 ceiling  G3.2 headroom-in-lines
        │                              G3.4 words outside page box  G4.3 top extent
        │
        └── pdftotext -raw ──────────► G6.11 divergence report (INFO, never gated)

   docs/verify/baseline-frozen.txt ──► G4.1 G5.*         (write-protected)
   docs/verify/manifest.txt ────────► thresholds, keyword tiers, severities, owners

   make verify-selftest:  mktemp -d ─► cp main.tex ─► inject PROBE_LINES ─► latexmk -jobname=probe
                          ─► assert exit 0 + 0 warnings (G7.1)
                          ─► assert pages > 2            (G7.2)
                          ─► verify --pdf probe.pdf  ⇒ exit!=0 ∧ G1.1 FAIL ∧ G2.1 FAIL (G7.3)
                          ─► assert repo clean           (G7.4)
```

### Recommended file layout

```
scripts/
└── verify-resume.sh          # single bash entrypoint; --pdf / --tex / --manifest overrides
docs/verify/
├── baseline-frozen.txt       # 15 frozen strings + geometry hash
└── manifest.txt              # mutable thresholds / keywords / headings / owners
Makefile                      # + verify, verify-selftest, verify-baseline; check gains poppler rows
```

`ARCHITECTURE.md:426` suggests `.planning/verify-resume.sh`. **Put it in `scripts/` instead** — `.planning/` is planning-tool territory that later gets archived (`gsd-cleanup` archives phase dirs), while `make verify` is a permanent build target. Its baselines belong next to the artifact they describe, in `docs/verify/`.

### Pattern 1 — Severity tiers with printed owners

```bash
BLOCKERS=0
result() {  # result <id> <status> <message>
  printf 'RESULT %-6s %-5s %s\n' "$1" "$2" "$3"
  [ "$2" = FAIL ] && BLOCKERS=$((BLOCKERS+1))
  return 0
}
warn()   { printf 'RESULT %-6s %-5s %s (owner: Phase %s)\n' "$1" WARN "$3" "$2"; }
```

`WARN` never touches `BLOCKERS`. A phase promotes a WARN by moving its keyword/threshold line in `manifest.txt`. Every WARN prints on every run with its owner, so nothing is ever silently excused — that is what distinguishes this from an allowlist.

### Pattern 2 — Read-only verification (no `touch`, no `make build`)

```bash
# ARCHITECTURE.md's draft opens with:  touch docs/main.tex && make build
# Don't. It mutates the tree and the committed artifact. Prove freshness instead:
src_md5=$(md5 -q docs/main.tex)
fdb_md5=$(awk '/^  "main\.tex"/{print $4; exit}' docs/AshutoshTiwari.fdb_latexmk 2>/dev/null)
```

### Anti-patterns to avoid

- **Substituting fill measurement for the page count.** Re-verified: the 3-page artifact reports positive page-1 headroom. G3.1 without G1.1 is a false gate.
- **Testing for the *absence* of company names on page 2.** Re-verified false OK; the spill fragment varies with the injection point (`Software Engineer`, `Groupon operates.`, `Breakdown.`). Positive assertion only.
- **`grep -F` for the frozen manifest.** Returns 2 for `Software Development Engineer`; cannot detect a changed Groupon title. Use `grep -Fx` with `== 1`.
- **Naive substring matching for short prohibited tokens.** `grep -c 'Go'` = 1 today via `Goal`. Use `-w`.
- **Gating on `pdftotext -raw`.** Proven unfixable in LaTeX (`\justifying` removal left `-raw` byte-identical). Report only.
- **mtime as the freshness gate.** Measured indeterminate after checkout.
- **Content-string anchors in the probe injector.** Phase 3 deletes the topics you would anchor on.
- **Hardcoding section-heading names in the script.** Blocks legitimate future renames and/or fails today. Manifest them.
- **Writing probe artifacts under `docs/`.** Risks clobbering the committed PDF and dirtying the tree. `mktemp -d`.

---

## Don't Hand-Roll

| Problem | Don't build | Use instead | Why |
|---|---|---|---|
| Page count | PDF trailer / `/Count` parsing, form-feed heuristics | `pdfinfo … \| awk '/^Pages:/{print $2}'` | Structural, one line, already installed, verified `2`. |
| Text extraction | custom content-stream / `TJ`-array decoding | `pdftotext` (default / `-raw` / `-bbox` / `-f`/`-l`) | Both research files measured with it; it *is* the ATS proxy. Hand-rolling would reproduce poppler's own bugs differently and invalidate every baseline in `ARCHITECTURE.md`/`PITFALLS.md`. |
| Per-page coordinates | PDF content-stream `Tm`/`Td` math | `pdftotext -bbox` + stdlib `xml.etree` | Gives `xMin/yMin/xMax/yMax` per word plus page dimensions. Verified deterministic modulo two date meta lines. |
| Freshness | mtime arithmetic, custom stamp files, git plumbing | latexmk's own `.fdb_latexmk` MD5, escalating to a 1.11s scratch rebuild | latexmk already computes and records exactly the hash you need. Verified match. mtime is measurably wrong here. |
| Byte-exact string comparison | Python/awk string loops, `diff` on extracted text | `LC_ALL=C grep -Fxc … == 1` | `-F` = no regex metacharacter surprises in titles containing `(`/`)`/`&`; `-x` = line-exact, which resolves the substring collision; `LC_ALL=C` = byte semantics for the U+2013 needle. All three verified. |
| Unicode inspection | a hand-maintained list of "bad characters" | full codepoint census + 4 class rules + manifest allowlist | The 5-ligature check misses PUA and U+FFFD entirely — the two classes that appear when `ToUnicode` breaks. The census is 8 lines of stdlib Python. |
| Overflow detection | parsing `.log` for warnings | `pdfinfo` page count | Measured 4× this session: a 3-page overflow yields exit 0 and **zero** overfull/underfull. There is no "overfull page" warning in TeX, and `\raggedbottom` suppresses underfull-vbox. |
| Building variants | editing `docs/main.tex` in place and reverting | `cp` to `mktemp -d`, `latexmk -jobname=probe` | Verified: repo stayed clean, committed PDF untouched. In-place edit + revert is how a stale artifact gets verified. |
| Test framework | `bats`, `shunit2`, pytest | `make verify-selftest` asserting on `RESULT` lines | The harness's whole contract is an exit code plus structured lines. The self-test *is* the test suite, and it needs zero new dependencies. |

**Key insight:** every measurement in `ARCHITECTURE.md` and `PITFALLS.md` was produced with poppler in specific modes. Substituting a different extractor changes the numbers and silently invalidates every threshold in this phase's manifest. The harness must use the same tools the baselines were measured with — that is a correctness requirement, not a convenience.

---

## Common Pitfalls

### Pitfall 1: Making the harness green on arrival

**What goes wrong:** the implementer sees three failures, assumes a bug, and either weakens the assertion (`grep -F` instead of `-Fx`, `>= 1` instead of `== 1`) or adds a suppression list.
**Why it happens:** "tests should pass" is a deep reflex, and it directly contradicts ROADMAP criterion 5.
**How to avoid:** state Phase 1 acceptance as an exit-1 assertion plus the three named messages, and put it in the plan's must-haves verbatim. **CORRECTED during planning:** assert it as `bash scripts/verify-resume.sh; test $? -eq 1`, NOT `make verify; test $? -eq 1` — GNU Make 3.81 exits 2 for any failed recipe regardless of what the recipe returned (measured both ways), so the Make-level form can never pass and also erases the exit-1 vs exit-2 distinction ROADMAP criterion 5 depends on. `make verify` is assertable only as "exits non-zero". See `01-01-PLAN.md` note 1 and `01-03-PLAN.md`'s notes.
**Warning signs:** an `EXPECTED_FAILURES` variable; any assertion whose message says "will be fixed later" without an owner; `|| true` on a BLOCKER.

### Pitfall 2: Making the harness so strict Phase 2 cannot turn it green

**What goes wrong:** every `PITFALLS.md` "Phase 0 assert" becomes a BLOCKER, including Skills ≤3 lines (Phase 5), palette contrast (Phase 6), `index.html` consistency (Phase 6), the `torch.compile`/`A100`/`H100` keywords (Phase 3/5) and the unassigned role-header/bullet-marker items. `make verify` is then permanently red and ROADMAP Phase 2/3/4 criterion 5 becomes unachievable.
**Why it happens:** `PITFALLS.md`'s pitfall-to-phase table says "Phase 0 assert" for all of them, which reads as "make it a gate in Phase 1" rather than "the harness is where it will eventually be asserted".
**How to avoid:** severity tiers (R6). BLOCKER ⟺ passes today, or is one of the three defects Phase 2 fixes. Everything else WARN with a printed owner.
**Warning signs:** `make verify` on the post-Phase-2 document still exits 1; a failure message with no owning phase; the Skills-line or palette check exiting non-zero.

### Pitfall 3: Freezing too much, so the freeze gets disabled

**What goes wrong:** the "baseline" becomes a snapshot of the whole text layer. Phase 2 changes a bullet, the diff is 40 lines, the honesty gate is regenerated wholesale — and the next time a *date* changes, it is regenerated wholesale again, silently.
**Why it happens:** a text-layer snapshot is the easiest baseline to generate.
**How to avoid:** 15 strings, hand-written, in a file whose regeneration requires `ALLOW_FROZEN_UPDATE=1` and prints a diff. Bullets are matched by *keyword tier*, never frozen.
**Warning signs:** `baseline-frozen.txt` longer than ~25 lines; `verify-baseline` overwriting it without a diff; the frozen file appearing in a routine content commit.

### Pitfall 4: The self-test silently becoming a no-op

**What goes wrong:** page-1 headroom grows past `PROBE_LINES × 11.5pt` (plausible after the Groupon/NetSpeed fold frees ≈90–98pt), the +5-line probe stops overflowing, `verify --pdf probe.pdf` exits 0 — and the self-test either reports success (if it only checks "verify was run") or fails with an unhelpful message.
**Why it happens:** the probe's validity depends on the very headroom the milestone is trying to create.
**How to avoid:** G7.2 asserts `pages > 2` on the probe *before* asserting that verify fails, with the remedy in the message (`raise PROBE_LINES`).
**Warning signs:** the self-test passing on a document with >57.5pt of page-1 headroom; no assertion on the probe's own page count.

### Pitfall 5: Verifying a stale artifact and calling it green

**What goes wrong:** `git checkout` of an older `main.tex` leaves a newer PDF; or `make` reports "Nothing to be done for `build`" (measured — it does today) and the harness verifies yesterday's artifact.
**Why it happens:** mtime intuition. Measured: after checkout both files carry mtime `1787351282`, so `-nt` is indeterminate, and `make` is mtime-gated.
**How to avoid:** L1 content-hash proof, escalating to the L2 scratch rebuild; refuse with exit **2**, distinct from a content failure.
**Warning signs:** the harness calling `make build` or `touch`; a freshness check that reduces to `-nt`; no handling for a `make clean`-deleted `.fdb_latexmk`.

### Pitfall 6: Encoding-naive string matching

**What goes wrong:** the frozen dates fail to match, or match spuriously. The extracted separator is U+2013, the source writes `--`, titles contain `&` (source `\&`) and `(`/`)`, and one title is a substring of another.
**Why it happens:** the source form and the extracted form are different strings, and locale-aware `grep` can normalize bytes.
**How to avoid:** store extracted forms, UTF-8, match with `LC_ALL=C grep -Fxc` requiring `== 1`. All verified.
**Warning signs:** `grep -E` on a frozen title; a needle containing `--`; `>= 1` instead of `== 1`.

### Pitfall 7: Asserting the ROADMAP's handle spelling verbatim

**What goes wrong:** the gate asserts `ashutosh-tiwari` (ROADMAP Ph2 crit 3). The correct handle is `ashutosh--tiwari` — measured `grep -Fc 'ashutosh-tiwari'` = **0** against the correct form. The gate would then demand a *broken* handle, and Phase 2 would "fix" the resume into a wrong LinkedIn URL.
**Why it happens:** the single-hyphen spelling was introduced during roadmapping; `main.tex:134`'s `\href` target and `PITFALLS.md:481` both say two hyphens.
**How to avoid:** assert `ashutosh--tiwari` (G6.9) plus zero occurrences of `ashutosh–tiwari` (G6.10). Confirm the real vanity URL with the user once (Assumption A1) — if it genuinely were single-hyphen, the existing `\href` target is *also* wrong and that is a bigger finding.
**Warning signs:** a manifest line containing `ashutosh-tiwari`.

### Pitfall 8: Probe injection anchored on content

**What goes wrong:** the injector anchors on `'Data Quality Framework'` or the first `\resumeSubHeadingListEnd`. The former disappears in Phase 3's Adobe rebuild; the latter resolves to **line 119, the `\newcommand` definition** (measured — it crashed).
**How to avoid:** the verified structural anchor — `\begin{document}` → `\newpage` window, last `\resumeItemListEnd` in it, skipping `\newcommand` lines.
**Warning signs:** an `IndexError`/empty-anchor failure; any English phrase in the injector.

---

## Code Examples

All snippets below were executed in this session against the real repo, **each with a negative control** — so the Wave 0 unit rows in Validation Architecture are known-implementable, not aspirational:

| Snippet | Positive control | Negative control |
|---|---|---|
| `geom_hash` | reproduced `8b13a46b…` on `docs/main.tex` | `\textheight` `1.2in`→`1.3in` in a temp copy ⇒ `ab8a67fd…` (drift detected) |
| frozen-string matcher | all **15** strings `PASS` (count exactly 1) | one-byte date mutation (`2019`→`2018`) ⇒ `count=0 (want 1)` |
| codepoint census | all `PASS`, zero WARN, exit 0 | fixture with `ﬁ` + U+FFFD + U+E000 ⇒ `G6.1/G6.2/G6.3 FAIL`, exit 1 |
| probe injector | exit 0, 0 warnings, 3 pages, repo clean | naive anchor ⇒ `IndexError` (the trap, found by hitting it) |

### Geometry + `\setlist` normalized hash (G4.1)

```bash
# Line-number independent. Handles the two-line \setlist[itemize] declaration
# (main.tex:69-70) that a per-line grep would truncate.
geom_hash() {
  { grep -hoE '\\addtolength\{\\(oddsidemargin|evensidemargin|textwidth|topmargin|textheight)\}\{[^}]*\}' "$1" | sort
    python3 -c '
import re,sys
s=open(sys.argv[1],encoding="utf-8").read()
pat=r"\\setlist(\[[^\]]*\])?\{(?:[^{}]|\{[^{}]*\})*\}"
print("\n".join(sorted(" ".join(m.group(0).split()) for m in re.finditer(pat,s))))' "$1"
  } | shasum -a 256 | awk '{print $1}'
}
# verified: 8b13a46bf5716cb9bb9042a4e1bb60a9d6919fd5f347a34ecdc6122d7f465a56
```

### Freshness proof (G0.3)

```bash
src=$(md5 -q docs/main.tex)                                      # 729318505f45209be4838bdff42044c4
fdb=$(awk '/^  "main\.tex"/{print $4; exit}' docs/AshutoshTiwari.fdb_latexmk 2>/dev/null)
if   [ -z "$fdb" ];        then escalate_to_scratch_rebuild      # make clean removed it
elif [ "$src" != "$fdb" ]; then die 2 "PDF is stale: built from $fdb, source is now $src -> run 'make build'"
else result G0.3 PASS "PDF provably built from current main.tex (md5 $src)"
fi
```

### L2 arbiter — scratch rebuild + layout-aware compare

```bash
# 1.11s measured. PDF *bytes* differ between builds (embedded CreationDate/ID),
# so compare the extracted layer, not the file.
t=$(mktemp -d); cp docs/main.tex "$t/"
( cd "$t" && latexmk -pdf -interaction=nonstopmode -halt-on-error -jobname=fresh main.tex >/dev/null 2>&1 )
strip_dates() { grep -v 'name="\(Creation\|Mod\)Date"'; }        # the ONLY nondeterministic lines
pdftotext -bbox "$t/fresh.pdf" "$t/a.xml"; pdftotext -bbox docs/AshutoshTiwari.pdf "$t/b.xml"
sed 's/fresh\.pdf/X/;s/AshutoshTiwari\.pdf/X/' "$t/a.xml" | strip_dates > "$t/a.n"
sed 's/fresh\.pdf/X/;s/AshutoshTiwari\.pdf/X/' "$t/b.xml" | strip_dates > "$t/b.n"
cmp -s "$t/a.n" "$t/b.n" && echo FRESH || echo STALE
rm -rf "$t"
```

### Frozen-string matcher (G5.1 / G5.2 / G5.5)

```bash
pdftotext docs/AshutoshTiwari.pdf "$TXT"
while IFS= read -r s; do
  case "$s" in ''|'#'*|'['*) continue ;; esac
  n=$(LC_ALL=C grep -Fxc "$s" "$TXT" || true)
  [ "$n" = 1 ] && result G5.x PASS "frozen: $s" \
               || result G5.x FAIL "frozen string count=$n (want exactly 1): $s"
done < docs/verify/baseline-frozen.txt
```

### Codepoint census / glyph gate (G6.1–G6.4)

```python
import sys, collections, unicodedata
t = open(sys.argv[1], encoding='utf-8').read()
allow = {int(x,16) for x in sys.argv[2].split(',')}
c = collections.Counter(ord(ch) for ch in t if ord(ch) > 127)
lig = sum(n for cp,n in c.items() if 0xFB00 <= cp <= 0xFB06)
pua = sum(n for cp,n in c.items() if 0xE000 <= cp <= 0xF8FF)
bad = c.get(0xFFFD, 0)
print(f"RESULT G6.1  {'PASS' if not lig else 'FAIL'} ligature codepoints U+FB00-FB06: {lig}")
print(f"RESULT G6.2  {'PASS' if not pua else 'FAIL'} private-use codepoints: {pua}")
print(f"RESULT G6.3  {'PASS' if not bad else 'FAIL'} U+FFFD replacement chars: {bad}")
for cp, n in sorted(c.items()):
    if cp not in allow:
        print(f"RESULT G6.4  WARN unlisted non-ASCII U+{cp:04X} x{n} "
              f"({unicodedata.name(chr(cp),'?')}) -> add to NONASCII_ALLOW if intentional")
sys.exit(1 if (lig or pua or bad) else 0)
```

### Headroom in lines (G3.1–G3.4)

```python
import sys, xml.etree.ElementTree as ET
tag = lambda e: e.tag.split('}')[-1]
CEIL, LINE = 764.4, 11.5
root = ET.parse(sys.argv[1]).getroot(); bad = False
for i, pg in enumerate([p for p in root.iter() if tag(p) == 'page'], 1):
    W, H = float(pg.get('width')), float(pg.get('height'))
    ws = [w for w in pg.iter() if tag(w) == 'word']
    if not ws: continue
    top    = min(float(w.get('yMin')) for w in ws)
    bottom = max(float(w.get('yMax')) for w in ws)
    off    = sum(1 for w in ws if float(w.get('xMin')) < 0 or float(w.get('yMin')) < 0
                                or float(w.get('xMax')) > W or float(w.get('yMax')) > H)
    slack = CEIL - bottom
    print(f"RESULT G3.1  {'FAIL' if slack < 0 else 'PASS'} p{i} bottom={bottom:.1f}pt ceiling={CEIL}")
    print(f"RESULT G3.2  INFO  p{i} headroom={slack:+.1f}pt (~{slack/LINE:+.2f} lines @{LINE}pt)")
    print(f"RESULT G3.4  {'FAIL' if off else 'PASS'} p{i} words outside page box: {off}")
    bad |= slack < 0 or off > 0
sys.exit(1 if bad else 0)
# verified: p1 bottom=764.3 headroom=+0.1pt (+0.01 lines), 0 outside; p2 710.9 / +53.5pt (+4.65)
```

### Probe injector (G7.1) — the verified structural anchor

```python
import sys
path, n = sys.argv[1], int(sys.argv[2])
L = open(path, encoding='utf-8').read().split('\n')
def find(tok, lo=0, hi=None):
    hi = len(L) if hi is None else hi
    # skipping \newcommand is ESSENTIAL: the first \resumeSubHeadingListEnd hit is the
    # macro DEFINITION at line 119, not the Experience usage at line 217.
    return [i for i in range(lo, hi) if tok in L[i] and '\\newcommand' not in L[i]]
doc = find(r'\begin{document}')[0]          # 126 (0-indexed) -> line 127
np  = find(r'\newpage', doc)[0]             # 218            -> line 219
at  = find(r'\resumeItemListEnd', doc, np)[-1]   # 214        -> line 215
L[at:at] = [r'        \resumeItem{VERIFY SELFTEST probe filler line %d --- must overflow page 1.}' % i
            for i in range(1, n + 1)]
open(path, 'w', encoding='utf-8').write('\n'.join(L))
```

### Makefile targets

```make
VERIFY     := scripts/verify-resume.sh
POPPLER    := pdfinfo pdftotext

.PHONY: verify verify-selftest verify-baseline

verify: $(PDF)  ## Gate the PDF: page-1 fit, ATS text layer, honesty invariants
	@bash $(VERIFY)

verify-selftest:  ## Prove the page-count gate actually fires (+N-line overflow probe)
	@bash $(VERIFY) --selftest

verify-baseline:  ## Regenerate docs/verify/manifest.txt (frozen file needs ALLOW_FROZEN_UPDATE=1)
	@bash $(VERIFY) --write-baseline

check:  ## (extend the existing target)
	@printf "  pdfinfo  : "; command -v pdfinfo   >/dev/null 2>&1 && pdfinfo -v 2>&1 | head -1 || echo "MISSING (brew install poppler)"
	@printf "  pdftotext: "; command -v pdftotext >/dev/null 2>&1 && pdftotext -v 2>&1 | head -1 || echo "MISSING (brew install poppler)"
	@printf "  python3  : "; command -v python3   >/dev/null 2>&1 && python3 --version || echo "MISSING"
```

Note `verify: $(PDF)` makes `make verify` build the PDF if it is missing, but **does not** rebuild a stale one (`make` is mtime-gated — measured: `make -n build` currently prints `Nothing to be done for 'build'`). That is exactly why G0.3 exists.

---

## State of the Art

| Old approach | Current approach | Why it changed |
|---|---|---|
| `make build` exit code as the fit signal | `pdfinfo … Pages == 2` | Measured 4× this session: 3-page overflow ⇒ exit 0, zero warnings. `\raggedbottom` removes the only complaining mechanism. |
| "no company names on page 2" | "page 2 *starts at* `PUBLICATIONS`" | Negative test returns false OK; spill fragments (`Software Engineer`, `Groupon operates.`, `Breakdown.`) are unenumerable. |
| bottom-whitespace threshold as the fit gate | page count + ceiling check; whitespace demoted to INFO; margins protected by the geometry hash | Fill measurement reads green on a 3-page artifact. |
| 5-character ligature check | 4-class codepoint gate + allowlist census | PUA and U+FFFD are the classes that actually appear when `ToUnicode` breaks; neither is covered by checking `ﬁﬂﬀﬃﬄ`. |
| mtime freshness (`-nt`) | latexmk `.fdb_latexmk` MD5 → scratch-rebuild arbiter | Measured indeterminate: identical mtimes after checkout. |
| `touch main.tex && make build` inside the gate | read-only hash proof | Mutating the tree to verify it is how stale artifacts get blessed; also makes the gate unsafe in CI. |
| `grep -F` for frozen strings | `grep -Fxc == 1` | Substring collision between two real titles. |
| single extraction mode | default (gate) + `-raw` (report) + `-bbox` (geometry) | `PITFALLS.md:522`; `-raw` is unfixable in LaTeX so it must never gate. |

**Deprecated / do not adopt:**
- `.planning/verify-resume.sh` as the script's home — `.planning/` is archived by planning-tool cleanup; `make verify` is permanent. Use `scripts/`.
- `pdfminer.six` / Tika cross-check — listed as a gap in `ARCHITECTURE.md:600`; adds a dependency to satisfy a requirement that ≥2 poppler *modes* already satisfy.
- `AltaCV`-style ligature remapping (`ARCHITECTURE.md:621`) — reintroduces U+FB01 codepoints; would break G6.1.

---

## Runtime State Inventory

**Not applicable.** Phase 1 adds new files (`scripts/verify-resume.sh`, `docs/verify/*`) and new Makefile targets. It renames nothing, migrates no data, and changes no string that any runtime system has cached, stored, or registered. There is no stored data, live service config, OS-registered state, secret/env-var name, or build artifact carrying a name this phase changes. *(Verified: the phase's only writes are new paths plus appended Makefile targets; no existing identifier is renamed.)*

---

## Environment Availability

| Dependency | Required by | Available | Version | Fallback |
|---|---|---|---|---|
| `pdfinfo` (poppler) | G1.1, G4.2 | ✓ | 26.08.0 (`/opt/homebrew/bin`) | form-feed count (G1.2), verified equal today |
| `pdftotext` (poppler) | G2.*, G3.*, G5.*, G6.* | ✓ | 26.08.0 | — (**no fallback; hard requirement**) |
| `python3` | G3.*, G6.1–G6.4, probe injector | ✓ | pyenv shim | — (stdlib only, no venv needed) |
| `latexmk` + `pdflatex` | G7.* self-test, L2 freshness arbiter | ✓ | `/Library/TeX/texbin` | G7 SKIPs with a loud notice if absent; L2 degrades to L1-only |
| `md5` / `shasum` | G0.3, G4.1 | ✓ | macOS base | `shasum -a 256` covers both if `md5` were absent |
| `grep` (BSD, with `-F -x -w -o -c`) | G5.*, G6.* | ✓ | macOS base | — (all flags verified present in BSD grep) |
| `mktemp -d` | G7.* | ✓ | macOS base | `VERIFY_TMPDIR` override |
| GNU `make` | targets | ✓ | macOS base | — |
| `brew` | `make install` path only | ✓ | `/opt/homebrew/bin/brew` | manual poppler install |
| `qpdf` | nothing | ✗ | — | not needed — no assertion requires it |
| `gs` | nothing in Phase 1 (Phase 6 grayscale) | ✓ | `/usr/local/bin/gs` (MacTeX) | n/a this phase |
| `mdls` | nothing (rejected) | ✓ | `/usr/bin/mdls` | rejected: Spotlight dependency |

**Missing dependencies with no fallback:** none.
**Missing dependencies with fallback:** none needed — every required tool is present.
**Net new dependencies introduced by this phase: zero.** `make install` should still gain `brew install poppler` so a clean machine can run the gate.

---

## Validation Architecture

### Test framework

| Property | Value |
|---|---|
| Framework | **none exists** — no `pytest.ini`, `jest.config.*`, `vitest.config.*`, `test/`, `tests/`, `__tests__/`, `*.test.*`, `*.spec.*`, or `package.json` anywhere in the repo (verified by directory listing: `blog_pdfs blogs css docs img .github` + `index.html Makefile README.md`) |
| Chosen harness | **`make verify-selftest`** — bash assertions over the `RESULT <id> <status>` contract. No framework installed (see Wave 0). |
| Config file | `docs/verify/manifest.txt` (thresholds) + `docs/verify/baseline-frozen.txt` (invariants) |
| Quick run command | `make verify` — measured cost ≈ 0.4s (no build) |
| Full suite command | `make verify && make verify-selftest` — measured ≈ 1.6s (one 1.11s scratch build) |

### Phase requirements → test map

| Req | Behavior | Test type | Automated command | Exists? |
|---|---|---|---|---|
| VERIFY-01 | non-zero when PDF ≠ 2 pages | self-test (positive control) | `make verify-selftest` → asserts `RESULT G1.1 FAIL` on a +5-line probe | ❌ Wave 0 |
| VERIFY-01 | non-zero unless page 2 starts at `PUBLICATIONS` | self-test | `make verify-selftest` → asserts `RESULT G2.1 FAIL` on the probe | ❌ Wave 0 |
| VERIFY-01 | green on the current 2-page artifact | smoke | `make verify \| grep -E 'RESULT (G1\.1\|G2\.1\|G3\.1) PASS'` | ❌ Wave 0 |
| VERIFY-01 | headroom reported in lines | smoke | `make verify \| grep 'RESULT G3.2'` → `p1 headroom=+0.1pt (~+0.01 lines @11.5pt)` | ❌ Wave 0 |
| VERIFY-02 | required keyword missing ⇒ non-zero | unit (negative control) | run against a manifest with a synthetic absent keyword; assert `RESULT G6.5 FAIL` | ❌ Wave 0 |
| VERIFY-02 | corrupted glyph ⇒ non-zero | unit (negative control) | feed a fixture text file containing `ﬁ` / U+FFFD / a PUA codepoint to the census; assert `G6.1`/`G6.3`/`G6.2 FAIL` | ❌ Wave 0 |
| VERIFY-02 | LinkedIn handle + portfolio URL as literal text | smoke (**expected FAIL today**) | `make verify \| grep 'RESULT G6.9 FAIL'` — 3 failures expected | ❌ Wave 0 |
| VERIFY-03 | date/title byte-difference ⇒ non-zero | unit (negative control) | mutate one manifest date by one byte in a temp copy; assert `RESULT G5.1 FAIL` | ❌ Wave 0 |
| VERIFY-03 | geometry / `\setlist` drift ⇒ non-zero | unit (negative control) | temp `main.tex` with `\textheight` `1.2in`→`1.3in`; assert `RESULT G4.1 FAIL` | ❌ Wave 0 |
| VERIFY-03 | stale PDF ⇒ refuse (exit 2) | unit (negative control) | temp copy with a mutated `main.tex`; assert exit 2 and `RESULT G0.3 FAIL` | ❌ Wave 0 |
| ROADMAP crit 5 | fails today naming each live defect | acceptance (**inverted**) | `bash scripts/verify-resume.sh; test $? -eq 1` **and** output contains `G6.9`, `G6.10`, `G6.12` — **CORRECTED during planning:** script-level, not `make verify; test $? -eq 1`, which GNU Make 3.81 makes unsatisfiable (any failed recipe ⇒ make exit 2) | ❌ Wave 0 |
| ROADMAP crit 1 premise | today's build accepts +5 lines warning-free | self-test | `make verify-selftest \| grep 'RESULT G7.1 PASS'` (measured: exit 0, 0 warnings) | ❌ Wave 0 |
| — | self-test never dirties the repo | self-test | `make verify-selftest && test -z "$(git status --porcelain)"` (measured clean) | ❌ Wave 0 |

**Observability note:** every requirement is observable through the `RESULT <id> <status>` contract, which is the design property that makes this phase testable at all. Without per-assertion output the only signal would be one exit code, and no test could distinguish "failed for the right reason" from "failed for a pre-existing defect" — which is precisely what G7.3 must do.

Each negative control operates on a **temp copy** (`mktemp -d`), never on `docs/`, following the verified G7.4 pattern.

### Sampling rate

- **Per task commit:** `make verify` (≈0.4s) — cheap enough to run on every commit.
- **Per wave merge:** `make verify && make verify-selftest` (≈1.6s).
- **Phase gate:** `make verify` exits **1** with exactly the three named defects, and `make verify-selftest` exits **0**, before `/gsd-verify-work`.

### Wave 0 gaps

- [ ] `scripts/verify-resume.sh` — the harness itself (covers VERIFY-01/02/03)
- [ ] `docs/verify/baseline-frozen.txt` — 15 frozen strings + geometry hash (VERIFY-03)
- [ ] `docs/verify/manifest.txt` — thresholds, keyword tiers, headings, WARN owners
- [ ] `make verify` / `make verify-selftest` / `make verify-baseline` targets; `make check` gains poppler rows
- [ ] `--selftest` mode with the verified probe injector (ROADMAP crit 1)
- [ ] negative-control fixtures for the 6 unit rows above (mutated date, mutated `\textheight`, stale PDF, corrupted-glyph text fixture, absent required keyword) — all as temp copies
- [ ] `.gitignore`: add `docs/verify/tmp/` only if a deterministic scratch path is chosen over `mktemp -d`
- [ ] no framework install required

---

## Security Domain

This phase writes a local, non-networked verification script. It processes exactly two inputs, both already trusted and already in the repo (`docs/main.tex`, `docs/AshutoshTiwari.pdf`), and exposes no service, endpoint, session, or credential.

### Applicable ASVS categories

| ASVS category | Applies | Standard control |
|---|---|---|
| V2 Authentication | no | no identity involved |
| V3 Session Management | no | no sessions |
| V4 Access Control | no | no multi-user surface |
| V5 Input Validation | **yes (limited)** | Manifest and baseline files are shell-consumed. Read them with `while IFS= read -r`, never `eval`/`source`. Interpolate manifest values only inside **quoted** arguments; match frozen strings with `grep -F` (no regex interpretation of user-supplied patterns). Treat `pdftotext` output as untrusted text — never `eval` it, never pass it unquoted. |
| V6 Cryptography | **yes (integrity only, not secrecy)** | `shasum -a 256` for the geometry freeze and `md5` only where latexmk already chose MD5 (`.fdb_latexmk`). MD5 is used to *compare against latexmk's own record*, not as a security boundary — do not hand-roll a hash. |
| V7 Error Handling & Logging | **yes** | Distinct exit codes (0/1/2). Never `set -e` alone — the harness must run *all* assertions and aggregate, so use explicit accumulation (`BLOCKERS=$((BLOCKERS+1))`) with `set -uo pipefail` and no `-e`. |
| V12 Files & Resources | **yes** | Scratch dirs via `mktemp -d`; `rm -rf` only a variable proven non-empty (`[ -n "$t" ] && [ -d "$t" ]`). Never write under `docs/` from the self-test (G7.4 asserts this). |
| V14 Configuration | **yes** | `ALLOW_FROZEN_UPDATE=1` gate on regenerating the honesty baseline — a deliberate two-factor guard on the one file whose silent modification would defeat VERIFY-03. |

### Known threat patterns for this stack

| Pattern | STRIDE | Standard mitigation |
|---|---|---|
| Shell injection via a manifest/baseline line containing `$(…)`, backticks or `;` | Tampering / Elevation | `read -r` line-wise; quote every expansion; never `eval`/`source` the manifest |
| Glob/word-splitting on paths | Tampering | quote all path variables; `IFS` untouched inside loops |
| `rm -rf "$VAR"` with an empty/unset `VAR` | Denial | `set -u`, plus an explicit non-empty + `-d` check before removal |
| Silent honesty-gate bypass (someone regenerates `baseline-frozen.txt` to match a changed date) | **Repudiation** — the milestone's highest-consequence risk (`PITFALLS.md:832`: offer-rescission class, "effectively unrecoverable") | Frozen file is hand-authored; regeneration requires `ALLOW_FROZEN_UPDATE=1` **and** prints a unified diff; the file is small enough (15 lines) that a reviewer sees any change in the commit diff |
| Verifying a stale artifact (integrity of the thing under test) | Spoofing | G0.3 content-hash proof + L2 rebuild arbiter; exit 2 refusal |
| Self-test corrupting the real artifact | Tampering | separate directory *and* separate jobname; G7.4 asserts `git status --porcelain` empty (measured clean) |

No secrets, tokens, network calls, or third-party services are involved. Nothing in this phase should reach the network.

---

## Assumptions Log

| # | Claim | Section | Risk if wrong |
|---|---|---|---|
| **A1** | The correct LinkedIn vanity handle is `ashutosh--tiwari` (two ASCII hyphens), per `docs/main.tex:134`'s `\href` target and `PITFALLS.md:481`. **`[ASSUMED]` — not verified against LinkedIn** (no network check performed; out of scope). | Pitfall 7, G6.9 | **HIGH.** If the real handle is single-hyphen, the existing `\href` URL is also wrong and the gate would enforce a broken handle. **One-line user confirmation before Phase 2 executes.** Note ROADMAP Ph2 crit 3 currently says single-hyphen and both research files say double — a genuine contradiction the planner must resolve, not paper over. |
| **A2** | The Education parse-order fix can land in Phase 2 (which already edits Education via EXP-01), rather than waiting for Phase 4/PG2-03. `[ASSUMED]` — an inference from the requirement text, not a user decision. | R6, Open Q1 | MEDIUM. If it must wait for Phase 4, then either ROADMAP Phase 2 crit 5 ("verify passes end-to-end") or Phase 1 crit 5 (Education named as a live defect) has to be relaxed. Surfacing it is the point. |
| **A3** | Section headings are *not* renamed in this milestone (`Technical Skills` stays, `Selected Projects` stays), because `REQUIREMENTS.md` mandates no rename even though `PITFALLS.md`/`SUMMARY.md` recommend both. `[ASSUMED]` | R5, Open Q2 | LOW — mitigated by design: headings live in the mutable manifest, so a rename is a one-line manifest edit rather than a script change. |
| **A4** | `docs/verify/` is an acceptable home for baselines and `scripts/` for the harness. `[ASSUMED]` — no repo convention exists (no `scripts/` dir today). | Architecture Patterns | LOW. Cosmetic; only affects paths in the plan. |
| **A5** | `PROBE_LINES=5` remains sufficient through the milestone. `[VERIFIED today]` (3 pages), `[ASSUMED]` for later phases. | Probe design | LOW — mitigated by G7.2, which converts probe rot into a loud, named failure with the remedy in the message. |
| **A6** | `.fdb_latexmk` stays git-tracked. `[VERIFIED: git ls-files]` today, `[ASSUMED]` going forward — `make clean` deletes it and a future commit could drop it. | Class 7 | LOW — mitigated: absent ⇒ *unknown*, escalate to L2, never assume fresh. |
| **A7** | The digit-bearing page-1 bullet floor is 7. `[VERIFIED: measured]` — but the metric counts bullet-*initial* extracted lines containing a digit; wrapped continuation lines are separate lines and are not counted. A rewording that moves a number onto a continuation line would trip it spuriously. | G5.4 | LOW — this is exactly why G5.4 is WARN (owner Phase 3), not BLOCKER. `PITFALLS.md:649` itself calls the metric "crude". |
| **A8** | `PITFALLS.md`'s "no term appears ≥3×" is unsuitable as a Phase 1 gate. `[VERIFIED]` — `inference` occurs 10× today. | Deferred table | LOW. Reported as INFO. |
| **A9** | Adding `verify` targets to the existing Makefile does not require renaming `install`/`check`/`build` to the `setup`/`setup-dev`/`run_tests`/`lint` convention. `[ASSUMED]` | Project Constraints, Open Q5 | LOW. Renaming would be out of scope for Phase 1 and would break `README`/muscle memory; raise separately. |

---

## Open Questions (RESOLVED)

> All six were resolved during planning (2026-08-21). Each carries an inline **RESOLVED** marker naming the plan note that binds the answer. Nothing here is still open; do not re-litigate during execution.

1. **Which phase fixes the Education parse order?** — **RESOLVED: G6.12 ships as a BLOCKER in Phase 1 and Phase 2 lands the fix.** Binding note: `01-01-PLAN.md` notes 4 and 5; implemented by `01-02-PLAN.md` Task 4 (G6.12), which requires the FAIL message to name `Owner: Phase 2 (EXP-01 already edits Education; re-asserted by Phase 4 / PG2-03)`.
   - Known: it is a live defect (measured — `Bloomington, IN` before the institution, date range 3 lines detached). ROADMAP Phase 1 crit 5 names it as a defect the harness must *fail* on. `REQUIREMENTS.md` assigns the fix to Phase 4 (PG2-03). ROADMAP Phase 2 crit 5 requires `make verify` to pass end-to-end.
   - Unclear at research time: those three statements cannot all hold if the assertion is a BLOCKER and the fix waits for Phase 4.
   - **Recommendation, adopted:** make G6.12 a BLOCKER and land the fix in Phase 2 — Phase 2 already rewrites Education under EXP-01, and the fix is a `\resumeSubheading` argument reorder at `main.tex:240-242` with zero page-1 cost. Phase 4/PG2-03 then re-asserts rather than introduces it. This is the only assignment under which Phase 1 crit 5 and Phase 2 crit 5 are simultaneously satisfiable.

2. **Are `Technical Skills` → `Skills` and `Selected Projects` → `Projects` in scope?** — **RESOLVED: out of scope this milestone.** Binding note: `01-01-PLAN.md` note 6; the headings are seeded into `SECTIONS` in `01-01-PLAN.md` Task 2, so a future rename is a one-line manifest edit.
   - Known: recommended by `PITFALLS.md` Pitfall 9 and `SUMMARY.md:69`; **absent** from `REQUIREMENTS.md` and from every ROADMAP criterion.
   - **Recommendation, adopted:** out of scope; seed the manifest with today's strings. The design already absorbs a later rename via one manifest line.

3. **Should the Skills ≤3-line assertion ship as WARN in Phase 1 or be omitted entirely?** — **RESOLVED: ships as WARN owned by Phase 5.** Binding note: `01-01-PLAN.md` Task 2 writes `WARN_OWNERS=…|G6.14:5|…` and annotates `SKILLS_MAX_LINES` as measuring 4 today; asserted by `01-02-PLAN.md` Task 4 (G6.14), whose criterion requires the line to print `owner: Phase 5`.
   - Known: measured 4 rendered lines today; ROADMAP Phase 5 crit 1 requires ≤3.
   - **Recommendation, adopted:** ship as WARN with `owner: Phase 5`, and have Phase 5 promote it. It costs three lines of script, keeps the target visible from Phase 1, and cannot break Phases 2–4.

4. **How should G6.15 treat `accentlight`?** — **RESOLVED: assert usage, not definition.** Binding note: `01-02-PLAN.md` Task 4 (G6.15), whose criteria require G6.15 to PASS today, an INFO line to report the unused definition, and the string `accentlight` to be absent from the script so the rule stays generic.
   - Known: `#E4EFEC` is 92.3% gray and **defined but unused** (0 use sites, `main.tex:19`). A naive "no near-white colour definition" rule fails today on a definition that renders nothing.
   - **Recommendation, adopted:** assert *usage* — flag a near-white colour only when it appears in a `\textcolor{…}`/`\color{…}` call site. Separately report the unused definition as INFO (Phase 6/VIS-01 must "use it or delete it").

5. **Do the global Makefile conventions (`setup`/`setup-dev`/`run_tests`/`lint`) apply here?** — **RESOLVED: no rename; add the three `verify*` targets only.** Binding note: `01-03-PLAN.md` Task 3 action and its notes; the optional `run_tests` alias is explicitly left as a follow-up to raise with the user, not added unilaterally.
   - Known: this repo uses `install`/`check`/`build`/`view`/`watch`/`clean`. `make verify` is the name every roadmap criterion uses.
   - **Recommendation, adopted:** add `verify` / `verify-selftest` / `verify-baseline` and change nothing else.

6. **Should `make verify` ever rebuild, or only refuse?** — **RESOLVED: refuse, exit 2, never rebuild.** Binding note: `01-01-PLAN.md` Task 3 (G0.3's four outcomes, `die2`, and the `--skip-freshness` override) plus `01-03-PLAN.md`'s `verify: $(PDF)` comment and G8.3 control. `verify-rebuild` is recorded as out of scope.
   - Known: ROADMAP crit 5 says *refuse* a stale PDF. `ARCHITECTURE.md:440` instead `touch`es and rebuilds.
   - **Recommendation, adopted:** refuse (exit 2) with the remedy `run 'make build'`. Read-only keeps the gate safe on a clean checkout and in CI, and preserves the distinction between "artifact wrong" (1) and "cannot verify" (2). Planning follow-on: because GNU Make 3.81 exits 2 for *any* failed recipe, that 1-vs-2 distinction is only observable when the script is invoked directly — see `01-03-PLAN.md`'s notes. Offer `make verify-rebuild` as an explicit convenience only if the user asks.

---

## Sources

### Primary (HIGH confidence — executed against this repo, 2026-08-21)

- **`docs/main.tex`** (340 ln), **`docs/AshutoshTiwari.pdf`** (2 pp, 612×792, pdfTeX-1.40.27, PDF 1.7, 225,460 B), **`docs/AshutoshTiwari.fdb_latexmk`**, **`Makefile`** (139 ln), **`.gitignore`**, **`.planning/config.json`**
- **poppler 26.08.0** — `pdfinfo`; `pdftotext` in default / `-raw` / `-bbox` / `-f N -l N` modes; full non-ASCII codepoint census; `od -c` byte inspection of the page-2 opening line and the LinkedIn token
- **4 scratch `latexmk` builds** in `mktemp -d` (+4 lines, +5 lines ×2, 2× baseline reproduction) — page counts, `.log` warning counts, page-2 opening lines, bbox extents, cross-build determinism. `git status --porcelain` empty before and after; `docs/AshutoshTiwari.pdf` mtime unchanged
- **Freshness experiments** — `md5 -q docs/main.tex` vs the `.fdb_latexmk` record; `stat -f %m` on source and artifact; `git ls-files docs/`; `make -n build`; scratch-rebuild text-layer and filtered-bbox comparison; `cmp` on PDF bytes
- **Matcher experiments** — `grep -Fxc` vs `grep -Fc` on all 15 candidate frozen strings; `LC_ALL=C grep -F` against a `printf '\xe2\x80\x93'` needle; `grep -owc 'Go'` vs `grep -c 'Go'`; case-sensitive vs case-insensitive counts for 9 ATS exact-match forms
- **Tool inventory** — `command -v` sweep; `brew info --json=v2 poppler`; `ls -l /opt/homebrew/bin/pdftotext`

### Secondary (HIGH confidence — upstream project research, this repo)

- **`.planning/research/ARCHITECTURE.md`** §2.3 cost model, §2.5 overflow-detection trap, §3.1–3.2 ATS inventory and watch-items, **§6.3 the draft 5-gate script**, §6.3 gate-behaviour table — assertion source **A**. Every claim I re-tested reproduced.
- **`.planning/research/PITFALLS.md`** — measured baseline (lines 34–81) and the assertion set embedded in Pitfalls 2, 3, 5, 7, 8, 9, 15, 16, 17, 18, 19, 20, 22, 23, 24 plus the Pitfall-to-Phase table (lines 840–869) — assertion source **B**
- **`.planning/research/SUMMARY.md`** §Page Budget (line 80 measurement discrepancy; line 211 "plan against the conservative pair"), §Phase 0 (line 118–123), line 181 ("needs consolidation, not discovery")
- **`.planning/ROADMAP.md`** Phase 1 goal + 5 criteria, Phases 2–6 criterion 5 (the "verify passes" constraint that drives R6), Checkpoints table
- **`.planning/REQUIREMENTS.md`** VERIFY-01/02/03, Out of Scope (lines 69–74), traceability
- **`.planning/STATE.md`** decisions (gate→budget→content; expected-to-fail), blockers
- **`AGENTS.md`** → `.opencode/skills/spike-findings-thunderock-github-io/` (SKILL.md, `references/projects-section.md`, `sources/001-github-repo-audit`, `sources/002-projects-section-reco`) — read directly; not loadable as a skill in this runtime; contains nothing that constrains the harness

### Tertiary (MEDIUM — inherited, not re-verified here)

- Jobscan ATS mechanics (inverted index, Boolean retrieval, NER date-range binding, blessed separators) and the recruiter-survey figures, via `ARCHITECTURE.md` §3.4 / `PITFALLS.md` Framing — **vendor**, used only for *why* the assertions matter, never for a threshold
- r/EngineeringResumes wiki norms (≤3 Skills lines, don't-mask-URLs, month-precision dates) via `PITFALLS.md` — the source of the `SKILLS_MAX_LINES=3` and contact-literal targets

### Not verified / gaps

- **A1 — the real LinkedIn vanity URL.** No network check performed. The repo's own `/URI` and both research files say `ashutosh--tiwari`; ROADMAP Ph2 crit 3 says otherwise. Needs one user confirmation.
- **No live ATS scan.** Inherited gap (`SUMMARY.md:209`, CRED-02 is v2 backlog). The harness is a `pdftotext` simulation, deliberately.
- **NetSpeed removal cost (≈49pt)** remains estimated by structural symmetry, not measured (`ARCHITECTURE.md:626`). Irrelevant to Phase 1 assertions; relevant to A5's probe-rot margin.
- **Cross-extractor validation** (`pdfminer.six`, Tika) not attempted — deliberately rejected as an unnecessary dependency, not blocked.

---

## Metadata

**Confidence breakdown:**

| Area | Level | Reason |
|---|---|---|
| Assertion merge & reconciliations | **HIGH** | Both source lists read in full; all six reconciliations grounded in a measurement or an explicit `REQUIREMENTS.md`/`ROADMAP.md` citation. R6's consequence (Phase 2 crit 5 unachievable under a naive merge) is a direct reading of the roadmap text. |
| Tooling per assertion class | **HIGH** | Every command executed this session with output recorded. Page-count methods compared 4 ways; matcher semantics tested on the actual colliding strings; freshness tested 3 ways including the mtime failure. |
| Overflow self-test design | **HIGH** | Built and run end-to-end: exit 0, 0 warnings, 3 pages, repo clean. The anchor trap was found by hitting it. |
| Baseline manifest design | **HIGH** on mechanism (all 15 strings verified `grep -Fxc` = 1; geometry hash reproduced), **MEDIUM** on file layout (A4 — no repo convention to follow) |
| Expected-failure bootstrapping | **HIGH** | All three live defects reproduced with exact counts; the remaining ~25 assertions confirmed green today, so the Phase-2-turns-green claim is measured, not assumed. |
| Severity assignment (which are BLOCKERs) | **MEDIUM-HIGH** | The *mechanism* is sound; the *Education assignment* depends on Open Question 1 / Assumption A2, which needs a planner decision. |
| Environment availability | **HIGH** | Direct `command -v` + `brew info` sweep. |
| Validation architecture | **HIGH** | Framework absence verified by directory listing; every requirement mapped to a runnable command with measured timings. |
| Security domain | **MEDIUM-HIGH** | Correct scoping for a local non-networked bash script; the shell-hardening controls are standard practice rather than measured here. |

**Research date:** 2026-08-21
**Valid until:** ~2026-09-20 (30 days). The artifacts are static and the toolchain is pinned locally; the only realistic invalidator is a poppler major upgrade changing extraction behaviour — in which case **re-measure the non-ASCII census, the page-2 opening line, and the frozen-string `grep -Fxc` counts before trusting any threshold in this document.**
