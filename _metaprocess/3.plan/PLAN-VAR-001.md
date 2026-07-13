# PLAN-VAR-001: Session State Variables

## Overview
Implement session state variables in `AGNOS-sw-eng.v1.instructions.md`: a version-controlled
YAML file at `process/_sessionstate/session.yaml` that stores user and system variables resolved
at session start and used to conditionally control process execution.

## References
- **Requirements**: RQ-VAR-001, RQ-VAR-002, RQ-VAR-003, RQ-VAR-004, RQ-VAR-005
- **ADRs**: ADR-VAR-001 (DEC-VAR-001, DEC-VAR-002, DEC-VAR-003, DEC-VAR-004)

---

## Tasks

### TASK-VAR-001: Add _sessionstate folder to process structure
- **Tier**: S
- **Status**: Done
- **Description**: Create `process/_sessionstate/.gitkeep` to track the directory, and update
  the PROCESS FOLDER STRUCTURE section of the instruction file.
- **Requirement refs**: RQ-VAR-001
- **ADR refs**: ADR-VAR-001
- **Acceptance Criteria**:
  - Given the workspace
  - When `process/_sessionstate/` is listed
  - Then `.gitkeep` exists and the folder structure section references it
- **Dependencies**: None
- **Assignee**: AI

---

### TASK-VAR-002: Add SESSION STATE VARIABLES section to instruction file
- **Tier**: M
- **Status**: Done
- **Description**: Add a new `## SESSION STATE VARIABLES` section to the instruction file
  documenting the schema, the two variable definitions (`unit_tests`, `platform`), and their kinds
  (user vs system) per DEC-VAR-003.
- **Requirement refs**: RQ-VAR-001, RQ-VAR-002, RQ-VAR-003, RQ-VAR-005
- **ADR refs**: ADR-VAR-001
- **Acceptance Criteria**:
  - Given the instruction file
  - When an agent reads the SESSION STATE VARIABLES section
  - Then it finds the YAML schema, both variable definitions, and the session.yaml file path
- **Dependencies**: TASK-VAR-001
- **Assignee**: AI

---

### TASK-VAR-003: Update START SESSION with variable resolution steps
- **Tier**: M
- **Status**: Done
- **Description**: Insert 4 new ordered steps into START SESSION (after step 2) implementing the
  variable lifecycle per DEC-VAR-002: auto-detect platform, ask user for unit_tests, write
  session.yaml, display summary for confirmation/override.
- **Requirement refs**: RQ-VAR-002, RQ-VAR-003, RQ-VAR-004
- **ADR refs**: ADR-VAR-001
- **Acceptance Criteria**:
  - Given the updated START SESSION section
  - When an agent reads step 3
  - Then it detects the platform, asks for unit_tests, writes session.yaml, and confirms all values
    with the user before scanning requirements (old step 3, now step 7)
- **Dependencies**: TASK-VAR-002
- **Assignee**: AI

---

### TASK-VAR-004: Add unit_tests guard to Testing section
- **Tier**: S
- **Status**: Done
- **Description**: Prefix the `### Testing` section with a `WHILE session.unit_tests = false`
  guard so the agent skips all testing steps when the variable is false per DEC-VAR-004.
- **Requirement refs**: RQ-VAR-002
- **ADR refs**: ADR-VAR-001
- **Acceptance Criteria**:
  - Given session.yaml contains `unit_tests: false`
  - When an agent reads the Testing section
  - Then it skips all test generation and execution steps
- **Dependencies**: TASK-VAR-003
- **Assignee**: AI

---

### TASK-VAR-005: Add platform guard to shell command guidance
- **Tier**: S
- **Status**: Done
- **Description**: Add a platform-aware shell command rule to the Anti-Patterns section of §4
  instructing the agent to use `session.platform` to determine correct shell syntax per DEC-VAR-004.
- **Requirement refs**: RQ-VAR-003
- **ADR refs**: ADR-VAR-001
- **Acceptance Criteria**:
  - Given session.yaml contains `platform: windows`
  - When the agent needs to run a shell command
  - Then it uses PowerShell syntax (not bash-only commands like `ls`, `tail`, `grep`)
- **Dependencies**: TASK-VAR-003
- **Assignee**: AI
