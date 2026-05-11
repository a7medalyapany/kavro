#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Kavro — Build Script
# Assembles distributable packages for each adapter.
# Run this before publishing a new release.
#
# Usage:
#   bash scripts/build.sh           — build all packages
#   bash scripts/build.sh --claude  — Claude package only
#   bash scripts/build.sh --codex   — Codex package only
#   bash scripts/build.sh --clean   — remove dist/ folder
#
# Output:
#   dist/kavro-claude.zip   → upload to Claude.ai Settings → Skills
#   dist/kavro-codex.zip    → manual Codex install
# ─────────────────────────────────────────────────────────────────────────────

set -e

# ── Dependency check
if ! command -v zip &>/dev/null; then
  echo ""
  echo "  ✗ 'zip' is required but not installed."
  echo ""
  echo "  Install it:"
  echo "    macOS:   brew install zip"
  echo "    Ubuntu:  sudo apt-get install zip"
  echo "    Fedora:  sudo dnf install zip"
  echo ""
  exit 1
fi

BOLD="\033[1m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
DIM="\033[2m"
RESET="\033[0m"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$REPO_ROOT/dist"
PHASES_DIR="$REPO_ROOT/core/phases"
VERSION=$(grep 'version:' "$REPO_ROOT/adapters/claude/SKILL.md" | head -1 | awk '{print $2}')

log_step()    { echo -e "\n${BOLD}$1${RESET}"; }
log_info()    { echo -e "${CYAN}  →${RESET} $1"; }
log_success() { echo -e "${GREEN}  ✓${RESET} $1"; }

print_banner() {
  echo ""
  echo -e "${BOLD}${CYAN}Kavro Build Script — v${VERSION}${RESET}"
  echo -e "${DIM}Assembling distributable packages...${RESET}"
  echo ""
}

clean() {
  log_step "Cleaning dist/"
  rm -rf "$DIST_DIR"
  log_success "dist/ removed"
}

# ── Build Claude package ──────────────────────────────────────────────────────
# Bundles SKILL.md + agents/openai.yaml + references/ (phase files)
# Output: dist/kavro-claude.zip
# Install: upload to Claude.ai Settings → Capabilities → Skills
build_claude() {
  log_step "Building Claude package"

  STAGING="$DIST_DIR/.staging/kavro"
  mkdir -p "$STAGING/agents"
  # Preserve source structure in distributed package so runtime paths
  # referenced from SKILL.md remain valid. We copy into kavro/core/phases
  mkdir -p "$STAGING/core/phases"

  # Core adapter files
  cp "$REPO_ROOT/adapters/claude/SKILL.md" "$STAGING/SKILL.md"
  cp "$REPO_ROOT/adapters/claude/agents/openai.yaml" "$STAGING/agents/openai.yaml"

  # Bundle phase files preserving the core/phases path so runtime
  # references (e.g. core/phases/01-research.md) resolve correctly.
  for phase_file in "$PHASES_DIR"/*.md; do
    cp "$phase_file" "$STAGING/core/phases/"
  done

  # Bundle core framework into core/KAVRO.md
  mkdir -p "$STAGING/core"
  cp "$REPO_ROOT/core/KAVRO.md" "$STAGING/core/KAVRO.md"

  # Create zip
  cd "$DIST_DIR/.staging"
  zip -r "$DIST_DIR/kavro-claude.zip" kavro/ -x "*.DS_Store" > /dev/null
  cd "$REPO_ROOT"

  log_success "Built: dist/kavro-claude.zip"
  log_info "Install: Claude.ai → Settings → Capabilities → Skills → Upload"
  log_info "Contents:"
  log_info "  kavro/SKILL.md"
  log_info "  kavro/agents/openai.yaml"
  log_info "  kavro/core/phases/ (all 7 phase files)"
  log_info "  kavro/core/KAVRO.md"
}

# ── Build Codex package ───────────────────────────────────────────────────────
# Bundles SKILL.md + agents/openai.yaml + references/ (phase files)
# Output: dist/kavro-codex.zip
# Install: unzip to ~/.agents/skills/
build_codex() {
  log_step "Building Codex package"

  STAGING="$DIST_DIR/.staging-codex/kavro"
  mkdir -p "$STAGING/agents"
  mkdir -p "$STAGING/core/phases"

  # Core adapter files
  cp "$REPO_ROOT/adapters/codex/SKILL.md" "$STAGING/SKILL.md"
  cp "$REPO_ROOT/adapters/codex/agents/openai.yaml" "$STAGING/agents/openai.yaml"

  # Bundle phase files preserving the core/phases path
  for phase_file in "$PHASES_DIR"/*.md; do
    cp "$phase_file" "$STAGING/core/phases/"
  done

  mkdir -p "$STAGING/core"
  cp "$REPO_ROOT/core/KAVRO.md" "$STAGING/core/KAVRO.md"

  # Create zip
  cd "$DIST_DIR/.staging-codex"
  zip -r "$DIST_DIR/kavro-codex.zip" kavro/ -x "*.DS_Store" > /dev/null
  cd "$REPO_ROOT"

  log_success "Built: dist/kavro-codex.zip"
  log_info "Install: unzip kavro-codex.zip -d ~/.agents/skills/"
  log_info "Contents:"
  log_info "  kavro/SKILL.md"
  log_info "  kavro/agents/openai.yaml"
  log_info "  kavro/core/phases/ (all 7 phase files)"
  log_info "  kavro/core/KAVRO.md"
}

# ── Cleanup staging ───────────────────────────────────────────────────────────
cleanup_staging() {
  rm -rf "$DIST_DIR/.staging"
  rm -rf "$DIST_DIR/.staging-codex"
}

# ── Summary ───────────────────────────────────────────────────────────────────
print_summary() {
  echo ""
  echo -e "${BOLD}${GREEN}Build complete.${RESET}"
  echo ""
  echo -e "${DIM}Packages in dist/:${RESET}"
  for f in "$DIST_DIR"/*.zip; do
    size=$(du -sh "$f" 2>/dev/null | awk '{print $1}')
    echo -e "${DIM}  $(basename $f) — $size${RESET}"
  done
  echo ""
  echo -e "${DIM}Next steps:${RESET}"
  echo -e "${DIM}  Claude.ai → Settings → Capabilities → Skills → Upload kavro-claude.zip${RESET}"
  echo -e "${DIM}  Codex → unzip kavro-codex.zip -d ~/.agents/skills/${RESET}"
  echo ""
}

# ── Entry Point ───────────────────────────────────────────────────────────────
main() {
  print_banner
  mkdir -p "$DIST_DIR"

  case "${1:-}" in
    --claude)
      build_claude
      cleanup_staging
      ;;
    --codex)
      build_codex
      cleanup_staging
      ;;
    --clean)
      clean
      ;;
    ""|--all)
      build_claude
      build_codex
      cleanup_staging
      ;;
    *)
      echo "Usage: bash scripts/build.sh [--claude|--codex|--clean|--all]"
      exit 1
      ;;
  esac

  print_summary
}

main "$@"
