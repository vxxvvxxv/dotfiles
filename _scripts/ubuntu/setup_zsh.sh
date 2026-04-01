#!/usr/bin/env bash
set -euo pipefail

echo "=== Setting up zsh ==="

# --- install ---
echo "-> zsh"
if command -v zsh &>/dev/null; then
    echo "   already installed"
else
    sudo apt-get update
    sudo apt-get install -y zsh
fi

# --- set as default shell ---
ZSH_PATH="$(command -v zsh)"
if [ "$SHELL" = "$ZSH_PATH" ]; then
    echo "   already default shell"
else
    echo "-> setting zsh as default shell"
    chsh -s "$ZSH_PATH"
fi
