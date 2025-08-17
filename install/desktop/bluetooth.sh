#!/bin/bash

# Install bluetooth controls
sudo dnf install -y blueman

# Turn on bluetooth by default
sudo systemctl enable --now bluetooth.service
