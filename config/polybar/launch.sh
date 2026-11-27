#!/usr/bin/env bash
polybar-msg cmd quit >/dev/null 2>&1 || true
mapfile -t monitors < <(polybar --list-monitors | cut -d: -f1)
(( ${#monitors[@]} )) || exit 0
primary=$(xrandr --query | awk '$2=="connected" && $3=="primary"{print $1;exit}')
[[ -n "$primary" ]] || primary="${monitors[0]}"
for monitor in "${monitors[@]}"; do
 bar=main
 [[ "$monitor" != "$primary" ]] || bar=primary
 MONITOR="$monitor" polybar "$bar" &
done
