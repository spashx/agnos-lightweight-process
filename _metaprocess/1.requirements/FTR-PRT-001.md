# FTR-PRT-001: Claude Code Compatibility

## Overview
Make the AGNOS process operable under **Claude Code** in addition to GitHub Copilot, without
duplicating the process text. Claude Code does not read `.github/instructions/*.instructions.md`
(it auto-loads `CLAUDE.md`) and does not read skills from `.github/skills/` (it reads
`.claude/skills/`). This feature adds the bridging artifacts required for Claude Code to load and
execute the same process, keeping a single canonical source for the process definition.

## Stakeholders
- **Owner**: AGNOS Process Team
- **Consumers**: AI agents running under Claude Code and GitHub Copilot; human developers using either tool

---

## Functional Requirements

### RQ-PRT-001: Claude Code Auto-Load Bridge
- **Category**: Functional
- **EARS Type**: Event-driven
- **Statement**: WHEN a Claude Code session starts in the workspace, the AGNOS process SHALL be
  loaded automatically via a root `CLAUDE.md` file that imports the canonical instruction file
  `.github/instructions/agnos-sw-eng.v1.instructions.md`.
- **Rationale**: Claude Code auto-loads `CLAUDE.md` but ignores `.github/instructions/`; the bridge
  makes the process active under Claude Code with no manual step.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given a workspace containing `CLAUDE.md` at the repository root
  - When a Claude Code session starts
  - Then the AGNOS process instructions are present in the agent's context via an `@import` of
    `.github/instructions/agnos-sw-eng.v1.instructions.md`
- **Dependencies**: None

---

### RQ-PRT-002: Skill Discoverable by Claude Code
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The AGNOS git-workflow skill SHALL be available to Claude Code under
  `.claude/skills/agnos-git-workflow/` with a `name` conforming to Claude Code's skill-naming rule
  (lowercase alphanumeric and hyphens only).
- **Rationale**: Claude Code discovers skills only under `.claude/skills/` and rejects skill names
  containing uppercase letters; the current `.github/skills/AGNOS-git-workflow` name is invalid and
  invisible to Claude Code.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given a Claude Code session
  - When the agent lists available skills
  - Then a skill named `agnos-git-workflow` is present and invokable
  - And its `name` field matches `^[a-z0-9]+(-[a-z0-9]+)*$`
- **Dependencies**: RQ-PRT-001

---

### RQ-PRT-003: Tool-Neutral User-Question Reference
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: WHERE the process instructs the agent to ask the user a question, it SHALL
  reference the question mechanism in a tool-agnostic way that resolves to `askQuestion` under
  GitHub Copilot and to the `AskUserQuestion` tool under Claude Code.
- **Rationale**: The process currently names the Copilot-only `askQuestion` tool; under Claude Code
  the equivalent is `AskUserQuestion`. A neutral reference keeps one source working on both tools.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given the canonical instruction file
  - When an agent reads a step that requires asking the user (e.g. START SESSION unit_tests, "Ask when blocking")
  - Then the step names the built-in question tool for both Copilot (`askQuestion`) and Claude Code (`AskUserQuestion`)
- **Dependencies**: RQ-PRT-001

---

## Non-Functional Requirements

### RQ-PRT-004: Single Source of Truth
- **Category**: Non-Functional
- **NFR Type**: Maintainability
- **EARS Type**: Ubiquitous
- **Statement**: The AGNOS process text SHALL exist in exactly one canonical file; every tool
  entry point (Copilot instructions, Claude Code `CLAUDE.md`) SHALL reference that file rather than
  copy its content.
- **Metric**: The process narrative (activities, rules, templates) appears in exactly one file; a
  diff of any tool-specific bridge file contains no copied process paragraphs.
- **Measurement Method**: Manual review of `CLAUDE.md` — it contains an import directive plus
  tool-specific notes only, no duplicated process body.
- **Priority**: Must
- **Acceptance Criteria**:
  - Given `CLAUDE.md` and `.github/instructions/agnos-sw-eng.v1.instructions.md`
  - When both are compared
  - Then the process activities/rules/templates exist only in the instruction file and `CLAUDE.md`
    imports it
- **Dependencies**: RQ-PRT-001
