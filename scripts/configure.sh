#!/usr/bin/env bash
set -euo pipefail
backup="$HOME/.local/state/bspwm-desktop/backup-$(date +%Y%m%d-%H%M%S)"
while IFS= read -r -d '' source; do
 rel="${source#"$PROJECT/config/"}"
 dest="$HOME/.config/$rel"
 if [[ -e "$dest" || -L "$dest" ]]; then
  mkdir -p "$backup/$(dirname "$rel")"
  cp -a -- "$dest" "$backup/$rel"
 fi
 install -D -m 644 "$source" "$dest"
done < <(find "$PROJECT/config" -type f -print0)
chmod +x "$HOME/.config/bspwm/bspwmrc" "$HOME/.config/polybar/launch.sh"
mkdir -p "$HOME/.local/bin"
for source in "$PROJECT"/bin/*; do
 dest="$HOME/.local/bin/$(basename "$source")"
 if [[ -e "$dest" ]]; then mkdir -p "$backup/bin"; cp -a "$dest" "$backup/bin/"; fi
 install -m 755 "$source" "$dest"
done
xdg-mime default thunar.desktop inode/directory
xdg-mime default org.gnome.TextEditor.desktop text/plain

