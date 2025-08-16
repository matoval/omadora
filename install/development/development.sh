#!/bin/bash

# Install standard development tools from Fedora repos
sudo dnf install -y \
  cargo rust clang llvm golang \
  ImageMagick \
  mariadb-connector-c-devel libpq-devel \
  gh

# Install mise (runtime manager) with COPR fallback to source build
if sudo dnf copr enable -y wef/mise 2>/dev/null && sudo dnf install -y mise 2>/dev/null; then
  echo "✅ Mise installed from COPR"
else
  echo "Building mise from source..."
  if ! command -v cargo &>/dev/null; then
    echo "Installing Rust for mise build..."
    sudo dnf install -y cargo rust
  fi
  cd /tmp
  rm -rf mise 2>/dev/null
  if git clone https://github.com/jdx/mise.git; then
    cd mise
    if cargo build --release; then
      sudo install -Dm755 target/release/mise /usr/local/bin/mise
      echo "✅ Mise (runtime manager) installed from source"
    else
      echo "❌ Failed to build mise from source"
    fi
    cd ~
    rm -rf /tmp/mise
  else
    echo "❌ Failed to clone mise repository"
  fi
fi

# Install lazygit with COPR fallback to source build
if sudo dnf copr enable -y atim/lazygit 2>/dev/null && sudo dnf install -y lazygit 2>/dev/null; then
  echo "✅ Lazygit installed from COPR"
else
  echo "Building lazygit from source..."
  if ! command -v go &>/dev/null; then
    echo "Installing Go for lazygit build..."
    sudo dnf install -y golang
  fi
  cd /tmp
  rm -rf lazygit 2>/dev/null
  if git clone https://github.com/jesseduffield/lazygit.git; then
    cd lazygit
    if go build -o lazygit .; then
      sudo install -Dm755 lazygit /usr/local/bin/lazygit
      echo "✅ Lazygit installed from source"
    else
      echo "❌ Failed to build lazygit from source"
    fi
    cd ~
    rm -rf /tmp/lazygit
  else
    echo "❌ Failed to clone lazygit repository"
  fi
fi

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
