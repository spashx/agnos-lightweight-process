<!-- Iteration: 4/5 -->
# PLAN-REC-004: Cross-session metrics persistence (recursive iteration 4/5)

## Overview
Implements FTR-REC-004: adds the METRICS_LOG.md mechanism to END SESSION ACTION and
PROCESS FOLDER STRUCTURE in `.github/instructions/agnos-sw-eng.v2.instructions.md`, and creates the
log file with its header row.

## References
- **Requirements**: RQ-REC-006
- **ADRs**: ADR-REC-004 (DEC-REC-005)

---

## Tasks

### TASK-REC-005: Add METRICS_LOG.md persistence step and create the log file
- **Tier**: L
- **Status**: Done
- **Description**: Edit END SESSION ACTION to append a session row to
  `process/_sessionstate/METRICS_LOG.md` (creating it with its header if absent), update the
  PROCESS FOLDER STRUCTURE bullet for `_sessionstate/` to mention the new file, and create
  `METRICS_LOG.md` with its header row, per DEC-REC-005.
- **Requirement refs**: RQ-REC-006
- **ADR refs**: ADR-REC-004 (DEC-REC-005)
- **Acceptance Criteria** (Gherkin):
  - **Given** the edited instructions file and the new `METRICS_LOG.md`
  - **When** a session's END SESSION ACTION runs
  - **Then** the instruction requires appending one row with the session's date, TRI, and 4
    counters to the log, creating the header first if the file is new
  - **And** `METRICS_LOG.md` exists with its header row and traceability comment
- **Dependencies**: None
- **Assignee**: AI
- **Verification**: Re-read PROCESS FOLDER STRUCTURE (line 25) and END SESSION ACTION (lines 67-68)
  via the Read tool after editing — confirmed both the folder-structure mention and the new
  "Persist the metrics" step citing RQ-REC-006 are present. Confirmed `METRICS_LOG.md` exists with
  its header row and traceability comment. Line count re-measured with
  `(Get-Content file).Count`: **373** ≤ 800.
- **Assumptions**: Same as prior tasks in this plan — normative-text/data-log change, no executable
  function, so the unit-test obligation does not apply.
