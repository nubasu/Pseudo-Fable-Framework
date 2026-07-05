# pseudo-fable-incident — How to use

English | [日本語](HOWTOUSE.ja.md)

Day-to-day operation after installation. For the design rationale and install steps, see [README.md](README.md). This module changes what happens in exactly one situation: production is impacted **now** (users, data, money, or security — actual or imminent). Everything else stays a normal bug and goes through the normal loop.

## What changes once it's installed

When production impact is on the table, the agent switches objective functions — **impact first, cause second**:

- opens `.claude/state/incident-<date>-<slug>.md` and timestamps every action and observation from minute one;
- triages in ~5 minutes (blast radius, "what changed?"), then **mitigates before diagnosing** — rollback / flag off / failover / rate-limit, whichever reversible lever is fastest;
- captures evidence (logs, metric snapshots, process state) **before** any state-destroying action like a restart or cache clear;
- makes one change at a time, observes, records — no stacking;
- treats "resolved" as observed-healthy: symptom demonstrably gone AND metrics holding through a monitoring window (default ~30–60 min, longer if detection was slow);
- closes only when the postmortem exists.

## Declaring an incident

The entry check is binary, and you are usually the one who trips it:

- "**Production is down**" / "users can't check out" / "we're leaking data" → incident mode.
- "This bug is bad but nothing is burning" → say so; the agent should route it through the normal loop (`root-cause-debug` where installed). Don't let ordinary bugs get incident theatrics.

## Your part

| Moment | What you do |
|---|---|
| Declaring | State the impact as concretely as you can (who's affected, since when). "What changed?" is the highest-yield triage question — answer it if you know (deploys, config, dependency bumps). |
| Production actions | If the agent lacks access, it **directs rather than executes**: it proposes the exact command with its reversibility stated, and you run or approve it. Destructive or irreversible actions always need your explicit approval. |
| During mitigation | Expect 3-line status updates (impact / suspected trigger / next action) on every state change — not on a timer. One change at a time; if you see stacking, stop it. |
| "It looks better" | Not resolved. Hold the agent to the monitoring window and the before/after observation. Mitigated ≠ resolved — the incident continues at lower urgency. |
| After resolution | Expect the `postmortem` skill to fire. For a real incident it's mandatory; a false alarm gets a 3-line note instead. |

## The live protocol at a glance

1. **Entry check** — production impacted? No → normal bug. Yes → incident file + timeline.
2. **TRIAGE (~5 min)** — blast radius; growing or stable; "what changed?" sweep.
3. **MITIGATE** — fastest reversible lever; evidence before destruction; verify impact actually dropped (numbers, not vibes).
4. **DIAGNOSE** — root-cause-debug discipline under production constraints (read-only evidence preferred; production experiments reversible or user-approved).
5. **FIX** — at the cause, through the normal finish-gate; grep for the sibling bug before closing.
6. **VERIFY & MONITOR** — symptom gone (before/after shown); metrics hold through the window; temporary mitigations unwound deliberately.
7. **CLOSE** — timeline complete, final status, handoff to postmortem.

## The postmortem (after the fire)

Blameless: "why did the system allow this?", never "who screwed up" — an agent error is a missing check. Expect:

- the three durations, each a separate improvement target: time-to-detect / time-to-mitigate / time-to-resolve;
- root cause as a mechanism ("retries lacked backoff, pool exhausted" — not "high load"), plus contributing factors and **what was merely lucky** (luck is a risk that didn't fire — priced as a finding);
- action items through three lenses — detect faster / prevent the class / mitigate faster — each with a destination and priority;
- the write-up at `docs/postmortems/<date>-<slug>.md`, under a page. With retro installed, lessons then route through its placement table (≤2 rules).

## Steering phrases

- "This is an incident — production impact." (entry)
- "Mitigate first; root-cause later." (when it starts diagnosing while users bleed)
- "Capture the logs before you restart anything."
- "What does the timeline say — did we already try X?"
- "Start the monitoring window; don't close yet."

## Artifacts to watch

- `.claude/state/incident-<date>-<slug>.md` — the live timeline; also your answer to "did we already try X?".
- `docs/postmortems/<date>-<slug>.md` — durable, human-visible (deliberately not under `.claude/state/`).

## When it misbehaves

- **Root-causing while users bleed** → "mitigate first". The only exception: mitigation genuinely requires the diagnosis — then the agent must say so explicitly and timebox diagnosis in ~15-min sprints.
- **Restarts/clears without capturing state** → stop it; evidence before destruction is non-negotiable #2.
- **Multiple simultaneous changes** → one lever at a time; simultaneous changes make it impossible to know what helped.
- **Closing on "looks better"** → hold the window. And no postmortem = the incident isn't closed.
- **Incident mode for a non-incident** → the entry check failed; send it back to the normal loop.
