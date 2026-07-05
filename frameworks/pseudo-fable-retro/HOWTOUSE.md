# pseudo-fable-retro — How to use

English | [日本語](HOWTOUSE.ja.md)

Day-to-day operation after installation. For the design rationale and install steps, see [README.md](README.md). Retro adds two rituals to any configuration: a session boot/shutdown sequence (`session-bootstrap`) and a lesson-harvesting loop (`retro`).

## What changes once it's installed

- A session that continues earlier work **boots from files, not memory**: state file → delegations ledger → tickets → `git log`/`git status`, then a drift check, then a one-message restatement of where things stand before any work happens.
- A session that's ending **checkpoints deliberately**: state files updated, the working tree parked with a readable message, a 3-line handoff (done today / next action / open risks).
- After milestones — and after anything that bounced, reverted, or dragged — the agent harvests **at most 2 rules** from what actually went wrong, and routes each to the narrowest effective home.
- Periodically, rules that never fire get **pruned**. The house rule: grown from recurred failures, deleted when they stop firing.

## Your part

| Moment | What you do |
|---|---|
| Starting a continuing session | Say "continue the X work" — then let the OPEN sequence run. Expect the restatement ("task stands at X/Y, next action is Z, this drifted") **before** any code is touched; correct it there. |
| Ending a session | Say "done for now" or "close the session". Expect the state-file update, a deliberately parked working tree (commit/stash with a readable message — never silent dirty state), and the 3-line handoff. |
| After a milestone or a messy episode | Say "run retro" if it doesn't fire on its own. Expect ≤2 proposed rules, each with a trigger, an action, and the failure it prevents. |
| A rule targets the store templates | The placement table says generic lessons are **proposed to you**, never written into the shared store silently. Approve, redirect, or decline. |
| ~Weekly / every ~10 tasks | Ask for the prune pass: "rule inventory — what never fired?" Deleting is as valuable as adding. |

## The OPEN sequence (what you should see)

1. Reads, in order and skipping what doesn't exist: `.claude/state/<task-slug>.md` → `.claude/state/delegations.md` → `docs/plan/<slug>/03-tickets.md` → `git log --oneline -15` + `git status`.
2. Verifies drift: top ~3 load-bearing facts re-checked against the code; unexplained dirty `git status` investigated; in-flight delegations reconciled.
3. Restates in one short message, then continues from `Next action` — **without re-planning what is already planned** (re-planning finished plans is how sessions lose their first hour).

A compacted context is a new session in disguise: OPEN applies after compaction too.

## The retro loop (what a good one looks like)

1. **Harvest** — failures (bounces, reverts, gate findings), drag (≥2 attempts, rediscovered traps), surprises (unpriced risk).
2. **The missing sentence** — for each: "which single sentence, in which document, would have prevented this?" Can't phrase it → the failure isn't understood yet.
3. **Route** via the placement table — repo trap → Gotchas / worker trap → standing brief Gotchas / process failure → project CLAUDE.md with a trigger / generic → proposed to you for the store / preference → agent memory / one-off → **nowhere** (not every lesson deserves a rule).
4. **Constraint** — max 2 rules per retro; every rule ships with trigger + action + the failure it prevents.

## Steering phrases

- "Where were we?" — triggers a boot from files when the agent starts guessing from memory.
- "Close the session." — full CLOSE, including the parked tree and handoff.
- "Run a micro-retro on that bounce." — ≤2 min, ≤2 rules.
- "Rule inventory." — the §4 prune pass.

## Artifacts to watch

- `.claude/state/*.md` — what OPEN boots from and CLOSE updates; the `Next action` line is the single most valuable thing a session leaves behind.
- Project CLAUDE.md / AGENTS.md Gotchas — where harvested rules land; watch it for inflation (that's what the prune pass is for).

## When it misbehaves

- **Session starts by re-reading the whole codebase** → "boot from the state file — Learned facts exist to make recon cheap."
- **Session ends with the plan only in chat** → "chat is not a handoff — update the state file and park the tree."
- **Retro adds rules from ideas, not failures** → cite the house rule; every rule must name the failure it prevents.
- **CLAUDE.md keeps growing** → schedule the prune. A retro that only ever adds is broken by its own definition (§5).
