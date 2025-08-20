#!/bin/bash

echo "DEBUG: Starting mimetypes.sh"
update-desktop-database ~/.local/share/applications
echo "DEBUG: update-desktop-database completed"

# Open all images with imv
echo "DEBUG: Setting image mimetypes"
xdg-mime default imv.desktop image/png
xdg-mime default imv.desktop image/jpeg
xdg-mime default imv.desktop image/gif
xdg-mime default imv.desktop image/webp
xdg-mime default imv.desktop image/bmp
xdg-mime default imv.desktop image/tiff

# Open PDFs with the Document Viewer
echo "DEBUG: Setting PDF mimetypes"
xdg-mime default org.gnome.Evince.desktop application/pdf

# Use Chromium as the default browser
echo "DEBUG: Setting browser defaults"

# Determine which chromium desktop file to use
if [ -f ~/.local/share/applications/chromium.desktop ]; then
  CHROMIUM_DESKTOP="chromium.desktop"
elif [ -f /usr/share/applications/chromium.desktop ]; then
  CHROMIUM_DESKTOP="chromium.desktop"
elif [ -f /usr/share/applications/chromium-browser.desktop ]; then
  CHROMIUM_DESKTOP="chromium-browser.desktop"
else
  echo "WARNING: No chromium desktop file found, skipping browser defaults"
  CHROMIUM_DESKTOP=""
fi

if [ -n "$CHROMIUM_DESKTOP" ]; then
  echo "DEBUG: Using $CHROMIUM_DESKTOP"
  echo "DEBUG: Setting default web browser"
  xdg-settings set default-web-browser "$CHROMIUM_DESKTOP" || true
  echo "DEBUG: Setting http handler"
  xdg-mime default "$CHROMIUM_DESKTOP" x-scheme-handler/http
  echo "DEBUG: Setting https handler"
  xdg-mime default "$CHROMIUM_DESKTOP" x-scheme-handler/https
  echo "DEBUG: Browser defaults completed"
fi

# Open video files with mpv
echo "DEBUG: Setting video mimetypes"
xdg-mime default mpv.desktop video/mp4
xdg-mime default mpv.desktop video/x-msvideo
xdg-mime default mpv.desktop video/x-matroska
xdg-mime default mpv.desktop video/x-flv
xdg-mime default mpv.desktop video/x-ms-wmv
xdg-mime default mpv.desktop video/mpeg
xdg-mime default mpv.desktop video/ogg
xdg-mime default mpv.desktop video/webm
xdg-mime default mpv.desktop video/quicktime
xdg-mime default mpv.desktop video/3gpp
xdg-mime default mpv.desktop video/3gpp2
xdg-mime default mpv.desktop video/x-ms-asf
xdg-mime default mpv.desktop video/x-ogm+ogg
xdg-mime default mpv.desktop video/x-theora+ogg
xdg-mime default mpv.desktop application/ogg

echo "DEBUG: mimetypes.sh completed successfully"
