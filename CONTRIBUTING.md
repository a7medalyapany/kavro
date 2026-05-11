# Contributing to Kavro

> *Think before you build.* - this applies here too.

Thank you for your interest in improving Kavro. This document explains
how to contribute effectively and what kinds of contributions are most valuable.

---

## What Makes a Good Contribution

Kavro is a framework, not a feature collection. Good contributions:

- **Improve the quality of a phase** - sharper questions, better templates, clearer rules
- **Add a new adapter** - support for a new AI coding tool
- **Fix an inaccuracy** - something in the framework that is wrong or misleading
- **Improve the installer** - better detection, edge case handling, platform support
- **Add real-world examples** - concrete examples of the framework in use

Contributions that are **not a good fit**:

- Adding new phases that break the 7-phase sequence without strong justification
- Making the framework more complex without a clear quality improvement
- Tool-specific hacks that undermine the cross-tool portability principle

If you're unsure, open an issue first. A brief discussion saves everyone time.

---

## Getting Started

```bash
git clone https://github.com/a7medalyapany/kavro.git
cd kavro
```

No build step required. The framework is Markdown and shell scripts.
Test your changes by installing locally:

```bash
bash scripts/install.sh --claude   # or whichever adapter you changed
```

---

## Project Structure

```
core/              ← The source of truth. Adapters derive from here.
  KAVRO.md         ← The canonical framework. Changing this changes everything.
  phases/          ← One file per phase. High-impact, high-sensitivity.

adapters/          ← Tool-specific translations. Format changes, logic doesn't.
  claude/
  codex/
  cursor/
  windsurf/

scripts/           ← Installer and build tooling.
docs/              ← Long-form documentation for contributors and maintainers.
```

**Key rule:** Never modify phase logic in an adapter without modifying `core/` first.
The adapter is a translation. The core is the contract.

---

## Contribution Types

### Improving a Phase File

Phase files live in `core/phases/`. They are high-sensitivity - many adapters
depend on them. When improving a phase:

1. Open an issue describing what is wrong or missing
2. Make your change in `core/phases/XX-name.md`
3. Verify the change doesn't conflict with what `core/KAVRO.md` says about that phase
4. Update `CHANGELOG.md` under `Upcoming`

### Adding a New Adapter

New adapters live in `adapters/[tool-name]/`. When adding one:

1. Read the target tool's documentation on how it loads system instructions
2. Translate the 7-phase logic from `core/KAVRO.md` into the tool's native format
3. Add the adapter to `scripts/install.sh` and `scripts/build.sh`
4. Add installation instructions to `INSTALLATION.md`
5. Document any tool-specific limitations honestly

### Fixing the Installer

`scripts/install.sh` needs to work on macOS and Linux across different
tool installation paths. When fixing or extending it:

- Test on a clean environment if possible
- Handle the case where the tool is not installed gracefully
- Never silently overwrite files - always back up first
- Keep the output readable - a user should understand what happened

---

## Pull Request Process

1. **Branch from `dev`**, not `main`
   ```bash
   git checkout dev
   git checkout -b fix/phase-2-decision-log-template
   ```

2. **Keep PRs focused** - one concern per PR. Don't mix phase improvements
   with installer changes.

3. **Update `CHANGELOG.md`** under `Upcoming` for any meaningful change.

4. **Write a clear PR description:**
   - What is the problem?
   - What does this PR change?
   - How was it tested?

5. **Target `dev`** - `main` only receives merges from `dev` at release time.

---

## Code of Conduct

Treat everyone with the same respect you'd want in a senior engineering review.
Direct, honest, and constructive. No condescension, no dismissiveness.

---

## Questions

Open an issue. That's what they're for.

---

*Kavro v1.0.1 - https://github.com/a7medalyapany/kavro*
