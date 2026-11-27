# Recovery

Use Ctrl+Alt+F3 for a TTY. Log in with your normal sudo account.

- Inspect journalctl -b -u lightdm and ~/.local/state/bspwm-desktop/install.log.
- To boot to console: sudo systemctl set-default multi-user.target; reboot. Restore graphical.target after fixing.
- Backups of overwritten user configuration are in ~/.local/state/bspwm-desktop/backup-*.
- Network rollback: identify the correct /root/bspwm-netplan.* backup printed by installer. Remove /etc/netplan/01-network-manager-all.yaml, restore original YAML from that backup, remove /etc/cloud/cloud.cfg.d/99-bspwm-disable-network-config.cfg and /etc/NetworkManager/conf.d/10-no-assume.conf if created by this installer. Enable systemd-networkd.service and systemd-networkd.socket if originally enabled; disable NetworkManager if it was not originally enabled. Run sudo netplan generate and reboot from local console. Review original configuration rather than applying these steps blindly.
- No full system rollback is provided. Take a VM snapshot or disk image before testing.


Network preflight is read-only and runs before package changes. Completed NetworkManager conversions are skipped; preserve the original printed backup. If networking is managed by networkd and --keep-network was used, nm-applet cannot manage those interfaces. For a display issue, use ARandR and restart bspwm with Super+Alt+R to refresh bars; hotplug is not fully automated. If the locker does not require a password on resume, do not use the desktop for sensitive work until fixed. Check journalctl --user -b and run desktop-doctor.
