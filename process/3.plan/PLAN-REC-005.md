<!-- Iteration: 5/5 -->
# PLAN-REC-005: Close the recursive self-improvement loop (recursive iteration 5/5)

## Overview
Implements FTR-REC-005: adds a "RECURSIVE SELF-IMPROVEMENT SESSIONS" section to the instructions
file formalizing tagging/commit conventions, updates the `agnos-git-workflow` SKILL.md to match,
and adds the proactive self-improvement proposal step to END SESSION ACTION.

## References
- **Requirements**: RQ-REC-007, RQ-REC-008, RQ-REC-009, RQ-REC-010
- **ADRs**: ADR-REC-005 (DEC-REC-006, DEC-REC-007, DEC-REC-008, DEC-REC-009)

---

## Tasks

### TASK-REC-006: Formalize iteration-tag and commit-message conventions
- **Tier**: L
- **Status**: Done
- **Description**: Add a "RECURSIVE SELF-IMPROVEMENT SESSIONS" section to the instructions file
  covering the `<!-- Iteration: k/N -->` tag (DEC-REC-006), the commit-message prefix/trailer
  (DEC-REC-007), the line-budget-across-all-iterations rule, the one-theme-at-a-time default, and
  the semantic-conflict post-condition on drafting a rule (DEC-REC-009). Update
  `.github/skills/agnos-git-workflow/SKILL.md`'s commit-task step to describe the same
  prefix/trailer for use during such sessions.
- **Requirement refs**: RQ-REC-007, RQ-REC-008, RQ-REC-010
- **ADR refs**: ADR-REC-005 (DEC-REC-006, DEC-REC-007, DEC-REC-009)
- **Acceptance Criteria** (Gherkin):
  - **Given** the edited instructions file and SKILL.md
  - **When** a recursive self-improvement session is run
  - **Then** both files describe the same `<type>(<TRI>): <ADR>/<TASK> <description>` +
    `Iteration: k/N` trailer convention, and the same artifact tagging rule
  - **And** the instructions file states that drafting a new rule during such a session has a
    post-condition: re-running the START SESSION ACTION step 7 conflict check against it before
    DoR presentation
- **Dependencies**: None
- **Assignee**: AI
- **Verification**: Re-read via the Read tool after editing — confirmed the new "RECURSIVE
  SELF-IMPROVEMENT SESSIONS" section (lines 118-125+, all 5 points) and the commit-task note
  citing RQ-REC-007 are present in the instructions file, and the matching prefix/trailer note is
  present in `.github/skills/agnos-git-workflow/SKILL.md`. Applied RQ-REC-010's post-condition to
  this very change: re-checked the new section and step against existing rules (default
  commit-task format, no-scope-creep rule) — no semantic conflict found. Line count re-measured
  with `(Get-Content file).Count`: **388** ≤ 800.
- **Assumptions**: Normative-text change, no executable function — unit-test obligation N/A, per
  the same reasoning as all prior tasks in this recursive effort.

### TASK-REC-007: Add proactive self-improvement proposal to END SESSION ACTION
- **Tier**: L
- **Status**: Done
- **Description**: Edit END SESSION ACTION to require a self-improvement proposal (line budget
  question, 1-3 friction-motivated themes, resulting iteration count) whenever the friction-metrics
  table has at least one non-zero counter, per DEC-REC-008.
- **Requirement refs**: RQ-REC-009
- **ADR refs**: ADR-REC-005 (DEC-REC-008)
- **Acceptance Criteria** (Gherkin):
  - **Given** the edited instructions file
  - **When** a session closes with a non-zero friction counter
  - **Then** the instruction requires proposing a follow-up with a line-budget question, themes,
    and iteration count, and forbids starting implementation before confirmation
- **Dependencies**: TASK-REC-006
- **Assignee**: AI
- **Verification**: Re-read END SESSION ACTION via the Read tool after editing — confirmed new
  step 3) citing RQ-REC-009, gated on a non-zero counter and forbidding implementation before
  confirmation, is present. Same conflict re-check as TASK-REC-006: no conflict with existing
  END SESSION ACTION steps 1-2 (RQ-REC-005/006) or the DoR gate. Line count unchanged from
  TASK-REC-006's measurement: **388** ≤ 800.
- **Assumptions**: Same as TASK-REC-006.
