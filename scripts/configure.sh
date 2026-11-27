#!/usr/bin/env bash
set -euo pipefail
# Fresh install: copy the desktop configuration and tools, no OS preferences.
mkdir -p "$HOME/.config" "$HOME/.local/bin"
backup=$(mktemp -d "$HOME/.config/bspwm-desktop-backup.XXXXXXXX")
while IFS= read -r -d '' source; do
 rel="${source#"$PROJECT/config/"}"
 dest="$HOME/.config/$rel"
 if [[ -e "$dest" || -L "$dest" ]]; then
  if cmp -s "$source" "$dest"; then continue; fi
  mkdir -p "$backup/$(dirname "$rel")"
  cp -a -- "$dest" "$backup/$rel"
 fi
 install -D -m 644 "$source" "$dest"
done < <(find "$PROJECT/config" -type f -print0)
chmod +x "$HOME/.config/bspwm/bspwmrc" "$HOME/.config/polybar/launch.sh"
install -m 644 "$PROJECT/KEYBINDINGS.md" "$HOME/.config/bspwm/KEYBINDINGS.md"
install -m 755 "$PROJECT"/bin/* "$HOME/.local/bin/"
rmdir "$backup" 2>/dev/null || echo "Previous desktop configs: $backup"
