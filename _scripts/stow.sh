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
    if [ ! -d "$DOTFILES_DIR/$pkg" ]; then
        echo "-> $pkg (skipped, directory not found)"
        continue
    fi

    # check if all symlinks already point to the right place
    already_linked=true
    while IFS= read -r -d '' file; do
        rel="${file#"$DOTFILES_DIR/$pkg/"}"
        target="$HOME/$rel"
        if [ ! -L "$target" ] || [ "$(readlink -f "$target")" != "$(readlink -f "$file")" ]; then
            already_linked=false
            break
        fi
    done < <(find "$DOTFILES_DIR/$pkg" -type f -print0)

    if $already_linked; then
        echo "-> $pkg (already linked)"
    else
        echo "-> $pkg"
        stow -d "$DOTFILES_DIR" -t "$HOME" -R "$pkg"
    fi
done
