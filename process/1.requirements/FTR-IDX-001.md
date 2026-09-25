# FTR-IDX-001: Process artifact index

## Overview
Locating an artifact by its ID in large process documents (e.g. a feature file holding a hundred
requirements) is token-expensive for the agent: it has to read or search whole files. This feature
adds a generated, machine-oriented index, `process/INDEX.idx.md`, listing every FTR, RQ, ADR, DEC,
PLAN and TASK definition with its line range, status and title. The agent reads this single small
file at session start, then opens process documents only by line range.

The index is written exclusively by a dedicated skill, `agnos-index`, backed by two native scripts
(Windows PowerShell 5.1 and bash) that produce byte-identical output and are invocable from both
GitHub Copilot and Claude Code. The index is versioned in git.

## Stakeholders
- **Owner**: AGNOS process maintainer (this repository)
- **Consumers**: AI agents running the AGNOS process (GitHub Copilot, Claude Code); the
  `agnos-git-workflow` skill (`commit-task` sub-command)

---

## Functional Requirements

### RQ-IDX-001: Indexed documents
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The index generator SHALL index every file whose name ends with `.md`
  (case-insensitive) found recursively under `process/1.requirements/`, `process/2.architecture/`
  and `process/3.plan/`, excluding files whose name ends (case-insensitive) with `.idx.md`,
  `readme.md` or `template.md`.
- **Rationale**: READMEs and templates define no artifact, the index must never index itself, and
  `process/_sessionstate/` holds no artifact.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** a process folder holding feature, ADR and plan documents, a document in a
    sub-folder, a README, a template, a `.idx.md` file and a `_sessionstate/` document
  - **When** the index is generated
  - **Then** each feature, ADR, plan and sub-folder document has a group in the index
  - **And** the README, the template, the `.idx.md` file and the `_sessionstate/` document have none
- **Dependencies**: None

### RQ-IDX-002: Artifact definition detection
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The index generator SHALL record as an artifact definition every ATX heading line
  (1 to 6 `#` at column 1, followed by a blank or the end of line) located outside fenced code
  blocks, whose text starts with an ID `<TYPE>-<TRI>-<NNN>` (TYPE among FTR, RQ, ADR, DEC, PLAN,
  TASK; TRI three uppercase ASCII letters; NNN three ASCII digits) immediately followed by a colon
  (optionally preceded by blanks), a blank, or the end of line.
- **Rationale**: IDs appear everywhere as references (Dependencies, refs fields, prose); only
  headings define artifacts, and every AGNOS template already declares artifacts as headings.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** a heading `### RQ-TST-001: Title` outside any fence
  - **When** the index is generated
  - **Then** an entry `RQ-TST-001` is recorded
  - **And** no entry is recorded for an ID found in a Dependencies field, in prose, in a heading
    inside a fenced block, or in a heading `### RQ-TST-0055: Title`
- **Dependencies**: RQ-IDX-001

### RQ-IDX-003: Entry line range and title
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The index SHALL give, for each definition, its first line (the heading line), its
  last line (the line preceding the next heading of the same or a higher level located outside
  fenced blocks, or else the last line of the document) and its title (the heading text following
  the ID and the optional colon, stripped of surrounding blanks), line numbers being 1-based.
- **Rationale**: A first-last range lets the agent read exactly one artifact instead of a whole
  document.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** an H3 requirement heading at line 12 followed by the next H3 heading at line 25
  - **When** the index is generated
  - **Then** its row shows the range `12-24`
  - **And** an H1 feature heading at line 1 of a 40-line document without any other H1 shows `1-40`
  - **And** a `#` comment line inside a fenced Gherkin block does not end any range
- **Dependencies**: RQ-IDX-002

### RQ-IDX-004: Entry status
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The index SHALL give as status of a definition the value of the first status field
  met while that definition is the innermost open one, a status field being either a line
  `**Status**: <value>` (optionally bulleted with `-`, `*` or `+`) or the first non-blank line
  following a heading whose text is `Status`; the value SHALL be stripped of surrounding blanks and
  have each `|` replaced by `/`, and the status SHALL be empty when no status field exists.
- **Rationale**: TASK and ADR templates carry a status; exposing it shows open tasks and superseded
  ADRs at session start without opening any document.
- **Priority**: Should
- **Acceptance Criteria** (Gherkin):
  - **Given** a task section holding `- **Status**: Done`
  - **When** the index is generated
  - **Then** the task row status is `Done`
  - **And** an ADR whose `## Status` heading is followed by `Accepted` has the status `Accepted`
  - **And** a status `[Not Started | Done]` is written `[Not Started / Done]`
  - **And** a plan whose only status line belongs to its first task has an empty status
- **Dependencies**: RQ-IDX-002, RQ-IDX-003

### RQ-IDX-005: Index file layout
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The index generator SHALL write `process/INDEX.idx.md` as two fixed header lines,
  one `#next` line, then, for each indexed document in ordinal (byte-wise) order of its path, a line
  `@<path>` (path relative to the repository root, `/`-separated) followed by one row
  `<ID>|<first>-<last>|<status>|<title>` per definition, in line order.
- **Rationale**: One read gives the whole inventory; writing the path once per document instead of
  once per row saves tokens; the title comes last so it never needs escaping.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** the documents `process/2.architecture/ADR-TST-001.md` and
    `process/1.requirements/FTR-TST-001.md`
  - **When** the index is generated
  - **Then** the `@process/1.requirements/FTR-TST-001.md` group precedes the ADR group
  - **And** a document without any definition has its `@` line and no row
  - **And** a title containing `|` is written verbatim as the last field
- **Dependencies**: RQ-IDX-003, RQ-IDX-004

### RQ-IDX-006: Next free IDs
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The index SHALL list on its `#next` line, separated by single spaces, for each
  `<TYPE>-<TRI>` prefix having at least one definition, the ID numbered one above the highest
  defined number of that prefix, zero-padded to 3 digits, in order of first appearance in the index.
- **Rationale**: Prevents ID collisions when the agent creates artifacts (MANDATORY UNIQUE
  IDENTIFIERS), without counting IDs by hand.
- **Priority**: Should
- **Acceptance Criteria** (Gherkin):
  - **Given** the definitions `RQ-TST-001` and `RQ-TST-004` and no other `RQ-TST` definition
  - **When** the index is generated
  - **Then** the `#next` line contains `RQ-TST-005`
- **Dependencies**: RQ-IDX-005

### RQ-IDX-007: Duplicate definitions
- **Category**: Functional
- **EARS Type**: Unwanted-behavior
- **Statement**: IF an ID is defined more than once, THEN the index generator SHALL still write the
  index, SHALL report each extra definition on the error stream as
  `agnos-index: DUPLICATE <ID> <path>:<line> (first: <path>:<line>)` and SHALL exit with code 2.
- **Rationale**: Unique IDs are mandatory; the generator sees every definition and can enforce it
  mechanically.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** `RQ-DUP-001` defined twice
  - **When** the index is generated
  - **Then** the error stream holds one DUPLICATE line locating both definitions
  - **And** the exit code is 2
  - **And** the index is written with both rows
- **Dependencies**: RQ-IDX-002

### RQ-IDX-008: Missing process folder
- **Category**: Functional
- **EARS Type**: Unwanted-behavior
- **Statement**: IF the working directory holds no `process/` folder, THEN the index generator SHALL
  write no file, SHALL report
  `agnos-index: 'process' folder not found - run from the repository root` on the error stream and
  SHALL exit with code 1.
- **Rationale**: The generator must be run from the repository root; failing loudly avoids writing
  an index elsewhere.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** a working directory without `process/` folder
  - **When** the generator runs
  - **Then** it exits with code 1, reports the error and creates no file
- **Dependencies**: None

### RQ-IDX-009: Write on change and run report
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN it runs, the index generator SHALL rewrite `process/INDEX.idx.md` only if the
  generated content differs from the file content, and SHALL print on the output stream the single
  line `agnos-index: <E> entries, <D> documents, process/INDEX.idx.md <updated|unchanged>`.
- **Rationale**: A one-line report costs the agent almost no token; an unchanged index is left
  untouched.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** an index already up to date
  - **When** the generator runs again
  - **Then** the index file bytes and last-write time are unchanged
  - **And** the output line ends with `unchanged`
- **Dependencies**: RQ-IDX-005

### RQ-IDX-010: Skill invocation
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The `agnos-index` skill SHALL be invocable by GitHub Copilot through
  `.github/skills/agnos-index/SKILL.md` (canonical procedure) and by Claude Code through
  `.claude/skills/agnos-index/SKILL.md` (pointer to the canonical procedure), and SHALL select its
  script from `session.platform`: `build-index.ps1` run by Windows PowerShell 5.1 for `windows`,
  `build-index.sh` run by bash for `linux` and `macos`.
- **Rationale**: Same packaging and dispatch as `agnos-git-workflow`, one source of truth for both
  agents.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** a session with `session.platform` set to `windows`
  - **When** the agent invokes the `agnos-index` skill
  - **Then** `build-index.ps1` runs and prints its report line
- **Dependencies**: RQ-IDX-009

### RQ-IDX-011: Index-first reading at session start
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN a session starts, the agent SHALL invoke the `agnos-index` skill and read
  `process/INDEX.idx.md` before scanning the process folders (START SESSION steps 4 to 6), and SHALL
  then open a process document only by the line range the index gives for the artifact it needs,
  unless the whole document is needed.
- **Rationale**: This is the purpose of the feature: one small read instead of whole documents.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** the updated instructions file
  - **When** a session starts
  - **Then** START SESSION requires invoking `agnos-index` and reading the index before steps 4 to 6
  - **And** requires ranged reads of process documents based on the index
- **Dependencies**: RQ-IDX-010

### RQ-IDX-012: Index refresh before commit
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN the `commit-task` sub-command of `agnos-git-workflow` runs, the agent SHALL
  invoke the `agnos-index` skill before staging, and SHALL stop and report without committing if the
  skill exits with a non-zero code.
- **Rationale**: A commit never carries an index inconsistent with its documents, and the on-disk
  index stays fresh for re-reads after a context compaction.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** the updated `commit-task` procedure
  - **When** a task is committed
  - **Then** the index is regenerated before `git add .`
  - **And** a non-zero exit code of the skill stops the commit
- **Dependencies**: RQ-IDX-010

### RQ-IDX-013: Generated-only index
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The agent SHALL NEVER create or modify `process/INDEX.idx.md` otherwise than by
  invoking the `agnos-index` skill.
- **Rationale**: A hand-maintained index drifts silently; the script is deterministic.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** the updated instructions file
  - **When** it is read
  - **Then** it states that the index is written only by the `agnos-index` skill
- **Dependencies**: RQ-IDX-010

### RQ-IDX-014: Decision heading convention
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The ADR template SHALL declare each decision as a heading
  `### DEC-<TRI>-<NNN>: <title>` under `## Decision`.
- **Rationale**: The template mandates DEC IDs without fixing their syntax; a heading makes
  decisions indexable like every other artifact (RQ-IDX-002).
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** the updated ADR template
  - **When** a new ADR is written from it
  - **Then** each decision is a `### DEC-<TRI>-<NNN>: <title>` heading under `## Decision`
- **Dependencies**: RQ-IDX-002

---

## Non-Functional Requirements

### RQ-IDX-015: Byte-identical output across platforms
- **Category**: Non-Functional
- **NFR Type**: Portability
- **EARS Type**: Ubiquitous
- **Statement**: The PowerShell and bash implementations of the index generator SHALL produce
  byte-identical index files, identical output and error lines, and identical exit codes for the
  same input documents.
- **Metric**: 0 byte of difference between each implementation's results and the shared expected
  files, for every test scenario.
- **Measurement Method**: Both test runners (`test-build-index.ps1`, `test-build-index.sh`) compare
  their results with the same expected files under `.github/skills/agnos-index/tests/expected/`.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** the shared test fixtures
  - **When** both test runners are executed
  - **Then** every scenario passes on both
- **Dependencies**: RQ-IDX-001, RQ-IDX-002, RQ-IDX-003, RQ-IDX-004, RQ-IDX-005, RQ-IDX-006,
  RQ-IDX-007, RQ-IDX-008, RQ-IDX-009

### RQ-IDX-016: Runtime compatibility
- **Category**: Non-Functional
- **NFR Type**: Portability
- **EARS Type**: Ubiquitous
- **Statement**: `build-index.ps1` SHALL run on Windows PowerShell 5.1 without any module, and
  `build-index.sh` SHALL run on bash 3.2 or later with any POSIX awk (gawk, mawk, BSD awk).
- **Metric**: every test scenario passes on Windows PowerShell 5.1, and on bash with gawk both in
  default and in POSIX mode; the awk program holds no regex interval expression.
- **Measurement Method**: Test runners, the bash runner being executed a second time with
  `POSIXLY_CORRECT=1`; search of `build-index.sh` for interval expressions.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** the two generators
  - **When** the test runners are executed in the environments above
  - **Then** every scenario passes
- **Dependencies**: RQ-IDX-015

### RQ-IDX-017: Generation time
- **Category**: Non-Functional
- **NFR Type**: Performance
- **EARS Type**: Ubiquitous
- **Statement**: The index generator SHALL complete, interpreter start-up included, in less than
  2 seconds for a corpus of 50 documents totalling 20,000 lines.
- **Metric**: wall-clock time < 2 s per run, for each implementation.
- **Measurement Method**: Timed run (`Measure-Command`, `time`) of each generator on a synthetic
  corpus of 50 documents of 400 lines, generated for the measurement and not committed.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** the synthetic corpus
  - **When** each generator runs
  - **Then** its wall-clock time is below 2 seconds
- **Dependencies**: RQ-IDX-001
