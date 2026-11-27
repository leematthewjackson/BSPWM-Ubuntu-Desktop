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
for name in bspwm-bluetooth bspwm-network bspwm-locker bspwm-power; do
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
for source in "$PROJECT"/bin/*; do
 deploy "$source" "$HOME/.local/bin/$(basename "$source")" 755 "bin/$(basename "$source")"
done
rmdir "$backup" 2>/dev/null || true
