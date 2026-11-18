---
description: Full product kickoff — chains opportunity assessment, PRD, and memory initialization in one guided session
argument-hint: "<product idea or problem space>"
---

# /kickoff -- New Product Kickoff

The full upstream PM workflow in one command. Chains discovery → requirements → memory initialization. Use this when starting a new product or greenfield opportunity.

## Invocation

```
/kickoff AI-powered meeting summarizer for async remote teams
/kickoff [attach a brief, strategy memo, or customer research]
/kickoff We want to enter the developer productivity space — where's the opportunity?
```

## Workflow

This command chains three skills in sequence. Each step confirms with you before writing.

### Step 1 — Discover (`research_opportunity`)

Run a full Opportunity Assessment. All six researcher agents run in parallel:
`@market-researcher`, `@customer-researcher`, `@competitor-researcher`, `@business-researcher`, `@technical-researcher`, `@risk-researcher`

Output: `thoughts/shared/research/YYYY-MM-DD-oa-{slug}.md`

Pause and confirm: "OA complete. Proceed to requirements?"

### Step 2 — Define (`research_requirements`)

Produce a full PRD from the OA. Covers personas, phased roadmap, functional requirements, and success metrics.

Output: `thoughts/shared/requirements/YYYY-MM-DD-prd-{slug}.md`

Pause and confirm: "PRD complete. Initialize product memory?"

### Step 3 — Initialize Memory (`update_memory` → Initialize)

Create `thoughts/shared/memory/` with the three files:
- `decisions.md` — seed with any go/no-go calls from the OA
- `context.md` — seed with product phase, team, and current focus from the PRD
- `taxonomy.md` — seed with key terms extracted from the OA and PRD

Output: `thoughts/shared/memory/decisions.md`, `context.md`, `taxonomy.md`

## After `/kickoff`

- Ready to scope the first feature? → `/spec`
- Want to prototype a concept? → `/prototype`
- Update memory as decisions evolve? → `/memory`

