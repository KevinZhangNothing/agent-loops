# Agent Loops

> **Stop prompting. Design the loop. Get a score.**

For developers using Grok, Claude Code, Codex, Cursor, and other AI coding agents.

---

<p align="center">
  <strong>🌐 Select Language:</strong>
  <a href="README.md">English</a> ·
  <a href="README.zh-CN.md">简体中文</a>
</p>

---

```bash
npx @kevinzhangnothing/loop-init .
```

Agent loops replace you as the person who prompts the agent — you design the system that does it instead.

<p align="center">
  <a href="https://github.com/KevinZhangNothing/agent-loops/stargazers"><img src="https://img.shields.io/github/stars/KevinZhangNothing/agent-loops?style=social" alt="GitHub stars"></a>
  <a href="https://github.com/KevinZhangNothing/agent-loops/actions/workflows/audit.yml"><img src="https://img.shields.io/github/actions/workflow/status/KevinZhangNothing/agent-loops/audit.yml?label=loop-audit%20dogfood" alt="loop-audit dogfood"></a>
  <a href="https://www.npmjs.com/package/@kevinzhangnothing/loop-audit"><img src="https://img.shields.io/npm/v/@kevinzhangnothing/loop-audit?label=loop-audit" alt="npm"></a>
  <a href="https://www.npmjs.com/package/@kevinzhangnothing/loop-init"><img src="https://img.shields.io/npm/v/@kevinzhangnothing/loop-init?label=loop-init" alt="npm"></a>
  <a href="https://github.com/KevinZhangNothing/agent-loops/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT"></a>
</p>

## Quick Start

**5 minutes to your first loop:**

```bash
# 1. Scaffold (prints Loop Ready score)
npx @kevinzhangnothing/loop-init . --pattern daily-triage --tool grok

# 2. Check token cost
npx @kevinzhangnothing/loop-cost --pattern daily-triage --level L1

# 3. Audit + get next steps
npx @kevinzhangnothing/loop-audit . --suggest

# 4. Run your first loop (report-only, week 1)
/loop 1d Run loop-triage. Update STATE.md. No auto-fix.
```

👉 **[Full Quickstart Guide →](docs/QUICKSTART.md)**

## What Are Agent Loops?

> "You shouldn't be prompting coding agents anymore. You should be designing loops that prompt your agents."

### Architecture Overview

**📐 Interactive Diagram** (opens in new tab)

> **View:** [Open Architecture Diagram →](docs/diagrams/agent-loops-architecture.html)
> 
> **Features:** 🌓 Dark/Light theme · 📥 Export PNG/SVG (up to 4×) · 🔍 Zoom & Pan

**Key Components:**

| Layer | Components |
|-------|------------|
| **Input Sources** | GitHub Events, Cron Schedules, Manual `/loop` commands |
| **Core Primitives** | Scheduling, State, Skills, Worktrees, Sub-agents |
| **MCP Integration** | GitHub MCP, Linear MCP, Slack MCP |
| **Output Actions** | STATE.md updates, PR Comments, Fix Commits, Reports |

| Primitive | Purpose |
|-----------|---------|
| **Scheduling** | Run triage on a cadence (cron, `/loop`, Automations) |
| **State** | Persistent memory outside any conversation (`STATE.md`) |
| **Skills** | Reusable capabilities (`SKILL.md`) |
| **Worktrees** | Safe parallel execution (isolated git worktrees) |
| **Sub-agents** | Maker/checker split for verification |
| **MCP** | Connect to real tools (GitHub, Linear, Slack) |

**[Core Concepts →](docs/CONCEPTS.md)** | **[Primitives →](docs/PRIMITIVES.md)**

## Patterns

| Pattern | Cadence | Week 1 | Token Cost |
|---------|---------|--------|------------|
| [Daily Triage](patterns/daily-triage.md) | 1d–2h | Report only | Low |
| [PR Babysitter](patterns/pr-babysitter.md) | 5–15m | Watch only | High |
| [CI Sweeper](patterns/ci-sweeper.md) | 5–15m | Cautious fixes | Very high |
| [Dependency Sweeper](patterns/dependency-sweeper.md) | 6h–1d | Patch-only | Medium |
| [Changelog Drafter](patterns/changelog-drafter.md) | 1d or tag | Draft only | Low |
| [Issue Triage](patterns/issue-triage.md) | 2h–1d | Propose only | Low |

### Execution Flow

**🔄 Interactive Diagram** (opens in new tab)

> **View:** [Open Lifecycle Diagram →](docs/diagrams/loop-execution-lifecycle.html)
>
> **Features:** 🌓 Dark/Light theme · 📥 Export PNG/SVG · State machine visualization

**Lifecycle States:**

| State | Description | Next |
|-------|-------------|------|
| **Triggered** | Loop activated by cron/event | Budget Check |
| **Budget Check** | Token cap validation | Triage or Early Exit |
| **Triage** | Prioritization | Executing |
| **Executing** | Skill execution | Verification |
| **Verifying** | loop-verifier + loop-guard | Completed or Escalated |
| **Completed** | Success, state updated | — |
| **Escalated** | Failed verification | Human review |

### Pattern Comparison

**📊 Interactive Diagram** (opens in new tab)

> **View:** [Open Patterns Workflow →](docs/diagrams/loop-patterns-workflow.html)
>
> **Shows:** Side-by-side comparison of Daily Triage (L1) · PR Babysitter (L2) · CI Sweeper (L2) · Dependency Sweeper (L2)

👉 **[All Patterns →](patterns/README.md)** | **[Pattern Picker →](docs/PATTERN_PICKER.md)**

## Tools

**Install from npm:**
```bash
npx @kevinzhangnothing/loop-init . --pattern daily-triage --tool grok
npx @kevinzhangnothing/loop-audit . --suggest
npx @kevinzhangnothing/loop-cost --pattern daily-triage --level L1
```

**Run from source (monorepo):**
```bash
npm run build:tools  # Build all tools
node tools/loop-init/dist/cli.js . --pattern daily-triage
node tools/loop-audit/dist/cli.js . --suggest
node tools/loop-cost/dist/cli.js --pattern daily-triage --level L1
```

| Tool | npm Package | Description |
|------|-------------|-------------|
| `loop-init` | `@kevinzhangnothing/loop-init` | Scaffold loop + print readiness score |
| `loop-audit` | `@kevinzhangnothing/loop-audit` | Score readiness + get next steps |
| `loop-cost` | `@kevinzhangnothing/loop-cost` | Estimate token spend by cadence |
| `loop-sync` | `@kevinzhangnothing/loop-sync` | Detect STATE.md ↔ LOOP.md drift |
| `loop-context` | `@kevinzhangnothing/loop-context` | Stateful memory + circuit breaker |
| `loop-worktree` | `@kevinzhangnothing/loop-worktree` | Isolated git worktrees per fix |
| `loop-mcp-server` | `@kevinzhangnothing/loop-mcp-server` | MCP runtime lookup |

**[Tools Documentation →](tools/README.md)**

## Examples by Tool

- **[Grok](examples/grok/daily-triage.md)** — `/loop` scheduling
- **[Claude Code](examples/claude-code/)** — `/loop` + skills
- **[Codex](examples/codex/)** — Automations tab
- **[Opencode](examples/opencode/)** — cron/systemd + `opencode run`
- **[Cursor](examples/cursor/)** — Automations + rules
- **[GitHub Actions](examples/github-actions/)** — CI-native loops

## Project State

This repo dogfoods its own patterns:

| File | Purpose |
|------|---------|
| [`STATE.md`](STATE.md) | Current loop state (live) |
| [`LOOP.md`](LOOP.md) | Active loops and cadence |
| [`loop-budget.md`](loop-budget.md) | Token caps and kill switch |
| [`loop-run-log.md`](loop-run-log.md) | Run history |

## Contributing

Share production patterns, tool examples, and failure stories.

**First PR?** Start with [`good first issues`](https://github.com/KevinZhangNothing/agent-loops/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22)

👉 **[Contributing Guide →](CONTRIBUTING.md)** | **[Add Your Project →](docs/adopters.md)**

## Documentation

### Core

| Doc | Description |
|-----|-------------|
| **[Quickstart](docs/QUICKSTART.md)** | 5-minute path from zero to first loop |
| **[Concepts](docs/CONCEPTS.md)** | Intent debt, comprehension debt, harness vs loop |
| **[Primitives](docs/PRIMITIVES.md)** | The 5 building blocks + memory |
| **[Safety](docs/SAFETY.md)** | Denylists, auto-merge policy, MCP scopes |
| **[Tool Matrix](docs/TOOL_MATRIX.md)** | Cross-tool capability mapping |

### Integration

| Doc | Description |
|-----|-------------|
| **[pi Integration](docs/PI-INTEGRATION.md)** | pi coding agent integration (12 skills, 3 workflows) |
| **[Publishing](docs/PUBLISH.md)** | npm package publishing guide |

### Community

| Doc | Description |
|-----|-------------|
| **[Adopters](docs/adopters.md)** | Projects using agent loops |
| **[Contributing](CONTRIBUTING.md)** | Contribution guidelines |

## License

MIT — see [LICENSE](LICENSE)

---

*Practical reference for designing systems that prompt AI coding agents.*
