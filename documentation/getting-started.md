# Getting Started

A step-by-step guide to setting up the PM layer for a new product and running your first spec.

---

## Prerequisites

The PM layer runs on top of HyprLayer. Before using any PM commands, you need:

- HyprLayer installed and configured (`hyprlayer storage info` should return a valid backend)
- A `thoughts/` directory mapped to your storage backend (git or Obsidian)
- GitHub Copilot (or compatible) with access to the prompt and agent files in `ai/copilot/`

If you're not sure whether HyprLayer is set up, run `hyprlayer storage info --json` in your terminal. If it returns a backend name, you're good. If it fails, follow the HyprLayer setup guide first.

---

## Step 1 — Research the Opportunity (optional but recommended)

If you're starting a brand new product or feature area and haven't validated the problem space yet, begin with an Opportunity Assessment.

Run: `research_opportunity`

This spawns parallel research agents across market, competitive, customer, and technical dimensions and writes a structured OA to `thoughts/shared/research/`. It typically takes a few minutes. The output feeds into your PRD.

Skip this step if you already have validated research or if you're working on a well-understood feature extension.

---

## Step 2 — Write the PRD

The PRD defines the product at a level above individual features — personas, roadmap phases, functional requirements, and success metrics. Specs inherit from it.

Run: `research_requirements`

The command checks whether an OA exists and uses it as input if found. It then asks ten focused product questions to shape the document. The PRD is written to `thoughts/shared/requirements/`.

You typically write one PRD per product, not per feature. If the product is well-defined and you're just adding features, skip to Step 3.

---

## Step 3 — Initialize Product Memory

Set up the three memory files that will accumulate product knowledge over time.

Run: `/update_memory`

Select the option to **Initialize**. This creates three empty files in `thoughts/shared/memory/`:

- `decisions.md` — decision log (starts empty, fills up over time)
- `context.md` — product context briefing
- `taxonomy.md` — terminology and naming conventions

After initialization, do two things before closing:

1. **Update context** — run `/update_memory` again, select "Update product context," and fill in the current sprint, team, and active constraints. Think of this as the day-one briefing for any agent that picks up your product.

2. **Add foundational terms** — open your PRD and pull the core domain terms into `taxonomy.md` using `/update_memory` → "Add a taxonomy term." Start with the 5–10 terms that appear in almost every sentence of the PRD.

This takes 10–15 minutes and pays back immediately — every spec you write from this point on will use consistent language.

---

## Step 4 — Write Your First Spec

Pick the first feature you want to build and create a spec for it.

Run: `/create_spec`

You'll be asked three questions. Answer them, and the command does the rest: it reads your PRD, finds relevant context, drafts the spec, shows it to you for approval, then writes it and creates your `backlog.md` automatically.

After the spec is written, you'll see a summary and a reminder that the spec is ready for `/create_plan`.

---

## Step 5 — Hand Off to Engineering

Point HyprLayer's engineering workflow at your spec.

Run: `/create_plan` (HyprLayer command)

Direct it at the spec you just wrote. It will read the acceptance criteria and success metrics as planning constraints and produce an engineering plan in `thoughts/repos/{project}/shared/plans/`.

When the plan is written, `/create_plan` links it back to your backlog row automatically (setting status to In Progress).

---

## Ongoing workflow

From here, the cycle per feature is:

```
/create_spec → /create_plan → implement → /update_backlog (Done) → repeat
```

The backlog stays current through a mix of automatic updates (spec creation, plan linking, Done transitions) and occasional manual runs of `/update_backlog` for parking lot management or full syncs.

Memory accumulates in the background. Run `/update_memory` when a significant decision is made in a meeting or conversation that wouldn't otherwise be captured.

---

## Folder structure reference

```
thoughts/
  shared/
    research/       Opportunity Assessments
    requirements/   PRDs
    specs/          Feature specs (output of /create_spec)
    backlog/        backlog.md (registry + parking lot)
    memory/         decisions.md, context.md, taxonomy.md
    user-docs/      User-facing documentation
    metrics/        Post-launch metrics reviews
  global/
    shared/         Cross-product personas, principles
  repos/            Engineering artifacts (HyprLayer)
```

---

## Quick reference

| I want to... | Run... |
|-------------|--------|
| Validate a new problem space | `research_opportunity` |
| Write or update the PRD | `research_requirements` |
| Create a feature spec | `/create_spec` |
| Update the backlog | `/update_backlog` |
| Log a decision or define a term | `/update_memory` |
| Create an engineering plan | `/create_plan` *(HyprLayer)* |
| See what everything produces | [Artifact Hierarchy](artifact-hierarchy.md) |
| Understand the memory files | [Memory System](memory-system.md) |
