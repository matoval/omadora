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

  # Remove old Typora repository if it exists (they moved their repo)
  if [ -f /etc/yum.repos.d/typora.repo ]; then
    sudo rm -f /etc/yum.repos.d/typora.repo
    echo "Removed old Typora repository configuration"
  fi

  # Typora from binary tarball (official recommendation for non-Ubuntu distributions)
  if ! command -v typora &>/dev/null; then
    echo "Installing Typora..."
    cd /tmp
    wget -q https://downloads.typora.io/linux/Typora-linux-x64.tar.gz || {
      echo "Failed to download Typora - skipping"
      cd ~
    }
    if [ -f "Typora-linux-x64.tar.gz" ]; then
      sudo tar -xzf Typora-linux-x64.tar.gz -C /opt/
      sudo ln -sf /opt/bin/typora /usr/local/bin/typora
      rm -f Typora-linux-x64.tar.gz
      echo "✅ Typora installed from binary"
    fi
    echo "Test cd"
    cd ~
  fi
fi

echo "Test source"
# Copy over Omadora applications
source ~/.local/share/omadora/bin/omarchy-refresh-applications || true
echo "Test end"
