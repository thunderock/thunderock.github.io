---
status: resolved
blockers: 1
warnings: 3
notes: 6
reviewed: 2026-08-22
resolved: 2026-08-22
resolved_commits: [b0d0a6e, 9e1edd2, 60b96d3, 4d68aa2, 78365ac]
deferred: [CR-06, CR-07]
---

# Phase 1: Code Review — Verification Harness

**Reviewed:** 2026-08-22
**Depth:** deep (full read of all 4 files + cross-checking against 01-02/01-03 summaries and ROADMAP Phase 1)
**Files reviewed:** scripts/verify-resume.sh (1874 lines), Makefile (196 lines), docs/verify/baseline-frozen.txt, docs/verify/manifest.txt
**Status:** issues_found

Pre-acknowledged context NOT re-reported as findings: exit 1 on today's PDF is correct by design; Make 3.81 collapsing recipe exits to 2; shellcheck SC2329 on `cleanup` (documented in 01-03); the six documented deviations in 01-03-SUMMARY.

## Findings

| ID | Sev | File:Line | Finding |
|----|-----|-----------|---------|
| CR-01 | BLOCKER | scripts/verify-resume.sh:225-263, 1307-1370, 1800-1854, 189-207 | A crashed inline python block silently deletes its whole assertion group — false-PASS channel. `glyph_census` ends in `return 0` (line 263), masking python's exit status; the G3 block (1307) and G6.15 block (1800) redirect to a rows file with no exit-status or row-count check; `emit_rows` (200-207) emits nothing when the file has no matching ID and reports no error. Consequence: a malformed manifest edit (`NONASCII_ALLOW=U+2013,...` → `int('U+2013',16)` ValueError; or a deleted `CEILING_PT` → `float('')` ValueError) or a truncated bbox XML makes G6.1-G6.4, or G3.1/G3.4, or G6.15 vanish from the RESULT stream with BLOCKERS untouched — on a post-Phase-2 green document the run exits 0. **Empirically confirmed during this review** (read-only, mutated manifest copies in mktemp): `--manifest` with `NONASCII_ALLOW=U+2013,2019` → 0 `RESULT G6.[1-4]` lines emitted (a python traceback goes to stderr but the RESULT stream and BLOCKERS tally are unaffected); `--manifest` with `CEILING_PT=` → 0 `RESULT G3.*` lines. Both runs still reported only the 5 known Phase-2 defects. This directly violates the harness's own "no false PASS" design rule and the 01-02 claim that "39 assertion IDs report on every run, none silently absent". Fix: propagate python's exit status (drop the `return 0` masks, check `$?` after each heredoc, `die2` on nonzero — an assertion engine that errored is "cannot verify") and/or have `emit_rows` fail when zero rows matched an expected ID. |
| CR-02 | WARNING | scripts/verify-resume.sh:518-541 | `l2_arbiter` can report FRESH when its measurement pipeline failed. Neither `pdftotext -bbox` call (529-530) is exit-checked, and the two `sed | grep -v > file` pipelines (531-534) fail identically on error — producing two EMPTY `a.n`/`b.n` files that `cmp -s` declares equal → `FRESH` → `G0.3 PASS "L2 scratch rebuild proves the PDF matches"`. A concrete trigger exists: the inline sed escapes `[.[\*^$]` in the PDF basename but not the `@` delimiter (or `]`), so `--pdf` / `VERIFY_PDF` naming a file with `@` breaks both seds and yields a false freshness pass. Fix: check pdftotext exit codes, assert `a.n`/`b.n` are non-empty before `cmp`, and escape `@`/`]` (or pick an impossible delimiter). |
| CR-03 | WARNING | Makefile:159-169 | The comment above `verify` claims it "deliberately does not rebuild a STALE one", but `verify: $(PDF)` with the `$(PDF): $(TEX_DIR)/$(TEX_FILE)` rule (128) means make DOES rebuild — and overwrite — the committed PDF whenever `docs/main.tex` has a strictly newer mtime (any edit). The claim holds only in the equal-mtimes fresh-checkout case. So `make verify` on a dirty source silently mutates the tracked artifact (PDF + aux files) and then verifies the just-built one — "build-then-verify", not "verify", and exactly the mutate-the-thing-under-test behavior the script header forbids for the harness. Fix: either make the prerequisite existence-only (e.g. drop the prerequisite and have the recipe test `-f $(PDF)` with a "run make build" message, relying on the script's G0.2/G0.3), or correct the comment to state the real behavior so Phase 2 isn't surprised when `make verify` rewrites the PDF mid-edit. |
| CR-04 | WARNING | scripts/verify-resume.sh:911-937; Makefile:181-191 | G8.3 breaks after a routine `make clean`. The staleness control asserts exit code exactly 2 via the L1 (md5-vs-`.fdb_latexmk`) path, but `make clean` deletes `docs/*.fdb_latexmk` (Makefile:189). With no record, the inner run escalates to the L2 arbiter; the appended-comment copy renders identically → FRESH → G0.3 PASS → inner exit 1 (content defects) → `G8.3 FAIL "exit code 1 (want exactly 2)"` — a confusing false alarm about the harness after nothing but `make clean`. The clean-target comment (181-185) explains why verify itself survives, but neither it nor G8.3's failure message mentions that verify-selftest needs `make build` first to restore the record. Fix: have G8.3 detect the missing `.fdb_latexmk` and emit a SKIP/FAIL message naming `make build` as the remedy (or pre-check the record before running the control). |
| CR-05 | NOTE | scripts/verify-resume.sh:22-24 vs 1131-1137, 1161-1167 | Header contract says "The harness is READ-ONLY. It never writes inside docs/" — but `--write-baseline` writes `docs/verify/manifest.txt` (and, gated, `baseline-frozen.txt`), including staging temp files `$MANIFEST.regen.$$` as siblings in docs/verify/. The mode itself is well-guarded (observation-only keys, ALLOW_FROZEN_UPDATE, diff-first); the header just needs a "except --write-baseline, see below" qualifier so the read-only claim can't be cited against the code. |
| CR-06 | NOTE | scripts/verify-resume.sh:201, 175 | Assertion IDs are interpolated into regexes with unescaped `.`: `emit_rows` greps `^$1|` and `warn_owner` greps `^$1:` / seds `s/^$1://`. No live collision exists today (checked all ID pairs against WARN_OWNERS and row IDs), but the class is latent: e.g. `warn_owner G6.1` would grep-match `G6.13:unassigned`, and the sed then fails to strip, yielding owner `G6.13:unassigned`. Escape the dot or match with `-F` plus a delimiter-aware cut. |
| CR-07 | NOTE | scripts/verify-resume.sh:636-658, 1038-1057, 1307-1345 | The pdftotext-bbox XML parse (namespace-stripping `localname` + page/word min-max loop) is implemented three times (`p1_headroom`, the `--write-baseline` measurement, the G3 block). The G4.1/geom_hash single-implementation rule was applied deliberately (01-03 deviation 2); the same drift argument applies here — a poppler XML format change would need three coordinated edits. |
| CR-08 | NOTE | scripts/verify-resume.sh:1736-1763 | G6.13 pairs `[employers]`/`[titles]`/`[dates]` by index (`sed -n "${ROLE_IDX}p"`). If the frozen sections ever differ in length, `gate_line_of ""` matches the first BLANK line of gate.txt (`grep -Fx -- ""` matches empty lines), producing a bogus but confidently-worded adjacency measurement. WARN-tier only, so no gate impact; guard with `[ -n "$ROLE_TITLE" ]`. |
| CR-09 | NOTE | scripts/verify-resume.sh:864-970 | In `--selftest`, the G8 controls do not forward the caller's `--pdf`/`--manifest`/`--frozen` overrides to their inner runs (each forwards only the one input it mutates). `verify-resume.sh --selftest --pdf other.pdf` therefore snapshots `other.pdf` for G7.4 but validates the repo-default artifacts in G8.1/G8.2/G8.5. Documented usage (`make verify-selftest`, defaults only) is unaffected; either forward the overrides or document selftest as defaults-only. |
| CR-10 | NOTE | scripts/verify-resume.sh:1836; manifest | Two policy constants live outside the manifest: the G6.15 near-white luma threshold `0.9` (hardcoded in the python block) and `ROLE_BIND_WINDOW=3` (the latter is deliberate and documented at 1725-1730; the luma cutoff has no such note). A one-line comment or a manifest key would keep the "thresholds live in the manifest" rule uniform. |

## Review lenses — what was checked and found clean

- **Bash 3.2 portability:** no associative arrays, no `mapfile`/`readarray`, no `${v^^}`/`${v,,}`, no `**` globs, no `=~`; `printf '%*s'`, `${#var}`, `${var%%:*}` all 3.2-safe. Clean.
- **Quoting/word-splitting:** all variable expansions in test/grep/sed/cp arguments are quoted; grep fixed-string searches use `-F` with `--` where the pattern is data (gate_line_of:269, region_line_of:323). Clean apart from CR-06's regex-context IDs.
- **Command injection (security):** manifest/frozen values are consumed as data everywhere — grep `-F` patterns, python `argv` (never interpolated into heredoc bodies), awk `-v`. No `eval`, no `source` of data files, no data in printf FORMAT strings. `GEOMETRY_KEYS` is interpolated into an ERE by design (config-as-pattern); a broken value fails toward G4.1 FAIL, the safe direction. Clean.
- **Probe/scratch containment:** every control uses `mktemp -d` nested under `$WORK`; single guarded `rm -rf` in `cleanup()` proves non-empty + is-directory first; trap on EXIT (bash runs it on INT/TERM too). Probe unreachable from the committed artifact by directory + jobname; G7.4/G8.6 prove blast radius empirically. Clean.
- **`--write-baseline` abuse surface:** cannot silently weaken a BLOCKER gate — gated keys (PAGES, CEILING_PT, PAGE_SIZE, PAGE2_OPENS_WITH) are compared and loudly refused, never written; honesty freeze refused without `ALLOW_FROZEN_UPDATE=1`, diff printed first, only the derivable hash regenerated; mode runs after G0.3 so a stale PDF can't seed a baseline. Clean.
- **Exit vocabulary:** 0/1/2 consistent on every exit path traced (usage→0, arg errors→2, die2→2, census 0/1, selftest 0/1, write-baseline→0 by design, verify 0/1). `result()`/`warn()`/`info()` all `return 0` so no emitter can abort under pipefail. FAIL accumulation into BLOCKERS is subshell-safe at all call sites (rows read via file redirects, never pipes) — the only swallow channel found is CR-01.
- **Makefile:** all 71 recipe lines tab-indented; `.PHONY` covers every non-file target; `--skip-freshness` appears 0× in the Makefile (containment grep holds). CR-03 is the one gap.
- **Grep/awk pattern correctness:** `grep -Fxc` whole-line exact-count for the freeze (substring-collision-proof, verified against the Groupon/Flipkart title pair); `-Fowc` word-boundary for prohibited words ('Go' vs 'Goal'); the `.fdb_latexmk` awk anchors on `$1=="\"main.tex\""` avoiding the rule-line's 4th-field trap. All correct as documented.

## Methods

- Full read of all 1874 lines of `scripts/verify-resume.sh`, the 196-line Makefile, and both docs/verify data files.
- Cross-referenced 01-02-SUMMARY.md, 01-03-SUMMARY.md (deviations excluded from findings), and ROADMAP.md Phase 1 success criteria.
- Traced every exit path for the 0/1/2 vocabulary; traced BLOCKERS accumulation through all emit sites; checked each inline python heredoc for failure propagation (source of CR-01).
- Simulated failure modes: PDF basename containing `@`, post-`make clean` selftest, mtime-newer source under `make verify` — and **empirically confirmed CR-01** with two read-only harness runs against mutated manifest copies (broken `NONASCII_ALLOW` → G6.1-G6.4 absent; empty `CEILING_PT` → G3.* absent; BLOCKERS tally unaffected in both).
- Verified Makefile tab indentation (`grep -c $'^\t'` → 71) and `.PHONY` coverage against the target list.

---
_Reviewer: gsd-code-reviewer_
_Depth: deep_

## Resolution

**Resolved 2026-08-22.** All four actionable findings (1 BLOCKER, 3 WARNING) are fixed, and four of the six NOTEs are closed; two NOTEs are deliberately deferred with reasons below. Every fix was first reproduced FAILING against the reviewed commit (`12782d7`) and then re-run passing, so each entry below is an A/B, not a claim. `docs/` is byte-identical to `12782d7` (`git diff 12782d7 HEAD -- docs/` is empty) and the committed PDF still hashes to `123d02e3…60d1`.

| ID | Sev | Status | Fix commit | What changed |
|----|-----|--------|-----------|--------------|
| CR-01 | BLOCKER | **fixed** | `b0d0a6e` | New `die_group`: a measurement block that fails emits `RESULT <id> FAIL` first, echoes the block's stderr, then exits **2** ("cannot verify"). Exit status is now checked for every inlined python block — glyph census (both call sites), page-fill parse, invisible-text scan, geometry hash, baseline bbox measurement — and the `return 0` masks in `glyph_census`/`geom_hash` are gone, with their stderr captured so the python error can be named. `emit_rows` closes the same channel from the other side by failing on zero matching rows, and the baseline writer refuses to stage an empty threshold or freeze a partial geometry hash. `p1_headroom` feeds a message only, so it degrades to `unknown` rather than dying inside a command substitution. |
| CR-02 | WARNING | **fixed** | `9e1edd2` | The duplicated normalization became `arb_normalize`, which returns non-zero when its input is unusable **or its output is empty** — killing the empty-vs-empty `cmp` that read as agreement. Delimiter switched from `@` to `/`, which a basename can never contain, making the metacharacter escape set complete. Both `pdftotext -bbox` calls and both normalizations are exit-checked; any failure yields a new `ERROR <why>` verdict that the caller turns into `G0.3 FAIL` + exit 2. A broken arbiter can no longer answer FRESH. |
| CR-03 | WARNING | **fixed** (comment) | `4d68aa2` | Comment-only, as scoped: the prerequisite and every recipe line are untouched because build-when-missing is wanted. The text now states the real build-then-verify semantics, explains why mtime cannot be the freshness proof in either direction, and points at `bash $(VERIFY)` for gating the committed artifact with no chance of rebuilding it first. |
| CR-04 | WARNING | **fixed** | `60b96d3` | G8.3 now checks for an md5 record for the source basename *before* running the control. Absent record → `SKIP` naming `make build` as the remedy and explaining why L2 cannot substitute; `SKIP` leaves `BLOCKERS` untouched, so an unexercisable control is no longer a failing one. `--pdf` is forwarded to the inner run so the record the pre-check reads is exactly the one the inner run looks up, and both verdict messages now name the L1 record. The `clean` target documents the degradation beside the deletion that causes it. |
| CR-05 | NOTE | **fixed** | `78365ac` | Both over-broad header claims are qualified where they are made: no *asserting* mode writes (only the explicit `--write-baseline` does), and no mode rebuilds the artifact under test (`--selftest` and the L2 arbiter build scratch copies under their own jobnames). |
| CR-06 | NOTE | **deferred** | — | Escaping the `.` in `emit_rows`/`warn_owner` needs a per-call escape subshell at two sites, which is neither one line nor zero-risk. Re-measured while fixing: the cited collision does not occur, because both patterns are anchored on the delimiter that follows the ID (`^G6.1\|` cannot match `G6.15\|`, `^G6.1:` cannot match `G6.13:`). Latent, no live instance, no live path to one. |
| CR-07 | NOTE | **deferred** | — | Unifying the three bbox-XML parses is a cross-block refactor of production measurement code, not a one-line change, and all three now fail loudly via CR-01's exit-status checks rather than silently. Worth doing as its own change with its own verification, not inside a review-fix pass. |
| CR-08 | NOTE | **fixed** | `78365ac` | Empty `ROLE_TITLE`/`ROLE_DATE` now report unmeasurable like every other missing input, so `grep -Fx -- ""` can no longer match the first blank line of the extraction and produce a confident adjacency measurement against line 1. |
| CR-09 | NOTE | **fixed** (documented) | `78365ac`, `60b96d3` | `--selftest` is documented as running against the default inputs, naming exactly which overrides are not forwarded. G8.3 additionally forwards `--pdf` because its pre-check and its inner run must agree on one record. Full forwarding remains a design change, not a note-level fix. |
| CR-10 | NOTE | **fixed** | `78365ac` | The near-white luma cutoff is marked as a deliberate local constant, the same way `ROLE_BIND_WINDOW` is. |

### A/B evidence per finding

| Finding | Before (at `12782d7`) | After |
|---|---|---|
| CR-01, probe A: `--manifest` with `NONASCII_ALLOW=U+2013,2019` | **exit 1**, **0** `RESULT G6.[1-4]` lines, same 5 known blockers reported — the group vanished | **exit 2**, `RESULT G6.1 FAIL "the glyph census (G6.1-G6.4) assertion group could NOT RUN … ValueError: invalid literal for int() with base 16: 'U+2013'"`, traceback echoed |
| CR-01, probe B: `--manifest` with `CEILING_PT=` | **exit 1**, **0** `RESULT G3.*` lines | **exit 2**, `RESULT G3.1 FAIL "… could NOT RUN … ValueError: could not convert string to float: ''"` |
| CR-01, zero-row channel: freeze with an emptied `[titles]` | G5.2 silently absent | **exit 2**, `RESULT G5.2 FAIL "no G5.2 row was produced …"` |
| CR-02: `docs/transcript.pdf` (a different document) copied to `a@b.pdf` | **exit 1** with `RESULT G0.3 PASS "L2 scratch rebuild proves the PDF matches the current source"` — while the same bytes named `plain.pdf` were correctly refused at exit 2 | **exit 2**, `RESULT G0.3 FAIL … DIVERGES` |
| CR-02, no false negative: the CORRECT PDF copied to `ok@name.pdf` | `G0.3 PASS` | `G0.3 PASS` (unchanged — the legitimate path still works with `/` as the delimiter) |
| CR-02, `ERROR` path: `pdftotext` fault-injected on the scratch measurement | pipeline failed silently → FRESH | **exit 2**, `RESULT G0.3 FAIL "… arbiter could not measure: pdftotext -bbox could not measure the scratch rebuild"` |
| CR-03: `make -n -W docs/main.tex verify` (what-if, touches nothing) | printed the full build recipe, contradicting the comment | comment now describes exactly that |
| CR-04: `--selftest` with `docs/AshutoshTiwari.fdb_latexmk` moved aside | **exit 1**, `RESULT G8.3 FAIL "the staleness refusal is broken: exit code 1 (want exactly 2) … G0.3 FAIL x0"` | **exit 0**, `RESULT G8.3 SKIP "… run 'make build' to restore the record"` |
| CR-04: record present (normal) | `G8.3 PASS` | `G8.3 PASS`, now naming the L1 record `729318…44c4` |

### Verification on the final tree

| Check | Result |
|---|---|
| `make verify-selftest` | **exit 0** — 10/10 `G7.[1-4]` + `G8.[1-6]` PASS, 0 FAIL |
| `bash scripts/verify-resume.sh` | **exit 1** — exactly 5 BLOCKER FAILs (`G6.9` ×3, `G6.10`, `G6.12`), 0 non-named blockers |
| RESULT stream vs the pre-fix baseline | **byte-identical**, 83 lines — no assertion changed its verdict on the committed artifact |
| `--census` on a corrupted fixture | exit 1 with three `G6.(1\|2\|3)` FAILs (G8.4's path intact) |
| `--write-baseline` | exit 0, idempotent, wrote nothing |
| `--skip-freshness`, `--help`, unknown option | `G0.3 SKIP` / exit 0 / exit 2 — vocabulary unchanged |
| Regression sweep across all modes | 14/14 checks pass |
| `shellcheck scripts/verify-resume.sh` | 1 finding, the pre-existing `SC2329` on `cleanup` — no new findings |
| `LC_ALL=C grep -Fc -- '--skip-freshness'` | script 9, `Makefile` **0** (containment holds) |
| `git status --short` | empty |
| `docs/AshutoshTiwari.pdf` sha256 | `123d02e32403db204252419097e718cdb1d8dbd24e83658afa3f25f5b4ef60d1` — unchanged, and all of `docs/` is byte-identical to `12782d7` |

### Note on exit-code semantics

CR-01 and CR-02 both resolve toward **exit 2**, not exit 1, and that choice is load-bearing. An assertion group that failed to RUN, and a freshness arbiter that failed to MEASURE, are infrastructure failures: the document was never examined, so "the document is wrong" would be a fabrication and silence would be a false pass. This keeps the vocabulary the phase depends on intact — 0 every blocker passed, 1 the document is wrong, 2 the harness could not verify — and G8.3 continues to assert the 1-vs-2 distinction at script level.

