#!/usr/bin/env bash
# Symlink every tracked file under hypr/ waybar/ mako/ wofi/ into ~/.config.
# Existing files are moved to ~/.config-backup/<timestamp>/ first.
# Files in ~/.config that this repo doesn't track (e.g. hypridle.conf) are left alone.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dest="${XDG_CONFIG_HOME:-$HOME/.config}"
backup="$HOME/.config-backup/$(date +%Y%m%d-%H%M%S)"

if [ "$repo" = "$dest" ]; then
    echo "Clone this repo somewhere other than $dest (e.g. ~/dotfiles)." >&2
    exit 1
fi

cd "$repo"
git ls-files -z -- hypr waybar mako wofi | while IFS= read -r -d '' f; do
    src="$repo/$f"
    target="$dest/$f"
    mkdir -p "$(dirname "$target")"
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
        continue
    fi
    if [ -e "$target" ] || [ -L "$target" ]; then
        mkdir -p "$backup/$(dirname "$f")"
        mv "$target" "$backup/$f"
        echo "backed up  $target -> $backup/$f"
    fi
    ln -s "$src" "$target"
    echo "linked     $target"
done

if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    hyprctl reload >/dev/null || true
    pkill -x waybar || true
    (waybar >/dev/null 2>&1 &)
    pkill -x mako || true
    (mako >/dev/null 2>&1 &)
    echo "reloaded Hyprland, waybar and mako"
fi
