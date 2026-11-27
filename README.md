# BSPWM Ubuntu Desktop

Personal keyboard-first X11 desktop on Ubuntu Server 26.04 LTS. No Dux, Omarchy, Hyprland, Snap or AI runtime. Core desktop packages from Ubuntu; everyday applications from Ubuntu, Flathub and the official Brave and Sublime Text repositories.

**Status: initial implementation for review, NOT yet tested on Ubuntu 26.04 or real hardware. Use a disposable VM or spare disk first.**

## Install

Fresh Ubuntu Server 26.04, normal sudo user, local console, DHCP Ethernet recommended. Select Btrfs manually if desired; snapshots are not automated. Do not run on a production workstation or existing desktop.

    sudo apt update
    sudo apt install git
    git clone https://github.com/leematthewjackson/BSPWM-Ubuntu-Desktop.git
    cd BSPWM-Ubuntu-Desktop
    ./install.sh --nvidia && sudo reboot

Omit --nvidia for Intel/AMD. All everyday apps are installed by default; --apps is accepted for backwards compatibility. Verify the Brave and Sublime Text full primary signing fingerprints against their official documentation when prompted; installer rejects unapproved keys. --keep-network leaves existing Netplan untouched; networkd-managed interfaces may appear unmanaged in nm-applet and require manual Wi-Fi configuration. Installer runs all local stages; no external framework installer. Complete MOK enrolment if prompted. Log in through LightDM (bspwm session). Run desktop-doctor inside the session.

## Design

- Ubuntu's packages, LightDM/PAM, MATE Polkit, GNOME Keyring, XDG desktop autostart via dex.
- bspwm longest-side tiling, sxhkd, Polybar, Rofi, Picom, Thunar and independent utilities.
- UK keyboard, dark theme, one bar per monitor. Ten numbered workspaces are distributed across connected monitors at first login. A single primary system tray; hotplug and mixed DPI need hardware testing.
- Existing configuration files backed up under ~/.local/state/bspwm-desktop. Log there too.
- No automatic AI or third-party repositories for core desktop packages. Brave and Sublime Text use their official APT repositories only for applications.

The underlying package selection and networking approach are adapted from [Dux Desktop on Ubuntu LTS](https://github.com/leematthewjackson/Dux-Desktop-on-Ubuntu-LTS), without installing Dux.

## Everyday applications

APT: Brave, Sublime Text, VLC, Flameshot, CopyQ, Thunar, Kitty, GNOME Text Editor and Calculator.
Flathub: Firefox (default browser and PDF viewer), Gwenview (images), Nextcloud and Emote.
Nextcloud starts in the tray at login; sign in manually. CopyQ starts automatically; review its history limits and password/sensitive clipboard handling before use. Super+E opens Emote, Print opens Flameshot, Super+Ctrl+V opens CopyQ. Ctrl+Alt+T and Ctrl+Alt+L are additional Mint-style shortcuts.

Optional: see [extras/README.md](extras/README.md) for independent ArtCraft and Claude Code installers. Desktop+ is not included. The main installer never calls either extra.

## Maintenance

    sudo apt update && sudo apt upgrade
    flatpak update

Ubuntu Pro is optional: run pro status, attach your own token interactively if desired. Never commit it. Use the normal release upgrade process; verify the desktop on a new LTS before upgrading.

See KEYBINDINGS.md, RECOVERY.md and REVIEW.md. No guarantees until acceptance tests pass. Redshift, autorandr and display scaling tools are installed for manual setup; no location or hardware assumptions.

