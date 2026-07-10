# Documentation Index

## Getting Started

| Doc | Time | Description |
|-----|------|-------------|
| [QUICKSTART](./QUICKSTART.md) | 5 min | First loop: scaffold → audit → run |
| [PATTERN_PICKER](./PATTERN_PICKER.md) | 3 min | Which loop to run first |
| [SAFETY](./SAFETY.md) | 5 min | Read before enabling auto-fixes |
| [PI INTEGRATION](./PI-INTEGRATION.md) | 10 min | pi coding agent integration |
| [DOGFOODING](./DOGFOODING.md) | 15 min | Use agent-loops to improve itself |

## Core Concepts

| Doc | Description |
|-----|-------------|
| [CONCEPTS](./CONCEPTS.md) | Intent debt, comprehension debt, harness vs loop |
| [PRIMITIVES](./PRIMITIVES.md) | The 5 building blocks + memory |
| [TOOL_MATRIX](./TOOL_MATRIX.md) | Cross-tool capability mapping (Grok, Claude, Codex, etc.) |

## Patterns

See [patterns/README.md](../patterns/README.md) for full pattern documentation.

| Pattern | When to Use |
|---------|-------------|
| [Daily Triage](../patterns/daily-triage.md) | Morning scan: CI, issues, commits |
| [PR Babysitter](../patterns/pr-babysitter.md) | Shepherd PRs through review and merge |
| [CI Sweeper](../patterns/ci-sweeper.md) | React to failing CI with fixes |
| [Dependency Sweeper](../patterns/dependency-sweeper.md) | Safe dependency and CVE updates |
| [Changelog Drafter](../patterns/changelog-drafter.md) | Auto-generate release notes |
| [Issue Triage](../patterns/issue-triage.md) | Prioritize incoming issues |

## Operations

| Doc | Description |
|-----|-------------|
| [Publishing](./NPM-SETUP.md) | Publish @kevinzhangnothing/loop-* to npm |
| [GitHub Settings](./GITHUB-SETTINGS.md) | Configure repo description, topics |
| [Adopters](./adopters.md) | Projects using agent loops |
| [Contributing](../CONTRIBUTING.md) | Contribution ladder and requirements |

## Project State (Live)

| File | Description |
|------|-------------|
| [STATE.md](../STATE.md) | Current loop state |
| [LOOP.md](../LOOP.md) | Active loops and cadence |
| [loop-budget.md](../loop-budget.md) | Token caps and kill switch |
| [loop-run-log.md](../loop-run-log.md) | Run history |
| [loop-constraints.md](../loop-constraints.md) | Operational constraints |

## External

- [GitHub Repository](https://github.com/KevinZhangNothing/agent-loops)
- [GitHub Discussions](https://github.com/KevinZhangNothing/agent-loops/discussions)
- [GitHub Issues](https://github.com/KevinZhangNothing/agent-loops/issues)
