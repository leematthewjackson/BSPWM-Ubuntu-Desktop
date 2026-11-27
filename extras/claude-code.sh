#!/usr/bin/env bash
set -euo pipefail
[[ $EUID != 0 ]] || { echo "Run as your normal user"; exit 1; }
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fsSL https://claude.ai/install.sh -o "$tmp/install.sh"
echo "Optional Claude Code installer downloaded from claude.ai."
echo "Inspect the installer below before approving execution. This is vendor code, not part of the desktop."
cat "$tmp/install.sh"
read -rp "Execute vendor installer as your user? [y/N] " answer
[[ "$answer" == y || "$answer" == Y ]] || exit 0
bash "$tmp/install.sh"
echo "Log out and back in if needed, then run claude to sign in."
