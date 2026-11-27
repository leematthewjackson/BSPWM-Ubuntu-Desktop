#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "$0")"
export PROJECT="$PWD"
export NVIDIA=0 NETWORK=1
for arg in "$@"; do
 case "$arg" in
 --nvidia) NVIDIA=1;;
 --keep-network) NETWORK=0;;
 --apps) :;;
 *) echo "Usage: ./install.sh [--nvidia] [--keep-network]"; exit 2;;
 esac
done
[[ $EUID != 0 ]] || { echo "Run as your normal sudo user"; exit 1; }
. /etc/os-release
[[ $ID == ubuntu && $VERSION_ID == 26.04 ]] || { echo "Requires Ubuntu 26.04 LTS"; exit 1; }
if [[ $NETWORK == 1 && -n ${SSH_CONNECTION:-} ]]; then
 echo "Run locally or use --keep-network."
 exit 1
fi
sudo -v
for stage in base services drivers desktop configure applications networking; do
 echo "==> $stage"
 bash "$PROJECT/scripts/$stage.sh" || { echo "Failed at stage: $stage"; exit 1; }
done
echo "Installation complete. Reboot, select bspwm at LightDM and log in."
