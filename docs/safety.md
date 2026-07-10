# Safety Guidelines

> **Week one rule:** report only. No auto-fix, no auto-merge. Read what the loop writes before you let it act.

## Phased Rollout

| Level | Stance | When | Requirements |
|-------|--------|------|--------------|
| **L1** | Report only | Week 1-2 | `STATE.md`, skill, run log |
| **L2** | Assisted fixes | Week 3+ | Worktrees + verifier + human gate |
| **L3** | Unattended | Rare | Allowlist + auto-merge + full verification |

**Never skip L1.** Even if you're experienced. Read what the loop writes.

## Path Denylist

**Purpose:** Prevent loops from touching sensitive files.

**Example `loop-constraints.md`:**
```markdown
## Denylist paths (never edit)
- `.env*`
- `**/*.key`
- `**/secrets/**`
- `package.json` (deps require explicit approval)
- `docs/api/**` (requires doc team review)

## Protected branches (never push)
- `main`
- `production`
- `release/**`

## Attempt cap
- Max 3 fix attempts per issue
- On 4th failure: escalate to human
```

**Enforcement:**
- L1: Skill reads denylist, refuses to edit
- L2: Worktree + verifier checks denylist
- L3: Pre-commit hook blocks denylist paths

## Auto-Merge Policy

**L1:** No auto-merge. Ever.

**L2:** Human gate on all merges. Loop creates PR, human reviews and merges.

**L3 (rare):** Auto-merge allowed only with:
- [ ] Path allowlist (explicit, not denylist)
- [ ] Verifier APPROVE
- [ ] Tests pass
- [ ] Token cost within budget
- [ ] Off-peak hours (e.g., 2-5am local)

**Recommended:** Never auto-merge. The 5 minutes you save isn't worth the 2 hours debugging a bad merge.

## MCP Scopes

**Principle:** Least privilege. Read-only for L1, scoped writes for L2.

| Connector | L1 | L2 | L3 |
|-----------|----|----|----|
| GitHub | Read issues, CI | Comment on issues | Create PRs |
| Linear | Read tickets | Comment on tickets | Update status |
| Slack | Read channels | Post to #loop-alerts | — |
| Git | Read repo | Create worktrees | Merge (allowlist only) |

**Never grant:**
- Secret access (`.env`, credentials)
- Production deployment
- Database writes
- Billing/payment APIs

## Token Budget + Kill Switch

**Set a budget in `loop-budget.md`:**
```markdown
## Daily token budget
- Max: 500K tokens/day
- Current: 127K (25%)
- Reset: 00:00 UTC

## Kill switch
- Trigger: 1M tokens/day OR 10x expected cost
- Action: Delete scheduler, alert #eng-alerts
```

**Kill signals:**
- Token cost 10x expected
- Same failure 3+ times (fix loop)
- Acting outside constraints
- You can't explain what it's doing

**How to kill:**
1. Delete scheduler (`/loop delete`, remove cron)
2. Commit final `STATE.md`
3. Log reason in `loop-run-log.md`
4. Update `LOOP.md` — mark as dead

## Worktree Isolation (L2+)

**Never fix on main or feature branches.** Always use worktrees:

```bash
# Create isolated worktree
git worktree add ../wt-fix-001 -b loop/fix-001

# Run implementer in worktree
opencode run "Fix the test" --dir ../wt-fix-001

# Extract diff for verifier
git -C ../wt-fix-001 diff > /tmp/diff.patch

# Verifier reviews diff only
opencode run "Review this diff" --file /tmp/diff.patch

# Cleanup (if rejected)
git worktree remove ../wt-fix-001
```

**Benefits:**
- No branch collisions
- Easy cleanup
- Parallel fixes safe
- Verifier sees clean diff

## Verifier Pattern (L2+)

**Principle:** Maker/checker split. Never let the same agent implement and verify.

**Pattern:**
```
Implementer: "Fix the failing test in wt-fix-001"
   ↓
Diff: git diff > /tmp/diff.patch
   ↓
Verifier: "Review this diff. APPROVE or REJECT only."
   ↓
If APPROVE: merge
If REJECT: cleanup + log failure
```

**Verifier constraints:**
- Sees **only the diff**, not the codebase
- Must explicitly say "APPROVE" or "REJECT"
- Cannot make code changes
- Must cite specific issues in diff

## Human Gate (L2+)

**When to escalate:**
- Denylist path touched
- Fix attempt 3+ failed
- Verifier REJECT
- Ambiguous situation
- Token cost spike

**Escalation format:**
```markdown
## Escalation [timestamp]

**Pattern:** pr-babysitter
**Issue:** PR #47 — merge conflict after rebase
**Attempts:** 3 (all failed)
**Reason:** Conflict in generated file `api/types.ts`
**Recommendation:** Manual rebase or regenerate types
**Loop status:** Paused, awaiting human
```

## Checklist Before L2

Before enabling assisted fixes (L2):

- [ ] Path denylist documented in `loop-constraints.md`
- [ ] Worktree pattern tested manually
- [ ] Verifier skill written and tested
- [ ] Human gate defined (when to escalate)
- [ ] Token budget set in `loop-budget.md`
- [ ] Kill switch documented
- [ ] Run log reviewed for 1+ weeks (L1)

## Checklist Before L3

Before enabling unattended operation (L3):

- [ ] All L2 checklists complete
- [ ] Path **allowlist** (explicit, not denylist)
- [ ] Auto-merge policy documented
- [ ] Verifier runs on every change
- [ ] Tests run on every change
- [ ] Off-peak hours defined
- [ ] Alert channel configured
- [ ] 4+ weeks L2 stability

**Honest advice:** L3 is rarely worth it. L2 with human gate catches edge cases the loop can't handle.

## See Also

- [Concepts](./CONCEPTS.md) — intent debt, comprehension debt
- [Primitives](./PRIMITIVES.md) — worktrees, sub-agents
- [Quickstart](./QUICKSTART.md) — first loop in 5 minutes
