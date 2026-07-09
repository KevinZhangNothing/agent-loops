# Republishing as `@kevinzhangnothing/*` — Operator's Guide

**Audience**: you (the maintainer) running this on your local machine.
**Time**: ~30 minutes for the first run, ~5 minutes for re-runs.
**Risk**: low — all steps are reversible (you can un-deprecate packages via `npm deprecate` with an empty message, and `npm unpublish` works within 72 hours of a new release).

---

## Why this is needed

The repository was rebranded from `@cobusgreyling/*` to `@kevinzhangnothing/*` in the
initial commits. The **source code, docs, and `package.json` metadata** all point at
the new scope. But the **actual published packages on npm** still live under the
old scope. To complete the rebrand, the 8 packages must be **republished** under
the new scope.

This is **not** a rename — npm doesn't support renames. The old packages will
continue to exist (you can deprecate them). New users install from the new scope
and never see the old one.

---

## What you (the human) have to do — 3 steps

These three steps need a browser and your npm account. The rest is automated.

### Step 1: Register an npm account (if you don't have one)

Go to https://www.npmjs.com/signup. Use the email you want associated with the
publishing identity.

### Step 2: Subscribe to npm and create the `kevinzhangnothing` organization

1. Sign in to https://www.npmjs.com
2. Go to https://www.npmjs.com/settings/<your-username>/billing
3. Subscribe to a plan that supports **scoped packages** (Teams plan, $7/month).
   The "User" plan is enough for a single scope; the "Org" plan is for multi-org.
4. After subscribing, go to
   https://www.npmjs.com/settings/<your-username>/organizations
5. Click **Create a new Organization** and name it `kevinzhangnothing`.
   - Visibility: **public** (so anyone can install your packages)
   - This is the org that owns the `@kevinzhangnothing/*` scope.
6. (Strongly recommended) Enable 2FA on your account:
   https://www.npmjs.com/settings/<your-username>/tfa
   npm requires 2FA for publishing since 2022.

### Step 3: Log in on your local machine

```bash
npm adduser
# Enter username, password, email, 2FA OTP
# Verify: npm whoami  → should print your username
```

Then verify you're a member of the org:

```bash
npm org ls kevinzhangnothing
# You should see your username listed
```

If you don't see your username, an existing owner must add you:

```bash
# (run by an existing owner)
npm org add kevinzhangnothing <your-username> developers
```

---

## What the scripts do (after the 3 manual steps)

Once you're logged in, everything else is two commands:

### A. Publish the 8 packages under the new scope

```bash
cd /path/to/loop-engineering
bash scripts/publish-npm-scope.sh
```

The script will:

1. Run preflight checks:
   - `npm` is installed (Node ≥ 18)
   - You're logged in (`npm whoami`)
   - You're a member of `kevinzhangnothing`
   - Each of the 8 `package.json` has the correct `name` field
2. Show you what it's about to publish (8 packages, in dependency order)
3. Ask for a confirmation (`yes`)
4. For each package: `npm run build` (if needed) + `npm publish --access public`
5. Skip packages whose version is already published (idempotent)
6. Print a final report

You can re-run it safely. To force a re-publish, bump the version first:

```bash
cd tools/loop-audit
npm version patch          # 1.6.0 → 1.6.1
cd ../..
bash scripts/publish-npm-scope.sh
```

#### Single-package mode

```bash
bash scripts/publish-npm-scope.sh loop-audit     # publish only loop-audit
```

#### Dry-run

```bash
bash scripts/publish-npm-scope.sh --dry-run      # see what would happen
```

### B. Deprecate the old `@cobusgreyling/*` packages (recommended)

```bash
bash scripts/deprecate-old-scope.sh
```

This calls `npm deprecate @cobusgreyling/<pkg> "<message>"` for each of the 8
packages. After this, anyone running `npx @cobusgreyling/loop-audit` will see:

```
npm warn deprecated @cobusgreyling/loop-audit@1.6.0:
This package has been republished as @kevinzhangnothing/loop-audit.
See https://github.com/KevinZhangNothing/loop-engineering
```

⚠️ **This step only works if you are a maintainer of `@cobusgreyling/*`.** If
you are not (e.g. you don't have access to the original publisher's account),
this script will fail on every package. That's fine — skip it. The new scope
will work independently.

#### Dry-run

```bash
bash scripts/deprecate-old-scope.sh --dry-run
```

---

## Verification

After both scripts finish, verify the new scope works end-to-end:

```bash
# 1. New scope installs
npx @kevinzhangnothing/loop-audit . --version

# 2. New scope passes the audit on this repo
npx @kevinzhangnothing/loop-audit . --suggest
# Expected: Score 100/100, Level L3

# 3. Old scope shows deprecation warning
npx @cobusgreyling/loop-audit . --version
# Expected: npm warn deprecated ... message

# 4. Check the registry directly
npm view @kevinzhangnothing/loop-audit
npm view @kevinzhangnothing/loop-audit versions
```

---

## The 8 packages being published

| Name | Current version | Depends on |
|------|----------------|------------|
| `@kevinzhangnothing/loop-audit` | 1.6.0 | — |
| `@kevinzhangnothing/loop-cost` | 1.0.3 | — |
| `@kevinzhangnothing/loop-init` | 1.3.3 | — |
| `@kevinzhangnothing/loop-sync` | 1.0.0 | — |
| `@kevinzhangnothing/loop-context` | 1.0.0 | — |
| `@kevinzhangnothing/loop-worktree` | 1.0.0 | — |
| `@kevinzhangnothing/goal-audit` | 1.0.2 | — |
| `@kevinzhangnothing/loop-mcp-server` | 1.0.0 | — |

Order in the publish script is dependency-aware (leaves first, then consumers),
but in this case none of the published packages have runtime dependencies on
each other — they're all standalone CLIs. The order is purely conventional.

---

## Rolling back

If something goes wrong:

| Step | Reversible? | How |
|------|-------------|-----|
| `npm publish` of a new version | Yes (within 72h) | `npm unpublish @kevinzhangnothing/<pkg>@<ver>` |
| `npm publish` after 72h | Partial | Cannot unpublish. Use `npm deprecate` to mark broken. |
| `npm deprecate @cobusgreyling/*` | Yes | `npm deprecate @cobusgreyling/<pkg> ""` (empty message) |
| Wrong org / scope | Manual | Contact npm support: https://www.npmjs.com/support |

The publish script is **idempotent**: re-running it for a package at the same
version is a no-op.

---

## After the rebrand — ongoing

- **CI / release workflow**: update `.github/workflows/release-loop-*.yml` to
  use the new scope when invoking `npm publish`. (See TODO below.)
- **Documentation**: already updated in the previous rebrand commit.
- **GitHub badges**: README shields.io URLs already point at the new scope.

### TODO (post-publish)

The 9 release workflows (`.github/workflows/release-loop-*.yml`) currently use
`@cobusgreyling` tokens or scope references. They may need to be re-keyed with
a new `NPM_TOKEN` secret tied to your npm account. See
[docs/RELEASE.md](./RELEASE.md) for the publish workflow.

---

## Reference: npm commands used by the scripts

If you prefer to run the commands manually instead of the scripts:

```bash
# Check you're logged in
npm whoami

# Verify org membership
npm org ls kevinzhangnothing

# Publish one package
cd tools/loop-audit
npm install            # ensure deps are installed
npm run build          # compile TypeScript → dist/
npm publish --access public

# Check what was published
npm view @kevinzhangnothing/loop-audit versions

# Deprecate an old package
npm deprecate @cobusgreyling/loop-audit \
  "Republished as @kevinzhangnothing/loop-audit"
```

---

## Cost

- npm Teams plan: $7/month
- Time investment: ~30 min the first time, ~5 min for version bumps
- Domain (`kevinzhangnothing.com`) already used in security email — if you
  don't actually own this domain, update `SECURITY.md` accordingly

---

*Last updated: 2026-07-09 (v2 rebrand)*
