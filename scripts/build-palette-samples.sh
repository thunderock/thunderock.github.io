#!/bin/bash
# =============================================================================
# build-palette-samples.sh — palette sample + WCAG-measurement harness (VIS-01)
#
# Renders the FINAL frozen resume (docs/main.tex) under each candidate accent
# palette as a 2-page PDF, produces a grayscale conversion, and computes the
# fixed WCAG contrast bar from the hex literals (never from a rendered raster).
#
# The palette is a single-hue family (D-02): `accent` carries the rules,
# `accentdark` carries all text. A swap is exactly two hex literals; this
# harness substitutes those two by CONTENT and leaves every other byte of
# main.tex identical. It NEVER edits the tracked source — it copies to a
# scratch dir, builds there, and copies only the PDFs to build/palette/.
#
# Usage:
#   scripts/build-palette-samples.sh            # all four columns (default)
#   scripts/build-palette-samples.sh all        # all four columns
#   scripts/build-palette-samples.sh navy       # one named column
#
# Fixed bar (PITFALLS.md Pitfall 20 / ARCHITECTURE.md §4.3, inclusive >=):
#   text     (accentdark vs white)          >= 7:1
#   rule     (accent vs white)              >= 3:1
#   grayText (BT.601 luma of accentdark)    >= 4.5:1
#   grayRule (BT.601 luma of accent)        >= 3:1
#   pages == 2
#
# bash 3.2 compatible; no associative arrays, no process-substitution.
# =============================================================================

set -euo pipefail

# latexmk lives in the MacTeX texbin, which is not on a non-login PATH.
export PATH="/Library/TeX/texbin:$PATH"

# Temp cleanup on any exit path (error/Ctrl-C included): the success paths
# already remove both the per-build scratch tree (build_one) and the summary
# accumulator (all-mode), so this only backstops the error/interrupt paths.
# The accumulator is always safe to drop; the scratch is kept only when a
# latexmk failure set KEEP_SCRATCH=1 to leave it for inspection.
SCRATCH=""; SUMMARY_ACC=""; KEEP_SCRATCH=0
cleanup() {
  [ -n "${SUMMARY_ACC:-}" ] && rm -f "$SUMMARY_ACC" 2>/dev/null || true
  [ "${KEEP_SCRATCH:-0}" = 1 ] || { [ -n "${SCRATCH:-}" ] && rm -rf "$SCRATCH" 2>/dev/null; } || true
}
trap cleanup EXIT INT TERM

REPO="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$REPO/docs/main.tex"
OUTDIR="$REPO/build/palette"

[ -f "$SRC" ] || { echo "!! source not found: $SRC" >&2; exit 2; }
command -v latexmk >/dev/null 2>&1 || { echo "!! latexmk not on PATH (run 'make install')" >&2; exit 2; }
command -v pdfinfo >/dev/null 2>&1 || { echo "!! pdfinfo not on PATH (brew install poppler)" >&2; exit 2; }
command -v python3 >/dev/null 2>&1 || { echo "!! python3 not on PATH" >&2; exit 2; }

mkdir -p "$OUTDIR"

# Incumbent teal literals in main.tex — the sed keys. Substituting these two,
# and only these two, keeps every other line byte-identical (for the teal
# column A/D equal the keys, so the scratch copy is byte-identical to source).
TEAL_ACCENT="17685C"
TEAL_ACCENTDARK="0E463E"

# Map a hue name to its (accent, accentdark) hexes. ARCHITECTURE.md §4.4.
A=""; D=""
hue_hexes() {
  case "$1" in
    teal)     A="17685C"; D="0E463E" ;;
    navy)     A="1F4E79"; D="14345B" ;;
    oxblood)  A="7B2D3B"; D="571F29" ;;
    graphite) A="3E4A59"; D="22303C" ;;
    *) echo "!! unknown hue: $1 (expected teal|navy|oxblood|graphite|all)" >&2; return 1 ;;
  esac
}

# Compute + print the four contrast numbers, PASS/FAIL each, and the machine line.
measure() {
  # args: name accentHex accentdarkHex pages
  python3 - "$1" "$2" "$3" "$4" <<'PY'
import sys
name, A, D, pages = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4])

def hx(h):
    return int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)

def lin(c):
    c /= 255.0
    return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4

def relL(r, g, b):
    return 0.2126 * lin(r) + 0.7152 * lin(g) + 0.0722 * lin(b)

def cw(r, g, b):                       # WCAG contrast vs white
    return 1.05 / (relL(r, g, b) + 0.05)

def bt601(r, g, b):                    # ITU-R BT.601 luma, rounded to a gray byte
    return int(round(0.299 * r + 0.587 * g + 0.114 * b))

ar, ag, ab = hx(A)
dr, dg, db = hx(D)

text = cw(dr, dg, db)                  # accentdark vs white  (all body text)
rule = cw(ar, ag, ab)                  # accent     vs white  (vector rules)
gd = bt601(dr, dg, db); gtext = cw(gd, gd, gd)
ga = bt601(ar, ag, ab); grule = cw(ga, ga, ga)

def v(val, bar):
    return "PASS" if val >= bar - 1e-9 else "FAIL"

tP, rP, gtP, grP = v(text, 7.0), v(rule, 3.0), v(gtext, 4.5), v(grule, 3.0)
pgP = "PASS" if pages == 2 else "FAIL"
V = "PASS" if all(x == "PASS" for x in (tP, rP, gtP, grP, pgP)) else "FAIL"

print("   accentdark #%s  text vs white           = %5.2f:1  (>= 7:1)    %s" % (D, text, tP))
print("   accent     #%s  rule vs white           = %5.2f:1  (>= 3:1)    %s" % (A, rule, rP))
print("   grayscale  #%02X%02X%02X  text (BT.601) vs white = %5.2f:1  (>= 4.5:1)  %s" % (gd, gd, gd, gtext, gtP))
print("   grayscale  #%02X%02X%02X  rule (BT.601) vs white = %5.2f:1  (>= 3:1)    %s" % (ga, ga, ga, grule, grP))
print("   pages = %d  (== 2)  %s" % (pages, pgP))
print(">> PALETTE %s text=%.2f:1 rule=%.2f:1 grayText=%.2f:1 grayRule=%.2f:1 pages=%d VERDICT=%s"
      % (name, text, rule, gtext, grule, pages, V))
PY
}

build_one() {
  name="$1"
  hue_hexes "$name" || return 1

  echo "=============================================================="
  echo "== $name (accent #$A / accentdark #$D)"
  echo "=============================================================="

  SCRATCH="$(mktemp -d "${TMPDIR:-/tmp}/palette.XXXXXX")"

  # Substitute the two color-def literals by content; every other line stays
  # byte-identical. \definecolor{accent}{HTML}{...} and {accentdark}{HTML}{...}
  # are the only lines carrying these exact substrings ({accentlight} differs).
  sed -e "s/{accent}{HTML}{$TEAL_ACCENT}/{accent}{HTML}{$A}/" \
      -e "s/{accentdark}{HTML}{$TEAL_ACCENTDARK}/{accentdark}{HTML}{$D}/" \
      "$SRC" > "$SCRATCH/main.tex"

  if ! ( cd "$SCRATCH" && latexmk -pdf -interaction=nonstopmode -halt-on-error \
           -jobname="palette-$name" main.tex >/dev/null 2>&1 ); then
    echo "!! latexmk failed for $name — scratch left at $SCRATCH for inspection" >&2
    KEEP_SCRATCH=1
    return 1
  fi

  cp "$SCRATCH/palette-$name.pdf" "$OUTDIR/palette-$name.pdf"
  pages="$(pdfinfo "$OUTDIR/palette-$name.pdf" | awk '/^Pages:/{print $2}')"

  # Grayscale conversion — best-effort, layered so it works without a working
  # ghostscript. The numeric grayscale contrast (below) is computed from the
  # hex regardless of whether a grayscale PDF renders.
  #   1. ghostscript pdfwrite Gray  — vector-preserving, smallest; used if gs
  #      is present AND actually functional (some installs are missing their
  #      resource dir and fail at runtime).
  #   2. poppler pdftoppm -gray + ImageMagick — gs-free raster grayscale PDF.
  GRAY_OUT="$OUTDIR/palette-$name-gray.pdf"
  IMG_TOOL=""
  command -v magick  >/dev/null 2>&1 && IMG_TOOL="magick"
  [ -z "$IMG_TOOL" ] && command -v convert >/dev/null 2>&1 && IMG_TOOL="convert"

  if command -v gs >/dev/null 2>&1 && \
     gs -sDEVICE=pdfwrite -sColorConversionStrategy=Gray \
        -dProcessColorModel=/DeviceGray -dCompatibilityLevel=1.4 \
        -dNOPAUSE -dBATCH -dQUIET \
        -sOutputFile="$GRAY_OUT" "$OUTDIR/palette-$name.pdf" >/dev/null 2>&1; then
    echo "   grayscale render (gs, vector): build/palette/palette-$name-gray.pdf"
  elif command -v pdftoppm >/dev/null 2>&1 && [ -n "$IMG_TOOL" ] && \
       pdftoppm -gray -r 150 "$OUTDIR/palette-$name.pdf" "$SCRATCH/gpg" >/dev/null 2>&1 && \
       "$IMG_TOOL" "$SCRATCH"/gpg-*.pgm -colorspace Gray "$GRAY_OUT" >/dev/null 2>&1; then
    echo "   grayscale render ($IMG_TOOL, 150dpi raster): build/palette/palette-$name-gray.pdf"
  else
    rm -f "$GRAY_OUT"
    echo "   grayscale render skipped: no working gs and no pdftoppm+imagemagick on PATH"
  fi

  echo "   color PDF: build/palette/palette-$name.pdf"
  MOUT="$(measure "$name" "$A" "$D" "$pages")"
  printf '%s\n' "$MOUT"
  # Accumulate the machine line for the final summary table (all-mode).
  if [ -n "${SUMMARY_ACC:-}" ]; then
    printf '%s\n' "$MOUT" | grep '^>> PALETTE' >> "$SUMMARY_ACC"
  fi
  echo ""

  rm -rf "$SCRATCH"
}

# Render the accumulated machine lines as one aligned comparison table — the
# side-by-side the VIS-01 checkpoint reads. Fixed bar restated in the header.
print_summary() {
  [ -s "$1" ] || return 0
  echo "=============================================================="
  echo "== SUMMARY — fixed WCAG bar: text>=7:1 rule>=3:1 grayText>=4.5:1 grayRule>=3:1, pages==2"
  echo "=============================================================="
  awk '
    BEGIN {
      printf "  %-9s %8s %8s %10s %10s %6s %8s\n", \
             "palette","text","rule","grayText","grayRule","pages","VERDICT"
    }
    {
      name=$3
      for (i=1;i<=NF;i++) {
        if ($i ~ /^text=/)     { t=$i;  sub(/text=/,"",t) }
        if ($i ~ /^rule=/)     { r=$i;  sub(/rule=/,"",r) }
        if ($i ~ /^grayText=/) { gt=$i; sub(/grayText=/,"",gt) }
        if ($i ~ /^grayRule=/) { gr=$i; sub(/grayRule=/,"",gr) }
        if ($i ~ /^pages=/)    { p=$i;  sub(/pages=/,"",p) }
        if ($i ~ /^VERDICT=/)  { v=$i;  sub(/VERDICT=/,"",v) }
      }
      printf "  %-9s %8s %8s %10s %10s %6s %8s\n", name,t,r,gt,gr,p,v
    }
  ' "$1"
  echo ""
  echo "Open the eight PDFs in build/palette/ (four color + four grayscale) side by side to pick."
}

ARG="${1:-all}"
if [ "$ARG" = "all" ]; then
  SUMMARY_ACC="$(mktemp "${TMPDIR:-/tmp}/palette-summary.XXXXXX")"
  for n in teal navy oxblood graphite; do
    build_one "$n"
  done
  print_summary "$SUMMARY_ACC"
  rm -f "$SUMMARY_ACC"
else
  build_one "$ARG"
fi
