<!-- Iteration: 1/5 -->
# PLAN-REC-001: Verification & assumption traceability (recursive iteration 1/5)

## Overview
Implements FTR-REC-001 by editing `.github/instructions/agnos-sw-eng.v2.instructions.md` itself:
adds `Verification` / `Assumptions` fields to the TASK template, strengthens the DoD self-check
rule, and records the 800-line ceiling as a standing, measurable rule.

## References
- **Requirements**: RQ-REC-001, RQ-REC-002, RQ-REC-003
- **ADRs**: ADR-REC-001 (DEC-REC-001, DEC-REC-002)

---

## Tasks

### TASK-REC-001: Add Verification/Assumptions fields and strengthen the DoD self-check rule
- **Tier**: L
- **Status**: Done
- **Description**: Edit §3 (Plan/Task File Template) to add `Verification` and `Assumptions`
  fields to the TASK template, and reword the "Self-check before declaring done" bullet to require
  `Verification` to cite current-session tool output rather than recollection.
- **Requirement refs**: RQ-REC-001, RQ-REC-002
- **ADR refs**: ADR-REC-001 (DEC-REC-001)
- **Acceptance Criteria** (Gherkin):
  - **Given** the edited instructions file
  - **When** a Tier M or L task is closed under the new rule
  - **Then** its `Verification` field cites concrete tool output per acceptance criterion
  - **And** its `Assumptions` field names any inferred detail, or reads "None"
- **Dependencies**: None
- **Assignee**: AI
- **Verification**: Re-read `agnos-sw-eng.v2.instructions.md` via the Read tool after editing —
  confirmed lines 236 (reworded self-check bullet citing RQ-REC-001/RQ-REC-002) and lines 307-308
  (new `Verification`/`Assumptions` fields in the TASK template) are present as specified
- **Assumptions**: This is a normative-text change with no executable function or method, so the
  Testing section's "every generated function or method SHALL have at least one unit test" rule
  (§4) does not apply — treated as N/A rather than skipped, since `session.unit_tests = true` for
  this session. No user instruction addressed this edge case directly.

### TASK-REC-002: Record the 800-line instructions-file ceiling as a standing rule
- **Tier**: L
- **Status**: Done
- **Description**: Add RQ-REC-003's constraint to the instructions file's MANDATORY RULES section,
  requiring any task that edits the file to report its post-edit line count as part of
  `Verification` (DEC-REC-002).
- **Requirement refs**: RQ-REC-003
- **ADR refs**: ADR-REC-001 (DEC-REC-002)
- **Acceptance Criteria** (Gherkin):
  - **Given** the edited instructions file
  - **When** the file is measured after this task's own edits
  - **Then** the reported line count is ≤ 800
- **Dependencies**: TASK-REC-001
- **Assignee**: AI
- **Verification**: Line count of `agnos-sw-eng.v2.instructions.md` measured after both tasks'
  edits. Initial check via `Measure-Object -Line` returned 282 — cross-checked with
  `(Get-Content file).Count`, which returned the correct **366** (PowerShell 5.1's
  `Measure-Object -Line` undercounts blank lines; the array `.Count` is the reliable method,
  now the one to use for this check in future iterations). 366 ≤ 800 — within budget.
- **Assumptions**: None
