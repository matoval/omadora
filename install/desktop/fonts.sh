#!/bin/bash

sudo dnf install -y fontawesome-fonts cascadia-code-fonts google-noto-fonts google-noto-emoji-fonts

# Install iA Writer font from source
if [ ! -f "/usr/local/share/fonts/iA Writer/iAWriterMonoS-Regular.ttf" ]; then
  echo "Installing iA Writer fonts..."
  # Ensure wget and unzip are available
  sudo dnf install -y wget unzip
  cd /tmp
  wget -q https://github.com/iaolo/iA-Fonts/archive/master.zip
  unzip -q master.zip
  sudo mkdir -p /usr/local/share/fonts/"iA Writer"
  sudo cp "iA-Fonts-master/iA Writer"/* /usr/local/share/fonts/"iA Writer"/
  sudo fc-cache -f
  rm -rf iA-Fonts-master master.zip
  cd ~
fi

if [ -z "$OMADORA_BARE" ]; then
  sudo dnf install -y jetbrains-mono-fonts google-noto-cjk-fonts
fi
