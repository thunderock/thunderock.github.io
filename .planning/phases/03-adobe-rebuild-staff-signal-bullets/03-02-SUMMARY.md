---
phase: 03-adobe-rebuild-staff-signal-bullets
plan: 02
subsystem: testing
tags: [make, gnu-make-3.81, regression-net, verification-harness, warn-ownership, manifest, github-pages]

# Dependency graph
requires:
  - phase: 02-page-1-budget-text-layer-defects
    provides: "scripts/verify-phase2-regressions.sh — the 27-assertion content net this plan makes reachable; the locked Phase-2 D-05/D-06 folded descriptors it protects"
  - phase: 01-verification-harness
    provides: "scripts/verify-resume.sh + docs/verify/manifest.txt WARN_OWNERS/warn_owner mechanism; the Makefile verification section shape and its freshness-waiver prohibition"
provides:
  - "make verify-regressions — standalone invoker for the Phase-2 content net (closes audit IG-01)"
  - "make verify runs the net FIRST, above the page/geometry harness"
  - "REGRESS Makefile variable + .PHONY entry + header target-index line"
  - "G6.13 role-block WARN owned by Phase 3 (all five lines read `(owner: Phase 3)`) — closes audit IG-03 / WR-01"
  - "STATE.md canonical record of the net, its C++ graph algorithms anchor, both invocation surfaces and the gating rule (closes audit IG-02)"
  - "STATE.md Phase-6 site-sync obligation covering index.html:196 and index.html:207-225"
affects: [03-04, 03-05, 03-06, "phase-5-skills", "phase-6-palette-and-site-ship", "any-plan-editing-docs/main.tex"]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Prerequisite-free verification target: a net whose contract is to read the artifact on disk gets NO $(PDF) prerequisite"
    - "Waiver flags are described, never named, inside the Makefile — so a grep for them stays 0"
    - "WARN ownership is claimed by a one-line manifest edit, never by a script change"

key-files:
  created:
    - .planning/phases/03-adobe-rebuild-staff-signal-bullets/03-02-SUMMARY.md
  modified:
    - Makefile
    - docs/verify/manifest.txt
    - .planning/STATE.md

key-decisions:
  - "The net is chained FIRST in `verify`, not second and not as a prerequisite: Make 3.81 aborts a recipe at its first failing line, so a net chained second never runs while the harness is red — the normal mid-edit state"
  - "verify-regressions carries NO $(PDF) prerequisite; that is the majority pattern in the section (verify-selftest and verify-baseline carry none either), and a prerequisite would convert the net into build-then-verify"
  - "Neither waiver flag is named in the Makefile even inside a comment — the file's established idiom is to describe them and point at the script"
  - "G6.13 claimed as a WARN only: the gate is NOT promoted and ROLE_BIND_WINDOW stays a local constant at scripts/verify-resume.sh:1936"
  - "requirements-completed is deliberately EMPTY — this plan builds no Adobe content; 03-08 Task 3 owns the EXP-02 tick"

patterns-established:
  - "Prerequisite-free net target: majority pattern confirmed against verify-selftest / verify-baseline, documented in-file with the build-then-verify rationale"
  - "Describe-never-name for waiver flags: `grep -c -- '--gate-text\\|--skip-freshness' Makefile` stays 0 by construction, so the assertion is mechanical"
  - "One-line WARN ownership claim: WARN_OWNERS numeric token -> `(owner: Phase N)`, asserted BEHAVIOURALLY (all five lines must read it) rather than by grepping the manifest string"
  - "Site-defect handoff verifies its own premise at write time: both retired figures were re-counted in index.html as the record was written, so the handoff cannot be stale on arrival"

requirements-completed: []

# Metrics
duration: 8min
completed: 2026-08-23
---

# Phase 3 Plan 02: Harness Wiring & WARN Ownership Summary

**The 27-assertion Phase-2 content net went from zero invokers to `make verify-regressions` plus the first recipe line of `make verify`, the G6.13 role-block WARN is now owned by Phase 3, and STATE.md carries both the net's canonical record and a Phase-6 site-sync obligation.**

## Performance

- **Duration:** 8 min
- **Started:** 2026-08-23T03:33:00Z
- **Completed:** 2026-08-23T03:41:00Z
- **Tasks:** 2
- **Files modified:** 3 (+1 summary created)

## Accomplishments

- **IG-01 closed.** `scripts/verify-phase2-regressions.sh` had zero invokers — no make target, no CI. It now has two: a standalone `make verify-regressions`, and the first recipe line of `make verify`.
- **IG-03 closed.** One-line `WARN_OWNERS` edit (`G6.13:unassigned` → `G6.13:3`) makes all five role-block WARNs read `(owner: Phase 3)`. Zero `owner: unassigned` lines remain anywhere in the harness run.
- **IG-02 closed.** The net, its load-bearing `C++ graph algorithms` anchor, both new invocation surfaces, and the standing gating rule are now named on two canonical surfaces outside the phase directory: the Makefile header target index and `.planning/STATE.md`.
- **Phase 6 inherits one greppable obligation** covering both site defects — `index.html:196` (duplicates both figures this phase retires) and `index.html:207-225` (SITE-02), the latter previously recorded only in `.planning/REQUIREMENTS.md:49`.

## Task Commits

Each task was committed atomically:

1. **Task 1: Wire the Phase-2 net into make and claim the G6.13 WARN** — `6d58396` (build)
2. **Task 2: Record the net on a canonical surface and hand the site duplicate to Phase 6** — `bf0f8ea` (docs)

## Files Created/Modified

- `Makefile` — four coordinated edits: `REGRESS` variable beside `VERIFY` (:30), `verify-regressions` in the single-line `.PHONY` (:55), the new prerequisite-free target with its rationale comment (:198-213), `@bash $(REGRESS)` chained first in `verify` (:195, above `@bash $(VERIFY)` at :196), and the header target-index line (:12).
- `docs/verify/manifest.txt` — exactly one changed line (:60): `G6.13:unassigned` → `G6.13:3`.
- `.planning/STATE.md` — two `[Phase 3 / 03-02]` bullets appended to `### Decisions` plus one `[Phase 6]` pointer in `### Blockers/Concerns`. Additions only (4 insertions, 0 deletions).

## Verification Evidence

### `make -n verify` recipe lines, verbatim

```
bash scripts/verify-phase2-regressions.sh
bash scripts/verify-resume.sh
```

The net is first. Confirmed by the plan's own automated gate, which requires `make -n verify` to show `verify-phase2-regressions.sh` at all and the acceptance criterion to show it *before* `verify-resume.sh`.

### The five `G6.13` RESULT lines with the new owner

```
RESULT G6.13  WARN  role block 'ADOBE FIREFLY' split across non-adjacent blocks: employer line 9, title line 5, date line 7 -- line span 4 against a window of 3 (2 non-empty line(s) apart) (owner: Phase 3)
RESULT G6.13  WARN  role block 'SWIGGY' split across non-adjacent blocks: employer line 34, title line 30, date line 32 -- line span 4 against a window of 3 (2 non-empty line(s) apart) (owner: Phase 3)
RESULT G6.13  WARN  role block 'FLIPKART (a Walmart company)' split across non-adjacent blocks: employer line 53, title line 48, date line 50 -- line span 5 against a window of 3 (3 non-empty line(s) apart) (owner: Phase 3)
RESULT G6.13  WARN  role block 'GROUPON' split across non-adjacent blocks: employer line 68, title line 64, date line 66 -- line span 4 against a window of 3 (2 non-empty line(s) apart) (owner: Phase 3)
RESULT G6.13  WARN  role block 'NETSPEED SYSTEMS (Acquired by Intel)' split across non-adjacent blocks: employer line 77, title line 73, date line 75 -- line span 4 against a window of 3 (2 non-empty line(s) apart) (owner: Phase 3)
```

`grep -c 'owner: unassigned'` over the whole harness run returns **0**. Note WR-01's FLIPKART span of 5 is unchanged — this plan claims the WARN, it does not fix the extraction wobble.

### Gate results

| Check | Result |
|---|---|
| `make verify-regressions` | exit 0, **27** anchored `^RESULT P2\..*PASS` lines (28 lines contain the word PASS — the `>> PASS:` summary is the 28th, exactly as the plan's verification block warns) |
| `make -n verify` net-first | ✅ net above harness |
| `grep -c 'verify-regressions' Makefile` | **4** (header index :12, `.PHONY` :55, `verify` comment :193, target+doc-comment :212) |
| `grep -c -- '--gate-text\|--skip-freshness' Makefile` | **0** |
| `make help` lists the target | ✅ with its doc comment (shifted right 2 cols by the known `%-16s` cosmetic — format string deliberately NOT widened) |
| `bash scripts/verify-resume.sh` | exit **0**, five `(owner: Phase 3)` |
| `grep -c 'G6.13:unassigned'` / `'G6.13:3'` | **0** / **1** |
| `grep -c 'ROLE_BIND_WINDOW' docs/verify/manifest.txt` | **0** |
| `git diff --stat docs/verify/manifest.txt` | 1 file changed, 1 insertion, 1 deletion |
| `git status --porcelain` on `baseline-frozen.txt`, `main.tex`, `.pdf` | empty |
| `make verify-selftest` | exit 0, **10** G7/G8 PASS, **0** SKIP |
| `git diff --numstat .planning/STATE.md` | `4 0` — additions only |
| `make verify` (corroboration only) | exit 0, `>> PASS: 0 blocking failures`; `git status --porcelain docs/` empty afterwards, so nothing was rebuilt |

`PROBE_LINES` stays 5: `RESULT G7.2 PASS the probe PDF is 3 page(s), above the manifest PAGES=2 budget, so the +5 probe is a genuine overflow`. This plan changed no content, so the 7.0pt G7.2 margin is untouched.

### Sibling plan 03-01 left alone

`scripts/verify-phase3-regressions.sh` is byte-untouched by this plan and remains red on arrival by design: exit 1, **46** owned FAILs, **0** unowned (`grep -E '^RESULT P3\.[0-9]+ +FAIL' | grep -vcE '/03-0[456] '` → 0). It was not "fixed".

## Decisions Made

1. **The net runs first, chained, not as a prerequisite.** GNU Make 3.81 aborts a recipe at its first failing line, so a net chained *second* would never run whenever the harness is red — which is the normal state mid-edit, exactly when a content regression most needs reporting. The three rejected alternatives from research were all avoided: `verify: verify-regressions` as a prerequisite (same short-circuit, worse readability), chaining after `$(VERIFY)`, and any `-` prefix or `|| true`.
2. **No `$(PDF)` prerequisite on the new target.** The net's contract is to read whatever artifact is on disk and never rebuild; a prerequisite would convert it to build-then-verify, the same wart the Makefile's existing block documents on `verify`. This is the *majority* pattern in the section — `verify-selftest` and `verify-baseline` carry no prerequisite either.
3. **Waiver flags described, never named.** The pre-existing Makefile already had `grep -c -- '--gate-text\|--skip-freshness' Makefile` = 0 and achieves it by describing the flag ("named only inside the script") rather than spelling it. Both new comment blocks follow that idiom, so the acceptance assertion stays mechanical instead of depending on comment wording.
4. **`make verify` remains a convenience, not an oracle.** Recorded in both the Makefile comment and STATE.md: Make 3.81 collapses a recipe's exit 1 and exit 2 into its own exit 2, so `make verify` cannot distinguish "the document is wrong" from "cannot verify". The gating invocation stays the two scripts run directly.
5. **G6.13 claimed as a WARN only.** `ROLE_BIND_WINDOW` was deliberately NOT added to the manifest — per the 01-02 record, the commit that *promotes* `G6.13` to a BLOCKER is the commit that adds the key. Phase 3 claims ownership; it does not promote the gate. No other manifest key was touched (`PROBE_LINES`, `DIGIT_BULLET_FLOOR`, `LINE_PT`, `PAGES`, `CEILING_PT` all out of bounds; `KEYWORDS_*` promotion belongs to 03-04/03-05).
6. **`requirements-completed` is deliberately EMPTY** despite the plan's `requirements: [EXP-02, EXP-07]`, and `requirements mark-complete` was NOT run. This plan wires a harness and writes records; it lands no Adobe content and tightens no Swiggy/Flipkart bullet. EXP-02 is claimed by 03-01/03-02/03-03/03-04/03-08 and EXP-07 by 03-01/03-02/03-03/03-06/03-08 — per the recorded Phase-2 precedent (and 03-01's own decision) a shared requirement completes when the LAST plan lands, and **03-08 Task 3 owns the EXP-02 tick**.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Missing Critical] Added a fourth `verify-regressions` mention so the target is documented where a reader of `verify` will look**

- **Found during:** Task 1 (Makefile wiring), at acceptance-criterion check time
- **Issue:** The plan's criterion `grep -c 'verify-regressions' Makefile` returns 4 or more `(header index, .PHONY, target, doc comment)` returned **3**. The arithmetic gap is real and benign: the sanctioned analog shape at `:180-187` puts the target and its `## `-suffixed doc comment on the **same line**, so the four enumerated *items* occupy only three *lines*, and `grep -c` counts lines. Padding the count would have been dishonest; leaving it at 3 would have failed a stated criterion.
- **Fix:** Added the genuinely-missing cross-reference to `verify`'s own chaining comment — *"To run only the net, without building or gating the PDF, use `make verify-regressions`."* A reader of the `verify` recipe now learns the standalone entry point exists, which is real documentation value and also serves must_have truth #3 (the new make target named on a canonical surface).
- **Files modified:** `Makefile` (:193)
- **Verification:** `grep -c 'verify-regressions' Makefile` → 4; `grep -c -- '--gate-text\|--skip-freshness' Makefile` still 0; `make -n verify` recipe unchanged; `make verify-regressions` still exit 0 with 27 PASS
- **Committed in:** `6d58396` (Task 1 commit)

---

**Total deviations:** 1 auto-fixed (1 missing critical / documentation completeness)
**Impact on plan:** No scope creep — one comment sentence inside a file the plan already authorized editing. No recipe line, variable, target or manifest key was added beyond the plan's four+one edits.

## Issues Encountered

- **The header target-index column cannot accommodate the new name.** The other ten index lines align their `-` at column 27; `#   make ` (9 chars) + `verify-regressions` (18) already consumes all 27, so alignment is arithmetically impossible without reflowing every line. Used research's exact single-space text (`#   make verify-regressions - standing content-regression assertions (P2.x)`), which puts the dash at column 29 — a +2 shift, measured. That is the same +2 the plan's cosmetic-awareness note predicts for `make help`'s `%-16s` against an 18-char name, and per that instruction neither the index nor the format string was reflowed or widened. Both shifts confirmed present and harmless in the rendered output.
- **`make verify-selftest`'s G7.4 reported "3 path(s) were already modified before the probe ran."** Expected, not a defect: that assertion is a BEFORE/AFTER delta plus tracked-input checksums by design (Phase 1 decision, STATE.md), precisely so it does not false-positive on a working tree with edits in progress. G8.6 independently confirmed `docs/verify/manifest.txt` was checksum-identical after the controls ran, so the manifest edit was not disturbed.
- **`--skip-freshness` does appear in `make verify-selftest` output** (G8.2's message). That is the script narrating its own negative control; the acceptance criterion greps the **Makefile**, which is 0. No conflict.

## User Setup Required

None — no external service configuration required. No packages were installed (T-03-SC: zero packages this phase).

## Next Phase Readiness

**Ready.** All three wiring gaps the milestone audit assigned to Phase 3 are closed *before* any content is touched, which was the point of running this plan in wave 1:

- Content plans 03-04 / 03-05 / 03-06 now edit `docs/main.tex` under a net that actually runs. `make verify-regressions` is the fast content-only check; `make verify` gives both in one command with the net reported first.
- **The gating invocation is unchanged and remains `bash scripts/verify-resume.sh && bash scripts/verify-phase2-regressions.sh`.** Do not substitute `make verify` in a plan gate — it collapses exit 1 and 2.
- **The D-08 re-compression lever is now protected.** If a later plan shortens the folded Groupon/NetSpeed descriptors, the net will name the specific lost literal — including the `C++ graph algorithms` anchor ROADMAP Phase 5 criterion 4 rests on — instead of that loss surfacing as a silent diff three phases later.
- **`G6.13` is Phase 3's WARN.** Owning it does not oblige fixing it. WR-01's measurement note still stands: any Adobe growth of ≥1 rendered line resolves the FLIPKART employer-order flip as a y-position side effect, which is an accident and not a property — 03-04/03-05 should re-measure all five blocks at end-state rather than assume it.
- **Phase 5 inherits nothing new.** `ROLE_BIND_WINDOW` remains a local constant; promoting `G6.13` to a BLOCKER is still the job of whichever commit adds the manifest key.
- **Phase 6 inherits a concrete, greppable site-sync obligation** in both `### Decisions` and `### Blockers/Concerns`: `index.html:196` and `index.html:207-225`, both live behind `.github/workflows/jekyll.yml` on push to `master`. Both retired figures were re-counted in `index.html` at write time (count 1 each), so the record was true when written rather than inherited from research.

**Concerns carried forward:** none new. The `.planning/` prose that still contains the retired figures (`ROADMAP.md`, `REQUIREMENTS.md`, `PROJECT.md`, research corpus) was deliberately NOT cleaned — verified still non-zero — since it is the record of what was retired and why.

---
*Phase: 03-adobe-rebuild-staff-signal-bullets*
*Completed: 2026-08-23*

## Self-Check: PASSED

Every file, commit hash and line-number claim in this summary was re-verified against the working tree after it was written:

- **Files:** all four claimed paths exist (`03-02-SUMMARY.md`, `Makefile`, `docs/verify/manifest.txt`, `.planning/STATE.md`).
- **Commits:** `6d58396` and `bf0f8ea` both found in `git log --all`.
- **Line numbers:** `Makefile` :12, :30, :55, :193, :195, :196, :198, :212, :213 each verified by `sed -n` against the content claimed; `docs/verify/manifest.txt` :60 verified; `ROLE_BIND_WINDOW` confirmed at `scripts/verify-resume.sh:1936`; `SITE-02` confirmed at `.planning/REQUIREMENTS.md:49`.
- **Two claims were corrected during self-check** rather than left wrong: the chained recipe line is :195 (not :194) and the new target block spans :198-213 (not :196-213); and the header index dash was measured at column 29 (+2) instead of being described only as "not 27".
- **Counts:** `grep -c 'verify-regressions' Makefile` = 4, waiver-flag grep = 0, `G6.13:3` = 1, `ROLE_BIND_WINDOW` in manifest = 0, retired-figure prose still present in `ROADMAP.md`/`REQUIREMENTS.md`/`PROJECT.md`.
