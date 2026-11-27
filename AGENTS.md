# Maintainer rules

Keep this a configuration project, not a distribution. The goal is a reliable complete everyday desktop, not an Omarchy clone.

- Main installer: Ubuntu repositories and Flathub only. No additional vendor repositories, key-verification prompts or downloaded vendor installers in the default installation.
- Optional applications that require vendor repositories, signing keys or bootstrap installers belong in extras/ and must never be called by install.sh. ArtCraft, Brave, Sublime Text and Claude Code are opt-in. Desktop+ is excluded.
- Prefer native bspwm commands and configuration of standard utilities over custom runtime wrappers. Do not introduce compatibility hacks solely to emulate another desktop. Preserve familiar shortcuts where practical and document differences.
- No Dux, Hyprland, Omarchy, custom shell, mandatory AI, passwordless sudo or weakened PAM/Polkit. Keep a single installer entry point and readable modular scripts.
- Keep essential integration, safe backups, preflight checks, recovery instructions and read-only diagnostics. Avoid extra abstractions unless they clearly reduce complexity.
- Never claim a test passed without evidence. Do not run the installer on a live workstation without explicit permission. Review security, idempotency and hardware differences before changes. Document each new dependency and decision.
- Verify all vendor signing keys independently before trusting them; retain explicit consent for downloaded installer execution.
