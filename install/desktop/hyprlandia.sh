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

# Install SwayOSD with COPR fallback to source build
if sudo dnf copr enable -y erikreider/SwayOSD 2>/dev/null && sudo dnf install -y swayosd 2>/dev/null; then
  echo "✅ SwayOSD installed from COPR"
else
  echo "Building SwayOSD from source..."
  # Install dependencies for SwayOSD
  sudo dnf install -y gcc gcc-c++ meson ninja-build pkg-config gtk3-devel libpulse-devel
  cd /tmp
  rm -rf SwayOSD 2>/dev/null
  if git clone https://github.com/ErikReider/SwayOSD.git; then
    cd SwayOSD
    if meson setup build && ninja -C build; then
      sudo ninja -C build install
      echo "✅ SwayOSD installed from source"
    else
      echo "❌ Failed to build SwayOSD from source"
    fi
    cd ~
    rm -rf /tmp/SwayOSD
  else
    echo "❌ Failed to clone SwayOSD repository"
  fi
fi

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
