# Phase 02 — Page-1 Budget & Text-Layer Defects — Security Audit

**Verdict:** SECURED — 15/15 threats CLOSED (12 mitigated + verified, 3 accepted + documented)
**ASVS Level:** 1 · **block_on:** high
**Audited:** 2026-08-22, against the working tree (clean; only pre-existing untracked `.omc/` in porcelain)
**Register source:** `<threat_model>` blocks of 02-01-PLAN.md and 02-02-PLAN.md (T-02-SC declared identically in both; deduplicated)
**Stance:** every mitigation assumed absent until proven by grep or live probe; all probes read-only against tracked files — sha256 of `docs/main.tex`, `docs/verify/manifest.txt`, `docs/verify/baseline-frozen.txt`, `docs/AshutoshTiwari.pdf`, `scripts/verify-resume.sh`, `Makefile` bracketed before and after the full probe run (harness, selftest, negative control, fresh clone) and byte-identical; `git status --porcelain` unchanged.

## Threat Verification

| Threat ID | Category | Disposition | Verdict | Evidence |
|-----------|----------|-------------|---------|----------|
| T-02-01 | Repudiation — honesty freeze on the shipped artifact | mitigate | CLOSED | Live run of `bash scripts/verify-resume.sh` on the committed artifact: `G5.1 PASS` ×**5**, `G5.2 PASS` ×**5**, `G5.5 PASS` ×**5** (15 total), `G5.(1\|2\|5) FAIL` ×**0**, exit 0 — each message the whole-line-exactly-once invariant. Fold kept `\resumeSubheading` for both folded roles (docs/main.tex:195 GROUPON, :202 NETSPEED SYSTEMS), so no frozen string is glued onto a shared extracted line — corroborated by the 15/15 whole-line matches themselves. |
| T-02-02 | Tampering — `docs/verify/` from Plan-01 commits | mitigate | CLOSED | `git show --name-only --format=` for **92f4891, 450a312, 933778e**: only `docs/main.tex` + build artifacts (`.pdf .log .fdb_latexmk .fls`); `grep -c 'docs/verify/'` over the union → **0**. |
| T-02-03 | Tampering — geometry/`\setlist` as a fit lever | mitigate | CLOSED | `git diff --unified=0 65573ac..HEAD -- docs/main.tex \| grep -cE '^[+-].*(\\setlist\|\\addtolength\|\\usepackage)'` → **0** across the whole phase; live `RESULT G4.1 PASS` on the existing frozen hash `8b13a46b…465a56`. |
| T-02-04 | Tampering — tracked artifacts vs source (freshness) | mitigate | CLOSED | Every artifact commit (92f4891, 450a312, 933778e, 29999ff) contains `docs/AshutoshTiwari.fdb_latexmk` with its source; live `md5 -q docs/main.tex` → `eff2ec04067eb8fa60b775424a0a3a53` == the `.fdb_latexmk` record for `"main.tex"` == the md5 `G0.3 PASS` quotes. No `make clean` in history (`.fdb` present at every phase commit). |
| T-02-06 | DoS — horizontal overflow off the page box | mitigate | CLOSED | Live `RESULT G3.4 PASS  0 words outside the page box, of 1177 positioned words`; `grep -c 'Overfull \\hbox' docs/AshutoshTiwari.log` → **0**. |
| T-02-07 | Tampering — `G6.12` clause weakened to reach green | mitigate | CLOSED | Clause is anchor-free institution-first (verify-resume.sh:1921 PASS branch asserts "first non-empty line in the region"). **Negative control REPRODUCED by this audit:** `git show 65573ac:docs/main.tex` + `65573ac:docs/AshutoshTiwari.pdf` into `mktemp -d` (basename preserved), run with `--pdf/--tex/--skip-freshness` → `RESULT G6.12 FAIL` ("line 100 comes first and reads 'Bloomington, IN'"), `G0.3 SKIP` the only waiver, exit **1**. Not a tautology. |
| T-02-08 | Tampering — `EDU_CITY` key/reader desync (empty-needle trap) | mitigate | CLOSED | `grep -c 'EDU_CITY' docs/verify/manifest.txt` → **0**; `grep -c 'EDU_CITY' scripts/verify-resume.sh` → **0**. Key and its only reader died together in **232abc2** (`git show --name-only 232abc2` carries both files). |
| T-02-09 | Tampering — `PROBE_LINES` / threshold drift | mitigate | CLOSED | `PROBE_LINES=5` in manifest (raise-only rule: never moved — T-2 did not trigger); live `make verify-selftest` exit 0 with `G7.1 PASS` (+5 injected lines accepted, 0 overfull) and `G7.2 PASS` (probe PDF 3 pages > PAGES=2, genuine overflow) at that value; `git diff 65573ac..HEAD -- docs/verify/manifest.txt \| grep -cE '^[+-](PAGES\|CEILING_PT\|LINE_PT\|CAREER_BREAK_PT\|PAGE_SIZE\|EDU_BIND_WINDOW\|SKILLS_MAX_LINES\|DIGIT_BULLET_FLOOR\|PROBE_LINES)='` → **0**. |
| T-02-10 | Repudiation — `baseline-frozen.txt` / `ALLOW_FROZEN_UPDATE` | mitigate | CLOSED | `git log --oneline 65573ac..HEAD -- docs/verify/baseline-frozen.txt` → **0** commits (byte-identical across the whole phase; sha256 `98bc0e90…8fda6e` stable through all audit probes). `ALLOW_FROZEN_UPDATE` appears only in a pre-existing Makefile help-comment (Makefile:186); Makefile has **0** phase commits, so no invocation path existed. `G4.1 PASS` on the existing hash. |
| T-02-11 | Repudiation — Education date ranges (outside `baseline-frozen.txt` coverage) | mitigate | CLOSED | `LC_ALL=C grep -Fxc 'Aug. 2021 – May 2023'` → **1** and `'Aug. 2011 – May 2015'` → **1** against the live extraction (whole-line, exactly once each). Manifest carries `EDU_DATE=Aug. 2021 – May 2023`; harness reads it (`manifest_get EDU_DATE`, verify-resume.sh:1888) and the retained `EDU_BIND_WINDOW` clause enforces it (`EDU_SPAN` vs `EDU_WINDOW`, :1916-1918; live `G6.12 PASS` states "date line 97 is 2 non-empty line(s) away (window 3)"). |
| T-02-12 | Tampering — stale greenlight on a fresh checkout | mitigate | CLOSED | **REPRODUCED by this audit:** `git clone` of the repo at HEAD into `mktemp -d` (clean tree, porcelain 0), `bash scripts/verify-resume.sh` → `RESULT G0.3 PASS  PDF provably built from current main.tex (latexmk md5 eff2ec04…)`, 0 FAIL lines, exit **0**. |
| T-02-13 | Elevation — `--skip-freshness` leaking into the Makefile | mitigate | CLOSED | `grep -c 'skip-freshness' Makefile` → **0**. Phase usage confined to Task 2's negative control against a `mktemp -d` copy (02-02-SUMMARY negative-control transcript, `G0.3 SKIP` sole waiver) — re-confirmed by this audit's own reproduction of that control; the harness's internal G8.2 consumer against a mktemp copy is Phase-1-verified (01-SECURITY.md T-01-10) and unchanged. |
| T-02-05 | Information disclosure — contact line | accept | CLOSED (accepted risk, logged below) | Display text only changed; all four brace-closed `\href` targets each measure exactly **1** in docs/main.tex (`linkedin.com/in/ashutosh--tiwari`, `github.com/thunderock`, `thunderock.github.io/`, `mailto:findashutoshtiwari@gmail.com`); phone + email were already in the published PDF. No new personal data. |
| T-02-14 | Information disclosure — Education content | accept | CLOSED (accepted risk, logged below) | Information was **removed**, not added: `Bloomington, IN` and `Patna, India` → **0** in both text layer and source. GPAs retained by decision (Phase 4 / PG2-03 owns removal). |
| T-02-SC | Tampering — supply chain | accept | CLOSED (accepted risk, logged below) | Zero new `\usepackage` in the phase diff (**0**, same sweep as T-02-03); no `npm`/`pip`/`pipx`/`cargo`/`uv`/`brew install` in any task command (both SUMMARYs assert; no lockfile/manifest of any package manager changed in `git diff 65573ac..HEAD --stat`). |

## Accepted Risks Log

| ID | Risk | Rationale | Recorded |
|----|------|-----------|----------|
| T-02-05 | Contact-line personal data (phone, email, profile URLs) visible as bare display text | D-01 changed display text only; `\href` targets byte-identical (4× brace-closed grep == 1); the phone and email were already published in the committed PDF, so no new disclosure surface | 02-01-PLAN.md threat register; 02-01-SUMMARY.md Threat Flags |
| T-02-14 | Education section content exposure | Dropping the city cells removes information; nothing new is published. GPAs remain by explicit decision — Phase 4 / PG2-03 owns their removal (`EDU_OWNER` now names it) | 02-02-PLAN.md threat register; 02-02-SUMMARY.md Threat Flags |
| T-02-SC | Supply chain | Not applicable this phase: zero package-manager installs and zero new LaTeX packages, both asserted by criteria and re-verified by this audit's phase-diff sweep. Poppler provenance carried over from Phase 1 (01-RESEARCH.md:117-128, Approved) | Both PLAN registers; Task 3 criterion 11 (02-02); Task 3 criterion 7 (02-01) |

## Threat Flags (from SUMMARYs)

- 02-01-SUMMARY.md `## Threat Flags`: **None** — reaffirms T-02-05 accept and T-02-SC (0 `\usepackage`). No new endpoint/auth/file-access/trust-boundary surface.
- 02-02-SUMMARY.md `## Threat Flags`: **None** — all eight plan-02 register dispositions discharged inline (each re-verified independently above).
- **Unregistered flag (WARNING, non-blocking):** 02-REVIEW.md **WR-01** — the career-break deletion shifted the Flipkart block ~49pt and flipped its pdftotext row-2 cell order (subtitle now extracts before the employer line). This is the same defect class `G6.12` guards for Education, but no gate asserts employer-first for Work Experience rows, and neither SUMMARY's Threat Flags names it. It maps to **no registered threat ID** (T-02-01/T-02-11 still hold — `G5.5` whole-line ×1 PASSes; the line exists, just later). Not a mitigation gap in this register; logged so Phase 3 (whose rebuild re-shifts every block's y-position) either documents it as a known non-gated wobble or adds a `region_first_nonempty`-style employer-first clause, per WR-01's fix guidance.

## Prior Review Evidence Incorporated

02-REVIEW.md (deep, 0 BLOCKER / 1 WARNING / 3 NOTE) independently re-ran the gate (exit 0, 0 FAIL), the selftest (10/10 PASS, G8.3 PASS not SKIP), and G0.3 freshness — all consistent with this audit's own runs. NT-02 (`region_first_nonempty` empty-arg guard) is unreachable via the sole caller and inherits the pre-existing helper idiom; it does not weaken T-02-07's clause. NT-03 (descriptor wording an editorial rendering) does not touch any frozen string — G5 15/15 whole-line PASS stands.

## Probe Transcript Summary (all read-only vs tracked files)

1. sha256 bracket over the six tracked security-relevant files: identical before and after all probes; porcelain unchanged (`?? .omc/` pre-existing only).
2. Live gate run: exit 0, 0 FAIL, `G5.1/G5.2/G5.5` 5/5/5, `G0.3`/`G3.4`/`G4.1`/`G6.12` PASS.
3. Live `make verify-selftest`: exit 0, `G7.[1-4]` + `G8.[1-6]` 10/10 PASS, `G7.1`+`G7.2` both PASS at `PROBE_LINES=5`.
4. Negative control reproduced (T-02-07): 65573ac `main.tex`+PDF pair via `git show` into `mktemp -d` → `G6.12 FAIL`, `G0.3 SKIP`, exit 1; scratch dir removed.
5. Fresh clone reproduced (T-02-12): `git clone` of HEAD into `mktemp -d` → clean tree, `G0.3 PASS`, 0 FAIL, exit 0; scratch dir removed.
6. Static sweeps: plan-01 commits touch nothing under `docs/verify/`; phase diff adds no `\setlist`/`\addtolength`/`\usepackage`; `EDU_CITY` 0 refs in manifest and harness; `skip-freshness` 0 in Makefile; `baseline-frozen.txt` 0 phase commits; no threshold key moved; `.fdb_latexmk` md5 == live `main.tex` md5.

**threats_open: 0**
