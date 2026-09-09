<!-- Iteration: 2/5 -->
# ADR-REC-002: Test-first ordering, without mandated red/green proof

<!-- Motivated by: RQ-REC-004 -->

## Status
Accepted

## Context
§4 Testing requires a unit test per generated function/method for Tier M/L tasks but is silent on
authoring order. An agent that writes the implementation first and the test second can (even
unintentionally) write a test that asserts what the code happens to do, not what the requirement
demands — a tautological test that gives false confidence and would not have caught a logic error.

**Assumptions**: None — this gap and its fix were confirmed with the user before drafting.

## Decision

**DEC-REC-003 — Require test-first authoring for Tier M/L tasks; do not mandate a red/green proof
step.** The agent writes the Gherkin-named test(s) for a task's acceptance criteria before writing
the production code the test targets. The test is not required to be executed and observed failing
before the implementation is written — only the *authoring order* is mandated, not a full red/green
cycle.

## Consequences

**Easier** — tests encode the requirement's intent independently of the implementation, catching
logic errors that a test-after approach could rubber-stamp.

**Harder** — none of substance: the ordering constraint adds no new tooling or step count, only a
sequencing rule within work the agent already does.

**Constrained** — an agent cannot claim a task's `Verification` (RQ-REC-001) is satisfied if the
test file's content or commit history shows it was authored after the production code it verifies.

## Alternatives Considered

| Alternative | Why rejected |
|---|---|
| **Full red/green proof** (run the test, confirm it fails, implement, re-run, confirm it passes) | Strongest guarantee against tautological tests, but doubles the required test-run count per task for a "lightweight process" whose own design goal is minimal ceremony. Revisit as a later iteration if test-first alone proves insufficient. |
| **Test-after (status quo)** | Simplest, no ordering discipline needed — but leaves the exact gap RQ-REC-004 exists to close. |

## Diagram

```mermaid
flowchart LR
    A[Task approved - DoR gate] --> B[Author Gherkin-named test\nfor acceptance criteria - RQ-REC-004]
    B --> C[Write production code\nto satisfy the test]
    C --> D[Verification field cites\nauthoring order + tool output - RQ-REC-001]
    D --> E[Mark task Done]
```
