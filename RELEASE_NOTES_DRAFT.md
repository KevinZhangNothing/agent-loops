# Release notes draft — since `loop-mcp-server-v1.0.0`

**Status:** Published to [Discussions](https://github.com/cobusgreyling/loop-engineering/discussions) on 2026-07-08. Archive copy for the next changelog-drafter run.

**Window:** 2026-07-06 → 2026-07-08

---

## Highlights

### New on npm: `@cobusgreyling/loop-worktree` ([#190](https://github.com/cobusgreyling/loop-engineering/pull/190), [#204](https://github.com/cobusgreyling/loop-engineering/pull/204))

Isolated git worktrees per fix attempt — supports PR Babysitter and CI Sweeper L2 patterns without branch collisions. Tagged `loop-worktree-v1.0.0`.

```bash
npx @cobusgreyling/loop-worktree create --run-id fix-1 --pattern pr-babysitter
npx @cobusgreyling/loop-worktree list
npx @cobusgreyling/loop-worktree cleanup --older-than 24h
```

Thanks [@KhaiTrang1995](https://github.com/KhaiTrang1995).

### Docs & examples

| PR | Contributor | What shipped |
|----|-------------|--------------|
| [#217](https://github.com/cobusgreyling/loop-engineering/pull/217) | @Mahizhan-S | MCP server `npx` quickstart in `examples/mcp/` ([#201](https://github.com/cobusgreyling/loop-engineering/issues/201)) |
| [#202](https://github.com/cobusgreyling/loop-engineering/pull/202) | @Mahizhan-S | Gemini CLI appendix in primitives matrix |
| [#206](https://github.com/cobusgreyling/loop-engineering/pull/206) | @Mahizhan-S | Zed appendix in primitives matrix |
| [#208](https://github.com/cobusgreyling/loop-engineering/pull/208) | @Mahizhan-S | Windsurf PR Babysitter example |
| [#182](https://github.com/cobusgreyling/loop-engineering/pull/182) | @k-anushka14 | Multi-loop coordination story |
| [#183](https://github.com/cobusgreyling/loop-engineering/pull/183) | @k-anushka14 | Opencode constraints example |
| [#185](https://github.com/cobusgreyling/loop-engineering/pull/185) | @k-anushka14 | Aider appendix link in examples index |
| Hermes index + QUICKSTART | @AshayK003 ([#187](https://github.com/cobusgreyling/loop-engineering/pull/187)–[#189](https://github.com/cobusgreyling/loop-engineering/pull/189)) | `examples/hermes/README.md`, QUICKSTART section |
| QUICKSTART `loop-worktree` | maintainer ([#197](https://github.com/cobusgreyling/loop-engineering/issues/197)) | L2 worktree subsection + cheat sheet |

### Philosophy & contributor growth

- KY cut surface philosophy v0.1 ([#179](https://github.com/cobusgreyling/loop-engineering/pull/179)) — thanks [@sololys](https://github.com/sololys)
- `CONTRIBUTORS.md` automation refresh ([#180](https://github.com/cobusgreyling/loop-engineering/pull/180))
- Star-history page redesign ([#205](https://github.com/cobusgreyling/loop-engineering/pull/205))

### Housekeeping

- **Star-history workflow** — opens an auto-merge PR instead of pushing to protected `main`
- Dependabot bumps: `actions/github-script` 7→9, `@types/node` in loop-audit/loop-init
- Stale branch prune + contributor PR backlog triage

---

## npm packages (current)

| Package | Version | Notes |
|---------|---------|-------|
| `@cobusgreyling/loop-worktree` | **1.0.0** | New — `loop-worktree-v1.0.0` |
| `@cobusgreyling/loop-mcp-server` | 1.0.0 | No change |
| `@cobusgreyling/loop-audit` | 1.5.3 | No change |
| `@cobusgreyling/loop-init` | 1.3.3 | No change |
| `@cobusgreyling/loop-cost` | 1.0.3 | No change |
| `@cobusgreyling/loop-sync` | 1.0.0 | No change |
| `@cobusgreyling/loop-context` | 1.0.0 | No change |

---

## Try it in 5 minutes

```bash
npx @cobusgreyling/loop-init . --pattern daily-triage --tool grok
npx @cobusgreyling/loop-audit . --suggest
LOOP_PROJECT_ROOT=. npx @cobusgreyling/loop-mcp-server
```

Week two (L2): pair `loop-worktree` with `loop-context --check` — see [QUICKSTART](docs/QUICKSTART.md#l2-isolated-fix-attempts-loop-worktree).