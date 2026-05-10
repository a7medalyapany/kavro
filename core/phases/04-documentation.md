# Phase 4 - Documentation & Knowledge Management

> *"Docs written after the fact are always incomplete. Docs written before are a contract."*

---

## Activation

This phase activates when the task decomposition is complete.

Documentation is not a cleanup activity.
It is not something done at the end of a sprint.
It is established before implementation begins and maintained throughout.

The documentation baseline created in this phase serves as:
- The contract between design and implementation
- The onboarding guide for future contributors
- The audit trail for architectural decisions
- The living spec that evolves with the system

---

## Documentation Structure

Create this structure in the project root before any implementation starts:

```
docs/
├── project-overview.md
├── architecture.md
├── execution-roadmap.md
├── research-findings.md
├── api-reference.md          ← Only if the project exposes an API
├── decisions/
│   └── YYYY-MM-DD-slug.md    ← One file per architectural decision
├── debugging-notes.md
└── future-improvements.md
```

---

## File Specifications

### `docs/project-overview.md`

The first document a new contributor reads.
Must be understandable with zero prior context.

```markdown
# [Project Name] - Overview

## Purpose
[What problem does this project solve? One paragraph.]

## Users
[Who uses this? What are their goals?]

## Success Criteria
[How do we know this is working? Specific, measurable outcomes.]

## Scope
[What is in scope. What is explicitly out of scope.]

## Stack
[Language, framework, runtime, infrastructure - with versions]

## Repository Structure
[High-level folder map with one-line descriptions]

## Getting Started
[Steps to run this locally from a clean machine]

## Key Contacts
[Who owns what. Who to ask about what.]
```

---

### `docs/architecture.md`

This is the Technical Blueprint from Phase 2, formatted as a living document.
It is updated whenever the architecture changes.
It is never allowed to fall out of sync with the implementation.

Contains:
- High-level architecture diagram
- Component responsibilities
- Module structure and boundaries
- API contracts
- Data design
- Cross-cutting concerns
- Scalability notes

**Rule:** If the implementation deviates from this document,
either the implementation is wrong or this document must be updated
via a formal amendment - not silently.

---

### `docs/execution-roadmap.md`

The task decomposition from Phase 3, formatted as a progress tracker.

```markdown
# Execution Roadmap

## Status Legend
- ⬜ Not started
- 🔄 In progress
- ✅ Complete
- 🚫 Blocked

## Milestone 1 - [Name]
### Phase 1.1 - [Name]
- ⬜ Task 1.1.1 - [Name]
- ⬜ Task 1.1.2 - [Name]

## Milestone 2 - [Name]
...
```

Updated after every task is completed.
The roadmap is the ground truth for project status.

---

### `docs/research-findings.md`

The Research Summary from Phase 1, formatted for long-term reference.

Contains:
- Business and technical goals
- Domain findings and references
- Risk register
- Assumptions made
- Resolved open questions

**Rule:** This document is read-only after Phase 2 begins.
If new research changes the direction, create a new entry
under a `## Amendment - [Date]` heading. Never overwrite.

---

### `docs/api-reference.md`

Exists only if the project exposes an API.

Documents every endpoint:
- Method and path
- Authentication requirement
- Request contract
- Response contracts (success and all error cases)
- Example request and response
- Rate limiting notes
- Deprecation status

Auto-generated API docs (Swagger, etc.) do not replace this file.
This file contains the intent and contracts. Auto-docs contain the implementation.
Both must exist.

---

### `docs/decisions/YYYY-MM-DD-slug.md`

One file per architectural decision. Created during Phase 2 and ongoing.

```markdown
# Decision: [Short Name]

**Date:** YYYY-MM-DD
**Status:** Accepted / Superseded by [link] / Deprecated

## Context
[Why this decision needed to be made]

## Decision
[What was decided]

## Alternatives Considered
### Option A - [Name]
[Description]
**Rejected because:** [Specific reason]

### Option B - [Name]
[Description]
**Rejected because:** [Specific reason]

## Reasoning
[Why the chosen approach was selected. Be specific.]

## Consequences
**Positive:** [What this enables or improves]
**Negative:** [What this costs or constrains]
**Risks:** [What could go wrong]

## Reversibility
Easy / Hard / Irreversible - [why]
```

Naming convention: `2026-05-09-chose-postgresql-over-mongodb.md`

---

### `docs/debugging-notes.md`

A running log of bugs encountered and how they were resolved.
Maintained throughout the project lifecycle.

```markdown
# Debugging Notes

## [Date] - [Short description of the bug]

**Symptom:** [What was observed]
**Root cause:** [What actually caused it]
**How it was found:** [The investigation process]
**Fix:** [What was changed]
**Prevention:** [What test or guard was added to prevent recurrence]
```

**Why this exists:** The second time you hit the same bug, you should spend
zero time diagnosing it. This document is that memory.

---

### `docs/future-improvements.md`

Known limitations, deferred decisions, and planned next steps.

```markdown
# Future Improvements

## Known Limitations
- [Limitation] - [Why it exists] - [What would fix it]

## Deferred Decisions
- [Decision] - [Why it was deferred] - [When to revisit]

## Planned Next Steps
- [Improvement] - [Why it matters] - [Rough priority]
```

This is not a shame list. It is an honest record of what was intentionally
left for later - and why. Future contributors will thank you.

---

## Documentation Standards

### Clarity
- Write for a developer who is new to this codebase
- Never reference "the obvious thing" - nothing is obvious to someone new
- Avoid acronyms without definition on first use
- Use examples wherever a concept could be misunderstood

### Currency
- Docs are updated in the same commit that changes the relevant behavior
- A PR that changes architecture without updating `docs/architecture.md` is incomplete
- A PR that adds an endpoint without updating `docs/api-reference.md` is incomplete

### Ownership
- Every doc has an implicit owner: the person who last made a significant architectural decision
- When ownership changes, update the Key Contacts in `project-overview.md`

---

## Phase Transition Rules

**Proceed to Phase 5 only when:**
- All required doc files are created (even if initially sparse)
- `docs/architecture.md` reflects the full Technical Blueprint
- `docs/execution-roadmap.md` reflects the full task decomposition
- At least one decision record exists for every major decision from Phase 2
- The documentation structure is committed to the repository

**Do not proceed if:**
- Any doc file is missing
- `docs/architecture.md` is incomplete
- Decision records are missing for major architectural choices

---

*Phase 4 complete → proceed to `05-prompts.md`*