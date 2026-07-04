# fable-harness v1.0 (2026-07-04) -- SessionStart hook: inject .claude/state/ into context.
# If state files exist, stdout (added to context on SessionStart) lists them and inlines the
# newest one so the session boots from files, not memory (session-bootstrap OPEN / solo P4).
# Silent (no output) when there is no state. Fails open on any error.
# NOTE: keep this file ASCII-only -- Windows PowerShell 5.1 reads BOM-less scripts as ANSI.

$ErrorActionPreference = 'Stop'
try {
    try { [Console]::In.ReadToEnd() | Out-Null } catch { }

    $root = $env:CLAUDE_PROJECT_DIR
    if (-not $root) { $root = (Get-Location).Path }
    $stateDir = Join-Path $root '.claude/state'
    if (-not (Test-Path -LiteralPath $stateDir)) { exit 0 }

    $files = Get-ChildItem -LiteralPath $stateDir -File | Sort-Object LastWriteTime -Descending
    if (-not $files) { exit 0 }

    Write-Output '[fable-harness] .claude/state/ is not empty - boot from files, not memory (session-bootstrap OPEN if installed; otherwise re-read the state, re-verify the top load-bearing facts in the code, and declare position/next-move before resuming). After a compaction, treat this as a new session in disguise.'
    Write-Output 'State files (newest first):'
    $files | Select-Object -First 10 | ForEach-Object {
        Write-Output ('  - {0} (modified {1:yyyy-MM-dd HH:mm})' -f $_.Name, $_.LastWriteTime)
    }

    $newest = $files[0]
    Write-Output ('--- {0}, first 60 lines ---' -f $newest.Name)
    $head = (Get-Content -LiteralPath $newest.FullName -TotalCount 60) -join "`n"
    if ($head.Length -gt 4000) { $head = $head.Substring(0, 4000) + "`n[truncated]" }
    Write-Output $head
    Write-Output '--- end of state file ---'
    exit 0
}
catch {
    exit 0
}
