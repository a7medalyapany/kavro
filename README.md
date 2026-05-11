# Kavro

> **Think before you build.**

---

AI coding agents are fast. Dangerously fast.

You give them a task. They jump straight to code. No research. No architecture. No tradeoffs. No long-term thinking. They produce something that compiles today and collapses in three weeks, and you're the one left debugging it at midnight.

This isn't a tool problem. It's a process problem.

**Kavro** is the fix.

---

## What Kavro Is

Kavro is a universal AI engineering orchestration framework. It enforces a 7-phase Staff-level engineering workflow on top of any AI coding agent: Claude, Codex, Cursor, Windsurf, or anything else.

It is not a skill library.
It is not a persona switcher.
It is not a collection of prompts.

It is a **process enforcement layer**. A governing framework that wraps around the AI tool you already use and ensures it thinks like a senior engineer before it writes a single line of code.

---

## The 7-Phase Workflow

Every Kavro session enforces this sequence. No shortcuts. No skipping.

| Phase | Name | What Happens |
|---|---|---|
| 1 | Deep Research | Understand the task, the domain, the risks, the codebase |
| 2 | System Design | Blueprint the architecture with full decision documentation |
| 3 | Task Decomposition | Break work into atomic, parallelizable, dependency-aware tasks |
| 4 | Documentation | Generate structured, living docs from day one |
| 5 | Prompt Orchestration | Generate tailored prompts per agent per role |
| 6 | Agent Selection | Choose the right tool for each task, dynamically |
| 7 | Execution Governance | Validate continuously, detect drift, enforce standards |

**Hard rule:** No code is written before Phase 2 is complete. No phase is skipped. Ever.

---

## Why This Exists

The best engineers don't jump to solutions. They ask why before how. They document decisions. They think about the developer who inherits their code in 18 months. They design before they build.

AI agents don't do any of this by default. Kavro makes them.

→ [Read the full philosophy](./docs/why.md)

---

## How It's Different

There are already great skill libraries out there (seriously, go check [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) - 232+ skills, solid work). Kavro is not competing with them. It operates one layer above.

Think of it this way: those skills are **what** the agent can do. Kavro governs **how** the agent does anything.

These skills can run inside Kavro as phase executors. Kavro is the conductor.

---

## Supported Agents

Kavro is built on the [agentskills.io](https://agentskills.io) open standard - the same format adopted by both Anthropic and OpenAI. One framework, multiple adapters.

| Agent | Format | Status |
|---|---|---|
| Claude Code | `SKILL.md` | ✅ v1.0 |
| Claude.ai | `SKILL.md` (upload) | ✅ v1.0 |
| Codex CLI | `SKILL.md` | ✅ v1.0 |
| Cursor | `.cursorrules` | ✅ v1.0 |
| Windsurf | `rules.md` | ✅ v1.0 |
| Gemini CLI | `SKILL.md` | 🔜 v1.1 |

---

## Installation

### Universal installer (recommended)

Auto-detects which tools you have installed and deploys the right adapter:

```bash
git clone https://github.com/a7medalyapany/kavro.git
cd kavro
bash scripts/install.sh
```

### Claude Code

```bash
git clone https://github.com/a7medalyapany/kavro.git
cp -r kavro/adapters/claude ~/.claude/skills/kavro
```

### Claude.ai (web / desktop / mobile)

```bash
cd kavro
bash scripts/build.sh --claude
# Upload dist/kavro-claude.zip → Settings → Capabilities → Skills
```

### Codex CLI

```bash
cp -r kavro/adapters/codex ~/.agents/skills/kavro
```

### Cursor

```bash
cp kavro/adapters/cursor/.cursorrules /path/to/your/project/.cursorrules
```

### Windsurf

```bash
cp kavro/adapters/windsurf/rules.md /path/to/your/project/.windsurfrules
# Or paste into: Settings → AI Rules → Global Rules
```

See [INSTALLATION.md](./INSTALLATION.md) for detailed per-tool instructions and troubleshooting.

---

## Usage

Once installed, Kavro activates automatically when you start any engineering task. You don't invoke it explicitly - it triggers on intent.

**Try asking your agent:**

```
Design a multi-tenant SaaS backend with PostgreSQL and Redis.
```

Without Kavro: you get code.

With Kavro: you get a Research Summary → a Technical Blueprint with full decision documentation → a decomposed task list → implementation - in that exact order.

---

## Contributing

Kavro is an open standard framework. If you have improvements to a phase, a new adapter, or a better prompt pattern - open a PR.

See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

---

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for version history.

---

## License

MIT [LICENSE](./LICENSE) - use it, fork it, build on it.

---

*Kavro - Think before you build.*