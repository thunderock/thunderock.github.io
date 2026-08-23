# Phase 3: Adobe Rebuild & Staff-Signal Bullets - Pattern Map

**Mapped:** 2026-08-22
**Files analyzed:** 4 modified (`docs/main.tex`, `Makefile`, `docs/verify/manifest.txt`, tracked build artifacts) + 1 created (`scripts/verify-phase3-regressions.sh`) + 1 record-only (`.planning/STATE.md`)
**Analogs found:** 6 / 6 — every edit site and the one new file have an in-repo analog; nothing is unprecedented in *shape*

> **Three copy-paste traps this mapping found in the analogs that RESEARCH.md does not name.** All three come from treating `scripts/verify-phase2-regressions.sh` as a verbatim template, which is exactly what CONTEXT invites:
>
> 1. **T-1 (silent-death, HIGH)** — `assert_whole_line_once` (P2 net `:228-239`) is documented `<label> <needle> <file>` but its FAIL branch dereferences **`$4`**. Under `/bin/bash` 3.2.57 + `set -u`, a 3-arg call **kills the whole script with `$4: unbound variable` and exit 1** the instant that assertion fails — no `RESULT` line, no `FAILURES` increment, **every remaining assertion skipped**, and the exit code masquerades as "the document is wrong" (reproduced live, §5.1). Invisible while the document is green.
> 2. **T-2 (ID collision)** — the `P2.` prefix is hardcoded *inside* `emit` and `FAILED_IDS` (`:130-138`). A copy that forgets both spots emits `RESULT P2.<n>` lines from the P3 file, colliding with the real net in the concatenated stream the P2 header advertises. Rename **three** things: `P2_SEQ`, the `printf` prefix, the `FAILED_IDS` append. §5.2.
> 3. **T-3 (missing input stream)** — the P2 net has slots for exactly **three** inputs (`--pdf`, `--tex`, `--frozen`). P3.9–P3.11's promotion-pairing assertions need a **fourth**: `docs/verify/manifest.txt`. Copying the template verbatim leaves those assertions with nothing to read. Four coordinated additions required (arg, default, precondition, helper). §5.3.
>
> **One RESEARCH recommendation refined:** the governance-topic analog is **not** the `\resumeTopic` + nested-list shape (`main.tex:152-157`) but the **topic-only** shape (`main.tex:163/164/165`) — three live examples, zero nested lists, which is precisely the 2-rendered-line form Pitfall 8 says must ship. §2.2.

---

## 1. File Classification

| New/Modified file | Role | Data flow | Closest analog | Match |
|---|---|---|---|---|
| `docs/main.tex:151` (Adobe lead bullet, D-01) | template / content | text-layer emission | itself + `\resumeItem` macro `main.tex:76-78` | exact (in-file) |
| `docs/main.tex:152,158` (2 topics **with** nested lists, D-03) | template / content | in-place reword | each other (`:152-157` ↔ `:158-162`) | exact (in-file) |
| `docs/main.tex:163,164,165` (3 topic-only groups, D-03/D-06) | template / content | in-place reword | each other + `main.tex:177,178,179` (Swiggy topic-only) | exact (in-file) |
| `docs/main.tex` **NEW governance topic** (D-02) | template / content | text-layer emission | `main.tex:163` (Build & Deployment — topic-only, 2 rendered lines, carries `Rust`) | exact (in-file) |
| `docs/main.tex:154-156,160-161` (nested items, D-05 swap) | template / content | in-place reword (+1 line) | each other; `:155` is the D-05 target itself | exact (in-file) |
| `docs/main.tex:172-179` (Swiggy, D-09) | template / content | in-place reword (line-neutral) | `main.tex:152-157` (same topic+nested shape) | exact (in-file) |
| `docs/main.tex:186-192` (Flipkart, D-10) | template / content | in-place reword (line-neutral) | `main.tex:186-192` itself; `:188-191` mirrors `:152-157` | exact (in-file) |
| **`scripts/verify-phase3-regressions.sh`** (NEW) | test harness / assertion script | files-in → `RESULT` stdout + 0/1/2 exit | **`scripts/verify-phase2-regressions.sh`** (whole file, 525 ln) | exact |
| └ P3.1 lead-bullet region clause | test assertion | region scan | `verify-resume.sh:405-414` `region_first_nonempty` + P2 net `:251-260` `region_line_of` | exact (adapt) |
| └ P3.9–P3.11 promotion pairing | test assertion | text-layer × config cross-check | **partial** — P2 net's dual source+text `assert_absent` pairs (`:495-509`) is the closest shape; no existing assertion reads the manifest | role-match, see §4 |
| `Makefile` (target + `.PHONY` + header index + chain) | build config | orchestration | `Makefile:180-187` (`verify` / `verify-selftest` / `verify-baseline`) | exact |
| `docs/verify/manifest.txt:53-54` (keyword promotion) | config (phase-mutable) | key/value | its own `:51-52` rule comment + the live `:53`/`:54` values | exact |
| `docs/verify/manifest.txt:60` (`G6.13:unassigned`→`3`) | config (phase-mutable) | key/value | the live `G5.4:3` and `G6.6:3` entries on the same line | exact |
| `docs/AshutoshTiwari.{pdf,log,fdb_latexmk}` | build artifact (**tracked**) | regeneration | commits `933778e`, `29999ff` (Phase 2 content commits) | exact |
| `.planning/STATE.md` (D-08, EXP-08, SITE handoff markers) | decision record | doc | `01-01-PLAN.md:139` `[Phase 1 / A1]` marker pattern | exact (per RESEARCH §Checkpoint Mechanics) |

---

## 2. Pattern Assignments — `docs/main.tex`

### 2.1 The macros (do not redefine — reuse)

```latex
% main.tex:76-78
\newcommand{\resumeItem}[1]{%
  \item\small{\justifying #1}%
}

% main.tex:109-111 — bold topic name, colon, then the inline claim sentence
\newcommand{\resumeTopic}[2]{%
  \item\small{\justifying \textbf{#1}: #2}%
}

% main.tex:120-121
\newcommand{\resumeItemListStart}{\begin{itemize}}
\newcommand{\resumeItemListEnd}{\end{itemize}}

% main.tex:113-114 — level-3 marker
\renewcommand{\labelitemiii}{\small\textendash}
```

**Measured extraction contract (live, read-only `pdftotext` this session).** Every Adobe bullet — at *both* itemize-2 and itemize-3 depth — extracts with a leading `– ` (U+2013 + space):

```
 9  ADOBE FIREFLY                                                    <- \resumeSubheading #3
10  GENERATIVE AI, COMPUTER VISION, LARGE LANGUAGE MODELS            <- #4  (NO blank line after)
11  – Leading parts of the org’s MLOps platform for building, …      <- :151 lead \resumeItem
12  Kubernetes, spanning the full ML lifecycle from data …           <- continuation (76 chars)
13  – Distributed Inference Frameworks: Designed and led …           <- :152 \resumeTopic
15  – Built online inference on vLLM + Ray … Falcon-40B and Llama 2 70B.   <- :154 (itemize-3)
```

Two consequences the plan depends on:
* **`G5.4`'s digit-bullet regex matches only these `–`-prefixed FIRST lines** — line 12/14/18 continuations start with a word. This is Pitfall 5, confirmed structurally.
* **Line 10 → 11 has no blank line between them.** P3.1's region-first clause can therefore anchor on the subtitle as `start` and take the *very next* non-empty line as the lead bullet. §3.1.

### 2.2 Governance topic (D-02) — copy the **topic-only** shape, not the nested one

Three live topic-only examples, all 2 rendered lines, all zero nested list:

```latex
% main.tex:163 — the closest analog: topic-only, 2 rendered lines (gate 23-24),
% and it is the sole carrier of the single-occurrence `Rust` BLOCKER keyword.
      \resumeTopic{Build \& Deployment System}{Built a CLI-driven build system (BuildKit images on KEDA-scaled Kubernetes jobs, pushed to ECR), fronted by a Rust control plane and an MCP interface for AI-agent-driven builds, deployments, and inference.}

% main.tex:164 — topic-only, 2 rendered lines (gate 25-26)
      \resumeTopic{Enrichment Service}{Orchestration and abstraction layer over the inference framework and other ML Platform offerings; runs fire-and-forget pipelines on datasets of billions of images and videos.}

% main.tex:165 — topic-only, 2 rendered lines (gate 27-28)
      \resumeTopic{Data Quality Framework}{Wrote the org’s first data quality framework on Cerberus, used across enrichment pipelines to validate the correctness of feature-generation outputs.}
```

**Why this and not `:152-157`:** RESEARCH Pitfall 8 measured `\resumeTopic` **+ nested `\resumeItemListStart` with one item = 4 rendered lines = the entire budget**. The three lines above are the shipped proof that a topic carries a full multi-clause claim in 2 lines with **no** nested list. Copy `:163`'s density (138 + 97 = 235 chars over 2 lines) as the governance group's length target.

**Ordering (agent's discretion, D-02/§Discretion):** insert as a new line anywhere in `:152-165`. Note `:163`'s `Rust` is single-occurrence — RESEARCH Pitfall 7 says land the governance group's second `Rust` **before or with** any `:163` reword.

### 2.3 Nested-list group (D-03/D-05) — the shape `:152` and `:158` share

```latex
% main.tex:152-157 — topic (2 rendered lines) + 3 nested items. :155 is D-05's target.
      \resumeTopic{Distributed Inference Frameworks}{Designed and led engineering for the org’s online and offline inference systems powering experimentation and production at scale.}
        \resumeItemListStart
          \resumeItem{Built online inference on vLLM + Ray for rapid experimentation with LLMs such as Falcon-40B and Llama~2~70B.}
          \resumeItem{Built offline inference on Ray Data + PyTorch Lightning, achieving 10--50$\times$ faster image loading and 3--8K images/sec on 32 GPUs.}
          \resumeItem{Modeled pipelines as horizontally-scaling Source $\to$ Transform $\to$ Sink plugins with no pod-to-pod communication, KEDA-autoscaled on SQS queue depth.}
        \resumeItemListEnd
```

Note the source-level idioms to preserve verbatim while rewording around them:
| Source | Extracts as | Keep because |
|---|---|---|
| `Llama~2~70B` | `Llama 2 70B` | D-03 mandates the claim survives; `~` is a non-breaking space |
| `$\times$` | `×` U+00D7 | in `NONASCII_ALLOW`; safe for the `8$\times$A100` / `24$\times$A100-40GB` figures |
| `Source $\to$ Transform $\to$ Sink` | `Source → Transform → Sink` | U+2192 in `NONASCII_ALLOW`; D-03/Pitfall 12 retain |
| `10--50` / `3--8K` | `10–50` / `3–8K` (U+2013) | **being deleted** — but the absence assertion must target the **rendered** EN DASH form (Pitfall 4) |
| `SQS queue depth` (`:156` tail, 16 chars) | gate line 18 | sole `SQS` carrier ⚠ + ~104 free tail chars |

### 2.4 Swiggy / Flipkart line-neutral pass (D-09/D-10)

Both blocks are the **same two shapes already inventoried above**, so the analog is in-file and exact:

```latex
% main.tex:172-176 — topic + nested list (mirrors :152-157). :175 is the sole `fault` carrier ⚠
        \resumeTopic{Online Inference Platform}{Core contributor to the online inference platform serving 18M+ monthly transacting users across food delivery and quick commerce, with models autoscaled by real-time load metrics.}
          \resumeItemListStart
            \resumeItem{Engineered a dynamic request-routing layer that evaluated incoming API calls against geo-tags, traffic profiles, and service metadata, then dispatched them to model clusters partitioned by region and load domain.}
            \resumeItem{Implemented routing/dispatch on an Akka-style actor framework for resilient asynchronous invocation, fault isolation across clusters, and backpressure-aware scheduling at sustained low P99 under high QPS.}
          \resumeItemListEnd

% main.tex:177 — topic-only. `Spark` (page-1 ×1) + the 4Bn/10K figures that sit on a CONTINUATION line
        \resumeTopic{Feature Store}{Built and maintained a Feature Store and pipeline serving on-demand features to deployed ML models at production scale (4Bn rows, 10K QPS), with multichannel ingestion via Spark, Flink, and user files.}

% main.tex:188-191 — Flipkart's D-10 site: topic + nested list. `---` extracts as U+2014 (allowed)
        \resumeTopic{ML Workflow Automation}{Built the first workflow at Flipkart to automate training and auto-deployment of search models---written first in Luigi and later migrated to Airflow.}
          \resumeItemListStart
            \resumeItem{Wrote a generic Airflow framework that creates DAGs at runtime for different ML models and orchestrates the train$\rightarrow$deploy flow, including data and model validations.}
          \resumeItemListEnd
```

**D-11 line-neutrality is a *rendered*-line property, not a char-count one.** Measure it as RESEARCH §V-EXP-07c specifies: gate regions **36–46 = 8 lines (Swiggy)** and **54–62 = 9 lines (Flipkart)** unchanged before/after. Char counts may move freely inside a line.

### 2.5 The folded-descriptor carrier (Phase 2's shape) — the **sanctioned lever, do not pull by default**

```latex
% main.tex:199 (Groupon) and :206 (NetSpeed) — the P2 fold: \resumeItem wrapping one \textit{}
        \resumeItem{\textit{Customer segmentation and deal-recommendation ML (NSVD unsupervised collaborative filtering on Neo4j); Cyclops customer-service platform live in every Groupon country.}}

        \resumeItem{\textit{C++ graph algorithms for Network-on-Chip interconnects: Virtual Channel Arbitration, Polarity-based Arbitration, Multi-Cast Filtering, Structural Latency Breakdown.}}
```

D-11 + CONTEXT `<deferred>`: touch these **only** if the Adobe rebuild measurably runs out of room, and then only as a *reword-shorter*. Every literal in both lines is asserted by the P2 net (`:445-456`, `:484-490`) and two shortened forms are explicitly forbidden (`:495-509`). A reword must keep all 12 literals and avoid both forbidden forms.

---

## 3. Pattern Assignments — `scripts/verify-phase3-regressions.sh` (NEW)

**Analog: `scripts/verify-phase2-regressions.sh`, copied whole.** Confirmed live this session: **27 RESULT lines, 27 PASS, exit 0**, mode `755`. Copy the file, then apply §5's four mechanical changes.

### 3.1 P3.1 — the lead-bullet region clause (EXP-02a)

Two helpers combine. From the harness (`verify-resume.sh:405-414`) — the *anchor-free* region primitive, and its rationale is exactly P3.1's:

```bash
# region_first_nonempty <start> <end> -> the absolute gate.txt line number of the
# first non-blank line inside the range, or empty.
region_first_nonempty() {
    if [ "$1" -lt 1 ] || [ "$1" -gt "$2" ]; then
        return 0
    fi
    _rfn=$(sed -n "$1,$2p" "$WORK/gate.txt" | LC_ALL=C grep -n -m1 '[^[:space:]]' | cut -d: -f1)
    if [ -n "$_rfn" ]; then
        printf '%s\n' "$(($1 + _rfn - 1))"
    fi
    return 0
}
```

From the P2 net (`:243-260`) — whole-line anchor lookup, already present in the template:

```bash
gate_line_of() {
    LC_ALL=C grep -n -Fx -m1 -- "$1" "$WORK/gate.txt" 2>/dev/null | cut -d: -f1
    return 0
}
```

**Composition for P3.1** (subtitle is the `\resumeSubheading` `#4` cell, extracted whole at gate line 10; line 11 is the lead bullet with no blank between):

```bash
SUB='GENERATIVE AI, COMPUTER VISION, LARGE LANGUAGE MODELS'
SUB_AT=$(gate_line_of "$SUB")
if [ -z "$SUB_AT" ]; then
    emit FAIL "EXP-02a lead-bullet voice: the Adobe subtitle '$SUB' does not extract as a whole line, so the block's opening line is unmeasurable -- check the harness's G5.x first"
else
    LEAD_AT=$(region_first_nonempty "$((SUB_AT + 1))" "$((SUB_AT + 4))")
    ...match the line's text against the locked anchors (fault-tolerant|fault-tolerance|distributed inference)...
fi
```

Follow the P2 net's **three-branch discipline** everywhere (`:374-398` is the model): *unmeasurable* → FAIL with "the verdict is UNKNOWN, which is never a pass"; never a silent skip.

### 3.2 P3.2–P3.30 — literal assertions: the dual-stream rule

The P2 net's own header (`:42-48`) states the rule; copy it verbatim in the P3 header:

```bash
# multi-word literals -> whitespace-SQUEEZED stream (pdftotext breaks them at wrap points)
assert_present "EXP-03 torch.compile production claim" 'torch.compile(mode="max-autotune")' "$SQUEEZED"
# whitespace-free short tokens -> RAW lines too, so the squeeze can never be what passes it
assert_present "EXP-04 A100 fleet figure" 'A100' "$GATE"
# removed figures -> absent in BOTH streams, EN DASH form (Pitfall 4)
assert_absent  "EXP-04 unverified speedup retired" '10–50' "$SQUEEZED" "Restore an evidenced figure; do not reintroduce the unprovenanced range."
```

The batch idiom (`:441-456` / `:481-490`) — a here-doc, **never a pipe**, because `emit` mutates `FAILURES` in the current shell:

```bash
while IFS= read -r LIT; do
    [ -n "$LIT" ] || continue
    assert_present "EXP-02b/c locked Phase-3 literal (whitespace-squeezed text layer)" "$LIT" "$SQUEEZED"
done <<'LITERALS'
27,135
claim/receipt
immutable S3 evidence layouts
Falcon-40B
Llama 2 70B
SQS queue depth
Flash Attention
1.09M
LITERALS
```

Note `Llama 2 70B` here is the **rendered** form (source is `Llama~2~70B`) — assert what `pdftotext` emits, matching how the P2 net asserts `Aug. 2021 – May 2023` with the U+2013 the source writes as `--`.

### 3.3 The five helper signatures to copy verbatim

| Helper | P2 net lines | Args | Use in P3 |
|---|---|---|---|
| `emit <PASS\|FAIL> <msg>` | `:130-138` | 2 | every assertion; **rename the prefix** (T-2) |
| `die2 <msg>` | `:142-145` | 1 | preconditions only; exits 2, emits no RESULT |
| `gcount <flags> <needle> <file>` | `:155-162` | 3 | the `-1` sentinel is load-bearing — keep it |
| `assert_present <label> <needle> <file>` | `:179-190` | 3 | retained claims, new figures, keywords |
| `assert_absent <label> <needle> <file> <remedy>` | `:210-221` | **4** | retired figures (both streams + source), EXP-08 drafts |
| `assert_whole_line_once <label> <needle> <file> <remedy>` | `:228-239` | **4** ⚠ | only if a whole-line clause is needed — **see T-1** |
| `display_of <path>` | `:168-175` | 1 | stable labels; extend if a 4th stream is added (§5.3) |

---

## 4. Pattern Assignments — `Makefile`, `manifest.txt`, artifacts

### 4.1 `Makefile` — the `verify-regressions` target

Analog (`Makefile:180-187`) — three targets, one shape: a `## `-suffixed doc comment, a single `@bash $(VAR)` recipe line:

```make
verify: $(PDF)  ## Gate the PDF: page budget, page-1 boundary, ATS text layer, honesty freeze
	@bash $(VERIFY)

verify-selftest:  ## Prove the gates fire: overflow probe + five negative controls
	@bash $(VERIFY) --selftest

verify-baseline:  ## Regenerate docs/verify/manifest.txt (honesty freeze needs ALLOW_FROZEN_UPDATE=1)
	@bash $(VERIFY) --write-baseline
```

Four coordinated edit sites (RESEARCH §Harness Wiring gives the recipe text; these are the *locations*):

| Site | Line | Edit |
|---|---|---|
| Header target index | `:4-15` | add `#   make verify-regressions - standing content-regression assertions (P2.x)` — this block is IG-02's "canonical surface" |
| Variable block | `:28` (`VERIFY := scripts/verify-resume.sh`) | add `REGRESS := scripts/verify-phase2-regressions.sh` beside it |
| `.PHONY` | `:53` | append `verify-regressions` to the single-line list |
| Verification section | `:180-187` | new target + chain `@bash $(REGRESS)` **first** in `verify`'s recipe |

**Note the `verify-selftest` / `verify-baseline` precedent: neither carries a `$(PDF)` prerequisite.** Only `verify` does. So the new target's "no prerequisite" design (RESEARCH) is the *majority* pattern here, not an exception.

**Cosmetic, worth one line of awareness:** `make help` (`:57-59`) greps `'^[a-zA-Z_-]+:.*?## .*$$'` and formats with `%-16s`. `verify-regressions` is **18 chars** — the first target to exceed the column, so its help line will shift right by 2. Harmless; do not widen the format string (it would reflow every other line).

### 4.2 `docs/verify/manifest.txt` — two one-line edits

The file's own header (`:1-6`) authorizes both: *"Thresholds here are meant to move as phases land."*

```
# --- Keyword tiers. Promotion = move an entry from KEYWORDS_TARGET to KEYWORDS_REQUIRED
# --- in the same commit that adds the keyword. Present today = BLOCKER; absent = WARN.
KEYWORDS_REQUIRED=inference|distributed|Kubernetes|PyTorch|FSDP|Ray|vLLM|Rust|fault|KEDA|SQS|Spark|Flash Attention
KEYWORDS_TARGET=torch.compile:3|A100:3|H100:3|ONNX:5|CUDA graphs:3|Iceberg:5|Triton:5
```
`:53` append (suffix **stripped**, Trap A) · `:54` remove the same entries. Note `Flash Attention` proves a **space-bearing** value is legal in `KEYWORDS_REQUIRED`, so `CUDA graphs` *could* be promoted mechanically — CONTEXT `<deferred>` says don't.

```
# --- Sentinels: none = corroborating only, nothing to promote; unassigned = real deviation
# --- with no owning requirement yet; any = the next phase touching that surface owns it.
WARN_OWNERS=G4.3:none|G5.4:3|G6.6:3|G6.13:unassigned|G6.14:5|G6.4:any
```
`:60` — `G6.13:unassigned` → `G6.13:3`. The two live `:3` entries on the same line are the format proof. `warn_owner` (`verify-resume.sh:213-221`) renders a numeric token verbatim; the assertion sites then print `(owner: 3)`-derived text for all **five** `G6.13` WARN lines.

**Do not add `ROLE_BIND_WINDOW`** — it is a deliberate local constant at `verify-resume.sh:1936`, and `:2045`'s comment names it as the canonical example of a local constant. Phase 3 claims the WARN; it does not promote the gate.

### 4.3 Tracked build artifacts — the commit shape

Phase 2's two content commits are the exact analog. Both are **one commit containing source + artifacts**:

```
933778e feat(02-01): fold Groupon and NetSpeed to header plus one italic descriptor
 docs/AshutoshTiwari.fdb_latexmk |   8 ++++----
 docs/AshutoshTiwari.log         |   4 ++--
 docs/AshutoshTiwari.pdf         | Bin 225154 -> 225740 bytes
 docs/main.tex                   |   4 ++--

29999ff feat(02-02): drop the Education city cells and bind the date to the degree row
 docs/AshutoshTiwari.fdb_latexmk |   8 ++++----
 docs/AshutoshTiwari.log         |   4 ++--
 docs/AshutoshTiwari.pdf         | Bin 225740 -> 225703 bytes
 docs/main.tex                   |   8 ++++----
```

Exactly **four** files per content commit — `.pdf` + `.log` + `.fdb_latexmk` + `.tex`. This **supersedes** the older `build(resume): regenerate` split-commit precedent quoted in `02-PATTERNS.md §6`; Phase 2 Decision 5 replaced it because a source-only commit refuses at `G0.3` exit 2 on fresh checkout. `.aux`/`.fls`/`.out` are also tracked (`git ls-files docs/`) but did not change in either commit — include them if they do.

**Commit message shape** (`git log`): `<type>(<NN>[-<PP>]): <imperative lowercase>` — `feat(03-01):`, `test(03):`, `docs(03):`, `chore(03-02):`. Per `general.md`: no tooling terminology in the message.

---

## 5. Shared Patterns

### 5.1 T-1 — the `$4` silent-death trap (apply to **every** copied helper)

`assert_whole_line_once` (`:228-239`) documents 3 args, dereferences `$4`:

```bash
# assert_whole_line_once <label> <needle> <file> -- exactly one whole extracted
assert_whole_line_once() {
    _awl=$(gcount -Fxc "$2" "$3")
    ...
    else
        emit FAIL "$1: '$2' appears $_awl time(s) as a whole extracted line in $_awld (want exactly 1) -- $4"
    fi
```

**Reproduced under `/bin/bash` 3.2.57 with `set -uo pipefail` (no errexit):** a 3-arg call whose assertion *fails* prints `line N: $4: unbound variable`, **exits 1 immediately**, emits **no** `RESULT` line, never increments `FAILURES`, and **skips every remaining assertion**. Exit 1 reads as "the document is wrong", so it is indistinguishable from a real regression in a log — while actually meaning "the net stopped running".

Mitigations for the new script, in preference order:
1. Fix the signature in the copy: `${4:-see the plan's locked-literal table}` (bash-3.2-safe default expansion), and correct the doc comment to `<label> <needle> <file> <remedy>`.
2. Never call it with 3 args (also correct, but T-1 is invisible until the day it fails).
3. Same audit for `assert_absent` (`:210-221`) — genuinely 4-arg, documented as 4-arg, so it is safe today; keep it that way.

### 5.2 T-2 — three renames when copying `emit`

```bash
FAILURES=0
FAILED_IDS=""
P2_SEQ=0                                              # (1) rename -> P3_SEQ

emit() {  # emit <PASS|FAIL> <message>
    P2_SEQ=$((P2_SEQ + 1))
    printf 'RESULT %-6s %-5s %s\n' "P2.$P2_SEQ" "$1" "$2"     # (2) "P3.$P3_SEQ"
    if [ "$1" = FAIL ]; then
        FAILURES=$((FAILURES + 1))
        FAILED_IDS="$FAILED_IDS P2.$P2_SEQ"                   # (3) "P3.$P3_SEQ"
    fi
    return 0
}
```

Plus the two summary `printf`s at `:519`/`:523` ("Phase-2 regression assertion(s)"), the `usage()` text (`:75-101`), and the whole header block. The P2 header (`:26-30`) is explicit that the prefix is what keeps the two streams concatenable — honoring it is a correctness property, not cosmetics.

### 5.3 T-3 — adding `manifest.txt` as a fourth input stream

The P2 net's three-input scaffold, and where each addition goes:

```bash
# :64-67  defaults
PDF="${VERIFY_PDF:-docs/AshutoshTiwari.pdf}"
TEX="${VERIFY_TEX:-docs/main.tex}"
FROZEN="docs/verify/baseline-frozen.txt"
GATE_TEXT=""
#                              (a) add: MANIFEST="docs/verify/manifest.txt"

# :109-118  arg parsing — one case arm per option, each with its own arity guard
        --frozen)    [ $# -ge 2 ] || { printf '!! --frozen needs a PATH\n' >&2; exit 2; }; FROZEN="$2"; shift 2 ;;
#                              (b) add the identical arm for --manifest

# :277-278  preconditions — "cannot verify" (exit 2), never a FAIL
[ -f "$TEX" ] && [ -s "$TEX" ] || die2 "LaTeX source missing or empty: $TEX"
[ -f "$FROZEN" ] && [ -s "$FROZEN" ] || die2 "honesty freeze missing or empty: $FROZEN"
#                              (c) add: [ -f "$MANIFEST" ] && [ -s "$MANIFEST" ] || die2 "verification manifest missing or empty: $MANIFEST"
```

**(d)** the promotion-pairing helper itself. RESEARCH E-5 supplies the logic; render it in the P2 net's house style — `gcount`-based where possible, three-branch verdicts, `LC_ALL=C`, `-1` for unmeasurable. Its three conjuncts:

```bash
# assert_promoted <label> <literal>  -- all three must hold in the same commit:
#   1. the literal is in the text layer            ($GATE, -F)
#   2. it is a whole pipe-field of KEYWORDS_REQUIRED  (grep -qxF after tr '|' '\n')
#   3. no KEYWORDS_TARGET field starts "<literal>:"  (the :phase suffix, Trap A)
```

Conjunct 2 **must be whole-field** (`-Fx` after `tr '|' '\n'`), not substring — a substring test would let `A100` pass on a hypothetical `A100-40GB` field. This is the same reasoning the P2 net's `assert_whole_line_once` comment (`:223-227`) gives for whole-line matching.

Also extend `display_of` (`:168-175`) with a `"${MANIFEST:-}"` arm so the RESULT text reads "the verification manifest" rather than a bare path — the function exists precisely so labels stay stable across runs.

### 5.4 The script skeleton (copy the ordering, it encodes six constraints)

```bash
#!/usr/bin/env bash                              # :1
set -uo pipefail                                 # :58   NO errexit -- assertions must aggregate
...defaults... ...usage()... ...arg parse...      # :64-118
...emit/die2/gcount/display_of/assert_*...        # :130-260
...preconditions -> die2 (exit 2, no RESULT)...   # :267-278
WORK=$(mktemp -d) || die2 ...                     # :284-288
trap 'if [ -n "${WORK:-}" ] && [ -d "${WORK:-}" ]; then rm -rf "$WORK"; fi' EXIT   # :289  inline, single-quoted
pdftotext "$PDF" "$WORK/raw.txt" || die2 ...      # :303-309
tr '\f' '\n' < raw.txt   > gate.txt               # :311  form-feed -> newline (NOT cosmetic)
tr -s ' \t\n' ' ' < gate.txt > squeezed.txt       # :313  one-line squeeze
[ -s ... ] || die2 "refusing to report a verdict measured against nothing"   # :312,:314
printf '>> Inputs: pdf=%s tex=%s frozen=%s\n' ... # :329  input banner
...assertion groups...                            # :334-509
printf '>> Groups run: ...\n'                     # :516
[ "$FAILURES" -eq 0 ] && { printf '>> PASS: %s ... assertion(s), 0 failures.\n' "$P2_SEQ"; exit 0; }
printf '!! FAIL: %s of %s ...:%s\n' "$FAILURES" "$P2_SEQ" "$FAILED_IDS"; exit 1   # :518-525
```

Hard constraints this ordering carries (all from the P2 net's own comments, all measured):
* **bash 3.2.57** — no arrays, no `mapfile`, no `local`, no `[[`, no `${x,,}`. Both existing scripts hold this bar; `/bin/bash` is 3.2.57 while PATH `bash` is 5.3.15.
* **`emit` never inside a pipeline or `$( )`** — the `FAILURES` increment would be lost in a subshell. Feed `while read` from a redirect or here-doc.
* **`LC_ALL=C` on every grep** — byte-exact matching for U+2013 / U+00D7 / U+2192.
* **`>> ` progress / `!! ` error prefixes**, machine-readable `RESULT` lines first.
* **read-only** — never writes inside `docs/`, never rebuilds.
* **`chmod 755`** to match both siblings (`-rwxr-xr-x`), even though `bash $(REGRESS)` does not require it.

### 5.5 The per-commit measurement loop (unchanged from Phase 2, extended)

```bash
make build
bash scripts/verify-resume.sh            # the ORACLE -- never `make verify` (Make 3.81 collapses 1 and 2 to 2)
bash scripts/verify-phase2-regressions.sh
bash scripts/verify-phase3-regressions.sh
```
Read in order: `G1.1` (fit — the primary alarm) → `G2.1` → **`G3.2` p1 headroom, recorded in pt *and* lines** → `G5.4`'s *value* → `G6.5` ×13 → `G6.6` → `G6.4`. Add `make verify-selftest` per wave; **no wave may end net-freed** (`G7.2`). Never `make clean` before verifying.

### 5.6 The negative control (anti-tautology) — Phase 2's proven shape

```bash
W=$(mktemp -d); git show "$PRE:docs/main.tex" > "$W/main.tex"   # basename MUST stay main.tex
( cd "$W" && latexmk -pdf -interaction=nonstopmode -halt-on-error -jobname=AshutoshTiwari main.tex )
bash scripts/verify-phase3-regressions.sh --pdf "$W/AshutoshTiwari.pdf" --tex "$W/main.tex"
```
`--pdf`/`--tex` already exist in the template (`:111-112`), so this works the moment the file is copied. ⚠ **A promotion-pairing assertion cannot be negative-controlled this way** — `--manifest` would still point at the *current* manifest. Control it by pointing `--manifest` at a scratch copy of the pre-promotion manifest (which the new `--manifest` arg makes possible — a second reason it must exist). The P2 net's `--gate-text` fixture flag (`:88-92`) is the precedent for a "this run certifies nothing" input override, including its stdout disclaimer at `:330-332`.

---

## 6. What NOT to touch (carried forward + Phase-3 additions)

| Surface | Location | Why |
|---|---|---|
| 5 frozen titles + dates (arg 1/2) | `main.tex:148,169,183,196,203` | `G5.1`/`G5.2` whole-line count exactly 1; source `--` extracts as U+2013 — that *is* the frozen byte |
| 5 frozen employers + subtitles (arg 3/4) | `main.tex:149,170,184,197,204` | `G5.5`; also P3.1's subtitle anchor lives on `:149` |
| `docs/verify/baseline-frozen.txt` | whole file | **immutable this phase** — nothing in D-01…D-15 changes a date/title/employer/geometry |
| `\setlist[itemize…]` ×3 · `\addtolength` ×5 | `main.tex:69-72`, `:38-42` | the `G4.1` geometry hash (source hash, any `\setlist` anywhere counts) |
| `\pdfgentounicode=1`, `\input{glyphtounicode}` | `main.tex:60`, `:15` | `G4.4` BLOCKER — voids every G5/G6 text-layer assertion |
| `\newpage` | `main.tex:211` | `G2.1` page-2 boundary |
| `scripts/verify-resume.sh` | whole file | 83 RESULT lines / 39 distinct IDs pinned by `02-02-PLAN.md` criterion 11; `G7`/`G8` count them |
| `scripts/verify-phase2-regressions.sh` | whole file | now gains an invoker, not an edit (IG-01) |
| `DIGIT_BULLET_FLOOR`, `PROBE_LINES` | `manifest.txt:48`, `:17` | lowering either to match a regression deletes the gate; `PROBE_LINES` is raise-only at a measured stable end-state |
| `ROLE_BIND_WINDOW` | `verify-resume.sh:1936` | deliberate local constant; the commit that *promotes* `G6.13` adds the key |
| `index.html:196` | — | carries both retired figures; **record in STATE.md, Phase 6 fixes** (RESEARCH OQ-2) |
| `.planning/` prose retaining the retired strings | ROADMAP:69, REQUIREMENTS:21, PROJECT.md:64, research/* | the record of what was retired and why — do not "clean" |

---

## 7. No Analog Found

| Change | Why no analog | Guidance |
|---|---|---|
| **Promotion-pairing assertion** (P3.9–P3.11) | No assertion anywhere reads `manifest.txt` as *data to cross-check*; the harness reads it as *configuration*, and the P2 net never opens it. The closest shape is the P2 net's dual source+text-layer `assert_absent` pairs (`:495-509`) — same "two independent inputs must agree" idea, both inputs textual. | Build `assert_promoted` from RESEARCH E-5, in P2 house style (§5.3d). Whole-field match on conjunct 2. |
| **Governance topic *content* framing** (D-02) | No live topic is framed as Rust fault-tolerant distributed systems. `main.tex:163` carries `a Rust control plane` but frames a build system. | Copy `:163`'s *density and shape*, take the *framing* from `CODEBASE-EVIDENCE.md`'s binding rule (never inference optimization). Structure is analogous; wording is new. |
| **`checkpoint:decision gate="blocking"` for EXP-08** | No checkpoint task exists in Phase 2 or 3 artifacts. | `01-01-PLAN.md:139` is the verbatim schema (RESEARCH §Checkpoint Mechanics transcribes it); reuse its `[Phase N / ID]` literal-marker + `grep -Fc … \| grep -q '^1$'` completion pattern with `[Phase 3 / EXP-08]` and `[Phase 3 / D-08]`. |
| **`checkpoint:human-verify` for D-08** | Same. | Same schema, `human-verify` type; pre-authorized Triton-only fallback so an unavailable read cannot block the phase. |
| **A `make` target invoking a phase-regression net** | `verify`/`verify-selftest`/`verify-baseline` all invoke `$(VERIFY)` with flags; none invokes a *second script*. | The three-target shape (`:180-187`) is still the analog — only the variable changes (`$(REGRESS)` beside `$(VERIFY)` at `:28`). Genuinely trivial; flagged only for honesty. |

---

## Metadata

**Analog search scope:** `docs/main.tex` (332 ln, read whole) · `scripts/verify-phase2-regressions.sh` (525 ln, read whole) · `Makefile` (214 ln, read whole) · `docs/verify/manifest.txt` (60 ln, read whole) · `scripts/verify-resume.sh` (2086 ln — targeted non-overlapping reads at `:205-244`, `:388-442`, `:1718-1762`; `grep` for `region_first_nonempty`/`warn_owner`/`KEYWORDS_TARGET`/`G6.13`/`ROLE_BIND_WINDOW`) · `.planning/phases/02-page-1-budget-text-layer-defects/02-PATTERNS.md` (358 ln) · `git log`/`git show --stat` for `933778e`, `29999ff`, `git ls-files docs/`.
**Read-only measurements taken:** `pdftotext docs/AshutoshTiwari.pdf` → gate lines 1-30 with per-line char counts (confirms the `– ` bullet prefix at both itemize depths, the no-blank-line subtitle→lead-bullet adjacency P3.1 needs, and the free-tail figures) · `bash scripts/verify-phase2-regressions.sh` → 27 RESULT / 27 PASS / exit 0 · `ls -l scripts/` → both nets mode 755 · a `/tmp` bash-3.2.57 probe reproducing T-1's unbound-`$4` silent death. **No repo file was modified; no build was run.**
**Pattern extraction date:** 2026-08-22
