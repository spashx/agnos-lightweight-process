# FTR-PRT-002: Cross-Platform Skill Scripts

## Overview
Make the AGNOS git-workflow skill's ID-validation run on **Windows and Linux/macOS**. Today the
skill ships only `validate-ids.ps1` and invokes it via `pwsh` — which is not installed on stock
Windows (only `powershell` 5.1) nor on stock Linux. It also references the script folder with the
wrong casing (`AGNOS-git-workflow` vs the on-disk `agnos-git-workflow`), which breaks on
case-sensitive filesystems. This feature adds a bash equivalent, selects the correct script from
`session.platform`, and fixes the invocation and casing defects.

## Stakeholders
- **Owner**: AGNOS Process Team
- **Consumers**: AI agents running the git-workflow skill on any supported OS

---

## Functional Requirements

### RQ-PRT-005: Bash Validation Script
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The AGNOS git-workflow skill SHALL provide a `validate-ids.sh` bash script that is
  functionally equivalent to `validate-ids.ps1`: it validates `TRI`, `TASK`, and `ADR` values
  against the same patterns and exits `0` on success or `1` with a human-readable stderr message on
  failure.
- **Rationale**: bash is the default shell on Linux/macOS; a bash script removes the PowerShell
  dependency on those platforms while preserving the deterministic validation ADR-GIT-002 mandates.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given `platform` is `linux` or `macos`
  - When the skill validates `TRI=USR`
  - Then `validate-ids.sh -Type TRI -Value USR` exits `0`
  - Given an invalid value `TASK=task-usr-1`
  - When `validate-ids.sh -Type TASK -Value task-usr-1` runs
  - Then it exits `1` and writes an error naming the expected format to stderr
- **Dependencies**: None

---

### RQ-PRT-006: Platform-Aware Script Selection
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN the skill validates an artifact ID, it SHALL select the validator matching
  `session.platform`: the PowerShell script on `windows`, the bash script on `linux` or `macos`.
- **Rationale**: A single skill body must run correctly regardless of OS by dispatching to the
  right script based on the already-detected `platform` session variable.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given `session.platform` is `windows`
  - When the skill validates an ID
  - Then it runs `validate-ids.ps1`
  - Given `session.platform` is `linux` or `macos`
  - When the skill validates an ID
  - Then it runs `validate-ids.sh`
- **Dependencies**: RQ-PRT-005

---

### RQ-PRT-007: Portable Invocation and Path Casing
- **Category**: Functional
- **EARS Type**: Unwanted-behavior
- **Statement**: IF the skill invokes the PowerShell validator on `windows`, THEN it SHALL use
  `powershell` (Windows PowerShell 5.1, always present) rather than `pwsh`, and all script paths in
  the skill SHALL use the exact on-disk casing (`agnos-git-workflow`) so invocation succeeds on
  case-sensitive filesystems.
- **Rationale**: `pwsh` is not installed on stock Windows, and the uppercase path
  `AGNOS-git-workflow` fails on Linux; both defects make the current skill non-functional as written.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given a stock Windows host with only Windows PowerShell 5.1
  - When the skill validates an ID
  - Then the invocation uses `powershell -NoProfile -File .github/skills/agnos-git-workflow/scripts/validate-ids.ps1` and succeeds
  - Given a case-sensitive filesystem
  - When any skill-referenced script path is resolved
  - Then the path casing matches the on-disk folder `agnos-git-workflow`
- **Dependencies**: RQ-PRT-005

---

## Non-Functional Requirements

### RQ-PRT-008: Cross-Platform Validation Equivalence
- **Category**: Non-Functional
- **NFR Type**: Portability
- **EARS Type**: Ubiquitous
- **Statement**: The PowerShell and bash validators SHALL enforce identical ID patterns so that any
  given input yields the same accept/reject result on every supported platform.
- **Metric**: For the same `-Type`/`-Value` input, `validate-ids.ps1` and `validate-ids.sh` return
  the same exit code for 100% of a shared valid/invalid test-vector set.
- **Measurement Method**: Run both scripts over the same vectors (valid: `USR`, `TASK-USR-001`,
  `ADR-USR-001`; invalid: lowercase, wrong length, missing sequence) and compare exit codes.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given the shared test-vector set
  - When each vector is run through both validators on their respective platforms
  - Then every vector produces the same exit code from both scripts
- **Dependencies**: RQ-PRT-005
