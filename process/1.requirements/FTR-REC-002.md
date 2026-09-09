<!-- Iteration: 2/5 -->
# FTR-REC-002: Test-first ordering for Tier M/L tasks

## Overview
Requires the Gherkin-defined unit test(s) for a Tier M/L task's acceptance criteria to be written
before the corresponding production code, closing a gap where test-after authoring lets an agent
write a test that merely describes what the code does rather than what it must do.

Second of 5 planned recursive self-improvement iterations on
`.github/instructions/agnos-sw-eng.v2.instructions.md` (see `process/2.architecture/ADR-REC-002.md`).

## Stakeholders
- **Owner**: AGNOS process session owner (this repository)
- **Consumers**: Any AI agent executing the AGNOS process's Testing section (§4) while
  `session.unit_tests = true`

---

## Functional Requirements

### RQ-REC-004: Test-first authoring order for Tier M/L tasks
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN a Tier M or L task begins implementation and `session.unit_tests = true`,
  the agent SHALL author the task's Gherkin-named unit test(s) for its acceptance criteria before
  writing the corresponding production code.
- **Rationale**: Test-after authoring risks a test that mirrors the implementation's actual
  behavior rather than the required behavior — a tautology that would pass regardless of a
  logic error. Writing the test first fixes the expected behavior independently of the
  implementation.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** a Tier M or L task with Gherkin acceptance criteria and `session.unit_tests = true`
  - **When** the agent begins implementing the task
  - **Then** the test file for the task's acceptance criteria exists before the production code
    file is created or edited
  - **And** the task's `Verification` field (RQ-REC-001) cites the order in which they were
    authored
- **Dependencies**: RQ-REC-001

**Assumptions**: No red/green proof (running the test to observe it fail, then pass) is required —
see ADR-REC-002 / DEC-REC-003 for the rationale. Not stated explicitly by the user; inferred to keep
the addition proportionate to a "lightweight process."
