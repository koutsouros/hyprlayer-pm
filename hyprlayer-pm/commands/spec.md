---
description: Write a feature-scoped spec ready for engineering — testable acceptance criteria, explicit scope boundaries, and automatic backlog registration
argument-hint: "<feature description>"
---

# /spec -- Feature Spec

Scope a single feature into a lightweight, engineering-ready spec. Draws from your PRD, prior specs, and backlog. Automatically registers the new spec in the product backlog.

## Invocation

```
/spec CSV export for the reporting dashboard
/spec Users are dropping off at step 3 of onboarding — spec the fix
/spec [attach a PRD section or backlog item]
```

## Workflow

Invoke the `create_spec` skill. It will:

1. Ask three focused questions: what feature, is it in the PRD, any relevant context
2. Gather context from `thoughts/`: PRD, prior specs, backlog, user docs
3. Draft the spec using `thoughts/global/shared/spec-template.md`:
   - Problem statement (one sentence)
   - User Story
   - In Scope / Out of Scope (explicit)
   - Acceptance Criteria (Given/When/Then)
   - Success Metrics (measurable, tied to PRD)
   - Constraints and Open Questions
4. Confirm the draft with you before writing
5. Write to `thoughts/shared/specs/YYYY-MM-DD-spec-{slug}.md`
6. Register in `backlog.md` (creates it if first spec)
7. Auto-capture scope decisions to memory

## After `/spec`

- Ready to build a prototype? → `/prototype`
- Need to revise scope? → `iterate_spec`
- Want to update the backlog status? → `update_backlog`

