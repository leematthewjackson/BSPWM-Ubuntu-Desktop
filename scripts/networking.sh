#!/usr/bin/env bash
set -euo pipefail
[[ $NETWORK == 1 ]] || exit 0
# Fresh DHCP systems only. Keep local console available.
if [[ -n ${SSH_CONNECTION:-} ]]; then
 echo "Refusing network conversion over SSH. Rerun locally or use --keep-network."
 exit 1
fi
# Do not discard static addressing, Wi-Fi credentials or custom network definitions.
shopt -s nullglob
for f in /etc/netplan/*.yaml; do
 if sudo grep -Eq 'addresses:|access-points:|routes:|nameservers:|bonds:|bridges:|vlans:' "$f"; then
  echo "Custom networking in $f; use --keep-network and configure manually."
  exit 1
 fi
done
backup=$(sudo mktemp -d /root/bspwm-netplan.XXXXXX)
for f in /etc/netplan/*.yaml; do sudo mv "$f" "$backup/"; done
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

