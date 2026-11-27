#!/usr/bin/env bash
set -euo pipefail
# Dux baseline: normal Ubuntu updates, base tools, remove and pin Snap.
sudo apt update
sudo apt full-upgrade -y
sudo apt install -y curl wget git ca-certificates gnupg software-properties-common micro
sudo apt purge -y snapd
printf 'Package: snapd\nPin: release a=*\nPin-Priority: -10\n' | sudo tee /etc/apt/preferences.d/nosnap.pref >/dev/null
# Do not delete user Snap data or automatically autoremove packages.
