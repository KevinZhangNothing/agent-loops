# goal-audit

Goal Readiness Score CLI for Grok Build `/goal` workflows.

## Install / run

```bash
npx @kevinzhangnothing/goal-audit .
npx @kevinzhangnothing/goal-audit . --suggest
npx @kevinzhangnothing/goal-audit . --json
```

## Levels

| Level | Score | Meaning |
|-------|-------|---------|
| G0 | < 40 | Ad hoc `/goal` usage |
| G1 | 40–59 | GOAL.md + assisted goals |
| G2 | 60–79 | Verifier + test gates |
| G3 | 80+ | CI, budget, run log |

## Development

```bash
npm install
npm test
```