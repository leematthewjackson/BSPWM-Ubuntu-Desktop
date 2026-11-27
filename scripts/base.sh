#!/usr/bin/env bash
set -euo pipefail
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y universe
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl wget git ca-certificates gnupg micro unattended-upgrades
# Follow the proven Dux purge approach; allow only Snap and server metapackages.
plan=$(LC_ALL=C apt-get -s purge snapd)
unexpected=$(printf '%s\n' "$plan" | awk '$1=="Remv" || $1=="Purg" {sub(/:.*/, "", $2); if ($2!="snapd" && $2!="ubuntu-server" && $2!="ubuntu-server-minimal") print $2}')
[[ -z "$unexpected" ]] || { printf 'Unexpected removals:\n%s\n' "$unexpected"; exit 1; }
# Retain installed dependencies of any server metapackage being removed.
for meta in ubuntu-server ubuntu-server-minimal; do
 if printf '%s\n' "$plan" | awk -v p="$meta" '($1=="Remv" || $1=="Purg") && $2==p {found=1} END{exit !found}'; then
  mapfile -t deps < <(apt-cache depends "$meta" | awk '/(Pre)?Depends:|Recommends:/ && $2 !~ /^</ {print $2}' | sort -u)
  keep=()
  for dep in "${deps[@]}"; do
   if [[ $(dpkg-query -W -f='${db:Status-Status}' "$dep" 2>/dev/null || true) == installed ]]; then keep+=("$dep"); fi
  done
  if (( ${#keep[@]} )); then sudo apt-mark manual "${keep[@]}"; fi
 fi
done
sudo apt purge -y snapd
printf 'Package: snapd\nPin: release a=*\nPin-Priority: -10\n' | sudo tee /etc/apt/preferences.d/nosnap.pref >/dev/null
# Never run apt autoremove automatically.
