#!/usr/bin/env bash
set -euo pipefail
# Vendor URLs from the owner's Mint setup. Review key fingerprints against
# independent vendor documentation before accepting; no silent key trust.
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg -o "$tmp/brave.gpg"
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg -o "$tmp/sublime.asc"
for vendor in brave sublime; do
 case "$vendor" in brave) key="$tmp/brave.gpg";; sublime) key="$tmp/sublime.asc";; esac
 echo "Review $vendor signing key against its official documentation:"
 gpg --show-keys --with-fingerprint "$key"
 read -rp "Have you independently verified the $vendor key? [y/N] " answer
 [[ "$answer" == y || "$answer" == Y ]] || { echo "Vendor installation stopped. No keys installed."; exit 1; }
done
sudo install -d -m 0755 /etc/apt/keyrings
sudo install -m 0644 "$tmp/brave.gpg" /etc/apt/keyrings/brave-browser.gpg
sudo install -m 0644 "$tmp/sublime.asc" /etc/apt/keyrings/sublimehq-pub.asc
printf 'Types: deb\nURIs: https://brave-browser-apt-release.s3.brave.com/\nSuites: stable\nComponents: main\nSigned-By: /etc/apt/keyrings/brave-browser.gpg\n' | sudo tee /etc/apt/sources.list.d/brave-browser-release.sources >/dev/null
printf 'Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc\n' | sudo tee /etc/apt/sources.list.d/sublime-text.sources >/dev/null
sudo apt update
for pkg in brave-browser sublime-text; do
 candidate=$(apt-cache policy "$pkg" | awk '/Candidate:/ {print $2}')
 [[ -n "$candidate" && "$candidate" != "(none)" ]] || { echo "No candidate: $pkg"; exit 1; }
done
sudo apt install -y brave-browser sublime-text
