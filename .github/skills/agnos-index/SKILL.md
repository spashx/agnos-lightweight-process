---
name: agnos-index
description: "AGNOS process index skill. Regenerates process/INDEX.idx.md, the machine-oriented index (ID, line range, status, title) of every FTR/RQ/ADR/DEC/PLAN/TASK definition in process/. USE FOR: START SESSION step 4 (before scanning process/) and commit-task (before staging). The index SHALL NEVER be edited by hand."
argument-hint: "(no arguments)"
---

# AGNOS Index

Canonical procedure, shared by GitHub Copilot (`.github/skills/agnos-index/`) and Claude Code
(`.claude/skills/agnos-index/`, which points here).

## Procedure

1. From the repository root, run the script matching `session.platform` (read
   `process/_sessionstate/session.yaml` first if not already in context):

   | `session.platform` | Command |
   |---|---|
   | `windows` | `powershell -NoProfile -File .github/skills/agnos-index/scripts/build-index.ps1` |
   | `linux` / `macos` | `bash .github/skills/agnos-index/scripts/build-index.sh` |

2. Check the exit code:
   - `0`: done. The single output line gives the entry and document counts.
   - `2`: duplicate IDs, listed on the error stream. The index is written; report the duplicates
     to the user (MANDATORY UNIQUE IDENTIFIERS).
   - `1`: error, nothing written. Apply the Error Recovery Protocol.

## Reading the index

- `@<path>` opens a document; each following row is `ID|first-last|status|title`.
- `#next` gives the next free ID of each `<TYPE>-<TRI>` prefix.
- Read an artifact by its line range only; open a whole document only when needed.
- After editing a document in-session, its line numbers after the edit shift: locate an ID by
  searching its heading in that document, or re-run this skill.
