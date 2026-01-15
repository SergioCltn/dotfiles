#!/usr/bin/env bash
# =============================================================================
# Dotfiles Installation Script
# Automatically sets up dotfiles using GNU Stow and installs dependencies
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Check for Arch Linux
        if [[ -f /etc/arch-release ]]; then
            echo "arch"
        else
            echo "linux"
        fi
    else
        error "Unsupported OS: $OSTYPE"
        exit 1
    fi
}

# Install Homebrew (macOS)
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        success "Homebrew installed"
    else
        info "Homebrew already installed"
    fi
}

# Install dependencies
install_dependencies() {
    local os=$1
    
    info "Installing dependencies..."
    
    if [[ "$os" == "macos" ]]; then
        # Homebrew packages
        local packages=(
            stow
            neovim
            tmux
            fzf
            fd
            ripgrep
            bat
            eza
            zoxide
            git-delta
            node
            tlrc
            powerlevel10k
            zsh-syntax-highlighting
            zsh-autosuggestions
        )
        
        for package in "${packages[@]}"; do
            if brew list "$package" &> /dev/null; then
                info "$package already installed"
            else
                info "Installing $package..."
                brew install "$package"
            fi
        done
        
    elif [[ "$os" == "arch" ]]; then
        # Update package database
        sudo pacman -Sy
        
        # Pacman packages
        local packages=(
            stow
            neovim
            tmux
            fzf
            fd
            ripgrep
            bat
            eza
            zoxide
            git-delta
            nodejs
            npm
            zsh
            git
            curl
            base-devel
        )
        
        for package in "${packages[@]}"; do
            if pacman -Qi "$package" &> /dev/null; then
                info "$package already installed"
            else
                info "Installing $package..."
                sudo pacman -S --noconfirm "$package"
            fi
        done
        
        # Install tlrc from AUR if yay is available
        if command -v yay &> /dev/null; then
            if ! pacman -Qi tlrc &> /dev/null; then
                info "Installing tlrc from AUR..."
                yay -S --noconfirm tlrc
            fi
        elif command -v paru &> /dev/null; then
            if ! pacman -Qi tlrc &> /dev/null; then
                info "Installing tlrc from AUR..."
                paru -S --noconfirm tlrc
            fi
        else
            warn "No AUR helper found. Skipping tlrc. Install yay or paru for AUR support."
        fi
        
    elif [[ "$os" == "linux" ]]; then
        # Update package list
        sudo apt-get update
        
        # APT packages
        local packages=(
            stow
            neovim
            tmux
            fzf
            fd-find
            ripgrep
            bat
            zsh
            git
            curl
            build-essential
        )
        
        for package in "${packages[@]}"; do
            if dpkg -l | grep -q "^ii  $package"; then
                info "$package already installed"
            else
                info "Installing $package..."
                sudo apt-get install -y "$package"
            fi
        done
        
        # Install eza (not in apt repos)
        if ! command -v eza &> /dev/null; then
            info "Installing eza..."
            cargo install eza || warn "Failed to install eza. Install Rust first: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
        fi
        
        # Install zoxide
        if ! command -v zoxide &> /dev/null; then
            info "Installing zoxide..."
            curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        fi
    fi
    
    success "Dependencies installed"
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        success "Oh My Zsh installed"
    else
        info "Oh My Zsh already installed"
    fi
}

# Install TMux Plugin Manager
install_tpm() {
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        info "Installing TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        success "TPM installed"
    else
        info "TPM already installed"
    fi
}

# Install NVM
install_nvm() {
    if [[ ! -d "$HOME/.nvm" ]]; then
        info "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        success "NVM installed"
    else
        info "NVM already installed"
    fi
}

# Install fzf-git
install_fzf_git() {
    if [[ ! -d "$HOME/fzf-git.sh" ]]; then
        info "Installing fzf-git.sh..."
        git clone https://github.com/junegunn/fzf-git.sh.git "$HOME/fzf-git.sh"
        success "fzf-git.sh installed"
    else
        info "fzf-git.sh already installed"
    fi
}

# Install Powerlevel10k
install_p10k() {
    local os=$1
    
    if [[ "$os" == "linux" || "$os" == "arch" ]] && [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
        info "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
        success "Powerlevel10k installed"
    fi
}

# Backup existing dotfiles
backup_existing_files() {
    info "Backing up existing dotfiles..."
    
    local files_to_backup=(
        "$HOME/.zshrc"
        "$HOME/.gitconfig"
        "$HOME/.tmux.conf"
        "$HOME/.ripgreprc"
    )
    
    local backup_dir="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    local backed_up=false
    
    for file in "${files_to_backup[@]}"; do
        if [[ -f "$file" ]] && [[ ! -L "$file" ]]; then
            if [[ "$backed_up" == false ]]; then
                mkdir -p "$backup_dir"
                backed_up=true
            fi
            info "Backing up $file"
            cp "$file" "$backup_dir/"
        fi
    done
    
    if [[ "$backed_up" == true ]]; then
        success "Existing dotfiles backed up to $backup_dir"
    else
        info "No existing dotfiles to backup"
    fi
}

# Stow dotfiles
stow_dotfiles() {
    info "Stowing dotfiles..."
    
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
            info "Stowing $package..."
            stow -v "$package" 2>&1 | grep -v "BUG in find_stowed_path" || true
            success "$package stowed"
        else
            warn "$package directory not found, skipping"
        fi
    done
    
    success "All dotfiles stowed"
}

# Make scripts executable
make_scripts_executable() {
    info "Making scripts executable..."
    if [[ -d "$HOME/.local/bin" ]]; then
        chmod +x "$HOME/.local/bin/"* 2>/dev/null || true
        success "Scripts are executable"
    fi
}

# Main installation
main() {
    echo ""
    echo "=========================================="
    echo "  Dotfiles Installation Script"
    echo "=========================================="
    echo ""
    
    OS=$(detect_os)
    info "Detected OS: $OS"
    
    # Install Homebrew on macOS
    if [[ "$OS" == "macos" ]]; then
        install_homebrew
    fi
    
    # Install dependencies
    install_dependencies "$OS"
    
    # Install additional tools
    install_oh_my_zsh
    install_tpm
    install_nvm
    install_fzf_git
    install_p10k "$OS"
    
    # Backup and stow
    backup_existing_files
    stow_dotfiles
    
    # Make scripts executable
    make_scripts_executable
    
    echo ""
    success "Installation complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal or run: exec zsh"
    echo "  2. Run 'p10k configure' to setup Powerlevel10k"
    echo "  3. In tmux, press 'prefix + I' to install tmux plugins"
    echo "  4. Open Neovim and run ':Lazy sync' to install plugins"
    echo ""
}

main
