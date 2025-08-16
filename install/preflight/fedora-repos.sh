#!/bin/bash

# Fedora Repository and Development Tools Setup
# Equivalent to Arch's aur.sh for setting up additional package sources

# Only add extra repositories if architecture is x86_64 for compatibility
if [[ "$(uname -m)" == "x86_64" ]]; then
  
  # Install RPM Fusion repositories (equivalent to Chaotic-AUR)
  # These provide multimedia codecs, proprietary software, and additional packages
  if ! rpm -q rpmfusion-free-release >/dev/null 2>&1; then
    echo "Setting up RPM Fusion repositories..."
    
    # Install RPM Fusion Free repository
    if sudo dnf install -y \
      "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
      "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"; then
      echo "RPM Fusion repositories installed successfully"
    else
      echo "Failed to install RPM Fusion repositories"
    fi
  else
    echo "RPM Fusion repositories already installed"
  fi

  # Enable essential COPR repositories for modern development tools
  # COPR is Fedora's equivalent to AUR for community packages
  
  echo "Enabling COPR repositories..."
  
  # Function to enable COPR with error handling
  enable_copr() {
    local copr_name="$1"
    local description="$2"
    
    if ! dnf copr list enabled 2>/dev/null | grep -q "$copr_name"; then
      echo "Enabling COPR: $description..."
      if sudo dnf copr enable -y "$copr_name" 2>/dev/null; then
        echo "✅ $description COPR enabled"
      else
        echo "⚠️  Failed to enable $description COPR - some packages may not be available"
        return 1
      fi
    else
      echo "✅ $description COPR already enabled"
    fi
    return 0
  }
  
  # Enable COPR repositories with error handling
  enable_copr "solopasha/hyprland" "Hyprland ecosystem" || true
  enable_copr "atim/lazygit" "Lazygit" || true
  enable_copr "alternateved/eza" "Eza (modern ls)" || true
  enable_copr "wef/mise" "Mise runtime manager" || true

  # Refresh repository metadata after adding new repos
  sudo dnf makecache --refresh

  echo "COPR repositories enabled successfully"
fi

# Install development tools (equivalent to Arch's base-devel group)
echo "Installing development tools..."
# Use correct Fedora 42 group names
sudo dnf install -y "@development-tools" "@c-development"

# Install essential build dependencies not covered by groups
echo "Installing additional build tools..."
sudo dnf install -y --skip-broken \
  git \
  cmake \
  ninja-build \
  meson \
  pkg-config \
  curl \
  wget

# Install Flatpak support for GUI applications (equivalent to AUR GUI packages)
if ! command -v flatpak &>/dev/null; then
  echo "Installing Flatpak support..."
  sudo dnf install -y flatpak
  
  # Add Flathub repository for GUI applications
  if ! flatpak remotes | grep -q flathub; then
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  fi
else
  echo "Flatpak already installed"
fi

# Configure DNF for better user experience (equivalent to pacman aesthetics)
echo "Optimizing DNF configuration..."

# Auto-confirm installations (like pacman --noconfirm)
if ! grep -q "defaultyes=True" /etc/dnf/dnf.conf; then
  echo 'defaultyes=True' | sudo tee -a /etc/dnf/dnf.conf >/dev/null
fi

# Enable colored output (like pacman Color option)
if ! grep -q "color=always" /etc/dnf/dnf.conf; then
  echo 'color=always' | sudo tee -a /etc/dnf/dnf.conf >/dev/null
fi

# Enable faster parallel downloads (better than pacman's single-threaded downloads)
if ! grep -q "max_parallel_downloads" /etc/dnf/dnf.conf; then
  echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf >/dev/null
fi

# Enable delta RPMs to save bandwidth
if ! grep -q "deltarpm=true" /etc/dnf/dnf.conf; then
  echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf >/dev/null
fi

# Keep cache for faster reinstalls (opposite of Arch's cache cleaning approach)
if ! grep -q "keepcache=True" /etc/dnf/dnf.conf; then
  echo 'keepcache=True' | sudo tee -a /etc/dnf/dnf.conf >/dev/null
fi

echo "DNF configuration optimized for better performance and UX"
echo "Repository setup complete!"