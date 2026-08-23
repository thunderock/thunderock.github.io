---
phase: 03-adobe-rebuild-staff-signal-bullets
plan: 05
subsystem: resume-content
tags: [latex, pdftotext, ats-keywords, torch-compile, triton, cuda-graphs, ray-data, attribution, page-budget]

# Dependency graph
requires:
  - phase: 03-01
    provides: "scripts/verify-phase3-regressions.sh — the acceptance oracle whose 13 03-05-owned FAILs this plan drove to zero, plus the <locked_literals> Class B/E tables and the recorded Class E gap this plan closes as a decision"
  - phase: 03-03
    provides: "03-DECISION-RECORD.md — the A4 revise disposition, the 1.09M / 8×A100 / 16-fractional-GPU-actor traceability rows, the retirement row's EN-DASH assertion rule, the ASCII-quote encoding rule and the contingency ladder"
  - phase: 03-04
    provides: "the measured entering headroom G3.2 p1 +28.1pt (+2.44 lines), the adjacent-append promotion pattern, the corrected free-tail character widths, and the anchored-FAIL-census rule this plan reused"
  - phase: 02
    provides: "the artifacts-ride-in-the-source-commit rule and the measured 11.4–11.5pt/line unit cost"
provides:
  - "D-08 discharged: the [Phase 3 / D-08] marker records cudagraphs-confirmed against a sha256-verified genie wheel, closing the [Phase 5] CUDA-graphs blocker"
  - "both unprovenanced page-1 figures retired from source AND text layer; all four absence assertions PASS"
  - "the evidenced Ray Data benchmark (1.09M rows, 8×A100, 16 fractional-GPU actors) shipped with machine-enforced attribution safety (achiev ×0 document-wide)"
  - "torch.compile(mode=\"max-autotune\") production claim with the full cudagraphs-confirmed compiler bridge at ZERO additional rendered lines"
  - "torch.compile and Triton promoted to KEYWORDS_REQUIRED, suffixes stripped, appended adjacently; G6.5 15 -> 17 PASS"
  - "P3 census 14 FAIL -> 1 FAIL; every 03-05-owned assertion cleared; the only survivor is the /03-06 Flipkart needle"
  - "measured page-1 headroom handed to 03-06: G3.2 p1 +17.1pt (+1.49 lines), EXP-08 reserve INTACT"
affects: [03-06, 03-07, 03-08, phase-05-keyword-promotion, phase-06-site-sync]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "branch-marker detection must be scoped to the marker LINE, never the document — a prior phase's own gap record can carry both branch identifiers as history"
    - "a +1-line spend creates its own free tail room: the second rendered line of a newly-wrapped bullet is the cheapest place for the next clause"
    - "keyword promotion appended adjacently at the END of KEYWORDS_REQUIRED so 'torch.compile|Triton' is a witness that is false pre-promotion"
    - "a recorded conditional assertion closes as a DECISION when its branch is not taken, not as an omission"

key-files:
  created:
    - .planning/phases/03-adobe-rebuild-staff-signal-bullets/03-05-SUMMARY.md
  modified:
    - .planning/STATE.md
    - docs/main.tex
    - docs/verify/manifest.txt
    - docs/AshutoshTiwari.pdf
    - docs/AshutoshTiwari.log
    - docs/AshutoshTiwari.fdb_latexmk

key-decisions:
  - "D-08 answered cudagraphs-confirmed on a sha256-verified genie 1.0.0+957ce74 wheel — full compiler bridge ships (Triton-generated kernels, fusion, CUDA-graph capture)"
  - "the Class E EXP-03c/03-05 'CUDA' absence needle was DELIBERATELY NOT appended — on this branch it would assert the opposite of the truth; the 03-01 recorded gap therefore closes as a decision"
  - "the D-08 branch detector and both uniqueness clauses were SCOPED TO THE MARKER LINE — STATE.md:63 already carries both identifiers, so the plan's document-scoped detector selected the WRONG branch"
  - "the bridge clause landed in A4's own new second rendered line rather than a separate topic, at a measured 0pt — A4 is the offline-inference (Glimmer/PyTorch-Lightning) item that owns the torch.compile evidence"
  - "requirements-completed left EMPTY — 03-08 is the last claiming plan for both EXP-03 and EXP-04 (sixth consecutive plan following the rule)"

patterns-established:
  - "Marker-line scoping: any grep that must read a decision marker's payload pipes through `grep -F '[marker]' file | grep …` so historical mentions of either branch identifier cannot flip the branch"
  - "Spend-then-fill: budget the rendered line first, then write the next clause into the tail room that line created — two tasks, one bullet, +1 line total"

requirements-completed: []  # EMPTY BY DESIGN — see Decisions Made; 03-08 is the last claiming plan for EXP-03 and EXP-04

# Metrics
duration: 9 min
completed: 2026-08-23
---

# Phase 3 Plan 05: Retire the Unverified Figures and Land the Production Compile Path Summary

**The two unprovenanced page-1 speedup figures are gone from source and text layer, replaced by the evidenced 1.09M-row / 8×A100 / 16-fractional-GPU-actor Ray Data benchmark with `achiev` machine-excluded document-wide, and `torch.compile(mode="max-autotune")` ships with the full CUDA-graph bridge that a sha256-verified genie wheel licensed — all at a net +1 rendered line, with `torch.compile` and `Triton` promoted in the same commit.**

## Performance

- **Duration:** 9 min (post-checkpoint continuation only; the D-08 read itself was performed by the user out of band)
- **Started:** 2026-08-23T04:40:00Z (continuation resume)
- **Completed:** 2026-08-23T04:49:09Z
- **Tasks:** 3 (Task 1's decision was supplied by the user; its record, Tasks 2 and 3 executed here)
- **Files modified:** 6 (1 planning, 2 source/config, 3 build artifacts)

## Accomplishments

- **D-08 discharged with evidence, not assumption.** The `[Phase 3 / D-08]` marker records `cudagraphs-confirmed` against the genie `1.0.0+957ce74` wheel (sha256 `c22efd9a…68dd0`), whose `glimmer/modules/dp/content_type_classifier/module.py:76-77` carries `torch.compile(mode="max-autotune")` on both the CLIP encoder and the classifier head, with wheel-wide **zero** hits for `cudagraph`, `cuda_graph`, `triton.cudagraphs`, `torch._inductor.config` and `max-autotune-no-cudagraphs`, and no YAML override. The `[Phase 5]` CUDA-graphs blocker is superseded and closed.
- **Both figures retired in all four asserted places.** `10–50` absent from the raw and squeezed text streams, `3–8K images/sec on 32 GPUs` absent from the squeezed stream, and both ASCII source forms absent from `docs/main.tex`.
- **Attribution safety is now machine-enforced.** `achiev` was ×1 on arrival (the very word being rewritten) and is now **×0** case-insensitively in both `docs/main.tex` and the squeezed text layer. The shipped wording says a module was *benchmarked on* the Ray Data engine — never that he achieved a result with it or built the engine.
- **The production compile claim ships with the strongest honest clause**, at **zero** additional rendered lines, written into the second rendered line that Task 2's budgeted +1 had just created.
- **`torch.compile` and `Triton` promoted in the same commit that landed them**, suffixes stripped, appended adjacently at the end of `KEYWORDS_REQUIRED`. `G6.5` went **15 → 17 PASS**. `CUDA graphs` remains an unpromoted `KEYWORDS_TARGET` entry at ×0, still owned by Phase 5's PG2-04.
- **P3 census 14 FAIL → 1 FAIL** (71 PASS). All 13 `/03-05`-owned assertions cleared; the sole survivor is `P3.66`, the `/03-06` Flipkart `manual deploys` needle.

## Task Commits

1. **Task 1: Record the D-08 production compile config read** — `5820d54` (docs)
2. **Task 2: Retire both unverified figures and land the Ray Data benchmark** — `353dc16` (feat)
3. **Task 3: Land the torch.compile production claim with the branch-selected bridge, and promote it** — `b056a4a` (feat)

**Plan metadata:** see the trailing `docs(03-05)` commit.

Artifacts (`.pdf`, `.log`, `.fdb_latexmk`) ride inside each source commit per the Phase-2 rule; `make clean` was never run. `.aux`, `.fls` and `.out` were byte-unchanged. No commit deleted a tracked file (verified with `git diff --diff-filter=D` on all three).

## Files Created/Modified

- `.planning/STATE.md` — one added line: the `[Phase 3 / D-08]` decision marker. Additions only (`1 insertion(+), 0 deletions`), inside the Decisions list; no `docs/` file touched by that task.
- `docs/main.tex:155` — the offline-inference `\resumeItem` rebuilt: retired figures out, Ray Data benchmark in, compiler bridge appended.
- `docs/verify/manifest.txt:53-54` — `torch.compile` and `Triton` moved from `KEYWORDS_TARGET` to `KEYWORDS_REQUIRED`.
- `docs/AshutoshTiwari.{pdf,log,fdb_latexmk}` — regenerated, committed with their source.

### The exact shipped wording (`docs/main.tex:155`)

```
\resumeItem{Built offline inference on Ray Data + PyTorch Lightning; a module
benchmarked on that engine at 1.09M rows, 8$\times$A100, 16 fractional-GPU actors.
Introduced torch.compile(mode="max-autotune") in production: compiler-generated
Triton kernels, fusion, CUDA-graph capture.}
```

Rendered as exactly **2** gate lines — gate 16 (135 chars) and gate 17 (131 chars), 266 rendered characters including the bullet prefix, 0 Overfull `\hbox`. `torch.compile(mode="max-autotune")` sits wholly inside gate line 17, so it never breaks across a wrap and the squeezed-stream assertion matches the literal byte-for-byte. The plain ASCII `"` extracted as U+0022: the `G6.4` census shows U+201C ×1 and U+201D ×1 both before and after this plan — **zero curly quotes added**.

## Verification Evidence

### Retirement proof — all four absence counts at 0

| Assertion | Stream | Count |
|---|---|---|
| `10–50` (U+2013) | raw text layer | **0** |
| `10–50` (U+2013) | squeezed text layer | **0** |
| `3–8K images/sec on 32 GPUs` | squeezed text layer | **0** |
| `10--50` \| `3--8K` (ASCII) | `docs/main.tex` | **0** |

### Attribution proof

| Needle | Stream | Arrival | Now |
|---|---|---|---|
| `achiev` (case-insensitive) | `docs/main.tex` | 1 (`:155`) | **0** |
| `achiev` (case-insensitive) | squeezed text layer | 1 | **0** |

Replacement literals present ×1 each in the squeezed text layer: `1.09M`, `8×A100`, `16 fractional-GPU actors`.

### Promotion diff

```
-KEYWORDS_REQUIRED=…|Flash Attention|A100|H100
+KEYWORDS_REQUIRED=…|Flash Attention|A100|H100|torch.compile|Triton
-KEYWORDS_TARGET=torch.compile:3|ONNX:5|CUDA graphs:3|Iceberg:5|Triton:5
+KEYWORDS_TARGET=ONNX:5|CUDA graphs:3|Iceberg:5
```

| Witness | Value |
|---|---|
| `grep -c 'torch.compile:3'` | **0** (suffix stripped) |
| `grep -c 'Triton:5'` | **0** (suffix stripped) |
| `grep -Fc 'torch.compile\|Triton'` | **1** (adjacency witness — false before this commit) |
| `grep -c 'CUDA graphs'` | **1** (still an unpromoted target) |

`G6.6` still WARNs `CUDA graphs` ×0 — correct on this branch: D-07's hyphenated singular `CUDA-graph capture` does not land the fixed string `CUDA graphs`.

### Harness / net census

| Gate | Entering (680055f) | After Task 2 | After Task 3 |
|---|---|---|---|
| `bash scripts/verify-resume.sh` | exit 0 | exit 0 | **exit 0** |
| `G1.1` | PASS 2 pages | PASS 2 pages | **PASS 2 pages** |
| `G2.1` | PASS | PASS | **PASS** |
| `G3.2` p1 | +28.1pt (+2.44 lines) | +17.1pt (+1.49) | **+17.1pt (+1.49)** |
| `G5.4` | 10 | 10 | **10** (≥8) |
| `G6.4` | PASS | PASS | **PASS** |
| `G6.5` PASS | 15 | 15 | **17** |
| P3 anchored FAIL | 14 | 4 | **1** |
| P3 anchored PASS | 58 | 68 | **71** |
| P2 anchored PASS | 27 | 27 | **27** (exit 0) |

- `make verify-selftest` exits **0** with **ten** G7/G8 PASS and **zero** anchored G7/G8 SKIP. (`grep -c SKIP` reads 1 only because `G8.2`'s own PASS message describes reaching its control through `--skip-freshness`, which `G0.3` reported as SKIP.)
- `G7.2` still reports *"the probe PDF is 3 page(s)"* — **rail 2 held**: `G3.2` p1 never rose above the +50.5pt baseline at any commit, and the wave did not end net-freed.
- `shellcheck -f gcc scripts/verify-phase3-regressions.sh` — zero findings. `/bin/bash` 3.2.57 run of the P3 net is identical (1 FAIL, 71 PASS).
- All seven forbidden accelerator families (`TensorRT`, `TRT-LLM`, `speculative decoding`, `quantization`, `MoE`, `tensor parallel`, `pipeline parallel`) count **0** in `docs/main.tex`.
- `PROBE_LINES` and `DIGIT_BULLET_FLOOR` byte-untouched. `make clean` never run.

### Budget ledger handed to 03-06

`G3.2` p1 = **+17.1pt (+1.49 lines)**. Task 2 spent the budgeted **+1** rendered line (−11.0pt measured); Task 3 spent **0pt**. Adobe grew 20 → **21** rendered lines (gate 11–31). At +17.1pt the contingency ladder's top rung (≥ +16.1pt) still holds by 1.0pt, so **the EXP-08 approval reserve SURVIVED** — the sanctioned Groupon/NetSpeed reword-shorter lever was not pulled and no same-commit obligation is inherited. Absolute gate line numbers below Adobe shifted down by 1 again; re-derive from region boundaries, never from literals.

## Decisions Made

1. **The Class E `EXP-03c/03-05` `CUDA` absence needle was deliberately NOT appended.** The plan makes it conditional on `triton-only-fallback`; the recorded branch is `cudagraphs-confirmed`, on which the bridge clause legitimately names CUDA-graph capture, so the needle would assert **the opposite of the truth** and would be permanently red on a correct document. It therefore stays exactly where 03-01 left it — a commented `RECORDED GAP` block at the end of Group 5 (`scripts/verify-phase3-regressions.sh:876-900`), with `grep -Fc 'EXP-03c/03-05'` returning 1 from that comment and **no live `assert_absent 'CUDA'`** anywhere in the file. The net is byte-unchanged by this plan. Consequently the crafted `--gate-text` control the plan owed on the fallback branch was **not run and is not owed** — the assertion it would have proven failable does not exist. The 03-01 gap closes as a *decision*, not as a gap a later reader must rediscover. `LC_ALL=C grep -Fci CUDA docs/main.tex` is **1** on this branch, which is the correct value.
2. **`CUDA graphs` was not promoted**, on the explicit instruction of both D-07 and the D-08 record: its exact-match form is Phase 5's PG2-04 work, and the shipped hyphenated singular does not land the fixed string anyway.
3. **The bridge clause landed in A4 rather than a separate topic.** Re-measuring the committed artifact showed A2 (`Distributed Inference Frameworks`), the nominal inference-owning topic, at 133/136 characters on its last rendered line — effectively full after 03-04's fleet figures. A4 *is* the offline-inference item (Ray Data + PyTorch Lightning = the Glimmer path the `torch.compile` evidence comes from), and Task 2's budgeted +1 line had just created ~128 characters of free tail room there. Placing the clause in that room cost a measured **0pt**, keeping every figure and mechanism in an owning topic.
4. **Measured itemize-3 line-1 capacity is 135 characters, not 130.** Gate line 16 rendered at 135, above the 128–130 range `[Phase 3 / 03-04]` recorded. Two-line itemize-3 content capacity is therefore ≈**266** characters, which is exactly what the shipped A4 bullet uses. This is what let the full honest bridge (Triton codegen + fusion + CUDA-graph capture) fit where a 130-char assumption would have predicted a third rendered line and a consumed EXP-08 reserve. Candidates were length-checked in **characters** against the measured width before editing; both tasks landed at their target line count on the first build with zero retries.
5. **`requirements-completed` is deliberately EMPTY and `requirements mark-complete` was NOT run**, despite the plan's `requirements: [EXP-03, EXP-04]`. EXP-03 is claimed by 03-01/03-05/03-08 and EXP-04 by 03-01/03-03/03-04/03-05/03-08 — **03-08 is the last claiming plan for both**, and 03-08 Task 3 owns the EXP-02 tick. Substantively both requirements' text is now satisfied (EXP-03's bridge clause ships here; EXP-04's six figure families are complete across 03-04 and this plan), but the phase oracle is still red on the `/03-06` needle and the phase's rule — followed by 03-01, 03-02, 03-03, 03-04 and Phase 2 Plan 01 — is that a shared requirement completes when the LAST plan lands. Sixth consecutive plan.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] The D-08 branch detector and both uniqueness clauses were document-scoped and selected the WRONG branch**

- **Found during:** Task 1 (recording the D-08 outcome), and it propagated into Task 3's gate.
- **Issue:** The plan asserts as measured fact that *"neither identifier appears anywhere in `.planning/STATE.md` today, so that grep is an unambiguous detector."* **That measurement is stale.** `.planning/STATE.md:63` — the `[Phase 3 / 03-01]` Class E gap record, committed during wave 1 *after* this plan was written — carries `cudagraphs-confirmed` ×2 **and** `triton-only-fallback` ×1 as history. Two consequences, both verified by running the plan's own commands:
  - Task 1's `<automated>` block and acceptance criterion 2 became **unsatisfiable**: the document-scoped counts read `cudagraphs-confirmed`=2, `triton-only-fallback`=1, so `test … -le 1` and the `sum = 1` clause both fail. The block as written exits **1** on a fully correct file.
  - Far worse, Task 3's branch detector `grep -q 'triton-only-fallback' .planning/STATE.md` returns **true regardless of the decision**. Measured on the finished file: the document-scoped detector prints `-> would WRONGLY select FALLBACK`. It would have shipped the Triton-only wording, appended the Class E `CUDA` needle that asserts the opposite of the truth, and then failed its own `grep -Fci CUDA docs/main.tex` = 0 gate — a green decision silently routed to the wrong honesty gate, which is precisely the failure T-03-26 exists to prevent.
- **Fix:** Scoped the branch detector and both uniqueness clauses **to the marker line**, e.g. `LC_ALL=C grep -F '[Phase 3 / D-08]' .planning/STATE.md | LC_ALL=C grep -q 'triton-only-fallback'`. Marker-line counts read `cudagraphs-confirmed`=1, `triton-only-fallback`=0, sum=1 — the property the plan actually wanted. **`.planning/STATE.md:63` was NOT edited**: its content is correct, it is committed history, and rewriting a prior plan's record to make a later grep convenient would destroy the audit trail. The marker bullet itself names only the winning identifier.
- **Files modified:** none beyond the planned `.planning/STATE.md` addition — this was a verification-clause fix, not a content fix.
- **Verification:** plan-as-written Task 1 block → exit **1**; marker-line-scoped block → exit **0**. Document-scoped Task 3 detector → selects fallback; marker-line-scoped → selects `cudagraphs-confirmed`. All Task 1 acceptance criteria pass under the scoped form, including `grep -Fc '[Phase 3 / D-08]'` = 1, `grep -c 'CUDA graphs' docs/verify/manifest.txt` = 1, additions-only diffstat (`1 insertion(+), 0 deletions`) and zero `docs/` files touched.
- **Committed in:** `5820d54` (Task 1 commit).

**2. [Rule 1 - Bug] Task 3's `<automated>` P3-FAIL census used the unanchored form and cannot pass**

- **Found during:** Task 3 verification.
- **Issue:** The clause `bash scripts/verify-phase3-regressions.sh | grep -E 'FAIL' | grep -vcE '/03-06 ' | grep -qx 0` reproduces the exact trap `[Phase 3 / 03-04]` recorded and predicted this plan would hit. The net emits two owner-tag-free footer lines containing the word FAIL, so on a fully correct document the count reads **2**, never 0, and the whole composed command exits 1 while every acceptance criterion is satisfied.
- **Fix:** Gated on the anchored form `^RESULT P3\.[0-9]+ +FAIL` for both the FAIL and PASS censuses, exactly as `[Phase 3 / 03-04]` instructs and as the resume instructions directed.
- **Files modified:** none — verification-clause fix only.
- **Verification:** unanchored → **2** (the two offending lines are `!! FAIL: 1 of 72 …` and `!! Every RESULT … FAIL line above names its owning plan and its remedy.`); anchored → **0** unowned FAILs, 71 PASS, sole FAIL `P3.66` owned by `/03-06`.
- **Committed in:** `b056a4a` (Task 3 commit).

---

**Total deviations:** 2 auto-fixed (both Rule 1 — broken verification clauses; zero content deviations)
**Impact on plan:** Both fixes were mandatory for correctness, and deviation 1 was load-bearing: without it the plan would have shipped the wrong D-08 branch's wording and honesty gate on a `cudagraphs-confirmed` decision. Neither fix weakened an assertion — deviation 1 made the branch detector *more* precise, and deviation 2 replaced an unsatisfiable clause with the one the plan's own sibling already mandates. No scope creep; no content departure from D-05, D-07 or D-08; no threshold raised or lowered; no locked literal dropped.

## Issues Encountered

- **The full honest bridge clause did not fit the predicted budget.** Sizing against `[Phase 3 / 03-04]`'s recorded 128–130-character itemize-3 width made every candidate carrying *Triton-generated kernels + compiler-driven fusion + CUDA-graph capture* overflow into a third rendered line, which would have consumed the EXP-08 reserve. Resolved by measuring the committed artifact instead of trusting the recorded estimate: gate line 16 renders at **135** characters, so the two-line budget is ≈266, and the clause `Introduced torch.compile(mode="max-autotune") in production: compiler-generated Triton kernels, fusion, CUDA-graph capture.` fits at exactly 266 with 0 Overfull `\hbox`. "compiler-generated Triton kernels" was chosen over "Triton kernels" deliberately: `STACK.md:483`'s guardrail 3 forbids any phrasing that could read as hand-written kernels, and attributing them to the compiler is what makes the claim credible.
- No authentication gates. No packages installed. No stubs: every claim in the shipped bullet resolves to a `CODEBASE-EVIDENCE.md` citation.

## Threat Flags

None. This plan touched one LaTeX `\resumeItem`, two manifest keyword lists and three build artifacts — no network endpoint, auth path, file-access pattern or schema at a trust boundary was introduced. Every threat in the plan's register was mitigated as specified except **T-03-26b**, which is branch-scoped to `triton-only-fallback` and therefore not reachable on this branch (see Decisions Made #1).

## User Setup Required

None — no external service configuration required. The one out-of-band action, the D-08 config read, was completed by the user at the Task 1 checkpoint and its evidence is recorded in `.planning/STATE.md`.

## Next Phase Readiness

- **Ready for 03-06.** The P3 oracle is at **71 PASS / 1 FAIL**, and that single FAIL is `P3.66`, `03-06`'s own `manual deploys` Flipkart-closure needle. 03-06 Task 2's gate is the net reaching exit 0; nothing this plan owns stands in its way, and the `Triton` promotion it depended on is landed.
- **Budget handed over:** `G3.2` p1 **+17.1pt (+1.49 lines)**, reserve intact by 1.0pt above the ladder's top rung. 03-06 is line-neutral per D-11, so 03-07/03-08 should still find roughly one rendered line of EXP-08 approval fund. Re-derive Swiggy/Flipkart region boundaries rather than reusing gate line numbers — Adobe grew to 21 rendered lines and pushed everything below it down by one more.
- **Still owed by later plans:** EXP-08 candidate (c)'s missing Class D needle (owner 03-08), the EXP-02/03/04/07/08 requirement ticks (owner 03-08), and the Phase-6 site-sync obligation at `index.html:196` — which now contradicts the resume on **both** retired figures, since this plan removed them from the PDF while the live site still publishes them.
- **Closed:** the `[Phase 5]` CUDA-graphs blocker in `### Blockers/Concerns` is superseded by the D-08 record and should be struck when STATE.md is next tidied.

## Self-Check: PASSED

- `.planning/phases/03-adobe-rebuild-staff-signal-bullets/03-05-SUMMARY.md` — exists on disk.
- `docs/main.tex`, `docs/verify/manifest.txt`, `docs/AshutoshTiwari.pdf` — all exist and are committed.
- Commits `5820d54`, `353dc16`, `b056a4a` all resolve in `git log --oneline --all`.
- Every task-level `<acceptance_criteria>` re-run after the final commit: `bash scripts/verify-resume.sh` exit **0** (`G1.1` 2 pages, `G2.1` PASS, `G6.4` PASS, `G6.5` **17** PASS / 0 FAIL, `G5.4` 10, `G3.2` p1 **+17.1pt**), `bash scripts/verify-phase2-regressions.sh` exit 0 with **27** anchored PASS, `bash scripts/verify-phase3-regressions.sh` **71** anchored PASS / **1** anchored FAIL with **0** not owned by `/03-06`, `make verify-selftest` exit 0 with ten G7/G8 PASS and zero anchored SKIP, `shellcheck` clean, all four retirement counts 0, `achiev` 0/0, all seven forbidden accelerator families 0, all three promotion witnesses correct.
- Working tree clean apart from the pre-existing untracked `.omc/`, which is out of scope and was left alone.

---
*Phase: 03-adobe-rebuild-staff-signal-bullets*
*Completed: 2026-08-23*
