# research_requirements

Research and generate a complete Product Requirements Document — personas, functional requirements, phased roadmap, and success metrics — based on an Opportunity Assessment and direct PM input.

---

## When to use it

Run `research_requirements` when you're ready to define a product, not just the problem space. Good triggers:

- An Opportunity Assessment exists and you're ready to scope the full product
- A new product or major feature area needs a requirements baseline
- Onboarding a new engineering lead or designer who needs a canonical product reference
- Realigning on scope after significant product changes

Not the right command for a single feature — use `/create_spec` for that. The PRD is product-scoped; a spec is feature-scoped.

---

## What you'll be asked

The command starts by asking for an Opportunity Assessment:

> "Do you have an Opportunity Assessment (OA) for this product? If so, please paste it or upload the file. It will significantly improve the quality of your PRD."

It will also check for an OA in your working folder. If none is found, it flags the sections that will need PM validation before the PRD moves to Review status.

Then it asks ten questions — all at once, not one at a time:

```
1. What is the product or feature name?
2. What problem does it solve? (1–3 sentences)
3. Who are the primary users?
4. What is the target platform or surface?
5. Do you have a launch target or timeline?
6. Who is the PM, Engineering Lead, and UX Designer?
7. Are there existing designs, mockups, or Figma links?
8. What systems or platforms does this touch?
9. Are there any hard constraints — technical, legal, or business?
10. What does success look like in 90 days?
```

Questions 1, 2, and 3 are required to proceed. The rest improve output quality.

---

## What happens next

After inputs are gathered:

1. Runs a research phase across six areas: market context, user behavior, competitive landscape, platform/technical landscape, regulatory factors, and baseline metrics. Each gap is flagged `[DATA NEEDED]`.
2. Drafts the PRD section by section, following the standard template precisely.
3. Runs a self-review quality checklist before delivering.
4. Writes the PRD to `thoughts/shared/requirements/`.
5. Presents a summary of what was drafted, what was flagged TBD, and what the PM should validate before moving to Review status.
6. Offers to generate a `.docx` version for sharing.

---

## What it produces

**Primary output:** `thoughts/shared/requirements/YYYY-MM-DD-prd-{slug}.md`

Every PRD contains:

| Section | What it captures |
|---------|-----------------|
| Executive Summary | 2–3 sentence business impact statement |
| Strategic Context & Business Rationale | Why this, why now, cost of inaction (3–5 paragraphs) |
| Scope | Explicit In Scope and Out of Scope lists |
| Stakeholders | Directly accountable owners with their stake |
| User Personas | 1–3 behavior-focused personas (not demographics) |
| Objectives & Goals | 1 primary objective + 3–5 measurable secondary goals |
| Assumptions | Validated and unvalidated assumptions, clearly labeled |
| Functional Requirements | User story table with Must/Should/Could importance ratings |
| Non-functional Requirements | Performance, security, reliability, scalability, accessibility, compliance |
| Dependencies | Confirmed blocking dependencies only |
| User Interaction and Design | End-to-end user flow or design links |
| Success Metrics | 3–5 metrics with baselines and targets |
| Appendix A — Phased Roadmap | 4+ phases, MVP clearly labeled |

**PRD frontmatter:**
```yaml
date: 2026-06-10
product: Product Name
status: Draft
version: v0.1
author: Greg
```

---

## Quality standards

The PRD follows strict writing rules:

- **No fabricated data** — no invented revenue projections, user counts, or timelines without a source
- **Every TBD has an owner** — `[TBD: what's needed and from whom]`, never anonymous
- **Assumptions labeled** — `[ASSUMPTION]` on everything unverified
- **Functional requirements describe WHAT, not HOW** — no implementation detail unless it's a confirmed hard constraint
- **Non-functional requirements are numeric** — "p95 latency < 300ms", not "fast"
- **Success metrics have targets** — and note whether a baseline exists
- **No marketing language** — no "seamless," "robust," "world-class"

If the OA was missing, the PRD is delivered with a ⚠️ note identifying which sections need PM validation before it moves to Review status.

---

## PRD vs. Spec

The PRD is the product-level document. It is not re-written per feature.

| PRD | Spec |
|-----|------|
| Product-scoped | Feature-scoped |
| Defines personas for all specs to reference | References personas from the PRD |
| Multi-quarter roadmap | Single feature, single sprint |
| Produced once; updated as the product evolves | Produced per feature; versioned in place |
| Input: OA + PM answers | Input: PRD + backlog context |

When a spec is written, it inherits personas, constraints, and success metric direction from the PRD. It does not redefine them.

---

## After the PRD is written

Run `/create_spec` for the first feature. It will ask whether the feature is in the current PRD roadmap and will inherit personas, constraints, and metric direction from it.

Keep the PRD updated as the product evolves — especially Scope, Assumptions, and Success Metrics. Personas and Strategic Context change slowly; Functional Requirements change as features are scoped into specs.

---

## Connected commands

| Command | Relationship |
|---------|-------------|
| `research_opportunity` | Produces the OA that anchors this PRD's strategic context |
| `/create_spec` | Each spec inherits from this PRD and back-links to it |
| `/update_memory` | Seed foundational terms from the PRD into `taxonomy.md` after the PRD is written |
| `/update_backlog` | The backlog registry tracks which PRD features have been spec'd |
