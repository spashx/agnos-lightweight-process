## Summary

<!-- What changed, in one or two sentences. Why, not just what. -->

## Traceability

<!-- AGNOS lives and dies by being able to `grep` an ID and find everything related to it.
     Fill in every field that applies; write "None" for what doesn't — don't leave it blank. -->

- **Requirement(s)**: `RQ-...` or `None`
- **ADR(s) / Decision(s)**: `ADR-...` (`DEC-...`) or `None`
- **Task(s)**: `TASK-...` or `None`
- **Related issue(s)**: `#...` or `None`

If this PR implements a tracked `TASK-*`, its `Verification` and `Assumptions` fields (per the
task's own file under `process/3.plan/`) should already be filled in from real evidence produced
in this branch — not from memory. Link or paste that evidence below if it isn't obvious from the
diff.

## History of this change

<!-- The point of this section is a decision trail, not a diff summary GitHub already gives you. -->

- **What was tried before, if anything, and why it didn't stick:**
- **What alternatives were considered for this change, and why this one won:**
- **What this change deliberately does NOT do (scope boundary):**

## Type of change

<!-- Matches the Conventional-Commits type used in the commit(s) — see CONTRIBUTING.md. -->
- [ ] `feat` — new capability
- [ ] `fix` — bug fix
- [ ] `docs` — documentation only
- [ ] `refactor` — no behavior change
- [ ] `test` — tests only
- [ ] `chore` / `build` / `ci` — tooling, process, or repo maintenance

## Checklist

- [ ] Commit message(s) follow `<type>(<scope>): <description>`, computed via the
      `agnos-git-workflow` skill's `commit-task` sub-command where applicable.
- [ ] Every new or touched artifact still references its requirement/ADR ID (no orphaned
      artifact).
- [ ] No duplicated/magic literal was introduced without a named constant.
- [ ] Tests pass, and none were edited just to force a pass.
- [ ] If `.github/instructions/agnos-sw-eng.v3.instructions.md` was touched: post-edit line count
      is ≤ 800 — state it here: `___ lines`.
- [ ] If both `.github/` and `.claude/` copies of a skill exist, they were kept in sync (or the
      `.claude/` side remains a thin pointer, unchanged).

## Additional context

<!-- Anything a reviewer needs that isn't in the diff: screenshots, session transcripts, links. -->
