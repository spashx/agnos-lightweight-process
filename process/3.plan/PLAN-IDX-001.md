# PLAN-IDX-001: Process artifact index

## Overview
Implements FTR-IDX-001: the `agnos-index` skill, its two scripts and tests, and its integration into
the AGNOS process.

## References
- **Requirements**: RQ-IDX-001 to RQ-IDX-017
- **ADRs**: ADR-IDX-001 (DEC-IDX-001 to DEC-IDX-004)

---

## Tasks

### TASK-IDX-001: Index generators and tests
- **Tier**: L
- **Status**: Done
- **Description**: Shared fixtures and expected index, `build-index.ps1`, `build-index.sh`, and a test
  runner per platform.
- **Requirement refs**: RQ-IDX-001 to RQ-IDX-009, RQ-IDX-015 to RQ-IDX-017
- **ADR refs**: ADR-IDX-001 (DEC-IDX-001 to DEC-IDX-004)
- **Acceptance Criteria** (Gherkin):
  - **Given** the shared fixtures
  - **When** each test runner is executed
  - **Then** both generators produce exactly the expected index, report line and exit code
- **Dependencies**: None
- **Assignee**: AI
- **Verification**: `test-build-index.ps1`: 12/12 PASS. `test-build-index.sh` (Git Bash): 24/24 PASS
  (default + `POSIXLY_CORRECT=1`); `bash -n` OK; no regex interval in `build-index.sh`;
  `build-index.ps1` has 0 non-ASCII line. Synthetic corpus 50 docs / 20,050 lines / 2,550 entries:
  ps1 1.82-2.04 s (PowerShell start-up alone 0.93 s), sh 0.26 s; sh reports `unchanged` on the
  ps1-written index, i.e. byte-identical output.
- **Assumptions**: Bash run on Windows (Git Bash) only to verify `build-index.sh`, as decided by the
  user at session start. Corpus far denser than a real project (one entry every 8 lines).

### TASK-IDX-002: Skill packaging and process integration
- **Tier**: L
- **Status**: Done
- **Description**: `agnos-index` SKILL.md (+ Claude Code pointer, CLAUDE.md line), instructions
  update (folder structure, START SESSION step 4, DEC headings), index refresh in `commit-task`.
- **Requirement refs**: RQ-IDX-010 to RQ-IDX-014
- **ADR refs**: ADR-IDX-001 (DEC-IDX-002, DEC-IDX-003, DEC-IDX-004)
- **Acceptance Criteria** (Gherkin):
  - **Given** the updated process files
  - **When** a session starts or a task is committed
  - **Then** the agent runs `agnos-index` and reads the index instead of whole documents
- **Dependencies**: TASK-IDX-001
- **Assignee**: AI
- **Verification**: Claude Code lists the `agnos-index` skill; running it on this repository gave
  `agnos-index: 26 entries, 3 documents, process/INDEX.idx.md updated` (exit 0) with TASK and ADR
  statuses extracted. Instructions file: 382 lines (budget 800). `commit-task` now refreshes the
  index at step 4, before confirmation and staging.
- **Assumptions**: None
