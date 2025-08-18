#!/bin/bash

sudo dnf install -y fontawesome-fonts cascadia-code-fonts google-noto-sans-fonts google-noto-emoji-fonts

# Install iA Writer font from source
if [ ! -f "/usr/local/share/fonts/iA Writer/iAWriterMonoS-Regular.ttf" ]; then
  echo "Installing iA Writer fonts..."
  # Ensure wget and unzip are available
  sudo dnf install -y wget unzip
  cd /tmp
  # Clean up any existing files first
  [ -d "iA-Fonts-master" ] && rm -rf iA-Fonts-master
  [ -f "master.zip" ] && rm -f master.zip
  wget -q https://github.com/iaolo/iA-Fonts/archive/master.zip
  unzip -q -o master.zip
  sudo mkdir -p "/usr/local/share/fonts/iA Writer"
  # Copy fonts from all iA Writer font families
  for font_family in "iA Writer Duo" "iA Writer Mono" "iA Writer Quattro"; do
    if [ -d "iA-Fonts-master/$font_family/Static" ]; then
      sudo cp "iA-Fonts-master/$font_family/Static"/*.ttf "/usr/local/share/fonts/iA Writer/" 2>/dev/null || true
    fi
    if [ -d "iA-Fonts-master/$font_family/Variable" ]; then
      sudo cp "iA-Fonts-master/$font_family/Variable"/*.ttf "/usr/local/share/fonts/iA Writer/" 2>/dev/null || true
    fi
  done
  sudo fc-cache -f
  rm -rf iA-Fonts-master master.zip
  cd ~
fi

if [ -z "$OMADORA_BARE" ]; then
  sudo dnf install -y jetbrains-mono-fonts google-noto-cjk-fonts
fi
