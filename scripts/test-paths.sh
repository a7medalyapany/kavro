#!/usr/bin/env bash
set -euo pipefail

# Validate that all phase references in adapters and rules point to existing
# core/phases files and that there is no mixture of core/phases vs references/ paths.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

errors=0

echo "Checking repository for path consistency..."

# Find files referencing core/phases or references/
matches=$(rg --hidden --no-ignore -n "core/phases/|references/" || true)

if [ -z "$matches" ]; then
  echo "No path references found."
  exit 0
fi

echo "$matches" | while IFS= read -r line; do
  file=$(echo "$line" | sed -E 's/:.*//')
  rest=$(echo "$line" | sed -E 's/^[^:]+:(.*)/\1/')
  # Extract all path-like tokens
  for path in $(echo "$rest" | grep -oE "(core/phases/[0-9]{2}-[a-z0-9-]+\.md|core/KAVRO.md|references/[A-Za-z0-9_./-]+|references/[A-Za-z0-9_./-]+)" || true); do
    # Normalize
    if [[ $path == references/* ]]; then
      echo "  ERROR: Found runtime-style 'references/' path in source: $file -> $path"
      errors=$((errors+1))
    fi
    if [[ $path == core/phases/* || $path == core/KAVRO.md ]]; then
      target="$REPO_ROOT/$path"
      if [ ! -f "$target" ]; then
        echo "  ERROR: Referenced file missing: $file -> $path (expected at $target)"
        errors=$((errors+1))
      fi
    fi
  done
done

if [ "$errors" -ne 0 ]; then
  echo "Path consistency checks FAILED with $errors errors."
  exit 2
fi

echo "Path consistency checks PASSED."
exit 0
