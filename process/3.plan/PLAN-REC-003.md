<!-- Iteration: 3/5 -->
# PLAN-REC-003: Process friction metrics at session close (recursive iteration 3/5)

## Overview
Implements FTR-REC-003 by editing END SESSION ACTION in
`.github/instructions/agnos-sw-eng.v2.instructions.md` to add a fixed-format friction-metrics table
to the closing summary.

## References
- **Requirements**: RQ-REC-005
- **ADRs**: ADR-REC-003 (DEC-REC-004)

---

## Tasks

### TASK-REC-004: Add friction-metrics table to END SESSION ACTION
- **Tier**: L
- **Status**: Done
- **Description**: Edit END SESSION ACTION to require a "Process friction metrics" table (4 fixed
  counters) in the closing chat summary, per DEC-REC-004.
- **Requirement refs**: RQ-REC-005
- **ADR refs**: ADR-REC-003 (DEC-REC-004)
- **Acceptance Criteria** (Gherkin):
  - **Given** the edited instructions file
  - **When** a session closes
  - **Then** the closing summary instruction requires the 4-counter table, each counter explicitly
    listed even at 0
- **Dependencies**: None
- **Assignee**: AI
- **Verification**: Re-read END SESSION ACTION via the Read tool after editing — confirmed the new
  "Process friction metrics" bullet (lines 63-65) citing RQ-REC-005 and RQ-REC-001 is present.
  Line count re-measured with `(Get-Content file).Count`: **370** ≤ 800.
- **Assumptions**: Same as TASK-REC-001/TASK-REC-003 — normative-text change, no executable
  function, so the unit-test obligation does not apply.
