#!/usr/bin/env bash
# Render the full Quarto project to a single Word document (report.docx).
#
# Steps:
#   1. Make sure data/feeding_clean.RData exists (run R/prepare_data.R if not).
#   2. Render report.qmd --to docx, which includes index.qmd / data.qmd / analysis.qmd.

set -euo pipefail

cd "$(dirname "$0")/.."

if [ ! -f data/feeding_clean.RData ]; then
  echo "[render-docx] data/feeding_clean.RData missing — running R/prepare_data.R first..."
  Rscript R/prepare_data.R
fi

quarto render report.qmd --to docx
echo "[render-docx] Done. Output: $(pwd)/report.docx"
