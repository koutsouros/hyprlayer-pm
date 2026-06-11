# /create_spec

Create a feature-level spec that engineering can act on immediately.

---

## When to use it

Run `/create_spec` any time you want to move a feature from idea to something actionable. Good triggers:

- A feature in the PRD is ready to be scoped for the next sprint
- An idea from the backlog parking lot has enough context to become a spec
- Engineering is asking "what exactly do we need to build?"
- You want to define acceptance criteria before planning begins

Not the right command if the work requires redefining product goals, user personas, or multi-quarter scope — that belongs in the PRD (`research_requirements`).

---

## What you'll be asked

The command opens with three questions, all at once:

1. **What feature or capability do you want to spec?** — A sentence or two describing the problem it solves or the capability it adds.
2. **Is this feature already in the current PRD roadmap?** — Yes / No / Not sure. Determines whether the spec inherits from existing PRD scope or flags itself as net-new.
3. **Are there backlog items, user feedback, prior research, or any other context I should pull in?** — Optional. Point to anything relevant and the command will find and read it.

That's all you need to provide upfront. The command handles the research.

---

## What happens next

After you answer the three questions, the command:

1. Scans your thoughts directory for relevant documents — PRD, prior specs, backlog entries, user docs, metrics reviews, opportunity assessments.
2. Deep-reads the most relevant sources in parallel.
3. Drafts a complete spec using a standard template (see below).
4. **Shows you the draft and waits for your approval** before writing anything.
5. Writes the spec to `thoughts/shared/specs/YYYY-MM-DD-spec-{slug}.md`.
6. Links the spec back to the PRD (if the feature was found there).
7. Adds the spec to your backlog — creating `backlog.md` if one doesn't exist yet.
8. Captures any out-of-scope decisions and new terms to product memory (if memory is set up).

---

## What it produces

**Primary output:** `thoughts/shared/specs/YYYY-MM-DD-spec-{slug}.md`

Every spec contains:

| Section | What it captures |
|---------|-----------------|
| Problem | One sentence — the user pain or product gap being addressed |
| User Story | As a [persona], I want to [action], so that [outcome] |
| In Scope | 3–5 explicit capabilities being built |
| Out of Scope | Explicit exclusions — prevents scope creep during planning |
| Acceptance Criteria | Testable Given/When/Then statements |
| Success Metrics | Measurable outcomes with baselines where known |
| Constraints | Confirmed technical, legal, or platform constraints |
| Related Context | Links to OA, PRD, backlog items, user docs, prior specs |
| Open Questions | Unresolved items, each with an owner |

**Side effects:**
- `backlog.md` — spec is added as a new `Todo` row in the registry
- `memory/decisions.md` — out-of-scope decisions are logged automatically
- `memory/taxonomy.md` — new domain terms are added automatically
- PRD — a back-link to the spec is added (if `prd_aligned: true`)

---

## Spec frontmatter

The spec file includes structured frontmatter that other commands read:

```yaml
date: 2026-06-10
product: My Product
prd: thoughts/shared/requirements/2026-05-01-prd-my-product.md
status: draft
prd_aligned: true
source: Internal Ideas — "bulk user invite via CSV"
version: v0.1
author: Greg
```

`prd_aligned: false` means the feature is not yet in the PRD. The spec will flag this in Open Questions and note it in the backlog.

---

## After the spec is written

The summary tells you:
- Where the spec was written
- What was scoped in and out
- Whether the PRD was updated
- Whether a parking lot entry was promoted
- Whether memory was updated
- A reminder: **"This spec is now readable by `/create_plan`."**

When you're ready to implement, run `/create_plan` and point it at this spec. It will use the acceptance criteria and success metrics as planning constraints.

---

## Follow-up edits

If you need to revise the spec after it's written, just describe the change. The command updates the file in place and increments the version (`v0.1 → v0.2`). It does not create a new file.

---

## Connected commands

| Command | Relationship |
|---------|-------------|
| `research_requirements` | Produces the PRD that specs inherit from |
| `research_opportunity` | Produces the OA that informs PRD context |
| `/update_backlog` | Manages the registry this spec is added to |
| `/update_memory` | Captures decisions and terms (also done automatically) |
| `/create_plan` *(HyprLayer)* | Reads this spec to produce the engineering plan |
