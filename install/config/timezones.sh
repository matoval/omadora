#!/bin/bash

if ! command -v tzupdate &>/dev/null; then
  # Use built-in automatic timezone detection in Fedora
  sudo dnf install -y geoclue2
  sudo systemctl enable --now geoclue
  # Automatically set timezone based on location
  sudo timedatectl set-timezone $(curl -s http://ip-api.com/line?fields=timezone 2>/dev/null || echo "UTC")
  sudo tee /etc/sudoers.d/omadora-tzupdate >/dev/null <<EOF
%wheel ALL=(root) NOPASSWD: /usr/bin/tzupdate, /usr/bin/timedatectl
EOF
  sudo chmod 0440 /etc/sudoers.d/omadora-tzupdate
fi
