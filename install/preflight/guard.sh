#!/bin/bash

abort() {
  echo -e "\e[31mOmadora install requires: $1\e[0m"
  echo
  gum confirm "Proceed anyway on your own accord and without assistance?" || exit 1
}

# Must be a Fedora distro
[[ -f /etc/fedora-release ]] || abort "Vanilla Fedora"

# Must not be a Fedora derivative distro
for marker in /etc/nobara-release /etc/ultramarine-release; do
  [[ -f "$marker" ]] && abort "Vanilla Fedora"
done

# Must not be runnig as root
[ "$EUID" -eq 0 ] && abort "Running as user (not root)"

# Must be x86 only to fully work
[ "$(uname -m)" != "x86_64" ] && abort "x86_64 CPU"

# Must not have Gnome or KDE already install
rpm -q gnome-shell &>/dev/null && abort "Fresh + Vanilla Fedora"
rpm -q plasma-desktop &>/dev/null && abort "Fresh + Vanilla Fedora"

# Cleared all guards
echo "Guards: OK"
