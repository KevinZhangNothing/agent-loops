---
name: loop-sync
description: >
  Detect drift between Loop configuration files (STATE.md, LOOP.md, AGENTS.md)
  and the skills directory. Wraps the @cobusgreyling/loop-sync CLI; never
  auto-mutates without an explicit human gate.
user_invocable: true
---

# Loop Sync Skill

You run drift detection between the Loop configuration files and report what
needs attention. You do **not** mutate files — you produce a report and
suggest the smallest fix the human can review.

## When to run

- Before the **first** loop run after a config edit.
- Whenever a new pattern is added or removed in `LOOP.md`.
- Whenever a new skill lands in `skills/` (or `.grok/skills/`, `.claude/skills/`,
  `.codex/skills/` — `@cobusgreyling/loop-sync` scans all four).
- After upgrading any loop-engineering tool.

## What `@cobusgreyling/loop-sync` actually checks

The CLI (see `tools/loop-sync/src/sync.ts`) produces a `DriftReport` with four
issue types:

| Type | Meaning |
|------|---------|
| `missing` | A required file is absent. Required: `STATE.md`, `LOOP.md`, `AGENTS.md`. |
| `inconsistent` | STATE.md ↔ LOOP.md disagree (e.g. LOOP.md declares a pattern but doesn't reference STATE.md). |
| `outdated` | A skill is behind the registry version. |
| `orphaned` | A pattern referenced in LOOP.md is no longer in `patterns/registry.yaml`. |

Severity → score: `error` −20, `warning` −10, `info` −1. Score 0–100 maps to
`healthy` (≥70), `warning` (40–69), `critical` (<40).

## How to invoke

```bash
# Default: human-readable report, exit 0 even with issues
npx @cobusgreyling/loop-sync .

# JSON for CI / STATE.md append
npx @cobusgreyling/loop-sync . --json > sync-report.json

# Dry-run preview of auto-fix (still does not write)
npx @cobusgreyling/loop-sync . --auto-fix --dry-run

# Verbose: also surface the top 3 heading mismatches between STATE.md and LOOP.md
npx @cobusgreyling/loop-sync . --verbose
```

**Never** run `--auto-fix` without `--dry-run` first and a human review of the
diff. Auto-fix is experimental per the CLI's own `--help`.

## Output

Paste a markdown summary into STATE.md (under **Recent Noise** or **Watch
List** depending on severity):

```markdown
## Loop Sync — 2026-07-09

- Score: 85/100 (warning)
- Errors: 0
- Warnings: 1 (`LOOP.md does not reference STATE.md`)
- Infos: 2

### Suggested actions
- Add STATE.md to the state files list in LOOP.md
- Run `npx @cobusgreyling/loop-init . --pattern daily-triage` if STATE.md is missing
```

## Rules

- Score < 40 (`critical`) → **STOP** the calling loop, escalate-human. State
  is too unreliable to drive auto-fix.
- Score 40–69 (`warning`) → continue, but **append** the warnings to STATE.md.
- Score ≥ 70 (`healthy`) → no-op, do not spam the log.
- Never delete files. Never edit `LOOP.md` without human approval
  (`loop-constraints.md`: "Always tell me what you're about to do").
- If a missing required file is detected, recommend `loop-init`, never copy
  the repo's own `STATE.md` into the target.