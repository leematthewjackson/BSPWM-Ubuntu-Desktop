#!/usr/bin/env bash
# Stage 2: run after rebooting the Dux-based Ubuntu foundation.
set -euo pipefail
cd -- "$(dirname -- "$0")"
PROJECT="$PWD"
[[ $EUID != 0 ]] || { echo "Run as your normal sudo user"; exit 1; }
sudo -v

echo "==> Install desktop and utilities"
sudo apt install -y xorg bspwm sxhkd polybar rofi picom lightdm lightdm-gtk-greeter \
 azote feh python3-xlib dunst thunar thunar-archive-plugin thunar-volman tumbler xarchiver \
 kitty flameshot arandr autorandr redshift xfce4-power-manager light-locker \
 mate-polkit dex copyq lxappearance gnome-text-editor x11-xserver-utils xclip gnome-calculator playerctl \
 blueman pavucontrol seahorse system-config-printer network-manager-gnome vlc

echo "==> Install personal applications"
sudo flatpak install --system -y flathub org.mozilla.firefox org.kde.gwenview com.nextcloud.desktopclient.nextcloud com.tomjwatson.Emote

echo "==> Install desktop configuration"
# Fresh install: copy the desktop configuration and tools, no OS preferences.
mkdir -p "$HOME/.config" "$HOME/.local/bin"
backup=$(mktemp -d "$HOME/.config/bspwm-desktop-backup.XXXXXXXX")
while IFS= read -r -d '' source; do
 rel="${source#"$PROJECT/config/"}"
 dest="$HOME/.config/$rel"
 if [[ -e "$dest" || -L "$dest" ]]; then
  if cmp -s "$source" "$dest"; then continue; fi
  mkdir -p "$backup/$(dirname "$rel")"
  cp -a -- "$dest" "$backup/$rel"
 fi
 install -D -m 644 "$source" "$dest"
done < <(find "$PROJECT/config" -type f -print0)
chmod +x "$HOME/.config/bspwm/bspwmrc" "$HOME/.config/polybar/launch.sh"
install -m 644 "$PROJECT/KEYBINDINGS.md" "$HOME/.config/bspwm/KEYBINDINGS.md"
install -m 755 "$PROJECT"/bin/* "$HOME/.local/bin/"

# Standard per-user application launchers, using the existing power confirmation menu.
mkdir -p "$HOME/.local/share/applications"
for action in Reboot Shutdown Logout; do
 cat > "$HOME/.local/share/applications/desktop-${action,,}.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=$action
Exec="$HOME/.local/bin/desktop-power" $action
Icon=system-${action,,}
Terminal=false
Categories=System;
EOF
done
rmdir "$backup" 2>/dev/null || echo "Previous desktop configs: $backup"

echo "==> Set application defaults"
# Run as the desktop user; xdg-mime writes per-user defaults.
xdg-mime default thunar.desktop inode/directory
xdg-mime default org.gnome.TextEditor.desktop text/plain
xdg-mime default org.mozilla.firefox.desktop text/html application/xhtml+xml x-scheme-handler/http x-scheme-handler/https application/pdf
xdg-mime default org.kde.gwenview.desktop image/jpeg image/png image/gif image/webp image/bmp image/tiff
xdg-mime default vlc.desktop video/mp4 video/mpeg video/webm video/x-matroska video/quicktime audio/mpeg audio/ogg audio/wav audio/flac audio/aac
xdg-mime default xarchiver.desktop application/zip application/gzip application/x-tar application/x-xz application/x-bzip2 application/x-7z-compressed application/vnd.rar application/x-rar

echo "==> Enable touchpad tapping"
sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee /etc/X11/xorg.conf.d/40-touchpad.conf >/dev/null <<'EOF'
Section "InputClass"
    Identifier "Touchpad settings"
    MatchIsTouchpad "on"
    MatchDriver "libinput"
    Option "Tapping" "on"
    Option "TappingDrag" "on"
EndSection
EOF

echo "==> Configure graphical login"
# Use the normal Ubuntu package configuration interface if GDM was selected.
if [[ $(cat /etc/X11/default-display-manager 2>/dev/null || true) != /usr/sbin/lightdm ]] ||
 [[ $(readlink -f /etc/systemd/system/display-manager.service) != /usr/lib/systemd/system/lightdm.service ]]; then
 echo "Select lightdm in the following Ubuntu configuration dialogue."
 sudo dpkg-reconfigure lightdm
fi
[[ $(cat /etc/X11/default-display-manager) == /usr/sbin/lightdm ]] || { echo "LightDM not selected; select it using sudo dpkg-reconfigure lightdm."; exit 1; }
sudo systemctl enable lightdm.service
sudo systemctl set-default graphical.target
sudo install -d /etc/lightdm/lightdm.conf.d
printf '[Seat:*]\nuser-session=bspwm\ngreeter-session=lightdm-gtk-greeter\n' | sudo tee /etc/lightdm/lightdm.conf.d/60-bspwm.conf >/dev/null

echo "Build complete. Reboot and select bspwm at LightDM."
