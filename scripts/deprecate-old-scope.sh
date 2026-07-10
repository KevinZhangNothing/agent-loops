#!/bin/bash
#
# deprecate-old-scope.sh — mark @cobusgreyling/* packages as deprecated
#
# This script does NOT unpublish the old packages (npm doesn't allow that for
# packages older than 72 hours). Instead it marks them deprecated with a
# message pointing users to the new @kevinzhangnothing/* scope.
#
# Deprecation is reversible (the packages still install and work), but users
# see a yellow npm warning on install. The user's choice whether to keep
# using the old scope or migrate.
#
# Pre-requisites:
#   1. You must be logged in to npm as a maintainer of @cobusgreyling/* OR
#      have access tokens for it. If you don't own those packages, you
#      cannot deprecate them — skip this script.
#
#   2. (Optional) Coordinate with the original publisher first if you are
#      not them.
#
# Usage:
#   bash scripts/deprecate-old-scope.sh              # deprecate all 8 packages
#   bash scripts/deprecate-old-scope.sh --dry-run    # show what would be deprecated
#   bash scripts/deprecate-old-scope.sh loop-audit   # deprecate just one
#
# After deprecation, users running:
#
#   npx @cobusgreyling/loop-audit .
#
# will see:
#
#   npm warn deprecated @cobusgreyling/loop-audit@1.6.0:
#   This package has been republished as @kevinzhangnothing/loop-audit.
#   See https://github.com/KevinZhangNothing/agent-loops
#

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

OLD_SCOPE="@cobusgreyling"
NEW_SCOPE="@kevinzhangnothing"
REPO_URL="https://github.com/KevinZhangNothing/agent-loops"

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

DEPRECATION_MSG="This package has been republished as ${NEW_SCOPE}/${0}. See ${REPO_URL}."

log_info()  { echo -e "${BLUE}[INFO]${NC}  $1"; }
log_ok()    { echo -e "${GREEN}[OK]${NC}    $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

DRY_RUN=false
ONLY_PKG=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --help|-h) echo "Usage: $0 [--dry-run] [pkg-name]"; exit 0 ;;
    -*) log_error "Unknown flag: $1"; exit 1 ;;
    *)
      if [ -z "$ONLY_PKG" ]; then ONLY_PKG="$1"; else log_error "Too many args"; exit 1; fi
      shift ;;
  esac
done

# Check login
NPM_USER="$(npm whoami 2>/dev/null || true)"
if [ -z "$NPM_USER" ]; then
  log_error "You are not logged in to npm. Run:  npm adduser"
  exit 1
fi
log_ok "Logged in as: $NPM_USER"

# For each package, try to check if the user can modify it
log_info "Checking which packages you can deprecate..."
CAN_DEPRECATE=()
CANNOT=()

for pkg in "${PACKAGES[@]}"; do
  full="$OLD_SCOPE/$pkg"
  # Check if the package exists
  if ! npm view "$full" name >/dev/null 2>&1; then
    log_warn "$full: not found on npm — skipping"
    continue
  fi
  # Check current deprecated status
  CURRENT_DEP=$(npm view "$full" deprecated 2>/dev/null || echo "")
  if [ -n "$CURRENT_DEP" ] && [ "$CURRENT_DEP" != "undefined" ]; then
    log_warn "$full: already deprecated — skipping"
    continue
  fi
  CAN_DEPRECATE+=("$pkg")
done

if [ ${#CAN_DEPRECATE[@]} -eq 0 ]; then
  log_info "No packages to deprecate. Done."
  exit 0
fi

if [ -n "$ONLY_PKG" ]; then
  FILTERED=()
  for p in "${CAN_DEPRECATE[@]}"; do
    [ "$p" = "$ONLY_PKG" ] && FILTERED+=("$p")
  done
  CAN_DEPRECATE=("${FILTERED[@]}")
  if [ ${#CAN_DEPRECATE[@]} -eq 0 ]; then
    log_error "$ONLY_PKG: not deprecatable (not found, already deprecated, or invalid name)"
    exit 1
  fi
fi

echo ""
log_info "Will deprecate these packages:"
for pkg in "${CAN_DEPRECATE[@]}"; do
  echo "    $OLD_SCOPE/$pkg"
done
echo ""

# Confirm
read -r -p "$(echo -e "${YELLOW}Proceed to deprecate? (type 'yes' to confirm): ${NC}")" CONFIRM
if [ "$CONFIRM" != "yes" ]; then
  log_warn "Aborted by user."
  exit 1
fi

DEPRECATED=0
FAILED=0

for pkg in "${CAN_DEPRECATE[@]}"; do
  full="$OLD_SCOPE/$pkg"
  msg="$DEPRECATION_MSG"

  if [ "$DRY_RUN" = true ]; then
    log_info "DRY-RUN: would run 'npm deprecate $full \"$msg\"'"
    continue
  fi

  if npm deprecate "$full" "$msg" 2>&1; then
    log_ok "$full deprecated"
    DEPRECATED=$((DEPRECATED + 1))
  else
    log_error "$full FAILED (you may not be a maintainer)"
    FAILED=$((FAILED + 1))
  fi
done

echo ""
echo "========================================"
echo "  Deprecation summary"
echo "========================================"
echo "  Deprecated: $DEPRECATED"
echo "  Failed:     $FAILED"
echo ""

if [ $FAILED -gt 0 ]; then
  log_warn "Some packages could not be deprecated. This is normal if you are not"
  log_warn "a maintainer of @${OLD_SCOPE#@}. The original publisher must deprecate them."
fi

log_ok "Done."
