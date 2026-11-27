#!/usr/bin/env bash
set -Eeuo pipefail
cd -- "$(dirname -- "$0")"
export PROJECT="$PWD"
export NVIDIA=0 NETWORK=1
for arg in "$@"; do
 case "$arg" in
 --nvidia) NVIDIA=1;;
 --apps) echo 'All everyday apps are now installed by default.';;
 --keep-network) NETWORK=0;;
 *) echo "Usage: ./install.sh [--nvidia] [--keep-network]"; exit 2;;
 esac
done
[[ $EUID != 0 ]] || { echo "Run as your normal sudo user"; exit 1; }
. /etc/os-release
[[ $ID == ubuntu && $VERSION_ID == 26.04 ]] || { echo "Requires Ubuntu 26.04 LTS"; exit 1; }
echo "For a fresh Ubuntu Server installation only. Changes packages, login and optionally networking."
echo "Existing configuration files will be backed up. Snap removal is permanent."
read -rp "Continue? [y/N] " answer
[[ $answer == y || $answer == Y ]] || exit 0
sudo -v
if [[ $NETWORK == 1 && -n ${SSH_CONNECTION:-} ]]; then
 echo "Network conversion requires a local console. Use --keep-network to skip."
 exit 1
fi
mkdir -p "$HOME/.local/state/bspwm-desktop"
exec > >(tee -a "$HOME/.local/state/bspwm-desktop/install.log") 2>&1
trap 'echo "Installation failed at line $LINENO. Review install.log; do not reboot blindly."' ERR
for stage in base services drivers desktop configure applications networking; do
 echo "==> $stage"
 bash "$PROJECT/scripts/$stage.sh"
done
echo "Installation complete. Reboot manually, choose BSPWM at LightDM, then run desktop-doctor in a terminal."

