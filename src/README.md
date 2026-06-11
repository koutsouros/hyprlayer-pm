# HyprLayer PM Layer — Reference Guide

**Version:** 1.0  
**Last updated:** 2026-06-10  
**Status:** In progress — commands, agents, and memory system complete; additional commands pending

---

## Overview

This document describes the product management skill layer built on top of HyprLayer. It mirrors HyprLayer's engineering workflow (Research → Plan → Implement → Validate → Commit → Review → Ship) from the PM perspective, using the same `thoughts/` directory infrastructure but writing to a `products/` folder structure rather than `repos/`.

The PM layer is designed around a single principle: **every artifact a PM produces should be directly readable by HyprLayer's engineering agents without translation.** A spec written by `/create_spec` becomes the primary input to `/create_plan`. A backlog maintained by `/update_backlog` tells engineers what is queued, in progress, or shipped. Memory captured by `/update_memory` grounds every agent — PM or engineering — in the team's actual language and decisions.

The PM layer does not replace engineering judgment. It structures the problem space so engineering agents have fewer ambiguities to resolve on their own.

---

## Relationship to HyprLayer

HyprLayer is a CLI and slash command system for spec-driven AI agent development. Its core workflow stages are:

```
Research → Plan → Implement → Validate → Commit → Review → Ship
```

Each stage produces artifacts that live in `thoughts/repos/`. The PM layer adds a parallel artifact chain that runs *before* the engineering workflow begins and feeds into it:

```
PM: Opportunity → PRD → Spec → [hand off to HyprLayer] → Plan → Implement → ...
```

The handoff point is the spec. Everything before it is PM work. Everything from `/create_plan` onward is HyprLayer engineering. The PM layer uses HyprLayer's existing `@thoughts-locator` and `@thoughts-analyzer` agents for all document retrieval — it does not introduce new retrieval infrastructure.

---

## Thoughts Directory Structure

The PM layer adds a `products/` folder tree under `thoughts/`. All PM artifacts live here. Engineering artifacts continue to live under `thoughts/repos/`.

```
thoughts/
├── shared/                         ← shared PM artifacts (default product scope)
│   ├── research/                   ← Opportunity Assessments (OAs)
│   │   └── YYYY-MM-DD-opportunity-{slug}.md
│   ├── requirements/               ← Product Requirements Documents (PRDs)
│   │   └── YYYY-MM-DD-prd-{slug}.md
│   ├── specs/                      ← Feature-level specs (primary input to /create_plan)
│   │   └── YYYY-MM-DD-spec-{slug}.md
│   ├── backlog/                    ← Spec registry and parking lot
│   │   └── backlog.md
│   ├── memory/                     ← Living product knowledge
│   │   ├── decisions.md            ← Append-only decision log
│   │   ├── context.md              ← Current product state (overwritten per section)
│   │   └── taxonomy.md             ← Product-specific terminology
│   ├── user-docs/                  ← User-facing documentation and onboarding flows
│   └── metrics/                    ← Post-launch metrics reviews
│
├── global/
│   └── shared/                     ← Cross-product: personas, principles, arch decisions
│
└── repos/                          ← HyprLayer engineering artifacts (unchanged)
    └── {project}/
        └── shared/
            └── plans/              ← Engineering plans produced by /create_plan
```

> **Searchable index:** HyprLayer maintains a `thoughts/searchable/` mirror with hard links for fast search. Strip `searchable/` from any path before writing it to a file. Do not create files directly in `searchable/`.

---

## Artifact Hierarchy

PM artifacts map to a deliberate hierarchy. Each level is a different scope and a different artifact type.

| Level | Artifact | Produced by | Scope | Feeds |
|-------|----------|-------------|-------|-------|
| 1 | **Opportunity Assessment (OA)** | `research_opportunity` | Market / problem space | PRD |
| 2 | **PRD** | `research_requirements` | Product-level, rare | Specs |
| 3 | **Spec** | `/create_spec` | Feature or epic | `/create_plan` |
| 4 | **Engineering Plan** | `/create_plan` (HyprLayer) | Implementation details | Implement → Ship |

A spec is not a PRD. A spec is feature-scoped, engineering-ready, and directly consumed by `/create_plan`. A PRD is product-scoped, defines the full roadmap and personas, and is the source a spec inherits from. If a request requires redefining product goals, user personas, or multi-quarter scope, it belongs in a PRD — not a spec.

---

## Commands (Prompt Files)

### `/create_spec` — v1.3

**File:** `create_spec.prompt.md`  
**Purpose:** Create a lightweight, feature-scoped spec that serves as the direct input to `/create_plan`.

#### What it does

1. Asks three opening questions: what feature, is it in the PRD, and what context to pull in.
2. Runs `@thoughts-locator` across all relevant folders: `research/`, `requirements/`, `specs/`, `backlog/backlog.md`, `user-docs/`, `metrics/`, `global/shared/`.
3. Spawns up to three parallel `@thoughts-analyzer` instances to deep-read the PRD, prior specs, and backlog/user-docs.
4. Drafts a spec using the standard template (see below).
5. Confirms the draft with the user before writing.
6. Writes the spec to `thoughts/shared/specs/YYYY-MM-DD-spec-{slug}.md`.
7. Updates the PRD with a spec link (if `prd_aligned: true`).
8. Creates or updates `backlog.md` via `@backlog-creator` or `@backlog-updater`.
9. Automatically captures out-of-scope decisions and new terms to `memory/` via `@memory-updater` (if memory is set up).
10. Presents a summary with a reminder to run `/create_plan`.

#### Spec template structure

```
---
date, product, prd, status: draft, prd_aligned, source, version: v0.1, author
---

# Spec: {Feature Name}

## Problem
## User Story
## In Scope
## Out of Scope
## Acceptance Criteria   ← Given/When/Then — becomes /create_plan success criteria
## Success Metrics       ← Measurable, with baseline if known
## Constraints
## Related Context       ← Links to OA, PRD, backlog items, user-docs, prior specs
## Open Questions        ← Each with an owner
```

#### Key design rules

- A spec describes **what**, not **how**. No implementation details unless they are confirmed hard constraints.
- `prd_aligned: true/false` — drives whether the PRD gets a back-link and whether the spec flags itself as a net-new addition.
- `[TBD: owner]` marks unknowns. `[ASSUMPTION]` marks unvalidated assumptions. Both must be resolved before moving to `/create_plan`.
- Follow-up edits increment `version` in frontmatter. Never create a new file for a revised spec.

---

### `/update_backlog` — v1.1

**File:** `update_backlog.prompt.md`  
**Purpose:** Keep the product backlog current — sync the spec registry, update statuses, and manage parking lot ideas.

#### What it does

Opens with a six-option menu:

```
1. Sync registry — scan all specs and reconcile missing or outdated rows
2. Update a status — mark a feature as In Progress, Done, or Blocked
3. Add a parking lot idea — capture an idea before it's ready for a spec
4. Remove or promote a parking lot entry — clean up ideas that have been spec'd or dropped
5. Add an eng plan link — link an existing registry row to its engineering plan
6. All of the above — run a full backlog health check
```

Reads the current `backlog.md` via `@thoughts-analyzer` before planning any changes. Confirms destructive operations (FULL_SYNC, Done status changes, removing parking lot entries, >2 rows changed) before executing. Delegates all writes to `@backlog-updater`.

**Memory hook (v1.1):** When any status is moved to `Done`, automatically calls `@memory-updater` with `LOG_DECISION` to record that the feature shipped. No user action required.

#### Backlog.md structure

```
---
product, last_updated, last_updated_by
---

## Spec Registry
| Status | Feature | Spec | Eng Plan | Created | Notes |

## Parking Lot
### User Feedback      ← Support tickets, NPS, interviews, in-app feedback
### Internal Ideas     ← Planning sessions, stakeholder requests
### Research & Metrics ← Signals from OAs or post-launch metrics reviews
### Competitive Signals ← Gaps from competitive analysis
```

Status values: `Todo` | `In Progress` | `Done` | `Blocked`

The backlog is a **registry**, not an ideation space. The parking lot is the pre-spec holding area. When an idea gets spec'd, it moves from the parking lot to the registry and the spec's `source` frontmatter records where it came from.

---

### `/update_memory` — v1.0

**File:** `update_memory.prompt.md`  
**Purpose:** Maintain the three memory files — log decisions, refresh product context, define terminology, or run a health check.

#### What it does

Opens with a six-option menu:

```
1. Log a decision
2. Update product context
3. Add a taxonomy term
4. Amend an existing entry
5. Memory health check
6. Capture from this conversation — scans chat for signals
```

Option 6 is the conversational capture path: scans the current conversation for decision signals ("we decided", "we agreed", "let's not"), taxonomy signals ("let's call it", "from now on"), and context signals ("this sprint we're focused on"), presents a curated list, and asks the user which to capture before writing anything.

Delegates all writes to `@memory-updater`. Requires rationale for every `LOG_DECISION` — will ask the user if it was omitted.

---

## Agents

### `@backlog-creator`

**File:** `backlog-creator.agent.md`  
**Called by:** `/create_spec` (when backlog.md doesn't exist), `/update_backlog`

Creates a new `backlog.md` from scratch. Scans `thoughts/searchable/shared/specs/` for existing spec files, reads each spec's frontmatter to derive feature name and status, and writes a fully-populated registry table. Guards against overwriting an existing backlog — stops and redirects to `@backlog-updater` if the file already exists.

**Status mapping from spec frontmatter:**

| Spec `status` | Backlog status |
|---------------|----------------|
| `draft` | Todo |
| `ready` | Todo |
| `implemented` | Done |

---

### `@backlog-updater`

**File:** `backlog-updater.agent.md`  
**Called by:** `/create_spec`, `/update_backlog`

Applies surgical, typed updates to an existing `backlog.md`. Reads the full file before making any change. Supported operations:

| Operation | What it does |
|-----------|--------------|
| `ADD_ROW` | Appends a new spec to the registry with status `Todo` |
| `UPDATE_STATUS` | Changes a row's status cell by spec slug |
| `ADD_PLAN_LINK` | Adds an eng plan link to a row; sets status to `In Progress` |
| `PARKING_LOT_ADD` | Appends a bullet to a specified parking lot section |
| `PARKING_LOT_REMOVE` | Removes a bullet (case-insensitive partial match) |
| `FULL_SYNC` | Reconciles registry against actual spec files on disk; adds missing rows; flags orphaned rows with ⚠️; never changes existing statuses |

All relative paths are calculated from `backlog/`: specs go `../specs/...`, plans go `../../repos/.../plans/...`. Updates `last_updated` and `last_updated_by` in frontmatter on every write.

---

### `@memory-updater`

**File:** `memory-updater.agent.md`  
**Called by:** `/create_spec` (automatic), `/update_backlog` (Done transitions), `/update_memory`

Maintains the three living memory files. Reads before writing. Initializes files from embedded templates if they don't exist yet — never fails with "file not found." Supported operations:

| Operation | File | What it does |
|-----------|------|--------------|
| `LOG_DECISION` | `decisions.md` | Appends a row to the decision table. Rationale required. |
| `AMEND_DECISION` | `decisions.md` | Adds a `↩ Reversed:` row below the original. Never removes the original. |
| `UPDATE_CONTEXT` | `context.md` | Replaces specified sections only. Other sections untouched. |
| `ADD_TERM` | `taxonomy.md` | Appends a row to the terms table. Checks for duplicates first. |
| `AMEND_TERM` | `taxonomy.md` | Updates a term's definition in place. Notes the amendment date and reason. |
| `REMOVE_TERM` | `taxonomy.md` | Removes a row; leaves an HTML comment noting the removal date and reason. |
| `CONSOLIDATE` | All three | Health check only — no writes. Reports drift, duplicates, stale sections, orphaned sources. |
| `INIT` | All three | Creates empty files from templates for a new product. |

---

### `@thoughts-locator` *(HyprLayer built-in)*

Used by all PM commands for document discovery. Scans the `thoughts/searchable/` index and returns file paths with one-line descriptions. Always invoked before `@thoughts-analyzer` — you need to know what exists before you can read it.

---

### `@thoughts-analyzer` *(HyprLayer built-in)*

Used by all PM commands for deep document reading. Detects storage backend first (`hyprlayer storage info --json`), then retrieves the document via the appropriate method (filesystem read for git/obsidian; API calls for Notion/Anytype). Extracts key decisions, constraints, actionable insights, and open questions. Filters aggressively — returns only what matters, not a summary of everything.

---

## Memory Files

The three files in `thoughts/shared/memory/` are the PM layer's persistent knowledge layer. They are not artifacts (they don't drive a specific workflow step) — they are the ambient context that every agent reads before doing substantive work.

### `decisions.md` — Decision Log

Append-only. Every meaningful product or technical decision recorded with its rationale, impact, and source. Reversals are added as new rows prefixed `↩ Reversed:` immediately below the original — the original is never deleted.

```markdown
| Date | Decision | Rationale | Impact | Source | Made By |
```

**Populated automatically by:**
- `/create_spec` — out-of-scope decisions, net-new specs (prd_aligned: false)
- `/update_backlog` — feature shipped (Done status)
- `/update_memory` — manual capture or conversational signal detection

---

### `context.md` — Product Context

A living briefing document — what is true right now. Updated per-section (not appended). The "What We Know Now" section is the most valuable: it captures what you'd tell a new team member on day one.

Sections: `Current Sprint`, `Active Constraints`, `Team`, `What We Know Now`, `Key Links`

**Updated by:** `/update_memory` (manually, or via `/sprint_plan` once that command is built)

---

### `taxonomy.md` — Taxonomy & Glossary

Product-specific language. Every term the team has consciously defined — not general industry vocabulary. Both PM and engineering agents read this before writing to ensure consistent naming across all artifacts.

```markdown
| Term | Definition | Introduced | Source |
```

Naming conventions and abbreviations tables also live here.

**Populated automatically by:** `/create_spec` (new terms introduced in the spec body); `/update_memory` (manual)

---

## Automatic Memory Capture

The memory system is designed to update itself without requiring a separate `/update_memory` call for routine workflow steps. Here is what triggers automatic capture:

| Trigger | `decisions.md` | `context.md` | `taxonomy.md` |
|---------|:-:|:-:|:-:|
| `/create_spec` — spec written | ✓ Out-of-scope decisions; net-new flag | — | ✓ New terms from spec body |
| `/update_backlog` — status → Done | ✓ "Shipped {feature}" | — | — |
| `/update_memory` — option 1 | ✓ | — | — |
| `/update_memory` — option 2 | — | ✓ | — |
| `/update_memory` — option 3 | — | — | ✓ |
| `/update_memory` — option 6 | ✓ if signals found | ✓ if signals found | ✓ if signals found |

If `memory/` does not exist for a product, all automatic steps skip silently. Run `/update_memory` → option to initialize to set it up.

---

## End-to-End PM Workflow

Below is the full sequence from opportunity through to handoff, showing which commands and agents are involved at each stage.

```
┌─────────────────────────────────────────────────────────┐
│  DISCOVER                                               │
│                                                         │
│  research_opportunity                                   │
│    → @market-researcher, @competitor-researcher,        │
│      @customer-researcher (parallel)                    │
│    → Output: thoughts/shared/research/YYYY-MM-DD-       │
│              opportunity-{slug}.md                      │
└────────────────────────────┬────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────┐
│  DEFINE                                                 │
│                                                         │
│  research_requirements                                  │
│    → Checks for OA; asks 10 product questions           │
│    → Output: thoughts/shared/requirements/              │
│              YYYY-MM-DD-prd-{slug}.md                   │
│    → Covers: personas, roadmap phases, functional       │
│              requirements, success metrics              │
└────────────────────────────┬────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────┐
│  SPEC                                                   │
│                                                         │
│  /create_spec                                           │
│    → @thoughts-locator (discovers relevant docs)        │
│    → @thoughts-analyzer ×3 parallel                     │
│      (PRD, prior specs, backlog/user-docs)              │
│    → Drafts spec; user confirms                         │
│    → Writes: thoughts/shared/specs/                     │
│              YYYY-MM-DD-spec-{slug}.md                  │
│    → Updates PRD (if prd_aligned)                       │
│    → @backlog-creator or @backlog-updater               │
│    → @memory-updater (auto — decisions + terms)         │
└────────────────────────────┬────────────────────────────┘
                             │
                    ╔════════▼════════╗
                    ║  HANDOFF TO     ║
                    ║  HYPRLAYER ENG  ║
                    ╚════════╤════════╝
                             │
┌────────────────────────────▼────────────────────────────┐
│  PLAN (HyprLayer)                                       │
│                                                         │
│  /create_plan                                           │
│    → Reads spec (acceptance criteria + success metrics) │
│    → Reads memory/context.md (product state)            │
│    → Reads memory/taxonomy.md (naming consistency)      │
│    → Output: thoughts/repos/{project}/shared/plans/     │
│    → Triggers: @backlog-updater ADD_PLAN_LINK           │
│                (sets status to In Progress)             │
└────────────────────────────┬────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────┐
│  IMPLEMENT → VALIDATE → COMMIT → REVIEW → SHIP          │
│  (HyprLayer engineering commands — unchanged)           │
└────────────────────────────┬────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────┐
│  CLOSE                                                  │
│                                                         │
│  /update_backlog → UPDATE_STATUS → Done                 │
│    → @backlog-updater sets row to Done                  │
│    → @memory-updater auto-logs "Shipped {feature}"      │
└─────────────────────────────────────────────────────────┘
```

---

## File Inventory

| File | Type | Version | Status |
|------|------|---------|--------|
| `create_spec.prompt.md` | Command | v1.3 | ✅ Complete |
| `update_backlog.prompt.md` | Command | v1.1 | ✅ Complete |
| `update_memory.prompt.md` | Command | v1.0 | ✅ Complete |
| `backlog-creator.agent.md` | Agent | — | ✅ Complete |
| `backlog-updater.agent.md` | Agent | — | ✅ Complete |
| `memory-updater.agent.md` | Agent | — | ✅ Complete |

### Inherited from HyprLayer (not modified)

| File | Role in PM layer |
|------|-----------------|
| `@thoughts-locator` | Document discovery for all PM commands |
| `@thoughts-analyzer` | Deep reading of OAs, PRDs, specs, backlog, memory files |
| `research_opportunity.prompt.md` | Produces OAs that feed into PRDs and spec context |
| `research_requirements.prompt.md` | Produces PRDs that specs inherit from |

---

## Planned Commands (Not Yet Built)

The following commands complete the PM workflow. They follow the same patterns established above.

| Command | Purpose | Key agents | Memory writes |
|---------|---------|------------|---------------|
| `/iterate_spec` | Revise a spec post-feedback or post-validation | `@thoughts-analyzer`, `@backlog-updater` | LOG_DECISION (why scope changed) |
| `/sprint_plan` | Scope a sprint from the backlog against team capacity | `@thoughts-analyzer` (backlog + specs) | UPDATE_CONTEXT (current sprint) |
| `/review_metrics` | Post-launch metrics review tied to a spec's success criteria | `@thoughts-analyzer` (spec + metrics) | LOG_DECISION (pivot or confirm), UPDATE_CONTEXT (what we learned) |
| `/stakeholder_update` | Generate a status update for leadership or engineering | `@thoughts-analyzer` (backlog + specs) | UPDATE_CONTEXT (if pivot present) |
| `/research_opportunity` | (Exists) Opportunity Assessment — already built in HyprLayer | Parallel research sub-agents | UPDATE_CONTEXT (market context) |

---

## Setup: New Product Onboarding

To initialize the PM layer for a new product:

1. **Run `research_opportunity`** if the problem space is not yet validated. Output lands in `thoughts/shared/research/`.
2. **Run `research_requirements`** to produce the PRD. Output lands in `thoughts/shared/requirements/`.
3. **Run `/update_memory`** and select Initialize. This creates the three empty memory files at `thoughts/shared/memory/`. Update `context.md` with the product phase, team, and active constraints. Add foundational terms to `taxonomy.md` from the PRD.
4. **Run `/create_spec`** for the first feature. It will create `backlog.md` automatically on first run (via `@backlog-creator`) and begin populating the registry.

From this point forward, the workflow is spec → backlog → plan → ship → memory, cycling per feature.

---

## Storage Backend Compatibility

All PM agents detect the HyprLayer storage backend before operating. Current support:

| Backend | Read | Write | Notes |
|---------|------|-------|-------|
| `git` | ✅ | ✅ | Default. Filesystem paths. |
| `obsidian` | ✅ | ✅ | Same filesystem path model as git. |
| `notion` | ✅ (via `@thoughts-analyzer`) | ❌ | Write operations not yet supported in backlog or memory agents. |
| `anytype` | ✅ (via `@thoughts-analyzer`) | ❌ | Write operations not yet supported. |

For Notion and Anytype backends: read-only operations (context gathering, OA/PRD analysis) work normally. Write operations (`@backlog-creator`, `@backlog-updater`, `@memory-updater`) will inform the caller they are unsupported and stop gracefully.

---

## Design Principles

**1. Specs are the handoff boundary.** Everything above a spec is PM work. Everything below is engineering work. The spec is the contract between them. It must be complete enough that an engineering agent can generate a valid plan without asking follow-up questions.

**2. Agents write; prompts orchestrate.** Prompt files contain workflow logic, ordering rules, and user interaction. Agent files contain file-system operations. No prompt file writes directly to thoughts — it always delegates to an agent. This keeps the write logic reusable across commands.

**3. Memory is ambient, not procedural.** The memory system updates passively during the normal workflow. A PM should never need to maintain it manually as a separate task. `/update_memory` exists for manual capture and corrections, but routine workflow steps handle the rest.

**4. Rationale is a first-class field.** A decision without a reason is just a fact. `@memory-updater` refuses to log a decision without a rationale. Over time this creates a record not just of what was built, but of why — which is the information that depreciates slowest.

**5. One backlog per product.** `backlog.md` is a single file that is the complete registry for a product. No per-sprint boards, no duplicated tracking. The parking lot captures pre-spec ideas in the same file so nothing lives outside the system.
