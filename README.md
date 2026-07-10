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

```mermaid
flowchart TB
    subgraph Inputs["📥 Input Sources"]
        direction LR
        GH["🔔 GitHub Events"]
        CRON["⏰ Cron Schedules"]
        MANUAL["✋ Manual /loop"]
    end

    subgraph Core["🔧 Core Primitives"]
        direction TB
        subgraph Primitives["5 Building Blocks"]
            direction LR
            SCHED["📅 Scheduling"]
            STATE[("💾 State")]
            SKILLS["🧩 Skills"]
            WT["🌿 Worktrees"]
            SUB["👥 Sub-agents"]
        end
    end

    subgraph MCP["🔌 MCP Integration Layer"]
        direction LR
        MCP_HUB(("MCP Hub"))
        GH_MCP["🐙 GitHub"]
        LIN_MCP["📋 Linear"]
        SLK_MCP["💬 Slack"]
    end

    subgraph Outputs["📤 Output Actions"]
        direction LR
        STATE_UPD[("STATE.md")]
        PR_COM["💬 PR Comments"]
        FIXES["✅ Fix Commits"]
        REPS["📊 Reports"]
    end

    %% Input connections
    GH --> SCHED
    CRON --> SCHED
    MANUAL --> SCHED
    
    %% Core primitive connections
    SCHED --> STATE
    SCHED --> SKILLS
    SKILLS --> WT
    SKILLS --> SUB
    SKILLS --> MCP_HUB
    
    %% MCP connections
    MCP_HUB --> GH_MCP
    MCP_HUB --> LIN_MCP
    MCP_HUB --> SLK_MCP
    
    %% Output connections
    STATE --> STATE_UPD
    SKILLS --> PR_COM
    SKILLS --> REPS
    WT --> FIXES

    %% Styling
    classDef input fill:#dbeafe,stroke:#2563eb,stroke-width:2px,color:#1e40af
    classDef core fill:#fef3c7,stroke:#d97706,stroke-width:2px,color:#92400e
    classDef mcp fill:#e0e7ff,stroke:#4f46e5,stroke-width:2px,color:#3730a3
    classDef output fill:#dcfce7,stroke:#16a34a,stroke-width:2px,color:#166534
    
    class GH,CRON,MANUAL input
    class SCHED,STATE,SKILLS,WT,SUB core
    class MCP_HUB,GH_MCP,LIN_MCP,SLK_MCP mcp
    class STATE_UPD,PR_COM,FIXES,REPS output
```

<p align="center">
  <em>Open the <a href="docs/diagrams/agent-loops-architecture.html">interactive architecture diagram</a> or visit the <a href="docs/DIAGRAMS.md">Diagrams Documentation</a> for details.</em>
</p>

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

```mermaid
stateDiagram-v2
    [*] --> Triggered
    Triggered --> BudgetCheck
    BudgetCheck --> Triage: budget ok
    BudgetCheck --> EarlyExit: over budget
    Triage --> Executing
    Executing --> Verifying: submit
    Verifying --> Completed: verified
    Verifying --> Escalated: failed
    EarlyExit --> [*]
    Completed --> [*]
    Escalated --> [*]

    note right of Verifying
        loop-guard
        circuit breaker
    end note

    classDef start fill:#22c55e,color:#fff
    classDef active fill:#3b82f6,color:#fff
    classDef waiting fill:#f59e0b,color:#fff
    classDef success fill:#22c55e,color:#fff
    classDef failure fill:#ef4444,color:#fff
    
    class Triggered start
    class BudgetCheck,Triage,Executing active
    class Verifying waiting
    class Completed,EarlyExit success
    class Escalated failure
```

<p align="center">
  <em>Open the <a href="docs/diagrams/loop-execution-lifecycle.html">interactive lifecycle diagram</a> or visit the <a href="docs/DIAGRAMS.md">Diagrams Documentation</a> for details.</em>
</p>

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
