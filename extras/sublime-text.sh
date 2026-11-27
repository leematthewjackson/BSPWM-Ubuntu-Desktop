#!/usr/bin/env bash
set -euo pipefail
[[ $EUID != 0 ]] || { echo "Run as your normal sudo user"; exit 1; }
# Optional vendor repository; never called by the desktop installer.
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
echo "Optional Sublime Text installation. Official instructions: https://www.sublimetext.com/docs/linux_repositories.html"
curl -fsSL 'https://download.sublimetext.com/sublimehq-pub.gpg' -o "$tmp/sublimehq-pub.asc"
actual=$(gpg --batch --with-colons --show-keys "$tmp/sublimehq-pub.asc" | awk -F: '$1=="pub"{p=1;next} p && $1=="fpr"{print $10;p=0}' | sort -u)
[[ -n "$actual" ]] || { echo "No primary signing key found"; exit 1; }
echo "Downloaded primary fingerprints:"
printf '%s\n' "$actual"
echo "Independently verify every primary fingerprint against official vendor information."
read -rp "Enter verified full fingerprints (space-separated, no spaces within fingerprints): " expected
expected=$(printf '%s\n' "$expected" | tr ' ' '\n' | tr '[:lower:]' '[:upper:]' | sed '/^$/d' | sort -u)
[[ "$expected" == "$actual" ]] || { echo "Fingerprint mismatch; nothing installed."; exit 1; }
sudo install -d -m 0755 /etc/apt/keyrings
sudo install -m 0644 "$tmp/sublimehq-pub.asc" /etc/apt/keyrings/sublimehq-pub.asc
printf 'Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc\n' | sudo tee /etc/apt/sources.list.d/sublime-text.sources >/dev/null
sudo apt update
candidate=$(apt-cache policy sublime-text | awk '/Candidate:/ {print $2}')
[[ -n "$candidate" && "$candidate" != "(none)" ]] || { echo "No package candidate: sublime-text"; exit 1; }
sudo apt install -y sublime-text
echo "Sublime Text installed. It updates through APT; existing desktop defaults are unchanged."
