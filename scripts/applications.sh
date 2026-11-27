#!/usr/bin/env bash
set -euo pipefail
sudo apt install -y vlc
sudo flatpak install --system -y flathub org.mozilla.firefox org.kde.gwenview com.nextcloud.desktopclient.nextcloud com.tomjwatson.Emote
# Vendor apps are separate from the Ubuntu desktop packages.
bash "$PROJECT/scripts/vendor-apps.sh"
bash "$PROJECT/scripts/default-apps.sh"
