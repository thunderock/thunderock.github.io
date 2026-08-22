# Phase 1: Verification Harness - Pattern Map

**Mapped:** 2026-08-21
**Files analyzed:** 5 (1 modified, 3 new, 1 conditional) + 1 note-only
**Analogs found:** 2 exact (self) / 3 partial / 0 for the shell script — **this repo contains zero standalone shell scripts**

Source for the file list: `01-RESEARCH.md:617-624` (Recommended file layout) and `01-RESEARCH.md:989-996` (Wave 0 gaps). No `CONTEXT.md` exists for this phase.

---

## File Classification

| New/Modified File | Role | Data Flow | Closest Analog | Match Quality |
|---|---|---|---|---|
| `Makefile` **(MODIFY)** — add `verify` / `verify-selftest` / `verify-baseline`; extend `check`; extend header doc-block | config / build | request-response (target dispatch) | itself — `Makefile:96-123` | **exact (self)** |
| `scripts/verify-resume.sh` **(NEW)** | utility — CLI entrypoint | batch transform (read 2 artifacts → `RESULT` lines → exit 0/1/2) | `Makefile:63-68`, `98-102`, `111-114` — embedded recipe shell, the **only shell in the repo** | **partial** (no standalone-script analog exists) |
| `docs/verify/manifest.txt` **(NEW)** | config — `KEY=VALUE` thresholds | file-I/O, read-only | `Makefile:20-23`, `:44` — the `NAME := value` variable block | **partial** (role-adjacent) |
| `docs/verify/baseline-frozen.txt` **(NEW)** | config / data — frozen invariant list | file-I/O, read-only | `Makefile:30-42` — `TEX_PKGS`, one item per line | **partial** (shape only) |
| `.gitignore` **(CONDITIONAL)** — only if a deterministic scratch path replaces `mktemp -d` (`01-RESEARCH.md:995`) | config | n/a | itself — `.gitignore:1` | **exact (self)** |
| `.github/workflows/jekyll.yml` | CI config | event-driven | itself | **note only — no change this phase** |

`docs/` is **flat today** (8 tracked files, zero subdirectories — `git ls-files docs/`). `docs/verify/` is a brand-new subdirectory with no sibling precedent. `scripts/` does not exist either.

---

## Pattern Assignments

### `Makefile` (config/build, request-response) — the primary analog

**Analog:** itself. Every convention below is already established; replicate, do not invent.

**Header doc-block — new targets MUST be listed here** (`Makefile:4-12`). Easy to miss and the only human-facing index besides `make help`:

```make
# Common targets:
#   make            - check deps, build the resume, open it in Preview
#   make install    - install MacTeX/BasicTeX + required TeX packages via brew
#   make check      - print which dependencies are present / missing
#   make build      - compile docs/main.tex -> docs/AshutoshTiwari.pdf
#   make view       - open docs/AshutoshTiwari.pdf in macOS Preview
#   make watch      - latexmk -pvc continuous build
#   make clean      - remove auxiliary build artifacts
#   make distclean  - clean + remove the generated PDF
```

Style: `#   make <target>` padded to a fixed column, then `- lowercase description`. Add three rows for `verify` / `verify-selftest` / `verify-baseline`.

**Variable block** (`Makefile:20-23`) — names padded so `:=` lands at column 12; simple-expansion `:=` throughout; derived paths compose earlier variables:

```make
TEX_DIR    := docs
TEX_FILE   := main.tex
JOBNAME    := AshutoshTiwari
PDF        := $(TEX_DIR)/$(JOBNAME).pdf
```

New variables (`VERIFY := scripts/verify-resume.sh`, etc.) go in this block and follow the same padding. Note `01-RESEARCH.md:874` proposes `VERIFY     := scripts/verify-resume.sh` — already correctly padded.

**PATH export** (`Makefile:26`) — one line, comment above, prepend form. Poppler lives in `/opt/homebrew/bin` which is already on a normal PATH, so **no second export is needed**; only add one if a guard proves otherwise:

```make
# Make sure /Library/TeX/texbin is reachable even in non-login shells.
export PATH := /Library/TeX/texbin:$(PATH)
```

**List variable** (`Makefile:30-42`) — backslash continuation, **hard tab** indent per item, no trailing backslash on the last item:

```make
TEX_PKGS := \
	latexmk \
	collection-fontsrecommended \
	...
	xcolor
```

**`.PHONY` is a SINGLE line** (`Makefile:48`) — append to it; do not add a second `.PHONY` directive:

```make
.PHONY: all help install brew mactex tex-deps check build view open watch clean distclean
```

**`##` help-comment pattern** — consumed by the `help` target. Two forms in use:

```make
all: check build view  ## Default: check deps, build, then open the PDF   # Makefile:50 — deps, TWO spaces, ##
help:  ## Show this help                                                   # Makefile:52 — no deps, TWO spaces after colon
build: $(PDF)  ## Compile the resume PDF                                   # Makefile:108
view: $(PDF)  ## Open the PDF in macOS Preview                             # Makefile:116
```

**`help` target** (`Makefile:52-54`) — the regex constrains legal target names:

```make
help:  ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'
```

- Regex `^[a-zA-Z_-]+:` permits letters, `_`, `-` only. **Verified:** `verify`, `verify-selftest`, `verify-baseline` all match (tested each against the live regex → 1 hit each).
- `%-12s` is too narrow: `verify-selftest` and `verify-baseline` are 15 chars (widest existing target is `distclean`, 9). **Bump to `%-16s` at `Makefile:54`** or accept misaligned help output.

**Section divider** (`Makefile:56-58`, `92-94`, `104-106`, `125-127`) — a rule / title / rule triple. Add one for the verify block:

```make
# ---------------------------------------------------------------------------
# Verification
# ---------------------------------------------------------------------------
```

**Guard style** (`Makefile:111`, `:122`) — `@command -v` probe, `!!` error prefix, actionable remedy, `exit 1`:

```make
	@command -v latexmk >/dev/null 2>&1 || { echo "!! latexmk not found. Run 'make install' first."; exit 1; }
```

> Do **not** put a poppler guard here with `exit 1`. Precondition G0.1 (`01-RESEARCH.md:211`) owns tool checks and must exit **2** ("cannot verify"), which is semantically distinct from Make's `exit 1`. Let `verify-resume.sh` do it.

**Progress echo** (`Makefile:64`, `72`, `86`, `112`, `114`, `135`, `139`) — `>>` prefix for progress, `!!` for errors:

```make
	@echo ">> Building $(PDF) ..."
	cd $(TEX_DIR) && latexmk $(LATEXMK_FLAGS) $(TEX_FILE)
	@echo ">> Built $(PDF)"
```

**File-target + phony-alias pattern** (`Makefile:108-114`) — the shape `verify: $(PDF)` should copy:

```make
build: $(PDF)  ## Compile the resume PDF

$(PDF): $(TEX_DIR)/$(TEX_FILE)
	@command -v latexmk >/dev/null 2>&1 || { echo "!! latexmk not found. Run 'make install' first."; exit 1; }
	@echo ">> Building $(PDF) ..."
	cd $(TEX_DIR) && latexmk $(LATEXMK_FLAGS) $(TEX_FILE)
	@echo ">> Built $(PDF)"
```

Note `cd $(TEX_DIR) && latexmk ...` at `:113` is deliberately **not** `@`-prefixed (the command is echoed).

**`check` target — extend in place** (`Makefile:96-102`). Row pattern: `@printf` a padded label, then `command -v` && version || `MISSING (remedy)`:

```make
check:  ## Print which dependencies are present
	@echo "Checking build dependencies on $$(uname -s)..."
	@printf "  brew     : "; command -v brew     >/dev/null 2>&1 && brew --version | head -1 || echo "MISSING (run 'make install')"
	@printf "  pdflatex : "; command -v pdflatex >/dev/null 2>&1 && pdflatex --version | head -1 || echo "MISSING (run 'make install')"
	@printf "  latexmk  : "; command -v latexmk  >/dev/null 2>&1 && latexmk --version | head -1 || echo "MISSING (run 'make install')"
	@printf "  tlmgr    : "; command -v tlmgr    >/dev/null 2>&1 && echo "ok ($$(command -v tlmgr))" || echo "MISSING (run 'make install')"
	@printf "  source-sans-pro: "; kpsewhich sourcesanspro.sty >/dev/null 2>&1 && echo "ok" || echo "MISSING (run 'make tex-deps')"
```

Note `$$(...)` for shell command substitution (double `$` escapes Make). Labels padded to a common colon column.

**`clean` deletes G0.3's freshness source** (`Makefile:129-135`) — `*.fdb_latexmk` is removed at `:132`, which is exactly the file G0.3 reads (`01-RESEARCH.md:388`). Absent ⇒ *unknown*, escalate to L2; never assume fresh:

```make
clean:  ## Remove LaTeX auxiliary files
	@cd $(TEX_DIR) && (latexmk -c >/dev/null 2>&1 || true)
	@rm -f $(TEX_DIR)/*.aux $(TEX_DIR)/*.log $(TEX_DIR)/*.out \
	       $(TEX_DIR)/*.fls $(TEX_DIR)/*.fdb_latexmk \
	       $(TEX_DIR)/*.synctex.gz $(TEX_DIR)/*.bbl $(TEX_DIR)/*.blg
	@rm -f texput.log
	@echo ">> Cleaned auxiliary files."
```

`clean` intentionally does **not** touch `docs/verify/*` — the manifests are checked-in source, not artifacts. Do not extend the `rm -f` list.

---

### `scripts/verify-resume.sh` (utility, batch transform)

**Analog:** none. **Zero shell scripts are tracked or present in this repo** (`git ls-files | grep -E '\.(sh|bash|zsh)$'` → empty; `find . -name '*.sh'` outside `.git` → empty). The only shell in the codebase is inside Makefile recipes.

**Match style against those recipes** for the user-facing surface — `>>` progress prefix, `!!` errors, `command -v X >/dev/null 2>&1` probes, actionable remedies naming the fixing command (`Makefile:63-68`, `98-102`, `111`, `122`).

Multi-line conditional shape to imitate (`Makefile:63-68`):

```make
	@if ! command -v brew >/dev/null 2>&1; then \
		echo ">> Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://.../install.sh)"; \
	else \
		echo ">> Homebrew already installed: $$(brew --version | head -1)"; \
	fi
```

For everything structural — severity tiers, `RESULT` line format, matchers, the probe injector, the geometry hash, the codepoint census — **the source of truth is `01-RESEARCH.md:742-869` (Code Examples)**, all of which were executed against these exact artifacts. Reuse those snippets verbatim; there is no repo analog to prefer over them.

**Toolchain constraints measured on this machine** (these bound how the script may be written):

| Tool | Version here | Constraint |
|---|---|---|
| `/bin/bash` | **3.2.57** | A clean macOS box has only bash 3.2. `01-RESEARCH.md:880` invokes `@bash $(VERIFY)` (PATH-resolved → brew bash 5.3.15 here, but 3.2 elsewhere). **Write bash-3.2-compatible:** no associative arrays, no `mapfile`/`readarray`, no `${v^^}`/`${v,,}`, no `globstar`. |
| `bash` (PATH) | 5.3.15 (`/opt/homebrew/bin/bash`) | Do not rely on it being present. |
| `grep` | BSD 2.6.0-FreeBSD (GNU compatible) | `-F -x -w -o -c` all present (research-verified). `LC_ALL=C grep -Fxc` is the load-bearing form (`01-RESEARCH.md:265`). |
| `make` | **GNU Make 3.81** | **No `.ONESHELL`** (3.82+). Every recipe line is its own shell — that is *why* the existing file uses `\`-continuation + `;` chaining (`Makefile:63-68`, `71-79`, `82-85`). New multi-line recipes must do the same. Also unavailable: `::=`, `undefine`, `private`, `$(file …)`. |

Shebang / exec bit have no repo precedent. `@bash $(VERIFY)` (`01-RESEARCH.md:880`) makes the exec bit optional; still ship `#!/usr/bin/env bash` + `chmod +x` and `set -uo pipefail` **without `-e`** (per `01-RESEARCH.md:1013` — the harness must run every assertion and aggregate).

---

### `docs/verify/manifest.txt` (config, read-only file-I/O)

**Analog:** `Makefile:20-23` / `:44` — the repo's only `KEY=VALUE`-shaped convention. No `.env`, `.ini`, `.yaml`, `.json`, or `.cfg` config file exists outside `.idea/` and `.github/`.

```make
TEX_DIR    := docs
TEX_FILE   := main.tex
JOBNAME    := AshutoshTiwari
PDF        := $(TEX_DIR)/$(JOBNAME).pdf
...
LATEXMK_FLAGS := -pdf -interaction=nonstopmode -halt-on-error -jobname=$(JOBNAME)
```

Carry over: `UPPER_SNAKE` keys, one per line, `#` comments above or trailing. Drop the `:=` for plain `=` per the research schema (`01-RESEARCH.md:471-493`). Parse with `while IFS= read -r` — **never `source`/`eval`** (`01-RESEARCH.md:1011`).

Comment style for the trailing-annotation rows follows `Makefile`'s inline `#` usage (`Makefile:28-29`, `:25`):

```
LINE_PT=11.5                      # R1: conservative pair
SKILLS_MAX_LINES=3                # today 4; owner Phase 5 -> WARN until then
```

### `docs/verify/baseline-frozen.txt` (config/data, read-only file-I/O)

**Analog (shape only):** `Makefile:30-42` — a one-item-per-line list with a `#` header explaining provenance. Same idea, different syntax: `[section]` groups + bare UTF-8 lines, no continuations, no indentation (leading whitespace would break `grep -Fxc`). Full content is specified at `01-RESEARCH.md:430-458`.

Guard convention: a hand-authored file whose regeneration is gated on `ALLOW_FROZEN_UPDATE=1` (`01-RESEARCH.md:496`). Nothing in the repo models this; it is new.

### `.gitignore` (conditional)

**Analog:** itself.

```
.idea/*
```

One line, glob-with-`/*` style — **not** a trailing-slash directory form. If a deterministic scratch path replaces `mktemp -d`, match the style: `docs/verify/tmp/*`. The research recommends `mktemp -d` (`01-RESEARCH.md:523`, `661`), in which case **`.gitignore` is not touched at all**.

### `.github/workflows/jekyll.yml` (note only — do not change)

Existing CI: a single `build` job on `push`/`pull_request` to `master`, `ubuntu-latest`, one `actions/checkout@v2` step plus a `docker run jekyll/builder` step. Relevant facts for a *future* phase, not this one:

- **Runner is `ubuntu-latest`, not macOS.** The harness is macOS-shaped: `md5 -q` (`01-RESEARCH.md:773`) is BSD-only — Linux has `md5sum`. `01-RESEARCH.md:932` already notes `shasum -a 256` covers both.
- No `latexmk`/`poppler` in the runner image, so `verify-selftest` and the L2 rebuild arbiter would need install steps.
- The workflow builds the Jekyll *site*; it does not touch `docs/main.tex` or the PDF.

**Do not plan CI changes in Phase 1.** Read-only verification (`01-RESEARCH.md:391`, `907`) is what keeps a later CI hookup possible.

---

## Shared Patterns

### Message prefixes
**Source:** `Makefile:64/72/86/112/114/135/139` (progress) and `Makefile:83/111/122` (errors)
**Apply to:** the Makefile targets and `verify-resume.sh` human-summary block (the `RESULT` lines keep their own machine-first format from `01-RESEARCH.md:536`).

```
>> <progress or success>
!! <error> — always with the remedy command, e.g. "Run 'make install' first."
```

### Tool-presence probe
**Source:** `Makefile:63`, `71`, `82`, `98-102`, `111`, `122`
**Apply to:** `check` rows and G0.1 preconditions.

```bash
command -v <tool> >/dev/null 2>&1 && <version cmd> | head -1 || echo "MISSING (<remedy>)"
```

### Hard tabs in recipes and list continuations
**Source:** `Makefile:31-42` (list), every recipe line
**Apply to:** all new Makefile content. Verified with `cat -e -t`: continuation items and recipe bodies are `^I`, and the `help` awk continuation is `^I^I`.

---

## No Analog Found

| File | Role | Data Flow | Reason |
|---|---|---|---|
| `scripts/verify-resume.sh` | utility / CLI | batch transform | **Zero shell scripts in the repo** (verified two ways). No `scripts/` dir. Use `01-RESEARCH.md:742-869` Code Examples as the pattern source; borrow only the message/probe conventions from Makefile recipes. |
| `docs/verify/baseline-frozen.txt` | config / data | file-I/O | No frozen-baseline or golden-file precedent. Full spec at `01-RESEARCH.md:430-458`. |
| — (test framework) | — | — | Confirmed absent: no `pytest.ini`, `package.json`, `test/`, `tests/`, `*.test.*`, `*.spec.*` anywhere (matches `01-RESEARCH.md:953`). `make verify-selftest` is the suite. |

---

## Corrections to RESEARCH.md's Proposed Makefile Snippet

`01-RESEARCH.md:871-892` sketches the targets. Three deviations from this repo's actual Makefile must be corrected during planning:

1. **`check:` must be extended, not redeclared.** The snippet at `01-RESEARCH.md:888` writes a second `check:` rule. `check` already exists at `Makefile:96` with five `@printf` rows. GNU Make emits `warning: overriding recipe for target 'check'` and **discards the original recipe** — silently dropping the brew/pdflatex/latexmk/tlmgr/source-sans-pro checks. **Append the three poppler/python rows into the existing recipe at `Makefile:96-102`.**
2. **`.PHONY` must be appended to the existing single line at `Makefile:48`,** not added as a second directive (`01-RESEARCH.md:877`). Legal Make, but breaks the file's one-line convention.
3. **`$(LATEXMK_FLAGS)` cannot be reused for the probe build.** It hardcodes `-jobname=$(JOBNAME)` (`Makefile:44`), while the self-test requires `-jobname=probe` (`01-RESEARCH.md:524`). The script calls `latexmk` directly with its own flags; do not thread `$(LATEXMK_FLAGS)` into `--selftest`.

Also cosmetic but worth folding in: bump `%-12s` → `%-16s` at `Makefile:54` so the 15-char `verify-selftest` / `verify-baseline` rows align, and add the three new targets to the header doc-block at `Makefile:4-12`.

---

## Metadata

**Analog search scope:** repo root, `docs/`, `.github/`, `css/`, `blogs/`, `blog_pdfs/`, `img/`, `.opencode/skills/` — full tracked-file listing (`git ls-files`, 33 files excluding `.planning/`)
**Files read in full:** `Makefile` (139 ln), `.gitignore` (1 ln), `.github/workflows/jekyll.yml` (20 ln), `README.md` (2 ln), `01-RESEARCH.md` (1129 ln)
**Whitespace / regex / toolchain claims verified by execution:** `cat -e -t` on `Makefile:20-54`; live `grep -E` test of the help regex against all three proposed target names; `bash`/`grep`/`make` version probes
**Pattern extraction date:** 2026-08-21
