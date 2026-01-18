#!/bin/bash

# Set install mode to online since boot.sh is used for curl installations
export DOTFILES_ONLINE_INSTALL=true

ansi_art='                                               
  ______________________________  ________.___________   
 /   _____/\_   _____/\______   \/  _____/|   \_____  \  
 \_____  \  |    __)_  |       _/   \  ___|   |/   |   \ 
 /        \ |        \ |    |   \    \_\  \   /    |    \
/_______  //_______  / |____|_  /\______  /___\_______  /
        \/         \/         \/        \/            \/ '

clear
echo -e "\n$ansi_art\n"

sudo pacman -Syu --noconfirm --needed git

# Use custom repo if specified, otherwise default to basecamp/omarchy
DOTFILES_REPO="${DOTFILES_REPO:-sergiocltn/dotfiles}"

echo -e "\nCloning from: https://github.com/${DOTFILES_REPO}.git"
rm -rf ~/.local/share/omarchy/
git clone "https://github.com/${DOTFILES_REPO}.git" ~/dotfiles >/dev/null

# Use custom branch if instructed, otherwise default to master
DOTFILES_REF="${DOTFILES_REF:-main}"
if [[ $DOTFILES_REF != "master" ]]; then
  echo -e "\e[32mUsing branch: $DOTFILES_REF\e[0m"
  cd ~/.local/share/omarchy
  git fetch origin "${DOTFILES_REF}" && git checkout "${DOTFILES_REF}"
  cd -
fi

echo -e "\nInstallation starting..."
source ~/dotfiles/install.sh
