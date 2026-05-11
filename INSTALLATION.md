# Kavro - Installation Guide

> *Think before you build.*

---

## Quick Install (Recommended)

Clone the repo and run the universal installer:

```bash
git clone https://github.com/a7medalyapany/kavro.git
cd kavro
bash scripts/install.sh
```

The installer auto-detects which tools you have installed and deploys
the right adapter for each one. That's it.

---

## Manual Installation by Tool

### Claude Code

**Scope:** Global - activates across all your projects.

```bash
# Copy the adapter to Claude Code's skills directory
cp -r adapters/claude ~/.claude/skills/kavro

# Restart Claude Code
# Kavro activates automatically on engineering tasks
```

**Verify installation:**
```bash
ls ~/.claude/skills/kavro
# Should show: SKILL.md  agents/
```

**Test it:**
Open Claude Code and type:
```
I want to build a REST API for user authentication.
```
Kavro should activate automatically and open with Phase 1 - not code.

---

### Claude.ai (Web / Desktop / Mobile)

**Scope:** Global - activates across all conversations.

1. Zip the Claude adapter folder:
```bash
cd adapters
zip -r kavro-claude.zip claude/
```

2. Go to **claude.ai → Settings → Capabilities → Skills**
3. Click **Upload skill**
4. Upload `kavro-claude.zip`
5. Toggle Kavro **on**

**Test it:**
Start a new conversation and type:
```
Help me design the architecture for a new SaaS product.
```
Kavro activates automatically.

---

### Codex CLI

**Scope:** Global - activates across all your projects.

```bash
# Ensure the skills directory exists
mkdir -p ~/.agents/skills

# Copy the adapter
cp -r adapters/codex ~/.agents/skills/kavro

# Restart Codex
# Kavro activates automatically on engineering tasks
```

**Verify installation:**
```bash
ls ~/.agents/skills/kavro
# Should show: SKILL.md  agents/
```

**Test it:**
Open Codex and type:
```
I need to build a background job processor in Go.
```
Kavro activates and begins Phase 1 before any code is written.

---

### Cursor

**Scope:** Project-scoped - activates for the current project only.
Run from your project root.

```bash
# From your project root
cp /path/to/kavro/adapters/cursor/.cursorrules .cursorrules
```

**If you already have a `.cursorrules` file:**
```bash
# Append Kavro rules to your existing file
cat /path/to/kavro/adapters/cursor/.cursorrules >> .cursorrules
```

**Verify:**
```bash
ls -la .cursorrules
# Should exist in your project root
```

**Test it:**
Open Cursor in your project and type:
```
Let's add a payment system to this app.
```
Kavro activates and Phase 1 begins - no code until architecture is defined.

**Note:** `.cursorrules` is project-scoped. Add it to `.gitignore` if you
don't want to commit it, or commit it to enforce Kavro across your team.

---

### Windsurf

**Option A - Project-scoped (via `.windsurfrules`):**

```bash
# From your project root
cp /path/to/kavro/adapters/windsurf/rules.md .windsurfrules
```

**Option B - Global (via Windsurf Settings):**

1. Open Windsurf
2. Go to **Settings → AI Rules → Global Rules**
3. Copy the contents of `adapters/windsurf/rules.md`
4. Paste into the Global Rules field
5. Save

Global rules apply to every project you open in Windsurf.

**Test it:**
Open any project in Windsurf and type:
```
I want to refactor the authentication module.
```
Kavro activates - Phase 1 before any refactoring begins.

---

## Universal Installer Flags

```bash
bash scripts/install.sh              # auto-detect all tools
bash scripts/install.sh --claude     # Claude Code only
bash scripts/install.sh --codex      # Codex CLI only
bash scripts/install.sh --cursor     # Cursor (run from project root)
bash scripts/install.sh --windsurf   # Windsurf (run from project root)
bash scripts/install.sh --all        # all adapters explicitly
bash scripts/install.sh --uninstall  # remove all installations
```

---

## Updating Kavro

```bash
cd kavro
git pull origin main
bash scripts/install.sh
```

The installer overwrites existing installations with the latest version.
Cursor and Windsurf project files need to be manually replaced.

---

## Verifying Kavro is Active

Regardless of tool, the test is the same:

Give your agent an engineering task without explicitly mentioning Kavro.

```
Build me a notification service that sends emails and push notifications.
```

**Expected behavior:**
- Agent announces `## Kavro - Phase 1: Research & Understanding`
- Asks clarifying questions or researches the codebase
- Does NOT write any code
- Produces a Research Summary first

**If Kavro doesn't activate:**
- Claude Code / Codex: restart the tool
- Cursor: confirm `.cursorrules` is in the project root
- Windsurf: confirm `.windsurfrules` is in the project root or global rules are set
- Claude.ai: confirm the skill is toggled on in Settings

---

## Team Installation

To enforce Kavro across your entire team for a project:

**Cursor:**
```bash
# Commit .cursorrules to the repo
git add .cursorrules
git commit -m "chore: add Kavro engineering orchestrator"
```
Every developer who clones the repo gets Kavro automatically.

**Codex / Claude Code:**
Each developer installs globally via the installer.
Add installation instructions to your project's `CONTRIBUTING.md`.

---

## Uninstall

```bash
bash scripts/install.sh --uninstall
```

Or manually:
```bash
rm -rf ~/.claude/skills/kavro      # Claude Code
rm -rf ~/.agents/skills/kavro      # Codex
rm .cursorrules                     # Cursor (project)
rm .windsurfrules                   # Windsurf (project)
```

---

## Troubleshooting

**Kavro triggers on non-engineering tasks**
The skill description uses trigger-phrase matching. If it over-triggers,
this is typically resolved in a future release. Use explicit invocation
in the meantime: mention "Kavro" in your prompt.

**Kavro doesn't trigger automatically**
Check the description field in `adapters/[tool]/SKILL.md`.
Try explicitly invoking: `$kavro` (Codex CLI) or mention "use Kavro" (Claude.ai).

**Phase files not found (Claude Code / Codex)**
The phase files are bundled into the installed adapter under
`<skill>/core/phases/` and the full framework is at `<skill>/core/KAVRO.md`.
This mirrors the repository layout exactly so runtime references like
`core/phases/01-research.md` resolve identically in development and
after installation/build. The skill is fully functional without the
phase files; they enable Level 3 progressive disclosure (loading the
full phase spec only when active).

**Cursor rules conflict with existing `.cursorrules`**
Your existing rules are backed up to `.cursorrules.bak`.
If conflicts occur, manually review both files and merge them.

---

## Structural Guarantees

When you run `bash scripts/install.sh` or `bash scripts/build.sh --claude` the
installer and build system now preserve the source path layout under the
installed skill. Example installed structure for Claude/Codex packages:

~/.claude/skills/kavro/
├─ SKILL.md
├─ agents/
├─ core/
│  ├─ KAVRO.md
│  └─ phases/
│     ├─ 01-research.md
│     └─ ...

This ensures any internal references in SKILL.md or adapter templates that
point to `core/phases/...` or `core/KAVRO.md` work the same in the repo,
during build, and at runtime after install.

## Validation (developer)

Run the included validation scripts to ensure path parity:

```bash
make test-paths       # scans the repo for broken or mixed path references
make validate-dist    # builds dist/ packages and validates contents
make test-install     # simulates install/uninstall in a temp HOME
```

*Kavro v1.0.0 - Think before you build.*
*https://github.com/a7medalyapany/kavro*
