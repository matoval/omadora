#!/bin/bash

# Install standard development tools from Fedora repos
sudo dnf install -y \
  cargo rust clang llvm golang \
  ImageMagick \
  mariadb-connector-c-devel libpq-devel \
  gh

# Install from COPR repositories
sudo dnf copr enable -y wef/mise
sudo dnf install -y mise

sudo dnf copr enable -y atim/lazygit
sudo dnf install -y lazygit

# Build lazydocker from source automatically
if ! command -v lazydocker &>/dev/null; then
  echo "Building lazydocker from source..."
  # Ensure Go and build tools are installed
  if ! command -v go &>/dev/null; then
    echo "Installing Go and build dependencies..."
    sudo dnf install -y golang git
  fi
  
  # Build lazydocker
  echo "Cloning and building lazydocker..."
  cd /tmp
  rm -rf lazydocker 2>/dev/null
  if git clone https://github.com/jesseduffield/lazydocker.git; then
    cd lazydocker
    if go build -o lazydocker .; then
      sudo install -Dm755 lazydocker /usr/local/bin/lazydocker
      echo "✅ Lazydocker installed successfully"
    else
      echo "❌ Failed to build lazydocker"
    fi
    cd ~
    rm -rf /tmp/lazydocker
  else
    echo "❌ Failed to clone lazydocker repository"
  fi
fi
