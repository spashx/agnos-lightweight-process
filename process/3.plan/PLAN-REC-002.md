<!-- Iteration: 2/5 -->
# PLAN-REC-002: Test-first ordering (recursive iteration 2/5)

## Overview
Implements FTR-REC-002 by editing the Testing section (§4) of
`.github/instructions/agnos-sw-eng.v2.instructions.md` to require test-first authoring for Tier M/L
tasks.

## References
- **Requirements**: RQ-REC-004
- **ADRs**: ADR-REC-002 (DEC-REC-003)

---

## Tasks

### TASK-REC-003: Add test-first authoring rule to the Testing section
- **Tier**: L
- **Status**: Done
- **Description**: Edit §4 Testing to require the Gherkin-named test(s) for a Tier M/L task's
  acceptance criteria to be authored before its production code, per DEC-REC-003.
- **Requirement refs**: RQ-REC-004
- **ADR refs**: ADR-REC-002 (DEC-REC-003)
- **Acceptance Criteria** (Gherkin):
  - **Given** the edited instructions file
  - **When** a Tier M/L task begins implementation under `session.unit_tests = true`
  - **Then** the rule directs the agent to author the test before the production code
- **Dependencies**: None
- **Assignee**: AI
- **Verification**: Re-read §4 Testing via the Read tool after editing — confirmed the new
  "Test-first." bullet (line 335) citing RQ-REC-004 is present, ahead of the pre-existing Gherkin
  bullet. Line count re-measured with `(Get-Content file).Count` (the reliable method identified
  in TASK-REC-002): **367** ≤ 800.
- **Assumptions**: This is a normative-text change with no executable function; the test-first
  rule being added does not itself need a unit test (no code is produced by this task) — same
  reasoning as TASK-REC-001's Assumptions entry.
