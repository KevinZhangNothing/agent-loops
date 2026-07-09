# New Contributor Guide

Welcome! This guide helps you make your first contribution to loop-engineering in **under 30 minutes**.

## Pick Your Path

### 🚀 Fastest (~10 minutes)

**Add your project to the adopters list**

1. Click [New Issue → Add Adopter](https://github.com/KevinZhangNothing/loop-engineering/issues/new?template=add-adopter.yml)
2. Fill in the form (project name, pattern used, tool, level)
3. Submit

That's it! Your project is now listed in [adopters.md](./adopters.md).

### 📝 Quick Win (~15 minutes)

**Fix a typo or improve documentation**

1. Browse [docs/](../docs/), [patterns/](../patterns/), or [stories/](../stories/)
2. Find something unclear, outdated, or with a typo
3. Click "Edit this file" on GitHub or fork and PR
4. In your PR description: "Docs: clarify X" or "Fix typo in Y"

Examples:
- Clarify a pattern description
- Add a missing tool to the primitives matrix
- Fix broken links

### 🛠️ Good First Issue (~30-60 minutes)

**Browse [`good first issue`](https://github.com/KevinZhangNothing/loop-engineering/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22)**

Current opportunities:
- Add a tool example to `examples/{tool}/`
- Write a production story for `stories/`
- Expand the primitives matrix with a new tool row
- Improve error messages in loop-audit or loop-init

Comment **"I'll take this"** on any issue to get assigned.

## Contribution Ladder

| Step | Time | What | Where |
|------|------|------|-------|
| **1** | ~10 min | Add your project to adopters | [Issue form](https://github.com/KevinZhangNothing/loop-engineering/issues/new?template=add-adopter.yml) |
| **2** | ~15 min | Typo fix or doc improvement | Any `.md` file |
| **3** | ~30 min | Production story or tool example | `stories/` or `examples/{tool}/` |
| **4** | ~1 hr | Skill template or MCP example | `templates/` or `examples/mcp/` |
| **5** | Half day | New starter kit | `starters/{pattern}-{tool}/` |
| **6** | Full day | Full pattern with registry entry | `patterns/` + `registry.yaml` |

## What Makes a Good Contribution?

### ✅ Yes
- **Honest failures**: Stories that include what broke, not just wins
- **Tool diversity**: Examples for tools you use (Cursor, Windsurf, Aider, etc.)
- **Specific tips**: "Run `npm ci` before `npm test`" not "install and test"
- **Small, focused PRs**: One clear change per PR

### ❌ No
- Hype or marketing language
- Undisclosed internal URLs or secrets
- Vague claims without evidence
- Large refactors without discussion first

## PR Checklist

Before submitting:

- [ ] Links work from README or docs index
- [ ] No secrets, tokens, or internal URLs
- [ ] Follows existing format (check similar files)
- [ ] PR title starts with scope: `Docs:`, `Story:`, `Example:`, `Pattern:`

## Maintainer Response

- **Adopters & Stories**: Same-day review when possible
- **Good First Issues**: Assigned within 24 hours of "I'll take this" comment
- **All PRs**: Merged or feedback within 48 hours

## After Your First PR

1. **Add the Loop Ready badge** to your project:
   ```bash
   npx @kevinzhangnothing/loop-audit . --badge
   ```

2. **Share your setup** in [Show and Tell Discussions](https://github.com/KevinZhangNothing/loop-engineering/discussions/categories/show-and-tell)

3. **Pick a bigger contribution** from the ladder above

## Questions?

- **General Q&A**: [GitHub Discussions](https://github.com/KevinZhangNothing/loop-engineering/discussions)
- **Bug reports**: [New Issue](https://github.com/KevinZhangNothing/loop-engineering/issues/new)
- **Security issues**: [SECURITY.md](../SECURITY.md) — do not file public issues

## Thank You

Every contribution makes loop engineering more practical and accessible. Whether you add a row to a table or write a full pattern, you're helping others avoid the same pitfalls and accelerate their own loops.

— The loop-engineering maintainers
