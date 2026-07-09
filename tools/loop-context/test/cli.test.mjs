import { test } from 'node:test';
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const cli = path.join(path.dirname(fileURLToPath(import.meta.url)), '../dist/cli.js');

const stagnationLedger = JSON.stringify({
  goal: 'x',
  attempts: [
    { iteration: 1, action: 'a', outcome: 'failure', error: 'boom' },
    { iteration: 2, action: 'a', outcome: 'failure', error: 'boom' },
    { iteration: 3, action: 'a', outcome: 'failure', error: 'boom' },
  ],
});

function runCli(args, input = stagnationLedger) {
  return spawnSync(process.execPath, [cli, ...args], {
    input,
    encoding: 'utf8',
  });
}

test('cli --check trips stagnation with default threshold', () => {
  const r = runCli(['--check', '--json']);
  assert.equal(r.status, 2);
  const decision = JSON.parse(r.stdout);
  assert.equal(decision.trigger, 'stagnation');
});

test('cli rejects invalid --stagnation values before running the breaker', () => {
  const r = runCli(['--check', '--stagnation', 'nope', '--json']);
  assert.equal(r.status, 1);
  assert.match(r.stderr, /--stagnation must be a positive integer/);
});

test('cli rejects invalid --no-progress values', () => {
  const r = runCli(['--check', '--no-progress', '0', '--json']);
  assert.equal(r.status, 1);
  assert.match(r.stderr, /--no-progress must be a positive integer/);
});

test('cli rejects invalid --max-iterations values', () => {
  const r = runCli(['--check', '--max-iterations', '1.5', '--json']);
  assert.equal(r.status, 1);
  assert.match(r.stderr, /--max-iterations must be a positive integer/);
});

test('cli rejects missing numeric flag values', () => {
  const r = runCli(['--check', '--stagnation']);
  assert.equal(r.status, 1);
  assert.match(r.stderr, /--stagnation requires a positive integer value/);
});