This folder contains skills, agents, and commands for a product manager to work through all stages of product management that complement engineering. Engineering has a parallel set of skills for research, plan, and implement — following a spec-driven-development pattern.

This file is the single source of truth for how the project is structured and maintained. `AGENTS.md` at the repo root points here for non-Claude agents.

---

## Plugin Structure

The `hyprlayer-pm` plugin lives at `hyprlayer-pm/` at the repo root:

```
hyprlayer-pm/
├── .claude-plugin/plugin.json   ← plugin manifest
├── skills/{name}/SKILL.md       ← 10 skills
├── agents/*.md                  ← 10 agents
└── commands/*.md                ← 6 slash commands
```

This repo is also a plugin marketplace. The catalog lives at `.claude-plugin/marketplace.json`.

## Install (Claude Code CLI)

```bash
# Add this repo as a marketplace
claude plugin marketplace add ./

# Install the plugin
claude plugin install hyprlayer-pm@hyprlayer-pm
```

Once installed, skills invoke as `/hyprlayer-pm:skill-name` and commands as `/hyprlayer-pm:discover`, `/hyprlayer-pm:spec`, etc. Agents load automatically.

## Install (Cowork)

1. Open **Customize** → **Browse plugins** → **Personal** → **+**
2. Select **Add marketplace from GitHub**
3. Enter: `koutsouros/hyprlayer-pm`

## Develop locally

```bash
claude --plugin-dir ./hyprlayer-pm
```

---

## Key Design Rules

**Skills vs. commands**
- **Skills = context and knowledge.** They define PM frameworks, workflows, and agent orchestration. Claude auto-loads a skill when the topic matches (e.g. `create_spec` when asked to write a spec). Skills are nouns/concepts.
- **Commands = user-triggered workflows.** They chain one or more skills and produce a concrete artifact (`/discover`, `/spec`, `/kickoff`). Commands are verbs.

**Naming conventions**
- Skill names: `lowercase_snake_case` action verb + noun — e.g. `research_opportunity`, `create_spec`, `iterate_prototype`. Verbs to use: `research`, `create`, `iterate`, `export`, `handoff`, `update`.
- A skill's `name` in frontmatter **must match its directory name exactly**.
- Command files: `kebab-case.md` — e.g. `discover.md`, `kickoff.md`.
- Agent files: `kebab-case.md` — e.g. `market-researcher.md`, `backlog-updater.md`.

**Frontmatter rules**
- Skills require `name` + `description` frontmatter (≤200 chars). The description is always loaded — write it to trigger at the right time, including key phrases a user would say.
- Commands require `description` + `argument-hint` frontmatter.
- Keep frontmatter lean (always loaded); put detail in the body (loaded when triggered) — progressive disclosure.

**No cross-plugin references**
- Since there is currently one plugin (`hyprlayer-pm`), all intra-plugin skill and command references are fine.
- If the plugin is ever split by phase, commands must only reference skills within the same plugin. Suggest follow-ups in natural language only — never hard-reference a command from a different plugin.

**thoughts/ coupling**
- Skills read from and write to `thoughts/` in the PM Product folder. This is required — skills are stateful and context-aware.
- `thoughts/global/shared/` holds cross-product templates. Skills read templates from here at runtime; never inline a template inside a skill.
- Memory files (`thoughts/shared/memory/decisions.md`, `context.md`, `taxonomy.md`) are the living product context. All agents treat them as authoritative.

**Claude Code is primary**
- When changes are made to skills, agents, or commands, update the Claude Code plugin (`hyprlayer-pm/`) first.
- Copilot and OpenCode equivalents live in `ai/other-providers/` and are synced manually — they are not the source of truth.

---

## What's Visible Where

| Location | Visible in | Notes |
|----------|-----------|-------|
| `marketplace.json` → `description` | Cowork marketplace browser, Claude Code | One-liner for the whole marketplace |
| `plugin.json` → `description` | Cowork plugin list, Claude Code | Per-plugin summary |
| `SKILL.md` frontmatter → `description` | Cowork skill list, Claude auto-loading | Include trigger phrases |
| Command frontmatter → `description` + `argument-hint` | Cowork and Claude Code (typing `/`) | Short and actionable |
| `README.md` (repo root) | GitHub only | Full docs; not loaded by Claude at runtime |

---

## Versioning

`marketplace.json`, `hyprlayer-pm/.claude-plugin/plugin.json`, and `CHANGELOG.md` must always carry the same version. Current version: **1.0.0**.

Semver rules: breaking changes = major; new skills, commands, or changed behavior = minor; fixes and docs = patch.

### After any skill, agent, or command change

1. Make changes in `hyprlayer-pm/` first.
2. Update the matching doc in `documentation/` if the user-facing behavior changed.
3. Sync the change to `ai/other-providers/` manually if relevant.
4. Update `README.md` skill/command counts if anything was added or removed.
5. Add a bullet to `CHANGELOG.md` under `## Unreleased`.

### At release time

Bump the version in all three places together:
- `.claude-plugin/marketplace.json` → `"version"`
- `hyprlayer-pm/.claude-plugin/plugin.json` → `"version"`
- `CHANGELOG.md` → rename `## Unreleased` to `## vX.Y.Z — YYYY-MM-DD`

### After a description change

- `plugin.json` description changed → check whether `README.md` needs the same edit (keep them aligned).
- `SKILL.md` description changed → no other sync needed.

---

## After Completing Work — Suggested Follow-ups

- After adding or removing skills/commands: "Should I update the counts in README.md?"
- After editing a `plugin.json` description: "Should I sync this to README.md?"
- After any user-facing change: "Want me to add a CHANGELOG bullet?"
- After a release: "Want me to bump the version across all three manifests?"
