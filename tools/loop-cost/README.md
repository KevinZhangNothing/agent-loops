# loop-cost

Estimate daily token spend for [loop engineering](https://github.com/cobusgreyling/loop-engineering) patterns by cadence and readiness level (L1–L3).

Uses cost metadata from `patterns/registry.yaml`.

## Install & Run

```bash
npx @cobusgreyling/loop-cost --pattern ci-sweeper --cadence 15m --level L2
npx @cobusgreyling/loop-cost --pattern daily-triage --level L1 --json
npx @cobusgreyling/loop-cost --list
```

**From this repo:**

```bash
cd tools/loop-cost
npm install
npm test
```

## Options

| Flag | Description |
|------|-------------|
| `--pattern` | Pattern id (see `--list`) |
| `--cadence` | Override cadence (e.g. `15m`, `1d`) |
| `--level` | `L1`, `L2`, or `L3` (default `L1`) |
| `--conservative` | Use slower cadence from ranges |
| `--json` | Machine-readable output |

## Scenarios

Each estimate includes:

- **Early-exit / no-op** — empty watchlist, minimal tokens
- **Full triage** — every run does a full scan
- **Action every run** — implementer + verifier every time (worst case)
- **Realistic blend** — level-based mix (documented in output)

Pair with `loop-budget.md` (scaffolded by `loop-init`) and `loop-audit` cost observability checks.

## Feed the circuit breaker

`--json` output resolves a realistic per-run token cap for
[`loop-context`](../loop-context)'s breaker, so `--token-budget` reflects real
pattern cost instead of a hand-typed guess (the `loop-guard` skill wires this):

```bash
BUDGET=$(npx @cobusgreyling/loop-cost --pattern ci-sweeper --level L2 --json \
  | node -e 'let d="";process.stdin.on("data",c=>d+=c).on("end",()=>process.stdout.write(String(JSON.parse(d).scenarios.realistic.tokensPerRun)))')
npx @cobusgreyling/loop-context --check --ledger loop-ledger.json --token-budget "$BUDGET"
```

The tools stay independent — no runtime dependency, just shell wiring.

See [docs/operating-loops.md](../../docs/operating-loops.md).