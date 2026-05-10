# Phase 6 - Dynamic Agent Selection

> *"The right tool for the right task. Not the familiar tool for every task."*

---

## Activation

This phase activates when prompts are prepared for an execution phase.

The orchestrator decides which agent handles each task.
This decision is logged. It is never silent.
The user does not have to choose - but the orchestrator must justify its choice.

---

## Selection Logic

Work through this decision tree for every task before assigning an agent.

```
What is the primary nature of this task?
│
├── Architectural decision or system design
│   └── → Architecture Agent (most capable available)
│
├── Backend implementation (API, service, data layer, workers)
│   └── → Backend Agent
│
├── Frontend implementation (components, pages, client logic)
│   └── → Frontend Agent
│
├── Bug investigation or production issue
│   └── → Debugging Agent
│
├── Code restructuring without behavior change
│   └── → Refactoring Agent
│       └── REQUIRE: test coverage confirmed before starting
│
├── Writing tests for existing or new code
│   └── → Testing Agent
│
├── Infrastructure, pipelines, deployment
│   └── → DevOps Agent
│
├── Research, domain investigation, reference gathering
│   └── → Research Agent (Phase 1 specialist)
│
└── Post-execution review and validation
    └── → Governance Agent (runs after EVERY task)
```

**Rule:** The Governance Agent always runs after every primary agent.
It is not optional. It is not skipped when "the task seems simple."

---

## Agent Capability Matching

When multiple agent options are available (e.g. different models),
match capability to task complexity:

| Task Complexity | Agent Capability Needed |
|----------------|------------------------|
| High - architecture, irreversible decisions | Most capable available (Opus-class) |
| Medium - feature implementation, API design | Standard capable (Sonnet-class) |
| Low - boilerplate, config, formatting | Efficient (Haiku-class or equivalent) |
| Validation - governance review | Standard capable minimum |

**Do not use a low-capability agent for high-complexity tasks.**
**Do not waste a high-capability agent on low-complexity tasks.**

---

## Selection Log Format

Every agent assignment must be logged before execution begins:

```markdown
## Agent Selection - Task [ID]

**Task:** [Task name]
**Assigned agent:** [Agent role + capability tier]
**Reason:** [Why this agent was chosen for this task]
**Context injected:** [What Phase 1–3 context is included in the prompt]
**Expected output:** [What the agent should produce]
**Governance:** Governance Agent runs post-execution - ALWAYS
```

---

## Orchestration Patterns

### Pattern 1 - Planner / Executor Split

The orchestrator plans. A specialized agent executes.
The orchestrator reviews. These are always separate.

```
Orchestrator (Kavro)
    ↓ generates task + prompt
Executor Agent
    ↓ produces output
Governance Agent
    ↓ validates against blueprint
Orchestrator
    ↓ proceeds or flags
```

**Why:** Executors optimizing for task completion will scope-creep
into architecture decisions if not constrained. Separation prevents this.

---

### Pattern 2 - Critic / Reviewer Loop

After execution, a reviewer agent compares output to the blueprint.
If drift is detected, the reviewer flags it before the next task starts.

```
Executor Agent → output
Governance Agent → PASS → next task
                → FLAG → document + proceed with acknowledgment
                → BLOCK → rollback + human review required
```

This loop runs after every atomic task. Without exception.

---

### Pattern 3 - Recursive Refinement

If a task output fails validation, feed it back to the executing agent
with specific failure context. The agent retries with constraints applied.

```
Executor Agent → output → BLOCK
    ↓
Orchestrator injects:
  - What failed and why
  - What the correct output should look like
  - Additional constraints based on the failure
    ↓
Executor Agent → refined output → re-validate
```

**Maximum iterations:** 2 refinement cycles before escalating to human review.
If the agent cannot produce a passing output in 2 attempts, the task
requires human intervention - not a third AI attempt.

---

### Pattern 4 - Parallel Agent Execution

Tasks with no shared dependencies can be executed simultaneously.
Identify these from the dependency graph in Phase 3.

```
Task 1.1.1 ──────────────► merge
Task 1.1.2 ──────────────►
Task 1.1.3 ──────────────►
```

**Constraints for parallel execution:**
- Tasks must have zero overlapping file scope
- Each task must have its own Governance Agent review before merge
- Merge conflicts are resolved by the orchestrator, not the executing agents

---

### Pattern 5 - Human Approval Gates

The orchestrator MUST pause and request explicit human approval before:

| Trigger | Why |
|---------|-----|
| Database schema migration | Irreversible in production |
| Breaking API change | Affects downstream consumers |
| Production infrastructure change | High blast radius |
| Any task rated High complexity touching core modules | Risk of cascade failure |
| Any deviation from the approved Technical Blueprint | Architecture is a contract |
| Third refinement attempt on a blocked task | Agent is stuck - human judgment needed |

**Format for human approval gate:**

```
⚠️  KAVRO APPROVAL REQUIRED

Task: [Task ID] - [Name]
Reason for gate: [Specific trigger from the list above]

What will happen:
[Exact description of what the next step does]

What cannot be easily undone:
[Specific irreversible consequences]

Rollback plan if this goes wrong:
[Concrete steps]

To proceed: explicitly confirm "approved"
To abort: explicitly confirm "abort"
```

---

## What the Orchestrator Never Does

- Selects an agent without logging the reason
- Skips the Governance Agent for "simple" tasks
- Allows a third refinement attempt without human escalation
- Proceeds past a BLOCK status without human resolution
- Makes irreversible changes without an explicit approval gate
- Assigns a high-complexity task to a low-capability agent

---

## Phase Transition Rules

**Proceed to Phase 7 when:**
- Every task has an agent assignment with a logged reason
- The Governance Agent is configured to run post every task
- All human approval gates are identified in advance
- Parallel execution opportunities are mapped

---

*Phase 6 complete → proceed to `07-governance.md`*