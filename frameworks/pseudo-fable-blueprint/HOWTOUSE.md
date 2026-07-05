# pseudo-fable-blueprint — How to use

English | [日本語](HOWTOUSE.ja.md)

Day-to-day operation after installation. For the design rationale and install steps, see [README.md](README.md). Blueprint runs in the planning session — the one that receives a spec and must turn it into requirements, a design, and tickets.

## What changes once it's installed

Handed anything spec-sized (a PRD, a feature request bigger than a bugfix), the agent stops designing from the raw text and instead walks a gated pipeline:

```
INTAKE (spec-interrogate) → DESIGN (design-doc) → PLAN & TICKETS (ticketize) → HANDOFF
```

No phase starts until the previous phase's exit gate closes, and everything lands in files, not chat:

```
docs/plan/<feature-slug>/
├── 01-requirements.md   ← testable register, questions, assumptions, out-of-scope
├── 02-design.md         ← recon, alternatives, chosen design, failure modes, ADRs, pre-mortem
└── 03-tickets.md        ← milestones, dependency graph, tickets, traceability matrix
```

## Your part, phase by phase

| Phase | What the agent does | What you do |
|---|---|---|
| INTAKE | Interrogates the spec: ambiguities, contradictions, gaps, unstated non-functionals. Produces the requirements register. | Answer **one batched round of questions** (aim ≤5). Each arrives with why-it-matters and a recommended default — replying "yes to all defaults" is a legitimate answer. Everything not asked becomes a recorded assumption. |
| DESIGN | Recon of the actual codebase, 2–3 materially different designs, trade-off scoring, failure-mode analysis, pinned interfaces, ADRs, pre-mortem. | Review the chosen design and the *rejected* alternatives (that's where re-litigation is prevented). Veto here — after ticketize, changes ripple. |
| PLAN & TICKETS | Walking-skeleton-first milestones, dependency graph, sized tickets with testable acceptance criteria, forgotten-workstreams sweep, traceability matrix. | Check the MVP line and the milestone order. Confirm or refuse external-tracker filing — `gh issue create` is externally visible, so the agent must ask first. |
| HANDOFF | Tickets feed pseudo-fable-orchestrate briefs 1:1 (field mapping in `ticketize` §6), or direct execution under pseudo-fable-lift. | Decide who executes: delegate the tickets, or work them down yourself. |

## A typical run

1. You: "Here's the spec for the billing revamp: docs/spec-billing.md. Plan it."
2. Agent reads the whole spec, recons the repo, produces `01-requirements.md` with R-ids (`R1 | p95 < 300 ms at 100 rps | spec §2 | non-functional | must`) — vague words like "fast" get quantified, with a proposed number if the spec has none.
3. One batched question round. You answer (or "defaults are fine").
4. Gate closes → `02-design.md`: alternatives A/B/C scored against R-ids, ADRs with rejected options, failure modes, frozen interfaces.
5. You approve the design → `03-tickets.md`: M1 is a walking skeleton (thinnest end-to-end slice), tickets carry Pointers / Acceptance / Non-goals / Depends-on, every R-id traces to a T-id.
6. Handoff — with orchestrate installed, each ticket becomes a brief nearly verbatim.

## Mid-flight spec changes

Hand the delta to the agent and expect it to re-run `spec-interrogate` **on the delta**, then propagate through the traceability matrix (which R-ids changed → which design elements → which tickets). Patching tickets directly from a changed spec is the anti-pattern the pipeline exists to prevent — call it out if you see it.

## Steering phrases

- "Run spec-interrogate on this before anything else." (if the agent starts designing from the raw spec)
- "Defaults are fine." (fastest way through the question round)
- "Show me the rejected alternatives for that decision."
- "Where does R7 land in the tickets?" (traceability check)
- "The spec changed: here's the delta." (triggers delta re-interrogation)

## Artifacts to watch

- `docs/plan/<slug>/01-requirements.md` — the register plus the assumption log (`A<id> | assumption | impact if wrong | how we would notice`). Assumptions are your risk list; skim them even if you skip everything else.
- `docs/plan/<slug>/02-design.md` — ADRs; the pinned interfaces here become orchestrate's frozen interfaces later.
- `docs/plan/<slug>/03-tickets.md` — the traceability matrix at the bottom is the "nothing dropped" proof: an R with no T is a dropped requirement.

## When it misbehaves

- **Designs from the raw spec** → "spec-interrogate first". The register is the design's input; there is no shortcut.
- **Asks you a dozen questions one by one** → point at the triage rule: one batched round, ≤5, each with a recommended default; the rest become recorded assumptions.
- **Requirements stay vague ("robust", "user-friendly")** → ask for the pass/fail form. A proposed number that's wrong gets corrected; "fast" never does.
- **Tickets skip tests / migration / rollout** → ask for the forgotten-workstreams sweep — every item must be ticketed, folded, or excluded with a written reason. Silence is not allowed.
