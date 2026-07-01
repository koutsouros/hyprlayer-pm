# Agents Reference

The PM layer uses nine agents — seven built specifically for PM and prototype work, two inherited from Hyprlayer. This document explains what each agent does, when it's called, and how to work with it.

---

## Design pattern

All PM agents follow the same structure:

1. **Detect storage backend first** — run `hyprlayer storage info --json` and read the `backend` field. This determines how documents are retrieved and written.
2. **Read before writing** — always read the full target file before making any change.
3. **Surgical edits only** — never rewrite an entire file when a targeted change will do.
4. **Report what changed** — return a structured summary of every change made.

Agents are called by prompt files (commands), not directly by users. If you need to trigger an agent behavior, run the corresponding command.

---

## Researcher Agents

Six specialist research agents are called by `research_opportunity`. They always run in parallel and write their findings to individual files before the synthesizing prompt combines them into the Opportunity Assessment.

All researcher agents share the same operating principles: no fabricated data, all data points confidence-labeled (`[HIGH]`, `[MEDIUM]`, `[LOW]`), all assumptions flagged with `[ASSUMPTION]`, all unknowns flagged with `[UNKNOWN]`, all sources cited with URLs.

---

### `@market-researcher`

**File:** `ai/copilot/agents/market-researcher.agent.md`  
**Called by:** `research_opportunity` (task 1 — Market Research)  
**Storage support:** web, search

Sizes the market and maps industry dynamics. Produces TAM/SAM/SOM estimates with sources, CAGR and growth trajectory, key trend analysis with timing signals (why now, window assessment), and adjacent market mapping. Cross-references market size estimates across at least two independent sources and notes any discrepancies.

**Output file:** `thoughts/shared/research/YYYY-MM-DD-market-researcher-{slug}.md`

---

### `@competitor-researcher`

**File:** `ai/copilot/agents/competitor-researcher.agent.md`  
**Called by:** `research_opportunity` (task 2 — Competitive Analysis)  
**Storage support:** web, search

Maps the competitive landscape. Produces profiles for direct competitors, indirect competitors, and substitutes; a feature comparison matrix (Has / Partial / Missing / Unknown); a positioning map; and white space analysis. Sources features from competitor websites, changelogs, G2/Capterra reviews, and Crunchbase.

**Output file:** `thoughts/shared/research/YYYY-MM-DD-competitor-researcher-{slug}.md`

---

### `@customer-researcher`

**File:** `ai/copilot/agents/customer-researcher.agent.md`  
**Called by:** `research_opportunity` (task 3 — Customer Needs)  
**Storage support:** web, search

Researches customer pain points, unmet needs, and demand signals. Documents how target users currently behave, what workarounds they use, and what segment-level needs exist. Does not invent user data — sources from reviews, forums, surveys, and public research.

**Output file:** `thoughts/shared/research/YYYY-MM-DD-customer-researcher-{slug}.md`

---

### `@business-researcher`

**File:** `ai/copilot/agents/business-researcher.agent.md`  
**Called by:** `research_opportunity` (task 4 — Business Viability)  
**Storage support:** web, search

Assesses business viability and strategic fit. Analyzes revenue model options, cost structure, ROI signals, and strategic alignment. Does not produce financial projections — documents what revenue models exist in comparable products and what cost structures look like.

**Output file:** `thoughts/shared/research/YYYY-MM-DD-business-researcher-{slug}.md`

---

### `@technical-researcher`

**File:** `ai/copilot/agents/technical-researcher.agent.md`  
**Called by:** `research_opportunity` (task 5 — Technical Landscape)  
**Storage support:** web, search

Maps the technology landscape. Produces build-vs-buy analysis, technology trend and maturity assessment, API and platform ecosystem mapping, and open-source option evaluation. Frames findings around technical feasibility signals relevant to the initiative.

**Output file:** `thoughts/shared/research/YYYY-MM-DD-technical-researcher-{slug}.md`

---

### `@risk-researcher`

**File:** `ai/copilot/agents/risk-researcher.agent.md`  
**Called by:** `research_opportunity` (task 6 — Risk Analysis)  
**Storage support:** web, search

Identifies and assesses risks across five dimensions: market, technical, organizational, regulatory, and financial. For each risk: likelihood, severity, and suggested mitigation direction. Does not prioritize what to build — documents risk as it exists so the PM can weigh it.

**Output file:** `thoughts/shared/research/YYYY-MM-DD-risk-researcher-{slug}.md`

---

## `@prototype-builder`

**File:** `ai/copilot/agents/prototype-builder.agent.md`  
**Called by:** `create_prototype`, `iterate_prototype`, `handoff_prototype`, `export_prototype`  
**Storage support:** filesystem (hyprlayer-prototypes monorepo)

Handles all file writes to the hyprlayer-prototypes monorepo. Never invoked directly by users. Reads `prototype-config.md` before every operation to resolve the repo path and enforce guardrails.

**Operations:**

| Operation | What it does |
|-----------|-------------|
| `INIT_PRODUCT_LINE` | Bootstraps a new product-line repo from scratch — directory structure, all `_template/` files, `git init`, initial commit, optional remote add |
| `SCAFFOLD` | Copies `_template/` to a new prototype path inside a product-line repo, stubs screens, writes `PROTOTYPE.md` |
| `ADD_SCREEN` | Creates a screen component with real interactions, generates typed JSON mock data, updates routing and manifest |
| `UPDATE_SCREEN` | Surgically modifies an existing screen — adds sections, wires interactions, extends data — without rewriting the full file |
| `UPDATE_MANIFEST` | Applies targeted updates to `PROTOTYPE.md` — status, decisions, screen rows, frontmatter |
| `BUILD_HANDOFF` | Runs `pnpm build`, verifies output, writes `HANDOFF.md`, marks prototype `ready-for-handoff` |

**Key behaviors:**
- Never writes to `_template/` — scaffold source is read-only
- Reads any file before modifying it
- Generates realistic mock data only — no `"string"`, `123`, or Lorem Ipsum placeholders
- All TypeScript must compile — no `any` types, no type errors
- Uses only Strong Tie Design System components — never builds custom UI from scratch when a design system primitive exists

**Prototype repo:** `https://github.com/koutsouros/hyprlayer-prototypes`  
**Local path (relative to PM repo):** `../hyprlayer-prototypes`

---

## `@backlog-creator`

**File:** `ai/copilot/agents/backlog-creator.agent.md`  
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

**File:** `ai/copilot/agents/backlog-updater.agent.md`  
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

**File:** `ai/copilot/agents/memory-updater.agent.md`  
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
research_opportunity
  └── @thoughts-locator    (discover existing research in thoughts/)
  └── [selected agents — all run IN PARALLEL]:
        @market-researcher      (if task 1 selected)
        @competitor-researcher  (if task 2 selected)
        @customer-researcher    (if task 3 selected)
        @business-researcher    (if task 4 selected)
        @technical-researcher   (if task 5 selected)
        @risk-researcher        (if task 6 selected)
  └── [synthesis — after all parallel agents complete]
        writes: thoughts/shared/research/YYYY-MM-DD-opportunity-{slug}.md

research_requirements
  └── [reads OA if provided — no agent call needed]
  └── [web research inline — research checklist]
  └── [drafts PRD directly — no agent delegation]
        writes: thoughts/shared/requirements/YYYY-MM-DD-prd-{slug}.md

/create_spec
  └── @thoughts-locator    (discover relevant files)
  └── @thoughts-analyzer × up to 3 parallel
        (PRD, prior specs, backlog/user-docs)
  └── @backlog-creator     (if no backlog.md)
   OR @backlog-updater     (if backlog.md exists)
  └── @memory-updater      (auto — decisions + terms)

/iterate_spec
  └── @thoughts-locator    (find spec file)
  └── @thoughts-analyzer   (read full spec) — parallel with:
  └── @thoughts-locator    (check backlog row + plan status)
  └── @memory-updater      (auto — scope cuts + new constraints)
  └── @backlog-updater     (only if status changed)

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

create_prototype
  └── [reads prototype-config.md — product line registry]
  └── [reads prototype-paths.local.md — resolves local repo path]
  └── IF new product line:
        @prototype-builder   INIT_PRODUCT_LINE
          creates: hyprlayer-prototypes-{slug}/ at local path
          writes:  prototype-paths.local.md entry
          updates: prototype-config.md registry row
  └── @thoughts-locator    (find spec, PRD, OA)
  └── @thoughts-analyzer × up to 3 parallel
        (spec, PRD, OA — extract flows, personas, constraints)
  └── @prototype-builder   SCAFFOLD
        writes: prototypes/{date}-{slug}/ in hyprlayer-prototypes-{product}
        writes: thoughts/shared/prototypes/{date}-prototype-{slug}.md

iterate_prototype
  └── [reads PROTOTYPE.md + all existing screen files]
  └── @thoughts-analyzer   (linked spec or PRD — checks scope alignment, surfaces unprototyped flows)
  └── @prototype-builder   ADD_SCREEN and/or UPDATE_SCREEN + UPDATE_MANIFEST
        (classifies each requested change internally — user does not choose operation)

handoff_prototype
  └── [reads PROTOTYPE.md from prototype repo]
  └── @thoughts-analyzer × parallel
        (decisions.md, taxonomy.md — check for duplicates)
  └── @memory-updater      (LOG_DECISION, ADD_TERM — confirmed only)
  └── @prototype-builder   UPDATE_MANIFEST (status → ready-for-handoff)

export_prototype
  └── [reads PROTOTYPE.md + scans src/ for component inventory]
  └── @prototype-builder   BUILD_HANDOFF
        writes: {prototype_path}/handoff/ (static build)
        writes: {prototype_path}/HANDOFF.md
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
