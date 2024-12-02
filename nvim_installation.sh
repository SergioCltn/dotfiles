#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
DOTFILES_REPO="https://github.com/sergiocltn/dotfiles.git"
CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim_backup"
CLONE_DIR="$HOME/dotfiles"

echo "Setting up Neovim with your dotfiles..."

# Step 0: Ensure the .config directory if it doesn't exists
mkdir -p "$HOME/.config"

# Step 1: Check and install Neovim if not present
if ! command -v nvim &> /dev/null; then
    echo "Neovim not found. Installing..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux installation
        if [[ -f /etc/os-release ]]; then
            . /etc/os-release
            case "$ID" in
                ubuntu|debian)
                    sudo apt update && sudo apt install -y neovim
                    ;;
                fedora|centos|rhel)
                    sudo dnf install -y neovim
                    ;;
                arch|manjaro)
                    sudo pacman -S --noconfirm neovim
                    ;;
                *)
                    echo "Unsupported Linux distribution. Please install Neovim manually."
                    exit 1
                    ;;
            esac
        else
            echo "Unable to detect your operating system. Please install Neovim manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS installation
        if ! command -v brew &> /dev/null; then
            echo "Homebrew not found. Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        echo "Installing Neovim with Homebrew..."
        brew install neovim
    else
        echo "Unsupported operating system. Please install Neovim manually."
        exit 1
    fi
else
    echo "Neovim is already installed."
fi

# Step 2: Clone the dotfiles repository
if [[ ! -d "$CLONE_DIR" ]]; then
    echo "Cloning dotfiles repository..."
    git clone "$DOTFILES_REPO" "$CLONE_DIR"
else
    echo "Dotfiles repository already exists. Pulling latest changes..."
    git -C "$CLONE_DIR" pull
fi

# Step 3: Backup existing Neovim config if it exists
if [[ -d "$CONFIG_DIR" ]]; then
    echo "Backing up existing Neovim configuration to $BACKUP_DIR..."
    mv "$CONFIG_DIR" "$BACKUP_DIR"
fi

# Step 4: Create symbolic link to Neovim configuration
echo "Linking Neovim configuration..."
ln -s "$CLONE_DIR/nvim" "$CONFIG_DIR"

# Step 5: Verify setup
if [[ -f "$CONFIG_DIR/init.vim" || -f "$CONFIG_DIR/init.lua" ]]; then
    echo "Neovim setup is complete! Launch Neovim with 'nvim' to verify."
else
    echo "Failed to set up Neovim configuration. Please check your dotfiles repository."
    exit 1
fi
