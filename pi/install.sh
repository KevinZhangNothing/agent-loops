#!/bin/bash
#
# pi Integration Installer for agent-loops
# 
# Usage:
#   ./install.sh                    # Install to default pi location
#   ./install.sh --dry-run          # Preview what will be installed
#   ./install.sh --target ~/custom  # Install to custom location
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default pi agent directory
DEFAULT_PI_AGENT_DIR="$HOME/.pi/agent"
PI_AGENT_DIR="$DEFAULT_PI_AGENT_DIR"

# Script directory (where this script lives)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_LOOPS_ROOT="$(dirname "$SCRIPT_DIR")"

# Parse arguments
DRY_RUN=false
CUSTOM_TARGET=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --target)
            CUSTOM_TARGET="$2"
            # 展开 ~ 为 $HOME（双引号内不会自动展开 ~）
            PI_AGENT_DIR="${CUSTOM_TARGET/#\~/$HOME}"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --dry-run         Preview what will be installed"
            echo "  --target <path>   Install to custom location"
            echo "  --help            Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if npx is available
    if ! command -v npx &> /dev/null; then
        log_error "npx is not installed. Please install Node.js first."
        exit 1
    fi
    log_success "npx found: $(which npx)"
    
    # Check if target directory exists (for dry-run, just warn)
    if [ ! -d "$PI_AGENT_DIR" ]; then
        if [ "$DRY_RUN" = true ]; then
            log_warning "Target directory does not exist: $PI_AGENT_DIR"
        else
            log_info "Creating target directory: $PI_AGENT_DIR"
            mkdir -p "$PI_AGENT_DIR"
        fi
    fi
}

install_mcp_config() {
    log_info "Installing MCP configuration..."
    
    local src="$SCRIPT_DIR/mcp.json"
    local dst="$PI_AGENT_DIR/mcp.json"
    
    if [ "$DRY_RUN" = true ]; then
        echo "  Would copy: $src -> $dst"
        return
    fi
    
    # Backup existing config if it exists
    if [ -f "$dst" ]; then
        local backup="$dst.backup.$(date +%Y%m%d%H%M%S)"
        log_warning "Backing up existing mcp.json to $backup"
        cp "$dst" "$backup"
    fi
    
    cp "$src" "$dst"
    log_success "MCP configuration installed to $dst"
}

install_skills() {
    log_info "Installing skills..."
    
    local src_dir="$SCRIPT_DIR/skills"
    local dst_dir="$PI_AGENT_DIR/skills"
    
    if [ "$DRY_RUN" = true ]; then
        echo "  Would copy skills from: $src_dir"
        echo "  Would install to: $dst_dir"
        for skill in "$src_dir"/*/; do
            if [ -d "$skill" ]; then
                echo "    - $(basename "$skill")"
            fi
        done
        return
    fi
    
    # Create skills directory if it doesn't exist
    mkdir -p "$dst_dir"
    
    # Copy each skill — backup existing skill before overwrite
    for skill in "$src_dir"/*/; do
        if [ -d "$skill" ]; then
            local skill_name=$(basename "$skill")
            # Backup existing skill if it exists (avoid silent overwrite)
            if [ -d "$dst_dir/$skill_name" ]; then
                local backup="$dst_dir/$skill_name.backup.$(date +%Y%m%d%H%M%S)"
                log_warning "Backing up existing skill $skill_name to $backup"
                mv "$dst_dir/$skill_name" "$backup"
            fi
            cp -r "$skill" "$dst_dir/"
            log_success "Installed skill: $skill_name"
        fi
    done
}

install_workflows() {
    log_info "Installing workflows..."
    
    local src_dir="$SCRIPT_DIR/workflows"
    local dst_dir="$PI_AGENT_DIR/workflows"
    
    if [ "$DRY_RUN" = true ]; then
        echo "  Would copy workflows from: $src_dir"
        echo "  Would install to: $dst_dir"
        for workflow in "$src_dir"/*.yaml; do
            if [ -f "$workflow" ]; then
                echo "    - $(basename "$workflow")"
            fi
        done
        return
    fi
    
    # Create workflows directory if it doesn't exist
    mkdir -p "$dst_dir"
    
    # Copy each workflow — backup existing workflow before overwrite
    for workflow in "$src_dir"/*.yaml; do
        if [ -f "$workflow" ]; then
            local wf_name=$(basename "$workflow")
            # Backup existing workflow if it exists (avoid silent overwrite)
            if [ -f "$dst_dir/$wf_name" ]; then
                local backup="$dst_dir/$wf_name.backup.$(date +%Y%m%d%H%M%S)"
                log_warning "Backing up existing workflow $wf_name to $backup"
                mv "$dst_dir/$wf_name" "$backup"
            fi
            cp "$workflow" "$dst_dir/"
        fi
    done
    
    local count=$(ls -1 "$dst_dir"/*.yaml 2>/dev/null | wc -l)
    log_success "Installed $count workflows to $dst_dir"
}

verify_installation() {
    log_info "Verifying installation..."
    
    local errors=0
    
    # Check MCP config
    if [ -f "$PI_AGENT_DIR/mcp.json" ]; then
        log_success "MCP configuration found"
    else
        log_error "MCP configuration not found"
        ((errors++))
    fi
    
    # Check skills
    local skill_count=0
    for skill in "$PI_AGENT_DIR/skills"/*/; do
        if [ -d "$skill" ]; then
            ((skill_count++))
        fi
    done
    
    if [ $skill_count -gt 0 ]; then
        log_success "Found $skill_count skills"
    else
        log_error "No skills found"
        ((errors++))
    fi
    
    # Check workflows
    local workflow_count=0
    for workflow in "$PI_AGENT_DIR/workflows"/*.yaml; do
        if [ -f "$workflow" ]; then
            ((workflow_count++))
        fi
    done
    
    if [ $workflow_count -gt 0 ]; then
        log_success "Found $workflow_count workflows"
    else
        log_warning "No workflows found (optional)"
    fi
    
    return $errors
}

print_shortcuts() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  Installation Complete!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "Available Shortcuts:"
    echo "  +loop-score         - Audit current project"
    echo "  +loop-score-suggest - Get improvement suggestions"
    echo "  +loop-init          - Initialize Loop scaffolding"
    echo "  +loop-cost          - Estimate token costs"
    echo "  +loop-state         - View STATE.md"
    echo "  +loop-log           - View run log"
    echo ""
    echo "Next Steps:"
    echo "  1. Restart pi to load new configuration"
    echo "  2. Run: +loop-score"
    echo "  3. Read: docs/PI-INTEGRATION.md"
    echo ""
}

print_dry_run_summary() {
    echo ""
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}  Dry Run Summary${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo ""
    echo "Would install to: $PI_AGENT_DIR"
    echo ""
    echo "Files to be installed:"
    echo "  - mcp.json"
    for skill in "$SCRIPT_DIR/skills"/*/; do
        if [ -d "$skill" ]; then
            echo "  - skills/$(basename "$skill")/"
        fi
    done
    for workflow in "$SCRIPT_DIR/workflows"/*.yaml; do
        if [ -f "$workflow" ]; then
            echo "  - workflows/$(basename "$workflow")"
        fi
    done
    echo ""
    echo "Run without --dry-run to install."
}

# Main
main() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  agent-loops pi Installer${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    
    check_prerequisites
    
    if [ "$DRY_RUN" = true ]; then
        install_mcp_config
        install_skills
        install_workflows
        print_dry_run_summary
    else
        install_mcp_config
        install_skills
        install_workflows
        
        if verify_installation; then
            print_shortcuts
        else
            log_error "Installation verification failed"
            exit 1
        fi
    fi
}

main
