---
name: rebase-and-clean
description: >
  Safe rebase and commit-history cleanup for watched PRs in pr-babysitter.
  Honors loop-constraints.md (no force-push to protected branches, draft PR
  first, human approval for auto-merge) and enforces a per-PR attempt cap.
user_invocable: true
---

# Rebase and Clean Skill

You keep a watched PR tidy so it can merge cleanly. You are **not** an
implementer — if a rebase surfaces a real conflict in a denylisted path, you
hand off to `minimal-fix` (or escalate-human), you do not patch it yourself.

## When to run

From `pr-babysitter` only, and only when:

- CI is **green** or already triaged by `ci-triage`.
- Review status is `approved` or `changes_requested` (no `pending` reviews).
- The PR is **not** idle > 7 days (that's a human-handoff signal).

## Pre-flight (mandatory)

Read `loop-constraints.md` and stop if **any** of these are violated:

1. **Allowed branches** — head branch must match `allowed_branches` from
   `loop-constraints.md`. If not → `escalate-human`. Do **not** rebase
   anything outside the allow-list.
2. **Protected branches** — never `--force-push` to `main`, `master`,
   `release/*`, or anything tagged `protected` in constraints. Use
   `--force-with-lease` at most, and only on the PR's own head branch.
3. **Draft PR first** — if the PR is not yet a draft and the loop has
   touched it, ensure it is converted to draft before any push. Auto-merge
   stays `false`; only the human flips it.
4. **Attempt cap** — `loop-constraints.md` says "Max 3 fix attempts per item;
   escalate after". Log each rebase attempt to `loop-ledger.json` (the same
   ledger `loop-guard` watches) so the breaker trips on the 4th try.

## Process

1. Check the head branch for noise commits: `fix typo`, `wip`, `address
   review`, `oops`, `format`. Suggest squash into the parent commit.
2. Check `git fetch origin <base>` and `git merge-tree` for conflicts with
   the base tip.
3. If **no conflict** and **no noise** → no-op. Report and exit.
4. If conflict in a **denylisted path** (`.env`, `auth/`, `payments/`,
   `secrets/`, `credentials/`, `tools/loop-audit/src/`, `docs/primitives*.md`)
   → `escalate-human` immediately. Do not rebase past these.
5. If conflict in any other path → rebase in an isolated worktree
   (`loop-worktree create --run-id <id> --pattern pr-babysitter`),
   resolve, run the project's test command from `AGENTS.md`.
6. Push (non-force, or `--force-with-lease` on the PR's own head only).
   Report the new head SHA.

## Output

```markdown
## Rebase & Clean Report — PR #N

- Head: feature/foo @ <old-sha> → <new-sha>
- Commits: X (Y squashable)
- Conflicts: yes | no
- Denylist touched: yes | no → escalate
- Worktree: <path> (cleaned up: yes)
- Pushed: yes | no
- Attempts this run: N (cap: 3)
- Human review needed: yes | no
```

## Interaction

- `pr-review-triage` decides *whether* a PR is worth touching. This skill
  decides *how* to touch it. Never run without triage first.
- `loop-guard` enforces the attempt cap mechanically. Append every attempt
  to `loop-ledger.json` — same schema as `ci-sweeper` uses.
- `loop-verifier` is **not** required for a pure rebase (no code change), but
  **is** required if the rebase resolved conflicts that altered logic.

## Rules

- One PR per invocation. Never batch.
- Never rebase a PR whose head branch is shared with another open PR unless
  both authors have been notified (drop a comment first).
- If the rebase would touch > 5 files → stop, escalate-human. That's not a
  rebase, that's a merge problem.
- Always clean up the worktree on exit (success or failure).