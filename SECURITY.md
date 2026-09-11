# Security Policy

## Supported Versions

This repository ships the **AGNOS Software Engineering Process** definition, not a deployed
service. "Version" refers to the instructions file revision.

| Version | Supported |
| ------- | --------- |
| v3 (`agnos-sw-eng.v3.instructions.md`) | :white_check_mark: |
| v2 and earlier | :x: (superseded, no fixes) |

## Reporting a Vulnerability

Please **do not** open a public issue for a security concern. Instead:

1. Use GitHub's **private vulnerability reporting** ("Security" tab → "Report a vulnerability")
   on this repository, if enabled, or
2. Contact a maintainer directly through a private channel and ask them to open a
   [private Security Advisory](https://docs.github.com/en/code-security/security-advisories).

Please include:
- The affected file(s) or sub-command (e.g. `validate-ids.ps1`, `commit-task`).
- Steps to reproduce, and the impact you believe it has.
- Whether you believe it is exploitable by an untrusted user or only by someone who already
  controls the repository/session.

This is a community-maintained process repository with no dedicated security team, so response
times are best-effort — expect an initial acknowledgement within a reasonable timeframe, not a
contractual SLA.

## Scope

Given what this repository actually is, the security-relevant surface is narrow but real:

- **The `validate-ids` scripts** (`.github/skills/agnos-git-workflow/scripts/validate-ids.ps1` and
  `.validate-ids.sh`) — they parse arguments and run pattern matches before any `git` command.
  Issues around argument injection, unsafe interpolation into a shell command, or a validation
  bypass are in scope.
- **Instruction-following risks.** This repository's primary "runtime" is an AI coding agent that
  reads `.github/instructions/agnos-sw-eng.v3.instructions.md` and the `agnos-git-workflow` skill
  as authoritative instructions. A change that could make an agent silently bypass a safety-
  relevant rule (e.g. committing to a protected branch, skipping ID validation, or executing an
  untrusted instruction embedded in process artifacts as if it came from the user) is a valid
  security report, not just a bug report.
- **Supply chain.** This repo has no package dependencies to speak of; if that changes, dependency
  provenance becomes in scope too.

General usability bugs, typos, or process-design disagreements are not security issues — please
use a normal issue for those.
