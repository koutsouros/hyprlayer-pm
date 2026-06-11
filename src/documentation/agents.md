# Agents Reference

The PM layer uses five agents — three built specifically for PM work, two inherited from HyprLayer. This document explains what each agent does, when it's called, and how to work with it.

---

## Design pattern

All PM agents follow the same structure:

1. **Detect storage backend first** — run `hyprlayer storage info --json` and read the `backend` field. This determines how documents are retrieved and written.
2. **Read before writing** — always read the full target file before making any change.
3. **Surgical edits only** — never rewrite an entire file when a targeted change will do.
4. **Report what changed** — return a structured summary of every change made.

Agents are called by prompt files (commands), not directly by users. If you need to trigger an agent behavior, run the corresponding command.

---

## `@backlog-creator`

**File:** `src/copilot/agents/backlog-creator.agent.md`  
**Called by:** `/create_spec` (when no backlog exists), `/update_backlog`  
**Storage support:** git, Obsidian

Creates `backlog.md` from scratch for a product. Scans `thoughts/searchable/shared/specs/` for all existing spec files, reads each spec's frontmatter to derive feature name and status, and writes a fully-populated registry table.

**Key behaviors:**
- Guards against overwriting — stops immediately if `backlog.md` already exists and tells the caller to use `@backlog-updater` instead
- Derives the feature name from the spec's H1 heading (`# Spec: Name`) first, then falls back to the filename slug
- Maps spec `status` frontmatter to backlog status: `draft` and `ready` → `Todo`; `implemented` → `Done`
- Marks specs with `prd_aligned: false` with a "Not in PRD" note in the registry

**Output:** `thoughts/shared/backlog/backlog.md` with a populated Spec Registry table and four empty Parking Lot sections

---

## `@backlog-updater`

**File:** `src/copilot/agents/backlog-updater.agent.md`  
**Called by:** `/create_spec`, `/update_backlog`  
**Storage support:** git, Obsidian

Applies surgical, typed updates to an existing `backlog.md`. Reads the full file before every operation.

**Operations:**

| Operation | What it does |
|-----------|-------------|
| `ADD_ROW` | Appends a new spec row with status `Todo` |
| `UPDATE_STATUS` | Changes a row's status cell by spec slug |
| `ADD_PLAN_LINK` | Adds an eng plan link; sets status to `In Progress` |
| `PARKING_LOT_ADD` | Appends a bullet to a named parking lot section |
| `PARKING_LOT_REMOVE` | Removes a bullet (case-insensitive partial match) |
| `FULL_SYNC` | Reconciles registry against spec files on disk |

**Path rules:**
- All paths written to the file are relative to `backlog/`
- Specs: `../specs/YYYY-MM-DD-spec-{slug}.md`
- Plans: `../../repos/{project}/shared/plans/...`
- Never writes absolute filesystem paths

**FULL_SYNC behavior:** Adds rows for specs not in the registry; flags orphaned rows (registry entry with no matching spec file) with `⚠️ spec file not found` in Notes; never changes the status of existing rows.

---

## `@memory-updater`

**File:** `src/copilot/agents/memory-updater.agent.md`  
**Called by:** `/create_spec` (automatic), `/update_backlog` Done transitions (automatic), `/update_memory`  
**Storage support:** git, Obsidian

Maintains the three memory files. Unlike the backlog agents, `@memory-updater` initializes files gracefully — if a target file doesn't exist, it creates it from the embedded template before applying the operation. It never fails with "file not found."

**Operations:**

| Operation | File | What it does |
|-----------|------|-------------|
| `LOG_DECISION` | `decisions.md` | Appends a row. Rationale required — rejects entries without one. |
| `AMEND_DECISION` | `decisions.md` | Adds a `↩ Reversed:` row below the original. Never removes the original. |
| `UPDATE_CONTEXT` | `context.md` | Replaces specified sections only; leaves all others unchanged. |
| `ADD_TERM` | `taxonomy.md` | Appends a row. Checks for duplicates first. |
| `AMEND_TERM` | `taxonomy.md` | Updates a term definition in place; notes amendment date and reason. |
| `REMOVE_TERM` | `taxonomy.md` | Removes a row; leaves an HTML comment noting the date and reason. |
| `CONSOLIDATE` | All three | Read-only health check — reports issues, no writes. |
| `INIT` | All three | Creates empty files from templates for a new product. |

**Important:** `decisions.md` and the Terms table in `taxonomy.md` are append-only — rows are never removed without an explicit `REMOVE_TERM` or `AMEND_DECISION` operation. `context.md` is section-scoped — only the specified sections are replaced.

---

## `@thoughts-locator` *(HyprLayer built-in)*

**Not a PM-layer file** — inherited from HyprLayer, used by all PM commands.

Scans the `thoughts/searchable/` index and returns a list of file paths with one-line descriptions of what each file contains. It is always invoked *before* `@thoughts-analyzer` — you need to know what exists before you can read it.

**PM commands invoke it to scan:**
- `thoughts/shared/research/` — Opportunity Assessments
- `thoughts/shared/requirements/` — PRDs
- `thoughts/shared/specs/` — prior specs
- `thoughts/shared/backlog/backlog.md` — spec registry and parking lot
- `thoughts/shared/user-docs/` — user documentation
- `thoughts/shared/metrics/` — post-launch metrics reviews
- `thoughts/global/shared/` — cross-product personas and principles
- `thoughts/shared/memory/` — memory files

**Path handling:** Always strip `searchable/` from any path returned by this agent before writing it to a file.

---

## `@thoughts-analyzer` *(HyprLayer built-in)*

**Not a PM-layer file** — inherited from HyprLayer, used by all PM commands.

Deep-reads a document and returns only the most relevant, actionable content. Filters aggressively — removes exploratory rambling, rejected options, and superseded information. Returns key decisions, critical constraints, technical specifications, and actionable insights.

**Backend detection:** Detects storage backend on every invocation and retrieves documents accordingly:
- `git` / `Obsidian` — reads directly from the filesystem path
- `Notion` — calls page-retrieve and block-children APIs
- `Anytype` — calls the object retrieval API

**Cross-project check:** After retrieval, compares the document's `project` field against the current repo's `mappedName`. If they differ, it calls this out at the top of the analysis.

**PM commands invoke it for:**
- Reading the PRD to extract feature alignment, personas, and success metrics
- Reading prior specs to extract scope patterns and related features
- Reading `backlog.md` fully before any backlog write
- Reading memory files before any memory update

---

## Agent interaction map

```
/create_spec
  └── @thoughts-locator    (discover relevant files)
  └── @thoughts-analyzer × up to 3 parallel
        (PRD, prior specs, backlog/user-docs)
  └── @backlog-creator     (if no backlog.md)
   OR @backlog-updater     (if backlog.md exists)
  └── @memory-updater      (auto — decisions + terms)

/update_backlog
  └── @thoughts-locator    (find backlog.md)
  └── @thoughts-analyzer   (read backlog.md in full)
  └── @backlog-creator     (if no backlog.md)
   OR @backlog-updater     (if backlog.md exists)
  └── @memory-updater      (auto — Done transitions only)

/update_memory
  └── @thoughts-locator    (check memory/ exists)
  └── @thoughts-analyzer   (read relevant memory files)
  └── @memory-updater      (apply confirmed operations)
```

---

## Extending an agent

All agent files follow the same format:

```yaml
---
name: agent-name
description: one-line description used by the caller to identify the agent
tools: ['execute', 'read', 'write', 'search']
---
```

Followed by plain markdown with:
- Storage backend detection (always first)
- Core responsibilities
- Operations (typed, with caller-provided fields and step-by-step behavior)
- Output format
- Important guidelines

To add a new operation to an existing agent, add a new `### OPERATION_NAME` section under Operations with the same structure as the existing ones: caller inputs → steps → output.

To create a new agent, use `backlog-updater.agent.md` or `memory-updater.agent.md` as the template — they represent the most fully-developed examples of the pattern.
