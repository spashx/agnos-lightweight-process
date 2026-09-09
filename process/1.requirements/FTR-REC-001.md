<!-- Iteration: 1/5 -->
# FTR-REC-001: Verification & assumption traceability for the AGNOS process itself

## Overview
Strengthens the AGNOS process's own Definition of Done and "infer and proceed" rule so that an AI
agent (a) re-verifies each acceptance criterion against real tool output instead of its own recall
before declaring a task Done, and (b) records every silent inference it makes as a traceable
artifact entry. Also formalizes the 800-line ceiling on the normative instructions file as a
standing, measurable requirement, since this and the following recursive-improvement iterations
edit that file directly.

This is the first of 5 planned recursive self-improvement iterations on
`.github/instructions/agnos-sw-eng.v2.instructions.md` (see `process/2.architecture/ADR-REC-001.md`).

## Stakeholders
- **Owner**: spambox098@free.fr (process owner / session initiator)
- **Consumers**: Any AI agent (Claude Code, GitHub Copilot) executing the AGNOS process in this
  repository, in this and all future sessions

---

## Functional Requirements

### RQ-REC-001: Independent verification before Definition-of-Done sign-off
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN a Tier M or L task's Definition of Done is evaluated, the agent SHALL
  re-verify each acceptance criterion against real tool output produced in the current session
  (a re-run test, a re-read file, a re-run command) rather than against the agent's own unverified
  recollection of having done so.
- **Rationale**: The dominant failure mode of an agentic coding assistant is confident
  self-reporting that does not match reality; a mandatory re-check step catches this before the
  task is marked Done instead of after.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** a Tier M or L task with Gherkin acceptance criteria
  - **When** the agent is about to mark the task Done
  - **Then** the task's closure notes cite the concrete tool output evidencing each criterion
  - **And** no criterion is marked satisfied on the basis of memory alone
- **Dependencies**: None

### RQ-REC-002: Traceable logging of silent inferences
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN the agent applies the "infer and proceed" rule to a detail the user did not
  explicitly specify, the agent SHALL record that inference as an explicit "Assumptions" entry in
  the artifact (RQ, ADR, PLAN, or TASK) it produces.
- **Rationale**: "Infer and proceed" is efficient but currently leaves no trace, so a reviewer
  cannot distinguish an explicit decision from a silent guess months later.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** the agent infers a detail not explicitly stated by the user
  - **When** it authors or edits the corresponding artifact
  - **Then** the artifact contains an "Assumptions" entry naming the inferred detail and its
    rationale, or the literal value "None" when no inference was made
- **Dependencies**: None

---

## Non-Functional Requirements

### RQ-REC-003: Instructions-file line budget
- **Category**: Non-Functional
- **NFR Type**: Maintainability
- **EARS Type**: State-driven
- **Statement**: WHILE a recursive self-improvement iteration edits
  `.github/instructions/agnos-sw-eng.v2.instructions.md`, the file's total line count SHALL NOT
  exceed 800 lines.
- **Metric**: Total line count ≤ 800
- **Measurement Method**: Line count of the file (e.g. `wc -l` / `Measure-Object -Line`), recorded
  as verification evidence in the closing task of any iteration that edits the file
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** an iteration has just edited the instructions file
  - **When** the task closes
  - **Then** the recorded line count is ≤ 800
  - **And** the count is cited in the task's Verification evidence
- **Dependencies**: None
