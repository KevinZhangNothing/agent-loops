# Pattern Picker

Not sure which loop to run first? This guide recommends a pattern based on your situation.

## Quick Recommendation

| Your situation | Start with | Why |
|----------------|------------|-----|
| **New to loops** | [Daily Triage](../patterns/daily-triage.md) | Low risk, learns discipline |
| **CI always red** | [CI Sweeper](../patterns/ci-sweeper.md) | High impact, but watch token cost |
| **PRs stuck in review** | [PR Babysitter](../patterns/pr-babysitter.md) | Unblocks team velocity |
| **Dependency CVEs piling up** | [Dependency Sweeper](../patterns/dependency-sweeper.md) | Security + tech debt |
| **No changelog, releases chaotic** | [Changelog Drafter](../patterns/changelog-drafter.md) | Low risk, high visibility win |
| **Issue queue overwhelming** | [Issue Triage](../patterns/issue-triage.md) | Prioritization without commitment |
| **Just merged a big PR** | [Post-Merge Cleanup](../patterns/post-merge-cleanup.md) | Prevents tech debt accumulation |

## Detailed Recommendations

### Daily Triage (Recommended First Loop)

**Cadence:** 1d–2h
**Week 1:** Report only
**Token cost:** Low (~500-2K/run)

**Best for:**
- Learning loop discipline
- Morning scan of repo health
- Feeder for other loops (finds work for CI sweeper, PR babysitter)

**Scaffold:**
```bash
npx @kevinzhangnothing/loop-init . --pattern daily-triage --tool grok
```

**First run:**
```bash
/loop 1d Run loop-triage. Read STATE.md first. Update High Priority. No code changes.
```

---

### CI Sweeper

**Cadence:** 5–15m
**Week 1:** Report only (no fixes)
**Token cost:** Very high (~5K-20K/run, variable)

**Best for:**
- CI always red on main
- Flaky tests blocking deploys
- Teams with strict "main must be green" policy

**⚠️ Warning:** Highest token cost. Start with report-only for 1 week.

**Scaffold:**
```bash
npx @kevinzhangnothing/loop-init . --pattern ci-sweeper --tool grok
```

---

### PR Babysitter

**Cadence:** 5–15m
**Week 1:** Watch only (no fixes)
**Token cost:** High (~10K-50K/run, high frequency)

**Best for:**
- PRs stuck waiting for review
- Merge conflicts after rebase
- Teams with slow review cycles

**Scaffold:**
```bash
npx @kevinzhangnothing/loop-init . --pattern pr-babysitter --tool grok
```

---

### Dependency Sweeper

**Cadence:** 6h–1d
**Week 1:** Report only (patch-only after)
**Token cost:** Medium (~2K-10K/run)

**Best for:**
- CVE alerts piling up
- Dependency drift (months behind)
- Teams with "patch-only" policy

**Scaffold:**
```bash
npx @kevinzhangnothing/loop-init . --pattern dependency-sweeper --tool grok
```

---

### Changelog Drafter

**Cadence:** 1d or on tag
**Week 1:** Draft only (no publish)
**Token cost:** Low (~1K-5K/run)

**Best for:**
- No changelog (or stale)
- Releases take too long to document
- Teams wanting automated release notes

**Scaffold:**
```bash
npx @kevinzhangnothing/loop-init . --pattern changelog-drafter --tool grok
```

---

### Issue Triage

**Cadence:** 2h–1d
**Week 1:** Propose labels only
**Token cost:** Low (~500-2K/run)

**Best for:**
- Issue queue overwhelming
- Need prioritization without commitment
- Teams with slow issue response

**Scaffold:**
```bash
npx @kevinzhangnothing/loop-init . --pattern issue-triage --tool grok
```

---

### Post-Merge Cleanup

**Cadence:** 1d–6h
**Week 1:** Report only
**Token cost:** Low (~1K-5K/run)

**Best for:**
- Tech debt after big merges
- Doc/API drift
- Teams wanting to prevent accumulation

**Scaffold:**
```bash
npx @kevinzhangnothing/loop-init . --pattern post-merge-cleanup --tool grok
```

## Token Cost Reference

| Pattern | Cadence | Level | Est. tokens/run | Est. tokens/day |
|---------|---------|-------|-----------------|-----------------|
| Daily Triage | 1d | L1 | 500-2K | 500-2K |
| Issue Triage | 1d | L1 | 500-2K | 500-2K |
| Changelog Drafter | 1d | L1 | 1K-5K | 1K-5K |
| Post-Merge Cleanup | 1d | L1 | 1K-5K | 1K-5K |
| Dependency Sweeper | 1d | L2 | 2K-10K | 2K-10K |
| CI Sweeper | 15m | L2 | 5K-20K | 50K-200K |
| PR Babysitter | 15m | L2 | 10K-50K | 100K-500K |

**Note:** L2 costs higher due to worktrees + verifier. Always run `loop-cost` before choosing cadence.

**Check cost:**
```bash
npx @kevinzhangnothing/loop-cost --pattern daily-triage --level L1 --cadence 1d
```

## Decision Tree

```
New to loops?
├─ Yes → Daily Triage (week 1-2)
│   └─ Then what's your pain?
│       ├─ CI red → CI Sweeper
│       ├─ PRs stuck → PR Babysitter
│       ├─ CVEs piling up → Dependency Sweeper
│       └─ No changelog → Changelog Drafter
│
└─ No (experienced) → What's the highest pain today?
    ├─ CI red → CI Sweeper (L2, worktrees)
    ├─ PRs stuck → PR Babysitter (L2, worktrees)
    └─ Tech debt → Post-Merge Cleanup (L1)
```

## Next Steps

1. **Pick a pattern** from above
2. **Check cost:** `npx @kevinzhangnothing/loop-cost --pattern <name> --level L1`
3. **Scaffold:** `npx @kevinzhangnothing/loop-init . --pattern <name> --tool grok`
4. **Run L1** for 1-2 weeks (report only)
5. **Audit:** `npx @kevinzhangnothing/loop-audit . --suggest`
6. **Consider L2** if stable (worktrees + verifier)

## See Also

- [All Patterns](../patterns/README.md) — full pattern documentation
- [Quickstart](./QUICKSTART.md) — first loop in 5 minutes
- [Safety](./SAFETY.md) — read before L2/L3
