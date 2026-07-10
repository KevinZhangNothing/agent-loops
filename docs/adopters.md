# Adopters & community setups

Forks and stars mean people are trying this in their own stacks. If you run a loop from this repo (or adapted from it), add yourself here via PR.

**Pinned:** [Add your project — Loop Ready badge + adopters list](https://github.com/KevinZhangNothing/agent-loops/discussions/92) (Discussions)

## Loop Ready badge

Show your readiness level in your README:

```bash
npx @kevinzhangnothing/loop-audit . --badge
```

Paste the markdown output into your README. Re-run after you graduate L1 → L2 → L3.

## How to list your project

**Fast path:** [open the Add Adopter issue](https://github.com/KevinZhangNothing/agent-loops/issues/new?template=add-adopter.yml) — we'll add your row.

Or open a PR that adds a row to the table below:

| Field | What to include |
|-------|-----------------|
| **Project** | Repo link or product name |
| **Pattern(s)** | e.g. Daily Triage + Issue Triage |
| **Tool** | Grok, Claude Code, Codex, Cursor, Windsurf, GitHub Actions, mixed |
| **Level** | L1 / L2 / L3 (honest) |
| **Notes** | One line — what worked or what broke |

## Adopters

| Project | Pattern(s) | Tool | Level | Notes |
|---------|------------|------|-------|-------|
| [agent-loops](https://github.com/KevinZhangNothing/agent-loops) (this repo) | Daily Triage, Changelog Drafter, audit dogfood | GitHub Actions + Grok | L3 | Reference implementation — `loop-audit` on every PR; readiness score 100 |
| [agent-loops](https://github.com/KevinZhangNothing/agent-loops) (maintainer) | Post-Merge Cleanup | Grok + GitHub Actions | L1→L2 | Off-peak scan; verifier caught doc/API drift — see [story](../stories/post-merge-cleanup-honest-win.md) |
| [agent-loops](https://github.com/KevinZhangNothing/agent-loops) (maintainer) | Issue Triage + Daily Triage | Grok | L1 | Issue queue feeder: propose labels only week one; pairs with morning `STATE.md` triage |
| [agent-loops](https://github.com/KevinZhangNothing/agent-loops) (maintainer) | PR Babysitter, Dependency Sweeper | Grok / Claude Code | L2 | Assisted fixes in worktrees; human gate on merges; patch-only deps |
| [Hermes Agent](https://github.com/NousResearch/hermes-agent) by [Nous Research](https://nousresearch.com) | Daily Triage | Hermes | L1 | Six loop primitives in one binary — `hermes cron` + skill + `delegate_task` + MCP + memory. Reference: [examples/hermes/daily-triage.md](../examples/hermes/daily-triage.md) |

*Your project here — see [CONTRIBUTING.md](../CONTRIBUTING.md).*

## Show & tell

Prefer chat over a PR? Post in [GitHub Discussions → Show and tell](https://github.com/KevinZhangNothing/agent-loops/discussions/categories/show-and-tell) with:

1. Which pattern you picked and why
2. Your first `/loop` or scheduler command
3. One surprise (good or bad)

Failure reports are first-class — see [stories/](../stories/).