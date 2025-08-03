#!/bin/bash

source ./functions.sh

# Package lists
packages=(
    git
    vim
    zsh
    curl
    wget
    python
    nodejs
    npm
    eza
    tldr
    fzf
    bat
    zoxide
    git-delta
    gcc
    make
    ripgrep
    fd
    unzip
    neovim
)

arch_extra_packages=(
    base-devel
    python-pip
)

mac_extra_packages=(
)

# Detect OS and distribution
OS="$(uname -s)"
case "$OS" in
    Linux*)
        if [ -f /etc/arch-release ]; then
            DISTRO="Arch"
        else
            DISTRO="Unknown"
        fi
        ;;
    Darwin*)
        DISTRO="macOS"
        ;;
    *)
        DISTRO="Unknown"
        ;;
esac

print_message "Updating system and installing essential packages..."

if [ "$DISTRO" = "Arch" ]; then
    sudo pacman -Syu --noconfirm
    all_packages=("${packages[@]}" "${arch_extra_packages[@]}")
    sudo pacman -S --noconfirm "${all_packages[@]}"

elif [ "$DISTRO" = "macOS" ]; then
    if ! command -v brew >/dev/null 2>&1; then
        print_message "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [ -d "/opt/homebrew" ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi

    brew update

    for pkg in "${packages[@]}"; do
        brew install "$pkg"
    done

    for pkg in "${mac_extra_packages[@]}"; do
        brew install "$pkg"
    done

else
    print_error "Unsupported OS or distribution: $DISTRO"
    exit 1
fi
#
# # Install Oh My Zsh (optional, comment out if not needed)
# print_message "Installing Oh My Zsh..."
# if [ ! -d "$HOME/.oh-my-zsh" ]; then
#     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# else
#     print_message "Oh My Zsh already installed, skipping..."
# fi
#
# # Set Zsh as default shell (optional, comment out if not needed)
# if [ "$SHELL" != "$(command -v zsh)" ]; then
#     print_message "Setting Zsh as default shell..."
#     chsh -s "$(command -v zsh)"
# else
#     print_message "Zsh is already the default shell, skipping..."
# fi
#
# # Source the new shell configuration
# print_message "Sourcing new shell configuration..."
# if [ -f "$HOME/.zshrc" ]; then
#     source "$HOME/.zshrc"
# elif [ -f "$HOME/.bashrc" ]; then
#     source "$HOME/.bashrc"
# fi
