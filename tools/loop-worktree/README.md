# loop-worktree

Manage isolated [git worktrees](https://git-scm.com/docs/git-worktree) for loop engineering attempts. One worktree per fix attempt; mark it when the verifier rejects or a human escalates; sweep the discarded ones.

`LOOP.md` and `docs/primitives.md` describe this convention in prose ("one worktree per fix; discard after verifier REJECT or human escalation"). This tool is the code behind it: a shared place for worktrees to live, a manifest that tracks their status, and a reconciler that sweeps orphans.

## Install & Run

```bash
npx @cobusgreyling/loop-worktree create --run-id ci-sweeper-2026-07-07-01 --pattern ci-sweeper
npx @cobusgreyling/loop-worktree list
```

**From this repo:**

```bash
cd tools/loop-worktree
npm install
npm test
```

## Commands

```bash
loop-worktree create --run-id <id> --pattern <p> [--base main]
  # git worktree add -b loop/<id> .loop-worktrees/<id> <base>, records the manifest entry

loop-worktree mark --run-id <id> --status rejected
  # updates the manifest only (audit trail); does not delete the worktree

loop-worktree cleanup [--status rejected,escalated] [--older-than 24h] [--force]
  # git worktree remove for matching entries, then prunes them from the manifest

loop-worktree gc [--force] [--json]
  # reconciles `git worktree list` against the manifest:
  #   - on disk under .loop-worktrees/ but not in the manifest -> reported as an orphan
  #   - in the manifest but not on disk -> dropped from the manifest
  # report-only by default; --force removes orphans

loop-worktree list [--status active] [--json]
```

## Status

An entry is one of: `active`, `rejected`, `escalated`, `merged`, `stale`.

`cleanup` sweeps `rejected` and `escalated` by default. `active` is never swept automatically.

## Safety

- `create` fails with a clear message (not a raw git error) if the directory is not a git repo, or if `--run-id` already has an active worktree.
- `cleanup` runs `git worktree remove` without `--force` first, so git refuses to delete a worktree with uncommitted or untracked changes; that entry is reported as skipped. Pass `--force` only when you accept the data loss.
- `gc` is report-only by default, matching the repo's convention that anything scanning broadly reports rather than acts.

## Pairing with loop-context

A loop's control script that calls [`loop-context`](../loop-context) `--check` and escalates should also mark its worktree:

```bash
loop-worktree mark --run-id "$RUN_ID" --status escalated
```

The two tools stay independent: `loop-worktree` does not read the ledger, and `loop-context` does not know about git.

## Manifest

`.loop-worktrees/manifest.json` (add `.loop-worktrees/` to `.gitignore`):

```json
{
  "version": 1,
  "worktrees": [
    {
      "id": "ci-sweeper-2026-07-07-01",
      "path": ".loop-worktrees/ci-sweeper-2026-07-07-01",
      "branch": "loop/ci-sweeper-2026-07-07-01",
      "baseBranch": "main",
      "pattern": "ci-sweeper",
      "createdAt": "2026-07-07T08:00:00.000Z",
      "status": "active"
    }
  ]
}
```

See [docs/primitives.md](../../docs/primitives.md) for where worktrees fit in the Five Building Blocks + Memory model.
