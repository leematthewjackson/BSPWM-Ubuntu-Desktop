#!/usr/bin/env bash
set -euo pipefail
echo 'lightdm shared/default-x-display-manager select lightdm' | sudo debconf-set-selections
sudo apt install -y xorg bspwm sxhkd polybar rofi picom lightdm lightdm-gtk-greeter \
 nitrogen dunst thunar thunar-archive-plugin thunar-volman tumbler xarchiver \
 kitty flameshot arandr autorandr redshift xfce4-power-manager light-locker \
 mate-polkit dex copyq lxappearance gnome-text-editor x11-xserver-utils xclip gnome-calculator playerctl
sudo systemctl enable lightdm.service
sudo systemctl set-default graphical.target
sudo install -d /etc/lightdm/lightdm.conf.d
printf '[Seat:*]\nuser-session=bspwm\ngreeter-session=lightdm-gtk-greeter\n' | sudo tee /etc/lightdm/lightdm.conf.d/60-bspwm.conf >/dev/null
sudo localectl set-x11-keymap gb
# Use packaged LightDM PAM configuration, never weaken authentication.
grep -q pam_gnome_keyring /etc/pam.d/lightdm || echo "WARNING: check LightDM PAM keyring integration before production use."


# Resolve the executable from the installed package, not a guessed release path.
agent=$(dpkg -L mate-polkit | grep '/polkit-mate-authentication-agent-1$' | head -n1)
[[ -n "$agent" && -x "$agent" ]] || { echo "MATE Polkit executable missing"; exit 1; }
for opt in --lock-on-suspend --lock-on-lid; do
 light-locker --help 2>&1 | grep -Fq -- "$opt" || { echo "Unsupported light-locker option: $opt"; exit 1; }
done
