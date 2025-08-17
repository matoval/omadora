#!/bin/bash

if [ -z "$OMADORA_BARE" ]; then
  # Install standard packages from Fedora repos
  sudo dnf install -y \
    gnome-calculator gnome-keyring \
    libreoffice obs-studio kdenlive \
    xournalpp pinta

  # Install GUI applications via Flatpak (user-level)
  echo "Installing GUI applications via Flatpak..."
  # Add flathub repository for user if not already added
  flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  # Install applications for user only
  flatpak install --user -y flathub \
    org.signal.Signal \
    md.obsidian.Obsidian \
    org.localsend.localsend_app \
    com.spotify.Client \
    us.zoom.Zoom

  # Install proprietary software automatically
  
  # 1Password from official Fedora repository
  if ! rpm -q 1password &>/dev/null; then
    echo "Installing 1Password..."
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\ngpgkey=https://downloads.1password.com/linux/keys/1password.asc" > /etc/yum.repos.d/1password.repo'
    sudo dnf install -y 1password 1password-cli || echo "Failed to install 1Password - continuing"
  fi
  
  # Typora from official repository (try both URLs)
  if ! rpm -q typora &>/dev/null; then
    echo "Installing Typora..."
    # Try the alternative repository URL first
    if sudo rpm --import https://typora.io/linux/public-key.asc 2>/dev/null; then
      echo -e "[typora]\nname=typora\nbaseurl=https://download.typora.io/linux/rpm/\nenabled=1\ngpgcheck=1\ngpgkey=https://typora.io/linux/public-key.asc" | sudo tee /etc/yum.repos.d/typora.repo
      sudo dnf install -y typora 2>/dev/null || {
        echo "Primary Typora repo failed, trying alternative..."
        echo -e "[typora]\nname=typora\nbaseurl=https://typora.io/linux/rpm/\nenabled=1\ngpgcheck=1\ngpgkey=https://typora.io/linux/public-key.asc" | sudo tee /etc/yum.repos.d/typora.repo
        sudo dnf install -y typora 2>/dev/null || echo "Failed to install Typora - continuing"
      }
    else
      echo "Failed to import Typora key - skipping Typora installation"
    fi
  fi
fi

# Copy over Omadora applications
source omarchy-refresh-applications || true
