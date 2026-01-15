#!/usr/bin/env bash
# =============================================================================
# Dotfiles Uninstallation Script
# Removes stowed dotfiles
# =============================================================================

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

main() {
    info "Unstowing dotfiles..."
    
    local dotfiles_dir
    dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    cd "$dotfiles_dir" || exit 1
    
    local packages=(git tmux zsh ripgrep scripts)
    
    # Add nvim if the directory exists
    if [[ -d "nvim" ]]; then
        packages+=(nvim)
    fi
    
    for package in "${packages[@]}"; do
        if [[ -d "$package" ]]; then
            info "Unstowing $package..."
            stow -D -v "$package" 2>&1 | grep -v "BUG in find_stowed_path" || true
        fi
    done
    
    success "All dotfiles unstowed"
}

main
