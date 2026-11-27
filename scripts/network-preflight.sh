#!/usr/bin/env bash
set -euo pipefail
[[ $NETWORK == 1 ]] || exit 0
if [[ -n ${SSH_CONNECTION:-} ]]; then
 echo "Network conversion requires a local console. Use --keep-network to skip."
 exit 1
fi
shopt -s nullglob
for file in /etc/netplan/*.yaml /etc/netplan/*.yml; do
 if sudo grep -Eq 'addresses:|access-points:|routes:|nameservers:|bonds:|bridges:|vlans:|wifis:|gateway[46]:|match:|set-name:|dhcp[46]:[[:space:]]*(false|no)|optional:|routing-policy:|renderer:[[:space:]]*networkd' "$file"; then
  echo "Custom networking in $file; use --keep-network and configure manually."
  exit 1
 fi
done
