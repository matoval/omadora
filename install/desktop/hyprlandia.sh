#!/bin/bash

# Enable Hyprland COPR repository
sudo dnf copr enable -y solopasha/hyprland

# Install Hyprland ecosystem from COPR
sudo dnf install -y \
  hyprland hyprshot hyprpicker hyprlock hypridle hyprsunset \
  xdg-desktop-portal-hyprland

# Install standard packages from Fedora repos
sudo dnf install -y \
  hyprpolkitagent libqalculate waybar mako swaybg \
  xdg-desktop-portal-gtk

# Enable SwayOSD COPR for audio/brightness OSD
sudo dnf copr enable -y erikreider/SwayOSD
sudo dnf install -y swayosd

# Build walker from source automatically
if ! command -v walker &>/dev/null; then
  echo "Building walker from source..."
  # Ensure Go and build tools are installed
  if ! command -v go &>/dev/null; then
    echo "Installing Go and build dependencies..."
    sudo dnf install -y golang git gtk4-devel gtk3-devel pkg-config
  fi
  
  # Build walker
  echo "Cloning and building walker..."
  cd /tmp
  rm -rf walker 2>/dev/null
  if git clone https://github.com/abenz1267/walker.git; then
    cd walker
    if go build -o walker .; then
      sudo install -Dm755 walker /usr/local/bin/walker
      echo "✅ Walker installed successfully"
    else
      echo "❌ Failed to build walker"
    fi
    cd ~
    rm -rf /tmp/walker
  else
    echo "❌ Failed to clone walker repository"
  fi
fi

# Note: hyprland-qtutils functionality not needed in Fedora setup
