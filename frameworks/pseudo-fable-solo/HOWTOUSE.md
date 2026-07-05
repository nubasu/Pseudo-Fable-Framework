# pseudo-fable-solo — How to use

English | [日本語](HOWTOUSE.ja.md)

Day-to-day operation after installation. For the design rationale and install steps, see [README.md](README.md). Solo is one CLAUDE.md and nothing else — no skills directory, so there is nothing to invoke and nothing that can fail to trigger; the protocols are resident sections (§P1–P5).

## What changes once it's installed

The session behaves like a disciplined solo engineer who assumes nobody reviews after it:

- every task is restated as a **numbered contract** first, and the final report maps each item to evidence;
- non-trivial builds get a §P1 deep plan (contract, recon, 2–3 alternatives, milestones, pre-mortem) before code;
- a failed fix triggers §P2 root-cause debugging with a hypothesis journal, never patch-stacking;
- **no "done" without §P3** — the finish gate, including a fresh-eyes adversarial re-read of the full diff (Gate B runs first precisely to put distance between writing and re-reading; that distance substitutes for a second reviewer);
- long tasks live in a §P4 state file; tests follow §P5 (fail-first, minimal mocks);
- extra Opus-specific counterweights: hold multiple candidates before choosing, evidence outranks eloquence, generate → critique → revise, finish at full strength.

## Your part

| Moment | What you do |
|---|---|
| Giving a task | The first reply restates your request as a contract — correct it there. Ambiguity you don't resolve becomes a recorded conventional default, not a question. |
| Big changes | Expect §P1 output (alternatives included) before any code. Challenge the choice at this stage. |
| A "done" report | Look for the coverage table and pasted outputs. Missing → reply "run §P3". |
| A stubborn bug | Expect the §P2 journal (`H1: <cause> — test: <experiment> → ✗/✓`). ~45–60 min without progress legitimately ends in a stuck-report — answer its sharpest question rather than demanding more grinding. |
| Multi-session work | `.claude/state/<task-slug>.md` should exist (§P4). After a compaction, the file wins over memory — remind the agent to re-read it if it acts from recollection. |

## Section trigger cheat sheet

| Situation | Section |
|---|---|
| ≥3 files, a design decision, or >30 min estimated | §P1 before coding |
| A fix attempt failed, or behavior seems "weird" | §P2 |
| About to say a coding task is complete | §P3 — no exceptions |
| Multi-hour/multi-session task, or right after compaction | §P4 |
| Writing or modifying tests | §P5 |

You can invoke any of them by name: "§P1 first", "run §P3 and show the gates", "start a §P4 state file".

## Boundaries — when solo is the wrong tool

- Solo is tuned for **one Opus-class session doing everything itself**. The moment you start spawning implementation subagents regularly, migrate to pseudo-fable-lift + pseudo-fable-orchestrate (the exclusivity rule: solo and lift never coexist in one CLAUDE.md).
- ~3K resident tokens is the price of zero trigger risk. If context pressure hurts on your project, lift's two-layer split is the lighter alternative.

## Artifacts to watch

- `.claude/state/<task-slug>.md` — §P4 state file (gitignore `.claude/state/`).
- Reports — contract coverage plus evidence; failures verbatim, "not checked" stated as such.

## When it misbehaves

- **"Done" without the gates** → "§P3" as a reply. If it recurs, add `pseudo-fable-harness` — its Stop hook blocks completion without a finish-gate marker (solo's §P3 satisfies it).
- **First-idea lock-in on a design** → ask for the §P1 alternatives explicitly; "hold multiple candidates" is a resident rule, cite it.
- **Quality sags late in a long task** → "finish at full strength" is §"How to spend intelligence" #5 — asking for a §P3 re-run on the last item usually snaps it back.
- **Post-compaction confusion** → "read the §P4 file first; the file wins over memory."
