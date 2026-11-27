#!/usr/bin/env bash
set -euo pipefail
sudo apt install -y xorg bspwm sxhkd polybar rofi picom lightdm lightdm-gtk-greeter \
 azote feh python3-xlib dunst thunar thunar-archive-plugin thunar-volman tumbler xarchiver \
 kitty flameshot arandr autorandr redshift xfce4-power-manager light-locker \
 mate-polkit dex copyq lxappearance gnome-text-editor x11-xserver-utils xclip gnome-calculator playerctl
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
