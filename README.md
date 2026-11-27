# BSPWM Ubuntu Desktop

Personal keyboard-first X11 desktop on Ubuntu Server 26.04 LTS. No Dux, Omarchy, Hyprland, Snap or AI runtime. The main installer uses only Ubuntu repositories and Flathub. Third-party vendor repositories and installers are separate, optional extras.

**Status: two-stage installation successfully tested on a ThinkPad P53 (27 November 2026). Desktop login, core autostart, NVIDIA, Ethernet and audio detection confirmed. Brightness group membership, Polybar spacing and Rofi theme verified manually. Border styling, GLX rounded corners and searchable Rofi power launchers verified manually. Other hardware and peripheral functions still need acceptance testing.**

## Install

Fresh Ubuntu Server 26.04, normal sudo user, local console, DHCP Ethernet. Keep your Ubuntu installation choices. Back up data before testing. For custom networking use --keep-network.

### 1. Prepare Ubuntu

    sudo apt update
    sudo apt install -y git
    git clone https://github.com/leematthewjackson/BSPWM-Ubuntu-Desktop.git
    cd BSPWM-Ubuntu-Desktop
    ./base.sh --nvidia && sudo reboot

Omit --nvidia for Intel/AMD. This stage follows Dux's working base setup: updates, Snap purge/pin, desktop plumbing, Flathub, optional NVIDIA and NetworkManager last. Complete MOK enrolment if prompted. The user is added to the video group for standard Ubuntu backlight permissions.

### 2. Build the desktop after reboot

    nmcli device status
    nvidia-smi
    cd ~/BSPWM-Ubuntu-Desktop
    ./build.sh && sudo reboot

The NVIDIA check is only for NVIDIA installations. Confirm networking works before proceeding. Select lightdm if Ubuntu prompts for a display manager. After the second reboot choose bspwm at LightDM and log in. Super+Enter opens Kitty; run desktop-doctor.

There are only two installation scripts. Both run directly in the terminal with normal sudo and package prompts. No external desktop framework is installed. Optional vendor apps remain independent.

## Design

- Ubuntu's packages, LightDM/PAM, MATE Polkit, GNOME Keyring, XDG desktop autostart via dex.
- bspwm longest-side tiling, sxhkd, Polybar, Rofi, Picom, Thunar and independent utilities.
- Existing Ubuntu keyboard, language and regional preferences are untouched; dark theme, one bar per monitor. Ten numbered workspaces are distributed across connected monitors at first login. A single primary system tray; hotplug and mixed DPI need hardware testing.
- Existing desktop configuration files are backed up under ~/.config/bspwm-desktop-backup.*. Scripts run directly in the terminal without output redirection.
- Prefer native commands and ordinary configuration over custom runtime helpers. No automatic AI, third-party APT repositories or vendor installers in the main installation.
- Preserve familiar keyboard shortcuts where native bspwm supports them. Do not add compatibility hacks solely to emulate Omarchy.

The underlying package selection and networking approach are adapted from [Dux Desktop on Ubuntu LTS](https://github.com/leematthewjackson/Dux-Desktop-on-Ubuntu-LTS), without installing Dux.

## Touchpads

Tap-to-click and tap-and-drag are enabled during build.sh using the standard Xorg libinput InputClass configuration, tested on the ThinkPad P53. This applies only to touchpads.

## Power controls

Super+Escape opens the system menu. Reboot, Shutdown and Logout are also searchable from Super+Space and use the same confirmation prompts.

## Application appearance

Regular applications default to light GTK appearance. The session does not force a colour scheme at login. Rofi, Polybar and Kitty retain their independent dark themes. Use LXAppearance (Customise Look and Feel) to select a GTK theme. For applications following the GNOME colour preference, run `gsettings set org.gnome.desktop.interface color-scheme prefer-dark` for dark or `gsettings set org.gnome.desktop.interface color-scheme default` to restore the default. Some applications have their own appearance settings.

## Wallpaper

Launch Azote from Rofi to browse images and set wallpapers graphically. Azote uses Feh on X11; bspwm restores the saved ~/.fehbg at login. Until an image is chosen, the background is dark. Both packages come from Ubuntu Universe.

## Everyday applications

Kitty's terminal shortcuts use native single-instance mode for faster subsequent windows. Thunar starts in daemon mode via XDG autostart to keep the file manager ready between launches.

APT: VLC, Flameshot, CopyQ, Thunar, Kitty, GNOME Text Editor and Calculator.
Flathub: Firefox (default browser and PDF viewer), Gwenview (images), Nextcloud and Emote.
Nextcloud starts in the tray at login; sign in manually. CopyQ starts automatically; review its history limits and password/sensitive clipboard handling before use. Super+E opens Emote, Print opens Flameshot, Super+Ctrl+V opens CopyQ. Ctrl+Alt+T and Ctrl+Alt+L are additional Mint-style shortcuts.

Optional: see [extras/README.md](extras/README.md) for independent ArtCraft, Brave, Sublime Text and Claude Code installers. Desktop+ is not included. The main installer never calls any extra.

## Maintenance

As in the Dux setup, Snap is purged and pinned out. Ubuntu Server metapackages may be removed because they depend on snapd; no automatic autoremove is performed. Never run autoremove blindly. Review metapackage requirements before a future Ubuntu release upgrade.

    sudo apt update && sudo apt upgrade
    flatpak update

Ubuntu Pro is optional: run pro status, attach your own token interactively if desired. Never commit it. Use the normal release upgrade process; verify the desktop on a new LTS before upgrading.

See KEYBINDINGS.md, RECOVERY.md and REVIEW.md. No guarantees until acceptance tests pass. Redshift, autorandr and display scaling tools are installed for manual setup; no location or hardware assumptions.

