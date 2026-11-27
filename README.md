# BSPWM Ubuntu Desktop

Personal keyboard-first X11 desktop on Ubuntu Server 26.04 LTS. No Dux, Omarchy, Hyprland, Snap or AI runtime. The main installer uses only Ubuntu repositories and Flathub. Third-party vendor repositories and installers are separate, optional extras.

**Status: initial implementation for review, NOT yet tested on Ubuntu 26.04 or real hardware. Use a disposable VM or spare disk first.**

## Install

Fresh Ubuntu Server 26.04, normal sudo user, local console, DHCP Ethernet recommended. The network conversion replaces existing Netplan YAML; use --keep-network for static addressing, existing Wi-Fi credentials or custom networking. Network conversion over SSH is refused. Select Btrfs manually if desired; snapshots are not automated. Do not run on a production workstation or existing desktop.

    sudo apt update
    sudo apt install git
    git clone https://github.com/leematthewjackson/BSPWM-Ubuntu-Desktop.git
    cd BSPWM-Ubuntu-Desktop
    ./install.sh --nvidia && sudo reboot

Omit --nvidia for Intel/AMD. All everyday apps are installed by default; --apps is accepted for backwards compatibility. No additional vendor APT keys or repositories are needed by the main installer. --keep-network leaves existing Netplan untouched; networkd-managed interfaces may appear unmanaged in nm-applet and require manual Wi-Fi configuration. Installer runs all local stages; no external framework installer. Complete MOK enrolment if prompted. Log in through LightDM (bspwm session). Run desktop-doctor inside the session.

## Design

- Ubuntu's packages, LightDM/PAM, MATE Polkit, GNOME Keyring, XDG desktop autostart via dex.
- bspwm longest-side tiling, sxhkd, Polybar, Rofi, Picom, Thunar and independent utilities.
- UK keyboard, dark theme, one bar per monitor. Ten numbered workspaces are distributed across connected monitors at first login. A single primary system tray; hotplug and mixed DPI need hardware testing.
- Existing configuration files backed up under ~/.local/state/bspwm-desktop. Log there too.
- Prefer native commands and ordinary configuration over custom runtime helpers. No automatic AI, third-party APT repositories or vendor installers in the main installation.
- Preserve familiar keyboard shortcuts where native bspwm supports them. Do not add compatibility hacks solely to emulate Omarchy.

The underlying package selection and networking approach are adapted from [Dux Desktop on Ubuntu LTS](https://github.com/leematthewjackson/Dux-Desktop-on-Ubuntu-LTS), without installing Dux.

## Everyday applications

APT: VLC, Flameshot, CopyQ, Thunar, Kitty, GNOME Text Editor and Calculator.
Flathub: Firefox (default browser and PDF viewer), Gwenview (images), Nextcloud and Emote.
Nextcloud starts in the tray at login; sign in manually. CopyQ starts automatically; review its history limits and password/sensitive clipboard handling before use. Super+E opens Emote, Print opens Flameshot, Super+Ctrl+V opens CopyQ. Ctrl+Alt+T and Ctrl+Alt+L are additional Mint-style shortcuts.

Optional: see [extras/README.md](extras/README.md) for independent ArtCraft, Brave, Sublime Text and Claude Code installers. Desktop+ is not included. The main installer never calls any extra.

## Maintenance

    sudo apt update && sudo apt upgrade
    flatpak update

Ubuntu Pro is optional: run pro status, attach your own token interactively if desired. Never commit it. Use the normal release upgrade process; verify the desktop on a new LTS before upgrading.

See KEYBINDINGS.md, RECOVERY.md and REVIEW.md. No guarantees until acceptance tests pass. Redshift, autorandr and display scaling tools are installed for manual setup; no location or hardware assumptions.

