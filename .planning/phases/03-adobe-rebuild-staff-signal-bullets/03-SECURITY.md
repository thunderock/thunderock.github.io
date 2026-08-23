---
phase: 3
slug: adobe-rebuild-staff-signal-bullets
status: verified
threats_open: 0
asvs_level: 1
created: 2026-08-23
---

# Phase 3 — Security

> Per-phase security contract: threat register, accepted risks, and audit trail.

---

## Trust Boundaries

| Boundary | Description | Data Crossing |
|----------|-------------|---------------|
| author → `docs/main.tex` | The only mutable content input; no runtime input, no network, no credentials | Document content (public résumé claims) |
| author → `scripts/verify-*.sh` + `docs/verify/manifest.txt` + `Makefile` | **The gate itself** — highest-value tampering surface; an edit here can convert red into a false green | Assertion logic, thresholds, keyword tiers |
| `docs/main.tex` → tracked build artifacts | `make build` regenerates the PDF and the `.fdb_latexmk` md5 record a fresh reader trusts (`G0.3`) | Build provenance |
| plan artifacts → user checkpoints | D-08 config read and EXP-08 per-bullet sign-off; recorded behind greppable STATE.md markers | Human authorizations |
| repo → future reader / ATS parser | The published text layer; honesty freeze + evidence traceability make claims non-repudiable | Public claim surface |
| external evidence (genie production wheel) → D-08 record | Read-only fetch of the pinned wheel into a scratch dir; sha256-verified; nothing installed or executed | Compile-config evidence |

---

## Threat Register

All rows verified 2026-08-23 by the security auditor (verify-mitigations mode — register authored at plan time; no new-threat scanning). Full per-threat evidence lives in the audit return; one row per threat below.

| Threat ID | Category | Component | Disposition | Mitigation | Status |
|-----------|----------|-----------|-------------|------------|--------|
| T-03-01 | Tampering | P3 net assertions | mitigate | Every class observed failing (red-on-arrival census 46→0 + crafted controls) | closed |
| T-03-02 | Tampering | `assert_promoted` field match | mitigate | Whole-pipe-field match via `tr`+`grep -Fxc`, never substring | closed |
| T-03-03 | Repudiation | `assert_whole_line_once` $4 trap | mitigate | `${4:-…}` default expansion present | closed |
| T-03-04 | Tampering | Vacuous absence needles | mitigate | Rendered EN-DASH + source ASCII dual assertions; `STS` needle rejected for `AssumeRole` | closed |
| T-03-05 | Spoofing | Fixture-driven runs | mitigate | `--gate-text` disclaimer; controls under `mktemp -d`; waiver flags ×0 in Makefile | closed |
| T-03-06 | Info Disclosure | Manifest read | accept | Line-wise `grep`/`sed`/`tr` read; zero `eval`/`source` — metacharacters inert | closed |
| T-03-07 | DoS | Scratch workspace | mitigate | `mktemp -d` only; guarded trap cleanup; zero writes under `docs/` | closed |
| T-03-08 | Tampering | `verify-regressions` recipe | mitigate | No waiver flag in any recipe (`--gate-text`/`--skip-freshness` ×0) | closed |
| T-03-09 | Tampering | Manifest threshold edit | mitigate | Commit `6d58396` diff = exactly 1 line (G6.13 owner) | closed |
| T-03-10 | Tampering | Honesty freeze | mitigate | `baseline-frozen.txt` untouched since Phase 1 (`1b7e513`) | closed |
| T-03-11 | Repudiation | Ownership claim | mitigate | Behavioral: 5× `G6.13 … (owner: Phase 3)` in live output | closed |
| T-03-12 | Repudiation | Site-contradiction handoff | mitigate | Both figures verified still in `index.html` when the handoff was written | closed |
| T-03-13 | Repudiation | Claim dropped in rewrite | mitigate | Disposition record commit `8dd7d83` precedes first content commit `2c37480` | closed |
| T-03-14 | Repudiation | Unprovenanced figure | mitigate | 28× `CODEBASE-EVIDENCE.md:` citations; every shipped figure resolves | closed |
| T-03-15 | Tampering | Draft graduates unapproved | mitigate | Rejected-draft literals ×0 in `main.tex` including comments | closed |
| T-03-16 | Repudiation | Invented magnitude | mitigate | Shipped mentoring bullet has zero numerals; drafts ⚠-flagged | closed |
| T-03-17 | Tampering | Attribution inflation (rules) | mitigate | Rules recorded (DECISION-RECORD:192) + governance slice in net | closed |
| T-03-18 | Tampering | Frozen Adobe cells | mitigate | Byte-identical arrival→HEAD; G5.1/2/5 PASS | closed |
| T-03-19 | Repudiation | Keyword lost in reword | mitigate | `G6.5` 17 PASS; `Rust` ×2 | closed |
| T-03-20 | Tampering | Suffix survives promotion | mitigate | `A100:3`/`H100:3` ×0; whole-field membership | closed |
| T-03-21 | Spoofing | Stale artifact | mitigate | `G0.3` PASS (md5-tied to committed source) | closed |
| T-03-22 | Tampering | Silent 3-page overflow | mitigate | `G1.1` PASS, read first after every build | closed |
| T-03-23 | Tampering | Budget freed not spent | mitigate | `G3.2` p1 +5.9pt ≤ +50.5pt; `G7.2` armed | closed |
| T-03-24 | Repudiation | Governance framed as inference | mitigate | Banned-word slice clause green | closed |
| T-03-25 | Tampering | Undeclared glyph | mitigate | `G6.4` PASS; no U+223C | closed |
| T-03-26 | Repudiation | CUDA clause without the read | mitigate | `[Phase 3 / D-08]` ×1: cudagraphs-confirmed, sha256-verified wheel, module.py:76-77 | closed |
| T-03-26b | Repudiation | Fallback keeps CUDA wording | mitigate | Branch-unreachable (confirmed branch taken); needle non-addition recorded as a decision | closed |
| T-03-27 | Repudiation | Ray attribution inflation | mitigate | `achiev` ×0 in source; needle live in net | closed |
| T-03-28 | Tampering | Vacuous retirement | mitigate | 4-way absence (both streams + both ASCII forms) all ×0 | closed |
| T-03-29 | Tampering | Suffix survives promotion | mitigate | `torch.compile:3`/`Triton:3` ×0 | closed |
| T-03-30 | Repudiation | Landed but never promoted | mitigate | P3.42–45 promotion triples PASS | closed |
| T-03-31 | Repudiation | Unevidenced accelerator claim | mitigate | All 7 forbidden families ×0 in `main.tex` (auditor-run) | closed |
| T-03-32 | Tampering | Curly quotes void match | mitigate | U+201C/U+201D delta 0; `G6.4` PASS | closed |
| T-03-33 | Spoofing | Stale artifact | mitigate | Artifacts ride in source commits; `G0.3` PASS | closed |
| T-03-34 | Repudiation | `fault`/`Spark` dropped | mitigate | Both retained; inside the 17 `G6.5` PASS | closed |
| T-03-35 | Tampering | Line freed instead of held | mitigate | Region counts re-derived: Swiggy 11 / Flipkart 9 unchanged | closed |
| T-03-36 | Repudiation | New unfalsifiable claim | mitigate | Figure set byte-identical pre/post; entailment recorded | closed |
| T-03-37 | Repudiation | Metric eaten by compression | mitigate | `G5.4` value 11 ≥ 8; `18M+` on a countable line | closed |
| T-03-38 | Tampering | Frozen S/F cells | mitigate | Byte-identical (content-resolved); baseline untouched | closed |
| T-03-39 | Repudiation | Artifact mistaken for regression | mitigate | Employer order measured + recorded, not gated | closed |
| T-03-40 | Tampering | Draft ships without approval | mitigate | Blocking checkpoint taken; rejected literals machine-absent | closed |
| T-03-41 | Repudiation | Verdict not recorded | mitigate | `[Phase 3 / EXP-08]` ×1 with per-draft verdicts; rejections as decisions | closed |
| T-03-42 | Repudiation | Decision against a red document | mitigate | All-suites-green proven before the ask; reproduced today | closed |
| T-03-43 | Tampering | Approval overflows silently | mitigate | Budget arithmetic in the packet; decision informed | closed |
| T-03-44 | Repudiation | Wording reconstructed from memory | mitigate | Verbatim record; compression pre-authorized in the same marker | closed |
| T-03-44b | Repudiation | Criterion-2 read assumed | mitigate | `staff-signal: yes` token ×1; Branch C correctly untriggered | closed |
| T-03-45 | Tampering | Unapproved bullet ships | mitigate | `AssumeRole`/`6-week` ×0; absence pairs enforced | closed |
| T-03-46 | Repudiation | Approved wording drifts | mitigate | `mentored` ×1 lowercase mid-sentence; P3.71/72 flipped to presence | closed |
| T-03-47 | Tampering | Absence assertions deleted | mitigate | Rejected pairs retained in live net; net exits 0 with them | closed |
| T-03-48 | Tampering | Approval overflows page 1 | mitigate | `G1.1` PASS; +5.9pt above back-out rung | closed |
| T-03-49 | Tampering | Protected descriptors lost | mitigate | 27 anchored P2 PASS (never bare-PASS count); forbidden forms absent | closed |
| T-03-50 | Repudiation | Net recreates IG-01 | mitigate | `make -n verify` emits both nets; standalone target wired | closed |
| T-03-51 | Repudiation | Tick without satisfaction | mitigate | EXP-02..08 ticked only with all five suites green | closed |
| T-03-51b | Repudiation | EXP-02 ticked on negative read | mitigate | Positive token recorded; revision marker correctly ×0 | closed |
| T-03-52 | Repudiation | Artifact claimed as fixed | mitigate | WR-01 recorded as artifact with Phase-4 candidacy; ungated | closed |
| T-03-SC (×8) | Tampering | Supply chain (per plan) | accept | Verified: file-set of all 34 phase commits contains zero package manifests/lockfiles/installs | closed |

*Status: open · closed*
*Disposition: mitigate (implementation required) · accept (documented risk) · transfer (third-party)*

---

## Accepted Risks Log

| Risk ID | Threat Ref | Rationale | Accepted By | Date |
|---------|------------|-----------|-------------|------|
| AR-03-01 | T-03-06 | Manifest is public repo configuration with no credential; read line-wise (never sourced/eval'd) so metacharacters stay inert data | plan-time register (03-01), auditor-verified | 2026-08-23 |
| AR-03-02 | T-03-SC (×8) | Zero package-manager commands and zero new dependencies across all 34 phase commits — no supply-chain surface exists | plan-time registers (all 8 plans), auditor-verified | 2026-08-23 |

---

## Security Audit Trail

| Audit Date | Threats Total | Closed | Open | Run By |
|------------|---------------|--------|------|--------|
| 2026-08-23 | 63 rows (55 numbered + 8 supply-chain) | 63 | 0 | security auditor (verify-mitigations mode; all gates re-run independently: harness 0 · P2 27 anchored PASS · P3 72 anchored PASS · self-test 10 PASS/0 SKIP) |

**Advisory carry-forwards (not open threats):** review WR-01 (P2-net failure aborts the recipe before the P3 census prints — gating intact, diagnostics lost) and WR-02 (`G6.13:3` owner label outlived the phase; acceptance rationale recorded in STATE.md, label not moved). Both recommended for Phase-4 adoption.

---

## Sign-Off

- [x] All threats have a disposition (mitigate / accept / transfer)
- [x] Accepted risks documented in Accepted Risks Log
- [x] `threats_open: 0` confirmed
- [x] `status: verified` set in frontmatter

**Approval:** verified 2026-08-23
