<!-- Iteration: 5/5 -->
# FTR-REC-005: Close the recursive self-improvement loop

## Overview
Closes the loop started in iterations 1-4: formalizes the iteration-tagging and commit-message
conventions actually used across this session (so far tacit, living only in conversation), and —
the key missing piece — has the agent proactively propose a self-improvement follow-up at session
close whenever the friction metrics (RQ-REC-005/006) show something worth addressing, instead of
waiting for a human to think to ask for one.

This mirrors the human debrief-then-improve loop: a debrief that produces data but never turns into
a proposed action does not, by itself, industrialize anything.

Fifth and final of 5 planned recursive self-improvement iterations on
`.github/instructions/agnos-sw-eng.v2.instructions.md` (see `process/2.architecture/ADR-REC-005.md`).

## Stakeholders
- **Owner**: AGNOS process session owner (this repository)
- **Consumers**: Any AI agent running a recursive self-improvement effort on this file, or running
  END SESSION ACTION generally

---

## Functional Requirements

### RQ-REC-007: Commit-message convention for recursive self-improvement sessions
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN the agent commits a task as part of a session explicitly running numbered
  recursive self-improvement iterations on this instructions file, it SHALL prefix the existing
  `<ADR>/<TASK> <description>` commit-task message with a Conventional-Commits type and the `<TRI>`
  scope (`<type>(<TRI>): <ADR>/<TASK> <description>`) and add an `Iteration: <k>/<N>` trailer.
- **Rationale**: Iterations 1-4 of this very session already used this format by conversational
  agreement; writing it down makes it reusable and consistent the next time this happens without
  re-negotiating it.
- **Priority**: Should
- **Acceptance Criteria** (Gherkin):
  - **Given** a commit-task invocation during a numbered recursive self-improvement session
  - **When** the commit message is built
  - **Then** it starts with `<type>(<TRI>): ` ahead of the `<ADR>/<TASK>` segment
  - **And** it ends with an `Iteration: <k>/<N>` trailer
- **Dependencies**: None

### RQ-REC-008: Iteration tag on artifacts during recursive self-improvement sessions
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN the agent authors or edits a REQ, ADR, or PLAN/TASK artifact as part of a
  numbered recursive self-improvement session, it SHALL tag the artifact's first line with
  `<!-- Iteration: <k>/<N> -->`.
- **Rationale**: Same as RQ-REC-007 — already practiced across iterations 1-4, now written down.
- **Priority**: Should
- **Acceptance Criteria** (Gherkin):
  - **Given** an artifact authored during iteration `k` of `N`
  - **When** the file is created or edited
  - **Then** its first line reads `<!-- Iteration: k/N -->`
- **Dependencies**: None

### RQ-REC-009: Proactive self-improvement proposal at session close
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN the END SESSION ACTION's friction-metrics table (RQ-REC-005) contains at
  least one non-zero counter, the agent SHALL propose a recursive self-improvement follow-up: it
  SHALL ask the user for the maximum number of lines to add to the instructions file, present 1-3
  candidate improvement themes derived from the session's specific friction (each citing the
  counter(s) that motivate it), and state the resulting number of iterations — before implementing
  anything.
- **Rationale**: This is the step that turns a debrief into actual process improvement instead of
  a report nobody acts on — per the user's own framing, the mechanism that let humans industrialize
  their processes.
- **Priority**: Should
- **Acceptance Criteria** (Gherkin):
  - **Given** a session's closing friction-metrics table has at least one non-zero counter
  - **When** END SESSION ACTION completes
  - **Then** the agent's closing message includes a self-improvement proposal
  - **And** the proposal asks for a maximum-lines-to-add budget
  - **And** it lists 1-3 candidate themes, each citing the motivating counter(s)
  - **And** it states the implied number of iterations
  - **And** no implementation starts before the user confirms
- **Dependencies**: RQ-REC-005, RQ-REC-006

**Assumptions**: The proposal triggers on ANY non-zero counter (no numeric threshold) — consistent
with ADR-REC-003/004's "start simple, no premature tooling" reasoning; a threshold could be added
later if this over-triggers in practice. Not stated explicitly by the user.

### RQ-REC-010: Semantic-conflict check as a post-condition of drafting a self-improvement rule
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN the agent drafts a new or amended rule for the instructions file during a
  recursive self-improvement iteration, it SHALL, as a post-condition of that drafting step (before
  the rule is presented for DoR approval), re-apply the semantic-conflict check already mandated at
  session start (START SESSION ACTION step 7) against the rule being added, and report any conflict
  found.
- **Rationale**: The process already requires a conflict check once, at session start, against
  pre-existing instruction files — but never re-applies it at the one moment the instructions file's
  own content changes. This is a cheap, complementary check, not a guarantee of correctness or of
  alignment with the process's purpose: it catches a rule that plainly contradicts another, not one
  that is simply pointless or low-value. Human review at the DoR/theme-confirmation gates remains
  the primary safeguard.
- **Priority**: Should
- **Acceptance Criteria** (Gherkin):
  - **Given** a candidate rule drafted during a recursive self-improvement iteration
  - **When** the agent prepares to present it for DoR approval
  - **Then** it has checked the candidate rule against the instructions file's existing rules for
    semantic conflict
  - **And** any conflict found is reported to the user before the DoR presentation, not after
- **Dependencies**: None

