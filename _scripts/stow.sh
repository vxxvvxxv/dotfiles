#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PACKAGES=(
  backgrounds
  foot
  hyprcwd
  hypridle
  hyprland
  hyprlock
  hyprpaper
  nvim
  waybar
  wofi
  zsh
)

echo "=== Applying stow ==="

for pkg in "${PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$pkg" ]; then
        echo "-> $pkg"
        stow -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
    else
        echo "-> $pkg (skipped, directory not found)"
    fi
done
