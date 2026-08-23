# Phase 3 Decision Record — Adobe Rebuild & Staff-Signal Bullets

**Written:** 2026-08-23 · **Plan:** 03-03 · **Status:** authoritative for waves 2–4

This is a **plan artifact, not a `docs/main.tex` artifact** (`03-CONTEXT.md` `<specifics>`, fourth
bullet). Nothing here is ever copied into the resume source. Its four jobs:

1. **Criterion 1** — a retain / revise / retire disposition for every current Adobe entry, recorded
   *before* any new text is written. Commit ordering is the proof.
2. **Criterion 3** — a figure → evidence traceability table, so no figure ships unprovenanced.
3. **The budget ledger** — the measured page-1 spend authority every content plan draws against.
4. **The EXP-08 drafts** — ⚠-flagged candidates that live *here* and nowhere else.

**Why this document exists at all.** `03-RESEARCH.md` §Pitfall 12 (citing `PITFALLS.md:689-696`)
names the signature failure of this phase: rebuilding the Adobe block from
`.planning/research/CODEBASE-EVIDENCE.md` alone makes everything that file does not restate look
like it was never there. `Falcon-40B`, `Llama 2 70B`, `Source → Transform → Sink` and
KEDA-on-SQS-depth are **not** in the evidence file. That makes them *unverified by that particular
mining pass* — **not false**. D-03 therefore mandates retain-and-revise, and the table below is the
mechanism that makes an implicit drop impossible to commit by accident.

**Measurement provenance.** Every count, line number, pt figure and character length in this
document was measured live on 2026-08-23 against the committed artifact at
`29999ff` (`docs/main.tex` + `docs/AshutoshTiwari.pdf`), using
`pdftotext docs/AshutoshTiwari.pdf - | tr '\f' '\n'` for gate lines and
`bash scripts/verify-resume.sh` for the gate values. Nothing below is predicted.

---

## Section 0 — Criterion-1 disposition table

**Ordering proof.** At the time of this commit, `git log --oneline -1 -- docs/main.tex` reports
`29999ff feat(02-02): drop the Education city cells and bind the date to the degree row` — a
**Phase 2** commit. No Phase-3 content edit has happened. The disposition is recorded first, as
ROADMAP criterion 1 requires.

Columns: entry ID · `docs/main.tex` source line · shape · today's gate lines (page-1 `pdftotext`
line numbers) · today's rendered line count · digit-bearing (the `G5.4` flag) · **keywords
carried** · D-03 disposition.

| # | source | shape | gate lines | rendered | digit-bearing (`G5.4`) | keywords carried | disposition (D-03) |
|---|---|---|---|---|---|---|---|
| A1 | `main.tex:151` | `\resumeItem` (lead) | 11–12 | 2 | no | `inference`×2, `Kubernetes` | **revise** → D-01 fault-tolerance / distributed-inference voice |
| A2 | `main.tex:152` | `\resumeTopic{Distributed Inference Frameworks}` | 13–14 | 2 | no | `inference` | **retain-and-revise** |
| A3 | `main.tex:154` | nested `\resumeItem` (vLLM + Ray; Falcon-40B, Llama 2 70B) | 15 | 1 | **yes** | `inference`, `Ray`, `vLLM` | **retain-and-revise** — Falcon-40B and Llama 2 70B survive |
| A4 | `main.tex:155` | nested `\resumeItem` (offline inference) | 16 | 1 | **yes** | `inference`, `Ray`, `PyTorch` | **revise** → D-05 Ray-benchmark replacement (+1 rendered line) |
| A5 | `main.tex:156` | nested `\resumeItem` (Source → Transform → Sink; KEDA/SQS) | 17–18 | 2 | no | `KEDA`, ⚠ **`SQS`** ×1 | **retain-and-revise** — KEDA-on-SQS-depth and `Source → Transform → Sink` survive |
| A6 | `main.tex:158` | `\resumeTopic{Foundation Model Training Framework}` | 19–20 | 2 | no | `PyTorch` | **retain-and-revise** |
| A7 | `main.tex:160` | nested `\resumeItem` (FSDP/FSDP2 strategy pattern) | 21 | 1 | **yes** | ⚠ **`FSDP`**×2-from-one-string, ⚠ `distributed` | **retain-and-revise** |
| A8 | `main.tex:161` | nested `\resumeItem` (Flash Attention 2/3, context parallelism) | 22 | 1 | **yes** | ⚠ **`Flash Attention`** ×1, ⚠ `distributed` | **retain-and-revise** |
| A9 | `main.tex:163` | `\resumeTopic{Build \& Deployment System}` | 23–24 | 2 | no | `KEDA`, `Kubernetes`, ⚠ **`Rust`** ×1, `inference` | **retain-and-revise** |
| A10 | `main.tex:164` | `\resumeTopic{Enrichment Service}` | 25–26 | 2 | no | `inference` | **retain-and-revise** — D-06 migration / video-clip figures land here |
| A11 | `main.tex:165` | `\resumeTopic{Data Quality Framework}` | 27–28 | 2 | no | — | **retain-and-revise** |
| **A12** | *new* | `\resumeTopic{Training-Data Governance (Rust)}` | — | **+2 (topic only)** | yes (`27,135`) | `Rust` (2nd copy), `fault`-tolerant, `lineage` | **add** (D-02) |

### Disposition totals — and the zero

| Disposition | Count | Entries |
|---|---|---|
| retain-and-revise (topics) | **5** | A2, A6, A9, A10, A11 |
| retain-and-revise (nested items) | **4** | A3, A5, A7, A8 |
| revise | **2** | A1 (lead, D-01), A4 (D-05 figure swap) |
| add | **1** | A12 (D-02 governance) |
| **retire** | **0** | — |

**Zero entries carry a `retire` disposition.** Nothing in the current Adobe block is deleted. D-03
is explicit — *"Retain all 5 existing topics … Retire nothing."* Two **figures** are retired inside
A4 (see Section A), but the entry itself is revised, not removed: A4 keeps its bullet, its shape and
its position, and gains an evidenced figure in place of the unprovenanced pair.

**Named survivals, so no later reader has to infer them:**

- `Falcon-40B` — A4's neighbour A3, `main.tex:154`. **Survives.**
- `Llama 2 70B` — A3, `main.tex:154`. **Survives.** (Source writes `Llama~2~70B`; the text layer
  holds `Llama 2 70B`, so the retention needle is the space-separated rendered form.)
- KEDA-on-`SQS queue depth` — A5, `main.tex:156`. **Survives.** This is also the sole carrier of the
  `SQS` BLOCKER keyword, which is *why* D-03 preserved it explicitly.
- `Source → Transform → Sink` — A5, `main.tex:156`. **Survives.** The arrow is U+2192, already
  declared in `NONASCII_ALLOW` (census: U+2192 ×3), so it costs nothing at `G6.4`.

### The keywords-carried column is the point of the table

All 13 `KEYWORDS_REQUIRED` pass today (`G6.5` ×13 PASS). **Eleven have every carrier inside the
three blocks this phase rewrites**, and **five are single points of failure**. A careless reword of
any one of those lines turns the phase gate red at BLOCKER tier:

| Keyword | Count today | Sole/concentrated carrier | Consequence of a careless reword |
|---|---|---|---|
| `Rust` | **×1** | A9, `main.tex:163` — "a Rust control plane" | `G6.5` FAIL. A9 is a topic D-03 revises. |
| `SQS` | **×1** | A5, `main.tex:156` — "SQS queue depth" | `G6.5` FAIL. D-03 preserves the claim for exactly this reason. |
| `Flash Attention` | **×1** | A8, `main.tex:161` | `G6.5` FAIL. Multi-word, so it must be checked against the whitespace-squeezed stream — a raw whole-line grep returns 0 on a correct document that wrapped it. |
| `FSDP` | **×2 from one string** | A7, `main.tex:160` — `FSDP/FSDP2` yields two matches from a single token | `G6.5` FAIL. The count of 2 is *not* two independent carriers; it is one string. Deleting that one string takes the count to 0. |
| `distributed` | **×2, both carriers in A7+A8** | A7 `main.tex:160` ("distributed training"), A8 `main.tex:161` ("distributed attention") | `G6.5` FAIL if **both** sub-items lose the lowercase word. Capital-D `Distributed Inference Frameworks` at A2 **does not count** — `G6.5` is case-sensitive (verified: `G6.5 PASS … 'distributed' x2`, and the match set is lines 21 and 22 only). |

`fault` is the fifth single-occurrence BLOCKER keyword but lives outside the Adobe block, at Swiggy
`main.tex:175` — covered in Section C.

**Pitfall-7 ordering rule (binding).** D-02's governance group is what lands the **second** `Rust`
copy. Until it lands, `Rust` is ×1 and A9 is its only carrier. Therefore: **the governance topic
must land before or in the same commit as any A9 reword.** Reword A9 first and the intervening
commit is red at `G6.5`, with the failure attributed to the wrong edit. `scripts/verify-phase3-regressions.sh`
Group 3 mechanizes this — its `Rust`-count clause requires **≥2** in the gate stream, so it can only
go green once the governance group exists.

### Digit-bearing baseline and how to assert it

Measured page-1 digit-bearing bullet lines today: **8** — gate lines **15, 16, 21, 22, 36, 46, 61,
70**. Verbatim from the harness:

```
RESULT G5.4   WARN  page-1 digit-bearing bullet lines: 8 against manifest DIGIT_BULLET_FLOOR=7
                    -- crude metric, kept non-gating (owner: Phase 3)
```

Breakdown: **Adobe 4** (15, 16, 21, 22) + **Swiggy 2** (36, 46) + **Flipkart 1** (61) +
**Groupon 1** (70) + **NetSpeed 0** = **8**, against `DIGIT_BULLET_FLOOR=7`.

**ROADMAP criterion 4 requires the count never drop below 8** — one above the manifest floor.
Two rules follow, and both are load-bearing:

1. **Assert the *value in the `G5.4` message*, never the absence of a FAIL.** `G5.4` is `warn`-tier
   and **non-gating**: it cannot fail. A run that drops the count from 8 to 7 still exits 0 with a
   WARN. Grep the number.
2. **Never lower `DIGIT_BULLET_FLOOR`.** Phase 1's recorded principle: a generator that lowers a
   BLOCKER threshold to match a document that moved away from it deletes the gate exactly the way
   re-freezing a changed employment date defeats VERIFY-03.

**Pitfall 5 — `G5.4` cannot see a figure that wrapped.** The regex is
`^[[:space:]]*(•|▪|◦|·|–|—|\*|-).*[0-9]` over page-1 text: it matches only lines that **begin with a
bullet glyph** (here U+2013, from the itemize default) and contain a digit. A continuation line
starts with a word, so a figure that lands there is invisible to the count. **Live proof:** Swiggy's
Feature Store bullet carries `(4Bn rows, 10K QPS)` on gate line **43**, a continuation — and 43 is
**absent** from the match set `{15, 16, 21, 22, 36, 46, 61, 70}`. Consequence for D-06: when the
count matters, put at least one digit on the owning bullet's **first** rendered line.

### Frozen surfaces — what this phase must not touch, and why

| # | Surface | Where | Why it is frozen |
|---|---|---|---|
| 1 | The five **titles and dates** — args #1/#2 of `\resumeSubheading` | `main.tex:148`, `:169`, `:183`, `:196`, and the NetSpeed row | Byte-frozen in `docs/verify/baseline-frozen.txt` `[titles]` / `[dates]`, matched `LC_ALL=C grep -Fxc` == exactly 1. VERIFY-03 / honesty: never fabricate an employment date or a printed title. Whole-line matching is itself load-bearing — bare `Software Development Engineer` is a substring of `Software Development Engineer (Search Relevance)`. |
| 2 | The five **employers and subtitles** — args #3/#4 | `main.tex:149`, `:170`, `:184`, `:197`, and the NetSpeed row | Employers are byte-frozen in `[employers]` (`G5.1`/`G5.2`/`G5.5` at exactly 1). The subtitles are not in the frozen file but are **anchors**: `scripts/verify-phase3-regressions.sh` Group 2 resolves `GENERATIVE AI, COMPUTER VISION, LARGE LANGUAGE MODELS` as a whole gate line to find the lead bullet. Reword it and criterion 2's own gate reports *unmeasurable*. |
| 3 | `docs/verify/baseline-frozen.txt` **in whole** | the file | Immutable this phase. Nothing in D-01…D-15 changes a date, title, employer or geometry declaration, so **any** diff here is a defect. Regeneration is refused without `ALLOW_FROZEN_UPDATE=1`, and even then only the derivable geometry hash is rewritten. |
| 4 | The `\setlist` and `\addtolength` declarations | `main.tex:38-42`, `:69`, `:71-72` | `G4.1` is the hard margin gate: it hashes exactly these declarations out of `$TEX` and compares to `[geometry-sha256]` = `8b13a46b…f465a56`. Changing list spacing to buy a line would silently change the measured 11.4–11.5pt/line pitch the whole budget ledger rests on, and `G8.2` proves the freeze fires on margin drift. |
| 5 | `\pdfgentounicode=1` | `main.tex:60` | The ATS text layer exists because of this line. Remove it and every `G5`/`G6` text-layer assertion degrades — the PDF becomes visually identical and machine-unreadable, which is the exact failure the milestone's core value forbids. |
| 6 | `\input{glyphtounicode}` | `main.tex:15` | Supplies the glyph→Unicode map `\pdfgentounicode` consumes. Without it the ligature and dash glyphs extract as garbage and `G6.4`'s census becomes meaningless rather than merely red. |
| 7 | `\newpage` | `main.tex:211` | The page-1/page-2 boundary `G2.1` asserts (`PAGE2_OPENS_WITH=PUBLICATIONS`). It is the definition of "Experience fits page 1"; moving it would satisfy the gate by redefining the constraint. |

---

## Section A — figure → evidence traceability (criterion 3)

Criterion 3's rule: **every figure the rebuild ships must trace to a named
`.planning/research/CODEBASE-EVIDENCE.md` entry.** A row without a citation is a defect, not a
stylistic omission — an unprovenanced figure is exactly what EXP-04 exists to remove. Line numbers
below were resolved with `LC_ALL=C grep -Fn` against that file on 2026-08-23.

| Rendered literal | LaTeX source form | Owning topic | Evidence |
|---|---|---|---|
| `1.09M` (rows) | `1.09M` | A4 offline inference (D-05) | `CODEBASE-EVIDENCE.md:58` — "1,087,682 rows @ 109 rows/s steady" |
| `8×A100` | `8$\times$A100` | A4 offline inference (D-05) | `CODEBASE-EVIDENCE.md:58` — "1×p4d.24xlarge (8×A100)" |
| `16 fractional-GPU actors` | `16 fractional-GPU actors` | A4 offline inference (D-05) | `CODEBASE-EVIDENCE.md:58` — "16 fractional-GPU actors (0.5 GPU each)" |
| `24×A100-40GB` | `24$\times$A100-40GB` | A10 Enrichment / fleet ops (D-06) | `CODEBASE-EVIDENCE.md:62` — "24×A100-40GB per model job × 9 queues" |
| `9 model queues` | `9 model queues` | A10 Enrichment / fleet ops (D-06) | `CODEBASE-EVIDENCE.md:62` (launch records) + `CODEBASE-EVIDENCE.md:61` (the 9 production modules enumerated) |
| `64 H100s` | `64 H100s` | A10 Enrichment / fleet ops (D-06) | `CODEBASE-EVIDENCE.md:98` — "64 H100s across the parallel wave" |
| `202.6M-row` | `202.6M-row` | A10 Enrichment / migration (D-06) | `CODEBASE-EVIDENCE.md:34` heading + `CODEBASE-EVIDENCE.md:35` — "~202.6M rows (README:12)" |
| `24.8M` (video clips) | `24.8M` | A10 Enrichment / migration (D-06) | `CODEBASE-EVIDENCE.md:38` — "Video clips migration — 24.8M clips (#1139 merged)" |
| `~700M` (asset catalog) | `\textasciitilde{}700M` ⚠ mandatory form | A10 or A11 data-platform scale (D-06) | `CODEBASE-EVIDENCE.md:88` — "~700M enriched assets" |
| `35–38M` (images/month) | `35--38M` | same topic as `~700M` (D-06) | `CODEBASE-EVIDENCE.md:88` and `CODEBASE-EVIDENCE.md:107` |
| `40-node` (EMR daily) | `40-node` | A10 / ingestion (D-06) | `CODEBASE-EVIDENCE.md:107` — "Prod ingestion runs on 40-node EMR daily" |
| `27,135` (lines of Rust) | `27,135` | A12 governance (D-02) | `CODEBASE-EVIDENCE.md:29` — "+27,135 lines solely his" |
| `9.7k-line` (integration test) | `9.7k-line` | A12 governance (D-02) | `CODEBASE-EVIDENCE.md:30` — "9,722-ln integration test" |
| `torch.compile(mode="max-autotune")` | plain ASCII `"` — verified U+0022 | A2/A4 inference (D-07) | `CODEBASE-EVIDENCE.md:54` — "introduced `torch.compile(mode="max-autotune")` on encoder + classifier" |

Supporting non-numeric claims the same rule covers, so the governance and mechanism vocabulary is
provenanced too: `claim/receipt` and `immutable S3 evidence layouts` and `lineage` →
`CODEBASE-EVIDENCE.md:30`; `exponential backoff` + `full jitter` → `CODEBASE-EVIDENCE.md:23`;
`concurrency-safe S3 checkpoint` → `CODEBASE-EVIDENCE.md:24`; `lease/TTL heartbeat` and `DLQ` and
`circuit breaker` → `CODEBASE-EVIDENCE.md:87`; `idempotent re-run` → `CODEBASE-EVIDENCE.md:95`.

### The two attribution-safety rules — constraints on wording, not suggestions

**Rule A-1 — the Ray Data engine is not his.** `CODEBASE-EVIDENCE.md:58` records that the Ray Data
engine *and its benchmark document* are **Joel C.'s**; the **AIDE module** benchmarked on it is his.
The sanctioned phrasing is therefore *his module **benchmarked on** the Ray Data engine* — and the
bullet must **never** say "achieved". This is not a style preference: `achieving` is the exact word
at `main.tex:155` today, and rewriting the figures while keeping that verb would convert an
unprovenanced number into a **misattributed** one, which is strictly worse.
`scripts/verify-phase3-regressions.sh` mechanizes it as the `achiev` absence needle (label
`EXP-04d/03-05 attribution-safe wording`), matched **case-insensitively** in both `$TEX` and
`$SQUEEZED` — because `achieving` / `achieved` / `Achievement` are one honesty violation, not three.

**Rule A-2 — the Content Gate work is never framed as inference optimization.**
`CODEBASE-EVIDENCE.md:12` is a binding honest-framing rule: Content Gate (#1706/#1870) is
*training-data governance/lineage* — "strong for **fault-tolerant distributed systems in Rust**, not
inference optimization." D-02 restates it. So the A12 topic may not carry `throughput`, `latency`,
`speedup`, `faster` or `images/sec`, and `scripts/verify-phase3-regressions.sh` Group 3 slices the
governance topic's rendered region out of the gate stream and asserts exactly that.

### Retirement row — the two figures being removed

| Retired literal | Source form | Where today | Reason | Assertion form |
|---|---|---|---|---|
| `10–50` (the "10–50× faster image loading" speedup) | `10--50$\times$` at `main.tex:155` | gate line 16 | **Unprovenanced.** No `CODEBASE-EVIDENCE.md` entry supports it; `PROJECT.md` Out of Scope names it as interview risk | absent in **both** `$GATE` and `$SQUEEZED`, **EN DASH U+2013 form** |
| `3–8K images/sec on 32 GPUs` | `3--8K images/sec on 32 GPUs` at `main.tex:155` | gate line 16 | **Unprovenanced.** Same | absent in `$SQUEEZED` (multi-word, wraps) |

**The EN-DASH rule, and why an ASCII assertion would be vacuous.** Measured today:

| stream | `10–50` (U+2013) | `10--50` (ASCII) |
|---|---|---|
| text layer (`$GATE`) | **1** | 0 |
| `docs/main.tex` (`$TEX`) | 0 | **1** |

LaTeX converts the source `--` to an en dash, so **the ASCII form never appears in the text layer and
the EN DASH form never appears in the source.** `assert_absent '10--50'` against the text layer
therefore passes trivially on *today's* still-defective document and could never catch a
reintroduction. Absence must be asserted against the **rendered EN DASH form** in the text streams,
and separately against the **ASCII source form** in `$TEX` — which is why the net carries four
retirement assertions, not two.

### LaTeX encoding rules that are BLOCKER-grade

1. **`~700M` must be written `\textasciitilde{}700M`.** `$\sim$` extracts as **U+223C**, which is
   *not* in `NONASCII_ALLOW=2013,2019,2022,2192,2206,00D7,2014,201C,201D` → **`G6.4` FAIL, BLOCKER**.
   `\textasciitilde{}` extracts as plain ASCII `~` (U+007E) and leaves the census clean. Verified
   both ways.
2. **A bare `~` is a non-breaking space and fails silently.** In LaTeX `~` is `\nobreakspace`, so
   `~700M` extracts as `700M` with a leading space — *the tilde vanishes with no warning, no WARN and
   no FAIL*. This is the more dangerous of the two because it is invisible: the approximation
   qualifier disappears and the claim silently hardens from "about 700M" to "700M".
3. **Allowed, no action needed:** `$\times$` → U+00D7 (census ×1 today) and `--` → U+2013 (census ×38)
   are both already declared. Plain `"` renders and extracts as ASCII U+0022 — verified, zero
   U+201C/U+201D added — so `torch.compile(mode="max-autotune")` needs no `\texttt{}` or `\char34`.

---

## Section B — the page-1 budget ledger

**This section is the spend authority for waves 2–4.** Every content plan draws against it, and no
plan may exceed it on the strength of its own estimate. Phase 2's core lesson: budget arithmetic is
**measured, never predicted**.

### Baseline and unit cost

| Quantity | Measured value |
|---|---|
| `G3.2` page-1 headroom, committed baseline | **+50.5pt (+4.39 lines)** at `LINE_PT=11.5` |
| Cost per rendered page-1 line | **11.4–11.5pt**, linear across the whole +1…+5 sweep |
| Hard ceiling | **+4 rendered lines** |

Verbatim from the harness on the committed artifact:

```
RESULT G3.1   PASS  deepest content bottom 713.9pt vs ceiling 764.4pt (p1 713.9pt, p2 710.9pt)
RESULT G3.2   INFO  headroom at 11.5pt/line: p1 +50.5pt (+4.39 lines), p2 +53.5pt (+4.65 lines)
```

The ceiling is measured, not derived from `floor(50.5 / 11.5)`: **+4 rendered lines stays 2 pages
with `G3.2` p1 at +4.7pt and zero BLOCKERs — the last safe step. +5 produces a 3-page PDF with
`G1.1` FAIL and `G2.1` FAIL.** The full sweep: `50.5 → 39.0 → 27.6 → 16.1 → 4.7pt`.

⚠ **`G3.1`/`G3.2` are NOT the overflow alarm — `G1.1` is.** At +5 lines the harness still printed
`RESULT G3.1 PASS deepest content bottom 760.3pt vs ceiling 764.4pt`, because with `\raggedbottom`
LaTeX **breaks the page** instead of overrunning `\textheight`. `G2.3` and `G2.4` also stayed green
on that 3-page document. Read **`G1.1` first, always**; treat `G3.2` p1 as the remaining-headroom
meter.

### Spend table, in wave order

| Wave item | Decision | Rendered-line spend | Note |
|---|---|---|---|
| A12 governance topic | D-02 | **+2** | `\resumeTopic` **only**. The `\resumeTopic`-plus-nested-`\resumeItem` form measures **4 rendered lines — the entire budget** — so that shape is **forbidden**. All of D-02's content (`27,135`, `claim/receipt`, `immutable S3 evidence layouts`, `9.7k-line`, `lineage`) fits the 2-line topic, measured with 0 overfull. |
| D-04 fault-tolerance mechanisms | D-04 | **0pt target** | Written into the ≈484 characters of measured free tail room. |
| D-06 spread figures | D-06 | **0pt target** | Same — into tails wherever the owning topic already wraps. |
| A4 Ray swap | D-05 | **+1** | 1-line item → 2-line item. |
| D-07 compiler bridge | D-07 | **0pt target** | Into an existing tail. |
| Swiggy block | D-11 | **0** | Line-neutral by decision. |
| Flipkart block | D-11 | **0** | Line-neutral by decision. |
| **Expected end state** | | **+3** | `G3.2` p1 ≈ **+16.1pt**, leaving **one rendered line (11.5pt) as the EXP-08 approval fund**. |

Reserving that line is deliberate. If the rebuild instead lands at the +4 ceiling (`G3.2` p1
+4.7pt) there is **no room for even one more rendered line**, and an EXP-08 approval would force
either a compensating tightening or a 3-page overflow. The checkpoint's context must state which
situation the user is deciding in.

### Free tail room — ≈484 characters at zero pt cost

An already-wrapped bullet's last rendered line has unused width; filling it costs **nothing**
(verified: ~145 characters appended across three Adobe tails left `G3.2` p1 unchanged at +50.5pt,
2 pages, 0 overfull). Capacities are per-shape: itemize-2 lines (lead + topics) ≈120–124 characters,
itemize-3 lines (nested items) 128–130.

| Adobe entry | source | last-line chars | free chars |
|---|---|---|---|
| A1 lead `\resumeItem` | `main.tex:151` | 76 | **~44** |
| A2 `\resumeTopic{Distributed Inference Frameworks}` | `main.tex:152` | 40 | **~80** |
| A3 vLLM + Ray item | `main.tex:154` | 110 | **~18** |
| A4 offline-inference item (D-05 target) | `main.tex:155` | 128 | **~0 — at capacity** |
| A5 KEDA/SQS item | `main.tex:156` | 16 | **~104** |
| A6 `\resumeTopic{Foundation Model Training Framework}` | `main.tex:158` | 51 | **~69** |
| A7 FSDP/FSDP2 item | `main.tex:160` | 109 | **~19** |
| A8 Flash Attention item | `main.tex:161` | 130 | **~0 — at capacity** |
| A9 `\resumeTopic{Build \& Deployment System}` | `main.tex:163` | 97 | **~23** |
| A10 `\resumeTopic{Enrichment Service}` | `main.tex:164` | 71 | **~49** |
| A11 `\resumeTopic{Data Quality Framework}` | `main.tex:165` | 42 | **~78** |
| **total** | `main.tex:151-165` | | **≈484 free chars, 0pt** |

⚠ **Measurement note for whoever re-derives this.** `awk '{print length}'` on the gate stream counts
**bytes**, not characters, and the U+2013 bullet prefix is 3 bytes. Re-measuring naively yields
2 extra on every bullet-led line (and 7 on A4, which also carries U+2013 ×2 and U+00D7 ×1). The
figures above are **character** counts; the byte counts measured today were 76, 40, 112, 135, 16, 51,
111, 132, 97, 71, 42. Both A4 and A8 are at or past capacity either way.

### Contingency ladder — the authority every content plan spends against

| Measured state after a batch | Verdict | Action |
|---|---|---|
| `G3.2` p1 **≥ +16.1pt** | reserve intact | proceed; the EXP-08 approval fund survives |
| `G3.2` p1 between **+4.7pt and +16.1pt** | reserve consumed | proceed, but the EXP-08 checkpoint's `<context>` **must say so** — the user is then deciding whether to fund an approval by tightening |
| `G3.2` p1 **below +4.7pt**, or `G1.1` reports **3 pages** | over budget | **back the edit out.** Do not tighten a frozen surface, do not lower a threshold |

### Two hard rails

1. **Never a fifth rendered line.** +5 is a measured 3-page PDF with `G1.1` FAIL and `G2.1` FAIL.
2. **`G3.2` p1 must never RISE above +50.5pt.** Spending is safe and makes the self-test guard
   *stronger* (margin = `57.5 − slack`). **Net-freeing a rendered line breaks it:** reproduced —
   shortening one Adobe topic from 2 rendered lines to 1 took slack to **61.4pt**, and the
   replicated `+5` probe then rendered **2 pages**, i.e. `G7.2` FAIL ("a +5 probe NO LONGER
   overflows page 1 and the self-test would prove nothing"). Because `G7` runs only under
   `--selftest`, `bash scripts/verify-resume.sh` stays green through this failure — so **spend
   before you free, and no wave may end in a net-freed state.**

Corollaries, both standing prohibitions:

- **`PROBE_LINES` is raise-only and is NOT raised this phase.** Raise-only means a raise can never
  be undone later. Under D-11 the end state leaves nowhere near 57.5pt of slack, so there is no
  measured justification.
- **`DIGIT_BULLET_FLOOR` is never lowered.** Lowering it to match a regression deletes the gate.

### The one sanctioned lever, and its precondition

The **Groupon** and **NetSpeed** folded descriptors (`main.tex:199` and the NetSpeed row) may be
**reworded SHORTER** — never deleted — but only when **all three** hold:

1. the Adobe rebuild has **measurably** run out of room (a recorded `G3.2` figure, not a prediction);
2. **every** P2-protected literal survives — `scripts/verify-phase2-regressions.sh` P2.7–P2.27,
   including the load-bearing multi-word `C++ graph algorithms` anchor that ROADMAP Phase 5
   criterion 4 rests on;
3. neither forbidden shortened form appears.

**Same-commit rule.** If this lever is pulled to fund an EXP-08 approval, **the reword and the
addition go in the SAME commit**, so the net rendered-line delta is zero and the `G7.2` margin is
never transiently widened. A two-commit sequence would leave one commit in a net-freed state, which
rail 2 forbids.

---

## Section C — Swiggy / Flipkart disposition (D-09 / D-10)

| # | source | bullet | gate lines | rendered | notes |
|---|---|---|---|---|---|
| S1 | `main.tex:172` | Online Inference Platform | 36–37 | 2 | Carries the `18M+` adoption count on its **FIRST** rendered line (36) — which is precisely why `G5.4` can see it. D-09: platform-adoption framing. |
| S2 | `main.tex:174` | dynamic request-routing item | 38–39 | 2 | Reworded in place; no new claim. |
| S3 | `main.tex:175` | Akka-style actor framework item | 40–41 | 2 | ⚠ **Sole `fault` carrier** in the whole document (`fault isolation across clusters`, gate line 40). D-09's failure-class-closure clause names it verbatim, which is what protects it. |
| S4 | `main.tex:177` | Feature Store | 42–43 | 2 | ⚠ **Sole page-1 `Spark` carrier** (gate line 43). Its `4Bn rows, 10K QPS` sits on a **continuation** line, so `G5.4` cannot see it (Pitfall 5's live proof). Keeps both figures. |
| S5 | `main.tex:178` | Forecasting & Correlation Platform | 44–45 | 2 | Keeps "Founding member". |
| S6 | `main.tex:179` | DAQ | 46 | 1 | Digit-bearing (`15M rows daily`) on its only line. |
| **Swiggy total** | `main.tex:172-179` | | **36–46** | **11** | |
| F1 | `main.tex:186` | Search Intent Models | 54–55 | 2 | Keeps "millions every day" (D-10). ⚠ It **wraps at "every / day"**, so it is ×0 in the raw gate stream and ×1 in the squeezed stream — squeezed-stream assertion **only**. This needle is the dual-stream rule proving itself. |
| F2 | `main.tex:187` | Tail Query Classifier | 56 | 1 | Reworded in place. |
| F3 | `main.tex:188` | ML Workflow Automation | 57–58 | 2 | **D-10's closure story.** Keeps `first workflow at Flipkart`; gains the error class it closed. |
| F4 | `main.tex:190` | generic Airflow framework item | 59–60 | 2 | Keeps `validations`. |
| F5 | `main.tex:192` | Large-Scale Data Pipelines | 61–62 | 2 | Digit-bearing (`4Bn+`) on its first line (61). |
| **Flipkart total** | `main.tex:186-192` | | **54–62** | **9** | |

### The binding constraint for both blocks: no new claims requiring new evidence

`.planning/research/CODEBASE-EVIDENCE.md` covers **Adobe repos only** (orion, genie, colligo,
asml-img-data-dags, ff-data-ingestion, ff-data-engineering, fetools). There is no mined evidence for
Swiggy or Flipkart at all. Therefore **every Swiggy and Flipkart edit is a rewording of claim
material already present in those lines** — a staff-signal reshaping of existing text, never an
addition. D-09 says so directly ("No new claims requiring new evidence").

**The one entailment that is licensed, and its exact limit.** D-10's closure needle is
`manual deploys`. It is licensed by the claim already at `main.tex:188` — *"the first workflow at
Flipkart to automate training and auto-deployment of search models"*. Automating a deploy entails
the deploy was **manual before**; naming that prior state adds no fact. **Nothing beyond that
entailment may be added** — no frequency, no duration, no incident count, no error rate. The same
bound applies to the `validations` clause at `main.tex:190`, which already names data and model
validations.

### Line-neutrality is a RENDERED-line property

D-11 requires the Swiggy and Flipkart edits to be line-neutral. Measured today:

| block | gate region | rendered lines |
|---|---|---|
| Adobe | 11–28 | **18** |
| Swiggy | 36–46 | **11** |
| Flipkart | 54–62 | **9** |

⚠ **`03-RESEARCH.md`'s "Swiggy 8 rendered lines" figure is SUPERSEDED by this measurement.** That
row states the region as gate 36–46 and the count as 8, which is internally inconsistent — 36
through 46 inclusive is **11** lines, and the per-bullet breakdown above sums to 11
(2+2+2+2+2+1). Flipkart's 9 reproduces exactly.

⚠ **Absolute gate line numbers SHIFT when Adobe grows.** Every Adobe rendered line the rebuild adds
pushes Swiggy and Flipkart down by the same amount, so `36–46` and `54–62` are true **today only**.
Line-neutrality must therefore be re-derived from **region boundaries** — the employer's subtitle
anchor down to the next blank line — and **never** from fixed line numbers. A differential check
pinned to literal numbers would report a false regression the moment the governance topic lands.
Corroborating check: `G3.2` p1 must move by **exactly** the Adobe delta and nothing more.

---

## Section D — EXP-08 draft families (⚠ UNVERIFIED, D-12 / D-13 / D-14)

**These drafts live here and nowhere else.** They are **never** written into `docs/main.tex` — **not
even as a `%`-commented line.** Three reasons, and the third is the decisive one:

1. A `%`-commented draft never renders, so `pdftotext` cannot see it and **no `G`-gate in this repo
   can see it either**.
2. Nothing would then catch it graduating from a comment to live text — the leak would be a one-character
   edit with zero gate coverage.
3. The `⚠ UNVERIFIED` marker itself would be **unassertable**, because a marker that lives only in a
   LaTeX comment cannot be measured in the text layer.

The only machine cover for this is the **source-side** half of the P3 net's Class D assertions
(`assert_absent` against `$TEX`), and 03-01 Task 3 proved it fires: appending a commented
`AssumeRole` draft to a basename-preserved scratch `main.tex` flipped **P3.67 alone**, with every
text-layer assertion still green. That is the leak no other gate in this repo can see.

### Needle-casing constraint (applies to every draft below)

`assert_absent` in `scripts/verify-phase3-regressions.sh` counts with `gcount -Fc` — a **fixed-string,
case-SENSITIVE** match. So a needle only flips from absent to present if the shipped bullet carries
it **byte-for-byte**:

| Needle | Must be written | Must NOT be written |
|---|---|---|
| `AssumeRole` | exactly `AssumeRole` (CamelCase, one word) | `assume-role`, `Assume Role`, `assumerole` |
| `6-week` | exactly `6-week` (digit, ASCII hyphen, lowercase) | `six-week`, `6 week`, `6--week` (which renders as an en dash) |
| `mentored` | lowercase `mentored`, **mid-sentence** | sentence-initial `Mentored` — the capital M makes the needle read 0 on a shipped bullet |

That last row is a real trap, not pedantry: a draft approved and shipped as *"Mentored applied-ML
engineers…"* would leave `assert_absent 'mentored'` reading count 0 forever, so 03-08's
`assert_absent`→`assert_present` flip would report a **false absence on a bullet that is actually on
the page**. Every draft below is worded to satisfy this table.

### Why `STS` is NOT a needle

`STS` is rejected as an assertion needle because **a fixed-string search for it matches inside
`TESTS`** — verified: `printf 'RUNNING TESTS\n' | LC_ALL=C grep -Fc 'STS'` returns **1**. Any file,
comment or bullet containing the word `TESTS` would make an `STS` absence assertion FAIL for a reason
that has nothing to do with the draft. The **wording may still say STS** (it is the correct service
name and reads naturally); the **needle is `AssumeRole`**.

---

### Family 1 — COST / EFFICIENCY (three candidates, D-12)

The user gets a real choice, so all three are drafted rather than one being pre-selected.

#### ⚠ UNVERIFIED — candidate (a): STS assume-role storm fix · needle `AssumeRole`

> Closed a credential-refresh failure class in the feature-registry client library where a failed
> AssumeRole never populated the session cache, driving thousands of throttled STS calls per second
> under role chaining; fixed with a shared negative cache on a 60s cooldown and exactly-one
> half-open retry, proven by an 8-thread thundering-herd collapse test.

- **What the user is being asked to confirm:** that "thousands of throttled calls per second
  eliminated" is a fair characterisation of the storm this fix ended — the magnitude leans on
  `CODEBASE-EVIDENCE.md:111` ("thousands of STS calls/sec + throttling").
- **Owning role if approved:** **A10 `\resumeTopic{Enrichment Service}`** — the feature-registry
  session layer is what every enrichment pipeline writes through (`CODEBASE-EVIDENCE.md:22`), as a
  nested `\resumeItem` under that topic.
- **Estimated rendered cost:** **2 lines** (longest of the three).
- **Every figure cited:** `thousands … per second`, `60s cooldown`, `exactly-one half-open retry`,
  `8-thread` → all `CODEBASE-EVIDENCE.md:111`. No dollar amount, no headcount, no percentage.

#### ⚠ UNVERIFIED — candidate (b): 6-week silent outage root-cause + smoke-test CI · needle `6-week`

> Root-caused a 6-week silent enrichment outage — dependency rot had broken the framework's venv
> installs with no failing signal — and closed the class with install/import smoke-test CI plus
> SHA-pinned builds, so the same rot now fails the build instead of the data.

- **What the user is being asked to confirm:** that "a 6-week silent-outage class closed" is a fair
  framing of a root-cause plus the CI that would have caught it — the magnitude leans on
  `CODEBASE-EVIDENCE.md:94` ("Root-caused 6-week silent outage … added install/import smoke-test CI
  that would have caught it; SHA-pinned genie builds").
- **Owning role if approved:** **A9 `\resumeTopic{Build \& Deployment System}`** — the remedy is
  build-and-CI reliability, which is that topic's subject.
- **Estimated rendered cost:** **1–2 lines**.
- **Every figure cited:** `6-week` → `CODEBASE-EVIDENCE.md:94`. No dollar amount, no headcount, no
  percentage.

#### ⚠ UNVERIFIED — candidate (c): preemptible-fleet idempotent autorecovery · ⚠ NO LOCKED NEEDLE

> Made preemptible-GPU enrichment backfills survive node loss: queue drain promoted to the
> authoritative success signal over preemption-noisy job state, idempotent re-runs, stale-queue
> drop-before-create, and window fallback to the last successful day.

- **What the user is being asked to confirm:** that a fault-tolerance claim with **no magnitude at
  all** is worth a page-1 line. The mechanisms lean on `CODEBASE-EVIDENCE.md:95`.
- **Owning role if approved:** **A10 `\resumeTopic{Enrichment Service}`** — the same topic D-06's
  `64 H100s` fleet figure lands in.
- **Estimated rendered cost:** **1–2 lines**.
- ⚠ **RECORDED GAP — this candidate has no Class D absence needle.** `03-01-PLAN.md`
  `<locked_literals>` Class D locks exactly three needles (`AssumeRole`, `6-week`, `mentored`), and
  none of them belongs to (c). So (c) is **not currently covered by an absent-by-default
  assertion**. Consequence, stated rather than left to be rediscovered: **if candidate (c) is the one
  approved, 03-08 must add its needle in the SAME commit that ships it** — otherwise the bullet
  enters the document with no machine record that it was ever gated. Suggested needle:
  `drop-before-create` (distinctive, whitespace-free after hyphenation, ×0 in `docs/main.tex`
  today, and it survives a wrap because `pdftotext` does not hyphenate it). This mirrors the Class E
  `CUDA` precedent: a gap that is written down is a decision; a gap that is not is an omission.

---

### Family 2 — MENTORING / LEADERSHIP (one draft, D-12)

#### ⚠ UNVERIFIED — mentoring line · needle `mentored` (lowercase, mid-sentence)

> Grew the platform's engineering bench: mentored applied-ML and platform engineers onto the
> training and inference frameworks, authoring the architecture guide, runbook and multi-node launch
> templates teams onboard with, and reviewing their module integrations through to production.

- **What the user is being asked to confirm:** **the people relationship itself.** This is a
  *stronger* ask than the cost family's — see the honesty note below. The supporting artifacts lean on
  `CODEBASE-EVIDENCE.md:26` (425-line ARCHITECTURE.md + 364-line runbook), `CODEBASE-EVIDENCE.md:61`
  (multi-node launch templates across 9 production modules), `CODEBASE-EVIDENCE.md:30` (the 422-line
  frozen cross-runtime contract doc) and `CODEBASE-EVIDENCE.md:53` (production model onboarding).
- **Owning role if approved:** **A6 `\resumeTopic{Foundation Model Training Framework}`** — the topic
  whose claim the people dimension extends.
- **Estimated rendered cost:** **1–2 lines**.
- **No magnitude at all, deliberately.** The draft carries **no numeral**: D-13 forbids an invented
  headcount, and "mentored N engineers" is precisely the invented headcount it forbids. The claim is
  qualitative on purpose.

**How it differs from what the document already says.** The existing lines make *artifact* and
*self-role* claims; none of them carries a people dimension, so the draft is additive rather than a
restatement:

| Existing line | What it already claims | What it does NOT claim |
|---|---|---|
| `main.tex:158` (A6) | a training framework **"adopted across the org"** | **adoption of an artifact.** Says nothing about who was brought along, or that he grew anyone's capability |
| `main.tex:178` (Swiggy S5) | **"Founding member"** of the forecasting platform | **his own role.** A founding-member claim is about his seat, not about other engineers' growth |
| `main.tex:192` (Flipkart F5) | Cascading/HDFS pipelines, `4Bn+` datapoints | nothing about people or leadership at all — checked, so the "already covered" objection is closed for this line too |

The draft's added dimension is **other engineers' capability**: people onboarded, artifacts authored
*for them*, and their integrations reviewed to production. That is the axis all three existing lines
are silent on.

⚠ **Honesty note, recorded because it changes what the checkpoint is asking.** The cost-family drafts
restate facts that are *already in* `CODEBASE-EVIDENCE.md` and ask the user only to approve the
**framing and the magnitude**. The mentoring draft is different: the mined commits show the
*artifacts* (guides, runbooks, templates, model onboardings) but **cannot show a mentoring
relationship** — commit history does not record who learned what from whom. So this draft asks the
user to confirm a **fact the evidence pass could not reach**, not merely a framing. The checkpoint
must present it that way. Rejecting it is entirely reasonable and costs the phase nothing (D-14).

---

### Ship rule and budget consequence

**D-14, absent-by-default.** The rebuilt Adobe section ships **without** every draft above. A draft
enters `docs/main.tex` only after **explicit recorded per-bullet approval**, and the record is a
`[Phase 3 / EXP-08]` marker whose presence is itself machine-checked. **The phase can close green
with all four drafts rejected — rejection is a valid outcome, not a failure.** Both branches are
asserted: approved → `assert_present` its needle; rejected → `assert_absent` stays green exactly as
it is today (P3.67–P3.72, all six PASS).

**Cost is estimated here and RE-MEASURED at the conditional wave.** The 1–2-line figures above are
estimates from the measured per-shape capacities in Section B, not measurements of the real drafts at
their real position. Phase 2's lesson applies without exception: **the real cost is measured after the
build, never trusted from an estimate.** The conditional wave rebuilds and reads `G1.1`, then `G3.2`
p1, before accepting any approval.

**The ceiling case.** Section B reserves **one rendered line (11.5pt)** as the EXP-08 approval fund,
so the expected end state (+3 lines, `G3.2` p1 ≈ +16.1pt) can absorb a one-line approval. But if the
rebuild instead lands at the **+4 ceiling** (`G3.2` p1 **+4.7pt**, +0.40 lines) then **there is no
room for even one more rendered line** — and the next line is a 3-page PDF with `G1.1` FAIL. In that
situation an approval requires the **sanctioned Groupon/NetSpeed reword-shorter**, and per Section B's
same-commit rule **the reword and the added bullet must land in the SAME commit**, so the net
rendered-line delta is zero and the `G7.2` margin is never transiently widened. The checkpoint's
`<context>` must state which of the two situations the user is deciding in, with the measured `G3.2`
figure quoted.
