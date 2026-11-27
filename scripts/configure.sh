#!/usr/bin/env bash
set -euo pipefail
backup=$(mktemp -d "$HOME/.local/state/bspwm-desktop/backup-XXXXXXXX")
deploy() {
 local source=$1 dest=$2 mode=$3 rel=$4
 if [[ ! -L "$dest" && -f "$dest" ]] && cmp -s "$source" "$dest"; then chmod "$mode" "$dest"; return; fi
 if [[ -e "$dest" || -L "$dest" ]]; then
  mkdir -p "$backup/$(dirname "$rel")"
  cp -a -- "$dest" "$backup/$rel"
  [[ ! -L "$dest" ]] || rm -- "$dest"
 fi
 install -D -m "$mode" "$source" "$dest"
}
# Retire old project autostart names, including on reruns.
for name in bspwm-bluetooth bspwm-network bspwm-locker bspwm-power bspwm-picom bspwm-browser-default; do
 dest="$HOME/.config/autostart/$name.desktop"
 if [[ -e "$dest" || -L "$dest" ]]; then
  mkdir -p "$backup/autostart"; mv -- "$dest" "$backup/autostart/"
 fi
done
while IFS= read -r -d '' source; do
 rel="${source#"$PROJECT/config/"}"
 mode=644
 case "$rel" in bspwm/bspwmrc|polybar/launch.sh) mode=755;; esac
 deploy "$source" "$HOME/.config/$rel" "$mode" "$rel"
done < <(find "$PROJECT/config" -type f -print0)
deploy "$PROJECT/KEYBINDINGS.md" "$HOME/.config/bspwm/KEYBINDINGS.md" 644 bspwm/KEYBINDINGS.md
# Retire obsolete project helpers and GTK4 settings, preserving backups.
for name in desktop-resize desktop-polkit desktop-browser-default; do
 if [[ -e "$HOME/.local/bin/$name" || -L "$HOME/.local/bin/$name" ]]; then
  mkdir -p "$backup/bin"
  mv -- "$HOME/.local/bin/$name" "$backup/bin/"
 fi
done
# Only retire the previous project-provided GTK4 settings, not user edits.
if [[ -f "$HOME/.config/gtk-4.0/settings.ini" ]] &&
 [[ $(cat "$HOME/.config/gtk-4.0/settings.ini") == for source in "$PROJECT"/bin/*; do
 deploy "$source" "$HOME/.local/bin/$(basename "$source")" 755 "bin/$(basename "$source")"
done
rmdir "$backup" 2>/dev/null || true
[Settings]\ngtk-application-prefer-dark-theme=1\ngtk-icon-theme-name=Adwaita' ]]; then
 mkdir -p "$backup/gtk-4.0"
 mv -- "$HOME/.config/gtk-4.0/settings.ini" "$backup/gtk-4.0/"
fi
for source in "$PROJECT"/bin/*; do
 deploy "$source" "$HOME/.local/bin/$(basename "$source")" 755 "bin/$(basename "$source")"
done
rmdir "$backup" 2>/dev/null || true
