# Memory System

How the three memory files work, what goes in each one, and when they're updated.

---

## Why memory exists

HyprLayer's thoughts directory stores artifacts — plans, research documents, specs. These are discrete, timestamped files that answer specific questions at a point in time.

The memory system is different. It stores *living knowledge* — the decisions, vocabulary, and current state that let any agent orient itself in seconds without having to re-read every artifact. When an engineering agent starts `/create_plan`, reading `memory/context.md` tells it what phase the product is in and what constraints exist without parsing the entire PRD. When `/create_spec` runs, reading `memory/taxonomy.md` ensures the spec uses the same terms the codebase and prior specs use.

Think of the three memory files as the answer to: "What would you tell a new teammate on their first day?"

---

## The three files

All three live at `thoughts/shared/memory/` and are initialized by running `/update_memory` → Initialize (or automatically on first write by any command).

---

### `decisions.md` — Decision Log

**Nature:** Append-only  
**Updated by:** `/create_spec` (automatic), `/update_backlog` Done transitions (automatic), `/update_memory` (manual)

An append-only record of every meaningful product or technical decision. The key word is *meaningful* — not every choice gets logged, only the ones with a rationale and a consequence.

**What makes a decision worth logging:**
- It closes off an alternative that might otherwise be revisited
- It affects how future specs or plans should be written
- It came from a conversation (meeting, Slack, chat) and would otherwise be lost
- It was reversed — the reversal needs to be on record

**What doesn't belong here:**
- Formatting or wording choices
- Decisions that are obvious from the spec or plan itself
- Status updates and routine workflow steps

**Structure:**

| Date | Decision | Rationale | Impact | Source | Made By |
|------|----------|-----------|--------|--------|---------|

**Reversal rule:** If a decision is reversed, a new row is added immediately below the original with `↩ Reversed:` prefix. The original row is never deleted — it's part of the record.

**Why rationale is required:** A decision without a reason is just a fact. The rationale is what makes the log useful six months later when someone asks "why did we do it this way?"

---

### `context.md` — Product Context

**Nature:** Overwritten per section  
**Updated by:** `/update_memory` (manual, typically at sprint start or on significant shifts)

A living briefing document — what is true right now. Unlike `decisions.md`, this file is not append-only. It is updated by section, so it always reads as a coherent current-state description rather than an accumulation of past states.

**Sections:**

| Section | What it captures |
|---------|-----------------|
| **Current Sprint** | Sprint name, dates, focus area, active spec slugs |
| **Active Constraints** | Current blockers, hard technical limits, resource constraints |
| **Team** | PM, Eng Lead, Design — update as composition changes |
| **What We Know Now** | Freeform briefing — the 2–3 paragraphs you'd tell a new team member on day one |
| **Key Links** | Relative paths to the PRD, OA, backlog |

**When to update context:**
- Start of each sprint (Current Sprint + What We Know Now)
- When a significant blocker is identified or cleared (Active Constraints)
- When the team changes (Team)
- After a post-launch metrics review reveals something that shifts priorities

**When NOT to update context:** Don't append history to context sections. If you want to record what happened, log it in `decisions.md`. Context describes now — history belongs in decisions.

---

### `taxonomy.md` — Taxonomy & Glossary

**Nature:** Append-only terms table; naming conventions section updated in place  
**Updated by:** `/create_spec` (automatic for new terms), `/update_memory` (manual)

Product-specific language. Every term the team has consciously defined — not general industry vocabulary. The goal is consistent naming across all artifacts: the same word in the spec, the codebase, the user docs, and the engineering plan.

**What belongs here:**
- Domain concepts specific to this product ("Workspace", "Export Job", "Member")
- Terms where the product's definition differs from the industry default
- Naming conventions (UI label casing, API field format, event name format)
- Product-specific abbreviations

**What doesn't belong here:**
- General software engineering terms
- Terms already universally understood by the team
- Marketing or sales language (unless it appears in the product UI)

**Structure:**

| Term | Definition | Introduced | Source |
|------|------------|------------|--------|

Plus `## Naming Conventions` and `## Abbreviations` sections.

**Taxonomy drift** is one of the most common causes of spec-to-plan misalignment. If the PRD says "Workspace," the spec says "Organization," the code says "tenant," and the user docs say "account," every agent has to guess — and they'll guess differently. This file prevents that.

---

## Automatic updates

Most memory updates happen without you doing anything:

| What triggers it | What's captured | Which file |
|-----------------|-----------------|------------|
| `/create_spec` — spec confirmed | Out-of-scope items with rationale | `decisions.md` |
| `/create_spec` — spec confirmed | New domain terms from spec body | `taxonomy.md` |
| `/create_spec` — `prd_aligned: false` | "Spec created outside PRD" logged | `decisions.md` |
| `/update_backlog` — status → Done | "Shipped {feature}" | `decisions.md` |

If `memory/` doesn't exist for a product yet, these automatic steps skip silently. Initialize memory first (see [Getting Started](getting-started.md)).

---

## Manual updates

Run `/update_memory` when something worth capturing happened outside the normal workflow:

- A decision was made in a meeting or Slack thread
- The team agreed on a term during a conversation
- A sprint is starting and context needs refreshing
- A previous decision was reversed
- You want a health check across all three files

See the [/update_memory command guide](update_memory.md) for the full set of options.

---

## How agents use memory

All PM and engineering agents that do substantive work should read memory before starting:

- `@thoughts-analyzer` reads `memory/context.md` when invoked — the product phase and constraints orient its analysis
- `/create_spec` reads `memory/taxonomy.md` before drafting — ensures the spec uses established terms
- `/create_plan` *(HyprLayer)* reads `memory/context.md` and `memory/taxonomy.md` — consistent naming and awareness of current constraints

The value compounds over time. A memory system that's been maintained for six months means every new spec and plan starts with a complete orientation to the product — no ramp-up, no inconsistencies.

---

## Health check

Run `/update_memory` → option 5 (Memory health check) to audit all three files for:

- Decisions that appear to contradict each other without a clear amendment link
- Taxonomy terms whose definitions have drifted across files
- Context sections that haven't been updated recently
- Source links that no longer resolve to actual files
- Potential duplicate terms under different names

The health check is read-only — it returns a report, you decide what to act on.

---

## Starting fresh vs. inheriting

**New product:** Initialize memory via `/update_memory`, then seed it manually — update context with the product phase and team, add foundational terms from the PRD. Takes 15 minutes and pays back immediately.

**Existing product with no memory yet:** Run a FULL_SYNC on the backlog first to ensure the registry is current. Then initialize memory and back-fill the most important decisions from prior specs and the PRD. Focus on the decisions that would be most surprising to a new team member — those are the ones worth capturing.
