source $DOTFILES_INSTALL/preflight/guard.sh
source $DOTFILES_INSTALL/preflight/begin.sh
run_logged $DOTFILES_INSTALL/preflight/show-env.sh
run_logged $DOTFILES_INSTALL/preflight/pacman.sh
run_logged $DOTFILES_INSTALL/preflight/first-run-mode.sh
run_logged $DOTFILES_INSTALL/preflight/disable-mkinitcpio.sh
