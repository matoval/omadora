#!/bin/bash

# Install standard packages from Fedora repos
sudo dnf install -y \
  wget curl unzip iputils hostname \
  fd-find fzf ripgrep bat jq xmlstarlet \
  wl-clipboard fastfetch btop \
  man-db tldr less whois plocate bash-completion \
  alacritty

# Install from COPR repositories with fallback
if sudo dnf copr enable -y alternateved/eza 2>/dev/null; then
  sudo dnf install -y eza || echo "⚠️ Failed to install eza from COPR"
else
  echo "⚠️ Failed to enable eza COPR - using traditional ls"
fi

if sudo dnf copr enable -y atim/zoxide 2>/dev/null; then
  sudo dnf install -y zoxide || echo "⚠️ Failed to install zoxide from COPR"
else
  echo "⚠️ Failed to enable zoxide COPR - directory jumping not available"
fi

# Build impala (WiFi TUI) from source if not available
if ! command -v impala &>/dev/null; then
  echo "Building impala (WiFi TUI) from source..."
  # Ensure Rust is installed
  if ! command -v cargo &>/dev/null; then
    echo "Installing Rust for impala build..."
    sudo dnf install -y cargo rust pkg-config
  fi
  
  # Build impala
  echo "Cloning and building impala..."
  cd /tmp
  rm -rf impala 2>/dev/null
  if git clone https://github.com/pythops/impala.git; then
    cd impala
    if cargo build --release; then
      sudo install -Dm755 target/release/impala /usr/local/bin/impala
      echo "✅ Impala (WiFi TUI) installed successfully"
    else
      echo "❌ Failed to build impala"
    fi
    cd ~
    rm -rf /tmp/impala
  else
    echo "❌ Failed to clone impala repository"
  fi
fi
