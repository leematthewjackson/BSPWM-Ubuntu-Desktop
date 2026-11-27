# Recovery

Use Ctrl+Alt+F3 for a TTY and log in as your normal sudo user.

- After base.sh, reboot and check nmcli device status (and nvidia-smi for NVIDIA) before running build.sh.
- If a package operation fails, read its terminal output and /var/log/apt/term.log. Check sudo dpkg --audit. Do not reboot halfway through a failed build.
- If the display manager is wrong, run sudo dpkg-reconfigure lightdm directly and choose lightdm. Check journalctl -b -u lightdm.
- To boot to console: sudo systemctl set-default multi-user.target; reboot. Restore graphical.target after fixing.
- Previous desktop configuration files are backed up under ~/.config/bspwm-desktop-backup.*.
- Networking follows Dux: original 00-installer-config.yaml or 50-cloud-init.yaml is backed up in /root with a .bak suffix. For rollback from local console, remove /etc/netplan/01-network-manager-all.yaml, restore original YAML, remove /etc/NetworkManager/conf.d/10-no-assume.conf if created by base.sh, restore original network service enablement, run sudo netplan generate and reboot. Inspect the original configuration before doing this. Use --keep-network for custom networking.
- Snap purge may remove Ubuntu Server metapackages; never run apt autoremove blindly. Review the Snap pin and metapackages before a release upgrade.
- If suspend/resume does not require a password, do not use the desktop for sensitive work until fixed.

No full system rollback is provided. Test on a fresh disposable installation.
