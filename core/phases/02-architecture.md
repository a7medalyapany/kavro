# Phase 2 - System Design & Architecture

> *"The blueprint is the contract. Everything built must honor it."*

---

## Activation

This phase activates when the Phase 1 Research Summary is complete and approved.

The agent's job in this phase is to design - not implement.
No code. No pseudocode. No "let me just show you a quick example."
Architecture diagrams, contracts, decisions, and structure only.

---

## Blueprint Sections

Every Technical Blueprint must cover all applicable sections below.
If a section is not applicable, write "N/A - [reason]" explicitly.
Leaving a section blank is not acceptable.

---

### Section 1 - High-Level Architecture

Describe the system at the component level:

- What are the major components or services?
- What is each component responsible for?
- How do components communicate (HTTP, events, queues, direct calls)?
- Where does data enter the system? Where does it leave?
- What are the external integration points?

**Format:** ASCII diagram + written description.

```
Example:

[Client] → [API Gateway] → [Auth Service]
                        → [Core Service] → [PostgreSQL]
                                        → [Redis Cache]
                        → [Worker Service] → [Job Queue]
```

---

### Section 2 - Folder & Module Structure

Define the structure before a single file is created:

- What is the top-level folder organization?
- What is each folder responsible for?
- What are the module boundaries? (What can import what?)
- What naming conventions apply?

**Rule:** No "utils" folders. Every folder has a single, nameable responsibility.
If you cannot name what a folder does, split it differently.

```
Example:

src/
├── api/          ← HTTP layer only. No business logic.
├── services/     ← Business logic only. No HTTP awareness.
├── repositories/ ← Data access only. No business logic.
├── models/       ← Data shape definitions only.
├── middleware/   ← Cross-cutting HTTP concerns.
├── config/       ← Environment and configuration loading.
└── lib/          ← Shared pure utilities with no side effects.
```

---

### Section 3 - API Layer Design

For every API surface exposed:

- Endpoint path and HTTP method
- Request contract (headers, params, body shape)
- Response contract (success shape, error shape)
- Authentication requirement
- Authorization model (who can call this?)
- Rate limiting requirements
- Versioning strategy

**Standard:** Every endpoint must have explicit error responses defined.
"It returns an error" is not a contract.

```
Example:

POST /api/v1/users
  Auth: Bearer token required
  Body: { email: string, name: string, role: "admin" | "member" }
  Success: 201 { id: uuid, email: string, createdAt: ISO8601 }
  Errors:
    400 - invalid input (with field-level validation errors)
    409 - email already exists
    500 - internal error (opaque, logged internally)
```

---

### Section 4 - Data Design

For every data store involved:

- Schema definition (tables, collections, or documents)
- Relationship definitions
- Index strategy (what is indexed and why)
- Migration approach (how schema changes are managed)
- Data retention and cleanup strategy

**Rule:** Every index must have a justification.
Indexes are not free - they cost on writes.

---

### Section 5 - Cross-Cutting Concerns

#### Error Handling Philosophy
- How are errors classified? (operational vs programmer errors)
- What is the error propagation strategy?
- What is logged? What is exposed to the client?
- How are unexpected errors handled at the boundary?

#### Caching Strategy
- What is cached? (be specific - not "responses")
- Where does the cache live? (in-memory, Redis, CDN)
- What is the TTL for each cached item?
- How is the cache invalidated? (time-based, event-based, explicit)
- What happens when the cache is unavailable?

#### Logging & Observability
- What events are logged?
- What log levels are used and when?
- What structured fields are included in every log?
- What metrics are emitted?
- What traces are captured?

#### Security Model
- How is identity established? (JWT, session, API key)
- How is authorization enforced? (RBAC, ABAC, ownership checks)
- How is input validated and sanitized?
- How are secrets managed? (never hardcoded - state the mechanism)
- What OWASP concerns are relevant to this system?

---

### Section 6 - Scalability & Resilience

- What is the expected load? (requests/sec, data volume, concurrency)
- What is the scaling strategy? (horizontal, vertical, serverless)
- What are the bottlenecks at 10x current load?
- What fails first under load? What is the plan?
- How does the system behave when a dependency is down?
- What circuit breakers or fallbacks exist?
- What is the recovery time objective (RTO)?

---

### Section 7 - Testing Strategy

Define scope before implementation begins:

| Layer | Scope | Tooling | Coverage Target |
|-------|-------|---------|-----------------|
| Unit | Pure functions, services in isolation | [tool] | [%] |
| Integration | Service + real DB/cache | [tool] | [%] |
| E2E | Full request lifecycle | [tool] | [%] |
| Contract | API contract validation | [tool] | - |

**Explicitly out of scope:** [List what you are intentionally not testing and why]

---

### Section 8 - Deployment Strategy

- What environments exist? (local, dev, staging, prod)
- How is the app built and packaged?
- How is it deployed? (CI/CD pipeline, manual, GitOps)
- What is the rollback mechanism?
- How are environment variables managed across environments?
- What health checks exist?
- What is the zero-downtime deployment approach?

---

## Decision Log

Every non-trivial architectural decision must have a decision record.

```markdown
### Decision: [Short name]

**Context:**
[Why this decision needed to be made]

**Chosen approach:**
[What was decided]

**Alternatives considered:**
- [Option A] - rejected because [specific reason]
- [Option B] - rejected because [specific reason]

**Why this approach:**
[The reasoning. Be specific. "It's simpler" is not enough.]

**Long-term implications:**
[What this means in 12–18 months for the team and system]

**What could go wrong:**
[Known risks with this choice and how they are mitigated]

**Reversibility:**
[Easy / Hard / Irreversible - and why]
```

**Decisions that always require a log:**
- Database choice or schema design
- API design patterns
- Authentication mechanism
- Caching strategy
- Any "we'll do this later" deferral
- Any choice that deviates from established team conventions

---

## Blueprint Review Checklist

Before proceeding to Phase 3, verify:

- [ ] All applicable sections are complete
- [ ] Every major decision has a decision log
- [ ] No section says "TBD" without an explicit resolution plan
- [ ] The blueprint can be handed to a developer with zero context and be understood
- [ ] The blueprint has been reviewed and approved

---

## Phase Transition Rules

**Proceed to Phase 3 only when:**
- All blueprint sections are complete or explicitly N/A
- All decision logs are written
- Blueprint is approved by the relevant stakeholder or senior engineer

**Do not proceed if:**
- Any section is incomplete without justification
- A decision was made without considering at least two alternatives
- The testing strategy is undefined

---

## Common Mistakes to Avoid

| Mistake | Why It Fails |
|---------|-------------|
| Designing only the happy path | Production lives in the error paths |
| No decision logs | Future developers don't know why and make it worse |
| "We'll figure out auth later" | Auth retrofitted onto a system is always broken |
| Over-engineering for hypothetical scale | Build for real load, design for 10x |
| Under-specifying API contracts | Implicit contracts become integration bugs |
| Skipping the testing strategy | "We'll add tests later" means no tests |

---

*Phase 2 complete → proceed to `03-decomposition.md`*