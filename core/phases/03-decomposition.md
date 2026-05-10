# Phase 3 - Task Decomposition

> *"The quality of your decomposition determines the quality of your execution."*

---

## Activation

This phase activates when the Technical Blueprint is approved.

The agent's job is to break the entire project into a structured,
dependency-aware, executable work breakdown - not to implement anything.

Good decomposition is a skill. A task that is too large creates regression risk.
A task that is too small creates coordination overhead.
The goal is **atomic** - the smallest unit of work that produces a
independently verifiable result.

---

## Decomposition Hierarchy

```
Project
└── Milestone         ← Major deliverable. Something real ships.
    └── Phase         ← Ordered group of related work.
        └── Task      ← Atomic unit. Single responsibility. Independently testable.
```

**Milestone:** A milestone is complete when a meaningful piece of the system
is working end-to-end. Not "the database layer is done." More like
"a user can register and log in."

**Phase:** A phase is a logical grouping of tasks that are worked on together.
All tasks in a phase share a common concern (e.g., "data layer" or "API endpoints").

**Task:** The atomic unit. See the Task Specification below.

---

## Task Specification

Every task must be fully specified before execution begins.
Vague tasks produce vague output.

```markdown
### Task [MILESTONE.PHASE.SEQUENCE] - [Name]

**Goal:**
[One sentence. What does this task accomplish?]

**Scope - In:**
[Exact files, modules, functions, or endpoints this task touches]

**Scope - Out:**
[What is explicitly NOT part of this task, even if tempting]

**Dependencies:**
[Task IDs that must be complete before this task starts]
[Write "None" if this task has no dependencies]

**Expected output:**
[Concrete description of what exists when this task is done]
[Not "implement X" - what can be observed or tested?]

**Implementation strategy:**
[How to approach this task. Not the code - the approach.]

**Validation steps:**
[Step-by-step verification that the task is done correctly]
1. [Specific check]
2. [Specific check]
3. [Specific check]

**Rollback plan:**
[How to undo this task if it introduces a regression]

**Complexity:** Low / Medium / High

**Estimated effort:** [Hours or story points - be honest]

**Agent role:** [Which agent type handles this - see Phase 6]
```

---

## Dependency Mapping

After writing all tasks, draw the dependency graph:

```
Task 1.1.1 ──────────────────────────► Task 1.2.1
Task 1.1.2 ──┐                         Task 1.2.2
Task 1.1.3 ──┴──► Task 1.1.4 ────────► Task 1.2.3
```

**Parallelization opportunities:** Tasks with no shared dependencies
can be executed simultaneously. Identify and document these explicitly.

**Critical path:** The longest chain of dependent tasks.
This determines the minimum execution time. Flag it.

---

## Decomposition Quality Checklist

Before finalizing the decomposition, verify every task:

- [ ] Has a single, nameable goal
- [ ] Can be completed without touching code outside its defined scope
- [ ] Has explicit validation steps (not "test it works")
- [ ] Has a rollback plan
- [ ] Has no implicit dependencies (all deps are listed)
- [ ] Could be handed to a developer who hasn't read the conversation history
- [ ] Is not "implement the whole feature"

---

## Decomposition Anti-Patterns

### The Monolith Task
```
❌ Task: Implement the user authentication system
```
This is a milestone, not a task. Split it.

```
✅ Task 1.1.1 - Create user schema and migration
✅ Task 1.1.2 - Implement password hashing utility
✅ Task 1.1.3 - Implement POST /auth/register endpoint
✅ Task 1.1.4 - Implement POST /auth/login endpoint
✅ Task 1.1.5 - Implement JWT generation and validation
✅ Task 1.1.6 - Write integration tests for auth flow
```

### The Vague Task
```
❌ Task: Add some caching
```
No scope. No output. No validation. Rewrite it.

```
✅ Task 2.1.1 - Add Redis caching for GET /users/:id
  Scope: repositories/user.repository.ts - findById method only
  Output: Response served from cache on repeat requests. Cache TTL: 5 min.
  Validation: Hit endpoint twice. Confirm second response time < 5ms.
```

### The Coupled Task
```
❌ Task: Implement the API endpoint and the database schema
```
Two responsibilities. Split it. Schema first, endpoint second.
They can be done sequentially or even in parallel by different agents.

### The Untestable Task
```
❌ Task: Refactor the service layer for better readability
```
"Better readability" is not verifiable. Define what changes and why.

```
✅ Task: Extract email sending logic from UserService into EmailService
  Validation: UserService has zero email-related imports after this task.
  All existing UserService tests still pass unchanged.
```

---

## Output Format - Full Decomposition Document

```markdown
# Execution Decomposition - [Project Name]

**Based on:** Technical Blueprint v[X]
**Created:** [Date]

---

## Milestone 1 - [Name]
**Goal:** [What ships at the end of this milestone]
**Definition of done:** [Observable end state]

### Phase 1.1 - [Name]
**Goal:** [What this phase accomplishes]

#### Task 1.1.1 - [Name]
[Full task spec]

#### Task 1.1.2 - [Name]
[Full task spec]

### Phase 1.2 - [Name]
...

---

## Milestone 2 - [Name]
...

---

## Dependency Graph
[ASCII diagram of task dependencies]

## Critical Path
[List the critical path tasks in order]

## Parallelization Opportunities
[List tasks that can run simultaneously]
```

---

## Phase Transition Rules

**Proceed to Phase 4 only when:**
- Every task is fully specified with all fields complete
- Dependency graph is drawn and reviewed
- Critical path is identified
- Parallelization opportunities are documented
- No task is a monolith, vague, or untestable

**Do not proceed if:**
- Any task has missing validation steps
- Any task has implicit (undocumented) dependencies
- Any task scope is ambiguous

---

*Phase 3 complete → proceed to `04-documentation.md`*