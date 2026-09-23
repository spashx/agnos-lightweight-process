# Changelog

All notable changes to this repository are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [v3.1]

### Changed
- Section 4 ("Code Implementation and Quality") rewording: "All" → "ALL" and "Every" → "EVERY"
  for emphasis consistency with the rest of the file's SHALL/MANDATORY language.

### Removed
- `chat_mode` session state variable and all references to it (session-start question, schema,
  variable-kind table, "Chat Verbosity" guidance) from
  `.github/instructions/agnos-sw-eng.instructions.md`, `README.md`, `GETTING_STARTED.MD`, and
  `process/_sessionstate/session.yaml`.
Consider using a dedicated harness like [caveman](https://github.com/juliusbrussee/caveman) to manage chat verbosity.
- redondant "versions" removed almost everywhere. only CHANGELOG.md and releases relate to version.



