# pseudo-fable-lift — How to use

English | [日本語](HOWTOUSE.ja.md)

Day-to-day operation after installation. For the design rationale and install steps, see [README.md](README.md).

## What changes once it's installed

Without you invoking anything, the agent in this project now:

- restates every task as a **numbered contract** in its first message, and reports against it at the end;
- refuses to say "done" until `finish-gate` passes — completion reports carry commands and pasted output, not assurances;
- switches to systematic debugging (`root-cause-debug`) after one failed fix, instead of stacking patches;
- keeps a state file for long tasks (`long-task-state`) so compaction and session breaks don't erase progress;
- proves new tests can fail (`test-protocol`) instead of shipping green-but-empty suites.

The resident core steers constantly; the five skills load only when their trigger fires.

## Your part

| Moment | What you do |
|---|---|
| Giving a task | State requirements concretely. The agent's first message restates them as a numbered contract — **correct it there**; it's the cheapest moment to fix scope. |
| Mid-task | Expect a `deep-plan` (contract / alternatives / milestones / pre-mortem) before any ≥3-file or design-heavy change. Push back on the chosen alternative here, not after the diff exists. |
| A "done" report | Look for the contract-coverage table and pasted command output. No evidence → reply "run finish-gate". |
| A dragging bug | Expect a hypothesis journal (`H1: … → ✗/✓`). If the agent retries without hypotheses, reply "use root-cause-debug". |
| Long / multi-session work | Expect `.claude/state/<task-slug>.md` to exist and stay current. After a compaction, the agent should re-read it before acting — remind it if not. |

## A typical session

1. You: "Add CSV export to the report page. Must handle empty datasets."
2. Agent: numbered contract (explicit items + implicit ones like backward compatibility) — you correct or confirm.
3. Task crosses the deep-plan trigger → contract, recon with `path:line`, 2–3 alternatives, milestones, pre-mortem. You veto or approve the approach.
4. Implementation in small steps, each confirmed (typecheck / focused test) before the next.
5. Before "done": finish-gate — coverage table, real run of the new path, adversarial diff re-read, blast-radius grep.
6. Report: outcome first, each contract item → change → evidence, failures verbatim.

## Trigger cheat sheet

| Skill | Fires when | You'll see |
|---|---|---|
| `deep-plan` | ≥3 files, a design decision, or >30 min estimated | Contract, alternatives compared, milestones, pre-mortem — before any code |
| `root-cause-debug` | A fix attempt failed, or behavior seems "weird" | Clean-state reset, reproduction, hypothesis journal, before/after proof |
| `finish-gate` | Right before any completion claim (mandatory) | Gates A–E; failing any → status stays "in progress" |
| `long-task-state` | Multi-hour/multi-session work; right after compaction | `.claude/state/<task-slug>.md` created and updated |
| `test-protocol` | Writing or modifying tests | Fail-first proof, minimal mocks, boundary & error-path coverage |

## Phrases that work

The triggers are mechanical, but you can always fire a protocol explicitly:

- "Run deep-plan before touching anything."
- "Use root-cause-debug on this."
- "Run the finish-gate and show me the evidence."
- "Write the plan into a long-task-state file — this will span sessions."
- "Apply test-protocol to these tests; I don't trust them."

A stuck-report ("ruled out / still possible / sharpest next question") is a legitimate deliverable — when you get one, answer the question or grant the missing access instead of asking the agent to push blindly on.

## Artifacts to watch

- `.claude/state/<task-slug>.md` — the long-task state file: contract, decisions, learned facts, failed approaches, next action. Add `.claude/state/` to `.gitignore` (see the root README's finishing steps).
- Reports themselves — the evidence tables are your audit trail; numbers and paths in them are copy-pasted from observation, never reconstructed.

## When it misbehaves

- **"Done" without evidence** → "finish-gate" as a one-word reply is usually enough. If it keeps happening, install `pseudo-fable-harness` — its Stop hook makes the gate mechanical.
- **Skills never fire** → check "list the available skills" shows the five; if not, they're misplaced (must be `<project-root>/.claude/skills/<name>/SKILL.md`). The store's `agent-framework-doctor` skill diagnoses this.
- **Rules get ignored under a heavy CLAUDE.md** → especially on Sonnet, trim Project specifics to commands and entry points (see "Per-model tuning" in the README).
- **Post-compaction drift** → say "re-read the state file first". If this recurs, add `pseudo-fable-retro` — its session-bootstrap ritual makes recovery a protocol.
