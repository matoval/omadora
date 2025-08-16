#!/bin/bash

if [ -z "$OMADORA_BARE" ]; then
  omadora-webapp-install "HEY" https://app.hey.com https://www.hey.com/assets/images/general/hey.png
  omadora-webapp-install "Basecamp" https://launchpad.37signals.com https://basecamp.com/assets/images/general/basecamp.png
  omadora-webapp-install "WhatsApp" https://web.whatsapp.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/whatsapp.png
  omadora-webapp-install "Google Photos" https://photos.google.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-photos.png
  omadora-webapp-install "Google Contacts" https://contacts.google.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-contacts.png
  omadora-webapp-install "Google Messages" https://messages.google.com/web/conversations https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-messages.png
  omadora-webapp-install "ChatGPT" https://chatgpt.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/chatgpt.png
  omadora-webapp-install "YouTube" https://youtube.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/youtube.png
  omadora-webapp-install "GitHub" https://github.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/github-light.png
  omadora-webapp-install "X" https://x.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/x-light.png
  omadora-webapp-install "Figma" https://figma.com/ https://www.veryicon.com/download/png/application/app-icon-7/figma-1?s=256
  omadora-webapp-install "Discord" https://discord.com/channels/@me https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/discord.png
fi
