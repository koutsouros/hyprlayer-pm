# Other AI Providers

The primary AI tooling for this project is **Claude Code** via the `hyprlayer-pm` plugin at the repo root. The skills and agents here are retained as a reference for teams using other AI tools.

## GitHub Copilot

Skills are in `copilot/prompts/` as `.prompt.md` files. Agents are in `copilot/agents/` as `.agent.md` files.

To use these in Copilot:

```bash
# Copy prompts
cp copilot/prompts/*.prompt.md ~/.copilot/prompts/

# Copy agents
cp copilot/agents/*.agent.md ~/.copilot/agents/
```

Then reference them in Copilot Chat with `@agent-name` or attach a `.prompt.md` file to your chat.

## OpenCode

Skills are in `opencode/commands/` as `.md` files. Agents are in `opencode/agents/` as `.md` files.

To use these in OpenCode:

```bash
# Copy commands (project-level)
cp opencode/commands/*.md .opencode/commands/

# Copy agents (project-level)
cp opencode/agents/*.md .opencode/agents/
```

Or copy to your global OpenCode config (`~/.opencode/`) to use across all projects.

## Keeping in Sync

These files are kept in sync with the Claude Code skills for reference. If you update a skill in `hyprlayer-pm/skills/`, reflect the change here manually — the content is equivalent, the format differs by provider.

| Skill | Claude Code | Copilot | OpenCode |
|---|---|---|---|
| research_opportunity | `hyprlayer-pm/skills/research_opportunity/SKILL.md` | `copilot/prompts/research_opportunity.prompt.md` | `opencode/commands/research_opportunity.md` |
| research_requirements | `hyprlayer-pm/skills/research_requirements/SKILL.md` | `copilot/prompts/research_requirements.prompt.md` | `opencode/commands/research_requirements.md` |
| create_spec | `hyprlayer-pm/skills/create_spec/SKILL.md` | `copilot/prompts/create_spec.prompt.md` | `opencode/commands/create_spec.md` |
| update_backlog | `hyprlayer-pm/skills/update_backlog/SKILL.md` | `copilot/prompts/update_backlog.prompt.md` | `opencode/commands/update_backlog.md` |
| iterate_spec | `hyprlayer-pm/skills/iterate_spec/SKILL.md` | `copilot/prompts/iterate_spec.prompt.md` | `opencode/commands/iterate_spec.md` |
| update_memory | `hyprlayer-pm/skills/update_memory/SKILL.md` | `copilot/prompts/update_memory.prompt.md` | `opencode/commands/update_memory.md` |
| create_prototype | `hyprlayer-pm/skills/create_prototype/SKILL.md` | `copilot/prompts/create_prototype.prompt.md` | `opencode/commands/create_prototype.md` |
| iterate_prototype | `hyprlayer-pm/skills/iterate_prototype/SKILL.md` | `copilot/prompts/iterate_prototype.prompt.md` | `opencode/commands/iterate_prototype.md` |
| handoff_prototype | `hyprlayer-pm/skills/handoff_prototype/SKILL.md` | `copilot/prompts/handoff_prototype.prompt.md` | `opencode/commands/handoff_prototype.md` |
| export_prototype | `hyprlayer-pm/skills/export_prototype/SKILL.md` | `copilot/prompts/export_prototype.prompt.md` | `opencode/commands/export_prototype.md` |
