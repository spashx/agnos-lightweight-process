# PLAN-PRT-001: Portability — Claude Code Compatibility & Cross-Platform Skill Scripts

## Overview
Make the AGNOS process run under Claude Code as well as GitHub Copilot (single source of truth), and
make the git-workflow skill's ID validation work on Windows and Linux/macOS. Also fix the related
pre-existing anomalies (session file extension, missing session-state folder, `pwsh`/casing defects).

## References
- **Requirements**: RQ-PRT-001, RQ-PRT-002, RQ-PRT-003, RQ-PRT-004, RQ-PRT-005, RQ-PRT-006, RQ-PRT-007, RQ-PRT-008 (plus RQ-VAR-001 for the anomaly fix)
- **ADRs**: ADR-PRT-001 (DEC-PRT-001..003), ADR-PRT-002 (DEC-PRT-004..006)

This plan implements the tasks in the format specified below.
---

## Tasks

### TASK-PRT-001: Create root CLAUDE.md bridge
- **Tier**: M
- **Status**: Done
- **Description**: Add `CLAUDE.md` at the repository root that `@import`s
  `.github/instructions/agnos-sw-eng.v1.instructions.md` and adds a short tool-mapping note (question
  tool, skill location). No process prose is copied.
- **Requirement refs**: RQ-PRT-001, RQ-PRT-004
- **ADR refs**: ADR-PRT-001 (DEC-PRT-001)
- **Acceptance Criteria**:
  - Given a Claude Code session in the workspace
  - When it starts
  - Then `CLAUDE.md` imports the canonical instruction file and copies no process paragraphs
- **Dependencies**: None
- **Assignee**: AI

---

### TASK-PRT-002: Create Claude Code skill (thin pointer)
- **Tier**: M
- **Status**: Done
- **Description**: Create `.claude/skills/agnos-git-workflow/SKILL.md` with a valid lowercase
  `name: agnos-git-workflow`, a description covering both sub-commands, tool-neutral wording, and a
  body pointing the agent to the canonical procedure in `.github/skills/agnos-git-workflow/SKILL.md`.
- **Requirement refs**: RQ-PRT-002
- **ADR refs**: ADR-PRT-001 (DEC-PRT-002)
- **Acceptance Criteria**:
  - Given a Claude Code session
  - When skills are listed
  - Then `agnos-git-workflow` is present, its name matches `^[a-z0-9]+(-[a-z0-9]+)*$`, and its body
    defers to the canonical `.github` procedure
- **Dependencies**: None
- **Assignee**: AI

---

### TASK-PRT-003: Add bash validator validate-ids.sh
- **Tier**: M
- **Status**: Done
- **Description**: Create `.github/skills/agnos-git-workflow/scripts/validate-ids.sh`, a bash
  equivalent of `validate-ids.ps1`: same `-Type`/`-Value` flags, same TRI/TASK/ADR regexes, exit `0`
  ok / `1` + stderr on failure.
- **Requirement refs**: RQ-PRT-005, RQ-PRT-008
- **ADR refs**: ADR-PRT-002 (DEC-PRT-004)
- **Acceptance Criteria**:
  - Given `validate-ids.sh -Type TRI -Value USR`
  - When it runs under bash
  - Then it exits `0`
  - Given `validate-ids.sh -Type TASK -Value task-usr-1`
  - When it runs
  - Then it exits `1` and writes the expected-format error to stderr
- **Dependencies**: None
- **Assignee**: AI

---

### TASK-PRT-004: Make canonical SKILL.md platform-aware and fix defects
- **Tier**: M
- **Status**: Done
- **Description**: Update `.github/skills/agnos-git-workflow/SKILL.md`: set `name: agnos-git-workflow`;
  dispatch validation by `session.platform` (`powershell … .ps1` on windows, `bash … .sh` on
  linux/macos); replace `pwsh` with `powershell`; correct all script paths to the on-disk casing
  `agnos-git-workflow`.
- **Requirement refs**: RQ-PRT-002, RQ-PRT-006, RQ-PRT-007
- **ADR refs**: ADR-PRT-002 (DEC-PRT-005, DEC-PRT-006), ADR-PRT-001 (DEC-PRT-002)
- **Acceptance Criteria**:
  - Given `session.platform = windows`
  - When the skill validates an ID
  - Then it invokes `powershell -NoProfile -File .github/skills/agnos-git-workflow/scripts/validate-ids.ps1 …`
  - Given `session.platform = linux`
  - When the skill validates an ID
  - Then it invokes `bash .github/skills/agnos-git-workflow/scripts/validate-ids.sh …`
- **Dependencies**: TASK-PRT-003
- **Assignee**: AI

---

### TASK-PRT-005: Tool-neutral references in the canonical instruction file
- **Tier**: M
- **Status**: Done
- **Description**: Edit `.github/instructions/agnos-sw-eng.v1.instructions.md` so every "ask the user"
  step names both `askQuestion` (Copilot) and `AskUserQuestion` (Claude Code), and skill references
  use the lowercase name `agnos-git-workflow`.
- **Requirement refs**: RQ-PRT-003, RQ-PRT-002
- **ADR refs**: ADR-PRT-001 (DEC-PRT-003)
- **Acceptance Criteria**:
  - Given the instruction file
  - When an agent reads START SESSION 3b, "Ask when blocking", and the git steps
  - Then the question tool is named for both tools and the skill is referenced as `agnos-git-workflow`
- **Dependencies**: None
- **Assignee**: AI

---

### TASK-PRT-006: Fix session-file anomalies (§4)
- **Tier**: M
- **Status**: Done
- **Description**: Correct `session.json` → `session.yaml` throughout `FTR-VAR-001.md` and
  `ADR-VAR-001.md` (statement + acceptance criteria + schema), so the VAR artifacts match the
  instruction file, README, and the now-created `process/_sessionstate/session.yaml`.
- **Requirement refs**: RQ-VAR-001
- **ADR refs**: ADR-VAR-001
- **Acceptance Criteria**:
  - Given `FTR-VAR-001.md` and `ADR-VAR-001.md`
  - When searched for `session.json`
  - Then no occurrence remains; all references read `session.yaml`
- **Dependencies**: None
- **Assignee**: AI

---

### TASK-PRT-007: Update README for dual-tool, cross-platform support
- **Tier**: M
- **Status**: Done
- **Description**: Update `README.md` to document Claude Code support (CLAUDE.md bridge, `.claude/skills`),
  Windows + Linux/macOS validation (dual scripts, platform dispatch), the corrected `powershell`
  invocation, and the lowercase skill name.
- **Requirement refs**: RQ-PRT-001, RQ-PRT-002, RQ-PRT-005, RQ-PRT-006
- **ADR refs**: ADR-PRT-001, ADR-PRT-002
- **Acceptance Criteria**:
  - Given the updated README
  - When a reader looks for tool/OS support
  - Then it documents Claude Code + Copilot and Windows + Linux/macOS with correct invocations
- **Dependencies**: TASK-PRT-001, TASK-PRT-002, TASK-PRT-004
- **Assignee**: AI
