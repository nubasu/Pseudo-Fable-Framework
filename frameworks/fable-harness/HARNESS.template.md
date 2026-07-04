## Harness — mechanical guardrails

<!-- fable-harness v1.0 (2026-07-04) — hook-based guardrails for the fable frameworks.
     Append this section to the project CLAUDE.md; pair it with the .claude/hooks/ scripts
     and the hooks block merged into .claude/settings.json. The hooks enforce the ritual,
     not the truth — the framework sections above still define WHAT to do. -->

Hooks in this project mechanically reinforce the framework. They are guardrails, not the protocol — and they verify the ritual, not the truth. Printing a marker that is not true is a non-negotiable violation.

- **Finish marker (Stop hook).** When the finish gate passes (skill `finish-gate`, or §P3 in solo setups), end the completion report with the literal line `[finish-gate: pass]`. When a turn ends WITHOUT a completion claim (blocked, awaiting user input, non-coding turn), end with a one-line reason plus `[finish-gate: n/a]`. The hook blocks stops that modified files but carry no marker after the last edit.
- **Subagent returns (PostToolUse hook).** Every subagent result is followed by an acceptance nudge: run `accept-work` (where installed) — verify independently before integrating.
- **Session start (SessionStart hook).** Files under `.claude/state/` are injected into context automatically; boot from them, not from memory.
