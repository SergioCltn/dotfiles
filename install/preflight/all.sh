source "$DOTFILES_INSTALL/preflight/guard.sh"
start_sudo_keepalive
source "$DOTFILES_INSTALL/preflight/begin.sh"
run_logged "$DOTFILES_INSTALL/preflight/show-env.sh"
run_logged "$DOTFILES_INSTALL/preflight/pacman.sh"
run_logged "$DOTFILES_INSTALL/preflight/disable-mkinitcpio.sh"
