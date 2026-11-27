#!/usr/bin/env bash
# Stage 1: Dux Ubuntu LTS baseline, without installing Dux.
# Fresh Ubuntu Server 26.04; run locally as your normal user.
set -euo pipefail

# --- Options -----------------------------------------------------------------
NVIDIA=no
NETWORK=yes
for arg in "$@"; do
  case "$arg" in
    --nvidia) NVIDIA=yes ;;
    --keep-network) NETWORK=no ;;
    *) echo "Unknown option: $arg (use --nvidia or --keep-network)"; exit 1 ;;
  esac
done

# Must run as the normal user: xdg-user-dirs-update sets up YOUR home folders.
if [ "$(id -u)" -eq 0 ]; then
  echo "Run this as your normal user, not with sudo. It will ask for your password."
  exit 1
fi

if [[ "$NETWORK" == yes && -n ${SSH_CONNECTION:-} ]]; then
  echo "Run locally or use --keep-network."
  exit 1
fi
sudo -v

# --- 1. Updates and base tools (guide Section 1) ----------------------------
echo "==> 1. Updates and base tools"
sudo apt update
sudo apt full-upgrade -y
# curl/wget: downloads   git: cloning repos   gnupg: checking repo keys
# software-properties-common: add-apt-repository (used by the Dux installer)
# micro: simple terminal text editor
sudo apt install -y curl wget git ca-certificates gnupg software-properties-common micro

# --- 1b. Remove Snap and block it (guide Section 1) -------------------------
# Like Linux Mint: purge snapd, delete its folders, and pin it at -10 so APT
# can never install it again, even as a dependency of something else.
echo "==> 1b. Remove Snap and keep it out (the Linux Mint way)"
sudo apt purge -y snapd
 # Leave any remaining user Snap data alone. Never autoremove automatically.
sudo tee /etc/apt/preferences.d/nosnap.pref >/dev/null <<'EOF'
# Keep snapd out, the Linux Mint way
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

# --- 2. Desktop plumbing (guide Section 4) ----------------------------------
# Installed before bspwm so the first login has everything it needs.
echo "==> 2. Desktop plumbing"
sudo apt install -y \
  pipewire-audio bluez alsa-utils \
  udisks2 gvfs gvfs-backends \
  gnome-keyring libpam-gnome-keyring libsecret-tools dbus-user-session \
  xdg-user-dirs xdg-utils xwayland \
  xdg-desktop-portal xdg-desktop-portal-gtk \
  upower power-profiles-daemon accountsservice \
  brightnessctl ddcutil \
  bubblewrap ffmpegthumbnailer poppler-utils unzip \
  fonts-noto fonts-noto-color-emoji fonts-dejavu-core \
  adwaita-icon-theme hicolor-icon-theme \
  qt6-image-formats-plugins kimageformat6-plugins \
  cups cups-pk-helper cups-browsed avahi-daemon libnss-mdns \
  ipp-usb sane-airscan simple-scan \
  flatpak libfuse2t64 \
  gnome-disk-utility fwupd
# What that covers, line by line:
#   audio + Bluetooth audio (pipewire-audio pulls in WirePlumber etc.)
#   USB drives, network shares, trash (udisks2 + gvfs)
#   keyring + auto-unlock at login, user D-Bus session
#   home folders (Documents, Downloads...), default apps, X11 app support
#   portals: file dialogs and screen sharing
#   battery, power profiles, user accounts (Dux's controls)
#   laptop + external monitor brightness
#   thumbnails (video, PDF), archive support
#   fonts incl. emoji
#   icons
#   extra image formats (AVIF/HEIC/JXL) - clears image format support
#   printing: CUPS, printer controls, network printer discovery
#   driverless USB printers, network/USB scanners, Simple Scan
#   Flatpak + AppImage (FUSE 2) support
#   GNOME Disks (partitions, disk health) + firmware updates
# Ubuntu brightness-udev grants backlight writes to the video group.
# Membership also grants access to video devices; applies after login/reboot.
sudo usermod -aG video "$(id -un)"
xdg-user-dirs-update
sudo flatpak remote-add --if-not-exists flathub \
  https://dl.flathub.org/repo/flathub.flatpakrepo

# --- 3. NVIDIA driver (guide Section 3, only with --nvidia) -----------------
# Ubuntu's own tested driver. Starts working after the reboot.
if [ "$NVIDIA" = yes ]; then
  echo "==> 3. NVIDIA driver"
  sudo apt install -y ubuntu-drivers-common
  sudo ubuntu-drivers install --recommended
else
  echo "==> 3. NVIDIA driver: skipped (run with --nvidia to include)"
fi

# --- 4. Switch to NetworkManager (guide Section 2) --------------------------
# Done LAST. Nothing changes until the reboot.
if [[ "$NETWORK" == yes ]]; then
echo "==> 4. Switch to NetworkManager (takes effect after reboot)"
sudo apt install -y network-manager wpasupplicant

# Hand all networking to NetworkManager (same file Ubuntu Desktop uses).
sudo tee /etc/netplan/01-network-manager-all.yaml >/dev/null <<'EOF'
network:
  version: 2
  renderer: NetworkManager
EOF
sudo chmod 600 /etc/netplan/01-network-manager-all.yaml

# Move the installer's own network file out of the way (backup kept in /root).
# On these machines it was 00-installer-config.yaml. Some installs call it
# 50-cloud-init.yaml instead - if nmcli shows "unmanaged" after the reboot,
# check /etc/netplan/ for a leftover file like that.
for file in 00-installer-config.yaml 50-cloud-init.yaml; do
  if [[ -f "/etc/netplan/$file" ]]; then
    sudo mv -n "/etc/netplan/$file" "/root/$file.bak"
  fi
done

# Make NetworkManager apply its own Ethernet profile at boot, instead of
# "assuming" the half-finished setup Ubuntu's boot image (dracut) leaves
# behind. Without this: no internet at boot until you toggle the connection.
sudo mkdir -p /etc/NetworkManager/conf.d
sudo tee /etc/NetworkManager/conf.d/10-no-assume.conf >/dev/null <<'EOF'
[device-ethernet]
match-device=type:ethernet
keep-configuration=no
EOF

# Turn off systemd-networkd (dracut's leftover catch-all DHCP rule would
# otherwise keep it running the network alongside NetworkManager), and stop
# boot from waiting for the network. Networking itself stays on.
sudo systemctl enable NetworkManager.service
sudo systemctl disable systemd-networkd.service systemd-networkd.socket
sudo systemctl disable systemd-networkd-wait-online.service
sudo systemctl disable NetworkManager-wait-online.service

fi

echo "Base complete. Reboot before running build.sh."
