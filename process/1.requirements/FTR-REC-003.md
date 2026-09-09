<!-- Iteration: 3/5 -->
# FTR-REC-003: Process friction metrics at session close

## Overview
Adds a fixed set of process-friction counters to the END SESSION ACTION summary, so recurring
signals (blocking questions, error-recovery triggers, re-tiered tasks, verification catches) are
reported consistently instead of scattered across individual task notes — giving future recursive
self-improvement iterations empirical data instead of intuition, and letting a reviewer spot a
pre-/post-mortem divergence (what was expected at DoR vs. what actually happened by DoD).

Third of 5 planned recursive self-improvement iterations on
`.github/instructions/agnos-sw-eng.v2.instructions.md` (see `process/2.architecture/ADR-REC-003.md`).

## Stakeholders
- **Owner**: AGNOS process session owner (this repository)
- **Consumers**: Any AI agent running the END SESSION ACTION; the user reviewing session closeout
  reports

---

## Functional Requirements

### RQ-REC-005: Report process friction metrics at session close
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN the END SESSION ACTION runs, the agent SHALL report, as a fixed-format table
  in the closing chat summary, counts of: AskUserQuestion invocations, Error Recovery Protocol
  invocations, tasks re-tiered, and Verification-caught discrepancies (per RQ-REC-001) observed
  during the session.
- **Rationale**: Iteration 1's RQ-REC-001 already caught a real discrepancy in this session (a
  `Measure-Object -Line` undercount) that would otherwise have gone unrecorded past that task's
  closure. Aggregating these signals at session level makes process friction visible and
  comparable across sessions, instead of buried in individual task notes.
- **Priority**: Should
- **Acceptance Criteria** (Gherkin):
  - **Given** a session ends (user indicates end of session or accepts all pending changes)
  - **When** the closing summary is generated
  - **Then** it includes a metrics table with all four counters listed, each reported as a number
  - **And** a counter with zero occurrences is shown as 0, never omitted
- **Dependencies**: RQ-REC-001

**Assumptions**: Counters are reported in chat only, not persisted to a file this iteration — see
ADR-REC-003 / DEC-REC-004. Cross-session persistence is deferred to a later iteration if this
reporting proves useful in practice; not stated explicitly by the user before this iteration, but
consistent with their preference to keep line growth minimal per iteration.
