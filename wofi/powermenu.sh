#!/usr/bin/env bash
choice=$(printf '%s\n' \
    "󰌾  Lock" \
    "󰤄  Suspend" \
    "󰜉  Reboot" \
    "󰐥  Shutdown" \
    "󰍃  Logout" |
    wofi --dmenu --prompt Power --width 280 --height 300 --cache-file /dev/null)

case "$choice" in
    *Lock)     hyprlock ;;
    *Suspend)  systemctl suspend ;;
    *Reboot)   systemctl reboot ;;
    *Shutdown) systemctl poweroff ;;
    *Logout)
        if command -v hyprshutdown >/dev/null 2>&1; then
            hyprshutdown
        else
            hyprctl dispatch 'hl.dsp.exit()'
        fi
        ;;
esac
