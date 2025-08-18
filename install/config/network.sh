#!/bin/bash

# Install iwd explicitly if it wasn't included in archinstall
# This can happen if archinstall used ethernet
if ! command -v iwctl &>/dev/null; then
  sudo dnf install -y iwd
  sudo systemctl enable --now iwd.service
fi

# Skip network timeout handling for Fedora (uses NetworkManager by default)
