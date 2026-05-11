#!/usr/bin/env bash
set -euo pipefail

# Simulate install into a temp HOME and verify installed structure and uninstall

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_SH="$REPO_ROOT/scripts/install.sh"
TMP_HOME="/tmp/kavro-install-test-$$"

export HOME="$TMP_HOME"
mkdir -p "$HOME"

echo "Simulating installer with HOME=$HOME"

bash "$INSTALL_SH" --claude

if [ ! -d "$HOME/.claude/skills/kavro/core/phases" ]; then
  echo "ERROR: Installed Claude skill missing core/phases"
  exit 5
fi

if [ ! -f "$HOME/.claude/skills/kavro/core/KAVRO.md" ]; then
  echo "ERROR: Installed Claude skill missing core/KAVRO.md"
  exit 6
fi

echo "Claude install structure OK."

bash "$INSTALL_SH" --codex
if [ ! -d "$HOME/.agents/skills/kavro/core/phases" ]; then
  echo "ERROR: Installed Codex skill missing core/phases"
  exit 7
fi
echo "Codex install structure OK."

echo "Testing uninstall..."
bash "$INSTALL_SH" --uninstall

if [ -d "$HOME/.claude/skills/kavro" ] || [ -d "$HOME/.agents/skills/kavro" ]; then
  echo "ERROR: Uninstall did not remove installed artifacts"
  exit 8
fi

echo "Install/uninstall flow validated."
exit 0
