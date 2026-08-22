---
phase: 01-verification-harness
verified: 2026-08-22T10:14:00Z
status: passed
score: 5/5 must-haves verified
overrides_applied: 0
requirements:
  VERIFY-01: satisfied
  VERIFY-02: satisfied
  VERIFY-03: satisfied
inverted_acceptance:
  selftest_exit: 0
  script_exit: 1
  make_verify_exit: 2
  drift_refusal_exit: 2
  all_four_hold: true
artifact_integrity:
  pdf_sha256: 123d02e32403db204252419097e718cdb1d8dbd24e83658afa3f25f5b4ef60d1
  pdf_unchanged_during_phase: true
  pdf_blob_at_phase_start: 4f7379bfc1763891339c3683e849c6fd081c56f3
  pdf_blob_at_head: 4f7379bfc1763891339c3683e849c6fd081c56f3
  commits_touching_pdf_during_phase: 0
  git_porcelain_after_verification: empty
human_verification_discharged:
  - test: "Open the LinkedIn URL for the recorded handle and confirm it resolves to the user's profile"
    discharged_at: "01-01 Task 1 checkpoint:decision (gate=blocking)"
    evidence: "STATE.md [Phase 1 / A1]: HTTP 200; canonical og:url = ashutosh--tiwari; single-hyphen URL returned 999"
    outstanding: false
---

# Phase 1: Verification Harness — Verification Report

**Phase Goal:** The page-1 fit gate, ATS text-layer integrity, and the honesty invariants are machine-enforced before any content is touched — a silent overflow becomes impossible to ship
**Verified:** 2026-08-22T10:14:00Z
**Status:** passed
**Re-verification:** No — initial verification
**Mode:** standard goal-backward (phase carries no `mode: mvp`)

---

## Inverted Acceptance — the four load-bearing checks

This phase is done when verification **fails** in the right places. All four hold.

| # | Check | Command | Want | Got | Status |
|---|-------|---------|------|-----|--------|
| 1 | Gates provably fire | `make verify-selftest` | exit 0 | **0** — 10/10 `G7.[1-4]`+`G8.[1-6]` PASS, 0 FAIL | ✓ |
| 2 | Red-on-arrival, correctly scoped | `bash scripts/verify-resume.sh` | exit 1, three defect families | **1** — 5 RESULT FAILs: `G6.9`×3, `G6.10`, `G6.12`; **0** outside those families | ✓ |
| 3 | Exposed through make | `make verify` | non-zero | **2** (GNU Make 3.81 collapses any failed recipe to 2 — documented, not a bug) | ✓ |
| 4 | Refuse-to-verify ≠ document-wrong | `bash scripts/verify-resume.sh --tex <drifted>` | exit 2 + `G0.3 FAIL` | **2**, `RESULT G0.3 FAIL "PDF is stale: built from md5 729318…44c4, but …/main.tex is now md5 ed7d68…05ba"`, **0** content assertions reached | ✓ |

Supporting evidence for check 4's precedence rule: the **same** drifted source with `--skip-freshness` yields `RESULT G0.3 SKIP "freshness proof waived by explicit request … this run's content results do NOT certify the committed artifact"` and continues into **79** content assertions, exiting 1. The 1-vs-2 vocabulary is therefore observable and load-bearing.

`make -n verify` was checked before running anything: mtimes on `docs/main.tex` and `docs/AshutoshTiwari.pdf` are identical (`1787351282`), so the recipe is `bash scripts/verify-resume.sh` with no rebuild. The RESULT streams from `make verify` and the direct script invocation are **byte-identical (83 lines)**.

---

## ROADMAP Success Criteria

| # | Criterion | Status | Evidence (command → observation) |
|---|-----------|--------|--------------------------------|
| 1 | `make verify` exits non-zero when the PDF is not exactly 2 pages — demonstrated against a deliberate +5-line probe that today's `make build` accepts warning-free and exit-0 | ✓ VERIFIED | `make verify-selftest` → exit 0. `G7.1 PASS` proves the **premise** numerically: "the build accepts +5 injected line(s) silently: latexmk exit code 0 with 0 overfull/underfull warning(s) (begin=127 break=219 insert=215)". `G7.2 PASS` proves the probe is a genuine overflow: "the probe PDF is 3 page(s), above the manifest PAGES=2 budget" — the anti-rot guard. `G7.3 PASS` proves the gate catches it: "exit 1 with G1.1 FAIL x1 (page count) and G2.1 FAIL x1". On the committed artifact `G1.1 PASS` reads the **page tree** ("page tree reports 2 page(s), manifest PAGES=2"), not the build log. |
| 2 | `make verify` exits non-zero unless page 2 *starts at* `PUBLICATIONS`, asserted positively | ✓ VERIFIED | `G2.1 PASS "page 2 opens at 'PUBLICATIONS' as required by manifest PAGE2_OPENS_WITH=PUBLICATIONS"` — a positive assertion via `pdftotext -f 2 -l 2` first non-empty line. The false-OK alternative is present but **explicitly non-gating**: `G2.4 INFO "experience employer names appearing on page 2: 0 (reported only -- absence is a false OK as a gate; G2.1 is the real boundary assertion)"`. G7.3 confirms `G2.1` FAILs on the partial-spill probe. |
| 3 | `make verify` exits non-zero when the `pdftotext` layer is missing a required keyword, contains a corrupted glyph/ligature, or fails to yield the LinkedIn handle and portfolio URL as literal text | ✓ VERIFIED | **Keyword:** `G8.5 PASS "a required keyword that is absent from the text layer fires: RESULT G6.5 FAIL names 'ZZSELFTESTKEYWORDABSENTBYCONSTRUCTION'"`; 13 `G6.5 PASS` on the live document. **Glyph:** `G8.4 PASS "all three glyph classes fire on a corrupted text fixture: G6.1 (ligature), G6.2 (private-use) and G6.3 (replacement character) all FAIL"` — independently reproduced by me: `--census` on a hand-built fixture → exit 1 with `G6.1/G6.2/G6.3 FAIL`. **Literal handle + URL:** firing on the real defect today — `G6.9 FAIL`×3 (`ashutosh--tiwari`, `github.com/thunderock`, `thunderock.github.io` all 0 occurrences) and `G6.10 FAIL` (`ashutosh–tiwari` U+2013 present). `G4.4 PASS` confirms the ATS switch (`\input{glyphtounicode}`, `\pdfgentounicode=1`) is intact. |
| 4 | `make verify` exits non-zero if any of the five employment date strings or printed titles differs by a single byte from the recorded baseline, or if page geometry / `\setlist` values have drifted | ✓ VERIFIED | **Freeze:** all **15/15** frozen strings return a whole-line count of exactly 1 — 5× `G5.1 PASS` (dates), 5× `G5.2 PASS` (titles), 5× `G5.5 PASS` (employers), matched with `grep -Fxc` against the form-feed-normalized extraction. Byte sensitivity proven: `G8.1 PASS "the honesty freeze fires on a one-byte date change: 'Jul. 2024 – Present' -> 'Jul. 3024 – Present' produced RESULT G5.1 FAIL with count=0"`. **Geometry:** `G4.1 PASS` naming the frozen hash `8b13a46bf5716cb9bb9042a4e1bb60a9d6919fd5f347a34ecdc6122d7f465a56` (line-number-independent); drift proven by `G8.2 PASS "the geometry freeze fires on margin drift: textheight 1.2in -> 1.3in produced RESULT G4.1 FAIL"`. `G4.2 PASS` pins page size 612×792. |
| 5 | `make verify` against today's committed PDF **FAILS and names each live defect** (en-dash handle, zero literal URLs, Education parse order) — and refuses to verify a PDF older than `docs/main.tex` instead of greenlighting a stale artifact | ✓ VERIFIED | **Clause 1 (names each defect):** `make verify` → exit 2 (non-zero); trailer `!! FAIL: 5 blocking failure(s) in: G6.9 G6.10 G6.12`. Every one of the three named defect families is present and **nothing else is**: `grep '^RESULT.* FAIL '` → 5 lines; FAILs outside `{G6.9,G6.10,G6.12}` → **0**. Each message carries its owner (`Owner: Phase 2 / EXP-06`; `Owner: Phase 2 (EXP-01 …)`). **Clause 2 (refuses stale):** drifted `--tex` → exit **2** with `RESULT G0.3 FAIL`, zero content assertions reached; `G8.3 PASS` asserts this at script level, distinguishing it from exit 1 — "machine-readable and distinct from the exit code 1 that means the document is wrong (L1 record 729318…44c4)". |

**Score: 5/5 ROADMAP success criteria verified.**

---

## Requirements Coverage

All three IDs declared in the PLAN frontmatter (`requirements: [VERIFY-01, VERIFY-02, VERIFY-03]`, identical across plans 01/02/03) are accounted for. `REQUIREMENTS.md` maps exactly `VERIFY-01`, `VERIFY-02`, `VERIFY-03` to Phase 1 — **no orphaned requirements**.

| Requirement | Description (from REQUIREMENTS.md) | Status | Evidence |
|-------------|-----------------------------------|--------|----------|
| **VERIFY-01** | `make verify` fails when the PDF ≠ 2 pages or Experience content crosses the page-1 boundary | ✓ SATISFIED | `G1.1` (page tree vs `PAGES=2`), `G2.1`–`G2.3` (positive boundary + page-1 containment of `WORK EXPERIENCE` and `NETSPEED SYSTEMS (Acquired by Intel)`), `G3.1` (deepest content bottom 764.3pt vs ceiling 764.4pt), `G3.4` (0 words outside the page box of 1218 positioned words). Discrimination proven end-to-end by `G7.1`→`G7.2`→`G7.3`. |
| **VERIFY-02** | `make verify` asserts ATS text-layer integrity via pdftotext round-trip — required keywords present, LinkedIn handle extracts correctly, no glyph/ligature corruption | ✓ SATISFIED | `G6.1`–`G6.4` codepoint census (0 ligatures, 0 private-use, 0 U+FFFD; every non-ASCII declared: U+2013 ×40, U+2019 ×6, …), `G6.5` 13 required keywords, `G6.7` prohibited terms with word boundaries, `G6.8` 7 canonical headings, `G6.9`/`G6.10` contact literals + corrupted handle, `G6.12` Education binding, `G6.15` invisible-text scan. Firing proven by `G8.4` and `G8.5`. |
| **VERIFY-03** | `make verify` asserts honesty gates — all employment date strings and titles byte-identical to the recorded baseline | ✓ SATISFIED | 15/15 exact whole-line matches (`G5.1`/`G5.2`/`G5.5`), `G5.3 PASS` ("no title inflation: 'Staff' x0, slash-hedged seniority lines x0"), `G4.1` geometry freeze. Firing proven by `G8.1` (one-byte date) and `G8.2` (geometry drift). |

---

## Required Artifacts

All four pass Levels 1–3 (exists, substantive, wired). Level 4 (data-flow) applies to the harness and is proven by real measured values reaching the RESULT stream.

| Artifact | Level 1 exists | Level 2 substantive | Level 3 wired | Level 4 data flows | Status |
|----------|---------------|---------------------|---------------|--------------------|--------|
| `scripts/verify-resume.sh` | ✓ | ✓ **2051** lines (min 450) | ✓ invoked by 3 make targets (`bash $(VERIFY)` ×5) | ✓ emits 83 RESULT lines / 39 distinct IDs from live `pdfinfo`/`pdftotext`/`python3` measurement | ✓ VERIFIED |
| `Makefile` | ✓ | ✓ 214 lines, `verify-selftest` ×3 | ✓ `.PHONY` single line covers all targets; `verify`/`verify-selftest`/`verify-baseline`/`poppler` present | ✓ `make check` prints **8** rows (5 original + pdfinfo/pdftotext/python3), all resolving to real versions | ✓ VERIFIED |
| `docs/verify/baseline-frozen.txt` | ✓ | ✓ 32 lines (min 20); contains `8b13a46b…f465a56` | ✓ read via `grep -Fxc` whole-line matcher (4 sites) | ✓ all 15 strings return count exactly 1 against the live extraction | ✓ VERIFIED |
| `docs/verify/manifest.txt` | ✓ | ✓ 54 lines (min 25); contains `PAGE2_OPENS_WITH=PUBLICATIONS` | ✓ line-wise `grep -m1` (8 sites); **0** `eval`, **0** `source` of data files | ✓ threshold values appear verbatim in RESULT messages (`PAGES=2`, `CEILING_PT`, `EDU_BIND_WINDOW=3`, `SKILLS_MAX_LINES`) | ✓ VERIFIED |

---

## Key Link Verification

| From | To | Via | Status | Evidence |
|------|----|-----|--------|----------|
| `verify-resume.sh` | `manifest.txt` | line-wise grep, never eval/source | ✓ WIRED | `grep -m1` ×8; the only `eval` token in the file is line 190 **inside a comment**; `source`/`.` of `$MANIFEST`/`$FROZEN` → 0 |
| `verify-resume.sh` | `AshutoshTiwari.fdb_latexmk` | awk extraction of latexmk's recorded md5 | ✓ WIRED | `fdb_latexmk` ×6; `G0.3 PASS` names md5 `729318505f45209be4838bdff42044c4` |
| `verify-resume.sh` | pdfinfo page tree | `Pages:` field parse | ✓ WIRED | `Pages:` ×3; `G1.1` reports "page tree reports 2 page(s)" |
| `verify-resume.sh` | per-page text extraction | `pdftotext -f 2 -l 2` first non-empty line | ✓ WIRED | pattern ×2; `G2.1` names the extracted opener |
| `verify-resume.sh` | `baseline-frozen.txt` | `grep -Fxc` whole-line count == 1 | ✓ WIRED | ×4; 15 PASS lines each stating "appears exactly once as a whole extracted line" |
| `verify-resume.sh` | manifest `EDU_*` keys | Education-scoped ordering + window | ✓ WIRED | `EDU_INSTITUTION` ×2; `G6.12 FAIL` names region "gate lines 100-113", city line 100 before institution line 102 |
| `verify-resume.sh --selftest` | `mktemp -d` scratch build | latexmk with `jobname=probe` | ✓ WIRED | `jobname=probe` ×2; `G7.1` reports the scratch build; `G7.4`/`G8.6` prove blast radius |
| `Makefile verify` | `verify-resume.sh` | `bash $(VERIFY)` | ✓ WIRED | ×5; RESULT streams byte-identical between `make verify` and direct invocation |

---

## Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|----------|---------|--------|--------|
| Full VALIDATION suite, verbatim | `bash …--selftest && { bash …; test $? -eq 1; }` | exit **0** | ✓ PASS |
| `--census` surface (G8.4's dependency) | `--census <corrupt fixture>` | exit 1; `G6.1`/`G6.2`/`G6.3` FAIL + 3 `G6.4` WARN; runs `G0.1` only | ✓ PASS |
| `--write-baseline` idempotence | `--write-baseline` | exit 0; "already matches live measurement; nothing written"; manifest+frozen sha **unchanged** | ✓ PASS |
| Honesty-freeze write guard | inspect | refuses without `ALLOW_FROZEN_UPDATE=1` (guard referenced ×6), diff-first | ✓ PASS |
| Exit vocabulary — unknown flag | `--bogus-flag` | exit **2** | ✓ PASS |
| Exit vocabulary — help | `--help` | exit **0** | ✓ PASS |
| `--skip-freshness` containment | `grep -Fc -- '--skip-freshness' Makefile` | **0** (script: 9) — no make target can waive freshness | ✓ PASS |
| `make check` extension | `make check` | 8 rows, exit 0 | ✓ PASS |
| shellcheck | `shellcheck scripts/verify-resume.sh` | 1 finding: pre-existing `SC2329` on trap-invoked `cleanup` — pre-acknowledged in 01-03 + REVIEW | ✓ PASS (no new) |

---

## Code Review Resolution — independently re-verified

`01-REVIEW.md` claims 1 BLOCKER + 3 WARNINGs resolved with A/B evidence. I reproduced the **after** state myself rather than accepting the claim. All four hold.

| Finding | Claim | My independent re-test | Verdict |
|---------|-------|------------------------|---------|
| **CR-01** (BLOCKER) — crashed python block silently deletes its assertion group, a false-PASS channel | fixed by `b0d0a6e` via `die_group` + exit-status propagation | **Probe A:** `--manifest` with `NONASCII_ALLOW=U+2013,2019` → exit **2**, `RESULT G6.1 FAIL "the glyph census (G6.1-G6.4) assertion group could NOT RUN: … ValueError: invalid literal for int() with base 16: 'U+2013'. The group's verdict is UNKNOWN, which is never a pass"`. **Probe B:** `CEILING_PT=` → exit **2**, `RESULT G3.1 FAIL "… ValueError: could not convert string to float: ''"`. **Probe C** (zero-row channel): emptied `[titles]` → exit **2**, `RESULT G5.2 FAIL "no G5.2 row was produced by its measurement block … verdict is UNKNOWN, which is never a pass"`. `die_group` defined ×1, called ×10. | ✓ RESOLVED |
| **CR-02** (WARNING) — `l2_arbiter` can report FRESH when its measurement failed | fixed by `9e1edd2` via `arb_normalize` + `/` delimiter | **False-positive path:** a *different* document (`transcript.pdf`) copied to `a@b.pdf` → exit **2**, `RESULT G0.3 FAIL "… the L2 scratch rebuild DIVERGES … -> run 'make build'"` (previously exit 1 with a false `G0.3 PASS`). **No false negative:** the *correct* PDF as `ok@name.pdf` → exit 1 with `G0.3 PASS "… L2 scratch rebuild proves the PDF matches the current source"`. `arb_normalize` present ×4. | ✓ RESOLVED |
| **CR-03** (WARNING) — `verify` comment contradicted build-then-verify reality | fixed by `4d68aa2` (comment only, deliberately) | `Makefile:160-181` now states verbatim that the target "**rebuilds it whenever `docs/main.tex` carries a strictly newer mtime**, then verifies the artifact it just built … this target is build-then-verify, and it overwrites the tracked PDF", explains why mtime cannot be a freshness proof in either direction, and points at `bash $(VERIFY)` for gating without rebuild risk. | ✓ RESOLVED |
| **CR-04** (WARNING) — G8.3 breaks after a routine `make clean` | fixed by `60b96d3` via record pre-check → SKIP | `--selftest` with a recordless `--pdf` → exit **0** with `RESULT G8.3 SKIP "the staleness control cannot run: no latexmk md5 record for main.tex in …/norecord.fdb_latexmk (a routine 'make clean' deletes it) … run 'make build' to restore the record"`. SKIP leaves BLOCKERS untouched, so an unexercisable control is no longer a failing one. | ✓ RESOLVED |
| CR-05, CR-08, CR-09, CR-10 (NOTEs) | fixed by `78365ac` | Header read-only claim now qualified; `--write-baseline` staging (`$MANIFEST.regen.$$`) is the sole docs/ write and lives in a non-asserting mode; no write redirection into `docs/` found in any asserting path. | ✓ RESOLVED |
| CR-06, CR-07 (NOTEs) | **deliberately deferred**, reasons recorded | CR-06: I confirmed the cited collision **cannot occur** — both patterns are anchored on the delimiter following the ID (`^G6.1\|` cannot match `G6.15\|`; `^G6.1:` cannot match `G6.13:`). Latent class, no live instance. CR-07: the three bbox-XML parses now all fail loudly via CR-01's exit-status checks rather than silently. | ✓ ACCEPTABLE (documented deferral, no live defect) |

---

## Artifact Byte-Integrity — the committed PDF was never rewritten

The central risk in a verification-harness phase is that the harness mutates the thing it measures.

| Check | Result |
|-------|--------|
| PDF sha256 **before** any verification action | `123d02e32403db204252419097e718cdb1d8dbd24e83658afa3f25f5b4ef60d1` |
| PDF sha256 **after** the full sweep (make verify, selftest ×2, 8 mutation probes, census, write-baseline) | `123d02e32403db204252419097e718cdb1d8dbd24e83658afa3f25f5b4ef60d1` — **identical** |
| Matches the expected baseline `123d02e3…60d1` | ✓ |
| Working tree PDF == `HEAD:docs/AshutoshTiwari.pdf` blob | ✓ |
| Commits touching `docs/AshutoshTiwari.pdf` during the phase (`8e17836^..HEAD`) | **0** |
| PDF blob at phase start vs HEAD | `4f7379bfc1763891339c3683e849c6fd081c56f3` == `4f7379bfc1763891339c3683e849c6fd081c56f3` |
| `git status --porcelain` after all verification runs | **empty** |
| `baseline-frozen.txt` / `manifest.txt` / `main.tex` / `verify-resume.sh` / `Makefile` sha256 before vs after | all **unchanged** |
| Harness invokes `make build`? | **No** — all 8 `make build` occurrences are prose inside error messages (`-> run 'make build'`) |
| Harness invokes `touch`? | **No** — both occurrences are prose ("does not touch BLOCKERS", "refusing to touch $FROZEN") |
| `\|\| true` fail-open suppressors | **0** |
| In-harness self-assertions | `G7.4 PASS` (PDF byte-unchanged + porcelain empty around the probe), `G8.6 PASS` (all three tracked inputs checksum-identical, controls added no porcelain entry) |

---

## Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| — | — | `TBD` / `FIXME` / `XXX` in phase-modified files | — | **none found** (BLOCKER gate clean across all 4 files) |
| — | — | `TODO` / `HACK` / `PLACEHOLDER` | — | **none found** |
| — | — | stub prose ("coming soon", "not yet implemented") | — | **none found** |
| `scripts/verify-resume.sh` | 18, 2042 | Trailer prose "G7-G8 land in Plan 03" reads as future tense now that Plan 03 has landed | ℹ️ INFO | Cosmetic only. It is an informational `>>` summary line, not a RESULT line — it affects no assertion, no BLOCKERS tally and no exit code. Literally still true (G7/G8 *were* delivered by Plan 03 and run only under `--selftest`). |
| `scripts/verify-resume.sh` | 452 | shellcheck `SC2329` on `cleanup` | ℹ️ INFO | False positive — the function is trap-invoked on EXIT. Pre-existing, pre-acknowledged in `01-03-SUMMARY.md` and excluded by name in `01-REVIEW.md`. |

---

## Human Verification

**No outstanding items.** The phase declared exactly one manual-only verification, and it was discharged during execution at a blocking gate rather than deferred to end-of-phase.

| Item | Requirement | Disposition |
|------|-------------|-------------|
| "Open the LinkedIn URL for the recorded handle and confirm it resolves to the user's profile" (`01-01-PLAN.md:189`, attached to `<task type="checkpoint:decision" gate="blocking">`) | VERIFY-02 | ✅ **DISCHARGED** at the 01-01 Task 1 checkpoint. `STATE.md [Phase 1 / A1]` records the user confirmation plus live-probe evidence: HTTP 200; LinkedIn canonical `og:url` = `ashutosh--tiwari`; the single-hyphen URL returned 999. The plan's own automated acceptance for that task re-run by me → **exit 0**. |

Consequence worth flagging for Phase 2: this decision **supersedes** `ROADMAP.md` Phase 2 criterion 3, which spells the handle `ashutosh-tiwari` (single hyphen). `docs/verify/manifest.txt:35` correctly freezes the double-hyphen form in `CONTACT_LITERALS` and the U+2013 form in `FORBIDDEN_LITERAL`. A later pass must **not** "correct" the manifest backwards to the roadmap's transcription error.

---

## Gaps Summary

**None.** Every must-have resolved to VERIFIED; no truth FAILED and none was left UNCERTAIN.

The adversarial starting hypothesis — *tasks completed, goal missed* — does not survive contact with the artifacts. The specific ways this phase could have faked completion were each tested and each failed to reproduce:

- **A harness that passes because it cannot see** — refuted by the 10 G7/G8 controls plus my own independent mutation probes. Every assertion class has now been observed FAILING as well as passing.
- **A harness that is green because the gates are absent** — refuted by 39 distinct assertion IDs on every run, and by CR-01's fix: an assertion group whose measurement block crashes now emits FAIL and exits 2 instead of vanishing. I reproduced all three vanishing channels and confirmed each now refuses.
- **A harness that mutated its own subject to pass** — refuted by byte-identical sha256 on the PDF and all tracked inputs across the full sweep, zero commits touching the PDF during the phase, identical git blob IDs at phase start and HEAD, and an empty porcelain.
- **A false-green from a stale artifact** — refuted by exit 2 + `G0.3 FAIL` on drifted source with zero content assertions reached, and by the metachar-basename false-FRESH path (CR-02) now being refused.
- **Scope creep in the failure set** — refuted by the family assertion: exactly 5 BLOCKER FAILs, all inside `{G6.9, G6.10, G6.12}`, zero outside. Phase 2 can turn this green by fixing EXP-06 plus the `\resumeSubheading` reorder, with no change to the harness — which is what makes Phase 2's own criterion 5 reachable.

One caveat is recorded rather than hidden: `make verify` on an **edited** source is build-then-verify and will overwrite the tracked PDF (mtimes are equal today, so it did not here — confirmed via `make -n` before running). This is now stated accurately in the Makefile comment (CR-03), and `bash scripts/verify-resume.sh` is the rebuild-free path for gating the committed artifact.

---

_Verified: 2026-08-22T10:14:00Z_
_Verifier: gsd-verifier — goal-backward, FORCE stance_
