# /iterate_spec

Revise a feature spec when scope changes — updates in place, captures the reason, and flags if an engineering plan may be affected.

---

## When to use it

Run `/iterate_spec` when something about the spec needs to change after it's been written. The two most common triggers:

- **Engineering feedback during planning** — eng reviewed the spec and raised a concern about feasibility, missing constraints, or scope that's too broad for the sprint
- **Stakeholder or PM scope decision** — a call was made to cut, add, or reframe what's being built before or during implementation

Not the right command if the spec needs to be rebuilt from scratch due to a product pivot — that warrants a new `/create_spec`.

---

## What you'll be asked

The command opens with two questions:

1. **Which spec are we updating?** — A name, slug, or brief description. The command will find it.
2. **What's driving the change?** — Engineering feedback (a) or a scope decision (b). A freeform answer also works — the command will interpret it and confirm.

---

## What happens next

After you answer the opening questions:

1. The command finds the spec in `thoughts/shared/specs/`.
2. Reads the full spec and checks the backlog row in parallel — to understand current scope and whether an engineering plan already exists.
3. **Flags ⚠️ if the spec is In Progress** — changes to AC or scope could make an existing plan stale.
4. Presents the current scope summary and asks what specifically needs to change.
5. Clarifies the rationale (who made the call, why).
6. Drafts the changed sections and **presents a before/after diff for your review**.
7. **Waits for your confirmation before writing anything.**
8. Updates the spec file in place, increments the version, and updates the frontmatter change log.
9. Logs scope cuts and new constraints to memory automatically.
10. Updates backlog status only if it changed (e.g., spec moved back to `draft` → status set to `Blocked`).

---

## Downstream risk flags

The command checks backlog status and flags risk before proposing any changes:

| Backlog status | What happens |
|---------------|-------------|
| `Todo` (no plan) | No flag — low risk, proceed normally |
| `In Progress` (plan exists) | ⚠️ Flag upfront — changes may make the plan stale |
| `Done` | Ask for confirmation — spec is for a shipped feature |

If the spec was In Progress, the summary at the end includes an explicit call to review the plan and consider re-running `/create_plan`.

---

## What it produces

**Primary change:** Spec file updated in place at `thoughts/shared/specs/YYYY-MM-DD-spec-{slug}.md`

Every iteration updates the spec's frontmatter:

```yaml
status: draft         # set back to draft if the change is substantive
version: v0.2         # incremented from previous version
last_updated: 2026-06-10
last_updated_by: Greg
last_updated_note: "Removed real-time sync from scope — eng: not feasible this sprint"
```

**For scope reductions (cuts):**
- Cut item moved from In Scope to Out of Scope with a rationale note: `{{item}} — cut: {{rationale}}`
- Related Acceptance Criteria removed
- Decision logged to `memory/decisions.md`

**For scope additions:**
- Item added to In Scope
- Corresponding Given/When/Then AC added
- `[TBD: metric needed]` flag added if new scope needs a success metric

**For new constraints:**
- Added to Constraints section
- Conflicting AC flagged for review

**Side effects:**
- `memory/decisions.md` — scope cuts and new constraints logged automatically (if memory exists)
- `backlog.md` — status updated only if it changed

---

## The before/after diff

Before any write, the command shows exactly what's changing:

```
Here's what I propose to change:

In Scope — removing:
- ~~Real-time sync across devices~~

Out of Scope — adding:
- Real-time sync across devices — cut: not feasible in sprint; server-sent events not yet available

Acceptance Criteria — removing:
- ~~Given a user makes a change on device A, when device B is open, then it syncs within 2 seconds.~~ (covered by cut item)

Version will increment: v0.1 → v0.2
Last updated note: "Removed real-time sync — eng: SSE not available this sprint"

Proceed with these changes?
```

If the proposed changes aren't right, you can ask for adjustments — the command revises and re-presents before writing.

---

## Why rationale is required

A scope cut without a reason is just a shorter spec. A scope cut with a clear rationale is a decision on record — when the same idea resurfaces in the next sprint, the team knows it was considered and why it was deferred.

Every change logged to `memory/decisions.md` requires a rationale. The command will ask for one if it wasn't clear from your opening description.

---

## Version history

Iteration history lives in the spec's frontmatter. Each `/iterate_spec` run increments the version and updates `last_updated_note`. This keeps the file self-documenting — anyone reading the spec can see at a glance what changed last and why.

`v0.1 → v0.2 → v0.3 ...` for pre-ready revisions  
`v1.0 → v1.1 → v1.2 ...` for post-ready revisions

---

## Connected commands

| Command | Relationship |
|---------|-------------|
| `/create_spec` | Produces the spec this command revises |
| `/update_backlog` | Reflects status changes from an iteration |
| `/update_memory` | Scope decisions are also logged here automatically |
| `/create_plan` *(HyprLayer)* | May need to be re-run if AC changed after a plan existed |
