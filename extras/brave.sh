#!/usr/bin/env bash
set -euo pipefail
[[ $EUID != 0 ]] || { echo "Run as your normal sudo user"; exit 1; }
# Optional vendor repository; never called by the desktop installer.
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
echo "Optional Brave installation. Official instructions: https://brave.com/linux/"
curl -fsSL 'https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg' -o "$tmp/brave-browser.gpg"
actual=$(gpg --batch --with-colons --show-keys "$tmp/brave-browser.gpg" | awk -F: '$1=="pub"{p=1;next} p && $1=="fpr"{print $10;p=0}' | sort -u)
[[ -n "$actual" ]] || { echo "No primary signing key found"; exit 1; }
echo "Downloaded primary fingerprints:"
printf '%s\n' "$actual"
echo "Independently verify every primary fingerprint against official vendor information."
read -rp "Enter verified full fingerprints (space-separated, no spaces within fingerprints): " expected
expected=$(printf '%s\n' "$expected" | tr ' ' '\n' | tr '[:lower:]' '[:upper:]' | sed '/^$/d' | sort -u)
[[ "$expected" == "$actual" ]] || { echo "Fingerprint mismatch; nothing installed."; exit 1; }
sudo install -d -m 0755 /etc/apt/keyrings
sudo install -m 0644 "$tmp/brave-browser.gpg" /etc/apt/keyrings/brave-browser.gpg
printf 'Types: deb\nURIs: https://brave-browser-apt-release.s3.brave.com/\nSuites: stable\nComponents: main\nSigned-By: /etc/apt/keyrings/brave-browser.gpg\n' | sudo tee /etc/apt/sources.list.d/brave-browser-release.sources >/dev/null
sudo apt update
candidate=$(apt-cache policy brave-browser | awk '/Candidate:/ {print $2}')
[[ -n "$candidate" && "$candidate" != "(none)" ]] || { echo "No package candidate: brave-browser"; exit 1; }
sudo apt install -y brave-browser
echo "Brave installed. It updates through APT; existing desktop defaults are unchanged."
