# /update_backlog

Keep the product backlog current — sync the spec registry, update statuses, and manage parking lot ideas.

---

## When to use it

Run `/update_backlog` any time the backlog needs to reflect reality. Good triggers:

- A feature shipped and you want to mark it Done
- Engineering started on something and you want to flip it to In Progress
- A new idea came up in a meeting and you want to park it before it gets lost
- You haven't touched the backlog in a sprint and want to sync it against actual spec files
- An engineering plan was written and needs to be linked to its registry row
- A parking lot idea just became a spec and the parking lot entry should be removed

---

## What you'll be asked

The command opens with a menu. Pick a number or just describe what you want:

```
1. Sync registry         — scan all specs and reconcile missing or outdated rows
2. Update a status       — mark a feature as In Progress, Done, or Blocked
3. Add a parking lot idea
4. Remove or promote a parking lot entry
5. Add an eng plan link
6. Full health check     — run all of the above
```

You can also skip the menu by describing the change directly — for example:

> "The CSV export feature shipped"

The command interprets that as a status update to Done and confirms before acting.

---

## What it produces

**Primary file:** `thoughts/shared/backlog/backlog.md`

The backlog has two sections:

### Spec Registry

A table of every feature spec and its current status:

| Status | Feature | Spec | Eng Plan | Created | Notes |
|--------|---------|------|----------|---------|-------|
| Todo | CSV Export | [spec](../specs/...) | — | 2026-06-10 | |
| In Progress | Bulk Invite | [spec](../specs/...) | [plan](../../repos/...) | 2026-05-20 | |
| Done | SSO Login | [spec](../specs/...) | [plan](../../repos/...) | 2026-04-01 | |

Status values:

| Status | Meaning |
|--------|---------|
| `Todo` | Spec written, not yet in an engineering plan |
| `In Progress` | Engineering plan exists, implementation underway |
| `Done` | Shipped or closed |
| `Blocked` | Waiting on something external — describe the blocker in Notes |

### Parking Lot

A structured holding area for ideas not yet ready for a spec, organized into four sections:

| Section | What goes here |
|---------|---------------|
| **User Feedback** | Support tickets, NPS responses, user interviews, in-app feedback |
| **Internal Ideas** | Planning sessions, team discussions, stakeholder requests |
| **Research & Metrics** | Signals from opportunity assessments or post-launch metrics reviews |
| **Competitive Signals** | Gaps identified from competitive analysis |

Parking lot entries are freeform bullets with optional source links. When an idea becomes a spec, the entry is removed from the parking lot and the spec's `source` frontmatter records where it came from.

---

## Confirmation rules

The command confirms before executing when:

- Running a full sync (`FULL_SYNC`) — may affect multiple rows
- Moving a feature to `Done` — confirms the feature actually shipped
- Removing a parking lot entry without promoting it to a spec
- Changing more than two rows in one run

Single, unambiguous operations (adding one parking lot idea, linking one plan) happen immediately without a confirmation step.

---

## Memory hook

When a feature is moved to `Done`, the command automatically logs a `"Shipped {feature}"` entry to `memory/decisions.md`. No extra steps needed.

---

## Full sync behavior

Option 1 (sync registry) compares the spec files on disk against the registry rows:

- **Specs on disk but not in registry** → adds them as new `Todo` rows
- **Registry rows whose spec file no longer exists** → flags them with ⚠️ in the Notes column (does not delete rows)
- **Rows already matched** → left completely unchanged, including status

The sync never changes the status of existing rows. Status is owned by the workflow, not the sync.

---

## Connected commands

| Command | Relationship |
|---------|-------------|
| `/create_spec` | Adds a new row to the registry automatically after writing a spec |
| `/create_plan` *(HyprLayer)* | Triggers the ADD_PLAN_LINK operation — links the plan and moves status to In Progress |
| `/update_memory` | Captures "shipped" decisions (also done automatically on Done transitions) |
