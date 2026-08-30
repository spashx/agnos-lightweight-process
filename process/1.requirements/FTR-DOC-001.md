# FTR-DOC-001: AGNOS Onboarding Guide

## Overview
A single, self-contained walkthrough showing a human operator how to run one complete AGNOS
session — from branch creation to the closing report — on one small example feature. It exists so
that a newcomer can run their first session without having to read the normative instruction file
end to end, and so that an AI agent asked to "show me how AGNOS works" has one canonical answer.

## Stakeholders
- **Owner**: AGNOS Process Owner
- **Consumers**: Developers adopting AGNOS on a new project; AI coding agents (GitHub Copilot,
  Claude Code) asked to demonstrate, explain, or bootstrap the process.

---

## Functional Requirements

### RQ-DOC-001: Complete session walkthrough
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The AGNOS repository SHALL provide a `GETTING_STARTED.MD` guide that walks through one complete session covering, in execution order, the six process stages: session start, requirement authoring, ADR authoring, plan and task definition, implementation with verification, and session close.
- **Rationale**: The normative instruction file states the rules but never shows them applied, leaving a newcomer to infer the sequence and the hand-offs.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** a reader who has never run an AGNOS session
  - **When** they open `GETTING_STARTED.MD`
  - **Then** they find at least one section per process stage, in execution order, each naming the stage it covers and the instruction section that governs it
  - **And** no stage is left without a section
- **Dependencies**: None

### RQ-DOC-002: Human-side prompts and agent-side artifacts
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: For each of the six stages, the guide SHALL show both the prompt the human operator types and the artifact the agent produces in response.
- **Rationale**: AGNOS splits work between a human driver and an AI executor; a guide that shows only the output does not teach the reader what to say.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** any stage section of the guide
  - **When** the reader reads it
  - **Then** the section contains at least one copy-pasteable prompt block and at least one excerpt of the resulting artifact or file
- **Dependencies**: RQ-DOC-001

### RQ-DOC-003: One continuous traceable example
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The guide SHALL use a single example feature under one trigram across all six stages, and SHALL make the full traceability chain visible: feature ID → requirement ID → ADR and decision ID → plan and task ID → source-code comment → commit message.
- **Rationale**: Traceability is the central obligation of AGNOS; disconnected per-stage snippets would demonstrate the templates but not the chain that makes them worth writing.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** the example requirement ID used in the guide
  - **When** the reader greps that ID across the guide
  - **Then** it appears in the requirement excerpt, the ADR excerpt, the task excerpt, the source-code excerpt, and the test excerpt
- **Dependencies**: RQ-DOC-001

### RQ-DOC-004: Discoverability from the README
- **Category**: Functional
- **EARS Type**: Ubiquitous
- **Statement**: The repository `README.md` SHALL link to `GETTING_STARTED.MD` from both its Quick Start section and its File References section.
- **Rationale**: A guide nobody finds does not onboard anybody; the README is the single entry point a newcomer opens first.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** a reader on the repository landing page
  - **When** they read the Quick Start section
  - **Then** a link to `GETTING_STARTED.MD` is present before the numbered session steps
  - **And** the same link is listed under File References
- **Dependencies**: RQ-DOC-001

### RQ-DOC-005: Guide never overrides the normative process
- **Category**: Functional
- **EARS Type**: Unwanted-behavior
- **Statement**: IF the guide describes a process rule, THEN the guide SHALL restate that rule as defined in `.github/instructions/agnos-sw-eng.v2.instructions.md` without relaxing, extending, or contradicting it, and SHALL name the instruction section it comes from.
- **Rationale**: Two documents describing the same process will drift; the guide must be explicitly subordinate so that drift is always resolved in favour of the instruction file.
- **Priority**: Must
- **Acceptance Criteria** (Gherkin):
  - **Given** any normative statement in the guide
  - **When** it is compared against the instruction file
  - **Then** it is equivalent to a rule present in that file
  - **And** the guide states that the instruction file prevails in case of divergence
- **Dependencies**: RQ-DOC-001

---

## Non-Functional Requirements

### RQ-DOC-006: Self-sufficiency for a first session
- **Category**: Non-Functional
- **NFR Type**: Usability
- **EARS Type**: Ubiquitous
- **Statement**: The guide SHALL enable a reader to complete their first AGNOS session without opening the normative instruction file.
- **Metric**: 6 of 6 stage sections carry at least one copy-pasteable prompt block and at least one artifact excerpt; the guide contains a single-table summary of every prompt the human types across a session.
- **Measurement Method**: Manual review against the metric, one pass per stage section, plus a check that the summary table lists one row per stage.
- **Priority**: Should
- **Acceptance Criteria** (Gherkin):
  - **Given** a reader with the repository cloned and an AI coding tool configured
  - **When** they follow the guide top to bottom on their own feature
  - **Then** they produce a requirement file, an ADR, a plan, an implementation and a conforming commit without consulting `.github/instructions/agnos-sw-eng.v2.instructions.md`
- **Dependencies**: RQ-DOC-001, RQ-DOC-002
