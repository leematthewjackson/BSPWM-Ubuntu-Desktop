# Maintainer rules

Keep this a configuration project, not a distribution. The goal is a reliable complete everyday desktop, not an Omarchy clone.

- Main installer: Ubuntu repositories and Flathub only. No additional vendor repositories, key-verification prompts or downloaded vendor installers in the default installation.
- Optional applications that require vendor repositories, signing keys or bootstrap installers belong in extras/ and must never be called by install.sh. ArtCraft, Brave, Sublime Text and Claude Code are opt-in. Desktop+ is excluded.
- Prefer native bspwm commands and configuration of standard utilities over custom runtime wrappers. Do not introduce compatibility hacks solely to emulate another desktop. Preserve familiar shortcuts where practical and document differences.
- No Dux, Hyprland, Omarchy, custom shell, mandatory AI, passwordless sudo or weakened PAM/Polkit. Keep exactly two readable installation scripts: base.sh, reboot, build.sh, reboot. No orchestrator or extra installation stages.
- Keep essential integration, safe backups, simple essential safety checks, recovery instructions and read-only diagnostics. Avoid extra abstractions unless they clearly reduce complexity.
- Never claim a test passed without evidence. Do not run the installer on a live workstation without explicit permission. Review security, idempotency and hardware differences before changes. Document each new dependency and decision.
- Verify all vendor signing keys independently before trusting them; retain explicit consent for downloaded installer execution.

Dux setup.sh is the reference for base updates, Snap removal, desktop plumbing, NVIDIA installation and networking. Keep base.sh as close to that working script as possible. Preserve Ubuntu installation choices (keyboard, language, timezone, locale, storage). No installer-wide output redirection, custom logging, speculative preflight or unattended display-manager workarounds. Use standard Ubuntu configuration dialogues directly. Do not add new features before real-world testing.
