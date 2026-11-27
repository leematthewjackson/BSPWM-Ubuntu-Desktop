# BSPWM Ubuntu Desktop

Personal keyboard-first X11 desktop on Ubuntu Server 26.04 LTS. No Dux, Omarchy, Hyprland, Snap or AI runtime. Core packages from Ubuntu; Firefox from Flathub.

**Status: initial implementation for review, NOT yet tested on Ubuntu 26.04 or real hardware. Use a disposable VM or spare disk first.**

## Install

Fresh Ubuntu Server 26.04, normal sudo user, local console, DHCP Ethernet recommended. Select Btrfs manually if desired; snapshots are not automated. Do not run on a production workstation or existing desktop.

    sudo apt update
    sudo apt install git
    git clone https://github.com/leematthewjackson/BSPWM-Ubuntu-Desktop.git
    cd BSPWM-Ubuntu-Desktop
    ./install.sh --nvidia --apps
    sudo reboot

Omit --nvidia for Intel/AMD. --apps adds VLC, Gwenview and Nextcloud. --keep-network leaves existing Netplan untouched. Installer runs all local stages; no external framework installer. Complete MOK enrolment if prompted. Log in through LightDM (bspwm session). Run desktop-doctor inside the session.

## Design

- Ubuntu's packages, LightDM/PAM, MATE Polkit, GNOME Keyring, XDG desktop autostart via dex.
- bspwm longest-side tiling, sxhkd, Polybar, Rofi, Picom, Thunar and independent utilities.
- UK keyboard, dark theme, one bar per monitor. Multi-monitor workspace assignment and mixed DPI need review.
- Existing configuration files backed up under ~/.local/state/bspwm-desktop. Log there too.
- No automatic AI, additional APT vendors or arbitrary remote shell scripts.

The underlying package selection and networking approach are adapted from [Dux Desktop on Ubuntu LTS](https://github.com/leematthewjackson/Dux-Desktop-on-Ubuntu-LTS), without installing Dux.

## Maintenance

    sudo apt update && sudo apt upgrade
    flatpak update

Ubuntu Pro is optional: run pro status, attach your own token interactively if desired. Never commit it. Use the normal release upgrade process; verify the desktop on a new LTS before upgrading.

See KEYBINDINGS.md, RECOVERY.md and REVIEW.md. No guarantees until acceptance tests pass. Redshift, autorandr and display scaling tools are installed for manual setup; no location or hardware assumptions.

