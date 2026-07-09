# Project Health Dashboard

Real-time status of loop-engineering components.

*Last updated: 2026-07-09*

## Core Metrics

| Metric | Status | Details |
|--------|--------|---------|
| **Loop Readiness Score** | ✅ 100/100 (L3) | `npx @kevinzhangnothing/loop-audit .` |
| **Active Loops** | ✅ 2 running | Daily Triage (L1), Changelog Drafter (L1) |
| **CI/CD** | ✅ Passing | `audit.yml`, `validate-patterns.yml` |
| **npm Packages** | ⏳ 8 staged for republish | Old `@cobusgreyling/*` still on registry — see [docs/REBRAND-NPM.md](./docs/REBRAND-NPM.md) |
| **Community** | ✅ Growing | 5.5k+ stars, active adopters |

## npm Package Status

| Package | Source | npm registry | Status |
|---------|--------|--------------|--------|
| `@kevinzhangnothing/loop-audit` | `tools/loop-audit/` | ⏳ pending republish | Source ready, run `scripts/publish-npm-scope.sh` |
| `@kevinzhangnothing/loop-init` | `tools/loop-init/` | ⏳ pending republish | Source ready |
| `@kevinzhangnothing/loop-cost` | `tools/loop-cost/` | ⏳ pending republish | Source ready |
| `@kevinzhangnothing/loop-sync` | `tools/loop-sync/` | ⏳ pending republish | Source ready |
| `@kevinzhangnothing/loop-context` | `tools/loop-context/` | ⏳ pending republish | Source ready |
| `@kevinzhangnothing/loop-mcp-server` | `tools/mcp-server/` | ⏳ pending republish | Source ready |
| `@kevinzhangnothing/loop-worktree` | `tools/loop-worktree/` | ⏳ pending republish | Source ready |
| `@kevinzhangnothing/goal-audit` | `tools/goal-audit/` | ⏳ pending republish | Source ready |
| `@cobusgreyling/*` (legacy) | — | ⚠️ still published | See [rebrand guide](./docs/REBRAND-NPM.md#b-deprecate-the-old-cobusgreyling-packages-recommended) to deprecate |

Release workflow: [docs/RELEASE.md](./docs/RELEASE.md)
Rebrand guide: [docs/REBRAND-NPM.md](./docs/REBRAND-NPM.md)

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

Check [GitHub Releases](https://github.com/KevinZhangNothing/loop-engineering/releases) for latest.

## Open Issues Health

| Label | Count | Description |
|-------|-------|-------------|
| `good first issue` | ~10 | Entry-level contributions |
| `help wanted` | ~5 | Needs community help |
| `enhancement` | ~15 | Feature requests |
| `bug` | ~3 | Bugs to fix |

[Browse all issues](https://github.com/KevinZhangNothing/loop-engineering/issues)

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
| More Cursor/Windsurf examples | Medium | [#220](https://github.com/KevinZhangNothing/loop-engineering/issues/220) |
| More production stories | Medium | [Stories index](./stories/) |
| Aider CLI examples | Low | [primitives-matrix.md](./primitives-matrix.md) |
| Gemini CLI examples | Low | [primitives-matrix.md](./primitives-matrix.md) |

## How to Help

1. **Add your project**: [Add Adopter issue](https://github.com/KevinZhangNothing/loop-engineering/issues/new?template=add-adopter.yml)
2. **Write a story**: Share what worked or broke in `stories/`
3. **Add examples**: Tool-specific implementations in `examples/{tool}/`
4. **Fix bugs**: Browse [`good first issue`](https://github.com/KevinZhangNothing/loop-engineering/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22)

## Automated Checks

| Check | Frequency | Status |
|-------|-----------|--------|
| `validate-patterns` | Every push/PR | ✅ |
| `audit` (dogfood) | Every push/PR + daily | ✅ |
| Star history update | Daily | ✅ |
| Contributors update | On merge | ✅ |

---

*This document is a living dashboard. Update it when metrics change or new gaps are identified.*
