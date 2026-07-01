# Hyprlayer-PM — OpenCode Project Context

This repo is the PM layer for Hyprlayer. It provides skills (commands) and agents for product managers working through opportunity assessment, requirements, specs, backlogs, memory, and prototyping.

## Structure

```
ai/opencode/
├── commands/   ← PM skills invoked with /command-name
└── agents/     ← subagents invoked via @ mention or automatically
thoughts/
└── global/shared/  ← prototype-config.md and artifact templates
documentation/      ← usage docs for each skill
```

## Available commands

| Command | What it does |
|---------|-------------|
| `/research_opportunity` | Parallel market, competitive, customer, and risk research → Opportunity Assessment |
| `/research_requirements` | Synthesize OA into a full PRD |
| `/create_spec` | Write a feature spec from a problem statement |
| `/iterate_spec` | Revise an existing spec in place |
| `/update_backlog` | Sync spec registry, update statuses, manage parking lot |
| `/update_memory` | Log decisions, update product context, add taxonomy terms |
| `/create_prototype` | Scaffold a new Vite + React prototype from PM artifacts |
| `/iterate_prototype` | Add or modify prototype screens in a single guided session |
| `/handoff_prototype` | Capture design decisions to memory; mark ready for engineering |
| `/export_prototype` | Build static HTML export and generate HANDOFF.md |

## Available subagents

Research agents (invoked in parallel by `/research_opportunity`):
`@market-researcher`, `@competitor-researcher`, `@customer-researcher`, `@business-researcher`, `@technical-researcher`, `@risk-researcher`

Workflow agents:
`@backlog-creator`, `@backlog-updater`, `@memory-updater`, `@prototype-builder`

## Working directory

Commands assume they are run from the PM Product folder — a Hyprlayer-initialized directory containing `thoughts/` (symlinked to the master thoughts directory) and `prototypes/` (the product-line prototype git repo). All file paths in commands are relative to this folder.
