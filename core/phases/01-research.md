# Phase 1 - Deep Research & Understanding

> *"A problem understood deeply is already half-solved."*

---

## Activation

This phase activates on every new task, feature, refactor, or system design request.
It also activates in scoped form during single-phase debugging sessions.

The agent must resist every instinct to propose solutions.
This phase is about **listening, questioning, and understanding** - not answering.

---

## Mandatory Pre-Research Checklist

Before asking any questions or doing any research, the agent must confirm:

- [ ] I have read the full task description without forming a solution
- [ ] I have identified what I do not know
- [ ] I have identified what assumptions I am tempted to make
- [ ] I have not yet formed an implementation opinion

If any of the above are false, re-read the task from the beginning.

---

## Research Dimensions

Work through all four dimensions before producing any output.

### Dimension 1 - Business Context

Ask and answer:

- What is the actual business goal behind this request?
  (Not the stated task - the underlying goal)
- Who are the users or stakeholders affected?
- What does success look like when this is in production?
- What failure mode would be completely unacceptable?
- Are there time constraints, budget constraints, or political constraints?
- What trade-off is the business willing to make: speed vs. quality?

**Red flag:** If you cannot answer the business goal in one clear sentence,
you do not understand the task well enough to proceed.

---

### Dimension 2 - Technical Context

Investigate:

- What is the current state of the system or codebase?
- What language, framework, runtime, and infrastructure are in use?
- What are the existing patterns and conventions you must respect?
- What external APIs, services, or dependencies are involved?
- What technical debt already lives in the code this task touches?
- What has been tried before that did not work?
- What constraints are non-negotiable (compliance, performance SLAs, etc.)?

**Action:** If a codebase is available, study the relevant modules.
Do not skim. Read the actual code.

---

### Dimension 3 - Domain Research

Research the problem space:

- What established architectural patterns address this class of problem?
- What do authoritative references (docs, RFCs, papers) say?
- What have engineers gotten wrong historically with this type of system?
- What open-source implementations exist? What are their known limitations?
- What post-mortems are relevant to this domain?

**Standard:** At least one external reference must be identified
for any non-trivial architectural decision in Phase 2.

---

### Dimension 4 - Risk Analysis

Think adversarially:

- What is the worst thing that could happen if this is implemented naively?
- Where are the scalability failure points?
- What security surface does this task introduce or expand?
- What happens when the system is under load?
- What happens when a dependency is unavailable?
- What happens when a developer who doesn't know this code maintains it in a year?
- What is the blast radius if this goes wrong in production?

---

## Required Output - Research Summary

The Research Summary is the formal output of Phase 1.
It must be written as a document, not as a chat response.

```markdown
# Research Summary - [Task Name]

**Date:** [Date]
**Status:** Complete / Pending human input on open questions

---

## Business Goal
[One clear paragraph describing the actual business objective]

## Technical Goal
[One clear paragraph describing what the system must do technically]

## Context
**Stack:** [Languages, frameworks, runtime, infra]
**Affected modules:** [What code this touches]
**Existing patterns:** [Conventions already in place that must be respected]
**Technical debt:** [Relevant existing problems in the affected area]

## Domain Findings
**Established patterns:** [What the industry does for this class of problem]
**References:** [Links, RFCs, docs consulted]
**Prior art:** [Existing implementations studied]
**Known failure modes:** [What others have gotten wrong]

## Risk Register
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk description] | High / Med / Low | High / Med / Low | [How to address it] |

## Assumptions Made
[List every assumption. Nothing should be implicit.]

## Open Questions
[Anything unresolved that requires human input before Phase 2 can begin]
- [ ] Question 1
- [ ] Question 2
```

---

## Phase Transition Rules

**Proceed to Phase 2 only when:**
- All four research dimensions are complete
- Every risk is documented in the Risk Register
- All Open Questions are resolved or explicitly deferred with reasoning
- The Research Summary document exists and is complete

**Do not proceed if:**
- Any Open Question is unresolved and blocks architecture decisions
- The business goal cannot be stated clearly
- The technical context is incomplete

---

## Common Mistakes to Avoid

| Mistake | Why It Fails |
|---------|-------------|
| Skipping to architecture before finishing research | You'll architect the wrong thing |
| Treating the stated task as the real goal | The real goal is often different |
| Skipping risk analysis because "it seems simple" | Simple tasks have hidden complexity |
| Assuming the existing codebase is well-structured | It almost never is |
| Skipping domain research because "I know this" | You know your version, not the established version |

---

*Phase 1 complete → proceed to `02-architecture.md`*