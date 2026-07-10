# Agent Loops Diagrams

Interactive architecture and workflow diagrams for understanding Agent Loops.

> **📖 How to view:** These are interactive HTML diagrams. Click any link to open in a new browser tab. Each HTML file is self-contained with embedded SVG, theme toggle, and export features.

<p align="center">
  <strong>🌐 Select Language:</strong>
  <a href="./DIAGRAMS.md">English</a> ·
  <a href="zh-CN/DIAGRAMS.md">简体中文</a>
</p>

---

## 📐 Architecture Diagram

**Agent Loops System Architecture** — Shows the complete system layout with all core components, external integrations, and data flow.

**[→ Open Architecture Diagram](diagrams/agent-loops-architecture.html)** *(opens in new tab)*

### Key Components

- **Input Sources** (Top): GitHub Events, Cron Schedules, Manual `/loop` commands
- **Core Primitives** (Middle): The 5 building blocks of every agent loop
  - Scheduling — cadence management, automations
  - State — persistent memory via `STATE.md`
  - Skills — reusable capabilities via `SKILL.md`
  - Worktrees — isolated git execution environments
  - Sub-agents — maker/checker verification split
- **MCP Hub** (Center): Model Context Protocol integration layer
- **External Tools** (Bottom): GitHub, Linear, Slack MCP servers
- **Output Actions** (Bottom): State updates, PR comments, fix commits, reports

### Features

- 🌓 **Dark/Light theme toggle** — Click the theme button (persists in localStorage)
- 📥 **Export menu** — Download PNG (up to 4×), JPEG, WebP, or dual-theme SVG
- 🔍 **Zoom & Pan** — Explore detailed component relationships

---

## 🔄 Execution Lifecycle

**Agent Loop Execution Lifecycle** — State machine showing the complete execution flow from trigger to completion, including verification gates and error handling.

**[→ Open Lifecycle Diagram](diagrams/loop-execution-lifecycle.html)** *(opens in new tab)*

### States

| State | Lane | Description |
|-------|------|-------------|
| **Triggered** | Main | Loop activated by cron, event, or manual command |
| **Budget Check** | Main | Token budget and scope validation |
| **Triage** | Main | Prioritization and planning |
| **Executing** | Main | Skill execution in isolated worktree |
| **Verifying** | Waiting | loop-verifier and loop-guard checks |
| **Completed** | Terminal | Successful state update and logging |
| **Early Exit** | Terminal | Budget exceeded or no actionable work |
| **Escalated** | Terminal | Verification failed, human review required |

### Transitions

- **Happy Path**: Triggered → Budget Check → Triage → Executing → Verifying → Completed
- **Budget Exit**: Budget Check → Early Exit (when over token cap)
- **Escalation**: Verifying → Escalated (when verification fails or circuit breaker trips)

### Loop Levels

- **L1 (Report only)**: Read-only analysis, no code changes
- **L2 (Assisted fixes)**: Creates PRs for human review
- **L3 (Auto-merge)**: Guarded auto-merge with circuit breaker

### Safety Mechanisms

- **Token Budget**: `loop-budget` enforces early exit when spend approaches cap
- **Circuit Breaker**: `loop-guard` tracks consecutive failures and escalates to human
- **Verification**: `loop-verifier` independently validates all changes before merge

---

## 📊 Pattern Comparison Workflow

**Agent Loop Patterns Workflow** — Side-by-side comparison of the four core patterns, showing their execution flow across trigger, analysis, and action phases.

**[→ Open Patterns Workflow](diagrams/loop-patterns-workflow.html)** *(opens in new tab)*

### Patterns Covered

| Pattern | Level | Cadence | Human Gate |
|---------|-------|---------|------------|
| **Daily Triage** | L1 | Daily 10:00 UTC | Weekly review |
| **PR Babysitter** | L2 | On PR events | Human merges |
| **CI Sweeper** | L2 | On CI failures | Human reviews PR |
| **Dependency Sweeper** | L2 | Every 6 hours | Allowlist only |

### Workflow Phases

1. **Trigger** — What activates the loop (cron, webhook, event watch)
2. **Analysis** — How the loop processes information (scan, check, analyze)
3. **Action** — What the loop produces (report, comment, fix PR)

### Execution Characteristics

- **L1 patterns** produce reports only — humans decide actions
- **L2 patterns** create PRs — all changes require human merge
- **Safety gates** apply to all patterns: worktrees, verifier, circuit breaker

---

## 🛠️ Diagram Tools

These diagrams were generated using [archify](https://github.com/tt-a1i/archify), a professional diagram generation tool that creates:

- Standalone HTML files with embedded SVG
- Built-in dark/light theme toggle
- One-click export to PNG/JPEG/WebP/SVG
- Schema-validated JSON source files

### Source Files

- [Architecture Diagram JSON](diagrams/agent-loops-architecture.json)
- [Lifecycle Diagram JSON](diagrams/loop-execution-lifecycle.json)
- [Patterns Workflow JSON](diagrams/loop-patterns-workflow.json)

### Regenerate Diagrams

```bash
cd /path/to/archify/skill

# Architecture diagram
node bin/archify.mjs render architecture \
  /path/to/agent-loops/docs/diagrams/agent-loops-architecture.json \
  /path/to/agent-loops/docs/diagrams/agent-loops-architecture.html

# Lifecycle diagram
node bin/archify.mjs render lifecycle \
  /path/to/agent-loops/docs/diagrams/loop-execution-lifecycle.json \
  /path/to/agent-loops/docs/diagrams/loop-execution-lifecycle.html

# Patterns workflow
node bin/archify.mjs render workflow \
  /path/to/agent-loops/docs/diagrams/loop-patterns-workflow.json \
  /path/to/agent-loops/docs/diagrams/loop-patterns-workflow.html
```

---

## 📖 Related Documentation

- [Core Concepts](CONCEPTS.md) — Intent debt, comprehension debt, harness vs loop
- [Primitives](PRIMITIVES.md) — The 5 building blocks + memory
- [Safety](SAFETY.md) — Denylists, auto-merge policy, MCP scopes
- [Quickstart](QUICKSTART.md) — 5-minute path from zero to first loop
- [Patterns Registry](../patterns/README.md) — All available patterns
