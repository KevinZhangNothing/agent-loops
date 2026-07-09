# Documentation Index

Central navigation for all loop-engineering documentation.

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
| [loop-audit](../tools/loop-audit/) | `@cobusgreyling/loop-audit` | Loop Readiness Score CLI |
| [loop-init](../tools/loop-init/) | `@cobusgreyling/loop-init` | Scaffold starters |
| [loop-cost](../tools/loop-cost/) | `@cobusgreyling/loop-cost` | Token spend estimator |
| [loop-sync](../tools/loop-sync/) | `@cobusgreyling/loop-sync` | STATE.md ↔ LOOP.md drift detection |
| [loop-context](../tools/loop-context/) | `@cobusgreyling/loop-context` | Stateful memory + circuit breaker |
| [loop-mcp-server](../tools/mcp-server/) | `@cobusgreyling/loop-mcp-server` | MCP runtime lookup |
| [loop-worktree](../tools/loop-worktree/) | `@cobusgreyling/loop-worktree` | Isolated git worktrees per fix |
| [goal-audit](../tools/goal-audit/) | `@cobusgreyling/goal-audit` | Companion goal engineering |

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
| [adopters.md](./adopters.md) | Projects using loop engineering |
| [RELEASE.md](./RELEASE.md) | npm publish workflow |
| [GITHUB_PAGES.md](./GITHUB_PAGES.md) | GitHub Pages deployment |

## pi Integration

| Doc | Description |
|-----|-------------|
| [PI-INTEGRATION.md](./PI-INTEGRATION.md) | Complete pi coding agent integration guide |
| [pi/README.md](../pi/README.md) | pi integration kit overview |
| [pi/skills/](../pi/skills/) | pi-formatted skills (loop-audit, loop-init, loop-triage, loop-cost) |
| [pi/workflows/](../pi/workflows/) | pi workflow definitions (daily-triage, pr-babysitter, ci-sweeper) |
| [pi/mcp.json](../pi/mcp.json) | pi MCP server configuration template |

## Project Health

| File | Description |
|------|-------------|
| [STATE.md](../STATE.md) | Current loop state (live) |
| [LOOP.md](../LOOP.md) | Active loops and cadence |
| [loop-budget.md](../loop-budget.md) | Token caps and kill switch |
| [loop-run-log.md](../loop-run-log.md) | Append-only run history |
| [loop-constraints.md](../loop-constraints.md) | Operational constraints |

## External

- [Interactive Showcase](https://cobusgreyling.github.io/loop-engineering/) — Pattern picker + visual index
- [Loop Engineering Essay](https://cobusgreyling.substack.com/p/loop-engineering) — The concept and why
- [Addy Osmani on Loop Engineering](https://addyosmani.com/blog/loop-engineering/) — Guest post
- [GitHub Discussions](https://github.com/cobusgreyling/loop-engineering/discussions) — Q&A and show-and-tell
