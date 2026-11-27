#!/usr/bin/env bash
set -euo pipefail
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl wget git ca-certificates gnupg micro software-properties-common unattended-upgrades
if command -v snap >/dev/null && snap list 2>/dev/null | grep -qv '^Name'; then
 echo "Snap packages exist. Review and remove them manually before proceeding."
 exit 1
fi
sudo apt purge -y snapd
printf 'Package: snapd\nPin: release a=*\nPin-Priority: -10\n' | sudo tee /etc/apt/preferences.d/nosnap.pref >/dev/null
sudo add-apt-repository -y universe
sudo apt update

