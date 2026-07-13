# PLAN-GIT-001: Implement Git Workflow Automation Prompts

## Overview
Implement two VS Code Copilot prompt files for the AGNOS git workflow operations, validate they
work as expected, and update the instruction process to reference them.

## References
- **Requirements**: RQ-GIT-001, RQ-GIT-002, RQ-GIT-003, RQ-GIT-004, RQ-GIT-005
- **ADRs**: ADR-GIT-001 (DEC-GIT-001)

---

## Tasks

- **Status**: Done
- **Description**: Create `.github/prompts/AGNOS-git-start-session.prompt.md` implementing the
  feature branch creation operation with proper frontmatter, parameter handling for `<TRI>`, and
  branch-exists guard logic per DEC-GIT-001.
- **Requirement refs**: RQ-GIT-001, RQ-GIT-005
- **ADR refs**: ADR-GIT-001
- **Acceptance Criteria**:
  - Given a repository with no `feature/USR` branch
  - When `/AGNOS-git-start-session` is invoked with TRI = `USR`
  - Then `git checkout -b feature/USR` is executed and the branch is active
  - Given the branch `feature/USR` already exists
  - When `/AGNOS-git-start-session` is invoked with TRI = `USR`
  - Then the agent asks the user how to proceed before performing any git operation
- **Dependencies**: None
- **Assignee**: AI

---

- **Status**: Done
- **Description**: Create `.github/prompts/AGNOS-git-commit-task.prompt.md` implementing the
  task commit operation with parameters TASK, ADR (optional), and description, producing the
  correct commit message format per DEC-GIT-001.
- **Requirement refs**: RQ-GIT-002, RQ-GIT-005
- **ADR refs**: ADR-GIT-001
- **Acceptance Criteria**:
  - Given changed files, TASK = `TASK-USR-001`, ADR = `ADR-USR-001`, description = `add login handler`
  - When `/AGNOS-git-commit-task` is invoked
  - Then a commit is created with message `ADR-USR-001/TASK-USR-001 add login handler`
  - Given changed files, TASK = `TASK-USR-002`, no ADR, description = `add logout handler`
  - When `/AGNOS-git-commit-task` is invoked
  - Then a commit is created with message `TASK-USR-002 add logout handler`
- **Dependencies**: TASK-GIT-001
- **Assignee**: AI

---

### TASK-GIT-003: Validate both prompts in the workspace
- **Tier**: M
- **Status**: Done
- **Description**: Interactively invoke both prompts against the current workspace repository to
  verify they satisfy the acceptance criteria of RQ-GIT-001 and RQ-GIT-002. Document findings
  inline as a checklist update in this task entry.
  > Note: Prompt files are not executable code; validation is manual/interactive via VS Code
  > Copilot Chat slash commands or `Chat: Run Prompt...`.
- **Requirement refs**: RQ-GIT-003
- **ADR refs**: ADR-GIT-001
- **Acceptance Criteria**:
  - Given the prompts from TASK-GIT-001 and TASK-GIT-002 are in place
  - When each prompt is invoked in VS Code Copilot Chat with valid test parameters
  - Then the resulting git state matches the expected outcome for each scenario in RQ-GIT-001
    and RQ-GIT-002
  - And both prompts appear in the `/` slash command suggestion list (RQ-GIT-005)
- **Dependencies**: TASK-GIT-001, TASK-GIT-002
- **Assignee**: Human (interactive validation in VS Code)

---

- **Status**: Done
- **Description**: Edit `AGNOS-sw-eng.v1.instructions.md` to reference the two new prompt files
  by name at START SESSION step 7 and at the DoD commit step, so agents invoke them directly.
- **Requirement refs**: RQ-GIT-004
- **ADR refs**: ADR-GIT-001
- **Acceptance Criteria**:
  - Given the updated instruction file
  - When an agent reads START SESSION step 7
  - Then the step text explicitly references `AGNOS-git-start-session` prompt
  - Given the updated instruction file
  - When an agent reads the DoD commit step
  - Then the step text explicitly references `AGNOS-git-commit-task` prompt
- **Dependencies**: TASK-GIT-001, TASK-GIT-002
- **Assignee**: AI
