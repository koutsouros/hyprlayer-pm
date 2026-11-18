# Changelog

All notable changes to this project will be documented here.

The newest `## vX.Y.Z` heading is the released version. See `CLAUDE.md` for the release procedure.

---

## v1.0.0 — 2026-11-17

Initial release of the `hyprlayer-pm` Claude Code marketplace plugin.

- 10 skills: `research_opportunity`, `research_requirements`, `create_spec`, `iterate_spec`, `update_backlog`, `update_memory`, `create_prototype`, `iterate_prototype`, `handoff_prototype`, `export_prototype`
- 10 agents: `market-researcher`, `competitor-researcher`, `customer-researcher`, `business-researcher`, `technical-researcher`, `risk-researcher`, `backlog-creator`, `backlog-updater`, `memory-updater`, `prototype-builder`
- 6 slash commands: `/discover`, `/define`, `/spec`, `/prototype`, `/memory`, `/kickoff`
- Marketplace manifest at `.claude-plugin/marketplace.json`
- Shared artifact templates in `thoughts/global/shared/`
- Copilot and OpenCode sync copies in `ai/other-providers/`
