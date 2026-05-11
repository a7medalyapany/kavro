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

# ── Colors ───────────────────────────────────────────────────────────────────
BOLD="\033[1m"
DIM="\033[2m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
RESET="\033[0m"

# ── Constants ─────────────────────────────────────────────────────────────────
KAVRO_VERSION="1.0.0"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_NAME="kavro"

# ── Helpers ───────────────────────────────────────────────────────────────────
print_banner() {
  echo ""
  echo -e "${BOLD}${CYAN}┌─────────────────────────────────────────┐${RESET}"
  echo -e "${BOLD}${CYAN}│   Kavro - AI Engineering Orchestrator   │${RESET}"
  echo -e "${BOLD}${CYAN}│        Think before you build.          │${RESET}"
  echo -e "${BOLD}${CYAN}│              v${KAVRO_VERSION}                        │${RESET}"
  echo -e "${BOLD}${CYAN}└─────────────────────────────────────────┘${RESET}"
  echo ""
}

log_info()    { echo -e "${CYAN}  →${RESET} $1"; }
log_success() { echo -e "${GREEN}  ✓${RESET} $1"; }
log_warn()    { echo -e "${YELLOW}  ⚠${RESET} $1"; }
log_error()   { echo -e "${RED}  ✗${RESET} $1"; }
log_step()    { echo -e "\n${BOLD}$1${RESET}"; }

# ── Detection ─────────────────────────────────────────────────────────────────
detect_tools() {
  INSTALL_CLAUDE=false
  INSTALL_CODEX=false
  INSTALL_CURSOR=false
  INSTALL_WINDSURF=false

  # Claude Code - checks for ~/.claude directory
  if [ -d "$HOME/.claude" ]; then
    INSTALL_CLAUDE=true
    log_info "Detected: Claude Code"
  fi

  # Codex CLI - checks for ~/.agents directory or codex binary
  if [ -d "$HOME/.agents" ] || command -v codex &>/dev/null; then
    INSTALL_CODEX=true
    log_info "Detected: Codex CLI"
  fi

  # Cursor - checks if we're in a project and cursor binary exists
  if command -v cursor &>/dev/null; then
    INSTALL_CURSOR=true
    log_info "Detected: Cursor"
  fi

  # Windsurf - checks for windsurf binary
  if command -v windsurf &>/dev/null; then
    INSTALL_WINDSURF=true
    log_info "Detected: Windsurf"
  fi

  # Nothing detected
  if [ "$INSTALL_CLAUDE" = false ] && \
     [ "$INSTALL_CODEX" = false ] && \
     [ "$INSTALL_CURSOR" = false ] && \
     [ "$INSTALL_WINDSURF" = false ]; then
    log_warn "No supported tools detected automatically."
    log_warn "Use a flag to install manually: --claude | --codex | --cursor | --windsurf"
    exit 0
  fi
}

# ── Installers ────────────────────────────────────────────────────────────────
install_claude() {
  log_step "Installing Kavro → Claude Code"

  CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
  TARGET="$CLAUDE_SKILLS_DIR/$SKILL_NAME"
  SOURCE="$REPO_ROOT/adapters/claude"

  mkdir -p "$CLAUDE_SKILLS_DIR"

  if [ -d "$TARGET" ]; then
    log_warn "Kavro already installed at $TARGET - updating..."
    rm -rf "$TARGET"
  fi

  cp -r "$SOURCE" "$TARGET"
  log_success "Installed to $TARGET"
  log_info "Restart Claude Code to activate Kavro."
  log_info "Test: ask Claude to help you design a new feature."
}

install_codex() {
  log_step "Installing Kavro → Codex CLI"

  CODEX_SKILLS_DIR="$HOME/.agents/skills"
  TARGET="$CODEX_SKILLS_DIR/$SKILL_NAME"
  SOURCE="$REPO_ROOT/adapters/codex"

  mkdir -p "$CODEX_SKILLS_DIR"

  if [ -d "$TARGET" ]; then
    log_warn "Kavro already installed at $TARGET - updating..."
    rm -rf "$TARGET"
  fi

  cp -r "$SOURCE" "$TARGET"
  log_success "Installed to $TARGET"
  log_info "Restart Codex to activate Kavro."
  log_info "Test: ask Codex to help you architect a new service."
}

install_cursor() {
  log_step "Installing Kavro → Cursor"

  # Check if we're inside a project
  if [ ! -f "$PWD/.git/config" ] && [ ! -d "$PWD/.git" ]; then
    log_warn "Not inside a Git project. Cursor adapter is project-scoped."
    log_warn "Run this installer from your project root."
    return
  fi

  TARGET="$PWD/.cursorrules"
  SOURCE="$REPO_ROOT/adapters/cursor/.cursorrules"

  if [ -f "$TARGET" ]; then
    log_warn ".cursorrules already exists - backing up to .cursorrules.bak"
    cp "$TARGET" "$TARGET.bak"
    log_info "Your previous rules are saved at .cursorrules.bak"
    echo "" >> "$TARGET"
    echo "" >> "$TARGET"
    cat "$SOURCE" >> "$TARGET"
    log_success "Kavro rules appended to existing .cursorrules"
  else
    cp "$SOURCE" "$TARGET"
    log_success "Installed to $TARGET"
  fi

  log_info "Kavro is now active for this project in Cursor."
  log_info "Test: open Cursor and ask it to design a new feature."
}

install_windsurf() {
  log_step "Installing Kavro → Windsurf"

  if [ ! -f "$PWD/.git/config" ] && [ ! -d "$PWD/.git" ]; then
    log_warn "Not inside a Git project. Windsurf adapter is project-scoped."
    log_warn "Run this installer from your project root."
    return
  fi

  TARGET="$PWD/.windsurfrules"
  SOURCE="$REPO_ROOT/adapters/windsurf/rules.md"

  if [ -f "$TARGET" ]; then
    log_warn ".windsurfrules already exists - backing up to .windsurfrules.bak"
    cp "$TARGET" "$TARGET.bak"
    echo "" >> "$TARGET"
    echo "" >> "$TARGET"
    cat "$SOURCE" >> "$TARGET"
    log_success "Kavro rules appended to existing .windsurfrules"
  else
    cp "$SOURCE" "$TARGET"
    log_success "Installed to $TARGET"
  fi

  log_info "Kavro is now active for this project in Windsurf."
  log_info "You can also paste the contents of adapters/windsurf/rules.md"
  log_info "into Windsurf Settings → AI Rules → Global Rules for global activation."
}

# ── Uninstaller ───────────────────────────────────────────────────────────────
uninstall_all() {
  log_step "Uninstalling Kavro from all tools"

  # Claude Code
  if [ -d "$HOME/.claude/skills/$SKILL_NAME" ]; then
    rm -rf "$HOME/.claude/skills/$SKILL_NAME"
    log_success "Removed from Claude Code"
  fi

  # Codex
  if [ -d "$HOME/.agents/skills/$SKILL_NAME" ]; then
    rm -rf "$HOME/.agents/skills/$SKILL_NAME"
    log_success "Removed from Codex CLI"
  fi

  # Cursor (project)
  if [ -f "$PWD/.cursorrules" ]; then
    log_warn ".cursorrules found - manual removal required."
    log_warn "Kavro rules start with '# Kavro - AI Engineering Orchestrator'"
    log_warn "File location: $PWD/.cursorrules"
  fi

  # Windsurf (project)
  if [ -f "$PWD/.windsurfrules" ]; then
    log_warn ".windsurfrules found - manual removal required."
    log_warn "File location: $PWD/.windsurfrules"
  fi

  log_success "Uninstall complete."
}

# ── Summary ───────────────────────────────────────────────────────────────────
print_summary() {
  echo ""
  echo -e "${BOLD}${GREEN}Kavro is installed. Think before you build.${RESET}"
  echo ""
  echo -e "${DIM}Documentation:  https://github.com/a7medalyapany/kavro${RESET}"
  echo -e "${DIM}Core framework: $REPO_ROOT/core/KAVRO.md${RESET}"
  echo ""
}

# ── Entry Point ───────────────────────────────────────────────────────────────
main() {
  print_banner

  case "${1:-}" in
    --claude)
      install_claude
      ;;
    --codex)
      install_codex
      ;;
    --cursor)
      install_cursor
      ;;
    --windsurf)
      install_windsurf
      ;;
    --all)
      install_claude
      install_codex
      install_cursor
      install_windsurf
      ;;
    --uninstall)
      uninstall_all
      ;;
    "")
      log_step "Auto-detecting installed tools..."
      detect_tools
      if [ "$INSTALL_CLAUDE" = true ];   then install_claude;   fi
      if [ "$INSTALL_CODEX" = true ];    then install_codex;    fi
      if [ "$INSTALL_CURSOR" = true ];   then install_cursor;   fi
      if [ "$INSTALL_WINDSURF" = true ]; then install_windsurf; fi
      ;;
    *)
      log_error "Unknown flag: $1"
      echo ""
      echo "Usage:"
      echo "  bash install.sh              - auto-detect and install all"
      echo "  bash install.sh --claude     - Claude Code only"
      echo "  bash install.sh --codex      - Codex CLI only"
      echo "  bash install.sh --cursor     - Cursor (current project)"
      echo "  bash install.sh --windsurf   - Windsurf (current project)"
      echo "  bash install.sh --all        - all adapters"
      echo "  bash install.sh --uninstall  - remove all installations"
      exit 1
      ;;
  esac

  print_summary
}

main "$@"