#!/usr/bin/env bash
set -euo pipefail
# Inspect installed snaps and proposed removals before upgrading or purging.
if command -v snap >/dev/null; then
 installed=$(snap list 2>&1) || { echo "$installed"; exit 1; }
 if printf '%s\n' "$installed" | grep -q '^Name'; then
  echo "Installed snaps found; remove them manually before proceeding."
  exit 1
 fi
fi
sudo apt update
plan=$(LC_ALL=C apt-get -s purge snapd)
unexpected=$(printf '%s\n' "$plan" | awk '$1=="Remv" || $1=="Purg" {sub(/:.*/, "", $2); if ($2!="snapd") print $2}')
[[ -z "$unexpected" ]] || { printf 'Refusing purge; other packages would be removed:\n%s\n' "$unexpected"; exit 1; }
sudo apt install -y software-properties-common
sudo add-apt-repository -y universe
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl wget git ca-certificates gnupg micro unattended-upgrades
# Recheck immediately before purge.
plan=$(LC_ALL=C apt-get -s purge snapd)
unexpected=$(printf '%s\n' "$plan" | awk '$1=="Remv" || $1=="Purg" {sub(/:.*/, "", $2); if ($2!="snapd") print $2}')
[[ -z "$unexpected" ]] || { echo "Unexpected removals: $unexpected"; exit 1; }
sudo apt purge -y snapd
printf 'Package: snapd\nPin: release a=*\nPin-Priority: -10\n' | sudo tee /etc/apt/preferences.d/nosnap.pref >/dev/null
