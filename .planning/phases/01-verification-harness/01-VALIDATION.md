---
phase: 1
slug: verification-harness
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-08-21
---

# Phase 1 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | bash + make (no test framework — the harness IS the test) |
| **Config file** | none — Wave 0 installs `make verify` + `make verify-selftest` |
| **Quick run command** | `make verify` |
| **Full suite command** | `make verify-selftest && make verify; test $? -eq 1` |
| **Estimated runtime** | ~5–15 seconds (selftest includes one scratch latexmk build, ~1.1s measured) |

---

## Sampling Rate

- **After every task commit:** Run `make verify` (expected exit 1 during Phase 1 — assert the FAILURE NAMES, not exit 0)
- **After every plan wave:** Run `make verify-selftest` (probe suite: +5-line overflow probe must be caught; positive/negative controls green)
- **Before `/gsd-verify-work`:** `make verify-selftest` exits 0 AND `make verify` exits 1 naming exactly the three Phase-2-owned defects (en-dash handle, zero literal URLs, Education parse order)
- **Max feedback latency:** 20 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 1-01-* | 01 | 1 | VERIFY-01 | — | N/A | integration | `make verify-selftest` (overflow probe caught; 2-page baseline passes page gate) | ❌ W0 | ⬜ pending |
| 1-01-* | 01 | 1 | VERIFY-02 | — | N/A | integration | `pdftotext` round-trip assertions fire on seeded corruption; pass on clean layer | ❌ W0 | ⬜ pending |
| 1-01-* | 01 | 1 | VERIFY-03 | — | N/A | integration | frozen-manifest `grep -Fxc` = 1 per string; mutation probe flips it to failure | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

*(Exact task IDs filled by the planner; every task's verify maps to one of the three commands above.)*

---

## Wave 0 Requirements

- [ ] `make verify` target + assertion script(s) — the deliverable itself is the test infrastructure
- [ ] `make verify-selftest` — probe suite with positive AND negative controls (overflow probe, mutation probes)
- [ ] Frozen-strings baseline manifest — pins the 5 employment date ranges + titles ONLY

*The harness is self-validating: selftest proves the gates fire; the inverted acceptance (`make verify; test $? -eq 1`) proves they detect today's real defects.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| LinkedIn vanity handle is actually `ashutosh--tiwari` | VERIFY-02 | Ground truth lives on linkedin.com, not in the repo | User confirms handle at checkpoint before the keyword manifest freezes it |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 20s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
