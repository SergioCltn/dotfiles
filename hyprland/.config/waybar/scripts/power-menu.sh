#!/bin/bash

options="Shutdown\nRestart\nSuspend\nLogout"

selected=$(echo -e "$options" | wofi --dmenu --prompt "Power" --width 150 --height 200)

case $selected in
    Shutdown)
        systemctl poweroff
        ;;
    Restart)
        systemctl reboot
        ;;
    Suspend)
        systemctl suspend
        ;;
    Logout)
        hyprctl dispatch exit
        ;;
esac
