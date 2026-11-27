#!/usr/bin/env bash
polybar-msg cmd quit >/dev/null 2>&1 || true
while IFS= read -r monitor; do
 MONITOR="$monitor" polybar main &
done < <(polybar --list-monitors | cut -d: -f1)

