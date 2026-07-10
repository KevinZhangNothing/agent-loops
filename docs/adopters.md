# Adopters & Community Setups

If you run a loop from this repo (or adapted from it), add yourself here.

## Loop Ready Badge

Show your readiness level in your README:

```bash
npx @kevinzhangnothing/loop-audit . --badge
```

Paste the markdown output into your README. Re-run after you graduate L1 → L2 → L3.

**Note:** npm packages pending publish. Run from source: `cd tools/loop-audit && npm ci && node dist/cli.js . --badge`

## How to List Your Project

**Option 1:** Open an [Add Adopter issue](https://github.com/KevinZhangNothing/agent-loops/issues/new?template=add-adopter.yml)

**Option 2:** Open a PR that adds a row to the table below

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
| [agent-loops](https://github.com/KevinZhangNothing/agent-loops) (this repo) | Daily Triage, Changelog Drafter, audit dogfood | GitHub Actions + Grok | L3 | Reference implementation — `loop-audit` on every PR |

*Your project here — open an issue or PR*

## Show & Tell

Prefer chat over a PR? Post in [GitHub Discussions → Show and tell](https://github.com/KevinZhangNothing/agent-loops/discussions/categories/show-and-tell) with:

1. Which pattern you picked and why
2. Your first `/loop` or scheduler command
3. One surprise (good or bad)

**Failure reports welcome.** See [stories/](../stories/) for honest post-mortems.

## Community

- [GitHub Discussions](https://github.com/KevinZhangNothing/agent-loops/discussions) — Q&A and show-and-tell
- [GitHub Issues](https://github.com/KevinZhangNothing/agent-loops/issues) — bug reports and feature requests
- [`good first issues`](https://github.com/KevinZhangNothing/agent-loops/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) — start contributing
