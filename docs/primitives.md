# The Five Primitives + Memory

Agent loops are built from six building blocks. Master these, and you can design loops for any tool.

## 1. Scheduling / Automations

**Purpose:** Run triage on a cadence without manual triggering.

| Tool | Mechanism | Example |
|------|-----------|---------|
| **Grok** | `/loop [interval]` | `/loop 1d Run loop-triage` |
| **Claude Code** | `/loop`, cron | `/loop 5m /babysit` |
| **Codex** | Automations tab | Project → Automations → 1d cadence |
| **Opencode** | cron/systemd | `0 9 * * * opencode run "..."` |
| **Cursor** | Automations | Settings → Automations → cron trigger |
| **GitHub Actions** | Workflow `on.schedule` | `cron: '0 9 * * *'` |

**Design tip:** Start with daily cadence. Increase frequency only after L1 stability.

## 2. State / Memory

**Purpose:** Persistent memory outside any conversation. The loop reads state at start, writes at end.

**Common patterns:**
- `STATE.md` — general triage state
- `issue-triage-state.md` — issue queue health
- `ci-sweeper-state.md` — active CI failures
- Linear/GitHub Projects — structured state

**Example `STATE.md`:**
```markdown
## Last run
2026-07-10 09:00

## High Priority
- CI failing: `test-api` on main (3 failures)

## Watch List
- PR #47: awaiting review
- Issue #120: needs reproduction

## Completed
- [x] Updated changelog for v1.5.0
```

**Design tip:** State must be **machine-readable**. Use consistent headings, bullet format, timestamps.

## 3. Skills

**Purpose:** Reusable capabilities. A skill is a `SKILL.md` file that defines what the agent should do.

**Structure:**
```markdown
# loop-triage

## Purpose
Scan CI, issues, and commits. Update STATE.md with priorities.

## Steps
1. Read STATE.md
2. Check CI status on main
3. Scan new issues (last 24h)
4. Scan new commits (last 24h)
5. Update STATE.md: High Priority, Watch List, Completed
6. Write 5-line summary

## Constraints
- No code changes
- No comments on issues/PRs
- Escalate if CI failing > 3 runs
```

**Invocation:**
- Grok: "Run the loop-triage skill"
- Claude Code: `$loop-triage`
- Opencode: Skill auto-discovered from `skills/` folder

**Design tip:** Skills should be **tool-agnostic**. The skill describes *what* to do; scheduling is *how* to invoke.

## 4. Worktrees

**Purpose:** Safe parallel execution. Each fix attempt gets an isolated git worktree.

**Why:** Prevents branch collisions, enables parallel fixes, easy cleanup.

**Pattern:**
```bash
# Create worktree for fix attempt
FIX_ID="$(date +%Y%m%d%H%M%S)"
WORKTREE="../wt-fix-$FIX_ID"
git worktree add "$WORKTREE" -b "loop/fix-$FIX_ID"

# Run implementer in worktree
opencode run "Fix the failing test" --dir "$WORKTREE"

# Extract diff for verifier
git -C "$WORKTREE" diff > /tmp/diff.patch

# Verifier reviews diff (not code)
opencode run "Review this diff" --file /tmp/diff.patch

# Cleanup (if rejected)
git worktree remove "$WORKTREE"
```

**Design tip:** L2 loops **must** use worktrees. Never fix directly on main or feature branches.

## 5. Sub-agents

**Purpose:** Maker/checker split. One agent implements, another verifies.

**Pattern:**
```
Implementer: "Fix the failing test in wt-fix-001"
   ↓
Verifier: "Review diff.patch. APPROVE or REJECT only."
   ↓
If APPROVE: merge
If REJECT: cleanup worktree, log failure
```

**Tools:**
- Grok: `Task` with `subagent_type`
- Claude Code: `.claude/agents/reviewer.md`
- Opencode: `--agent implementer` / `--agent verifier`
- Cursor: Review mode

**Design tip:** Verifier should see **only the diff**, not the codebase. Forces focused review.

## + Memory (The Spine)

**Purpose:** Durable spine outside any conversation. More than state — the loop's identity.

| File | Purpose |
|------|---------|
| `LOOP.md` | Active loops, cadence, constraints |
| `loop-budget.md` | Token caps, kill switch |
| `loop-run-log.md` | Append-only run history |
| `loop-constraints.md` | Denylist paths, protected branches |

**Example `loop-budget.md`:**
```markdown
## Daily token budget
- Max: 500K tokens/day
- Current: 127K (25%)

## Kill switch
- Trigger: 1M tokens/day OR 10x expected cost
- Action: Delete scheduler, alert #eng

## Last reset
2026-07-10 00:00
```

**Design tip:** Memory files are **git-tracked** (except live state). They're the loop's contract with you.

## Putting It Together: Anatomy of a Loop

```
┌─────────────────────────────────────────────────────┐
│  Schedule (cron, /loop, Automations)                │
│       ↓                                             │
│  Read STATE.md + LOOP.md                            │
│       ↓                                             │
│  Triage Skill (loop-triage, pr-babysitter, etc.)    │
│       ↓                                             │
│  Decide: Report? Fix? Escalate?                     │
│       ↓                                             │
│  If Fix:                                            │
│    → Create worktree                                │
│    → Implementer sub-agent                          │
│    → Verifier sub-agent (diff review)               │
│    → If APPROVE: merge; If REJECT: cleanup          │
│       ↓                                             │
│  Update STATE.md + loop-run-log.md                  │
│       ↓                                             │
│  Human gate? (L2/L3)                                │
│       ↓                                             │
│  Wait for next cadence                              │
└─────────────────────────────────────────────────────┘
```

## Tool Matrix Summary

| Primitive | Grok | Claude Code | Opencode | Cursor |
|-----------|------|-------------|----------|--------|
| Scheduling | `/loop` | `/loop`, cron | cron/systemd | Automations |
| State | `STATE.md` | `STATE.md` | `STATE.md` | `STATE.md` |
| Skills | `SKILL.md` | `SKILL.md` | `SKILL.md` | `.cursor/rules/` |
| Worktrees | `isolation: worktree` | `git worktree` | `git worktree` | `git worktree` |
| Sub-agents | `Task` | `.claude/agents/` | `--agent` | Review mode |

**[Full Tool Matrix →](./TOOL_MATRIX.md)**

## See Also

- [Quickstart](./QUICKSTART.md) — first loop in 5 minutes
- [Concepts](./CONCEPTS.md) — intent debt, comprehension debt
- [Safety](./SAFETY.md) — denylists, auto-merge policy
