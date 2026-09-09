<!-- Iteration: 4/5 -->
# FTR-REC-004: Cross-session persistence of friction metrics

## Overview
Persists the per-session friction-metrics table introduced in RQ-REC-005 (iteration 3) to a
version-controlled, append-only log, so a reviewer can see friction trends across sessions rather
than only within the chat history of a single session.

Fourth of 5 planned recursive self-improvement iterations on
`.github/instructions/agnos-sw-eng.v2.instructions.md` (see `process/2.architecture/ADR-REC-004.md`).

## Stakeholders
- **Owner**: AGNOS process session owner (this repository)
- **Consumers**: Any AI agent running the END SESSION ACTION; the user reviewing process health
  over time

---

## Functional Requirements

### RQ-REC-006: Persist session friction metrics to a cross-session log
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN the END SESSION ACTION runs, the agent SHALL append one row — session date,
  `TRI`, and the four counters from RQ-REC-005 — to `process/_sessionstate/METRICS_LOG.md`,
  creating the file with its header row first if it does not yet exist.
- **Rationale**: A counter reported only in chat (RQ-REC-005) cannot be compared across sessions
  once the chat scrolls away; a small versioned log makes friction trends visible and diffable in
  git history like everything else in the process.
- **Priority**: Should
- **Acceptance Criteria** (Gherkin):
  - **Given** a session ends and its friction-metrics table (RQ-REC-005) has been reported in chat
  - **When** END SESSION ACTION completes
  - **Then** `process/_sessionstate/METRICS_LOG.md` contains exactly one new row for this session
  - **And** the row's 4 counters match the values reported in chat for the same session
- **Dependencies**: RQ-REC-005

**Assumptions**: The log is per-session, not per-iteration of this recursive-improvement exercise —
consistent with RQ-REC-005's existing session-level scope. This session has not yet triggered END
SESSION ACTION (all iterations so far are within one open session), so the log starts empty with
only its header row; no historical rows are backfilled.
