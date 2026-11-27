# Maintainer rules

Keep this a configuration project, not a distribution. No Dux, Hyprland, Omarchy, custom shell, additional core desktop package repository, automatic remote shell installer, mandatory AI, passwordless sudo or weakened PAM/Polkit. Standard Ubuntu packages for core desktop. Prefer simple independent utilities. Keep one entry point, modular scripts, safe backups and understandable configuration. Never claim a test passed without evidence. Do not run the installer on a live workstation without explicit permission. Review security, idempotency and hardware differences before proposing changes. Document every new dependency and decision.


Approved application exceptions: official Brave and Sublime Text APT repositories. ArtCraft and Claude Code are opt-in extras only; never call them from install.sh. Desktop+ is excluded. Verify vendor signing keys and keep user approval before executing downloaded installers.
