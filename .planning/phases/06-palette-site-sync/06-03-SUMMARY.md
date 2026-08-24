---
phase: 06-palette-site-sync
plan: 03
subsystem: testing
tags: [site-sync, regression-net, index.html, honesty-boundary, makefile, verify]
requires:
  - phase: 06-palette-site-sync (Plan 02)
    provides: "index.html synced to the rebuilt résumé — the artifact the S6.x net asserts over"
provides:
  - "scripts/verify-site-regressions.sh — the S6.x site-sync regression net over raw index.html (18 assertions, each class failable via an --html negative control), including the D-08/D-09 public-register honesty classes"
  - "Makefile REGRESS6 wiring — the site net chained into `make verify` and `make verify-regressions`"
  - "the final six-net green gate + the recorded plain-text paste-test sign-off (APPROVED)"
affects: [site-sync, ship, milestone-close]
actuals:
  tokens: 5700
  tasks: 3
  commits: 3
tech-stack:
  added: []
  patterns:
    - "raw-HTML grep net (byte-exact LC_ALL=C grep -F, no pdftotext/no $SQUEEZED — HTML is not reflowed)"
    - "each assertion class proven failable via an --html scratch-fixture negative control (mirrors the résumé nets' --gate-text), never passed from a make target"
    - "deliberate needle omissions recorded in the net header so no requirement is silently dropped"
key-files:
  created:
    - "scripts/verify-site-regressions.sh"
  modified:
    - "Makefile"
key-decisions:
  - "D-08/D-09 public-register honesty boundary — flagged-unverified in 06-02 — is now MACHINE-GATED here as REGRESS6 assert_absent classes (retired throughput register + fabricated/no-evidence terms), each proven failable."
  - "Two D-09 needles are deliberately NOT added and the reason is recorded in the net header: bare `Go` (surviving `Google` Font-link comment makes a substring grep -F needle false-fail; the `Go`-as-language boundary stays gated résumé-side by verify-phase5's word-boundary assert_absent_word) and bare `GPUs` (the rewrite may legitimately keep `distributed GPU inference` phrasing, so only the exact `32 GPUs` fleet number is gated)."
patterns-established:
  - "Site-sync net idiom: default target index.html, `--html FILE` waiver for negative controls ONLY (prints a 'does NOT certify the committed index.html' disclaimer, read-only, never passed from a build target), exit 0/1/2 (all pass / a regression / cannot verify)."
requirements-completed: [SITE-01, SITE-02]
coverage:
  - id: D1
    description: "scripts/verify-site-regressions.sh — S6.x site-sync net over raw index.html: retired figures absent, career-break absent, rollout+graph_ml present, GPAs/Bloomington/pruned-sections/grad-titles absent, torch.compile present"
    requirement: "SITE-01"
    verification:
      - kind: automated_ui
        ref: "bash scripts/verify-site-regressions.sh (18 S6.x PASS, exit 0)"
        status: pass
      - kind: other
        ref: "negative control: --html scratch fixture with a retired figure re-inserted → exit 1"
        status: pass
    human_judgment: false
  - id: D2
    description: "D-08/D-09 public-register honesty classes machine-gated: retired throughput register (images/sec, 32 GPUs) + fabricated terms (speculative decoding, TensorRT-LLM, TRT-LLM) absent"
    requirement: "SITE-01"
    verification:
      - kind: automated_ui
        ref: "scripts/verify-site-regressions.sh S6.14–S6.18 (each count 0, exit 0)"
        status: pass
      - kind: other
        ref: "honesty negative control: --html fixture appending a fabricated register/term <li> → exit 1"
        status: pass
    human_judgment: false
  - id: D3
    description: "REGRESS6 chained into `make verify` + `make verify-regressions` (no `-`/`|| true` prefix, no --html in any recipe)"
    requirement: "SITE-02"
    verification:
      - kind: integration
        ref: "make verify (exit 0, green); make verify-regressions runs REGRESS2..REGRESS6"
        status: pass
    human_judgment: false
  - id: D4
    description: "Plain-text paste test (criterion 5): PDF pasted as plain text reads in correct order, ashutosh--tiwari handle + portfolio/GitHub/LinkedIn URLs intact"
    requirement: "SITE-01"
    verification:
      - kind: manual_procedural
        ref: "blocking human checkpoint (Task 3) — APPROVED by user"
        status: pass
    human_judgment: true
    rationale: "Read-order and literal-URL integrity in a real paste target is an eyeball judgment the harness cannot automate; approved at the blocking checkpoint."
duration: ~35min (across the interrupted + continuation sessions)
completed: 2026-08-24
status: complete
---

# Phase 6 Plan 03: Site-Sync Regression Net (REGRESS6) Summary

**A raw-HTML S6.x regression net (18 assertions, each class failable) machine-gates the site-sync invariants AND the D-08/D-09 public-register honesty boundary, wired into `make verify` as REGRESS6; the final six-net gate is green and the plain-text paste test was approved.**

## Performance

- **Duration:** ~35 min (interrupted mid-Task-2, reconciled in a continuation session)
- **Completed:** 2026-08-24
- **Tasks:** 3 (2 code tasks committed; Task 3 = the blocking human checkpoint, approved)
- **Files modified:** 2 (`scripts/verify-site-regressions.sh` created, `Makefile` wired)

## Accomplishments

- **`scripts/verify-site-regressions.sh`** — the S6.x site-sync net over the RAW `index.html` source (bash-3.2, byte-exact `LC_ALL=C grep -F`, no pdftotext / no `$SQUEEZED` because HTML is not reflowed). Green on the synced file (exit 0, 18 assertions PASS), each class proven failable via an `--html` scratch-fixture negative control. Exit vocabulary 0 (all pass) / 1 (a regression) / 2 (cannot verify — missing file). Read-only; `--html` prints a "does NOT certify the committed index.html" disclaimer and is never passed from a build target.
- **The D-08/D-09 public-register honesty boundary is now machine-gated** — the boundary 06-02 could only flag-unverified is enforced here by `assert_absent` classes: the retired throughput register (`images/sec` — broader than the exact retired string, catching a re-worded figure — and the exact `32 GPUs` fleet number) and the fabricated / no-evidence terms (`speculative decoding`, `TensorRT-LLM`, `TRT-LLM`), each proven failable.
- **REGRESS6 wired into make** — `REGRESS6 := scripts/verify-site-regressions.sh`, `@bash $(REGRESS6)` chained into both `verify:` (after REGRESS5) and `verify-regressions:`, help/comment text extended to name the site net. No `-`/`|| true` prefix, no `--html` in any recipe.
- **Final six-net gate green + paste test APPROVED** — `verify-resume.sh` exit 0; the P2/P3/P4/P5 nets + the site net exit 0 (P2=27, P3=72, P4=38, P5=25, S6=18); `make verify` exit 0; `pdfinfo` pages=2. The blocking plain-text paste test was **approved by the user** (read order intact, `ashutosh--tiwari` handle intact, portfolio/GitHub/LinkedIn URLs present as literal text).

## S6.x assertion classes + IDs

| ID(s) | Class | Needles | Assert |
|-------|-------|---------|--------|
| S6.1–S6.2 | retired page-1 figures absent | `3–8K images/sec`, `10–50×` | count 0 |
| S6.3 | career-break absent | `Career Break` | count 0 |
| S6.4–S6.5 | featured projects present | `github.com/thunderock/rollout`, `.../graph_ml` | ≥1 |
| S6.6–S6.7 | dropped GPAs absent | `3.87`, `8.32` | count 0 |
| S6.8 | Bloomington absent | `Bloomington` | count 0 |
| S6.9–S6.10 | pruned sections absent | `Competitive D.S. Experience`, `Certifications` | count 0 |
| S6.11 | Adobe rewrite landed | `torch.compile` | ≥1 |
| S6.12–S6.13 | grad-project titles absent | `BiasNet`, `DeepFoodie` | count 0 |
| **S6.14–S6.15** | **D-09 retired throughput register absent** | `images/sec`, `32 GPUs` | count 0 |
| **S6.16–S6.18** | **D-09 fabricated / no-evidence terms absent** | `speculative decoding`, `TensorRT-LLM`, `TRT-LLM` | count 0 |

**Negative controls (each class failable):** a scratch copy of `index.html` with a retired-figure `<li>` (or a fabricated register/term `<li>`) appended, run via `--html`, exits 1 and names the S6 class. Documented in the net header the way the résumé nets document their `--gate-text` controls.

**Deliberate omissions (recorded in the net header, not silent):**
- bare `Go` — no safe byte-exact grep -F form over raw HTML (the surviving `Google` Font-link comment makes a substring `Go` needle false-fail); the `Go`-as-language boundary stays gated résumé-side by `verify-phase5`'s word-boundary `assert_absent_word` over the shared document identity.
- bare `GPUs` — the D-08/D-09 rewrite may legitimately keep `distributed GPU inference`-style phrasing, so only the exact `32 GPUs` fleet number (S6.15) is provably absent and gated.

## Task Commits

1. **Task 1: Site-sync net tracer (retired-figure class, proven failable)** — `c87ce3c` (feat)
2. **Task 2a: All 18 S6.x classes + D-09 honesty boundary, each failable** — `8c1e7af` (feat)
3. **Task 2b: REGRESS6 wired into `make verify` + `make verify-regressions`** — `d35b169` (feat)

**Plan metadata:** this SUMMARY + tracking files (docs commit).

## Final gate evidence (six nets, all exit 0)

| Net | Result |
|-----|--------|
| `bash scripts/verify-resume.sh` | exit 0, 0 blocking failures; pages=2, page 2 opens PUBLICATIONS |
| `bash scripts/verify-phase2-regressions.sh` | exit 0 (P2=27) |
| `bash scripts/verify-phase3-regressions.sh` | exit 0 (P3=72) |
| `bash scripts/verify-phase4-regressions.sh` | exit 0 (P4=38) |
| `bash scripts/verify-phase5-regressions.sh` | exit 0 (P5=25) |
| `bash scripts/verify-site-regressions.sh` | exit 0 (S6=18) |
| `make verify` | runs green (corroboration; GNU Make collapses exit 1/2, so the direct runs are the oracle) |

## Files Created/Modified

- `scripts/verify-site-regressions.sh` — the S6.x site-sync regression net (created; 398 lines).
- `Makefile` — `REGRESS6` variable + `@bash $(REGRESS6)` chained into `verify:` and `verify-regressions:`, help text extended.

## Decisions Made

- Machine-gate the D-08/D-09 public-register honesty boundary here (06-02 could only flag it unverified) as REGRESS6 `assert_absent` classes, each proven failable — see key-decisions.
- Record the two deliberate needle omissions (bare `Go`, bare `GPUs`) in the net header with their reasons, so no requirement is silently dropped.

## Deviations from Plan

None — plan executed exactly as written (D-11 invariants + the D-08/D-09 honesty classes all asserted, both omissions recorded, REGRESS6 chained into both recipes).

## Issues Encountered

**Crash recovery (mid-Task-2 interruption).** The prior executor session was interrupted mid-Task-2 with an uncommitted working-tree draft of `scripts/verify-site-regressions.sh` (the remaining assertion classes) plus the Makefile wiring. On resume, the uncommitted draft was reconciled against the plan and split into the two atomic commits the plan's task structure calls for — `8c1e7af` (all 18 S6.x classes + the D-09 honesty boundary) and `d35b169` (the REGRESS6 Makefile wiring) — rather than one mixed commit. A hygiene-hook comment fix was applied so every commit passed the pre-commit hooks cleanly; **no `--no-verify` was used** on any commit. The final full gate then passed on the reconciled tree.

**Post-checkpoint continuation.** This SUMMARY + tracking updates were written by a fresh continuation agent after the blocking `checkpoint:human-verify` (Task 3, criterion-5 paste test) was **approved** by the user. The three code commits were re-verified present and both `verify-resume.sh` and `verify-site-regressions.sh` were re-run green before closing the plan.

## Next Phase Readiness

- SITE-01 + SITE-02 ticked complete (REQUIREMENTS.md checkboxes + traceability → Complete). VIS-01 was already ticked by 06-01. All three Phase 6 requirements are now closed.
- The milestone artifact set is verified shippable: résumé (palette applied), site (synced), and a standing REGRESS6 net that catches a silent public regression before the owner pushes.
- **No push performed** — the sync goes public only on the owner's own push to `master`. Phase-level verification + phase-complete are the orchestrator's to run next.

## Self-Check

- `scripts/verify-site-regressions.sh` exists on disk (398 lines); `Makefile` carries `REGRESS6`.
- Commits `c87ce3c`, `8c1e7af`, `d35b169` all present in git log.
- 06-03-SUMMARY.md created on disk.

## Self-Check: PASSED

---
*Phase: 06-palette-site-sync*
*Completed: 2026-08-24*
