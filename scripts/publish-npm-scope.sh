#!/bin/bash
#
# publish-npm-scope.sh — republish loop-engineering tools under @kevinzhangnothing
#
# Pre-requisites (you must do these BEFORE running this script):
#
#   1. Register an npm account at https://www.npmjs.com/signup (if needed)
#
#   2. Subscribe to npm and create the "kevinzhangnothing" organization:
#        https://www.npmjs.com/settings/<your-username>/organizations
#        (Cost: $7/month for the "Teams" plan, free for public-only orgs)
#
#   3. Make your user a member of the @kevinzhangnothing org with publish rights.
#
#   4. From your local machine (this is interactive — needs your npm credentials):
#
#        npm adduser        # log in as the user that owns the org
#        npm org ls kevinzhangnothing   # verify membership
#
#   5. (Optional) Set 2FA on your npm account. Required for publishing scoped
#      packages on the "publish" level since 2022.
#
# Usage:
#
#   bash scripts/publish-npm-scope.sh           # build + publish all 8 packages
#   bash scripts/publish-npm-scope.sh --dry-run # show what would be published
#   bash scripts/publish-npm-scope.sh <pkg>     # publish only one package, e.g.
#                                               #   bash scripts/publish-npm-scope.sh loop-audit
#
# 2FA OTP handling:
#
#   The script prompts for a 6-digit OTP before each 'npm publish' (the
#   account has 2FA enabled, which is required for scoped package publishing).
#   Type 's' at the prompt to skip that package.
#
#   To suppress prompts: export NPM_PUBLISH_OTP=000000  (rarely useful)
#                        bash scripts/publish-npm-scope.sh --no-2fa  (will fail
#                        on accounts that require OTP)
#
# The script is idempotent per-package: re-running it for a package that is
# already published at the same version will be a no-op (npm refuses duplicate
# versions). To force a re-publish, bump the version first with `npm version`.
#
# After this script finishes, run:
#
#   bash scripts/deprecate-old-scope.sh   # mark @cobusgreyling/* as deprecated
#

set -euo pipefail

# The npm scope we're publishing under.
EXPECTED_SCOPE="@kevinzhangnothing"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Resolve repo root (script lives in scripts/, so .. is the root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
TOOLS_DIR="$REPO_ROOT/tools"

# Packages to publish, in dependency order (leaves first, then consumers).
# loop-mcp-server has no dependencies, but listed last as the "headline" tool.
# Two parallel arrays: PACKAGES = npm names, PACKAGE_DIRS = source dirs.
# The two are the same EXCEPT loop-mcp-server, whose source lives in
# tools/mcp-server/ (kept the historical directory name to match
# README docs and starter templates).
PACKAGE_DIRS=(
  "loop-audit"
  "loop-cost"
  "loop-init"
  "loop-sync"
  "loop-context"
  "loop-worktree"
  "goal-audit"
  "mcp-server"
)
PACKAGES=(
  "loop-audit"
  "loop-cost"
  "loop-init"
  "loop-sync"
  "loop-context"
  "loop-worktree"
  "goal-audit"
  "loop-mcp-server"
)

log_info()  { echo -e "${BLUE}[INFO]${NC}  $1"; }
log_ok()    { echo -e "${GREEN}[OK]${NC}    $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

usage() {
  sed -n '2,40p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
}

# Parse flags
DRY_RUN=false
ONLY_PKG=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --help|-h) usage ;;
    -*) log_error "Unknown flag: $1"; usage ;;
    *)
      if [ -z "$ONLY_PKG" ]; then ONLY_PKG="$1"; else log_error "Too many args"; usage; fi
      shift
      ;;
  esac
done

# ---------- preflight checks ----------

log_info "Preflight checks..."

# 1. npm is installed
if ! command -v npm >/dev/null 2>&1; then
  log_error "npm not found. Install Node.js >= 18 first."
  exit 1
fi
log_ok "npm $(npm --version) installed"

# 2. user is logged in
NPM_USER="$(npm whoami 2>/dev/null || true)"
if [ -z "$NPM_USER" ]; then
  log_error "You are not logged in to npm. Run:  npm adduser"
  exit 1
fi
log_ok "Logged in as: $NPM_USER"

# 3. user has access to @kevinzhangnothing scope
log_info "Checking @${EXPECTED_SCOPE#@} org membership..."
if ! npm org ls "$EXPECTED_SCOPE" 2>/dev/null | grep -q "^$NPM_USER"; then
  log_error "User '$NPM_USER' is NOT a member of '$EXPECTED_SCOPE'."
  log_error "Either:"
  log_error "  a) Create the org at https://www.npmjs.com/settings/$NPM_USER/organizations"
  log_error "  b) Ask an existing owner to add you with: npm adduser $EXPECTED_SCOPE"
  exit 1
fi
log_ok "User is a member of $EXPECTED_SCOPE"

# 4. every package has the expected scope
log_info "Verifying package name fields..."
BAD=0
for i in "${!PACKAGES[@]}"; do
  pkg="${PACKAGES[$i]}"
  dir_name="${PACKAGE_DIRS[$i]}"
  pkg_json="$TOOLS_DIR/$dir_name/package.json"
  if [ ! -f "$pkg_json" ]; then
    log_error "Missing: $pkg_json"
    BAD=$((BAD + 1))
    continue
  fi
  name=$(node -e "console.log(require('$pkg_json').name)" 2>/dev/null || echo "PARSE_ERROR")
  if [ "$name" = "PARSE_ERROR" ]; then
    log_error "$pkg: package.json failed to parse"
    BAD=$((BAD + 1))
  elif [ "$name" != "$EXPECTED_SCOPE/$pkg" ]; then
    log_error "$pkg: name is '$name', expected '$EXPECTED_SCOPE/$pkg'"
    BAD=$((BAD + 1))
  fi
done
if [ $BAD -gt 0 ]; then
  log_error "Fix the package names above before publishing. (See docs/REBRAND-NPM.md)"
  exit 1
fi
log_ok "All 8 packages have correct scope"

# 5. every package has been built
log_info "Verifying dist/ exists for each package..."
for i in "${!PACKAGES[@]}"; do
  dir_name="${PACKAGE_DIRS[$i]}"
  pkg="${PACKAGES[$i]}"
  if [ ! -d "$TOOLS_DIR/$dir_name/dist" ]; then
    log_warn "$pkg: dist/ missing — will build now"
  fi
done

# Filter to single package if requested
if [ -n "$ONLY_PKG" ]; then
  FOUND=0
  for i in "${!PACKAGES[@]}"; do
    if [ "${PACKAGES[$i]}" = "$ONLY_PKG" ]; then
      FOUND=1
      PACKAGES=("$ONLY_PKG")
      PACKAGE_DIRS=("${PACKAGE_DIRS[$i]}")
      break
    fi
  done
  if [ $FOUND -eq 0 ]; then
    log_error "Unknown package: $ONLY_PKG"
    log_error "Valid: ${PACKAGES[*]}"
    exit 1
  fi
  log_info "Single-package mode: $ONLY_PKG"
fi

# 2FA handling
# -----------------
# npm requires a 2FA one-time password (OTP) for every publish when the
# account has 2FA enabled (which is required for scoped package publishing
# as of 2022). The OTP expires after 30 seconds, so we have to ask for a
# fresh one before each publish.
#
# Three modes are supported:
#
#   1) INTERACTIVE (default): the script prompts for an OTP before each
#      'npm publish'. You type the 6-digit code from your authenticator
#      and hit Enter. The input is hidden (read -s).
#
#   2) AUTO from env: if NPM_PUBLISH_OTP is set in the environment, that
#      single OTP is used for every publish. Useful only if you've set
#      a long-lived token and disabled per-publish 2FA (not recommended).
#
#   3) SKIP 2FA: pass --no-2fa to skip the prompt. 'npm publish' will
#      fail with EOTP unless your account is configured to not require
#      OTP (e.g. legacy accounts with granular tokens).
OTP_MODE="interactive"
if [ "${NPM_PUBLISH_OTP:-}" != "" ]; then
  OTP_MODE="env"
fi
if [ "${1:-}" = "--no-2fa" ] || [ "${2:-}" = "--no-2fa" ] || [ "${3:-}" = "--no-2fa" ]; then
  OTP_MODE="none"
  log_warn "Running with --no-2fa; publish will fail if your account requires OTP"
fi

# Function: get an OTP for a publish.
# Echoes the OTP code (6 digits) on stdout, or empty string to skip.
get_otp() {
  case "$OTP_MODE" in
    env)
      echo "$NPM_PUBLISH_OTP"
      ;;
    none)
      # Return empty + unique sentinel so callers can distinguish "no OTP" from
      # "user pressed enter with no value". We use a newline + sentinel.
      printf '%s\n' ""
      ;;
    interactive)
      local tries=3
      while [ $tries -gt 0 ]; do
        echo "" >&2
        echo -e "${YELLOW}  ┌──────────────────────────────────────────────┐${NC}" >&2
        echo -e "${YELLOW}  │  2FA required: open your authenticator app  │${NC}" >&2
        echo -e "${YELLOW}  │  Enter the 6-digit code (or 's' to skip):    │${NC}" >&2
        echo -e "${YELLOW}  └──────────────────────────────────────────────┘${NC}" >&2
        local otp
        read -r -s -p "  OTP> " otp
        echo "" >&2
        if [ "$otp" = "s" ] || [ "$otp" = "S" ]; then
          # Skip — return empty + sentinel
          printf '%s\n' "__SKIP__"
          return
        fi
        if echo "$otp" | grep -qE '^[0-9]{6}$'; then
          printf '%s' "$otp"
          return
        fi
        tries=$((tries - 1))
        echo -e "${RED}  Invalid OTP (must be 6 digits). $tries tries left.${NC}" >&2
      done
      printf '%s\n' "__SKIP__"
      ;;
  esac
}

# ---------- summary ----------

echo ""
log_info "Will publish these packages in this order:"
for i in "${!PACKAGES[@]}"; do
  pkg="${PACKAGES[$i]}"
  pkg_json="$TOOLS_DIR/${PACKAGE_DIRS[$i]}/package.json"
  ver=$(node -e "console.log(require('$pkg_json').version)" 2>/dev/null)
  echo "    $EXPECTED_SCOPE/$pkg @ $ver"
done
echo ""

if [ "$DRY_RUN" = true ]; then
  log_info "DRY-RUN — would run 'npm run build' (if needed) then 'npm publish --access public' in each."
  log_info "Re-run without --dry-run to actually publish."
  exit 0
fi

# ---------- confirm ----------

read -r -p "$(echo -e "${YELLOW}Proceed to publish? (type 'yes' to confirm): ${NC}")" CONFIRM
if [ "$CONFIRM" != "yes" ]; then
  log_warn "Aborted by user."
  exit 1
fi

# ---------- publish loop ----------

PUBLISHED=0
FAILED=0
RESULTS=()

for i in "${!PACKAGES[@]}"; do
  pkg="${PACKAGES[$i]}"
  dir_name="${PACKAGE_DIRS[$i]}"
  pkg_dir="$TOOLS_DIR/$dir_name"
  pkg_json="$pkg_dir/package.json"
  ver=$(node -e "console.log(require('$pkg_json').version)")
  full="$EXPECTED_SCOPE/$pkg@$ver"

  echo ""
  log_info "=== Publishing $full ==="

  # Build if dist/ is missing or src/ newer than dist
  if [ ! -d "$pkg_dir/dist" ] || [ -n "$(find "$pkg_dir/src" -newer "$pkg_dir/dist" -type f 2>/dev/null | head -1)" ]; then
    log_info "Building $pkg..."
    if ! (cd "$pkg_dir" && npm run build); then
      log_error "$pkg: build failed"
      FAILED=$((FAILED + 1))
      RESULTS+=("FAIL  $full  (build)")
      continue
    fi
  fi

  # Check if this version is already published (no-op)
  PUBLISHED_VERSIONS=$(npm view "$EXPECTED_SCOPE/$pkg" versions --json 2>/dev/null || echo "[]")
  if echo "$PUBLISHED_VERSIONS" | grep -q "\"$ver\""; then
    log_warn "$full is already published. Skipping (use 'npm version patch' to bump)."
    RESULTS+=("SKIP  $full  (already published)")
    continue
  fi

  # Get a fresh 2FA OTP for this publish
  OTP=$(get_otp)
  if [ "$OTP" = "__SKIP__" ] || [ -z "$OTP" ]; then
    log_warn "Skipped (no OTP provided)"
    RESULTS+=("SKIP  $full  (no OTP)")
    continue
  fi

  # Build publish command with --otp flag
  PUBLISH_CMD=(npm publish --access public --otp="$OTP")

  # Publish
  if (cd "$pkg_dir" && "${PUBLISH_CMD[@]}" 2>&1 | tail -20); then
    log_ok "$full published"
    PUBLISHED=$((PUBLISHED + 1))
    RESULTS+=("OK    $full")
  else
    log_error "$full FAILED"
    FAILED=$((FAILED + 1))
    RESULTS+=("FAIL  $full")
  fi
done

# ---------- final report ----------

echo ""
echo "========================================"
echo "  Publish summary"
echo "========================================"
for r in "${RESULTS[@]}"; do echo "  $r"; done
echo ""
echo "  Published: $PUBLISHED"
echo "  Failed:    $FAILED"
echo ""

if [ $FAILED -gt 0 ]; then
  log_error "Some packages failed. Re-run with the specific package name to retry."
  exit 1
fi

log_ok "All packages published to $EXPECTED_SCOPE."
echo ""
echo "Next steps:"
echo "  1. Verify at https://www.npmjs.com/settings/$NPM_USER/packages"
echo "  2. (Recommended) Run:  bash scripts/deprecate-old-scope.sh"
echo "  3. Test the new scope:  npx $EXPECTED_SCOPE/loop-audit . --version"
