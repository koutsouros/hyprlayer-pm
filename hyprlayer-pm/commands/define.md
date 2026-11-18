---
description: Produce a full PRD from an existing Opportunity Assessment — personas, phased roadmap, functional requirements, and success metrics
argument-hint: "<product name or OA reference>"
---

# /define -- Product Requirements Document

Turn an Opportunity Assessment into a full Product Requirements Document. Reads from `thoughts/shared/research/` and writes the PRD to `thoughts/shared/requirements/`.

## Invocation

```
/define AI meeting summarizer
/define [reference the OA file path]
/define [attach an OA or brief]
```

## Workflow

Invoke the `research_requirements` skill. It will:

1. Locate the most relevant OA in `thoughts/shared/research/` (or ask you to point to one)
2. Extract: problem space, target segments, competitive context, and risk signals
3. Produce a full PRD covering:
   - User Personas (linked to OA segments)
   - Phased Roadmap (Appendix A)
   - Functional Requirements table
   - Non-Functional Requirements
   - Success Metrics (tied to OA opportunity signals)
4. Confirm the draft with you before writing
5. Write the PRD to `thoughts/shared/requirements/YYYY-MM-DD-prd-{slug}.md`
6. Initialize `thoughts/shared/memory/` if it doesn't exist yet

## After `/define`

- Ready to scope a feature? → `/spec`
- Want to prototype a concept? → `/prototype`
- Need to set up product memory? → `/memory`

