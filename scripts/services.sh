#!/usr/bin/env bash
set -euo pipefail
sudo apt install -y pipewire-audio alsa-utils bluez blueman pavucontrol \
 udisks2 gvfs gvfs-backends gnome-keyring libpam-gnome-keyring libsecret-tools seahorse dbus-user-session \
 xdg-user-dirs xdg-utils xdg-desktop-portal xdg-desktop-portal-gtk \
 upower power-profiles-daemon accountsservice brightnessctl ddcutil \
 bubblewrap ffmpegthumbnailer poppler-utils unzip fonts-noto fonts-noto-color-emoji fonts-dejavu-core \
 adwaita-icon-theme hicolor-icon-theme cups cups-pk-helper cups-browsed avahi-daemon libnss-mdns \
 ipp-usb sane-airscan simple-scan system-config-printer flatpak libfuse2t64 gnome-disk-utility fwupd \
 network-manager network-manager-gnome wpasupplicant
sudo systemctl enable cups.service avahi-daemon.service bluetooth.service
xdg-user-dirs-update
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

