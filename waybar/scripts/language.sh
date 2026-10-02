#!/usr/bin/env bash
# Replacement for Waybar's hyprland/language module.
# Waybar (<= 0.14) mis-parses the activelayout event when the keyboard name
# contains "(", e.g. ite-tech.-inc.-ite-device(8258)-keyboard, so the layout
# label never updates. This prints the short layout name whenever it changes.

short() {
    case "$1" in
        English*) echo "EN" ;;
        Arabic*)  echo "AR" ;;
        *)        echo "$1" ;;
    esac
}

current() {
    hyprctl devices -j | jq -r '.keyboards[] | select(.main) | .active_keymap'
}

short "$(current)"

sock="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
if command -v socat >/dev/null 2>&1; then
    socat -u "UNIX-CONNECT:$sock" - | while IFS= read -r line; do
        case "$line" in
            "activelayout>>"*)
                payload="${line#activelayout>>}"
                short "${payload#*,}"
                ;;
        esac
    done
else
    while sleep 1; do
        short "$(current)"
    done
fi
