#!/usr/bin/env node
import { createWorktree, markWorktree, cleanupWorktrees, gc, listWorktrees, VALID_STATUSES, } from './worktree.js';
function parseFlags(argv) {
    const flags = { root: process.cwd(), force: false, json: false };
    for (let i = 0; i < argv.length; i++) {
        const a = argv[i];
        if (a === '--run-id')
            flags.runId = argv[++i];
        else if (a === '--pattern')
            flags.pattern = argv[++i];
        else if (a === '--base')
            flags.base = argv[++i];
        else if (a === '--status')
            flags.status = argv[++i];
        else if (a === '--older-than')
            flags.olderThan = argv[++i];
        else if (a === '--root')
            flags.root = argv[++i];
        else if (a === '--force')
            flags.force = true;
        else if (a === '--json')
            flags.json = true;
    }
    return flags;
}
function parseStatuses(csv) {
    return csv.split(',').map((s) => {
        const t = s.trim();
        if (!VALID_STATUSES.includes(t)) {
            throw new Error(`Invalid status "${t}". Use: ${VALID_STATUSES.join(', ')}.`);
        }
        return t;
    });
}
const HELP = `loop-worktree - manage isolated git worktrees for loop attempts

Usage:
  loop-worktree create --run-id <id> --pattern <p> [--base main]
  loop-worktree mark   --run-id <id> --status <${VALID_STATUSES.join('|')}>
  loop-worktree cleanup [--status rejected,escalated] [--older-than 24h] [--force]
  loop-worktree gc [--force] [--json]
  loop-worktree list [--status <s>] [--json]

Common flags:
  --root <dir>   Repo root to operate in (default: cwd)
  --json         Machine-readable output (list, gc)
  --force        Allow removing worktrees with uncommitted changes / orphans

Worktrees live under .loop-worktrees/, tracked in .loop-worktrees/manifest.json.
Add .loop-worktrees/ to .gitignore.`;
async function main() {
    const argv = process.argv.slice(2);
    const command = argv[0];
    if (!command || command === '--help' || command === '-h') {
        console.log(HELP);
        return command ? 0 : 1;
    }
    const flags = parseFlags(argv.slice(1));
    switch (command) {
        case 'create': {
            if (!flags.runId || !flags.pattern) {
                throw new Error('create requires --run-id and --pattern.');
            }
            const entry = await createWorktree({
                root: flags.root,
                runId: flags.runId,
                pattern: flags.pattern,
                base: flags.base,
            });
            console.log(`created worktree ${entry.path} on branch ${entry.branch} (base ${entry.baseBranch})`);
            return 0;
        }
        case 'mark': {
            if (!flags.runId || !flags.status) {
                throw new Error('mark requires --run-id and --status.');
            }
            const entry = await markWorktree({
                root: flags.root,
                runId: flags.runId,
                status: flags.status,
            });
            console.log(`marked ${entry.id} as ${entry.status}`);
            return 0;
        }
        case 'cleanup': {
            const result = await cleanupWorktrees({
                root: flags.root,
                statuses: flags.status ? parseStatuses(flags.status) : undefined,
                olderThan: flags.olderThan,
                force: flags.force,
            });
            for (const e of result.removed)
                console.log(`removed ${e.path} (${e.status})`);
            for (const s of result.skipped)
                console.log(`skipped ${s.entry.path}: ${s.reason}`);
            console.log(`cleanup: ${result.removed.length} removed, ${result.skipped.length} skipped`);
            return 0;
        }
        case 'gc': {
            const result = await gc({ root: flags.root, force: flags.force });
            if (flags.json) {
                console.log(JSON.stringify(result, null, 2));
                return 0;
            }
            for (const o of result.orphans) {
                console.log(result.removedOrphans.includes(o) ? `removed orphan ${o}` : `orphan ${o}`);
            }
            for (const d of result.dropped)
                console.log(`dropped stale manifest entry ${d.id}`);
            console.log(`gc: ${result.orphans.length} orphan(s), ${result.dropped.length} dropped` +
                (flags.force ? `, ${result.removedOrphans.length} removed` : ' (report-only; use --force to remove orphans)'));
            return 0;
        }
        case 'list': {
            const entries = await listWorktrees({
                root: flags.root,
                status: flags.status,
            });
            if (flags.json) {
                console.log(JSON.stringify(entries, null, 2));
                return 0;
            }
            if (entries.length === 0) {
                console.log('no worktrees tracked');
                return 0;
            }
            for (const e of entries) {
                console.log(`${e.status.padEnd(9)} ${e.id}  ${e.branch}  (${e.pattern})`);
            }
            return 0;
        }
        default:
            console.error(`Unknown command "${command}".\n\n${HELP}`);
            return 1;
    }
}
main()
    .then((code) => process.exit(code))
    .catch((err) => {
    console.error(err instanceof Error ? err.message : String(err));
    process.exit(1);
});
