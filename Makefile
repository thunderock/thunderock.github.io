# =============================================================================
# Resume build Makefile (macOS)
#
# Common targets:
#   make            - check deps, build the resume, open it in Preview
#   make install    - install MacTeX/BasicTeX + required TeX packages via brew
#   make check      - print which dependencies are present / missing
#   make build      - compile docs/main.tex -> docs/AshutoshTiwari.pdf
#   make view       - open docs/AshutoshTiwari.pdf in macOS Preview
#   make watch      - latexmk -pvc continuous build
#   make clean      - remove auxiliary build artifacts
#   make distclean  - clean + remove the generated PDF
#
# Notes:
#   - This Makefile assumes macOS. It uses Homebrew (and brew --cask) for setup.
#   - MacTeX puts binaries in /Library/TeX/texbin, which is added to PATH below.
#   - BasicTeX is small (~100 MB) and enough for this resume; MacTeX is ~5 GB.
# =============================================================================

TEX_DIR    := docs
TEX_FILE   := main.tex
JOBNAME    := AshutoshTiwari
PDF        := $(TEX_DIR)/$(JOBNAME).pdf

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

.PHONY: all help install brew mactex tex-deps check build view open watch clean distclean

all: check build view  ## Default: check deps, build, then open the PDF

help:  ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

# ---------------------------------------------------------------------------
# Dependency installation (idempotent)
# ---------------------------------------------------------------------------

install: brew mactex tex-deps  ## Install Homebrew, BasicTeX, and required TeX packages

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
# Cleanup
# ---------------------------------------------------------------------------

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
