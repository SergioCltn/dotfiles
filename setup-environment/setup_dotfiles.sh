#!/bin/bash

# setup_dotfiles.sh
# Manages dotfiles cloning and symlinking, including .config directories, with backup for existing non-symlink files

# Source configuration and functions
source ./functions.sh

# Variables
DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_REPO="https://github.com/sergiocltn/dotfiles.git"  # Replace with your repo URL
BACKUP_SUFFIX=".backup-$(date +%Y%m%d_%H%M%S)"

# Clone dotfiles repository if it doesn't exist
if [ ! -d "$DOTFILES_DIR" ]; then
    print_message "Cloning dotfiles repository..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
    print_message "Dotfiles directory already exists, skipping clone..."
fi

# Create symlinks for individual dotfiles
print_message "Creating symlinks for dotfiles..."
for file in .bashrc .zshrc .vimrc .gitconfig; do
    if [ -f "$DOTFILES_DIR/$file" ]; then
        if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
            print_message "Backing up existing $HOME/$file..."
            mv "$HOME/$file" "$HOME/$file$BACKUP_SUFFIX"
        fi
        ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
        print_message "Linked $file to $HOME/$file"
    else
        print_message "Skipping $file, not found in dotfiles repository"
    fi
done

# Handle .config directory
CONFIG_DIR="$DOTFILES_DIR/.config"
HOME_CONFIG_DIR="$HOME/.config"

# Ensure $HOME/.config exists
if [ ! -d "$HOME_CONFIG_DIR" ]; then
    print_message "Creating $HOME_CONFIG_DIR directory..."
    mkdir -p "$HOME_CONFIG_DIR"
fi

# Create symlinks for folders in .config
if [ -d "$CONFIG_DIR" ]; then
    print_message "Creating symlinks for .config directories..."
    for dir in "$CONFIG_DIR"/*; do
        if [ -d "$dir" ]; then
            dir_name=$(basename "$dir")
            if [ -e "$HOME_CONFIG_DIR/$dir_name" ] && [ ! -L "$HOME_CONFIG_DIR/$dir_name" ]; then
                print_message "Backing up existing $HOME_CONFIG_DIR/$dir_name..."
                mv "$HOME_CONFIG_DIR/$dir_name" "$HOME_CONFIG_DIR/$dir_name$BACKUP_SUFFIX"
            fi
            ln -sfn "$dir" "$HOME_CONFIG_DIR/$dir_name"
            print_message "Linked $dir_name to $HOME_CONFIG_DIR/$dir_name"
        else
            print_message "Skipping $dir_name, not a directory"
        fi
    done
else
    print_message ".config directory not found in dotfiles repository, skipping..."
fi
