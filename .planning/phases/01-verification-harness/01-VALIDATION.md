---
phase: 1
slug: verification-harness
status: approved
nyquist_compliant: true
wave_0_complete: false
created: 2026-08-21
updated: 2026-08-21
---

# Phase 1 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | bash + make (no test framework — the harness IS the test) |
| **Config file** | none — Wave 0 installs `make verify` + `make verify-selftest` |
| **Quick run command** | `bash scripts/verify-resume.sh` |
| **Full suite command** | `bash scripts/verify-resume.sh --selftest && { bash scripts/verify-resume.sh; test $? -eq 1; }` |
| **Estimated runtime** | ~5–15 seconds (selftest includes one scratch latexmk build, ~1.1s measured) |

> **Why the suite invokes the script, not `make`.** GNU Make 3.81 exits **2** for any failed
> recipe regardless of what the recipe returned — measured both ways in a scratch Makefile
> (recipe exit 1 → make exit 2; recipe exit 2 → make exit 2). So `make verify; test $? -eq 1`
> can never pass, and Make also erases the harness's load-bearing distinction between exit 1
> ("the document is wrong") and exit 2 ("cannot verify — refusing a stale artifact"), which
> ROADMAP criterion 5's second clause depends on. `make verify` is therefore asserted only as
> **exits non-zero**, which is exactly the wording ROADMAP criteria 1–4 use; the exact code is
> asserted by calling `bash scripts/verify-resume.sh` directly.

---

## Sampling Rate

- **After every task commit:** Run `bash scripts/verify-resume.sh` (expected exit 1 from plan 02 onward during Phase 1 — assert the FAILURE NAMES, not exit 0)
- **After every plan wave:** Run `bash scripts/verify-resume.sh --selftest` (probe suite: +5-line overflow probe must be caught; G7 positive controls and G8 negative controls green)
- **Before `/gsd-verify-work`:** all four hold — `--selftest` exits 0; `bash scripts/verify-resume.sh` exits **1** naming exactly the three Phase-2-owned defects (en-dash handle, zero literal URLs, Education parse order); the same script exits **2** on a drifted `--tex`; and `make verify` exits **non-zero**
- **Max feedback latency:** 20 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 1-01-T1 | 01 | 1 | VERIFY-02 | — | N/A (decision record) | static | `LC_ALL=C grep -Fc '[Phase 1 / A1]' .planning/STATE.md \| grep -q '^1$'` | ✅ | ⬜ pending |
| 1-01-T2 | 01 | 1 | VERIFY-03 | T-01-06 | frozen file hand-authored, no generator | integration | `T=$(mktemp -d); pdftotext docs/AshutoshTiwari.pdf - \| tr '\f' '\n' > "$T/g.txt"` then `LC_ALL=C grep -Fxc` = 1 for each of the 15 frozen strings | ❌ W0 | ⬜ pending |
| 1-01-T3 | 01 | 1 | VERIFY-01 | T-01-01, T-01-04 | no eval/source; exit-2 refusal | integration | `bash scripts/verify-resume.sh` exits 0 with four G0 RESULT lines; `bash scripts/verify-resume.sh --tex <mutated copy>` exits 2 with `RESULT G0.3 FAIL`; adding `--skip-freshness` yields `RESULT G0.3 SKIP` and continues | ❌ W0 | ⬜ pending |
| 1-02-T1 | 02 | 2 | VERIFY-01 | — | page tree, not build log | integration | `bash scripts/verify-resume.sh` shows `G1.1/G2.1/G2.2/G2.3/G3.1/G3.4` PASS and `G2.4/G3.2` INFO | ❌ W0 | ⬜ pending |
| 1-02-T2 | 02 | 2 | VERIFY-03 | T-01-06, T-01-07 | exact-count matcher, no `\|\| true` | integration | `bash scripts/verify-resume.sh` shows `G4.1` PASS naming the frozen hash and 15 `G5.(1\|2\|5)` PASS lines; drift control `--tex <copy> --skip-freshness` yields `G4.1` FAIL; `--frozen <one-byte-mutated copy>` yields `G5.1` FAIL count 0 | ❌ W0 | ⬜ pending |
| 1-02-T3 | 02 | 2 | VERIFY-02 | T-01-01 | fixed-string matching, word boundaries | integration | `bash scripts/verify-resume.sh` exits 1 with three `G6.9` FAIL and one `G6.10` FAIL, all naming Phase 2, and `G6.1/G6.2/G6.3/G6.5/G6.7/G6.8` PASS | ❌ W0 | ⬜ pending |
| 1-02-T4 | 02 | 2 | VERIFY-02 | T-01-01 | section-scoped, usage-not-definition | integration | `bash scripts/verify-resume.sh` exits 1 with exactly 5 FAIL lines (3× `G6.9`, `G6.10`, `G6.12`), `G6.13/G6.14` WARN with owners, `G6.15` PASS | ❌ W0 | ⬜ pending |
| 1-03-T1 | 03 | 3 | VERIFY-01 | T-01-05 | scratch build, `-jobname=probe` | integration | `bash scripts/verify-resume.sh --selftest` exits 0 with four `G7.[1-4]` PASS lines; `shasum -a 256 docs/AshutoshTiwari.pdf` identical before/after | ❌ W0 | ⬜ pending |
| 1-03-T2 | 03 | 3 | VERIFY-01, VERIFY-02, VERIFY-03 | T-01-08, T-01-10 | every control on a `mktemp -d` copy | integration | `bash scripts/verify-resume.sh --selftest` shows five `G8.[1-5]` PASS lines and zero `G8.x` FAIL; `shasum -a 256 docs/verify/baseline-frozen.txt docs/verify/manifest.txt docs/main.tex` identical before/after | ❌ W0 | ⬜ pending |
| 1-03-T3 | 03 | 3 | VERIFY-01 | T-01-06, T-01-09 | `ALLOW_FROZEN_UPDATE` guard; no `--skip-freshness` in Makefile | integration | `make verify-selftest` exits 0; `make verify` exits **non-zero** with five `G6.(9\|10\|12)` FAIL lines; `bash scripts/verify-resume.sh` exits **1**; `make check` prints 8 rows; `LC_ALL=C grep -Fc -- '--skip-freshness' Makefile` returns 0 | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

*Do NOT run `make clean` as part of any verification step — it deletes `*.fdb_latexmk` (G0.3's freshness source) and forces a rebuild that rewrites the committed PDF. `clean`'s non-extension is asserted statically by reading its `rm -f` list.*

---

## Wave 0 Requirements

- [ ] `scripts/verify-resume.sh` + assertion set — the deliverable itself is the test infrastructure (plans 01–02)
- [ ] `make verify` target — created in plan 03 Task 3; every criterion above that names `make` is red until then
- [ ] `--selftest` probe suite with positive (G7) AND negative (G8) controls — overflow probe, mutation probes (plan 03 Tasks 1–2)
- [ ] Frozen-strings baseline manifest — pins the 5 employment date ranges, 5 titles, 5 employers + geometry hash (plan 01 Task 2)

*The harness is self-validating: `--selftest` proves the gates fire; the inverted acceptance (`bash scripts/verify-resume.sh; test $? -eq 1`) proves they detect today's real defects.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| LinkedIn vanity handle is actually `ashutosh--tiwari` | VERIFY-02 | Ground truth lives on linkedin.com, not in the repo | User confirms handle at the plan 01 Task 1 checkpoint before the manifest freezes it |

---

## Validation Sign-Off

- [x] All tasks have `<automated>` verify or Wave 0 dependencies
- [x] Sampling continuity: no 3 consecutive tasks without automated verify
- [x] Wave 0 covers all MISSING references
- [x] No watch-mode flags
- [x] Feedback latency < 20s
- [x] Exit-code assertions are satisfiable on GNU Make 3.81 (script-level for exact codes, non-zero for `make`)
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** approved 2026-08-21
