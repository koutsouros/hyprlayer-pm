# /update_memory

Capture what the team knows — log a decision, define a term, refresh product context, or scan the current conversation for things worth keeping.

---

## When to use it

Most memory updates happen automatically during other commands. Run `/update_memory` explicitly when:

- A decision was made in a meeting, Slack thread, or conversation and you want it on record
- The team agreed on a term or naming convention that should be consistent across all specs and plans
- A sprint is starting and you want to update the product context briefing
- A previous decision was reversed and the log needs a correction
- You want to run a health check and find any drift or stale entries across all three memory files
- Setting up memory for a new product for the first time

---

## The three memory files

`/update_memory` maintains three files in `thoughts/shared/memory/`:

### `decisions.md` — Decision Log

An append-only record of every meaningful product or technical decision. Decisions are never deleted. If a decision is reversed, a new row is added immediately below the original — the original stays as a record of what was true at that point.

Every row captures: **date, decision, rationale, impact, source, who made it.**

Rationale is required. A decision without a reason is just a fact — the value of the log is understanding *why*, which is the information that ages slowest.

### `context.md` — Product Context

A living briefing document that reflects the current state of the product. Written to be read by a new team member on day one, or by an AI agent orienting itself before doing any work.

Updated by section, not by appending — this file describes *now*, not history. History lives in `decisions.md`.

Sections: current sprint, active constraints, team, what we know now, key links.

### `taxonomy.md` — Taxonomy & Glossary

Product-specific language that every agent reads before writing specs or plans. Ensures consistent naming across all artifacts — the difference between a spec that says "Workspace," an API that says "tenant," and user docs that say "account" is exactly the kind of drift this file prevents.

Contains a terms table, naming conventions, and abbreviations.

---

## What you'll be asked

The command opens with a menu:

```
1. Log a decision
2. Update product context
3. Add a taxonomy term
4. Amend an existing entry
5. Memory health check
6. Capture from this conversation
```

You can also skip the menu with a freeform statement:

> "We decided not to support offline mode — too much infra complexity for a feature less than 5% of users need"

The command classifies it (decision), routes it to `decisions.md`, and confirms before writing. It extracts the rationale from your statement — if you don't include one, it asks before logging.

---

## Option 6 — Capture from conversation

This option scans the current conversation for signals worth capturing:

- **Decisions:** "we decided", "we agreed", "let's not", "going with", "final answer"
- **Terminology:** "let's call it", "from now on we'll say", "the difference between X and Y"
- **Context shifts:** "this sprint we're focused on", "current blocker is", "as of now"

It presents a curated list and asks which entries to capture before writing anything. Candidates flagged as needing clarification (e.g. a decision with no stated rationale) are called out — you provide the missing piece before it's logged.

---

## Initializing memory for a new product

If you haven't set up memory for a product yet, the command will detect this and offer to initialize. Initialization creates three empty files from templates — ready to populate. Do this once at the start of a product, then let the normal workflow keep it current.

---

## What updates automatically (without running this command)

Most of the time you don't need to run `/update_memory` explicitly:

| Automatic trigger | What gets captured |
|-------------------|--------------------|
| `/create_spec` — spec confirmed | Out-of-scope decisions → `decisions.md`; new terms from the spec body → `taxonomy.md` |
| `/update_backlog` — status moved to Done | "Shipped {feature}" → `decisions.md` |

These happen in the background as side effects. `/update_memory` is for everything else — ad hoc decisions, context updates at sprint start, manual corrections, and health checks.

---

## Health check (option 5)

Runs a read-only audit across all three files and reports:

- Decisions that may contradict each other without a clear amendment link
- Taxonomy terms whose definitions have drifted from how they appear elsewhere
- Context sections that haven't been updated recently
- Source links that no longer resolve to actual files
- Potential duplicate terms defined under different names

No changes are made during a health check. It returns a report — you decide what to act on.

---

## Amending an existing entry

Option 4 handles corrections and reversals:

- **Reverse a decision** — adds a `↩ Reversed:` row immediately below the original. The original is preserved.
- **Update a term definition** — replaces the definition in place and notes the amendment date and reason.
- **Remove a deprecated term** — removes the row and leaves a comment recording the date and reason.

---

## Connected commands

| Command | Relationship |
|---------|-------------|
| `/create_spec` | Writes to memory automatically after spec is confirmed |
| `/update_backlog` | Writes to memory automatically on Done transitions |
| `research_requirements` | PRD creation is a good time to initialize or refresh context and taxonomy |
