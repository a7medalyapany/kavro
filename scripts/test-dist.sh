#!/usr/bin/env bash
set -euo pipefail

# Simulate build and inspect dist package for correct structure

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_SH="$REPO_ROOT/scripts/build.sh"
TMP_DIR="/tmp/kavro-dist-test-$$"

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo "Running build script to create dist/ packages..."
bash "$BUILD_SH" --all

echo "Inspecting dist/ for included core/phases and core/KAVRO.md..."
for zip in "$REPO_ROOT"/dist/*.zip; do
  echo "  Checking $zip"
  unzip -q -d "$TMP_DIR" "$zip"
  # look for kavro/core/phases/01-research.md and kavro/core/KAVRO.md
  if [ ! -f "$TMP_DIR/kavro/core/phases/01-research.md" ]; then
    echo "  ERROR: $zip missing kavro/core/phases/01-research.md"
    exit 3
  fi
  if [ ! -f "$TMP_DIR/kavro/core/KAVRO.md" ]; then
    echo "  ERROR: $zip missing kavro/core/KAVRO.md"
    exit 4
  fi
  rm -rf "$TMP_DIR"/*
done

echo "dist/ packages validated."
exit 0
