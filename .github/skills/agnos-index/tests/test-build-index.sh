#!/usr/bin/env bash
# Tests of build-index.sh against the shared fixtures and expected files.
# Covers RQ-IDX-001 to RQ-IDX-009, RQ-IDX-015 and RQ-IDX-016 (ADR-IDX-001, DEC-IDX-004).
# The whole suite runs twice: default mode, then POSIX mode (POSIXLY_CORRECT=1).
# Usage: bash .github/skills/agnos-index/tests/test-build-index.sh
set -u

HERE=$(cd "$(dirname "$0")" && pwd)
SCRIPT="$HERE/../scripts/build-index.sh"
INDEX_REL="process/INDEX.idx.md"
OLD_TIME="200001010000"
EXPECTED_NOMINAL_REPORT="agnos-index: 13 entries, 6 documents, process/INDEX.idx.md"
EXPECTED_DUPLICATE_REPORT="agnos-index: 3 entries, 1 documents, process/INDEX.idx.md updated"
EXPECTED_DUPLICATE_ERROR="agnos-index: DUPLICATE RQ-DUP-001 process/1.requirements/FTR-DUP-001.md:5 (first: process/1.requirements/FTR-DUP-001.md:3)"
EXPECTED_MISSING_ERROR="agnos-index: 'process' folder not found - run from the repository root"
failures=0

new_scenario() {
  dir=$(mktemp -d)
  if [ -n "$1" ]; then cp -R "$HERE/fixtures/$1/process" "$dir/"; fi
}

run_generator() {
  if [ "$mode" = "posix" ]; then
    (cd "$dir" && POSIXLY_CORRECT=1 bash "$SCRIPT" >"$dir/.out" 2>"$dir/.err")
  else
    (cd "$dir" && bash "$SCRIPT" >"$dir/.out" 2>"$dir/.err")
  fi
  code=$?
  out=$(cat "$dir/.out")
  err=$(cat "$dir/.err")
}

check() {
  if [ "$2" = "0" ]; then echo "PASS [$mode] $1"; else echo "FAIL [$mode] $1"; failures=$((failures + 1)); fi
}

for mode in default posix; do
  # Scenario: nominal documents
  new_scenario nominal
  run_generator
  [ "$code" = 0 ]; check "Given nominal documents When indexing Then the exit code is 0 [RQ-IDX-009]" $?
  cmp -s "$dir/$INDEX_REL" "$HERE/expected/nominal.idx.md"
  check "Given nominal documents When indexing Then the index equals the expected bytes [RQ-IDX-001..006, RQ-IDX-015]" $?
  [ "$out" = "$EXPECTED_NOMINAL_REPORT updated" ]; check "Given nominal documents When indexing Then the report says updated [RQ-IDX-009]" $?
  touch -t "$OLD_TIME" "$dir/$INDEX_REL" "$dir/.marker"
  run_generator
  [ "$out" = "$EXPECTED_NOMINAL_REPORT unchanged" ]; check "Given an up-to-date index When indexing again Then the report says unchanged [RQ-IDX-009]" $?
  ! [ "$dir/$INDEX_REL" -nt "$dir/.marker" ]; check "Given an up-to-date index When indexing again Then the file is not rewritten [RQ-IDX-009]" $?
  rm -rf "$dir"

  # Scenario: duplicate definitions
  new_scenario duplicate
  run_generator
  [ "$code" = 2 ]; check "Given a duplicate ID When indexing Then the exit code is 2 [RQ-IDX-007]" $?
  [ "$err" = "$EXPECTED_DUPLICATE_ERROR" ]; check "Given a duplicate ID When indexing Then the duplicate is reported [RQ-IDX-007]" $?
  cmp -s "$dir/$INDEX_REL" "$HERE/expected/duplicate.idx.md"
  check "Given a duplicate ID When indexing Then the index is still written [RQ-IDX-007, RQ-IDX-015]" $?
  [ "$out" = "$EXPECTED_DUPLICATE_REPORT" ]; check "Given a duplicate ID When indexing Then the report line is printed [RQ-IDX-009]" $?
  rm -rf "$dir"

  # Scenario: no process folder
  new_scenario ""
  run_generator
  [ "$code" = 1 ]; check "Given no process folder When indexing Then the exit code is 1 [RQ-IDX-008]" $?
  [ "$err" = "$EXPECTED_MISSING_ERROR" ]; check "Given no process folder When indexing Then the error is reported [RQ-IDX-008]" $?
  [ ! -e "$dir/process" ] && [ -z "$out" ]; check "Given no process folder When indexing Then nothing is written [RQ-IDX-008]" $?
  rm -rf "$dir"
done

if [ "$failures" -gt 0 ]; then echo "$failures check(s) failed"; exit 1; fi
echo "All checks passed"
exit 0
