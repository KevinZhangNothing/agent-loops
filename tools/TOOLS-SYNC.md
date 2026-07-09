# Tools Sync Status

Track npm package versions and release synchronization across all loop-engineering tools.

*Last sync check: 2026-07-09*

## Package Versions

| Tool | Package | Version | Last Updated | Status |
|------|---------|---------|--------------|--------|
| loop-audit | `@kevinzhangnothing/loop-audit` | 1.6.0 | Current | ✅ |
| loop-init | `@kevinzhangnothing/loop-init` | 1.2.x | Current | ✅ |
| loop-cost | `@kevinzhangnothing/loop-cost` | 1.0.x | Current | ✅ |
| loop-sync | `@kevinzhangnothing/loop-sync` | 1.0.x | Current | ✅ |
| loop-context | `@kevinzhangnothing/loop-context` | 1.0.x | Current | ✅ |
| loop-mcp-server | `@kevinzhangnothing/loop-mcp-server` | 1.0.x | Current | ✅ |
| loop-worktree | `@kevinzhangnothing/loop-worktree` | 1.0.0 | Current | ✅ |
| goal-audit | `@kevinzhangnothing/goal-audit` | Latest | Current | ✅ |

## Test Status

All tools pass tests:

```
✅ loop-audit: 22 tests pass
✅ loop-init: tests pass
✅ loop-cost: tests pass
✅ loop-sync: tests pass
✅ loop-context: tests pass
✅ loop-mcp-server: 22 tests pass
✅ loop-worktree: 8 tests pass
```

## Release Workflow

Each tool has its own release workflow triggered by git tags:

| Tool | Tag Pattern | Workflow |
|------|-------------|----------|
| loop-audit | `loop-audit-v*` | `.github/workflows/release-loop-audit.yml` |
| loop-init | `loop-init-v*` | `.github/workflows/release-loop-init.yml` |
| loop-cost | `loop-cost-v*` | `.github/workflows/release-loop-cost.yml` |
| loop-sync | `loop-sync-v*` | `.github/workflows/release-loop-sync.yml` |
| loop-context | `loop-context-v*` | `.github/workflows/release-loop-context.yml` |
| loop-mcp-server | `loop-mcp-server-v*` | `.github/workflows/release-loop-mcp-server.yml` |
| loop-worktree | `loop-worktree-v*` | `.github/workflows/release-loop-worktree.yml` |
| goal-audit | `goal-audit-v*` | `.github/workflows/release-goal-audit.yml` |

See [docs/RELEASE.md](../docs/RELEASE.md) for full release process.

## Dependency Sync

All tools share these common dependencies:

| Dependency | Version | Used By |
|------------|---------|---------|
| `typescript` | ^5.x | All tools |
| `@types/node` | ^22.x | All tools |
| `yaml` | ^2.x | loop-audit, loop-init, loop-cost, loop-sync |
| `ajv` | ^8.x | loop-audit, loop-init |

## Build Commands

```bash
# Build all tools
npm run build:tools

# Test all tools
npm run test:tools

# Individual tool
cd tools/loop-audit && npm run build && npm test
```

## Known Issues

None currently.

## Next Release Candidates

Track upcoming releases here before tagging:

| Tool | Changes | Target Version |
|------|---------|----------------|
| — | — | — |

---

*Update this document when releasing new versions or when test status changes.*
