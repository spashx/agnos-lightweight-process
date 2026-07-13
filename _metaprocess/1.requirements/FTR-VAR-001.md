
# FTR-VAR-001: Session State Variables

## Overview
The AGNOS process shall support **session state variables** — named key/value pairs persisted in
`process/_sessionstate/` and loaded at session start — that conditionally control process
execution. Two variable kinds are defined: **user variables** (values set by asking the user via
`askQuestion`) and **system variables** (values auto-detected by the agent). All variable values
are surfaced to the user for confirmation before the session proceeds, and the user may override
any value at that point.

## Stakeholders
- **Owner**: AGNOS Process Team
- **Consumers**: AI agents following the AGNOS process

---

## Functional Requirements

### RQ-VAR-001: Session State Storage
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The AGNOS process SHALL persist session state variables as a YAML file at
  `process/_sessionstate/session.yaml`, tracked under version control.
- **Rationale**: Version-controlled storage enables team members to review past session
  configurations and ensures reproducibility across sessions.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given a session has started and variables have been resolved
  - When the session state is written
  - Then `process/_sessionstate/session.yaml` exists and contains all resolved variable values as
    valid YAML with keys matching variable names
- **Dependencies**: None

---

### RQ-VAR-002: User Variable — Unit Tests
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN a new session starts, the AGNOS process SHALL ask the user via `askQuestion`
  whether unit tests should be generated (`unit_tests: true | false`), and SHALL skip all steps
  described in the `### Testing` section of the instruction process WHILE `unit_tests` is `false`.
- **Rationale**: Some contexts (spike, prototype, data exploration) do not require unit tests;
  forcing them adds friction without value.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given the user answers "no" to the unit tests question at session start
  - When a Tier M or L task is executed
  - Then the agent skips all test generation and execution steps
  - And `process/_sessionstate/session.yaml` contains `unit_tests: false`
  - Given the user answers "yes" to the unit tests question at session start
  - When a Tier M or L task is executed
  - Then the agent applies all testing steps as defined in the instruction process
- **Dependencies**: RQ-VAR-001

---

### RQ-VAR-003: System Variable — Execution Platform
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN a new session starts, the AGNOS process SHALL auto-detect the OS platform
  (`platform: windows | macos | linux`) and store it as a system variable; WHEN the agent
  generates a shell command, it SHALL use platform-specific syntax consistent with the stored
  `platform` value.
- **Rationale**: Platform-specific command syntax errors (e.g., `ls`, `tail` on Windows) break
  deterministic execution; detecting once and storing eliminates repeated guessing.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given the agent runs on Windows
  - When it detects the platform at session start
  - Then `process/_sessionstate/session.yaml` contains `platform: windows`
  - And all subsequent shell commands use PowerShell / `cmd` syntax, never bash-only commands
  - Given the agent runs on macOS or Linux
  - When it detects the platform at session start
  - Then `process/_sessionstate/session.yaml` contains `platform: macos` or `platform: linux`
  - And all subsequent shell commands use bash/zsh syntax
- **Dependencies**: RQ-VAR-001

---

### RQ-VAR-004: Variable Confirmation and Override
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN session variables have been resolved (user-asked and system-detected), the
  AGNOS process SHALL display all variable values to the user and allow the user to override any
  value before the session proceeds.
- **Rationale**: Gives the user a single, visible point of control over session behavior before
  any work begins.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given resolved variables `unit_tests: true` and `platform: windows`
  - When the confirmation step is displayed
  - Then the agent shows a summary table of all variable names and their resolved values
  - And waits for the user to confirm or override before proceeding to step 3 of START SESSION
- **Dependencies**: RQ-VAR-002, RQ-VAR-003

---

## Non-Functional Requirements

### RQ-VAR-005: Session State Schema Stability
- **Category**: Non-Functional
- **NFR Type**: Maintainability
- **EARS Type**: Ubiquitous
- **Statement**: The session state YAML schema SHALL be documented in the instruction process so
  that new variables can be added without breaking existing sessions.
- **Metric**: Any new variable added follows the documented schema with no changes to existing keys.
- **Measurement Method**: Code review of instruction process file after any variable addition.
- **Priority**: Should
- **Acceptance Criteria**:
  - Given the session state schema is documented in the instruction process
  - When a new variable is added to `session.yaml`
  - Then existing variable keys are unchanged and the new key conforms to the schema
- **Dependencies**: RQ-VAR-001


