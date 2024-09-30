#!/bin/bash

chosen=$(echo -e "Shutdown\nReboot\nLogout\nSuspend" | rofi -dmenu -i -p "Choose an action")

case "$chosen" in
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Logout) i3-msg exit ;;
    Suspend) systemctl suspend ;;
    *) ;;
esac
