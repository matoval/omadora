#!/bin/bash

sudo dnf install -y fontawesome-fonts cascadia-code-fonts google-noto-sans-fonts google-noto-emoji-fonts

# Install iA Writer font from source
if [ ! -f "/usr/local/share/fonts/iA Writer/iAWriterMonoS-Regular.ttf" ]; then
  echo "Installing iA Writer fonts..."
  # Ensure wget and unzip are available
  sudo dnf install -y wget unzip
  cd /tmp
  wget -q https://github.com/iaolo/iA-Fonts/archive/master.zip
  unzip -q master.zip
  sudo mkdir -p "/usr/local/share/fonts/iA Writer"
  # Use find to properly handle paths with spaces
  find "iA-Fonts-master" -name "*.ttf" -o -name "*.otf" | while read -r font; do
    sudo cp "$font" "/usr/local/share/fonts/iA Writer/"
  done
  sudo fc-cache -f
  rm -rf iA-Fonts-master master.zip
  cd ~
fi

if [ -z "$OMADORA_BARE" ]; then
  sudo dnf install -y jetbrains-mono-fonts google-noto-cjk-fonts
fi
