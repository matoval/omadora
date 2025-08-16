#!/bin/bash

if ! command -v nvim &>/dev/null; then
  sudo dnf install -y neovim luarocks nodejs npm
  # Install tree-sitter-cli via npm
  sudo npm install -g tree-sitter-cli

  # Install LazyVim
  rm -rf ~/.config/nvim
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  # Determine source path
  if [ -d "./config/nvim" ]; then
    cp -R ./config/nvim/* ~/.config/nvim/
  else
    cp -R ~/.local/share/omadora/config/nvim/* ~/.config/nvim/
  fi
  rm -rf ~/.config/nvim/.git
  echo "vim.opt.relativenumber = false" >>~/.config/nvim/lua/config/options.lua
fi
