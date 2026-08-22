# =============================================================================
# Resume build Makefile (macOS)
#
# Common targets:
#   make                  - check deps, build the resume, open it in Preview
#   make install          - install MacTeX/BasicTeX + required TeX packages via brew
#   make check            - print which dependencies are present / missing
#   make build            - compile docs/main.tex -> docs/AshutoshTiwari.pdf
#   make view             - open docs/AshutoshTiwari.pdf in macOS Preview
#   make watch            - latexmk -pvc continuous build
#   make verify           - gate the PDF: page budget, ATS text layer, honesty freeze
#   make verify-selftest  - prove the gates fire (overflow probe + negative controls)
#   make verify-baseline  - regenerate docs/verify/manifest.txt from live measurement
#   make clean            - remove auxiliary build artifacts
#   make distclean        - clean + remove the generated PDF
#
# Notes:
#   - This Makefile assumes macOS. It uses Homebrew (and brew --cask) for setup.
#   - MacTeX puts binaries in /Library/TeX/texbin, which is added to PATH below.
#   - BasicTeX is small (~100 MB) and enough for this resume; MacTeX is ~5 GB.
#   - The verify targets need poppler (pdfinfo, pdftotext); 'make install' adds it.
# =============================================================================

TEX_DIR    := docs
TEX_FILE   := main.tex
JOBNAME    := AshutoshTiwari
PDF        := $(TEX_DIR)/$(JOBNAME).pdf
VERIFY     := scripts/verify-resume.sh

# Make sure /Library/TeX/texbin is reachable even in non-login shells.
export PATH := /Library/TeX/texbin:$(PATH)

# Required TeX packages used by docs/main.tex (sourcesanspro and friends are
# not part of BasicTeX by default).
TEX_PKGS := \
	latexmk \
	collection-fontsrecommended \
	sourcesanspro \
	fontaxes \
	mweights \
	titlesec \
	enumitem \
	fancyhdr \
	tabularx \
	ragged2e \
	marvosym \
	xcolor

LATEXMK_FLAGS := -pdf -interaction=nonstopmode -halt-on-error -jobname=$(JOBNAME)

.DEFAULT_GOAL := all

.PHONY: all help install brew mactex tex-deps poppler check build view open watch verify verify-selftest verify-baseline clean distclean

all: check build view  ## Default: check deps, build, then open the PDF

help:  ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

# ---------------------------------------------------------------------------
# Dependency installation (idempotent)
# ---------------------------------------------------------------------------

install: brew mactex tex-deps poppler  ## Install Homebrew, BasicTeX, required TeX packages, and poppler

brew:
	@if ! command -v brew >/dev/null 2>&1; then \
		echo ">> Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	else \
		echo ">> Homebrew already installed: $$(brew --version | head -1)"; \
	fi

mactex:
	@if ! command -v latexmk >/dev/null 2>&1 || ! command -v pdflatex >/dev/null 2>&1; then \
		echo ">> Installing BasicTeX (small TeX Live distribution) via Homebrew..."; \
		brew install --cask basictex; \
		echo ">> BasicTeX installed. New shells will pick up /Library/TeX/texbin automatically."; \
	else \
		echo ">> TeX toolchain already installed:"; \
		echo "   pdflatex: $$(pdflatex --version | head -1)"; \
		echo "   latexmk : $$(latexmk --version | head -1)"; \
	fi

tex-deps:
	@if ! command -v tlmgr >/dev/null 2>&1; then \
		echo "!! tlmgr not found on PATH. Open a new shell so /Library/TeX/texbin is picked up, then re-run 'make install'."; \
		exit 1; \
	fi
	@echo ">> Updating tlmgr (you may be prompted for sudo)..."
	@sudo tlmgr update --self || true
	@echo ">> Installing TeX packages required by the resume..."
	@sudo tlmgr install $(TEX_PKGS) || true
	@echo ">> TeX dependencies ready."

# pdfinfo and pdftotext are what the verification harness measures the PDF with.
# They live in a directory a normal PATH already covers, so no PATH export needed.
poppler:
	@if ! command -v pdfinfo >/dev/null 2>&1 || ! command -v pdftotext >/dev/null 2>&1; then \
		echo ">> Installing poppler (pdfinfo, pdftotext) via Homebrew..."; \
		brew install poppler; \
	else \
		echo ">> poppler already installed: $$(pdfinfo -v 2>&1 | head -1)"; \
	fi

# ---------------------------------------------------------------------------
# Diagnostic
# ---------------------------------------------------------------------------

check:  ## Print which dependencies are present
	@echo "Checking build dependencies on $$(uname -s)..."
	@printf "  brew     : "; command -v brew     >/dev/null 2>&1 && brew --version | head -1 || echo "MISSING (run 'make install')"
	@printf "  pdflatex : "; command -v pdflatex >/dev/null 2>&1 && pdflatex --version | head -1 || echo "MISSING (run 'make install')"
	@printf "  latexmk  : "; command -v latexmk  >/dev/null 2>&1 && latexmk --version | head -1 || echo "MISSING (run 'make install')"
	@printf "  tlmgr    : "; command -v tlmgr    >/dev/null 2>&1 && echo "ok ($$(command -v tlmgr))" || echo "MISSING (run 'make install')"
	@printf "  source-sans-pro: "; kpsewhich sourcesanspro.sty >/dev/null 2>&1 && echo "ok" || echo "MISSING (run 'make tex-deps')"
	@printf "  pdfinfo  : "; command -v pdfinfo  >/dev/null 2>&1 && pdfinfo -v 2>&1 | head -1 || echo "MISSING (run 'brew install poppler')"
	@printf "  pdftotext: "; command -v pdftotext >/dev/null 2>&1 && pdftotext -v 2>&1 | head -1 || echo "MISSING (run 'brew install poppler')"
	@printf "  python3  : "; command -v python3  >/dev/null 2>&1 && python3 --version || echo "MISSING (install Xcode command line tools)"

# ---------------------------------------------------------------------------
# Build / view
# ---------------------------------------------------------------------------

build: $(PDF)  ## Compile the resume PDF

$(PDF): $(TEX_DIR)/$(TEX_FILE)
	@command -v latexmk >/dev/null 2>&1 || { echo "!! latexmk not found. Run 'make install' first."; exit 1; }
	@echo ">> Building $(PDF) ..."
	cd $(TEX_DIR) && latexmk $(LATEXMK_FLAGS) $(TEX_FILE)
	@echo ">> Built $(PDF)"

view: $(PDF)  ## Open the PDF in macOS Preview
	@open $(PDF)

open: view  ## Alias for `make view`

watch:  ## Continuous build with latexmk -pvc
	@command -v latexmk >/dev/null 2>&1 || { echo "!! latexmk not found. Run 'make install' first."; exit 1; }
	cd $(TEX_DIR) && latexmk $(LATEXMK_FLAGS) -pvc $(TEX_FILE)

# ---------------------------------------------------------------------------
# Verification
# ---------------------------------------------------------------------------

# Measured behaviour of GNU Make 3.81 that shapes how these targets can be
# asserted: ANY failed recipe makes make itself exit 2, whatever the recipe
# returned (a recipe returning 1 gives make exit 2; a recipe returning 2 also
# gives make exit 2). So `make verify` is only ever assertable as "exits
# non-zero". The harness's own vocabulary -- 0 all gates pass, 1 the document is
# wrong, 2 cannot verify -- is observable only by invoking bash $(VERIFY)
# directly, which is what the phase gate and the harness's own staleness control
# do. Do not try to forward the script's code through the recipe: make's exit
# status is not configurable in 3.81, and the workaround would only hide where
# the real distinction lives.
#
# What `verify: $(PDF)` actually does, measured with make's what-if mode
# (`make -n -W docs/main.tex verify`, which changes no file): make builds the PDF
# when it is MISSING **and rebuilds it whenever docs/main.tex carries a strictly
# newer mtime**, then verifies the artifact it just built. So on an edited source
# this target is build-then-verify, and it overwrites the tracked PDF and its aux
# files in the process. The "nothing to be done" case people remember is the
# equal-mtimes one: a fresh checkout stamps source and artifact identically, so
# make rebuilds nothing and the committed PDF is verified as-is.
#
# That is also why mtime is not, and cannot be, the freshness proof. make's
# comparison says nothing about provenance in either direction -- equal mtimes do
# not prove the PDF came from this source, and a rebuild only proves it did once
# make had already replaced it. The harness therefore carries its own content-hash
# proof (G0.3, md5 against the latexmk record) and refuses at exit 2 rather than
# verifying an artifact it cannot tie to the current source. If you want to gate
# the committed artifact without any chance of rebuilding it first, invoke
# `bash $(VERIFY)` directly.
#
# No target waives the harness's freshness proof. The one flag that can waive it
# exists solely for the harness's own geometry negative control, is named only
# inside the script, and must never appear here: a target carrying it would turn
# `make verify` into a run that cannot refuse a stale artifact.
verify: $(PDF)  ## Gate the PDF: page budget, page-1 boundary, ATS text layer, honesty freeze
	@bash $(VERIFY)

verify-selftest:  ## Prove the gates fire: overflow probe + five negative controls
	@bash $(VERIFY) --selftest

verify-baseline:  ## Regenerate docs/verify/manifest.txt (honesty freeze needs ALLOW_FROZEN_UPDATE=1)
	@bash $(VERIFY) --write-baseline

# ---------------------------------------------------------------------------
# Cleanup
# ---------------------------------------------------------------------------

# Note: this deletes *.fdb_latexmk, which is the primary source the harness's
# freshness proof reads. That is safe by construction -- an absent record means
# freshness is UNKNOWN, never assumed fresh, so the harness escalates to a
# scratch rebuild and compares the rendered documents instead. The checked-in
# verification manifests are source, not artifacts, and are not touched here.
#
# One consequence is worth knowing before you read a self-test report: the G8.3
# staleness control asserts the record-based (L1) refusal path, so with the record
# deleted it reports SKIP and names 'make build' as the remedy. That is the
# designed degradation, not a harness failure -- run 'make build' to restore the
# record and the control becomes exercisable again.
clean:  ## Remove LaTeX auxiliary files
	@cd $(TEX_DIR) && (latexmk -c >/dev/null 2>&1 || true)
	@rm -f $(TEX_DIR)/*.aux $(TEX_DIR)/*.log $(TEX_DIR)/*.out \
	       $(TEX_DIR)/*.fls $(TEX_DIR)/*.fdb_latexmk \
	       $(TEX_DIR)/*.synctex.gz $(TEX_DIR)/*.bbl $(TEX_DIR)/*.blg
	@rm -f texput.log
	@echo ">> Cleaned auxiliary files."

distclean: clean  ## Clean + remove the generated PDF
	@rm -f $(PDF)
	@echo ">> Removed $(PDF)."
