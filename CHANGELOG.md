# Changelog

All notable changes to Kavro are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [1.0.0] - 2026-05-11

### Added
- `core/KAVRO.md` - canonical, tool-agnostic orchestration framework
- 7 phase specification files under `core/phases/`:
  - `01-research.md` - deep research and understanding
  - `02-architecture.md` - system design and technical blueprint
  - `03-decomposition.md` - task decomposition and dependency mapping
  - `04-documentation.md` - documentation baseline and knowledge management
  - `05-prompts.md` - AI prompt orchestration with 8 role-specific templates
  - `06-agent-selection.md` - dynamic agent selection and orchestration patterns
  - `07-governance.md` - execution governance, drift detection, and standards enforcement
- `adapters/claude/SKILL.md` - Claude Code and Claude.ai native adapter
- `adapters/codex/SKILL.md` - Codex CLI native adapter (agentskills.io standard)
- `adapters/cursor/.cursorrules` - Cursor project adapter
- `adapters/windsurf/rules.md` - Windsurf project adapter
- `scripts/install.sh` - universal installer with auto-detection and phase bundling
- `scripts/build.sh` - distributable package builder for Claude.ai and Codex
- `INSTALLATION.md` - detailed per-tool installation guide

### Architecture
- Single source of truth in `core/` - adapters never duplicate phase logic
- Phase files bundled into `core/` at install/build time for Level 3 progressive disclosure
- `dist/` packages assembled by `build.sh` - not stored in the repository

---

## Upcoming

### [1.1.0] - Planned
- Gemini CLI adapter
- GitHub Copilot custom instructions adapter
- packaging/cleanup tasks to ensure core/ is canonical across tools
- agentskills.io registry submission

### [2.0.0] - Long-term
- MCP server wrapper (Go) for stateful orchestration
- Cross-session memory and drift tracking
- Team governance dashboard
