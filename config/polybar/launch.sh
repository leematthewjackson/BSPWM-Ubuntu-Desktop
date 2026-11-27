#!/usr/bin/env bash
polybar-msg cmd quit >/dev/null 2>&1 || true
# Allow existing bars to release the tray before restarting.
for ((i=0;i<25;i++)); do
 pgrep -u "$UID" -x polybar >/dev/null || break
 sleep 0.2
done
if pgrep -u "$UID" -x polybar >/dev/null; then
 pkill -TERM -u "$UID" -x polybar || true
 for ((i=0;i<25;i++)); do
  pgrep -u "$UID" -x polybar >/dev/null || break
  sleep 0.2
 done
fi
if pgrep -u "$UID" -x polybar >/dev/null; then
 echo "Previous Polybar processes did not exit; skipping duplicate bars." >&2
 exit 1
fi
mapfile -t monitors < <(polybar --list-monitors | cut -d: -f1)
(( ${#monitors[@]} )) || exit 0
primary=$(xrandr --query | awk '$2=="connected" && $3=="primary"{print $1;exit}')
[[ -n "$primary" ]] || primary=$(bspc query -M --names | head -n1)
[[ -n "$primary" ]] || primary="${monitors[0]}"
for monitor in "${monitors[@]}"; do
 bar=main
 [[ "$monitor" != "$primary" ]] || bar=primary
 MONITOR="$monitor" polybar "$bar" &
done
