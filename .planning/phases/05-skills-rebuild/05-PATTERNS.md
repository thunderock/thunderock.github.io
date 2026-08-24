# Phase 5: Skills Rebuild - Pattern Map

**Mapped:** 2026-08-24
**Files analyzed:** 5 (2 CREATE-adjacent / 5 MODIFY)
**Analogs found:** 5 / 5 (all in-repo; this is a self-contained LaTeX + shell repo)

## File Classification

| New/Modified File | Role | Data Flow | Closest Analog | Match Quality |
|-------------------|------|-----------|----------------|---------------|
| `docs/main.tex` (`\section{Technical Skills}`, L289–295, resolve by CONTENT) | config/content (LaTeX source-of-truth) | transform (source → PDF text layer) | its own current itemize block (L289–295) | exact (in-place rewrite) |
| `docs/verify/manifest.txt` (`KEYWORDS_*`, `SKILLS_MAX_LINES`) | config (verification manifest/ledger) | batch (data read by gates + nets) | its own `KEYWORDS_REQUIRED`/`KEYWORDS_TARGET`/`WARN_OWNERS` lines | exact (in-place edit) |
| `scripts/verify-phase5-regressions.sh` | test (regression net) | CREATE | `scripts/verify-phase4-regressions.sh` (38 P4.x) | exact (role + data flow) |
| `scripts/verify-phase3-regressions.sh` (`P3.44`/`P3.65` flips, triple extend) | test (regression net) | MODIFY (in-place needle flips) | itself, L877–888 + L1015–1017 | exact |
| `Makefile` (`REGRESS5` wiring) | config (build/verify wiring) | MODIFY | `REGRESS4` var + `verify:`/`verify-regressions:` recipes | exact |

---

## Pattern Assignments

### `scripts/verify-phase5-regressions.sh` (test, CREATE)

**Analog:** `scripts/verify-phase4-regressions.sh` (copy the whole scaffold, retitle P4→P5). The `assert_promoted` helper + `--manifest` plumbing is NOT in the phase-4 net — copy those from `scripts/verify-phase3-regressions.sh` (option A per RESEARCH §Harness (c)/(d): the phase-5 net owns the `ONNX`/`CUDA graphs`/`Iceberg` promotions).

**Header/shell conventions** (phase4 `:57-65`): bash 3.2.57, `set -uo pipefail` (NOT errexit — every assertion must run and aggregate), all greps under `LC_ALL=C`, temporaries `_`-prefixed, `P5.` prefix cannot collide with G-series / P2. / P3. / P4.

**Two-stream setup** (phase4 `:270-284`) — copy verbatim; this is the load-bearing STATE.md rule (`$SQUEEZED` for multi-word, `$GATE` for single-token):
```bash
if [ -z "$GATE_TEXT" ]; then
    pdftotext "$PDF" "$WORK/raw.txt" 2>/dev/null \
        || die2 "pdftotext failed to extract a text layer from $PDF"
else
    cp "$GATE_TEXT" "$WORK/raw.txt" 2>/dev/null || die2 "cannot read the gate-text fixture: $GATE_TEXT"
fi
tr '\f' '\n' < "$WORK/raw.txt" > "$WORK/gate.txt" || die2 "form-feed normalization failed"
[ -s "$WORK/gate.txt" ] || die2 "the extracted text layer is empty ..."
tr -s ' \t\n' ' ' < "$WORK/gate.txt" > "$WORK/squeezed.txt" || die2 "whitespace normalization failed"
[ -s "$WORK/squeezed.txt" ] || die2 "the whitespace-squeezed text layer is empty ..."
GATE="$WORK/gate.txt"
SQUEEZED="$WORK/squeezed.txt"
```

**`emit()` id auto-numbering** (phase4 `:134-142`) — retitle to `P5.$P5_SEQ`; ids are sequential in emission order, never hardcoded:
```bash
emit() {  # emit <PASS|FAIL> <message>
    P5_SEQ=$((P5_SEQ + 1))
    printf 'RESULT %-6s %-5s %s\n' "P5.$P5_SEQ" "$1" "$2"
    if [ "$1" = FAIL ]; then
        FAILURES=$((FAILURES + 1)); FAILED_IDS="$FAILED_IDS P5.$P5_SEQ"
    fi
    return 0
}
```

**`gcount` sentinel + assertion helpers** (phase4 `:159-228`) — copy `gcount` (-1 sentinel for unreadable/missing), `assert_present` (`:183-194`), `assert_absent` (4-arg: label, needle, file, remedy — `:199-210`), `assert_count` (`:217-228`). Copy `display_of` (`:172-179`) and ADD the `MANIFEST` arm from phase3 (`:283`) since `assert_promoted` needs it.

**`assert_promoted` helper** (copy from phase3 `:410-438`, verbatim — three-conjunct pairing rule: present in `$GATE` ∧ whole pipe-field of `KEYWORDS_REQUIRED` ∧ no leftover `KEYWORDS_TARGET` `<literal>:` field):
```bash
assert_promoted() {           # assert_promoted <label> <literal>  (2 args)
    _apr_gate=$(gcount -Fc "$2" "$GATE")
    if [ -s "$WORK/kw-required.txt" ]; then _apr_req=$(gcount -Fxc "$2" "$WORK/kw-required.txt")
    else _apr_req=-1; fi
    _apr_sfx=''
    while IFS= read -r _apr_f; do
        [ -n "$_apr_f" ] || continue
        case "$_apr_f" in "$2":*) _apr_sfx="$_apr_sfx '$_apr_f'" ;; esac
    done < "$WORK/kw-target.txt"
    ... (three-conjunct verdict, names WHICH conjunct failed)
}
```

**`--manifest` plumbing** (copy from phase3): default `MANIFEST="docs/verify/manifest.txt"` (`:162`), the `--manifest PATH` arg case (`:221`), the precondition `[ -f "$MANIFEST" ] && [ -s "$MANIFEST" ] || die2 ...` (`:511`), and the kw-field extraction into scratch (`:565-570`):
```bash
LC_ALL=C grep '^KEYWORDS_REQUIRED=' "$MANIFEST" 2>/dev/null \
    | sed -e 's/^KEYWORDS_REQUIRED=//' -e 's/[[:space:]]*#.*$//' -e 's/[[:space:]]*$//' \
    | tr '|' '\n' > "$WORK/kw-required.txt"
LC_ALL=C grep '^KEYWORDS_TARGET=' "$MANIFEST" 2>/dev/null \
    | sed -e 's/^KEYWORDS_TARGET=//' -e 's/[[:space:]]*#.*$//' -e 's/[[:space:]]*$//' \
    | tr '|' '\n' > "$WORK/kw-target.txt"
```

**`--gate-text` / `--tex` fixture overrides + `mktemp` scratch + EXIT trap** (phase4 `:114-122`, `:251-256`) — copy verbatim; the `--gate-text` flag is what proves each assertion failable (negative control; prints a NON-certification notice at `:287-289`).

**Assertion classes to author** (per RESEARCH §Harness (d)):
- Multi-word literals on `$SQUEEZED`: `CUDA graphs`, `Flash Attention`, `ONNX Runtime`, `PyTorch Lightning`, plus concept phrases (`tensor parallelism`, `pipeline parallelism`, `Mixture of Experts (MoE)`, `KV-cache management`, `continuous batching`).
- Single-token needles on `$GATE`: `A100`, `H100`, `Triton`, `Rust`, `KEDA`, `Iceberg`, `vLLM`, `Spark`, `Ray`, `FSDP`, `Kubernetes`.
- Absence (honesty): `speculative decoding` on `$SQUEEZED`, `Go` word-boundary — note `gcount -Fc` is SUBSTRING; for `Go` use a word-boundary approach (harness `G6.7` uses `-w`), do not `-Fc 'Go'` (matches "Google" etc.).
- Promotions: `assert_promoted "..." 'ONNX'`, `... 'CUDA graphs'`, `... 'Iceberg'` (H100's promotion stays in the phase-3 net via the P3.44 flip).

**Footer** (phase4 `:423-430`): `>> PASS/FAIL` summary + `exit 0/1`; `die2` → exit 2 (cannot-verify, never conflated with FAIL).

---

### `scripts/verify-phase3-regressions.sh` (test, MODIFY — in-place needle flips)

**Analog:** itself. IDs are auto-numbered by call order (`emit()` `:238-244`), so **flip in place at the same call position** to preserve `P3.44`/`P3.65`. Do NOT renumber. Signatures differ by arg count: `assert_promoted` = 2 args, `assert_present` = 3, `assert_absent` = 4.

**`P3.44` — current (L886), flip `assert_absent`→`assert_promoted 'H100'`:**
```bash
assert_absent "EXP-03b/03-04 accelerator keyword demoted by owner finalization (whitespace-squeezed text layer)" 'H100' "$SQUEEZED" \
    "Owner removed H100 from page 1 in 798c0fb; ..."
```
Neighbours at L877–888 are the existing promotion triple — this is the shape to match:
```bash
assert_promoted "EXP-03b/03-05 keyword promoted in the same commit that landed it" 'torch.compile'   # P3.42
assert_promoted "EXP-03b/03-04 keyword promoted in the same commit that landed it" 'A100'            # P3.43
# P3.44 -> flip to: assert_promoted "..." 'H100'
assert_promoted "EXP-03b/03-05 keyword promoted in the same commit that landed it" 'Triton'          # P3.45
```

**`P3.65` — current (L1016), flip `assert_absent`→`assert_present 'H100' "$GATE"`:**
```bash
assert_present "EXP-04b/03-04 accelerator keyword (raw extracted lines, normalization-proof)" 'A100' "$GATE"   # P3.64
assert_absent "EXP-04b/03-04 accelerator keyword demoted by owner finalization (raw extracted lines)" 'H100' "$GATE" \  # P3.65 -> flip to assert_present '...' 'H100' "$GATE"
    "Owner removed H100 from page 1 in 798c0fb; ..."
```

Both flips land in the SAME commit that adds `H100` to Skills + promotes it in the manifest ($GATE/$SQUEEZED are whole-document — skipping the flip reddens the P3 net mid-phase).

---

### `docs/verify/manifest.txt` (config, MODIFY)

**Analog:** its own `KEYWORDS_*` lines (L59–60). Promote by moving a field from `KEYWORDS_TARGET` to `KEYWORDS_REQUIRED` **with the `:phase` suffix STRIPPED** (a suffix-intact promotion makes G6.5 grep the text layer for `H100:5` and FAIL).

**Current (L59–60):**
```
KEYWORDS_REQUIRED=inference|distributed|Kubernetes|PyTorch|FSDP|Ray|vLLM|Rust|fault|KEDA|SQS|Spark|Flash Attention|A100|torch.compile|Triton
KEYWORDS_TARGET=ONNX:5|CUDA graphs:3|Iceberg:5|H100:5
```
Move `ONNX`, `CUDA graphs`, `Iceberg`, `H100` → `KEYWORDS_REQUIRED` (strip `:5`/`:3`); each in the commit that lands its keyword. Required key is `ONNX` (substring of printed `ONNX Runtime`). After promotion `KEYWORDS_TARGET` empties.

**`SKILLS_MAX_LINES` (L49):** already `=3`; NO change needed — `G6.14` WARN→pass happens automatically once Skills renders ≤3 lines. Do not disturb `SECTIONS` ordering (`G6.14` uses the terminal-section EOF fallback; `TECHNICAL SKILLS` must stay last).

**`WARN_OWNERS` (L66):** `G6.14:5` may stay or be re-pointed to `none`/`any` once satisfied — judgment call, not required.

---

### `docs/main.tex` `\section{Technical Skills}` (content, MODIFY — resolve by CONTENT, ~L289–295)

**Analog:** the current block itself. Reuse the `itemize` shape; swap the two content lines for 3 tier lines.

**Current shape (L289–295):**
```latex
\section{Technical Skills}
 \begin{itemize}[leftmargin=0.15in, label={}]
    \small{\item{
     Search Relevance, Recommendations, ... Contrastive Learning, Large Language Models \\
     \textbf{Frameworks/Libraries/Tools}{: Ray, Pytorch Geometric, Pytorch Lightning, ... vLLM, Django}\\
    }}
 \end{itemize}
```
Note current casing defect: `Pytorch Lightning`, `Pytorch` (lowercase-t) → fix to `PyTorch Lightning` exact casing. Rebuild as 3 `\\`-separated tier lines using `\textbf{Label}{: tokens}` per D-01 (`Languages & Inference` / `Training & Distributed` / `Concepts`). Purge all research-identity + generalist tokens (D-02). MEASURE line count via `make build` + pdftotext (never predict — Concepts line is the sole wrap-to-4 risk).

---

### `Makefile` (config, MODIFY)

**Analog:** the `REGRESS4` wiring. Add `REGRESS5 := scripts/verify-phase5-regressions.sh` after L32, and chain `@bash $(REGRESS5)` in BOTH recipes.

**Var block (L30–32):**
```make
REGRESS    := scripts/verify-phase2-regressions.sh
REGRESS3   := scripts/verify-phase3-regressions.sh
REGRESS4   := scripts/verify-phase4-regressions.sh
# add: REGRESS5   := scripts/verify-phase5-regressions.sh
```
**`verify:` recipe (L197–201)** — add `@bash $(REGRESS5)` before `@bash $(VERIFY)`:
```make
verify: $(PDF)
	@bash $(REGRESS)
	@bash $(REGRESS3)
	@bash $(REGRESS4)
	@bash $(VERIFY)
```
**`verify-regressions:` recipe (L231–234)** — append `@bash $(REGRESS5)`. Never prefix a recipe line with `-` or `|| true`. Also update the L194 comment's gating-invocation string to include `&& bash $(REGRESS5)`.

---

## Shared Patterns

### Two-stream text-layer convention (multi-word → `$SQUEEZED`, single-token → `$GATE`)
**Source:** `scripts/verify-phase4-regressions.sh:270-284` (setup), STATE.md `[Phase 04 / close]` (standing rule)
**Apply to:** every assertion in the new phase-5 net. `pdftotext` wraps multi-word phrases across lines → a raw-`$GATE` absence check false-passes on a wrapped regression. Single tokens carry no whitespace → stay on `$GATE`.

### Every assertion proven failable (`--gate-text` negative control)
**Source:** `scripts/verify-phase4-regressions.sh:93-97, 117-118, 287-289`
**Apply to:** the whole phase-5 net. "An assertion never observed failing is not a gate" (Phase-1 rule). A run carrying `--gate-text` prints an explicit non-certification notice and no build target may pass it.

### `emit()` id auto-numbering by call order
**Source:** `scripts/verify-phase3-regressions.sh:238-244` / `verify-phase4-regressions.sh:134-142`
**Apply to:** new net (P5.n) AND the in-place P3 flips — replacing a call at the same position preserves its id; renumbering breaks STATE.md citations.

### `assert_promoted` three-conjunct promotion gate (the ONLY machine-backed promotion)
**Source:** `scripts/verify-phase3-regressions.sh:410-438` (+ manifest plumbing `:565-570`, `--manifest` arg `:221`)
**Apply to:** the 3 new promotions (`ONNX`/`CUDA graphs`/`Iceberg`) in the phase-5 net; `H100` via the P3.44 flip. `G6.5`/`G6.6` are convention, not a gate — every promotion needs an `assert_promoted`.

### bash 3.2.57 / `LC_ALL=C` / `set -uo pipefail` / no-errexit aggregation
**Source:** both nets' headers (`verify-phase4:57-65`)
**Apply to:** the new net — no associative arrays, no `mapfile`, no `local`, no case-converting expansion; feed loops via redirect/here-doc never a pipe (subshell would lose `emit` increments).

## No Analog Found

None. Every file has an in-repo analog; this is a self-contained LaTeX + shell repo with zero external packages.

## Metadata

**Analog search scope:** `scripts/`, `docs/`, `Makefile`, `docs/verify/`
**Files scanned:** 6 (2 nets, main.tex, manifest, Makefile, CONTEXT/RESEARCH)
**Pattern extraction date:** 2026-08-24
