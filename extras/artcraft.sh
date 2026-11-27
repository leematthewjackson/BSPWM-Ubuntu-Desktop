#!/usr/bin/env bash
set -euo pipefail
[[ $EUID != 0 ]] || { echo "Run as your normal sudo user"; exit 1; }
# Optional native packages for MCP-compatible CLIs, from the Mint setup.
apps=(anicraft deckcraft effectcraft figcraft filmcraft gridcraft pdfcraft photocraft soundcraft vectorcraft wordcraft)
fingerprint=2B76741B414AAD6CD33E631213A005C0B9D7C3ED
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fsSL https://getartcraft.com/keys/artcraft.gpg -o "$tmp/artcraft.gpg"
actual=$(gpg --batch --with-colons --show-keys "$tmp/artcraft.gpg" | awk -F: '$1=="pub"{p=1;next} p && $1=="fpr"{print $10;p=0}')
[[ "$actual" == "$fingerprint" ]] || { echo "Unexpected signing key; verify with vendor before changing fingerprint."; exit 1; }
echo "Install the ArtCraft vendor repository and all eleven native applications?"
read -rp "Continue? [y/N] " answer
[[ "$answer" == y || "$answer" == Y ]] || exit 0
sudo install -d -m 0755 /etc/apt/keyrings
sudo install -m 0644 "$tmp/artcraft.gpg" /etc/apt/keyrings/artcraft.gpg
# Explicit source from vendor instructions; inspect source before enabling.
curl -fsSL https://getartcraft.com/apt/artcraft.sources -o "$tmp/artcraft.sources"
cat "$tmp/artcraft.sources"
read -rp "Confirm vendor source shown above? [y/N] " answer
[[ "$answer" == y || "$answer" == Y ]] || exit 0
sudo install -m 0644 "$tmp/artcraft.sources" /etc/apt/sources.list.d/artcraft.sources
sudo apt update
for pkg in "${apps[@]}"; do
 candidate=$(apt-cache policy "$pkg" | awk '/Candidate:/ {print $2}')
 [[ -n "$candidate" && "$candidate" != "(none)" ]] || { echo "No candidate: $pkg"; exit 1; }
done
sudo apt install -y "${apps[@]}"
echo "ArtCraft installed. MCP setup and any office file association changes are separate."
