# Phase 01 — Verification Harness — Security Audit

**Verdict:** SECURED — 11/11 threats CLOSED (10 mitigated + verified, 1 accepted + documented)
**ASVS Level:** 1 · **block_on:** high
**Audited:** 2026-08-22, against the working tree (clean, `git status --porcelain` empty)
**Register source:** `<threat_model>` blocks of 01-01-PLAN.md, 01-02-PLAN.md, 01-03-PLAN.md
**Stance:** every mitigation assumed absent until proven by grep or live probe; all probes read-only against tracked files (checksums of `docs/verify/manifest.txt`, `docs/verify/baseline-frozen.txt`, `docs/main.tex`, `docs/AshutoshTiwari.pdf` identical before and after every probe run; working tree unchanged).

## Threat Verification

| Threat ID | Category | Disposition | Verdict | Evidence |
|-----------|----------|-------------|---------|----------|
| T-01-01 | Tampering/Elevation — manifest+frozen parser | mitigate | CLOSED | `manifest_get`/`manifest_list` are pure grep/sed/tr readers (verify-resume.sh:195-207); zero `eval`, zero `source`/`.`-sourcing of file content in the entire script (grep swept all 2051 lines — only comment/python-variable matches). All 9 python heredocs use the quoted delimiter `<<'PY'` (lines 281, 426, 749, 823, 961, 1003, 1177, 1464, 1974) and receive manifest values via argv (e.g. 281, 749, 1464), never by heredoc interpolation. Frozen strings matched fixed-string: `LC_ALL=C grep -Fxc` at 1654, 1415, 1423, 1779. **Live probe:** a manifest copy carrying `PAGE2_OPENS_WITH=$(touch <marker>)` plus an `EVIL=$(…); \`touch …\`; ; rm -rf / #` line was consumed as inert data — no marker file created, the hostile value echoed verbatim inside G2.1's FAIL message. Corroborates 01-01-SUMMARY.md:72 (same class of probe at execution time). |
| T-01-02 | Tampering — path handling | mitigate | CLOSED | Every `$PDF`/`$TEX`/`$MANIFEST`/`$FROZEN`/`$WORK` expansion quoted at use sites (spot-verified across all groups; e.g. 512-528, 544-545, 816-817, 1347-1349). `IFS` is set only as a per-`read` prefix (`IFS=`/`IFS='|'` at 13 sites: 251, 355, 1222, 1441, 1540, 1642, 1713, 1727, 1746, 1755, 1777, 1800, 1906) — never globally reassigned. No unquoted globs. **Live probe:** `--tex "<dir with space>/main.tex"` did not word-split; G0.3 resolved and PASSed against the identical-bytes copy (record matched by basename, verify-resume.sh:657). |
| T-01-03 | DoS — cleanup trap | mitigate | CLOSED | `set -uo pipefail` at line 35; single `rm -rf` in the script at line 454, guarded by `[ -n "${WORK:-}" ] && [ -d "${WORK:-}" ]` (453); `$WORK` originates only from `mktemp -d` (447, 449); every control/probe scratch is `mktemp -d` nested under `$WORK` (816, 958, 1002, 1062, 1085, 1100). |
| T-01-04 | Spoofing — stale artifact | mitigate | CLOSED | L1 md5-vs-`.fdb_latexmk` at 656-701 (awk anchored `$1==f` at 661, dodging the rule-line 4th-field trap); refusal emits `result G0.3 FAIL` FIRST then `die2` (exit 2) at 697-698, distinct from content exit 1; L2 scratch-rebuild arbiter 611-644 with exit-checked pipeline and `ERROR → FAIL + exit 2` (679-686, CR-02 fix). `--skip-freshness` prints a loud `RESULT G0.3 SKIP` on every flagged run (654) and is absent from the Makefile: `grep -Fc -- '--skip-freshness' Makefile` → **0**. **Live probe:** selftest G8.3 PASS — drifted source refused at exit exactly 2 with `G0.3 FAIL x1` (L1 record 729318…44c4). |
| T-01-05 | Tampering — probe/L2 LaTeX builds | mitigate | CLOSED | L2 arbiter builds in `$WORK` with `-jobname=fresh` (617); selftest probe builds in `mktemp -d` under `$WORK` with `-jobname=probe` (816, 862), deliberately not reusing `$(LATEXMK_FLAGS)` (858-861). No `make build` invocation and no `touch` of tracked files anywhere in the script (grep: only a "refusing to touch" message at 1300). **Live probe:** G7.4 PASS — committed PDF sha256 `123d02e3…4ef60d1` byte-unchanged across the probe, porcelain empty before/after. |
| T-01-06 | Repudiation — honesty-freeze writes (HIGHEST-CONSEQUENCE) | mitigate | CLOSED | Write path exists only in `--write-baseline` (1170-1336). Frozen file gated at 1309: without `ALLOW_FROZEN_UPDATE=1` a changed geometry hash is REFUSED (1329-1331); with it, unified diff printed BEFORE the write (1310-1317) and only the derivable `[geometry-sha256]` regenerated — the 15 hand-authored strings never touched (1302-1307, 1320). Manifest staged via sibling temp + atomic `mv` (1279-1285); gated thresholds (PAGES, PAGE_SIZE, PAGE2_OPENS_WITH) reported, never written (1252-1264). **Guard exercised live on scratch copies** (`--frozen`/`--manifest` → mktemp copies, geometry hash mutated): plain run → `!! REFUSING to write …: its geometry hash would change from 0000000b… to 8b13a46b…`, frozen copy checksum byte-identical before/after; `ALLOW_FROZEN_UPDATE=1` re-run → unified diff printed first, hash-only rewrite, "The 15 frozen strings were NOT touched". Tracked `docs/verify/baseline-frozen.txt` unchanged throughout. |
| T-01-07 | Tampering — assertion weakening | mitigate | CLOSED | Matcher forms present as claimed: `grep -Fxc` ×4 (1415, 1423, 1654, 1779), `grep -Fowc` ×1 (1748); frozen comparison is exact-count `= 1` (1655), not at-least-one. Zero-count sweeps over the script: `expected_fail` 0, `allowlist` 0, `known_fail` 0, `\|\| true` 0. (The Makefile's two `\|\| true` at 92/94 are tlmgr install conveniences, not harness assertions — outside this threat's component.) |
| T-01-08 | Tampering — negative controls | mitigate | CLOSED | Each G8 control copies into `mktemp -d` under `$WORK` and forwards only the copy: G8.1 `--frozen` (958-983), G8.2 `--tex` (1002-1021), G8.3 `--tex` copy (1062-1065), G8.4 `--census` fixture (1085-1087), G8.5 `--manifest` (1100-1103). G8.6 asserts the blast radius empirically (1115-1130). **Live probe:** full `--selftest` run exit 0, G8.6 PASS ("checksum-identical … no porcelain entry"); independent bracket by this audit: sha256 of frozen/manifest/tex/PDF identical before vs after, `git status --porcelain` unchanged. |
| T-01-09 | Tampering — Makefile interpolation | mitigate | CLOSED | Verify recipes interpolate only repo-controlled variables: `bash $(VERIFY)` (Makefile:181), `bash $(VERIFY) --selftest` (184), `bash $(VERIFY) --write-baseline` (187); build recipes use `$(TEX_DIR)`/`$(LATEXMK_FLAGS)`/`$(TEX_FILE)` (131, 141). No recipe reads `docs/verify/*` content or extracted PDF text into a command string (full 214-line read). |
| T-01-10 | Elevation — `--skip-freshness` containment | mitigate | CLOSED | Flag parsed in the script only (verify-resume.sh:108); `grep -Fc -- '--skip-freshness' Makefile` → **0**. G0.3 prints SKIP unconditionally on every flagged run — the `SKIP_FRESHNESS=1` branch has exactly one outcome, the SKIP line (646-654). G8.2 is the sole consumer (1021) against a mutated mktemp copy; G8.3 deliberately omits it and exercised the unflagged refusal live (G8.3 PASS, exit exactly 2). |
| T-01-SC | Tampering — package installs | accept | CLOSED (accepted risk, logged below) | Zero npm/PyPI/crates packages in the phase. Poppler provenance audit present at 01-RESEARCH.md:117-128 (Homebrew core formula, upstream since 2005, Cellar symlink + binary version string verified, disposition **Approved**). |

## Accepted Risks Log

| ID | Risk | Rationale | Recorded |
|----|------|-----------|----------|
| T-01-SC | Supply chain of the `poppler` Homebrew formula (pdfinfo/pdftotext) | Only external dependency; already installed (26.08.0), provenance verified via Cellar symlink and the binary's own version string; no language-registry package exists in the phase, so no legitimacy checkpoint applies | 01-RESEARCH.md:117-128 |

## Threat Flags (from SUMMARYs)

- 01-03-SUMMARY.md `## Threat Flags`: **None** — the one new write path (`--write-baseline` → `docs/verify/`) maps to registered T-01-06 (informational, verified above).
- 01-01-SUMMARY.md / 01-02-SUMMARY.md: no `## Threat Flags` section; 01-01-SUMMARY.md:72 records execution-time verification of the T-01-01/T-01-02 controls (corroborated by this audit's own probes).
- **Unregistered flags: none.**

## Prior Review Evidence Incorporated

01-REVIEW.md (status: resolved) hardened two surfaces this register depends on, both re-verified in the current tree: CR-01 (`b0d0a6e`) — crashed measurement blocks now `die_group` → `RESULT FAIL` + exit 2 instead of silently deleting assertion groups (verify-resume.sh:177-186, 245-256); CR-02 (`9e1edd2`) — the L2 arbiter can no longer answer FRESH from a failed pipeline (`arb_normalize` non-empty checks + `/` delimiter + `ERROR` verdict, 588-644). Both close false-PASS channels that would have hollowed out T-01-04.

## Probe Transcript Summary (all read-only vs tracked files)

1. Static sweeps: eval/source, IFS, rm -rf, mktemp origins, heredoc quoting, matcher forms, `--skip-freshness`-in-Makefile → all as claimed.
2. Hostile-manifest injection (`$(touch …)`, backticks, `;`) via `--manifest` scratch copy → inert data, no marker file, exit 1 on known content defects only.
3. Space-containing `--tex` path → no word-split, G0.3 resolved correctly.
4. `--write-baseline` on scratch copies, mutated geometry hash: plain → REFUSED, frozen copy byte-identical; `ALLOW_FROZEN_UPDATE=1` → diff-first, hash-only write.
5. Full `--selftest`: exit 0, G7.1-G7.4 + G8.1-G8.6 all PASS; audit-side sha256 bracket over frozen/manifest/tex/PDF identical, porcelain unchanged.

**threats_open: 0**
