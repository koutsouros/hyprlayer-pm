# research_opportunity

Synthesize a market opportunity from parallel research across six dimensions — market sizing, competitive landscape, customer needs, business viability, technology landscape, and risk.

---

## When to use it

Run `research_opportunity` when you need a structured, evidence-based view of whether a problem space is worth solving and for whom. Good triggers:

- Entering a new problem space with no prior research
- Validating a product idea before committing to a PRD
- Preparing context for a leadership or investment conversation
- Grounding a PRD in current market reality before writing requirements

Not the right command if you already have a validated OA and are ready to write requirements — use `research_requirements` for that.

---

## What you'll be asked

The command opens with a single prompt:

> "I'm ready to research the market opportunity. Please provide your initiative brief — describe the problem space, target market, and any known context and I'll analyze it thoroughly by exploring relevant sources."

Then it asks which of six research tasks to run:

```
1. Market Research       — market sizing, industry trends, timing signals, adjacent markets
2. Competitive Analysis  — competitive landscape, feature matrices, positioning, white space
3. Customer Needs        — pain points, unmet needs, demand signals
4. Business Viability    — revenue potential, cost structure, ROI signals
5. Technical Landscape   — technology trends, platform capabilities, build vs. buy
6. Risk Analysis         — market, technical, and organizational risks
```

Reply with numbers (`1, 3, 5`) or `all`. Only the selected agents run.

---

## What happens next

After you provide the brief and select research tasks:

1. Reads any files or prior research you mention before delegating — full context first.
2. Runs `@thoughts-locator` to discover what relevant documents already exist in the thoughts directory.
3. Runs all selected researcher agents **in parallel** for maximum speed.
4. Waits for all agents to complete before synthesizing — never writes a partial document.
5. Writes individual sub-agent files for each research area.
6. Synthesizes all findings into a single Opportunity Assessment document.
7. Presents a summary with key file references and asks for follow-up questions.
8. Appends follow-up research to the same document — never creates a new file for the same topic.

---

## What it produces

**Sub-agent output files** (one per selected research task):
```
thoughts/shared/research/YYYY-MM-DD-market-researcher-{slug}.md
thoughts/shared/research/YYYY-MM-DD-competitor-researcher-{slug}.md
thoughts/shared/research/YYYY-MM-DD-customer-researcher-{slug}.md
thoughts/shared/research/YYYY-MM-DD-business-researcher-{slug}.md
thoughts/shared/research/YYYY-MM-DD-technical-researcher-{slug}.md
thoughts/shared/research/YYYY-MM-DD-risk-researcher-{slug}.md
```

**Synthesized Opportunity Assessment:**
```
thoughts/shared/research/YYYY-MM-DD-opportunity-{slug}.md
```

The OA follows the standard template structure:

| Section | What it captures |
|---------|-----------------|
| Executive Summary | High-level answer to the opportunity question |
| Problem Statement | Original brief and context |
| Market Research | TAM/SAM/SOM, trends, timing signals |
| Business Viability | Revenue model, cost structure, ROI signals |
| Risk Analysis | Market, technical, organizational risks |
| Customer Needs | Pain points, unmet needs, demand signals |
| Solution Evaluation | Competitive landscape and technology options |
| References | Sub-agent files, web sources, prior thoughts/ context |
| Appendix | Related research, open questions |

**OA frontmatter:**
```yaml
date: 2026-06-10T...
researcher: Greg
topic: "Your research topic"
tags: [research, market-opportunity]
status: complete
last_updated: 2026-06-10
last_updated_by: Greg
```

---

## Research quality standards

Every researcher agent follows strict evidence rules:

- **No fabricated data** — no invented market sizes, revenue projections, or statistics
- **Confidence labeling** — all data points tagged `[HIGH]`, `[MEDIUM]`, or `[LOW]`
- **Assumptions flagged** — anything unverified is labeled `[ASSUMPTION]`
- **Unknowns flagged** — gaps are labeled `[UNKNOWN]`, not guessed at
- **Sources cited** — every claim links to a URL
- **Recency** — data older than 24 months is flagged

The command is a researcher and analyst, not an advocate. It documents what exists, not what should be built.

---

## Researcher agents

| Agent | Research area |
|-------|--------------|
| `@market-researcher` | Market sizing (TAM/SAM/SOM), industry trends, timing signals, adjacent markets |
| `@competitor-researcher` | Competitive landscape, feature matrices, positioning, white space |
| `@customer-researcher` | Pain points, unmet needs, demand signals, segment-level needs |
| `@business-researcher` | Revenue models, cost structure, strategic fit, ROI signals |
| `@technical-researcher` | Technology trends, platform capabilities, build vs. buy analysis |
| `@risk-researcher` | Market, technical, organizational, regulatory, and financial risks |

---

## After the OA is written

The OA becomes the primary input to `research_requirements`. It defines the problem space, target user, and business rationale before any solution work begins.

When you run `research_requirements`, you'll be asked whether an OA exists — pointing it at the OA significantly improves the quality of the PRD's strategic context, personas, and success metrics.

---

## Connected commands

| Command | Relationship |
|---------|-------------|
| `research_requirements` | Consumes the OA to produce the PRD |
| `/create_spec` | Specs inherit context from the OA via the PRD |
| `/update_memory` | Key findings from the OA can be seeded into `context.md` |
