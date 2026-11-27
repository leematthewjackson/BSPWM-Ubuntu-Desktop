#!/usr/bin/env bash
set -euo pipefail
sudo apt install -y vlc
sudo flatpak install --system -y flathub org.mozilla.firefox org.kde.gwenview com.nextcloud.desktopclient.nextcloud com.tomjwatson.Emote
# Only Ubuntu and Flathub; vendor software is strictly opt-in.
bash "$PROJECT/scripts/default-apps.sh"
