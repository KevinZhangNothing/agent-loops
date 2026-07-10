# npm Setup Guide — @kevinzhangnothing

This guide walks you through setting up npm publishing for the `@kevinzhangnothing` organization.

## Quick Start

```bash
# 1. Login to npm
npm login

# 2. Build all tools
npm run build:tools

# 3. Test locally
./scripts/test-npx.sh

# 4. Publish all
npm run publish:all
```

## Step 1: Create npm Account

1. Go to https://www.npmjs.com/signup
2. Create account with username: `kevinzhangnothing` (or your preferred)
3. Verify email

## Step 2: Login to npm

```bash
npm login
```

You'll be prompted for:
- Username
- Password
- Email
- OTP (if 2FA enabled)

**Verify login:**
```bash
npm whoami
# Should output: kevinzhangnothing
```

## Step 3: Enable 2FA (Required)

npm requires 2FA for publishing:

```bash
npm profile enable-2fa auth-and-writes
```

Save your 2FA codes in a secure location.

## Step 4: Test Locally (Before Publishing)

```bash
# Build all tools
npm run build:tools

# Test all CLIs
./scripts/test-npx.sh

# Expected output:
# ✅ All CLI tools working!
```

## Step 5: Publish All Packages

```bash
npm run publish:all
```

This publishes in dependency order:
1. `@kevinzhangnothing/loop-audit`
2. `@kevinzhangnothing/loop-cost`
3. `@kevinzhangnothing/loop-sync`
4. `@kevinzhangnothing/loop-context`
5. `@kevinzhangnothing/loop-worktree`
6. `@kevinzhangnothing/loop-mcp-server`
7. `@kevinzhangnothing/loop-init`

**Enter 2FA code when prompted.**

## Step 6: Verify Publication

1. **Check npm organization:**
   https://www.npmjs.com/org/kevinzhangnothing

2. **Test npx commands:**
   ```bash
   npx @kevinzhangnothing/loop-audit --version
   npx @kevinzhangnothing/loop-init --help
   npx @kevinzhangnothing/loop-cost --list
   ```

3. **Test in a new project:**
   ```bash
   mkdir /tmp/test-loop
   cd /tmp/test-loop
   git init
   npx @kevinzhangnothing/loop-init . --pattern daily-triage --tool grok
   npx @kevinzhangnothing/loop-audit . --suggest
   ```

## Troubleshooting

### "EPUBLISHCONFLICT: Cannot publish over existing version"

The version already exists. Bump version:

```bash
cd tools/loop-audit
npm version patch  # or minor/major
npm publish --access public
cd ../..
```

### "E401: Unauthorized"

You're not logged in:

```bash
npm login
npm whoami  # Should show your username
```

### "E404: Not found"

Make sure package name uses correct scope:
- ✅ `@kevinzhangnothing/loop-audit`
- ❌ `kevinzhangnothing/loop-audit`

### "EOTP: One-time password required"

Enter your 2FA code from authenticator app.

### Package already exists under different scope

If packages were previously published under different scope (e.g., `@cobusgreyling/*`), you need to:

1. Publish with new version number
2. Update README to reference new scope
3. Deprecate old versions (optional):
   ```bash
   npm deprecate @cobusgreyling/loop-audit "Deprecated: use @kevinzhangnothing/loop-audit"
   ```

## Package Versions

Current versions ready to publish:

| Package | Version | Status |
|---------|---------|--------|
| `@kevinzhangnothing/loop-audit` | 1.6.0 | ✅ Ready |
| `@kevinzhangnothing/loop-init` | 1.3.3 | ✅ Ready |
| `@kevinzhangnothing/loop-cost` | 1.0.3 | ✅ Ready |
| `@kevinzhangnothing/loop-sync` | 1.0.0 | ✅ Ready |
| `@kevinzhangnothing/loop-context` | 1.0.0 | ✅ Ready |
| `@kevinzhangnothing/loop-worktree` | 1.0.0 | ✅ Ready |
| `@kevinzhangnothing/loop-mcp-server` | 1.0.0 | ✅ Ready |

## Update README After Publishing

After successful publish, update badges in README.md:

```markdown
[![loop-audit](https://img.shields.io/npm/v/@kevinzhangnothing/loop-audit?label=loop-audit)](https://www.npmjs.com/package/@kevinzhangnothing/loop-audit)
[![loop-init](https://img.shields.io/npm/v/@kevinzhangnothing/loop-init?label=loop-init)](https://www.npmjs.com/package/@kevinzhangnothing/loop-init)
[![loop-cost](https://img.shields.io/npm/v/@kevinzhangnothing/loop-cost?label=loop-cost)](https://www.npmjs.com/package/@kevinzhangnothing/loop-cost)
```

## Links

- [npm publishing docs](https://docs.npmjs.com/packages-and-modules/contributing-packages-to-the-registry)
- [npm organizations](https://docs.npmjs.com/organizations)
- [Your npm org](https://www.npmjs.com/org/kevinzhangnothing)
- [npm 2FA docs](https://docs.npmjs.com/securing-your-npm-account/adding-two-factor-authentication-to-your-npm-account)

## Next Steps

After publishing:

1. ✅ Test npx commands in fresh directory
2. ✅ Update README with working badges
3. ✅ Announce in GitHub Discussions
4. ✅ Update adopters with new installation method
5. 📅 Set up automated releases (GitHub Actions + semantic-release)
