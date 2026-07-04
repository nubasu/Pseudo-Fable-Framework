# fable-harness v1.0 (2026-07-04) -- PostToolUse hook (matcher: Task|Agent):
# after a subagent returns, remind the lead to run accept-work before integrating.
# Exit 2 feeds stderr back to the model as feedback; the tool result itself is untouched.
# NOTE: keep this file ASCII-only -- Windows PowerShell 5.1 reads BOM-less scripts as ANSI.

try { [Console]::In.ReadToEnd() | Out-Null } catch { }
[Console]::Error.WriteLine('[fable-harness] A subagent returned. Before integrating anything: run `accept-work` - verify its done-criteria independently (a report is a claim, not a fact), read the full diff, then ACCEPT / PATCH / BOUNCE / RECLAIM. For a read-only scout/report agent with nothing to integrate, note that and continue.')
exit 2
