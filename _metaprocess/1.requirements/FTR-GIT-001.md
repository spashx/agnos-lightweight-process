# FTR-GIT-001: Git Workflow Automation Prompts

## Overview
Provide reusable VS Code Copilot prompt files for the two GIT operations mandated by the AGNOS
process: creating a feature branch at session start, and committing task changes when a task is
done. The instruction process file shall reference these prompts so agents invoke them directly.

## Stakeholders
- **Owner**: AGNOS Process Team
- **Consumers**: AI agents following the AGNOS process, human developers in VS Code Copilot Chat

---

## Functional Requirements

### RQ-GIT-001: Feature Branch Creation Prompt
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN a new session starts, the AGNOS process SHALL invoke a reusable prompt that
  creates a GIT branch named `feature/<TRI>` where `<TRI>` is provided by the user, and checks it
  out; IF the branch already exists, THEN the prompt SHALL ask the user how to proceed.
- **Rationale**: Automates START SESSION step 7 to ensure branch creation is consistent and
  traceable across all sessions.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given a repository with no existing `feature/USR` branch and the user provides TRI = `USR`
  - When the feature branch prompt is invoked
  - Then a new GIT branch `feature/USR` is created and checked out
  - Given the branch `feature/USR` already exists
  - When the feature branch prompt is invoked with TRI = `USR`
  - Then the user is asked how to proceed before any git operation is performed
- **Dependencies**: None

---

### RQ-GIT-002: Task Commit Prompt
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN a task is marked Done, the AGNOS process SHALL invoke a reusable prompt that
  stages all changes and commits them to the current feature branch with the message
  `<ADR>/<TASK> <description>` when an ADR is related, or `<TASK> <description>` when no ADR is
  related.
- **Rationale**: Automates the DoD commit step to ensure commit messages are consistently formatted
  and traceable to task and ADR identifiers.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given changed files in the working tree, TASK = `TASK-USR-001`, ADR = `ADR-USR-001`, and
    description = `add login handler`
  - When the task commit prompt is invoked
  - Then all changes are staged and committed with the message `ADR-USR-001/TASK-USR-001 add login handler`
  - Given changed files, TASK = `TASK-USR-002`, no ADR, description = `add logout handler`
  - When the task commit prompt is invoked
  - Then all changes are staged and committed with the message `TASK-USR-002 add logout handler`
- **Dependencies**: RQ-GIT-001

---

### RQ-GIT-003: Prompt Validation
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The AGNOS process SHALL validate that both git prompts satisfy their acceptance
  criteria in the current workspace repository.
- **Rationale**: Ensures the prompts behave as expected before being relied upon in production
  sessions.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given a clean working tree
  - When each prompt is invoked with the parameters from its acceptance criteria
  - Then the resulting GIT state matches the expected outcome described in RQ-GIT-001 and RQ-GIT-002
- **Dependencies**: RQ-GIT-001, RQ-GIT-002

---

### RQ-GIT-004: Instruction Process Update
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The `AGNOS-sw-eng.v1.instructions.md` instruction file SHALL reference the git
  workflow prompts so agents invoke them at the appropriate lifecycle steps.
- **Rationale**: Ensures agents use the standardised prompts rather than ad-hoc git commands.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given the updated instruction file
  - When an agent reads START SESSION step 7
  - Then the step explicitly directs the agent to invoke the `AGNOS-git-start-session` prompt
  - Given the updated instruction file
  - When an agent reads the DoD commit step
  - Then the step explicitly directs the agent to invoke the `AGNOS-git-commit-task` prompt
- **Dependencies**: RQ-GIT-001, RQ-GIT-002

---

## Non-Functional Requirements

### RQ-GIT-005: Prompt Discoverability
- **Category**: Non-Functional
- **NFR Type**: Usability
- **EARS Type**: Ubiquitous
- **Statement**: The AGNOS git workflow prompts SHALL be discoverable via the VS Code `/` slash
  command in Copilot Chat.
- **Metric**: Both prompts appear in the slash command suggestion list when `/` is typed.
- **Measurement Method**: Manual verification in VS Code Copilot Chat after prompt files are placed
  in `.github/prompts/`.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given VS Code with Copilot Chat open
  - When the user types `/` in the chat input
  - Then both `AGNOS-git-start-session` and `AGNOS-git-commit-task` prompts appear in the suggestions
- **Dependencies**: RQ-GIT-001, RQ-GIT-002
