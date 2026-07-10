# Loop State — agent-loops reference

**Owner:** Daily Triage Loop (L1 report-only)  
**Cadence & Gates:** See [LOOP.md](LOOP.md#active-loops)  
**Last run:** 2026-07-09T10:41:53Z (automated daily-triage workflow)

## Active Loops

| Pattern | Level | Status | Next Run |
|---------|-------|--------|----------|
| daily-triage | L1 | report-only | next weekday 10:00 UTC |
| pr-babysitter | L2 | manual trigger | on-demand |
| dependency-sweeper | L2 | patch-only | 6h cadence |

## High Priority (loop is acting or waiting on human)

- Maintain loop readiness score ≥ 58 (current: **100**, level **L3**).
- Keep npm packages current after tool changes (tag `loop-audit-v*`, `loop-init-v*`, `loop-cost-v*` — see docs/RELEASE.md).


## Watch List

- Expand contributor failure stories (dependency sweeper, multi-loop).
- Collect a production story for Post-Merge Cleanup.
- Validate `loop-init` scaffolds on fresh projects across all patterns.

## Recent Noise (ignored this run)

—

## Budget & Observability

- Token cap: See `loop-budget.md`
- Run log: `loop-run-log.md` (21 entries, last run 2026-07-09)
- Readiness score: **100/100 (L3)**

## Safety & Gates

- No auto-merge on main (see [LOOP.md](LOOP.md#safety--gates))
- Worktrees required for unattended code changes
- Denylist: showcase assets, primitives docs, audit scoring logic

## Worktrees

- Active worktrees: 0
- Last worktree: N/A (see `git worktree list`)

---
Run log: Updated by `.github/workflows/daily-triage.yml`. See `LOOP.md` for cadence and gates.
