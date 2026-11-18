---
description: Run a full opportunity assessment — parallel market, customer, competitor, business, technical, and risk research synthesized into an OA
argument-hint: "<product idea or problem space>"
---

# /discover -- Opportunity Assessment

Kick off product discovery with a full Opportunity Assessment. Six research agents run in parallel across the market, customer, competitive, business, technical, and risk dimensions. Results are synthesized into a single OA written to `thoughts/shared/research/`.

## Invocation

```
/discover AI-powered meeting summarizer for remote teams
/discover We're seeing high churn in onboarding — what's the opportunity?
/discover [attach a brief, strategy doc, or market report]
```

## Workflow

Invoke the `research_opportunity` skill. It will:

1. Ask one clarifying question to confirm scope if the input is ambiguous
2. Spin up all six researcher agents in parallel:
   - `@market-researcher` — TAM/SAM/SOM, trends, timing signals
   - `@customer-researcher` — Pain points, unmet needs, demand signals
   - `@competitor-researcher` — Competitive landscape, white space, positioning
   - `@business-researcher` — Revenue models, strategic fit, ROI signals
   - `@technical-researcher` — Platform capabilities, build vs. buy
   - `@risk-researcher` — Market, technical, organizational, regulatory risks
3. Synthesize findings into an Opportunity Assessment using `thoughts/global/shared/oa-template.md`
4. Write the OA to `thoughts/shared/research/YYYY-MM-DD-oa-{slug}.md`

## After `/discover`

- Ready to define requirements? → `/define`
- Want to jump straight to a spec? → `/spec`
- Need to capture a key decision from the research? → `/memory`

