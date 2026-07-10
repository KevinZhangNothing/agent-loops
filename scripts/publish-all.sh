#!/bin/bash
# Publish all @kevinzhangnothing/loop-* packages to npm
# Usage: ./scripts/publish-all.sh

set -e

echo "🚀 Publishing all @kevinzhangnothing/loop-* packages to npm"
echo ""

# Check if logged in to npm
if ! npm whoami &>/dev/null; then
    echo "❌ Not logged in to npm. Please run: npm login"
    exit 1
fi

echo "✅ Logged in as: $(npm whoami)"
echo ""

# Build all tools first
echo "🔨 Building all tools..."
npm run build:tools
echo ""

# Publish in dependency order
PACKAGES=(
    "tools/loop-audit"
    "tools/loop-cost"
    "tools/loop-sync"
    "tools/loop-context"
    "tools/loop-worktree"
    "tools/mcp-server"
    "tools/loop-init"  # Depends on loop-audit
)

for pkg in "${PACKAGES[@]}"; do
    echo "📦 Publishing $pkg..."
    cd "$pkg"
    
    # Check package.json exists
    if [ ! -f "package.json" ]; then
        echo "❌ package.json not found in $pkg"
        cd - > /dev/null
        continue
    fi
    
    # Get package name and version
    NAME=$(node -p "require('./package.json').name")
    VERSION=$(node -p "require('./package.json').version")
    
    echo "   Package: $NAME@$VERSION"
    
    # Publish
    if npm publish --access public; then
        echo "   ✅ Published successfully"
    else
        echo "   ⚠️  Publish failed (may already exist)"
    fi
    
    cd - > /dev/null
    echo ""
done

echo "🎉 All packages processed!"
echo ""
echo "Verify at: https://www.npmjs.com/org/kevinzhangnothing"
