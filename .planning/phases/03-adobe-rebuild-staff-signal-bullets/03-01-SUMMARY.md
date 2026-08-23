---
phase: 03-adobe-rebuild-staff-signal-bullets
plan: 01
subsystem: testing
tags: [bash, shellcheck, pdftotext, regression-net, content-assertions, ats]

# Dependency graph
requires:
  - phase: 01-verification-harness
    provides: "scripts/verify-resume.sh (G0-G8, 83 RESULT lines / 39 IDs), the RESULT/exit-code contract, and the rule that an assertion never observed failing is not a gate"
  - phase: 02-page-1-budget-text-layer-defects
    provides: "scripts/verify-phase2-regressions.sh — the copied template: emit/die2/gcount/display_of/assert_* helper set, dual gate+squeezed streams, --gate-text fixture flag with its stdout disclaimer, mktemp -d scratch discipline"
provides:
  - "scripts/verify-phase3-regressions.sh — the standing P3.x content-regression net, 72 assertions across 7 groups, mode 755, shellcheck-clean, bash 3.2.57"
  - "A red-on-arrival FAIL census of 46 assertions, every one tagged with the plan that owns its fix (32 to 03-04, 13 to 03-05, 1 to 03-06) — the machine contract those plans drive to zero"
  - "assert_promoted — the first assertion anywhere in the repo that reads docs/verify/manifest.txt as DATA to cross-check rather than as configuration; gives the keyword-promotion rule its first machine backing"
  - "A fourth input stream (--manifest) on the regression-net scaffold, which is also what makes a promotion assertion negative-controllable"
  - "The T-1 fix: the copied whole-line helper's undocumented $4 dereference can no longer kill a run and report it as a document regression"
  - "A recorded Class E gap: the branch-conditional CUDA needle for D-08's triton-only-fallback branch, specified with its label, streams, owner (03-05 Task 3) and control obligation"
affects: [03-04, 03-05, 03-06, 03-07, 03-08]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Red-on-arrival acceptance oracle: the net is written before the content it gates, and every FAIL names its owning plan"
    - "Owner-tagged assertion labels (EXP-04d/03-05 form) so a FAIL census is auditable without opening a plan file"
    - "Region-scoped assertions: an anchor must be earned by the extracted line that owns it, not by the document"
    - "Conjunction assertions that report WHICH conjunct failed, proven by a per-conjunct control matrix"
    - "ID-delta negative controls: evidence is the assertion ID that flipped, not the process exit code"

key-files:
  created:
    - "scripts/verify-phase3-regressions.sh"
  modified: []

key-decisions:
  - "The EXP-02a lead anchors are an ANY-OF set, not all-of — an all-of reading is unsatisfiable in English and its own owner (03-04) could never turn it green"
  - "The governance Rust clause counts OCCURRENCES, not matching lines, so a wrapped double-Rust cannot false-fail"
  - "Retirement is asserted in the RENDERED form against the text layer and in the ASCII form against the source; the ASCII form against the text layer is vacuous"
  - "requirements-completed is deliberately EMPTY: this plan builds the acceptance oracle for its five requirements, it does not satisfy them"
  - "Seven SC2329 never-invoked findings resolved with scoped shellcheck directives naming each helper's future caller, not by deferring the helper set"

patterns-established:
  - "Owner-tagged FAIL census: every assertion label carries requirement AND owning plan, and the plan-level gate greps for unowned FAILs"
  - "Per-conjunct control matrix: a conjunction assertion is proven to be N independent tests by observing each conjunct name itself, plus one configuration where it passes"
  - "Invariance proof via git show into scratch: a comment-only commit proves it changed no verdict by diffing two ordinary temp files, never process substitution and never a fixed /tmp path"

requirements-completed: []

# Metrics
duration: 18 min
completed: 2026-08-23
---

# Phase 3 Plan 01: Phase-3 Content Regression Net Summary

**A 72-assertion standing P3.x net, red on arrival with 46 owner-tagged FAILs, giving Phase 3's locked literals, its lead-bullet voice, its keyword-promotion pairing and its absent-by-default draft rule their first machine backing — with every assertion class observed failing.**

## Performance

- **Duration:** 18 min
- **Started:** 2026-08-23T03:09:20Z
- **Completed:** 2026-08-23T03:28:07Z
- **Tasks:** 3
- **Files modified:** 1 created, 0 modified

## Accomplishments

- `scripts/verify-phase3-regressions.sh` exists: 648 lines, mode `-rwxr-xr-x`, **0 shellcheck findings**, runs under `/bin/bash` 3.2.57, exits **1** with a fully-owned census. Never writes inside `docs/`, never rebuilds.
- **Seven assertion groups / 72 assertions / 26 PASS / 46 FAIL / 0 unowned FAILs.** Owner split: **32 → 03-04**, **13 → 03-05**, **1 → 03-06**.
- **The promotion rule now has machine backing.** The harness's `G6.6` calls `warn` unconditionally with no branch on the count, so a commit that lands a `KEYWORDS_TARGET` keyword and forgets to promote it leaves `verify-resume.sh` at exit 0. `assert_promoted` is the first assertion in the repo to read `manifest.txt` as data to cross-check.
- **The source-side EXP-08 half catches a leak no existing gate can see.** A draft parked behind a `%` comment never renders, so every text-layer gate in the repo is blind to it. Proven live (Control 2b).
- **T-1 fixed at the copy.** The template's `assert_whole_line_once` documents 3 args and dereferences `$4`; under `/bin/bash` 3.2.57 with `set -u` a 3-arg call whose assertion fails aborts the script with no RESULT line, no `FAILURES` increment, every remaining assertion skipped — while exiting 1, which reads in a log as "the document is wrong". Now `${4:-…}`.
- **Every assertion class observed failing.** Classes A/B and the `achiev` needle by the arrival run against the real committed artifact; retention, draft-absence and the promotion conjunction by six crafted controls.
- **The D-08 fallback honesty rule has a named machine owner** rather than living in prose (Class E gap, recorded in code at the end of Group 5).

## Task Commits

1. **Task 1: scaffold, helpers, fourth input stream, retention group** — `5f231b3` (test)
2. **Task 2: six new-content assertion groups, red on arrival** — `bee3872` (test)
3. **Task 3: crafted negative controls per class** — `9a8d590` (test)

## Files Created/Modified

- `scripts/verify-phase3-regressions.sh` — the standing P3.x net. Header states what it asserts, why it is a separate file, the `RESULT P3.<n>` contract, the 0/1/2 exit vocabulary, the dual-stream rule, the bash-3.2 constraint, and a per-class NEGATIVE CONTROLS section.

## The FAIL census — the contract 03-04 / 03-05 / 03-06 shrink to zero

Measured on the committed artifact at `9a8d590`. Every needle matched the plan's `<locked_literals>` table exactly; **no needle's measured count differed** (verified needle-by-needle before Task 1 was written).

| ID | Owner tag | Needle / clause | Status |
|---|---|---|---|
| P3.1 | EXP-02c/03-01 | `Falcon-40B` (squeezed) | PASS |
| P3.2 | EXP-02c/03-01 | `Llama 2 70B` | PASS |
| P3.3 | EXP-02c/03-01 | `SQS queue depth` | PASS |
| P3.4 | EXP-02c/03-01 | `Flash Attention` | PASS |
| P3.5 | EXP-02c/03-01 | `FSDP` (squeezed) | PASS |
| P3.6 | EXP-02c/03-01 | `Rust` (squeezed) | PASS |
| P3.7 | EXP-02c/03-01 | `fault isolation across clusters` | PASS |
| P3.8 | EXP-02c/03-01 | `backpressure-aware scheduling` | PASS |
| P3.9 | EXP-02c/03-01 | `sustained low P99` | PASS |
| P3.10 | EXP-02c/03-01 | `18M+` (squeezed) | PASS |
| P3.11 | EXP-02c/03-01 | `4Bn rows` | PASS |
| P3.12 | EXP-02c/03-01 | `10K QPS` | PASS |
| P3.13 | EXP-02c/03-01 | `first workflow at Flipkart` | PASS |
| P3.14 | EXP-02c/03-01 | `validations` (squeezed) | PASS |
| P3.15 | EXP-02c/03-01 | `Falcon-40B` (raw lines) | PASS |
| P3.16 | EXP-02c/03-01 | `FSDP` (raw lines) | PASS |
| P3.17 | EXP-02c/03-01 | `Rust` (raw lines) | PASS |
| P3.18 | EXP-02c/03-01 | `18M+` (raw lines) | PASS |
| P3.19 | EXP-02c/03-01 | `validations` (raw lines) | PASS |
| P3.20 | EXP-02c/03-01 | `millions every day` — squeezed ONLY (×0 raw, ×1 squeezed) | PASS |
| P3.21 | EXP-02a/03-04 | lead-line anchor set, any-of, case-insensitive, scoped to gate line 11 | FAIL |
| P3.22 | EXP-02b/03-04 | `Training-Data Governance` | FAIL |
| P3.23 | EXP-02b/03-04 | `27,135` | FAIL |
| P3.24 | EXP-02b/03-04 | `claim/receipt` | FAIL |
| P3.25 | EXP-02b/03-04 | `immutable S3 evidence layouts` | FAIL |
| P3.26 | EXP-02b/03-04 | `9.7k-line` | FAIL |
| P3.27 | EXP-02b/03-04 | `lineage` | FAIL |
| P3.28 | EXP-02b/03-04 | `Rust` occurrences ≥ 2 (is 1) | FAIL |
| P3.29 | EXP-02b/03-04 | `throughput` absent from governance region | FAIL (unmeasurable) |
| P3.30 | EXP-02b/03-04 | `latency` absent from governance region | FAIL (unmeasurable) |
| P3.31 | EXP-02b/03-04 | `speedup` absent from governance region | FAIL (unmeasurable) |
| P3.32 | EXP-02b/03-04 | `faster` absent from governance region | FAIL (unmeasurable) |
| P3.33 | EXP-02b/03-04 | `images/sec` absent from governance region | FAIL (unmeasurable) |
| P3.34 | D-04/03-04 | `exponential backoff` | FAIL |
| P3.35 | D-04/03-04 | `full jitter` | FAIL |
| P3.36 | D-04/03-04 | `concurrency-safe S3 checkpoint` | FAIL |
| P3.37 | D-04/03-04 | `lease/TTL heartbeat` | FAIL |
| P3.38 | D-04/03-04 | `DLQ` | FAIL |
| P3.39 | D-04/03-04 | `circuit breaker` | FAIL |
| P3.40 | D-04/03-04 | `idempotent re-run` | FAIL |
| P3.41 | EXP-03a/03-05 | `torch.compile(mode="max-autotune")` | FAIL |
| P3.42 | EXP-03b/03-05 | promotion pairing: `torch.compile` | FAIL (conjunct 1) |
| P3.43 | EXP-03b/03-04 | promotion pairing: `A100` | FAIL (conjunct 1) |
| P3.44 | EXP-03b/03-04 | promotion pairing: `H100` | FAIL (conjunct 1) |
| P3.45 | EXP-03b/03-05 | promotion pairing: `Triton` | FAIL (conjunct 1) |
| P3.46 | EXP-04a/03-05 | `10–50` absent (raw, U+2013) | FAIL |
| P3.47 | EXP-04a/03-05 | `10–50` absent (squeezed, U+2013) | FAIL |
| P3.48 | EXP-04a/03-05 | `3–8K images/sec on 32 GPUs` absent (squeezed) | FAIL |
| P3.49 | EXP-04a/03-05 | `10--50` absent from `docs/main.tex` | FAIL |
| P3.50 | EXP-04a/03-05 | `3--8K` absent from `docs/main.tex` | FAIL |
| P3.51 | EXP-04d/03-05 | `achiev` absent from `docs/main.tex`, case-insensitive | FAIL |
| P3.52 | EXP-04d/03-05 | `achiev` absent from squeezed, case-insensitive | FAIL |
| P3.53 | EXP-04b/03-05 | `1.09M` | FAIL |
| P3.54 | EXP-04b/03-05 | `8×A100` | FAIL |
| P3.55 | EXP-04b/03-05 | `16 fractional-GPU actors` | FAIL |
| P3.56 | EXP-04b/03-04 | `24×A100-40GB` | FAIL |
| P3.57 | EXP-04b/03-04 | `9 model queues` | FAIL |
| P3.58 | EXP-04b/03-04 | `64 H100s` | FAIL |
| P3.59 | EXP-04b/03-04 | `202.6M-row` | FAIL |
| P3.60 | EXP-04b/03-04 | `24.8M` | FAIL |
| P3.61 | EXP-04b/03-04 | `~700M` | FAIL |
| P3.62 | EXP-04b/03-04 | `35–38M` | FAIL |
| P3.63 | EXP-04b/03-04 | `40-node` | FAIL |
| P3.64 | EXP-04b/03-04 | `A100` (raw lines) | FAIL |
| P3.65 | EXP-04b/03-04 | `H100` (raw lines) | FAIL |
| P3.66 | EXP-07a/03-06 | `manual deploys` | FAIL |
| P3.67 | EXP-08a/03-07 | `AssumeRole` absent from source | PASS |
| P3.68 | EXP-08a/03-07 | `AssumeRole` absent from text layer | PASS |
| P3.69 | EXP-08a/03-07 | `6-week` absent from source | PASS |
| P3.70 | EXP-08a/03-07 | `6-week` absent from text layer | PASS |
| P3.71 | EXP-08a/03-07 | `mentored` absent from source | PASS |
| P3.72 | EXP-08a/03-07 | `mentored` absent from text layer | PASS |

**Rollup:** `EXP-02c/03-01` 20 PASS · `EXP-02a/03-04` 1 FAIL · `EXP-02b/03-04` 12 FAIL · `D-04/03-04` 7 FAIL · `EXP-03a/03-05` 1 FAIL · `EXP-03b/03-04` 2 FAIL · `EXP-03b/03-05` 2 FAIL · `EXP-04a/03-05` 5 FAIL · `EXP-04b/03-04` 10 FAIL · `EXP-04b/03-05` 3 FAIL · `EXP-04d/03-05` 2 FAIL · `EXP-07a/03-06` 1 FAIL · `EXP-08a/03-07` 6 PASS.

**Note for 03-04:** P3.29–P3.33 currently FAIL as **unmeasurable**, not as violations — the governance topic does not exist, so its rendered region cannot be sliced. They become real framing assertions the moment `Training-Data Governance` extracts.

## Negative controls — the six proven command shapes

All six ran under `mktemp -d`. Nothing was written into the working tree: `git status --porcelain docs/` empty and both sibling scripts byte-unchanged after every run. Evidence is the **assertion ID that flipped**, not the process exit code — the net already exits 1 by design, so an exit code alone would prove nothing.

| # | Class | Command shape | Exit | Newly-FAILING IDs |
|---|---|---|---|---|
| 1a | retention, multi-word/squeezed | `sed 's/Flash Attention//g' raw.txt > fx` → `--gate-text fx` | 1 | **P3.4** (46→47 FAILs) |
| 1b | retention, short token/raw | `sed 's/FSDP//g' raw.txt > fx` → `--gate-text fx` | 1 | **P3.5 + P3.16** (46→48) |
| 2a | EXP-08 text-layer half | append `AssumeRole 6-week mentored` to `raw.txt` → `--gate-text fx` | 1 | **P3.68, P3.70, P3.72** (46→49) |
| 2b | EXP-08 **source** half | `cp docs/main.tex $SC/src/main.tex`; append `% draft … AssumeRole` → `--tex` | 1 | **P3.67** (46→47) |
| 3a | promotion conjunct 3 | `--gate-text kwfx --manifest manifest-A` (in REQUIRED, suffixed TARGET left behind) | 1 | **P3.42 flips to "conjunct 3 FAILS"** |
| 3b | promotion conjunct 1 | `--manifest manifest-B` (moved correctly, keyword absent from text) | 1 | **P3.42 reports "conjunct 1 FAILS"** |

Controls 1a, 1b, 2a and 3a printed the `does NOT certify the committed artifact` disclaimer; 2b and 3b run against the real PDF so no disclaimer is expected or printed.

**Control 1b also proves the fixture propagation claim:** `--gate-text` replaces the RAW stream from which both derived streams are built, so a single deletion flipped both the squeezed (P3.5) and the raw-line (P3.16) assertion.

**Control 2b kept the basename `main.tex`,** so the freshness record is still found by source filename; a renamed copy would escalate to the L2 rebuild arbiter and silently disarm the staleness control (Phase 1's `G8.3` finding).

### The promotion conjunct matrix (Control 3, expanded)

A conjunction is only proven to be three independent tests if each conjunct can be observed naming itself — and only proven not to be stuck-red if some configuration passes. All five rows are P3.42:

| Input configuration | P3.42 verdict |
|---|---|
| real text layer + real manifest (baseline) | FAIL — conjunct 1 |
| real text layer + manifest-B (moved correctly) | FAIL — conjunct 1 |
| kw fixture + real manifest (keyword only in TARGET) | FAIL — conjunct 2 |
| kw fixture + manifest-A (suffixed TARGET entry left behind) | FAIL — conjunct 3 |
| kw fixture + manifest-B (fully promoted) | **PASS** |

The conjunct-2 and PASS rows are extra evidence beyond the plan's six controls, recorded because a conjunction that can only ever report one conjunct is one test wearing three names, and an assertion that can never pass is as useless as one that can never fail.

### Invariance proof (Task 3 changed no verdict)

Task 3's diff is **53 insertions, 0 non-comment lines**. Baseline re-derived in scratch via `git show HEAD:scripts/verify-phase3-regressions.sh > "$SC/prev.sh"`, both versions run, each FAIL slice written to its own ordinary temp file, then `diff`:

- `prev.fail` md5 `7e207ba539c9c87ed78bb90d06e67ead` == `now.fail` md5 `7e207ba539c9c87ed78bb90d06e67ead`
- the **full** census (not just the FAIL slice) is byte-identical
- two ordinary files under `mktemp -d` — **no** `diff <(…) <(…)` process substitution, and no fixed `/tmp` path an earlier task wrote

## Decisions Made

1. **The EXP-02a lead anchors are an ANY-OF set, not all-of.** The plan's Task 2 text reads "match the three anchors against it", which admits an all-of reading; three independent sources say any-of — `03-04-PLAN.md` Task 1 ("MUST contain **at least one of**"), `03-RESEARCH.md`'s EXP-02a validation row ("must match **one of** the locked lead anchors"), and `03-PATTERNS.md` §3.1 (a regex **alternation**). An all-of reading is also unsatisfiable in ordinary English — `fault-tolerant` and `fault-tolerance` are morphological variants of one word — so 03-04 could never turn its own assertion green, and 03-04's gate (`grep -E 'EXP-02a' | grep -c FAIL | grep -qx 0`) would be unreachable. Implemented as one assertion whose verdict is any-of; all three anchors are still matched and the PASS message names which ones hit.
2. **The governance `Rust` clause counts OCCURRENCES, not matching lines.** `gcount -Fc` counts lines, so a governance clause that happened to render its `Rust` on the same wrapped line as another carrier would read as 1 and FAIL for a fabricated reason. The `-1` unmeasurable sentinel is still taken from `gcount`, because `grep -Fo` on an unreadable file prints nothing and would otherwise be indistinguishable from a genuine zero.
3. **The governance framing tokens stay CASE-SENSITIVE.** Case-insensitive would be strictly stronger, but the plan states `achiev` is "the net's **only** case-insensitive absence needle" and both the plan and `03-04-PLAN.md`:138 list the five framing tokens in lowercase prose form. Honoured the stated property; `assert_absent_i` is called by `achiev` alone.
4. **`requirements-completed` is deliberately EMPTY** despite the plan's `requirements: [EXP-02, EXP-03, EXP-04, EXP-07, EXP-08]`, and `requirements.mark-complete` was **not** run. This plan builds those requirements' acceptance oracle; it does not satisfy them, and the oracle is red. Ticking them while 46 assertions FAIL would misreport the phase. This follows the recorded Phase-2 precedent ("a requirement shared across two plans completes when the last plan lands, not the first") and 03-08 Task 3's explicit ownership of the EXP-02 tick.
5. **Seven `SC2329` never-invoked findings resolved with scoped directives, not by deferring the helper set.** Task 1's criteria demand both the full helper set AND zero shellcheck findings; shellcheck 0.11.0 flags a defined-but-not-yet-called function. Each directive is preceded by a comment naming its future caller, and four were removed in Task 2 as their callers landed. Three remain, each with an accurate reason: `assert_present_i` (the lead clause needs any-of semantics, so it counts with `gcount` directly), `region_line_of` (the governance slice anchors on a topic line that *contains* its needle rather than equalling it), and `assert_whole_line_once` (kept so the T-1 fix travels with the copy — T-1 is invisible until the day it fires). The harness itself carries one such note, so this is not a new class of finding for the repo.
6. **The unused `[employers]` extraction was dropped from the copy.** `--frozen` and its precondition are kept (the flag is the arity-guard model the plan cites, and a broken freeze should report "cannot verify"), but no P3 assertion reads the freeze — nothing in D-01…D-15 changes a frozen date, title, employer or geometry value — so carrying the template's `awk` extraction would have been dead data prep. A comment records why the stream is precondition-only.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Task 1's two acceptance criteria were unsatisfiable together without a shellcheck directive**

- **Found during:** Task 1
- **Issue:** Criterion 1 requires zero `shellcheck -f gcc` findings; the `<done>` clause and the action require the *full* helper set present at Task 1, including `assert_promoted` and `region_first_nonempty` whose callers land in Task 2. shellcheck 0.11.0 emits `SC2329` (never invoked) for each, so the two requirements collide — 7 findings.
- **Fix:** Scoped `# shellcheck disable=SC2329` per function, each preceded by a comment naming the caller that will land. Four were removed in Task 2 when their callers arrived; three remain with accurate stated reasons (Decision 5).
- **Files modified:** `scripts/verify-phase3-regressions.sh`
- **Verification:** `shellcheck -f gcc` → 0 findings at all three commits; the four directives whose callers landed are gone at `bee3872`.
- **Committed in:** `5f231b3` (added), `bee3872` (four removed)

**2. [Rule 1 - Bug] Task 1 criterion 3 (`grep -c 'P2\.'` returns 0) was tripped by the header's own prose**

- **Found during:** Task 1 verification
- **Issue:** The header explained the ID-collision property using the literal Phase-2 prefix, which made the T-2 mechanical check return 1. The check exists to catch a copy that renamed the counter but forgot the `emit` printf or the failed-ID append; my prose was a false positive against its own gate.
- **Fix:** Reworded to "the Phase-2 net's own sequential IDs", and added a line to the header stating that nothing in the file may contain that literal *because* the plan gates on a whole-file grep for it — so the constraint is now self-documenting rather than a trap for the next editor.
- **Files modified:** `scripts/verify-phase3-regressions.sh`
- **Verification:** `grep -c 'P2\.' scripts/verify-phase3-regressions.sh` → 0
- **Committed in:** `5f231b3`

**3. [Rule 1 - Bug] Control 3's evidence metric had to change: an ID delta cannot see a conjunct change**

- **Found during:** Task 3
- **Issue:** Controls 1 and 2 are evidenced by which assertion ID newly FAILs. P3.42 is *already* FAIL at baseline (on conjunct 1), so manifests A and B produce a **zero** ID delta — the plan's "require conjunct 3 to FAIL" is invisible to that metric. Worse, conjunct 3 is only *reportable* when conjunct 1 holds, so manifest A alone would still have reported conjunct 1: the control needs `--gate-text` to land the keyword as well as `--manifest` to vary the tiers.
- **Fix:** Paired manifest A with a keyword text-layer fixture, and switched Control 3's evidence from the ID delta to the **conjunct the FAIL names**. Added the conjunct-2 row and a fully-promoted PASS row to the matrix, so all three conjuncts are observed naming themselves and the assertion is proven neither stuck-red nor stuck-green.
- **Files modified:** none (evidence method, not code)
- **Verification:** the five-row conjunct matrix above, all P3.42
- **Committed in:** `9a8d590` (the header's NEGATIVE CONTROLS section records the paired `--gate-text --manifest` shape)

---

**Total deviations:** 3 auto-fixed (1 blocking, 2 bugs)
**Impact on plan:** All three were needed to make the plan's own acceptance criteria satisfiable and its controls meaningful. No assertion was weakened, no criterion was skipped, and no scope was added — the conjunct-2 and PASS matrix rows are extra evidence for an assertion the plan already required.

## Issues Encountered

- **The plan's Group 6 says "four `assert_absent`" but enumerates five needles** (`10–50`@raw, `10–50`@squeezed, `3–8K images/sec on 32 GPUs`@squeezed, plus source forms `10--50` and `3--8K`). Shipped **five**, which is what the plan's own acceptance criteria require in two separate bullets. Resolved as a miscount in the prose, not a scope change.
- **`comm` mis-reported the first control-delta run** because the ID lists were `sort -V`-ordered; `comm` requires plain lexicographic input. Re-derived every delta with `LC_ALL=C sort`. No verdict was affected — only the first printed delta, which was discarded.

## User Setup Required

None — no external service configuration required. This plan installs zero npm/PyPI/crates/brew packages (threat register `T-03-SC`), so no package-legitimacy checkpoint was needed.

## Next Phase Readiness

- **03-02 is unblocked.** The net is the acceptance oracle every later plan in Phase 3 verifies against, and it is in place before any content changes.
- **The contract is explicit:** 03-04 owns 32 FAILs, 03-05 owns 13, 03-06 owns 1. Zero FAILs are unowned, so `grep -E '^RESULT P3\.[0-9]+ +FAIL' | grep -vcE '/03-0[456] '` → 0 is a standing gate.
- **03-04 note:** P3.29–P3.33 read "unmeasurable" today because the governance region cannot be sliced until `Training-Data Governance` extracts. Landing the topic converts them from unmeasurable to real framing assertions — expect the message text to change, not just the status.
- **03-05 owes two things beyond its content:** the Class E `CUDA` needle on the `triton-only-fallback` branch (label `EXP-03c/03-05 fallback bridge names no CUDA graphs`, streams `$SQUEEZED` + `$TEX`, appended in the SAME commit as the fallback wording), and its crafted control — insert `CUDA` into a scratch text layer, `--gate-text`, require exit 1. On `cudagraphs-confirmed` it must record in its SUMMARY that the needle was deliberately *not* added. The gap is recorded in code at the end of Group 5.
- **03-08 owes the `make verify-regressions` wiring** (its Task 2) and the requirement ticks; this plan added no `Makefile` target, so the net is invoked directly for now.
- **No blockers.** `bash scripts/verify-resume.sh` exit 0 throughout; `bash scripts/verify-phase2-regressions.sh` 27 anchored `^RESULT P2\..*PASS` lines throughout; `docs/` untouched; both sibling scripts byte-unchanged; no build was run and `make clean` was never invoked.

## Self-Check: PASSED

- `scripts/verify-phase3-regressions.sh` — FOUND on disk, mode `-rwxr-xr-x`
- `5f231b3` — FOUND in `git log`
- `bee3872` — FOUND in `git log`
- `9a8d590` — FOUND in `git log`
- Plan `<verification>` re-run at `9a8d590`: `shellcheck -f gcc` 0 findings · `/bin/bash` net exit 1 · `verify-resume.sh` exit 0 · `verify-phase2-regressions.sh` exit 0 with 27 anchored PASS
- All 11 Task-1, all 10 Task-2 and all 8 Task-3 acceptance criteria re-verified; all three tasks' `<automated>` gates re-run verbatim and exited 0

---
*Phase: 03-adobe-rebuild-staff-signal-bullets*
*Completed: 2026-08-23*
