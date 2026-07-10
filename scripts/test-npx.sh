#!/bin/bash
# Test all npx commands locally before publishing
# Usage: ./scripts/test-npx.sh

set -e

echo "🧪 Testing all npx commands locally"
echo ""

cd /Users/kevin/Desktop/Nothing/agent-loops

# Build all tools first
echo "🔨 Building all tools..."
npm run build:tools
echo ""

# Test loop-audit
echo "📦 Testing loop-audit..."
node tools/loop-audit/dist/cli.js . --help
node tools/loop-audit/dist/cli.js . --json | head -20
echo ""

# Test loop-init
echo "📦 Testing loop-init..."
node tools/loop-init/dist/cli.js --help
echo ""

# Test loop-cost
echo "📦 Testing loop-cost..."
node tools/loop-cost/dist/cli.js --help
node tools/loop-cost/dist/cli.js --list
echo ""

# Test loop-sync
echo "📦 Testing loop-sync..."
node tools/loop-sync/dist/cli.js --help
echo ""

# Test loop-context
echo "📦 Testing loop-context..."
node tools/loop-context/dist/cli.js --help
echo ""

# Test loop-worktree
echo "📦 Testing loop-worktree..."
node tools/loop-worktree/dist/cli.js --help
echo ""

# Test mcp-server
echo "📦 Testing loop-mcp-server..."
node tools/mcp-server/dist/index.js --help 2>&1 | head -10 || echo "(MCP server runs until stopped)"
echo ""

echo "✅ All CLI tools working!"
echo ""
echo "Next steps:"
echo "1. npm login"
echo "2. npm run publish:all"
echo "3. Test with: npx @kevinzhangnothing/loop-audit --version"
