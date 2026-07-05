# pseudo-fable-team — How to use

English | [日本語](HOWTOUSE.ja.md)

Day-to-day operation after installation. For the design rationale and install steps, see [README.md](README.md). One AGENTS.md at the repo root governs every agent — lead and workers alike; each reads §1–§2, its own role section, and the shared formats.

## What changes once it's installed

Every agent that reads the file first resolves its **role**, then follows only that role's discipline:

| Signal | Role |
|---|---|
| The prompt contains a `# TASK <id>` brief | Worker (§4) |
| Raw requirements from the user + can spawn or instruct other agents | PL (§3) |
| Neither (solo session) | Worker discipline, with your request as the Contract and you as the PL |
| An explicit `Role:` line in the instructions | Overrides everything above |

Standard assignment: Opus-class session = PL, Sonnet / Codex = Workers — but the functional rules above decide edge cases, so the same file works unmodified in every seat.

## Running the PL session (your usual seat)

Talk to an Opus-class session as you would to a tech lead:

- Give it the goal; it turns the request into a numbered, testable contract, asks at most one batched round of load-bearing questions (each with a recommended default), and records the rest as assumptions.
- It delegates along interfaces with a full §5 brief per task — no brief, no delegation — and freezes shared interfaces before any parallel fan-out.
- On every return it verifies independently before integrating: ACCEPT / PATCH / BOUNCE (max 2, evidence-based) / RECLAIM. Integration (merged build + full tests) is its own job, never delegated.
- It keeps `.claude/state/delegations.md` as the ledger — ask "show me the ledger" for the cross-task dashboard.

## Running a worker

- **Claude subagents** get the brief as their prompt and read AGENTS.md through the `@AGENTS.md` bridge in CLAUDE.md (or natively). No extra setup per worker.
- **Codex**: run non-interactively (`codex exec "<brief>"` — check your local CLI form). The brief plus AGENTS.md carry everything; nothing else is shared.
- To force a role in an odd setup, put a `Role: worker` (or `Role: PL`) line in the instructions.

## The two formats you'll read

All PL↔worker traffic uses the §5 shapes, so you can audit any exchange at a glance:

- **Brief**: `# TASK <id>` + Context / Pointers / Contract / Non-goals / Constraints / Gotchas / Done means / Escalation / Report back.
- **Report**: `RESULT: DONE | BLOCKED | DEVIATED` + Changes / Evidence / Deviations & discoveries / Not done — capped at 40 lines. `DONE` is only legitimate when every contract item has pasted evidence; an honest `BLOCKED` with a stuck-report is a deliverable, not a failure.

## Steering phrases

- "Show me the ledger." — delegation dashboard.
- "That report has no evidence — bounce it." — the worker must paste actual command output.
- "Freeze the interfaces before you fan out."
- "Role: worker" (in a prompt) — force worker discipline for a one-off session.

## When it misbehaves

- **An agent acts in the wrong role** → check what its prompt actually contained; the dispatch is mechanical (`# TASK` ⇒ worker). Add an explicit `Role:` line when in doubt.
- **Claude agents don't seem to read the file** → verify the `@AGENTS.md` line sits near the top of CLAUDE.md, or that your Claude Code version reads AGENTS.md natively (test it — don't assume).
- **AGENTS.md and CLAUDE.md disagree on commands** → a missed Project-specifics sync; CLAUDE.md is the source of truth, copy it over.
- **You keep wanting deeper protocols** (hypothesis journals, phase gates, retro rituals) → this file is the distilled constant. Graduate to the full family: lift + orchestrate (+ blueprint) replace it for depth, or install their skills alongside — the sheet then acts as the constant while the skills provide the deep protocols.
