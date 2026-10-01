# dotfiles

Hyprland (Lua config), Waybar, Mako and Wofi configs.

```
hypr/    -> ~/.config/hypr
waybar/  -> ~/.config/waybar
mako/    -> ~/.config/mako
wofi/    -> ~/.config/wofi
```

## Install

```sh
git clone https://github.com/hadisulfe/.config.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` symlinks each tracked file into `~/.config`, backing up anything it replaces to `~/.config-backup/<timestamp>/`, then reloads Hyprland, Waybar and Mako if you're inside a Hyprland session.
Because the files are symlinks, `git checkout <branch>` in `~/dotfiles` switches your live config; run `./install.sh` again afterwards to link any files new to that branch and reload.
