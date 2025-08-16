#!/bin/bash

# Install standard desktop packages from Fedora repos
sudo dnf install -y \
  brightnessctl playerctl pamixer wireplumber \
  fcitx5 fcitx5-gtk fcitx5-qt \
  nautilus sushi ffmpegthumbnailer gvfs-mtp \
  slurp \
  mpv evince imv \
  chromium

# Install satty (screenshot annotator) with COPR fallback to source build
if sudo dnf copr enable -y atim/satty 2>/dev/null && sudo dnf install -y satty 2>/dev/null; then
  echo "✅ Satty installed from COPR"
else
  echo "Building satty from source..."
  if ! command -v cargo &>/dev/null; then
    echo "Installing Rust for satty build..."
    sudo dnf install -y cargo rust
  fi
  # Install dependencies for satty
  sudo dnf install -y gtk4-devel libadwaita-devel libepoxy-devel pkg-config
  cd /tmp
  rm -rf satty 2>/dev/null
  if git clone https://github.com/gabm/Satty.git satty; then
    cd satty
    if cargo build --release; then
      sudo install -Dm755 target/release/satty /usr/local/bin/satty
      echo "✅ Satty (screenshot annotator) installed from source"
    else
      echo "❌ Failed to build satty from source"
    fi
    cd ~
    rm -rf /tmp/satty
  else
    echo "❌ Failed to clone satty repository"
  fi
fi

# Add screen recorder based on GPU
if lspci | grep -qi 'nvidia'; then
  sudo dnf install -y wf-recorder
else
  # Build wl-screenrec from source automatically
  if ! command -v wl-screenrec &>/dev/null; then
    echo "Building wl-screenrec from source..."
    # Ensure Rust and build dependencies are installed
    if ! command -v cargo &>/dev/null; then
      echo "Installing Rust and build dependencies..."
      sudo dnf install -y cargo rust git gcc pkg-config wayland-devel wayland-protocols-devel
    fi
    
    # Build wl-screenrec
    echo "Cloning and building wl-screenrec..."
    cd /tmp
    rm -rf wl-screenrec 2>/dev/null
    if git clone https://github.com/russelltg/wl-screenrec.git; then
      cd wl-screenrec
      if cargo build --release; then
        sudo install -Dm755 target/release/wl-screenrec /usr/local/bin/wl-screenrec
        echo "✅ wl-screenrec installed successfully"
      else
        echo "❌ Failed to build wl-screenrec"
      fi
      cd ~
      rm -rf /tmp/wl-screenrec
    else
      echo "❌ Failed to clone wl-screenrec repository"
    fi
  fi
fi
