# Phase 7 - Execution Governance

> *"The architecture is the contract. Implementation must honor it."*

---

## Activation

This phase activates when execution begins.
It runs continuously and in parallel with all subsequent phases.
It never deactivates until the project is complete.

Governance is not a review at the end.
It is a continuous check at the task level, the phase level, and the milestone level.
Problems caught at the task level cost minutes.
Problems caught at the milestone level cost days.
Problems caught in production cost trust.

---

## The Drift Taxonomy

Drift is any implementation that deviates from the approved Technical Blueprint.
Not all drift is equal. Classify it before responding.

### Minor Drift

Definition: A small deviation that does not affect system behavior,
interface contracts, or architectural boundaries.

Examples:
- A variable named differently than the convention
- A helper function placed in a slightly wrong module
- A comment that is inaccurate

Response:
- Flag in the task output
- Document in `docs/debugging-notes.md`
- Correct in the same PR if trivial, or create a follow-up task
- Continue execution with explicit acknowledgment

---

### Major Drift

Definition: A deviation that affects architectural decisions, module boundaries,
API contracts, data design, or cross-cutting concerns - but is reversible.

Examples:
- An endpoint added without a corresponding API contract in the blueprint
- A service importing directly from a module it should not own
- A caching strategy implemented differently than specified
- A database query bypassing the repository layer

Response:
- Pause execution on the affected task
- Surface the drift to the user with full context
- Two options offered:
  1. Amend the blueprint (update the architecture formally)
  2. Revert the implementation to match the blueprint
- Continue only after resolution is confirmed in writing

---

### Critical Drift

Definition: A deviation that affects irreversible system properties -
data migrations, public API contracts, security model, or infrastructure state.

Examples:
- A schema migration run without approval
- An authentication mechanism changed mid-implementation
- A breaking change to a public API endpoint
- Secrets committed to version control

Response:
- Full stop on all execution
- Rollback the offending task immediately
- Require human review before any execution continues
- Document the incident in `docs/debugging-notes.md`
- Amend the blueprint or revert - no middle ground

---

## Governance Checkpoints

### After Every Atomic Task

Run the Governance Agent with the task output. Check:

```
TASK GOVERNANCE CHECKLIST

Output verification:
- [ ] Output matches the task's defined expected output
- [ ] Scope honored - only defined files/modules were touched
- [ ] No new patterns introduced without blueprint amendment
- [ ] No out-of-scope changes (even "improvements")

Code quality:
- [ ] Naming follows defined conventions
- [ ] Error handling is explicit - no silent catches or empty catch blocks
- [ ] No hardcoded values (secrets, config, magic numbers)
- [ ] No dead code introduced
- [ ] No commented-out code left in place
- [ ] Public functions/methods are documented
- [ ] No TODO comments in submitted code

Testing:
- [ ] Tests written alongside implementation (not deferred)
- [ ] Error paths tested, not just happy path
- [ ] All pre-existing tests still pass

Documentation:
- [ ] If architecture changed → docs/architecture.md updated
- [ ] If API changed → docs/api-reference.md updated
- [ ] Execution roadmap updated (task marked complete)
```

**Outcome:** PASS / FLAG / BLOCK per the Governance Agent output format.

---

### After Every Execution Phase

At the end of each phase in the decomposition:

```
PHASE GOVERNANCE CHECKLIST

- [ ] All tasks in this phase are complete and validated (PASS or FLAG resolved)
- [ ] Implementation as a whole matches the Technical Blueprint for this phase
- [ ] No regressions introduced - full test suite passes
- [ ] Phase output reviewed by Governance Agent at the aggregate level
- [ ] Execution roadmap updated (phase marked complete)
- [ ] Any FLAGS from individual tasks are resolved or formally deferred
```

---

### After Every Milestone

At the end of each milestone:

```
MILESTONE GOVERNANCE CHECKLIST

System behavior:
- [ ] Full end-to-end behavior matches the original goal from Phase 1
- [ ] All user-facing flows work as defined in the success criteria
- [ ] Performance meets the defined SLAs (if applicable)
- [ ] Security model is intact

Architecture integrity:
- [ ] docs/architecture.md reflects the current implementation
- [ ] No undocumented deviations from the blueprint exist
- [ ] All decision records are current

Documentation:
- [ ] All docs are current and accurate
- [ ] docs/future-improvements.md updated with known limitations
- [ ] docs/decisions/ has records for all decisions made during this milestone

Readiness for next milestone:
- [ ] No BLOCK-level items remain open
- [ ] All FLAG items are resolved or have a documented resolution plan
- [ ] The next milestone's Phase 3 task specs are ready
```

---

## Standards Enforcement Reference

The Governance Agent enforces these standards on every output.
Any violation is at minimum a FLAG.

### Naming
- Files: match the convention defined in the blueprint (kebab-case / PascalCase / snake_case)
- Functions: descriptive verbs - `getUserById`, not `get`, not `userData`
- Variables: no single-letter names outside of loop counters
- Constants: SCREAMING_SNAKE_CASE for true constants
- No abbreviations unless universally understood in the domain (e.g. `id`, `url`)

### Error Handling
- Every external call (DB, API, filesystem) has explicit error handling
- No empty catch blocks - ever
- Errors are logged with context before being surfaced or swallowed
- User-facing error messages never expose internal stack traces
- Operational errors (expected) are distinguished from programmer errors (bugs)

### Code Hygiene
- No commented-out code in committed files
- No TODO comments - convert to tracked tasks
- No dead code (unreachable branches, unused imports, unused variables)
- No magic numbers - extract to named constants with a comment explaining the value
- Functions do one thing - if "and" appears in the description, split it

### Security
- Zero secrets in code - use environment variables or a secrets manager
- All user input is validated before use
- No direct SQL string construction - use parameterized queries
- Authentication checked before authorization
- Authorization checked before data access

### Documentation
- Every public function has a docstring
- Every exported type/interface has a description
- Every non-obvious decision in the code has a comment explaining why

---

## Governance Failure Escalation Path

```
Task output produced
        ↓
Governance Agent reviews
        ↓
    PASS ──────────────────────────────► proceed to next task
        ↓
    FLAG ──► document + acknowledge ──► proceed with resolution plan
        ↓
   BLOCK ──► pause execution
             ↓
         Orchestrator presents to user:
         - What failed
         - Why it is a BLOCK
         - Two options: fix or revert
             ↓
         Resolution confirmed
             ↓
         Re-run Governance Agent
             ↓
         PASS ──────────────────────────► proceed
         BLOCK (again) ─────────────────► human review required
                                          no further AI attempts
```

---

## Governance Mindset

The Governance Agent is not adversarial.
It is not looking for reasons to block.
It is the mechanism that keeps the system honest.

Good governance is invisible when everything is going well.
It becomes essential when things start to drift - and they always drift eventually.

The goal is not perfection on every task.
The goal is a system where problems are caught early,
documented clearly, and resolved deliberately.

**A BLOCK is not a failure. Undetected drift is.**

---

*Phase 7 - Governance runs continuously until project complete.*
*Return to `core/KAVRO.md` for the full framework reference.*