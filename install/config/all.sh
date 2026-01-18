run_logged $OMARCHY_INSTALL/config/config.sh
# run_logged $OMARCHY_INSTALL/config/theme.sh
run_logged $OMARCHY_INSTALL/config/git.sh
# run_logged $OMARCHY_INSTALL/config/gpg.sh
# run_logged $OMARCHY_INSTALL/config/timezones.sh

run_logged $OMARCHY_INSTALL/config/increase-sudo-tries.sh # this is for hyprlock
run_logged $OMARCHY_INSTALL/config/increase-lockout-limit.sh
run_logged $OMARCHY_INSTALL/config/ssh-flakiness.sh #problem with ssh connections being unrelibable and fail intermittently

#TODO mise is for node replace for nvm
run_logged $OMARCHY_INSTALL/config/mise-work.sh
run_logged $OMARCHY_INSTALL/config/fix-powerprofilesctl-shebang.sh
run_logged $OMARCHY_INSTALL/config/docker.sh
run_logged $OMARCHY_INSTALL/config/mimetypes.sh
run_logged $OMARCHY_INSTALL/config/localdb.sh # probably needed
# run_logged $OMARCHY_INSTALL/config/walker-elephant.sh # i'm using hyprpaper
run_logged $OMARCHY_INSTALL/config/fast-shutdown.sh
# run_logged $OMARCHY_INSTALL/config/input-group.sh

run_logged $OMARCHY_INSTALL/config/hardware/network.sh
run_logged $OMARCHY_INSTALL/config/hardware/set-wireless-regdom.sh
run_logged $OMARCHY_INSTALL/config/hardware/bluetooth.sh
run_logged $OMARCHY_INSTALL/config/hardware/printer.sh
run_logged $OMARCHY_INSTALL/config/hardware/usb-autosuspend.sh
run_logged $OMARCHY_INSTALL/config/hardware/ignore-power-button.sh
