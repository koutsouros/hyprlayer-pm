# Hyprlayer-PM

The product management layer for Hyprlayer — spec-driven development from the PM side.

Hyprlayer-PM gives product managers a structured workflow that mirrors Hyprlayer's engineering workflow, producing artifacts that engineering agents can read directly without translation. A spec written by `/create_spec` becomes the primary input to `/create_plan`. A backlog maintained by `/update_backlog` tells engineers what is queued, in progress, or shipped. Memory captured across commands grounds every agent — PM or engineering — in the team's actual language and decisions.

Hyprlayer-PM uses the same `thoughts/` directory as Hyprlayer. PM artifacts live under `thoughts/shared/`; engineering artifacts continue to live under `thoughts/repos/`. Both sides read from the same memory files and the same storage backend.

---

## Relationship to Hyprlayer

Hyprlayer's engineering workflow starts at planning:

```
Research → Plan → Implement → Validate → Commit → Review → Ship
```

Hyprlayer-PM adds the upstream work that makes planning possible:

```
Opportunity → PRD → Spec  ──────────────────────────────  ✋ handoff  →  Plan → Implement → ...
└── PM layer (this repo) ─┘                               └── Hyprlayer engineering ──────────┘
                               ↕ (parallel, spec-driven)
                          Prototype → Iterate → Export
```

The handoff point is the spec. Everything before it is PM work. Everything from `/create_plan` onward is Hyprlayer engineering. The spec's acceptance criteria become the engineering plan's success criteria — the contract between them.

Prototyping runs in parallel with the spec phase. A prototype is grounded in the same PM artifacts (spec, PRD, OA) and its design decisions feed back into memory alongside spec decisions.

---

## Workflow

1. **Discover** (`research_opportunity`) — Synthesize market signals, competitive landscape, and customer evidence into an Opportunity Assessment
2. **Define** (`research_requirements`) — Translate the opportunity into a full PRD: personas, phased roadmap, functional requirements, success metrics
3. **Spec** (`/create_spec`) — Scope a single feature into a testable, engineering-ready spec with explicit AC and out-of-scope decisions
4. **Prototype** (`create_prototype` → `iterate_prototype`) — Build a high-fidelity prototype grounded in the spec; runs in parallel with spec refinement, not sequentially after it
5. **Maintain** (`/update_backlog`) — Track all specs through the registry from Todo → In Progress → Done; manage pre-spec ideas in the parking lot
6. **Iterate** (`/iterate_spec`) — Revise a spec when engineering raises a concern or scope changes; updates in place and logs the reason
7. **Capture** (`/update_memory`) — Log decisions, refresh product context, define terminology — or let routine commands handle it automatically

From Step 5 onward, the loop runs per feature until the product ships. Prototyping is optional but recommended before engineering handoff for complex UI flows.

---

## Commands

| Command | Description |
|---------|-------------|
| `/research_opportunity` | Produce an Opportunity Assessment from parallel market, competitive, and customer research |
| `/research_requirements` | Produce a PRD covering personas, roadmap phases, functional requirements, and success metrics |
| `/create_spec` | Write a feature-scoped spec that engineering can act on immediately — confirms draft before writing |
| `/update_backlog` | Sync the spec registry, update statuses, and manage parking lot ideas |
| `/iterate_spec` | Revise an existing spec in place; flags if a plan exists and may go stale |
| `/update_memory` | Log decisions, update product context, add terminology, or run a memory health check |
| `/plan_sprint` | *(planned)* Scope a sprint from the backlog against team capacity |
| `/review_metrics` | *(planned)* Post-launch metrics review tied to a spec's success criteria |
| `/stakeholder_update` | *(planned)* Generate a status update for leadership or engineering |
| `create_prototype` | Create a new Vite + React prototype from PM artifacts — bootstraps the product-line repo automatically on first use |
| `/iterate_prototype` | Add new screens, extend existing ones, or do both — reads existing prototype state and classifies each change automatically |
| `/handoff_prototype` | Capture prototype design decisions to memory; mark prototype ready for engineering |
| `/export_prototype` | Build a static HTML export package and generate an annotated `HANDOFF.md` for engineering |

For command details and usage examples, see [`documentation/`](documentation/).

### Slash Commands

Six slash commands chain or wrap the skills above for common workflows. Available after plugin install as `/hyprlayer-pm:<command>`.

| Command | Chains | What it does |
|---------|--------|-------------|
| `/discover <idea>` | `research_opportunity` | Full opportunity assessment — 6 researcher agents in parallel, synthesized into an OA |
| `/define` | `research_requirements` | PRD from an existing OA — personas, phased roadmap, functional requirements, success metrics |
| `/spec <feature>` | `create_spec` | Feature spec with AC, backlog registration, and automatic memory capture |
| `/prototype` | `create_prototype` | Vite + React prototype scaffolded from PM artifacts |
| `/memory` | `update_memory` | Log a decision, update context, add a term, or run a memory health check |
| `/kickoff <idea>` | `research_opportunity` → `research_requirements` → `update_memory` | End-to-end: OA → PRD → memory initialization in one chained session with confirmation pauses |

---

## Agents

PM commands delegate all file writes to agents. No command writes directly to thoughts.

### Researcher agents (called by `research_opportunity`)

All six run in parallel. Each writes its findings to a dedicated file before the synthesizing prompt combines them into the Opportunity Assessment.

| Agent | Research area |
|-------|--------------|
| `@market-researcher` | Market sizing (TAM/SAM/SOM), industry trends, timing signals, adjacent markets |
| `@competitor-researcher` | Competitive landscape, feature comparison matrices, positioning, white space |
| `@customer-researcher` | Pain points, unmet needs, demand signals, segment-level needs |
| `@business-researcher` | Revenue models, cost structure, strategic fit, ROI signals |
| `@technical-researcher` | Technology trends, platform capabilities, build vs. buy analysis |
| `@risk-researcher` | Market, technical, organizational, regulatory, and financial risks |

### PM workflow agents

| Agent | Called by | What it does |
|-------|-----------|-------------|
| `@backlog-creator` | `/create_spec`, `/update_backlog` | Creates `backlog.md` from scratch by scanning existing specs |
| `@backlog-updater` | `/create_spec`, `/update_backlog`, `/iterate_spec` | Applies surgical typed updates to an existing `backlog.md` |
| `@memory-updater` | `/create_spec` (auto), `/update_backlog` (auto), `/update_memory` | Maintains the three memory files; initializes gracefully if they don't exist |
| `@prototype-builder` | `create_prototype`, `iterate_prototype`, `handoff_prototype`, `export_prototype` | Scaffolds and maintains prototype projects across per-product-line repos (`hyprlayer-prototypes-{slug}`) |
| `@thoughts-locator` | All commands | *(Hyprlayer built-in)* Scans `thoughts/searchable/` for relevant files |
| `@thoughts-analyzer` | All commands | *(Hyprlayer built-in)* Deep-reads documents; extracts decisions, constraints, and actionable content |

See [`documentation/agents.md`](documentation/agents.md) for the full agent interaction map.

---

## Memory System

Three living files in `thoughts/shared/memory/` give every agent a shared orientation without re-reading every artifact:

| File | Nature | What it captures |
|------|--------|-----------------|
| `decisions.md` | Append-only | Every meaningful product decision with its rationale — why things were built or cut |
| `context.md` | Section-overwrite | What is true right now: current sprint, active constraints, team, key links |
| `taxonomy.md` | Append-only terms table | Product-specific language — ensures the spec, plan, codebase, and docs use the same words |

Most memory updates happen automatically during the normal workflow:

| Trigger | What's captured |
|---------|----------------|
| `/create_spec` — spec confirmed | Out-of-scope decisions; new terms from the spec body |
| `/iterate_spec` — scope cut or new constraint | The reason the scope changed |
| `/update_backlog` — status → Done | "Shipped {feature}" |

If `memory/` doesn't exist, automatic steps skip silently. Run `/update_memory` → Initialize to set it up.

See [`documentation/memory-system.md`](documentation/memory-system.md) for a full explanation.

---

## Artifact Hierarchy

```
Opportunity Assessment (OA)     thoughts/shared/research/
         ↓
Product Requirements Doc (PRD)  thoughts/shared/requirements/
         ↓
Feature Spec                    thoughts/shared/specs/
         ↓
Engineering Plan                thoughts/repos/{project}/shared/plans/
(Hyprlayer /create_plan)
```

Each level inherits from the level above. A spec references personas from the PRD — it does not redefine them. An engineering plan uses the spec's acceptance criteria as planning constraints — it does not re-state them.

See [`documentation/artifact-hierarchy.md`](documentation/artifact-hierarchy.md) for when to use each artifact.

---

## Shared Templates

Cross-product artifact templates live in `thoughts/global/shared/`. Every skill that produces a PM artifact reads the matching template from here at runtime — there is no inline template duplicated inside the skill itself.

| Template | Used by | Artifact type |
|----------|---------|---------------|
| `oa-template.md` | `research_opportunity` | Opportunity Assessment |
| `prd-template.md` | `research_requirements` | Product Requirements Doc |
| `spec-template.md` | `create_spec` | Feature Spec |
| `backlog-template.md` | `update_backlog` (on first create) | Backlog registry |

### Unified Metadata Schema

All PM artifacts share a consistent 10-field YAML frontmatter block:

```yaml
title: "..."
type: research | plan | note
date: YYYY-MM-DD
status: draft | active | complete
ticket: ""
project: "product-slug"
scope: shared
tags: [...]
author: "..."
related: []
```

This schema is backend-portable — the same fields map to git/Obsidian frontmatter, Notion database properties, and Anytype type properties.

---

## Storage Backends

Hyprlayer-PM uses whatever storage backend Hyprlayer is configured with. Run `Hyprlayer storage info --json` inside a project to see the active backend.

| Backend | Read | Write | Notes |
|---------|:----:|:-----:|-------|
| `git` | ✅ | ✅ | Default. Filesystem paths and YAML frontmatter. |
| `obsidian` | ✅ | ✅ | Same filesystem path model as git. |
| `notion` | ✅ | ❌ | Read via `@thoughts-analyzer`; write operations unsupported. |
| `anytype` | ✅ | ❌ | Read via `@thoughts-analyzer`; write operations unsupported. |

For Notion and Anytype backends, all read operations (context gathering, PRD and spec analysis) work normally. Write operations (`@backlog-creator`, `@backlog-updater`, `@memory-updater`) stop gracefully and inform the caller.

---

## Setup

To initialize Hyprlayer-PM for a new product:

1. **Run `research_opportunity`** to produce an Opportunity Assessment (skip if the problem space is already validated)
2. **Run `research_requirements`** to produce the PRD
3. **Run `/update_memory`** → Initialize to create the three memory files; seed `context.md` with the product phase and team, and add foundational terms from the PRD
4. **Run `/create_spec`** for the first feature — it creates `backlog.md` automatically on first run

From this point forward, the workflow is spec → backlog → plan → ship → memory, repeating per feature.

**Prototyping requires no additional setup.** When you're ready to prototype a feature, run `create_prototype` — it handles everything: resolving or creating the product-line repo, scaffolding the prototype, and wiring it to your PM artifacts. The first time you prototype a product, it will ask for a local path and walk you through pushing to GitHub. After that, subsequent prototypes for the same product go straight to scaffolding.

---

## Supported AI Tools

**Claude Code and Cowork are the primary tools.** The plugin lives at `hyprlayer-pm/` at the repo root; this repo is also a Claude Code plugin marketplace.

| Tool | Format | Location | Project context |
|------|--------|----------|-----------------|
| **Claude Code** | Plugin (`skills/` + `agents/` + `commands/`) | `hyprlayer-pm/` | `CLAUDE.md` |
| **Cowork** | Same plugin via marketplace | `hyprlayer-pm/` | `CLAUDE.md` |
| **GitHub Copilot** | `.prompt.md` / `.agent.md` | `ai/other-providers/copilot/` | Copy instructions in `ai/other-providers/README.md` |
| **OpenCode** | `.md` commands + agents | `ai/other-providers/opencode/` | Copy instructions in `ai/other-providers/README.md` |

### Claude Code — Marketplace Install

This repo is a Claude Code plugin marketplace. The catalog lives at `.claude-plugin/marketplace.json`.

```bash
# Add this repo as a marketplace (run once)
claude plugin marketplace add ./

# Install the plugin
claude plugin install hyprlayer-pm@hyprlayer-pm
```

Once installed, skills invoke as `/hyprlayer-pm:skill-name` and slash commands as `/hyprlayer-pm:discover`, `/hyprlayer-pm:spec`, etc. Agents load automatically.

### Cowork — Marketplace Install

1. Open **Customize** → **Browse plugins** → **Personal** → **+**
2. Select **Add marketplace from GitHub**
3. Enter: `koutsouros/hyprlayer-pm`

### Local development

```bash
claude --plugin-dir ./hyprlayer-pm
```

### Copilot & OpenCode — Manual Sync

Skill files in `ai/other-providers/` can be copied manually. See `ai/other-providers/README.md` for copy instructions and a sync table showing all 10 skills across providers.
