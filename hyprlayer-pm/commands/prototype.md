---
description: Create a high-fidelity Vite + React prototype grounded in a feature spec — scaffolds the product-line repo automatically on first use
argument-hint: "<feature or spec reference>"
---

# /prototype -- Create Prototype

Build a high-fidelity interactive prototype from your PM artifacts. Reads from your spec and PRD. Writes to a dedicated `hyprlayer-prototypes-{slug}` repo.

## Invocation

```
/prototype the CSV export feature
/prototype [attach a spec or link to thoughts/shared/specs/]
/prototype onboarding step 3 redesign
```

## Workflow

Invoke the `create_prototype` skill. It will:

1. Locate the relevant spec in `thoughts/shared/specs/`
2. Extract: user story, acceptance criteria, scope, and design constraints
3. On first prototype for this product: scaffold the `hyprlayer-prototypes-{slug}` repo (Vite + React + Tailwind) and push to GitHub
4. Scaffold the prototype screens from the spec's In Scope items
5. Write screen components, navigation, and a `prototype-manifest.json`
6. Surface for your review before finalizing

## After `/prototype`

- Evolve screens? → `iterate_prototype`
- Ready for engineering? → `handoff_prototype` then `export_prototype`
- Capture design decisions? → `/memory`

