# Core Concepts

## What Is an Agent Loop?

An **agent loop** is a scheduled, stateful workflow where an AI agent:
1. **Reads** persistent state (`STATE.md`)
2. **Triages** new information (CI failures, PRs, issues)
3. **Acts** within defined boundaries (report → fix → merge)
4. **Writes** updated state for the next run

> "You shouldn't be prompting coding agents anymore. You should be designing loops that prompt your agents."

## Loops vs Goals

| Aspect | Loop | Goal |
|--------|------|------|
| **Purpose** | Discover + triage ongoing work | Finish a bounded task |
| **Cadence** | Scheduled (every 5m, 1d, etc.) | Run until done |
| **State** | Persistent (`STATE.md`) | Temporary (session-only) |
| **Stop condition** | Never (kill switch manual) | Verifiable completion |
| **Example** | "Daily triage at 9am" | "Fix all failing tests" |

**Use loops for:** monitoring, triage, maintenance, cadence-based work
**Use goals for:** bounded tasks with clear completion criteria

## The Five Primitives + Memory

| Primitive | Purpose | Example |
|-----------|---------|---------|
| **Scheduling** | Run on cadence | `/loop 1d`, cron, Automations |
| **State** | Persistent memory | `STATE.md`, Linear tickets |
| **Skills** | Reusable capabilities | `SKILL.md.loop-triage` |
| **Worktrees** | Safe parallel execution | `git worktree` per fix |
| **Sub-agents** | Maker/checker split | Implementer → Verifier |
| **+ Memory** | Cross-session spine | `LOOP.md`, run logs |

**[Primitives →](./PRIMITIVES.md)** | **[Tool Matrix →](./TOOL_MATRIX.md)**

## Intent Debt vs Comprehension Debt

### Intent Debt

**Definition:** The gap between what you told the loop to do and what it actually does.

**Causes:**
- Vague prompts ("fix CI")
- Missing constraints (no denylist)
- No verifier step

**Symptoms:**
- Loop makes unexpected changes
- Token costs spike
- You dread checking what it did

**Fix:**
- Write explicit constraints in `LOOP.md`
- Add denylist paths
- Require verifier approval

### Comprehension Debt

**Definition:** The gap between what the loop did and what you understand.

**Causes:**
- Not reading `STATE.md` updates
- Skipping run logs
- Complex multi-step actions

**Symptoms:**
- "What did this loop even do?"
- Surprised by PRs
- Can't explain token spend

**Fix:**
- Read `STATE.md` every run (week 1+)
- Require 5-line summaries
- Escalate ambiguous actions

## Harness Engineering vs Loop Engineering

| Aspect | Harness | Loop |
|--------|---------|------|
| **Focus** | One-off automation | Recurring workflow |
| **State** | None (stateless) | Persistent (`STATE.md`) |
| **Verification** | Hope | Built-in verifier |
| **Example** | "Fix this bug" | "Daily triage + fix small bugs" |

**Harness:** You prompt, agent acts, conversation ends
**Loop:** Agent prompts itself, acts, updates state, repeats

## Phased Rollout (L1 → L2 → L3)

| Level | Stance | When | Requirements |
|-------|--------|------|--------------|
| **L1** | Report only | Week 1-2 | `STATE.md`, skill, run log |
| **L2** | Assisted fixes | Week 3+ | Worktrees + verifier + human gate |
| **L3** | Unattended | Rare | Path allowlist, auto-merge, full verification |

**Never skip L1.** Read what the loop writes before letting it act.

## When to Kill a Loop

**Immediate kill signals:**
- Token cost 10x expected
- Fix loop (same failure 3+ times)
- Acting outside constraints
- You can't explain what it's doing

**How to kill:**
1. Delete scheduler (`/loop delete`, remove cron)
2. Commit final `STATE.md`
3. Log reason in `loop-run-log.md`
4. Update `LOOP.md` — mark as dead

> "Build the loop. But build it like someone who intends to stay the engineer, not just the person who presses go."

## See Also

- [Safety Guidelines](./SAFETY.md) — denylists, auto-merge policy
- [Primitives](./PRIMITIVES.md) — detailed primitive breakdown
- [Pattern Picker](./PATTERN_PICKER.md) — which loop to run first
