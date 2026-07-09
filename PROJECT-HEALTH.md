# Project Health Dashboard

Real-time status of loop-engineering components.

*Last updated: 2026-07-09*

## Core Metrics

| Metric | Status | Details |
|--------|--------|---------|
| **Loop Readiness Score** | ✅ 100/100 (L3) | `npx @cobusgreyling/loop-audit .` |
| **Active Loops** | ✅ 2 running | Daily Triage (L1), Changelog Drafter (L1) |
| **CI/CD** | ✅ Passing | `audit.yml`, `validate-patterns.yml` |
| **npm Packages** | ✅ 8 published | All tools on npm registry |
| **Community** | ✅ Growing | 5.5k+ stars, active adopters |

## npm Package Status

| Package | Version | Last Published | Status |
|---------|---------|----------------|--------|
| `@cobusgreyling/loop-audit` | Latest | From `loop-audit-v*` tags | ✅ |
| `@cobusgreyling/loop-init` | Latest | From `loop-init-v*` tags | ✅ |
| `@cobusgreyling/loop-cost` | Latest | From `loop-cost-v*` tags | ✅ |
| `@cobusgreyling/loop-sync` | Latest | From `loop-sync-v*` tags | ✅ |
| `@cobusgreyling/loop-context` | Latest | From `loop-context-v*` tags | ✅ |
| `@cobusgreyling/loop-mcp-server` | Latest | From `loop-mcp-server-v*` tags | ✅ |
| `@cobusgreyling/loop-worktree` | Latest | From `loop-worktree-v*` tags | ✅ |
| `@cobusgreyling/goal-audit` | Latest | From `goal-audit-v*` tags | ✅ |

Publish workflow: [docs/RELEASE.md](./docs/RELEASE.md)

## Pattern Coverage

| Pattern | Grok | Claude | Codex | Opencode | GitHub Actions |
|---------|------|--------|-------|----------|----------------|
| Daily Triage | ✅ | ✅ | ✅ | ✅ | ✅ |
| PR Babysitter | ✅ | 🟡 | 🟡 | ✅ | ✅ |
| CI Sweeper | ✅ | 🟡 | 🟡 | ✅ | ✅ |
| Dependency Sweeper | ✅ | 🟡 | 🟡 | ✅ | ✅ |
| Post-Merge Cleanup | ✅ | 🟡 | 🟡 | ✅ | ✅ |
| Changelog Drafter | ✅ | 🟡 | 🟡 | ✅ | ✅ |
| Issue Triage | ✅ | 🟡 | 🟡 | ✅ | ✅ |

**Legend**: ✅ Full example | 🟡 Via `loop-init` only | ⚪ Not yet available

## Recent Activity

### Loop Runs (Last 7 Days)

| Date | Pattern | Duration | Outcome | Score |
|------|---------|----------|---------|-------|
| 2026-07-09 | Daily Triage | 7s | report-only | 100 |
| 2026-07-08 | Daily Triage | 10s | report-only | 100 |
| 2026-07-07 | Daily Triage | 4s | report-only | 100 |
| 2026-07-06 | Daily Triage | 11s | report-only | 100 |
| 2026-07-03 | Daily Triage | 5s | report-only | 100 |

Full log: [loop-run-log.md](./loop-run-log.md)

### Recent Releases

Check [GitHub Releases](https://github.com/cobusgreyling/loop-engineering/releases) for latest.

## Open Issues Health

| Label | Count | Description |
|-------|-------|-------------|
| `good first issue` | ~10 | Entry-level contributions |
| `help wanted` | ~5 | Needs community help |
| `enhancement` | ~15 | Feature requests |
| `bug` | ~3 | Bugs to fix |

[Browse all issues](https://github.com/cobusgreyling/loop-engineering/issues)

## Documentation Coverage

| Section | Status | Last Updated |
|---------|--------|--------------|
| Quick Start | ✅ | Current |
| Patterns (7) | ✅ | Current |
| Tool Examples | 🟡 | Expanding |
| Stories | 🟡 | Needs more |
| API Reference | ✅ | In tool READMEs |

## Known Gaps

| Gap | Priority | Tracking |
|-----|----------|----------|
| More Cursor/Windsurf examples | Medium | [#220](https://github.com/cobusgreyling/loop-engineering/issues/220) |
| More production stories | Medium | [Stories index](./stories/) |
| Aider CLI examples | Low | [primitives-matrix.md](./primitives-matrix.md) |
| Gemini CLI examples | Low | [primitives-matrix.md](./primitives-matrix.md) |

## How to Help

1. **Add your project**: [Add Adopter issue](https://github.com/cobusgreyling/loop-engineering/issues/new?template=add-adopter.yml)
2. **Write a story**: Share what worked or broke in `stories/`
3. **Add examples**: Tool-specific implementations in `examples/{tool}/`
4. **Fix bugs**: Browse [`good first issue`](https://github.com/cobusgreyling/loop-engineering/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22)

## Automated Checks

| Check | Frequency | Status |
|-------|-----------|--------|
| `validate-patterns` | Every push/PR | ✅ |
| `audit` (dogfood) | Every push/PR + daily | ✅ |
| Star history update | Daily | ✅ |
| Contributors update | On merge | ✅ |

---

*This document is a living dashboard. Update it when metrics change or new gaps are identified.*
