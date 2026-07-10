# Publishing npm Packages

This guide covers publishing the `@kevinzhangnothing/loop-*` packages to npm.

## Prerequisites

1. **npm account** — Sign up at https://www.npmjs.com/signup
2. **npm login** — Run `npm login` in your terminal
3. **2FA enabled** — Required for publishing (use `npm profile enable-2fa auth-and-writes`)

## Quick Publish (All Packages)

```bash
# 1. Login to npm
npm login

# 2. Build all tools
npm run build:tools

# 3. Test all tools
npm run test:tools

# 4. Publish all (in correct order)
npm run publish:all
```

This publishes packages in dependency order:
1. `@kevinzhangnothing/loop-audit`
2. `@kevinzhangnothing/loop-cost`
3. `@kevinzhangnothing/loop-sync`
4. `@kevinzhangnothing/loop-context`
5. `@kevinzhangnothing/loop-worktree`
6. `@kevinzhangnothing/loop-mcp-server`
7. `@kevinzhangnothing/loop-init` (depends on loop-audit)

## Manual Publish (Single Package)

```bash
# Navigate to package
cd tools/loop-audit

# Build
npm run build

# Test
npm test

# Publish
npm publish --access public
```

## Verify Publication

1. **Check npm:** https://www.npmjs.com/org/kevinzhangnothing
2. **Test installation:**
   ```bash
   npx @kevinzhangnothing/loop-audit --version
   npx @kevinzhangnothing/loop-init --help
   npx @kevinzhangnothing/loop-cost --help
   ```

## Version Bumping

Before publishing, bump versions according to semver:

```bash
# In package directory
npm version patch  # 1.0.0 → 1.0.1 (bug fix)
npm version minor  # 1.0.0 → 1.1.0 (new feature)
npm version major  # 1.0.0 → 2.0.0 (breaking change)
```

This updates `package.json`, creates a git commit, and tags the release.

## Troubleshooting

### "EPUBLISHCONFLICT: Cannot publish over existing version"

Bump the version:
```bash
npm version patch
npm publish --access public
```

### "E404: Not found"

Make sure you're using the correct scope:
- Package name: `@kevinzhangnothing/loop-audit`
- Publish command: `npm publish --access public`

### "EOTP: One-time password required"

Enter your npm 2FA code when prompted.

### "You do not have permission to publish"

Make sure you're logged in as the package owner:
```bash
npm whoami
npm owner add <username> @kevinzhangnothing/loop-audit
```

## Package Status

| Package | Version | Status |
|---------|---------|--------|
| `@kevinzhangnothing/loop-audit` | 1.6.0 | Ready to publish |
| `@kevinzhangnothing/loop-init` | 1.3.3 | Ready to publish |
| `@kevinzhangnothing/loop-cost` | 1.0.3 | Ready to publish |
| `@kevinzhangnothing/loop-sync` | 1.0.0 | Ready to publish |
| `@kevinzhangnothing/loop-context` | 1.0.0 | Ready to publish |
| `@kevinzhangnothing/loop-worktree` | 1.0.0 | Ready to publish |
| `@kevinzhangnothing/loop-mcp-server` | 1.0.0 | Ready to publish |

## Post-Publish

After publishing, update the README badges:

```markdown
[![loop-audit](https://img.shields.io/npm/v/@kevinzhangnothing/loop-audit?label=loop-audit)](https://www.npmjs.com/package/@kevinzhangnothing/loop-audit)
[![loop-init](https://img.shields.io/npm/v/@kevinzhangnothing/loop-init?label=loop-init)](https://www.npmjs.com/package/@kevinzhangnothing/loop-init)
```

## Links

- [npm publishing docs](https://docs.npmjs.com/packages-and-modules/contributing-packages-to-the-registry)
- [npm organization docs](https://docs.npmjs.com/organizations)
- [Your npm org](https://www.npmjs.com/org/kevinzhangnothing)
