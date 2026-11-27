#!/usr/bin/env bash
set -euo pipefail
# Firefox from Flathub avoids Ubuntu's Snap transition and additional APT repos.
flatpak install --system -y flathub org.mozilla.firefox
xdg-mime default org.mozilla.firefox.desktop text/html x-scheme-handler/http x-scheme-handler/https application/pdf
if [[ $APPS == 1 ]]; then
 sudo apt install -y vlc
 flatpak install --system -y flathub org.kde.gwenview com.nextcloud.desktopclient.nextcloud
fi

