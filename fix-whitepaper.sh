#!/usr/bin/env bash
# fix-whitepaper.sh
# Fixes the `site/` path prefix in whitepaper.qmd so Quarto finds the theme
# and partials that live at the repo root (that's what caused the FATAL
# "unable to open file site/_header.html" errors).
#
# Usage — run from the root of your nytel.ai clone:
#   bash fix-whitepaper.sh
# (or pass the path:  bash fix-whitepaper.sh path/to/whitepaper.qmd )

set -euo pipefail

QMD="${1:-whitepaper.qmd}"
if [ ! -f "$QMD" ]; then
  echo "Can't find $QMD. Run this from your nytel.ai clone, or pass the path as an argument."
  exit 1
fi

cp "$QMD" "$QMD.bak"

sed -i.tmp \
  -e 's#site/nytel\.scss#nytel.scss#g' \
  -e 's#site/_header-meta\.html#_header-meta.html#g' \
  -e 's#site/_header\.html#_header.html#g' \
  -e 's#site/_footer\.html#_footer.html#g' \
  "$QMD"
rm -f "$QMD.tmp"

echo "Patched $QMD  (backup saved to $QMD.bak)"
echo "Any remaining site/ references:"
grep -n "site/" "$QMD" || echo "  none — good."
echo
echo "Next:"
echo "  1) Copy the 6 corrected files from the nytel-latest download into this clone."
echo "  2) quarto render $QMD"
