# Documentation Index

Central navigation for all agent-loops documentation.

## Quick Start

| Doc | Purpose | Time |
|-----|---------|------|
| [QUICKSTART.md](./QUICKSTART.md) | First 5 minutes — scaffold, audit, run | 5 min |
| [pattern-picker.md](./pattern-picker.md) | Which loop to run first | 3 min |
| [loop-design-checklist.md](./loop-design-checklist.md) | Ship readiness rubric | 10 min |

## Core Concepts

| Doc | Description |
|-----|-------------|
| [primitives.md](./primitives.md) | The 5 building blocks + memory |
| [primitives-matrix.md](./primitives-matrix.md) | Cross-tool capability mapping (Grok, Claude, Codex, etc.) |
| [concepts.md](./concepts.md) | Intent debt, comprehension debt, harness vs loop |
| [operating-loops.md](./operating-loops.md) | Cost, logging, when to kill a loop |

## Patterns

| Doc | Description |
|-----|-------------|
| [Pattern Registry](../patterns/registry.yaml) | Machine-readable index (7 patterns) |
| [Daily Triage](../patterns/daily-triage.md) | Morning scan of CI, issues, commits |
| [PR Babysitter](../patterns/pr-babysitter.md) | Shepherd PRs through review and merge |
| [CI Sweeper](../patterns/ci-sweeper.md) | React to failing CI with fixes |
| [Dependency Sweeper](../patterns/dependency-sweeper.md) | Safe dependency and CVE updates |
| [Post-Merge Cleanup](../patterns/post-merge-cleanup.md) | Tech debt cleanup after merges |
| [Changelog Drafter](../patterns/changelog-drafter.md) | Auto-generate release notes |
| [Issue Triage](../patterns/issue-triage.md) | Prioritize incoming issues |

## Safety & Operations

| Doc | Description |
|-----|-------------|
| [safety.md](./safety.md) | Denylists, auto-merge policy, MCP scopes |
| [failure-modes.md](./failure-modes.md) | Incident-style failure catalog |
| [anti-patterns.md](./anti-patterns.md) | Design mistakes to avoid |
| [multi-loop.md](./multi-loop.md) | When multiple loops collide |

## Tools

| Tool | npm | Description |
|------|-----|-------------|
| [loop-audit](../tools/loop-audit/) | `@kevinzhangnothing/loop-audit` (pending) | Loop Readiness Score CLI |
| [loop-init](../tools/loop-init/) | `@kevinzhangnothing/loop-init` (pending) | Scaffold starters |
| [loop-cost](../tools/loop-cost/) | `@kevinzhangnothing/loop-cost` (pending) | Token spend estimator |
| [loop-sync](../tools/loop-sync/) | `@kevinzhangnothing/loop-sync` (pending) | STATE.md ↔ LOOP.md drift detection |
| [loop-context](../tools/loop-context/) | `@kevinzhangnothing/loop-context` (pending) | Stateful memory + circuit breaker |
| [loop-mcp-server](../tools/mcp-server/) | `@kevinzhangnothing/loop-mcp-server` (pending) | MCP runtime lookup |
| [loop-worktree](../tools/loop-worktree/) | `@kevinzhangnothing/loop-worktree` (pending) | Isolated git worktrees per fix |
| [goal-audit](../tools/goal-audit/) | `@kevinzhangnothing/goal-audit` (pending) | Companion goal engineering |

## Examples & Starters

| Directory | Description |
|-----------|-------------|
| [examples/](../examples/) | Tool-specific implementations |
| [starters/](../starters/) | Clone-and-run kits |
| [stories/](../stories/) | Real production wins and failures |
| [templates/](../templates/) | Skill and state templates |

## Contributing

| Doc | Description |
|-----|-------------|
| [CONTRIBUTING.md](../CONTRIBUTING.md) | Contribution ladder and requirements |
| [adopters.md](./adopters.md) | Projects using agent loops |
| [RELEASE.md](./RELEASE.md) | npm publish workflow |
| [GITHUB_PAGES.md](./GITHUB_PAGES.md) | GitHub Pages deployment |

## pi Integration

| Doc | Description |
|-----|-------------|
| [PI-INTEGRATION.md](./PI-INTEGRATION.md) | Complete pi coding agent integration guide |
| [pi/README.md](../pi/README.md) | pi integration kit overview |
| [pi/skills/](../pi/skills/) | pi-formatted skills (12 skills: loop-audit, loop-init, loop-triage, loop-cost, loop-budget, loop-verifier, minimal-fix, loop-sync, loop-guard, ci-triage, pr-review-triage, rebase-and-clean) |
| [pi/workflows/](../pi/workflows/) | pi workflow definitions (daily-triage, pr-babysitter, ci-sweeper) |
| [pi/mcp.json](../pi/mcp.json) | pi MCP server configuration template |
| [PI-INTEGRATION-COMPLETE.md](../PI-INTEGRATION-COMPLETE.md) | pi integration v2 status report |

## Rebrand & Operations

| Doc | Description |
|-----|-------------|
| [REBRAND-NPM.md](./REBRAND-NPM.md) | Operator's guide to republish as `@kevinzhangnothing/*` (3 manual steps + 2 scripts) |

## Project Health

| File | Description |
|------|-------------|
| [STATE.md](../STATE.md) | Current loop state (live) |
| [LOOP.md](../LOOP.md) | Active loops and cadence |
| [loop-budget.md](../loop-budget.md) | Token caps and kill switch |
| [loop-run-log.md](../loop-run-log.md) | Append-only run history |
| [loop-constraints.md](../loop-constraints.md) | Operational constraints |

## External

- [GitHub Discussions](https://github.com/KevinZhangNothing/agent-loops/discussions) — Q&A and show-and-tell
- [GitHub Repository](https://github.com/KevinZhangNothing/agent-loops) — Source code and issues
