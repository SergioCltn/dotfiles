#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define Omarchy locations
export DOTFILES_PATH="$HOME/dotfiles"
export DOTFILES_INSTALL="$DOTFILES_PATH/install"
export DOTFILES_INSTALL_LOG_FILE="$HOME/dotfiles/install.log"

# TODO: be careful with the path
export PATH="$DOTFILES_PATH/bin:$PATH"

# Install
source "$DOTFILES_INSTALL/helpers/all.sh"
source "$DOTFILES_INSTALL/preflight/all.sh"
source "$DOTFILES_INSTALL/packaging/all.sh"
source "$DOTFILES_INSTALL/config/all.sh"
source "$DOTFILES_INSTALL/login/all.sh"
source "$DOTFILES_INSTALL/post-install/all.sh"
