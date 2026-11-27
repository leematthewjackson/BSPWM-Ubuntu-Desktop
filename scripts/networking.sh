#!/usr/bin/env bash
set -euo pipefail
[[ $NETWORK == 1 ]] || exit 0
if [[ -n ${SSH_CONNECTION:-} ]]; then
 echo "Network conversion requires a local console. Use --keep-network to skip."
 exit 1
fi
shopt -s nullglob
# Skip our completed conversion, never replace its original backup.
files=(/etc/netplan/*.yaml /etc/netplan/*.yml)
if [[ ${#files[@]} == 1 && ${files[0]} == /etc/netplan/01-network-manager-all.yaml ]] &&
 sudo grep -q 'renderer: NetworkManager' "${files[0]}" &&
 systemctl is-enabled --quiet NetworkManager.service &&
 sudo test -f /etc/NetworkManager/conf.d/10-no-assume.conf; then
 echo "NetworkManager conversion already configured; keeping original backup."
 exit 0
fi
# If a pre-existing configuration already uses NetworkManager, preserve it.
if sudo netplan get network.renderer 2>/dev/null | grep -qx NetworkManager; then
 echo "Existing NetworkManager renderer preserved."
 exit 0
fi
backup=$(sudo mktemp -d /root/bspwm-netplan.XXXXXX)
for f in "${files[@]}"; do sudo mv "$f" "$backup/"; done
printf 'network:\n  version: 2\n  renderer: NetworkManager\n' | sudo tee /etc/netplan/01-network-manager-all.yaml >/dev/null
sudo chmod 600 /etc/netplan/01-network-manager-all.yaml
if ! sudo netplan generate; then
 sudo rm /etc/netplan/01-network-manager-all.yaml
 sudo cp -a "$backup/." /etc/netplan/
 sudo netplan generate
 exit 1
fi
# Prevent cloud-init from regenerating its old network file.
if [[ -d /etc/cloud/cloud.cfg.d ]]; then
 printf 'network: {config: disabled}\n' | sudo tee /etc/cloud/cloud.cfg.d/99-bspwm-disable-network-config.cfg >/dev/null
fi
sudo mkdir -p /etc/NetworkManager/conf.d
printf '[device-ethernet]\nmatch-device=type:ethernet\nkeep-configuration=no\n' | sudo tee /etc/NetworkManager/conf.d/10-no-assume.conf >/dev/null
sudo systemctl enable NetworkManager.service
for unit in systemd-networkd.service systemd-networkd.socket systemd-networkd-wait-online.service NetworkManager-wait-online.service; do
 sudo systemctl disable "$unit" || true
done
echo "Network backup: $backup. Changes take effect at reboot. See RECOVERY.md."

