---
description: Update product memory — log a decision, refresh context, add a taxonomy term, or run a health check on decisions.md, context.md, and taxonomy.md
argument-hint: "<what to capture or 'health check'>"
---

# /memory -- Update Product Memory

Maintain the three living memory files in `thoughts/shared/memory/`. Keeps every agent — PM or engineering — grounded in your team's real language and decisions.

## Invocation

```
/memory we decided to drop offline mode for v1 — not enough demand to justify the complexity
/memory our sprint focus shifted to retention after Q3 results
/memory we call it a "Workspace" not an "Organization"
/memory health check
```

## Workflow

Invoke the `update_memory` skill. It routes your input to the right operation:

| Input type | File updated | Operation |
|---|---|---|
| A decision with rationale | `decisions.md` | `LOG_DECISION` — append-only |
| A current state change | `context.md` | `UPDATE_CONTEXT` — section overwrite |
| A new term or definition | `taxonomy.md` | `ADD_TERM` — append-only |
| "health check" | All three | `CONSOLIDATE` — read-only audit |

Memory/ is initialized automatically on first use.

## After `/memory`

- Back to specs? → `/spec`
- Reviewing backlog? → `update_backlog`

