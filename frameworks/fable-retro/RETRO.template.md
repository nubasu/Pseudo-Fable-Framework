## Continuity — session rhythm and rule growth

<!-- fable-retro v1.0 (2026-07-04) — cross-session continuity and the rule-growing
     flywheel. Append this section to the project CLAUDE.md. Composes with fable-lift
     (long-task-state), fable-orchestrate (delegations ledger), and fable-blueprint
     (tickets); degrades gracefully when any of those are absent. -->

Chat evaporates between sessions; lessons evaporate between tasks. Two skills stop the leaks.

### Hard triggers

| Situation | Invoke |
|---|---|
| Session starts on work begun earlier | `session-bootstrap` OPEN — boot from files, never from memory |
| Session is ending, the user says done for now, or context is nearly full | `session-bootstrap` CLOSE — checkpoint so the next session boots in minutes |
| A milestone or task completed; a bounce, reclaim, or failed-fix spiral happened | `retro` — harvest ≤2 rules from what actually went wrong |
| ~Weekly, or every ~10 tasks | `retro` §4 — prune rules that never fire |

House rule: **rules are grown from recurred failures and pruned when they stop firing.** A rule that never changes behavior is pure context cost.
