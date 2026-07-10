# Tool Matrix — Capability Mapping

Tool-agnostic loop design: the **capability** is what matters, not the product name. This matrix maps each primitive to how it appears in major agent environments.

## Scheduling

| Tool | Mechanism | Example | Notes |
|------|-----------|---------|-------|
| **Grok Build TUI** | `/loop [interval]` | `/loop 1d Run triage` | Native scheduling, durable |
| **Claude Code** | `/loop`, cron | `/loop 5m /babysit` | Also supports hooks |
| **Codex** | Automations tab | Project → Automations → 1d | Server-side, survives restart |
| **Opencode** | cron/systemd | `0 9 * * * opencode run "..."` | Full control, headless |
| **Cursor** | Automations | Settings → Automations | Cloud Agents + triggers |
| **Windsurf** | Workflows + external cron | `/workflow` + GitHub Actions | Manual invoke or external |
| **Hermes** | `hermes cron create` | `hermes cron create "0 9 * * *" --skill ...` | Built-in cron gateway |

## State / Memory

| Tool | Pattern | Example |
|------|---------|---------|
| **All tools** | `STATE.md` at repo root | Machine-readable markdown |
| **Grok** | `STATE.md` + scheduler state | Durable scheduler persists |
| **Claude Code** | `STATE.md` + `AGENTS.md` | `AGENTS.md` for always-on rules |
| **Cursor** | `STATE.md` + Cloud memories | Memories persist across sessions |
| **Windsurf** | `STATE.md` + Cascade memories | Workflow run notes |

**Recommended state files:**
- `STATE.md` — general triage
- `issue-triage-state.md` — issue queue
- `pr-babysitter-state.md` — PR tracking
- `ci-sweeper-state.md` — CI failures

## Skills

| Tool | Format | Location | Invocation |
|------|--------|----------|------------|
| **Grok** | `SKILL.md` | `.grok/skills/` or `~/.grok/skills/` | Name in prompt |
| **Claude Code** | `SKILL.md` | `.claude/skills/` | `$skill-name` |
| **Codex** | `SKILL.md` | `.codex/skills/` | `$skill-name` |
| **Opencode** | `SKILL.md` | `skills/<name>/` | Auto-discovered |
| **Cursor** | `.mdc` rules | `.cursor/rules/` | Auto-apply by glob |
| **Windsurf** | Markdown rules | `.windsurf/rules/` | Always-on in Cascade |
| **Hermes** | `SKILL.md` | `~/.hermes/skills/` or `.hermes/skills/` | `--skill <name>` |

**Skill template:**
```markdown
# skill-name

## Purpose
One-sentence description.

## Steps
1. Read STATE.md
2. ...
3. Update STATE.md

## Constraints
- No code changes (week 1)
- Escalate ambiguous cases
```

## Worktrees

| Tool | Mechanism | Example |
|------|-----------|---------|
| **Grok** | `isolation: worktree` on subagents | `Task { isolation: "worktree" }` |
| **Claude Code** | `git worktree` | `git worktree add ../wt-fix -b loop/fix` |
| **Opencode** | `git worktree` + `--dir` | `opencode run "..." --dir $WORKTREE` |
| **Cursor** | `git worktree` per task | Cloud Agent isolation |
| **All tools** | Standard git worktree | `git worktree add <path> -b <branch>` |

**L2 requirement:** Every fix attempt must use an isolated worktree.

## Sub-agents

| Tool | Pattern | Example |
|------|---------|---------|
| **Grok** | `Task` with `subagent_type` | `Task { subagent_type: "implementer" }` |
| **Claude Code** | `.claude/agents/<role>.md` | `.claude/agents/reviewer.md` |
| **Opencode** | `--agent <name>` | `--agent implementer`, `--agent verifier` |
| **Cursor** | Review mode | Second pass with review-only instructions |
| **Windsurf** | Workflow steps | Implement → Review workflow |
| **Hermes** | `delegate_task` | `delegate_task(role='leaf', toolsets=['file'])` |

**Maker/checker pattern:**
1. Implementer works in worktree
2. Extract diff: `git diff > /tmp/diff.patch`
3. Verifier reviews **only the diff**
4. APPROVE → merge, REJECT → cleanup

## MCP / Connectors

| Tool | Mechanism | Example |
|------|-----------|---------|
| **Grok** | MCP servers | `CallMcpTool` |
| **Claude Code** | MCP servers + plugins | MCP config in `.claude/` |
| **Codex** | Connectors | GitHub, Linear, Slack |
| **Opencode** | MCP in `opencode.json` | GitHub/Linear via MCP bridge |
| **Cursor** | MCP in settings | Full connector access |
| **Windsurf** | MCP config | `mcp_config.json` |
| **Hermes** | `hermes mcp add` | Built-in Feishu, Slack, Discord |

## Quick Reference: Daily Triage Setup

### Grok
```bash
# Skills
cp templates/SKILL.md.loop-triage .grok/skills/loop-triage/

# Schedule
/loop 1d Run loop-triage. Read STATE.md first. Update High Priority. No code changes.
```

### Claude Code
```bash
# Skills
cp templates/SKILL.md.loop-triage .claude/skills/loop-triage/

# Schedule
/loop 1d $loop-triage — report-only week 1
```

### Opencode
```bash
# Skills
mkdir -p skills/loop-triage
cp templates/SKILL.md.loop-triage skills/loop-triage/SKILL.md

# Cron (crontab -e)
0 9 * * * cd /repo && opencode run "Run loop-triage. Update STATE.md."
```

### Cursor
```bash
# Skills
cp templates/SKILL.md.loop-triage .cursor/skills/loop-triage/

# Automations: Settings → Automations → New
# Trigger: cron "0 9 * * *"
# Prompt: "Run loop-triage skill. Read STATE.md..."
```

## Choosing a Tool

You do not need to pick one forever. A well-designed loop transfers:

1. **Write the skill** (tool-agnostic `SKILL.md`)
2. **Define state schema** (markdown or JSON)
3. **Document verification split** (who checks whom)
4. **Map scheduling** to your current TUI/editor/Action

**Start with your existing tool.** The patterns transfer.

## See Also

- [Primitives](./PRIMITIVES.md) — detailed primitive breakdown
- [Quickstart](./QUICKSTART.md) — first loop in 5 minutes
- [Examples](../examples/) — tool-specific implementations
