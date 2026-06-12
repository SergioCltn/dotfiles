#!/bin/bash

set -eEo pipefail

export DOTFILES_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_INSTALL="$DOTFILES_PATH/install"
export DOTFILES_INSTALL_LOG_FILE="$DOTFILES_PATH/install.log"

source "$DOTFILES_INSTALL/helpers/all.sh"
source "$DOTFILES_INSTALL/preflight/all.sh"
source "$DOTFILES_INSTALL/packaging/all.sh"
source "$DOTFILES_INSTALL/config/all.sh"
source "$DOTFILES_INSTALL/login/all.sh"
source "$DOTFILES_INSTALL/post-install/all.sh"
