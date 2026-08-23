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
