#!/bin/bash

DOTFILES_REPO=~/dotfiles/git # Change this to the actual path of your dotfiles repo
ROOT_FOLDER=~            # Home directory where links will be created
FILES_TO_LINK=(".gitconfig" ".githelpers")

# Function to install git
install_git() {
    echo "Checking if git is installed..."
    if ! command -v git &>/dev/null; then
        echo "Git is not installed. Installing..."
        
        # Detect the package manager and install git
        if [ -x "$(command -v apt)" ]; then
            sudo apt update && sudo apt install -y git
        elif [ -x "$(command -v yum)" ]; then
            sudo yum install -y git
        elif [ -x "$(command -v pacman)" ]; then
            sudo pacman -Syu --noconfirm git
        elif [ -x "$(command -v brew)" ]; then
            brew install git
        else
            echo "Package manager not detected. Please install git manually."
            exit 1
        fi
    else
        echo "Git is already installed."
    fi
}

# Function to create symbolic links
create_symlink() {
    local src=$1
    local dest=$2
    
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "Skipping $dest: File or symlink already exists."
    else
        ln -s "$src" "$dest"
        echo "Linked $src -> $dest"
    fi
}

# Main execution
install_git

# Iterate over the files to link
for file in "${FILES_TO_LINK[@]}"; do
    SRC_PATH="$DOTFILES_REPO/$file"
    DEST_PATH="$ROOT_FOLDER/$file"
    
    if [ -e "$SRC_PATH" ]; then
        create_symlink "$SRC_PATH" "$DEST_PATH"
    else
        echo "Source file $SRC_PATH does not exist. Skipping."
    fi
done
