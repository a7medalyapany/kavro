#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Kavro - Universal Installer
# Think before you build.
# https://github.com/a7medalyapany/kavro
#
# Usage:
#   bash install.sh              - auto-detects installed tools, installs all
#   bash install.sh --claude     - Claude Code only
#   bash install.sh --codex      - Codex CLI only
#   bash install.sh --cursor     - Cursor (current project) only
#   bash install.sh --windsurf   - Windsurf (current project) only
#   bash install.sh --all        - all adapters
#   bash install.sh --uninstall  - remove all Kavro installations
# ─────────────────────────────────────────────────────────────────────────────

set -e

BOLD="\033[1m"
DIM="\033[2m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
RESET="\033[0m"

KAVRO_VERSION="1.0.0"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PHASES_DIR="$REPO_ROOT/core/phases"
SKILL_NAME="kavro"

print_banner() {
  echo ""
  echo -e "${BOLD}${CYAN}┌─────────────────────────────────────────┐${RESET}"
  echo -e "${BOLD}${CYAN}│   Kavro - AI Engineering Orchestrator   │${RESET}"
  echo -e "${BOLD}${CYAN}│        Think before you build.          │${RESET}"
  echo -e "${BOLD}${CYAN}│              v${KAVRO_VERSION}                     │${RESET}"
  echo -e "${BOLD}${CYAN}└─────────────────────────────────────────┘${RESET}"
  echo ""
}

log_info()    { echo -e "${CYAN}  →${RESET} $1"; }
log_success() { echo -e "${GREEN}  ✓${RESET} $1"; }
log_warn()    { echo -e "${YELLOW}  ⚠${RESET} $1"; }
log_error()   { echo -e "${RED}  ✗${RESET} $1"; }
log_step()    { echo -e "\n${BOLD}$1${RESET}"; }

# ── Bundle phase files into references/
# Enables Claude Code and Codex Level 3 progressive disclosure:
# the agent loads the full phase spec only when that phase is active,
# keeping context window lean and focused throughout execution.
bundle_phases() {
  local target_dir="$1"
  # Preserve source structure under target_dir/core/phases so runtime
  # references remain identical between repo and installed copy.
  mkdir -p "$target_dir/core/phases"
  for phase_file in "$PHASES_DIR"/*.md; do
    cp "$phase_file" "$target_dir/core/phases/"
  done

  mkdir -p "$target_dir/core"
  cp "$REPO_ROOT/core/KAVRO.md" "$target_dir/core/KAVRO.md"
  log_info "Phase references bundled → core/phases/"
}

# ── Detection
detect_tools() {
  INSTALL_CLAUDE=false
  INSTALL_CODEX=false
  INSTALL_CURSOR=false
  INSTALL_WINDSURF=false

  if [ -d "$HOME/.claude" ]; then
    INSTALL_CLAUDE=true
    log_info "Detected: Claude Code"
  fi

  if [ -d "$HOME/.agents" ] || command -v codex &>/dev/null; then
    INSTALL_CODEX=true
    log_info "Detected: Codex CLI"
  fi

  if command -v cursor &>/dev/null; then
    INSTALL_CURSOR=true
    log_info "Detected: Cursor"
  fi

  if command -v windsurf &>/dev/null; then
    INSTALL_WINDSURF=true
    log_info "Detected: Windsurf"
  fi

  if [ "$INSTALL_CLAUDE" = false ] && \
     [ "$INSTALL_CODEX" = false ] && \
     [ "$INSTALL_CURSOR" = false ] && \
     [ "$INSTALL_WINDSURF" = false ]; then
    log_warn "No supported tools detected automatically."
    log_warn "Use a flag: --claude | --codex | --cursor | --windsurf"
    exit 0
  fi
}

# ── Installers
install_claude() {
  log_step "Installing Kavro → Claude Code"

  TARGET="$HOME/.claude/skills/$SKILL_NAME"
  SOURCE="$REPO_ROOT/adapters/claude"

  mkdir -p "$HOME/.claude/skills"

  if [ -d "$TARGET" ]; then
    log_warn "Kavro already installed - updating..."
    rm -rf "$TARGET"
  fi

  cp -r "$SOURCE" "$TARGET"
  bundle_phases "$TARGET"

  log_success "Installed to $TARGET"
  log_info "Restart Claude Code to activate."
}

install_codex() {
  log_step "Installing Kavro → Codex CLI"

  TARGET="$HOME/.agents/skills/$SKILL_NAME"
  SOURCE="$REPO_ROOT/adapters/codex"

  mkdir -p "$HOME/.agents/skills"

  if [ -d "$TARGET" ]; then
    log_warn "Kavro already installed - updating..."
    rm -rf "$TARGET"
  fi

  cp -r "$SOURCE" "$TARGET"
  bundle_phases "$TARGET"

  log_success "Installed to $TARGET"
  log_info "Restart Codex to activate."
}

install_cursor() {
  log_step "Installing Kavro → Cursor"

  if [ ! -d "$PWD/.git" ]; then
    log_warn "Not inside a Git project. Run from your project root."
    return
  fi

  TARGET="$PWD/.cursorrules"
  SOURCE="$REPO_ROOT/adapters/cursor/.cursorrules"

  if [ -f "$TARGET" ]; then
    log_warn ".cursorrules exists - backing up to .cursorrules.bak"
    cp "$TARGET" "$TARGET.bak"
    printf "\n\n" >> "$TARGET"
    cat "$SOURCE" >> "$TARGET"
    log_success "Kavro rules appended to existing .cursorrules"
  else
    cp "$SOURCE" "$TARGET"
    log_success "Installed to $TARGET"
  fi
}

install_windsurf() {
  log_step "Installing Kavro → Windsurf"

  if [ ! -d "$PWD/.git" ]; then
    log_warn "Not inside a Git project. Run from your project root."
    return
  fi

  TARGET="$PWD/.windsurfrules"
  SOURCE="$REPO_ROOT/adapters/windsurf/rules.md"

  if [ -f "$TARGET" ]; then
    log_warn ".windsurfrules exists - backing up to .windsurfrules.bak"
    cp "$TARGET" "$TARGET.bak"
    printf "\n\n" >> "$TARGET"
    cat "$SOURCE" >> "$TARGET"
    log_success "Kavro rules appended to existing .windsurfrules"
  else
    cp "$SOURCE" "$TARGET"
    log_success "Installed to $TARGET"
  fi

  log_info "For global activation: Windsurf → Settings → AI Rules → Global Rules"
}

# ── Uninstaller
uninstall_all() {
  log_step "Uninstalling Kavro"

  if [ -d "$HOME/.claude/skills/$SKILL_NAME" ]; then
    rm -rf "$HOME/.claude/skills/$SKILL_NAME"
    log_success "Removed from Claude Code"
  fi

  if [ -d "$HOME/.agents/skills/$SKILL_NAME" ]; then
    rm -rf "$HOME/.agents/skills/$SKILL_NAME"
    log_success "Removed from Codex CLI"
  fi

  if [ -f "$PWD/.cursorrules" ]; then
    log_warn ".cursorrules - manual removal required"
    log_warn "Kavro block starts with: # Kavro - AI Engineering Orchestrator"
    log_warn "File: $PWD/.cursorrules"
  fi

  if [ -f "$PWD/.windsurfrules" ]; then
    log_warn ".windsurfrules - manual removal required"
    log_warn "File: $PWD/.windsurfrules"
  fi

  log_success "Uninstall complete."
}

# ── Summary
print_summary() {
  echo ""
  echo -e "${BOLD}${GREEN}Kavro is installed. Think before you build.${RESET}"
  echo ""
  echo -e "${DIM}For Claude.ai web/desktop upload, run:${RESET}"
  echo -e "${DIM}  bash scripts/build.sh --claude${RESET}"
  echo -e "${DIM}  Upload dist/kavro-claude.zip → Settings → Skills${RESET}"
  echo ""
  echo -e "${DIM}https://github.com/a7medalyapany/kavro${RESET}"
  echo ""
}

# ── Entry Point
main() {
  print_banner

  case "${1:-}" in
    --claude)    install_claude ;;
    --codex)     install_codex ;;
    --cursor)    install_cursor ;;
    --windsurf)  install_windsurf ;;
    --all)
      install_claude
      install_codex
      install_cursor
      install_windsurf
      ;;
    --uninstall) uninstall_all ;;
    "")
      log_step "Auto-detecting installed tools..."
      detect_tools
      [ "$INSTALL_CLAUDE" = true ]   && install_claude
      [ "$INSTALL_CODEX" = true ]    && install_codex
      [ "$INSTALL_CURSOR" = true ]   && install_cursor
      [ "$INSTALL_WINDSURF" = true ] && install_windsurf
      ;;
    *)
      log_error "Unknown flag: $1"
      echo "Usage: bash install.sh [--claude|--codex|--cursor|--windsurf|--all|--uninstall]"
      exit 1
      ;;
  esac

  print_summary
}

main "$@"
