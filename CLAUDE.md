This folder contains a set of skills and agents for a product manager to work through all stages of product management that compliment engineering. Engineering has a similar set of commands, skills and agents for research, plan and implement, following a spec-driven-development pattern.

---

Any time new files are created or skills or agents are updated or deleted, always update the high level README.md file and relevant user docs in the documentation/ folder.  

Naming convention for skills: Each skill combines a lowercase action verb with a specific noun or target object, separated by an underscore (snake_case). Verbs to use when relevant: research, create, iterate, implement, and validate.

Any time changes are needed or made to an agent, skill, or command, ensure it is done for all three ai types (copilot, claude, and opencode) reflecting the needed changes required by the respective provider.

Claude Code skills and agents are packaged as a plugin at `ai/claude/`. Install the plugin locally with:

```
claude --plugin-dir ./ai/claude
```

Or install from the repo URL once published:

```
/plugin marketplace add https://github.com/koutsouros/hyprlayer-productmanagement
/plugin install hyprlayer-pm@hyprlayer-productmanagement
```

Once installed, skills are invoked as `/hyprlayer-pm:skill-name` (e.g. `/hyprlayer-pm:create_spec`). Agents are available automatically under the plugin namespace.

The plugin manifest lives at `ai/claude/.claude-plugin/plugin.json`. Skills live at `ai/claude/skills/{skill-name}/SKILL.md`. Agents live at `ai/claude/agents/*.md`.