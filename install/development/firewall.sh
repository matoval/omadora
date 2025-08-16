#!/bin/bash

# Fedora uses firewalld by default - ensure it's running
if ! systemctl is-active --quiet firewalld; then
  echo "Starting firewalld..."
  sudo systemctl enable --now firewalld
fi

# Configure firewall zones and rules using firewalld
echo "Configuring firewall rules..."

# Set default zone to public (restrictive by default)
sudo firewall-cmd --set-default-zone=public

# Allow LocalSend ports
sudo firewall-cmd --permanent --add-port=53317/tcp
sudo firewall-cmd --permanent --add-port=53317/udp

# Allow SSH (usually already enabled in public zone)
sudo firewall-cmd --permanent --add-service=ssh

# Configure Docker integration if Docker is installed
if command -v docker &>/dev/null; then
  # Add docker0 interface to trusted zone for container networking
  sudo firewall-cmd --permanent --zone=trusted --add-interface=docker0
  
  # Allow DNS for Docker containers
  sudo firewall-cmd --permanent --zone=trusted --add-service=dns
fi

# Reload firewall to apply all changes
sudo firewall-cmd --reload

echo "Firewall configuration completed"
echo "Active zones:"
sudo firewall-cmd --get-active-zones
