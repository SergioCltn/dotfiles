run_logged $DOTFILES_INSTALL/config/config.sh
run_logged $DOTFILES_INSTALL/config/increase-sudo-tries.sh # this is for hyprlock
run_logged $DOTFILES_INSTALL/config/increase-lockout-limit.sh
run_logged $DOTFILES_INSTALL/config/ssh-flakiness.sh #problem with ssh connections being unrelibable and fail intermittently

run_logged $DOTFILES_INSTALL/config/mpacmanise-work.sh
run_logged $DOTFILES_INSTALL/config/fix-powerprofilesctl-shebang.sh
run_logged $DOTFILES_INSTALL/config/docker.sh
run_logged $DOTFILES_INSTALL/config/mimetypes.sh
run_logged $DOTFILES_INSTALL/config/localdb.sh # probably needed
run_logged $DOTFILES_INSTALL/config/fast-shutdown.sh

run_logged $DOTFILES_INSTALL/config/hardware/network.sh
run_logged $DOTFILES_INSTALL/config/hardware/bluetooth.sh
run_logged $DOTFILES_INSTALL/config/hardware/printer.sh
run_logged $DOTFILES_INSTALL/config/hardware/usb-autosuspend.sh
run_logged $DOTFILES_INSTALL/config/hardware/ignore-power-button.sh
