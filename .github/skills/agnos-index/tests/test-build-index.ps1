# Tests of build-index.ps1 against the shared fixtures and expected files.
# Covers RQ-IDX-001 to RQ-IDX-009 and RQ-IDX-015 (ADR-IDX-001, DEC-IDX-004).
# Usage: powershell -NoProfile -File .github/skills/agnos-index/tests/test-build-index.ps1
$ErrorActionPreference = 'Stop'

$Here = $PSScriptRoot
$Script = Join-Path $Here '..\scripts\build-index.ps1'
$IndexRel = 'process\INDEX.idx.md'
$OutFile = '.out'
$ErrFile = '.err'
$OldTime = [datetime]'2000-01-01'
$ReportPrefix = 'agnos-index: '
$ExpectedNominalReport = 'agnos-index: 13 entries, 6 documents, process/INDEX.idx.md'
$ExpectedDuplicateReport = 'agnos-index: 3 entries, 1 documents, process/INDEX.idx.md updated'
$ExpectedDuplicateError = 'agnos-index: DUPLICATE RQ-DUP-001 process/1.requirements/FTR-DUP-001.md:5 (first: process/1.requirements/FTR-DUP-001.md:3)'
$ExpectedMissingError = "agnos-index: 'process' folder not found - run from the repository root"
$script:Failures = 0

function New-Scenario([string]$Fixture) {
    $dir = Join-Path ([IO.Path]::GetTempPath()) ('agnos-index-' + [guid]::NewGuid())
    New-Item -ItemType Directory -Path $dir | Out-Null
    if ($Fixture) { Copy-Item -Recurse -LiteralPath (Join-Path $Here "fixtures\$Fixture\process") -Destination $dir }
    $dir
}

function Invoke-Generator([string]$Dir) {
    $p = Start-Process -FilePath 'powershell' -ArgumentList "-NoProfile -File `"$Script`"" -WorkingDirectory $Dir `
        -RedirectStandardOutput (Join-Path $Dir $OutFile) -RedirectStandardError (Join-Path $Dir $ErrFile) -Wait -PassThru -NoNewWindow
    @{
        Code = $p.ExitCode
        Out  = ([IO.File]::ReadAllText((Join-Path $Dir $OutFile))).TrimEnd()
        Err  = ([IO.File]::ReadAllText((Join-Path $Dir $ErrFile))).TrimEnd()
    }
}

function Test-SameBytes([string]$Actual, [string]$Expected) {
    (Test-Path -LiteralPath $Actual) -and
        ([Convert]::ToBase64String([IO.File]::ReadAllBytes($Actual)) -ceq [Convert]::ToBase64String([IO.File]::ReadAllBytes($Expected)))
}

function Assert-That([string]$Name, [bool]$Condition) {
    if ($Condition) { "PASS $Name" } else { "FAIL $Name"; $script:Failures++ }
}

# Scenario: nominal documents
$dir = New-Scenario 'nominal'
$index = Join-Path $dir $IndexRel
$r = Invoke-Generator $dir
Assert-That 'Given nominal documents When indexing Then the exit code is 0 [RQ-IDX-009]' ($r.Code -eq 0)
Assert-That 'Given nominal documents When indexing Then the index equals the expected bytes [RQ-IDX-001..006, RQ-IDX-015]' `
    (Test-SameBytes $index (Join-Path $Here 'expected\nominal.idx.md'))
Assert-That 'Given nominal documents When indexing Then the report says updated [RQ-IDX-009]' ($r.Out -ceq "$ExpectedNominalReport updated")
(Get-Item -LiteralPath $index).LastWriteTime = $OldTime
$r = Invoke-Generator $dir
Assert-That 'Given an up-to-date index When indexing again Then the report says unchanged [RQ-IDX-009]' ($r.Out -ceq "$ExpectedNominalReport unchanged")
Assert-That 'Given an up-to-date index When indexing again Then the file is not rewritten [RQ-IDX-009]' `
    ((Get-Item -LiteralPath $index).LastWriteTime -eq $OldTime)
Remove-Item -Recurse -Force -LiteralPath $dir

# Scenario: duplicate definitions
$dir = New-Scenario 'duplicate'
$r = Invoke-Generator $dir
Assert-That 'Given a duplicate ID When indexing Then the exit code is 2 [RQ-IDX-007]' ($r.Code -eq 2)
Assert-That 'Given a duplicate ID When indexing Then the duplicate is reported [RQ-IDX-007]' ($r.Err -ceq $ExpectedDuplicateError)
Assert-That 'Given a duplicate ID When indexing Then the index is still written [RQ-IDX-007, RQ-IDX-015]' `
    (Test-SameBytes (Join-Path $dir $IndexRel) (Join-Path $Here 'expected\duplicate.idx.md'))
Assert-That 'Given a duplicate ID When indexing Then the report line is printed [RQ-IDX-009]' ($r.Out -ceq $ExpectedDuplicateReport)
Remove-Item -Recurse -Force -LiteralPath $dir

# Scenario: no process folder
$dir = New-Scenario ''
$r = Invoke-Generator $dir
Assert-That 'Given no process folder When indexing Then the exit code is 1 [RQ-IDX-008]' ($r.Code -eq 1)
Assert-That 'Given no process folder When indexing Then the error is reported [RQ-IDX-008]' ($r.Err -ceq $ExpectedMissingError)
Assert-That 'Given no process folder When indexing Then nothing is written [RQ-IDX-008]' `
    (-not (Test-Path -LiteralPath (Join-Path $dir 'process')) -and -not $r.Out.StartsWith($ReportPrefix))
Remove-Item -Recurse -Force -LiteralPath $dir

if ($script:Failures -gt 0) { "$($script:Failures) check(s) failed"; exit 1 }
'All checks passed'
exit 0
