#!/bin/bash

# Always use installed location
CONFIG_SOURCE=~/.local/share/omadora/config
DEFAULT_SOURCE=~/.local/share/omadora/default

# Ensure .config directory exists and copy over Omadora configs
mkdir -p ~/.config
cp -R "$CONFIG_SOURCE"/* ~/.config/

# Use default bashrc from Omadora
cp "$DEFAULT_SOURCE/bashrc" ~/.bashrc

# Ensure application directory exists for update-desktop-database
mkdir -p ~/.local/share/applications

# If bare install, allow a way for its exclusions to not get added in updates
if [ -n "$OMADORA_BARE" ]; then
  mkdir -p ~/.local/state/omadora
  touch ~/.local/state/omadora/bare.mode
fi

# Setup GPG configuration with multiple keyservers for better reliability
sudo mkdir -p /etc/gnupg
sudo cp "$DEFAULT_SOURCE/gpg/dirmngr.conf" /etc/gnupg/
sudo chmod 644 /etc/gnupg/dirmngr.conf
sudo gpgconf --kill dirmngr || true
sudo gpgconf --launch dirmngr || true

# Increase lockout limit to 10 and decrease timeout to 2 minutes
sudo sed -i 's|^\(auth\s\+required\s\+pam_faillock.so\)\s\+preauth.*$|\1 preauth silent deny=10 unlock_time=120|' "/etc/pam.d/system-auth"
sudo sed -i 's|^\(auth\s\+\[default=die\]\s\+pam_faillock.so\)\s\+authfail.*$|\1 authfail deny=10 unlock_time=120|' "/etc/pam.d/system-auth"

# Set Cloudflare as primary DNS (with Google as backup)
sudo cp "$DEFAULT_SOURCE/systemd/resolved.conf" /etc/systemd/

# Solve common flakiness with SSH
echo "net.ipv4.tcp_mtu_probing=1" | sudo tee -a /etc/sysctl.d/99-sysctl.conf

# Set common git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global pull.rebase true
git config --global init.defaultBranch master

# Set identification from install inputs
if [[ -n "${OMADORA_USER_NAME//[[:space:]]/}" ]]; then
  git config --global user.name "$OMADORA_USER_NAME"
fi

if [[ -n "${OMADORA_USER_EMAIL//[[:space:]]/}" ]]; then
  git config --global user.email "$OMADORA_USER_EMAIL"
fi

# Set default XCompose that is triggered with CapsLock
cat > ~/.XCompose <<EOF
include "%H/$DEFAULT_SOURCE/xcompose"

# Identification
<Multi_key> <space> <n> : "$OMADORA_USER_NAME"
<Multi_key> <space> <e> : "$OMADORA_USER_EMAIL"
EOF
