#!/usr/bin/env bash
set -euo pipefail
if [[ $NVIDIA == 1 ]]; then
 sudo apt install -y ubuntu-drivers-common
 sudo ubuntu-drivers install --recommended
 echo "Complete Secure Boot MOK enrolment on reboot if prompted."
fi

