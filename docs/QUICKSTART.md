# Quickstart — 5 Minutes to Your First Loop

> **Week one rule:** report only. No auto-fix, no auto-merge. Read what the loop writes before you let it act.

## Step 1: Pick Your Pattern (30 seconds)

Start with **Daily Triage** — lowest risk, learns loop discipline:

```bash
npx @kevinzhangnothing/loop-init . --pattern daily-triage --tool grok
```

**Other patterns:** See [patterns/README.md](../patterns/README.md)

**Tool options:**
- `grok` — `/loop` scheduling (default)
- `claude` — `/loop` + skills
- `codex` — Automations tab
- `opencode` — cron/systemd
- `cursor` — manual setup (see [examples/cursor/](../examples/cursor/))

## Step 2: Scaffold (60 seconds)

`loop-init` creates:
- `STATE.md` — loop memory
- `LOOP.md` — active loops
- `loop-budget.md` — token caps
- `loop-run-log.md` — run history
- `skills/loop-triage/SKILL.md` — triage skill

**Output:** Your Loop Ready score (starts ~10-30, aim for 70+)

## Step 3: Check Token Cost (30 seconds)

```bash
npx @kevinzhangnothing/loop-cost --pattern daily-triage --level L1 --cadence 1d
```

**Typical L1 costs:**
- Daily Triage: ~500-2K tokens/run
- PR Babysitter: ~10K-50K tokens/run (high frequency)
- CI Sweeper: ~5K-20K tokens/run (variable)

## Step 4: Audit + Get Next Steps

```bash
npx @kevinzhangnothing/loop-audit . --suggest
```

**Readiness levels:**
- **L1 (Report only):** Score 30-60 — safe for week 1
- **L2 (Assisted fixes):** Score 60-85 — worktrees + verifier
- **L3 (Unattended):** Score 85+ — full automation (rare)

## Step 5: Run Your First Loop

**Grok example:**
```bash
/loop 1d Run loop-triage. Read STATE.md first. Update High Priority and Watch List. No code changes.
```

**Claude Code:**
```bash
/loop 1d $loop-triage — report-only week 1
```

**Codex:** Create Automation with 1d cadence, prompt: "Run loop-triage skill..."

**Opencode (cron):**
```bash
# crontab -e
0 9 * * * cd /repo && opencode run "Run loop-triage. Update STATE.md. No code changes."
```

## Week 2+: Graduating to L2

After 1-2 weeks of report-only runs:

1. **Add worktrees** for isolated fixes:
   ```bash
   npx @kevinzhangnothing/loop-worktree create --run-id fix-1 --pattern pr-babysitter
   ```

2. **Add verifier skill** — maker/checker split

3. **Update LOOP.md** — enable L2 with human gate on merges

4. **Re-audit:** `npx @kevinzhangnothing/loop-audit . --suggest`

## Next Steps

| Doc | Description |
|-----|-------------|
| [Pattern Picker](./PATTERN_PICKER.md) | Which loop next |
| [Primitives](./PRIMITIVES.md) | Understanding the building blocks |
| [Safety](./SAFETY.md) | Read before L2/L3 |
| [Tool Matrix](./TOOL_MATRIX.md) | Your tool's capabilities |

## Troubleshooting

**Score stuck?** Run `loop-audit --suggest` and implement 1-2 recommendations.

**Token spike?** Kill the loop, check `loop-run-log.md`, reduce cadence or scope.

**Not sure what broke?** See [CONCEPTS.md](./CONCEPTS.md) — comprehension debt is real.
