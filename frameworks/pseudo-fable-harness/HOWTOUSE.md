# pseudo-fable-harness — How to use

English | [日本語](HOWTOUSE.ja.md)

Day-to-day operation after installation. For the design rationale, hook internals, and install steps, see [README.md](README.md). Unlike the other frameworks, the harness mostly works on you *indirectly* — it constrains the agent mechanically, and what you experience is its side effects.

## First-time checks (once, right after install)

1. **Restart the session** — hook registration loads at startup.
2. Run `/hooks` and confirm the four harness hooks are listed (`stop-verify` stays inert until you configure it).
3. Smoke test: have the agent make a trivial file edit and end its turn without a completion report — the stop should bounce exactly once with the gate instruction.

## What you'll notice in daily use

| You see | What it is |
|---|---|
| Completion reports end with `[finish-gate: pass]` | The marker contract: the finish gate (lift's `finish-gate` / solo's §P3) passed. |
| Turns end with a one-line reason + `[finish-gate: n/a]` | The turn wasn't a completion claim (blocked, awaiting your input, non-coding turn). |
| A turn "bounces" instead of ending after edits | The Stop hook blocked a stop that modified files but carried no marker after the last edit. The agent gets the gate instruction fed back; worst case is two bounces, never a loop. |
| A one-line acceptance nudge after every subagent result | The PostToolUse hook reminding the lead to run `accept-work` before integrating (read-only scouts get waved through). |
| `.claude/state/` contents appear in context at session start | The SessionStart hook injecting your state files — newest file inlined (60-line/4KB cap). A **stale warning** means the newest file is >60 min old: it may predate recent work, so the agent should re-verify before trusting it. |
| A stop blocked with check-command output | Strict verify (if you enabled it): the project's real check command failed after edits; completion stays blocked until it passes. |

## Strict verify — turning the truth-check on

The three always-on hooks enforce the *ritual*. Strict verify closes the gap for Gate B ("it actually runs"): a marker can be faked, a failing typecheck cannot. Set your project's real check command in the `env` block of `.claude/settings.json`:

```json
{
  "env": { "PSEUDO_FABLE_HARNESS_VERIFY_CMD": "npm run typecheck && npm test -- --bail" }
}
```

Notes for choosing the command:

- It runs from the project root after edits, with a 300s timeout in the shipped settings; keep it fast enough to run at every finish line (typecheck + a focused test suite beats a full CI run).
- It executes with your shell privileges (`sh -c` / `Invoke-Expression`) — review it like any build script.
- On failure the agent sees the last 1500 characters of output and must fix, never work around, the check.

## The kill switch

`PSEUDO_FABLE_HARNESS_DISABLE` silences hooks at runtime without touching settings.json — a comma-separated list of `stop`, `accept`, `session`, `verify`, or `all`:

```
PSEUDO_FABLE_HARNESS_DISABLE=accept,verify   # e.g. mute the nudge and strict verify
PSEUDO_FABLE_HARNESS_DISABLE=all             # everything off (e.g. for a docs-only session)
```

Pre-rename installs (`fable-harness`) use the old `FABLE_HARNESS_*` variable names — check the header comment of your installed hook scripts if the switch seems dead.

## Reading the markers honestly

The hook verifies the ritual, not the truth: a model *can* print `[finish-gate: pass]` without honestly running the gates — printing a false marker is defined as a non-negotiable violation, and that written prohibition is the actual backstop. So treat the marker as "the gate claims to have run", and keep spot-checking the evidence tables the way you would without the harness. Strict verify is the mechanical half of the answer.

## When it gets in the way

- **The stop bounces on a turn that genuinely wasn't a completion** → the agent should end such turns with a reason + `[finish-gate: n/a]`; remind it once — the contract is in the CLAUDE.md addendum.
- **Edits made via shell commands (`sed`, `git apply`, generated scripts) aren't detected** → known limit: the gate only sees the file tools. If your sessions routinely edit via shell, extend the pattern in the hook script (at the cost of noise) — or accept the gap.
- **The acceptance nudge grates** (fires for every subagent, scouts included) → delete the PostToolUse block from settings, or `PSEUDO_FABLE_HARNESS_DISABLE=accept`.
- **Hooks don't fire at all** → restart the session, then `/hooks`. On Windows, the default bash settings need Git Bash; without it, switch to `settings.hooks.powershell.json`. The store's `agent-framework-doctor` skill checks the wiring.
- **A hook errors** → by design it fails open; the session proceeds. Check the script only if it happens repeatedly.

## Tuning

The block/nudge messages live inside the hook scripts — tune their wording the way you tune CLAUDE.md rules, keep the `.sh`/`.ps1` twins in step, and keep the `.ps1` files ASCII-only (Windows PowerShell 5.1 reads BOM-less scripts as ANSI; non-ASCII would mojibake on non-English Windows). Family rule applies here too: if a guardrail never changes behavior, delete it.
