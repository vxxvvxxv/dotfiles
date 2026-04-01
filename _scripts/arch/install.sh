#!/usr/bin/env bash
set -euo pipefail

# yay
# sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# tools
yay -S neovim \
ttf-nerd-fonts-symbols \
ghostty \
foot \
keepassxc \
lazygit \
lazysql \
lazydocker \
lazyssh \
k9s \
fzf \
yazi \
go \
golangci-lint \
rustup \
python \
nodejs \
bottom \
gdu \
ripgrep \
tree-sitter \
git \
curl \
wget \
stow \
starship \
zoxide \
xclip

# env
yay -S hyprland \
hyprcwd-git \
hypridle \
hyprlock \
hyprpaper \
waybar \
wofi \
catppuccin-cursors-mocha \
swaync

# work
yay -S aws-cli-v2 \
aws-session-manager-plugin \
google-chrome \
slack-desktop \
postman-bin
