# Complete Tutorial: Using Agent Loops with pi

This tutorial will guide you from zero to running your first Agent Loop in pi.

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Quick Verification](#quick-verification)
4. [Your First Loop](#your-first-loop)
5. [Daily Usage](#daily-usage)
6. [Advanced Configuration](#advanced-configuration)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### 1. Install pi

Ensure you have pi coding agent installed:

```bash
# If not installed, refer to official documentation
# https://pi.mcp.dev/docs/installation
```

### 2. Verify pi Works

```bash
# Test that pi is working
pi --version
```

### 3. Prepare Your Project

Choose a project where you want to use Agent Loops:

```bash
cd /path/to/your/project
```

---

## Installation

### Method 1: One-Click Install (Recommended)

```bash
# 1. Clone agent-loops repo (if not already)
git clone https://github.com/KevinZhangNothing/agent-loops.git
cd agent-loops

# 2. Run the installation script
bash pi/install.sh
```

The install script automatically:
- ✅ Copies 12 skills to `~/.pi/agent/skills/`
- ✅ Copies 3 workflows to `~/.pi/agent/workflows/`
- ✅ Configures MCP server to `~/.pi/agent/mcp.json`
- ✅ Backs up existing files

### Method 2: Manual Installation

```bash
# 1. Copy skills
cp -r agent-loops/pi/skills/. ~/.pi/agent/skills/

# 2. Copy workflows
cp -r agent-loops/pi/workflows/. ~/.pi/agent/workflows/

# 3. Configure MCP server
cp agent-loops/pi/mcp.json ~/.pi/agent/mcp.json

# 4. Edit mcp.json, set your project path
# Change LOOP_PROJECT_ROOT to your project's absolute path
```

### Verify Installation

```bash
# Check if skills are installed
ls ~/.pi/agent/skills/ | grep loop

# You should see:
# loop-audit
# loop-budget
# loop-cost
# loop-guard
# loop-init
# loop-sync
# loop-triage
# loop-verifier
# ...
```

---

## Quick Verification

### 1. Test MCP Connection

In pi, run:

```
+loop-score
```

**Expected output:**
```
Loop Readiness Audit — /path/to/your/project
Score: XX/100 (L0/L1/L2)
...
```

### 2. View Available Skills

Ask pi:

```
Show all available loop skills
```

**Should return:**
- loop-audit — Loop readiness audit
- loop-init — Scaffold generation
- loop-triage — Daily task triage
- loop-cost — Token cost estimation
- loop-budget — Token budget guard
- loop-sync — Configuration drift detection
- loop-verifier — Independent verifier
- minimal-fix — Minimal fix implementation
- loop-guard — Circuit breaker
- ci-triage — CI failure triage
- pr-review-triage — PR status triage
- rebase-and-clean — PR rebase and cleanup

---

## Your First Loop

### Step 1: Initialize Your Project

In pi, run:

```
+loop-init daily-triage grok
```

**Example output:**
```
📦 Scaffolding loop with pattern: daily-triage
🔧 Tool: grok

Created:
  ✓ STATE.md
  ✓ LOOP.md
  ✓ loop-budget.md
  ✓ skills/loop-triage/SKILL.md

Loop Readiness Score: 65/100 (L1)
Assessment: Ready for L1 report-only loop
```

### Step 2: Check Token Budget

```
+loop-cost daily-triage L1
```

**Example output:**
```
Pattern: daily-triage
Level: L1
Cadence: 1d
Est. tokens/run: 500-2K
Est. tokens/day: 500-2K
Est. cost/day: $0.01-0.04 (at $20/1M tokens)
```

### Step 3: Run Your First Loop

In pi, send:

```
/loop 1d Run loop-triage. Read STATE.md first. Update High Priority section. No code changes.
```

**This will:**
1. Read `STATE.md`
2. Scan CI status, Issues, Commits
3. Update `STATE.md` High Priority section
4. Generate a 5-line summary

### Step 4: View Results

```
+loop-state
```

**Example output:**
```
## Last run
2026-07-10 09:00

## High Priority
- CI failing: test-api on main (2 failures)
- PR #47: awaiting review

## Watch List
- Issue #120: needs reproduction

## Completed
- [x] Updated changelog for v1.5.0
```

---

## Daily Usage

### Scenario 1: Morning Project Scan

**Run every morning:**

```
+loop-triage
```

**Or use the loop command:**

```
/loop 1d Morning triage: CI, issues, commits. Update STATE.md.
```

### Scenario 2: Audit Project Health

**Run once a week:**

```
+loop-score-suggest
```

**Output includes:**
- Loop readiness score
- Current level assessment
- Improvement recommendations
- Next actions

### Scenario 3: Check Token Spend

**Query anytime:**

```
+loop-budget
```

**Or view run logs:**

```
+loop-log
```

### Scenario 4: Detect Configuration Drift

**After modifying configuration:**

```
+loop-sync
```

**This checks:**
- STATE.md and LOOP.md consistency
- Skill version matching
- Scheduler configuration correctness

---

## Advanced Configuration

### Configure Daily Triage Workflow

Edit `~/.pi/agent/workflows/daily-triage.yaml`:

```yaml
name: Daily Triage
schedule: "0 9 * * 1-5"  # Weekdays at 9 AM
skills:
  - loop-triage
  - loop-audit
budget: 100000  # 100K tokens/day
level: L1  # Report-only mode
```

### Configure PR Babysitter Workflow

Edit `~/.pi/agent/workflows/pr-babysitter.yaml`:

```yaml
name: PR Babysitter
schedule: "*/15 * * * *"  # Every 15 minutes
skills:
  - pr-review-triage
  - loop-verifier
  - minimal-fix
budget: 200000  # 200K tokens/day
level: L2  # Assisted fix mode
```

### Configure CI Sweeper Workflow

Edit `~/.pi/agent/workflows/ci-sweeper.yaml`:

```yaml
name: CI Sweeper
schedule: "*/10 * * * *"  # Every 10 minutes
skills:
  - ci-triage
  - loop-verifier
  - loop-guard
budget: 1000000  # 1M tokens/day
level: L2
circuit_breaker:
  enabled: true
  stagnation_threshold: 3  # Escalate after 3 failures
```

### Customize Token Budget

Edit `loop-budget.md` in your project:

```markdown
## Daily token budget
- Max: 100K tokens/day
- Current: 25K (25%)
- Kill switch: 500K tokens/day

## Per-loop limits
- daily-triage: 50K
- pr-babysitter: 200K
- ci-sweeper: 1M
```

---

## Troubleshooting

### Q1: Skills Not Loading

**Problem:** pi cannot find loop skills

**Solution:**

```bash
# 1. Check skills directory
ls ~/.pi/agent/skills/ | grep loop

# 2. If missing, reinstall
bash agent-loops/pi/install.sh

# 3. Or manually copy
cp -r agent-loops/pi/skills/. ~/.pi/agent/skills/

# 4. Restart pi
```

### Q2: MCP Server Not Connecting

**Problem:** `+loop-score` doesn't respond

**Solution:**

```bash
# 1. Check if npx is available
which npx

# 2. Manually run MCP server
npx -y @kevinzhangnothing/loop-mcp-server

# 3. Check mcp.json configuration
cat ~/.pi/agent/mcp.json

# 4. Ensure LOOP_PROJECT_ROOT is set correctly
# 5. Restart pi
```

### Q3: Workflows Not Triggering

**Problem:** Scheduled workflows don't run

**Solution:**

```bash
# 1. Check if workflow files exist
ls ~/.pi/agent/workflows/

# 2. Verify cron expression
# Use https://crontab.guru to validate

# 3. Check pi logs
# View workflow scheduler logs

# 4. Manually trigger for testing
/loop 5m Run daily-triage skill
```

### Q4: Token Budget Exceeded

**Problem:** Loop spend exceeds expectations

**Immediate actions:**

```bash
# 1. Stop the loop
# Remove scheduler or disable workflow

# 2. Check current spend
+loop-budget

# 3. Set stricter budget
# Edit loop-budget.md, lower daily_max

# 4. Enable circuit breaker
# Add loop-guard skill to workflow
```

### Q5: Loop Makes Unexpected Changes

**Problem:** L2+ loop modified code it shouldn't have

**Prevention and solution:**

```markdown
1. Use L1 only for the first week
2. Add denylist to LOOP.md:
   ```
   Denylist:
   - package-lock.json
   - yarn.lock
   - docs/*.md
   ```
3. Enable maker/checker split
4. Require human review for all PRs
```

---

## Best Practices

### ✅ Recommended

1. **Start with L1**
   ```
   /loop 1d Run loop-triage. Report only. No code changes.
   ```

2. **Set Clear Budgets**
   ```markdown
   ## loop-budget.md
   - Daily max: 100K tokens
   - Kill switch: 500K tokens
   ```

3. **Use Circuit Breakers**
   ```yaml
   skills:
     - loop-guard
   circuit_breaker:
     enabled: true
     stagnation_threshold: 3
   ```

4. **Maker/Checker Split**
   ```
   Implementer: "Fix the failing test"
      ↓
   Verifier: "Review this diff. APPROVE or REJECT only."
   ```

5. **Audit Regularly**
   ```
   Weekly: +loop-score-suggest
   ```

### ❌ Avoid

1. **Don't start with L3**
   - Build trust first, then escalate gradually

2. **Don't set budgets too high**
   - Start low, increase as needed

3. **Don't skip verification steps**
   - All auto-fixes need verification

4. **Don't ignore STATE.md**
   - Read daily, stay informed

5. **Don't run L2+ without circuit breaker**
   - Always enable loop-guard

---

## Shortcuts Reference

| Shortcut | Description | Example |
|----------|-------------|---------|
| `+loop-score` | Audit current project | `+loop-score` |
| `+loop-score-suggest` | Get improvement suggestions | `+loop-score-suggest` |
| `+loop-init` | Initialize scaffold | `+loop-init daily-triage grok` |
| `+loop-cost` | Estimate token cost | `+loop-cost daily-triage L1` |
| `+loop-state` | View STATE.md | `+loop-state` |
| `+loop-log` | View run logs | `+loop-log` |
| `+loop-budget` | View budget status | `+loop-budget` |
| `+loop-sync` | Detect config drift | `+loop-sync` |

---

## Next Steps

After completing this tutorial:

1. 📖 Read [Core Concepts](./concepts.md) to understand loops vs goals
2. 📖 Read [Five Primitives](./PRIMITIVES.md) to learn the building blocks
3. 📖 Browse [Patterns](../patterns/README.md) to choose your loop
4. 🔧 Try configuring [PR Babysitter](../patterns/pr-babysitter.md)
5. 🔧 Try configuring [CI Sweeper](../patterns/ci-sweeper.md)

---

## Resources

- [pi Official Docs](https://pi.mcp.dev/docs)
- [Agent-loops GitHub](https://github.com/KevinZhangNothing/agent-loops)
- [npm Packages](https://www.npmjs.com/org/kevinzhangnothing)
- [Install Script](../pi/install.sh)
- [Skills Documentation](./README.md)

## Support

Having issues?

- 🐛 [GitHub Issues](https://github.com/KevinZhangNothing/agent-loops/issues)
- 💬 [GitHub Discussions](https://github.com/KevinZhangNothing/agent-loops/discussions)
- 📖 [Troubleshooting Guide](./PI-INTEGRATION.md#troubleshooting)
