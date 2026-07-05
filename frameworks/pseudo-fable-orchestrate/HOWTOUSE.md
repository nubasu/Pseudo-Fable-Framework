# pseudo-fable-orchestrate — How to use

English | [日本語](HOWTOUSE.ja.md)

Day-to-day operation after installation. For the design rationale and install steps, see [README.md](README.md). This guide assumes the lead session (the one whose CLAUDE.md carries the Orchestration section); worker-side behavior comes from pseudo-fable-lift (Claude subagents) or AGENTS.md (Codex).

## What changes once it's installed

The lead now behaves as a tech lead, not a solo implementer:

- **Delegation-first**: implementation goes to workers by default. The lead's own hands touch code only when all four criteria hold (<15 min mechanical, no deep context pull, nobody blocked on it, low-risk & reversible).
- **No brief, no delegation**: before any implementation subagent is spawned, the `delegate` skill produces a 9-field brief (Context / Pointers / Contract / Non-goals / Constraints / Gotchas / Done means / Escalation / Report back).
- **No integration on trust**: every returned result goes through `accept-work` — independent verification, then a verdict — before anything is merged.
- Parallel fan-out is preceded by interface freezing and file isolation; integration (merged build + full tests) is always the lead's own job.

## Your part

| Moment | What you do |
|---|---|
| Giving work | Hand the lead the goal, not the task splits — decomposition and routing are its job. Resolve product-level ambiguity when asked; everything else it decides and records. |
| Watching a brief go out | Briefs are your window into what was actually decided. Skim the Contract and Non-goals; a vague brief now is a bounce later. |
| A worker returns | Expect an accept-work verdict with evidence, not "the subagent says it's done". If the lead merges without verifying, reply "run accept-work first". |
| Repeated bounces | Two bounces on one task force a RECLAIM (rewrite the brief for a fresh worker, or take it back). If the lead attempts bounce #3, stop it — the protocol forbids it. |
| Cost control | Fan-out costs real tokens. The under-15-minutes rule and micro-task batching are the levers; you can also cap parallelism verbally ("max 2 workers"). |

## A typical delegation cycle

1. You: "Implement the notification-preferences feature, spec is in docs/spec.md."
2. Lead decides the design itself (judgment is never delegated), splits along interfaces, freezes shared types.
3. `delegate` produces one brief per task; the pre-send check (§3c) verifies every path and command in it against the repo before sending.
4. Workers run (Claude subagents in the background, or `codex exec` for Codex).
5. Each return → `accept-work`: the lead re-runs the Done-means commands itself or spawns a fresh verifier, reads the full diff, then rules ACCEPT / PATCH / BOUNCE / RECLAIM.
6. After all returns: the lead runs the merged build + full test suite itself, updates the ledger, reports with evidence.

## The verdicts you'll see

| Verdict | Meaning | What follows |
|---|---|---|
| ACCEPT | Every contract item independently verified | Logged to ledger, integrated |
| PATCH | Substance correct, trivial defects | Lead fixes inline (or sends a ~5-line patch-brief if it would pull it deep); noted in ledger |
| BOUNCE | Contract unmet — evidence-based feedback, same worker | Max 2 per task |
| RECLAIM | After 2 bounces or fundamental misunderstanding | Rewritten brief to a fresh worker, or the lead takes it back |

Every BOUNCE/RECLAIM triggers a brief post-mortem: "which missing sentence in my brief would have prevented this?" — this is the flywheel that improves delegation over time; expect briefs to get noticeably better after a few cycles.

## Steering phrases

- "Delegate this; don't implement it yourself." / "This session: no implementation at all." (a user instruction overrides Delegation-first's judgment clause)
- "Batch these small fixes into one brief."
- "Get a second opinion from a different model family on this diff." (cross-model adversarial review)
- "Show me the ledger." — current state of all delegations.

## Codex / external agents

- `AGENTS.md` must exist at the repo root (the bundled minimal template, or the pseudo-fable-team superset) — Codex never reads CLAUDE.md.
- Briefs to Codex must be fully self-contained; invoke non-interactively (`codex exec "<brief>"` — verify the exact form with your local `codex --help`).
- Codex runs in its own environment: acceptance always re-verifies in the lead's environment.

## Artifacts to watch

- `.claude/state/delegations.md` (or the ledger section of the long-task-state file when pseudo-fable-lift is installed) — columns: id / executor / brief / status / verdict / evidence. This is your progress dashboard across tasks and sessions.
- The briefs themselves — decisions are recorded there, not in evaporating chat.

## When it misbehaves

- **The lead implements everything itself** → remind it: "Delegation-first — brief it out." If the reverse happens (it delegates trivia), invoke the under-15-minutes rule.
- **Merging on the worker's word** → "accept-work, then integrate." If this recurs, add `pseudo-fable-harness` — its PostToolUse hook nudges acceptance after every subagent return.
- **Workers keep failing the same way** → the briefs are the suspect, not the workers. Ask for the post-mortem sentence and where it was added; recurring project traps belong in the standing Gotchas.
- **Parallel workers collide** → interfaces weren't frozen or files weren't disjoint; ask the lead to re-run `delegate` §4 before the next fan-out (worktree isolation if overlap is unavoidable).
