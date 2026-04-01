#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OS=""
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS="$ID"
fi

case "$OS" in
  arch)
    bash "$SCRIPT_DIR/_scripts/arch/install.sh"
    bash "$SCRIPT_DIR/_scripts/arch/setup_zsh.sh"
    ;;
  ubuntu)
    bash "$SCRIPT_DIR/_scripts/ubuntu/install.sh"
    bash "$SCRIPT_DIR/_scripts/ubuntu/setup_zsh.sh"
    ;;
  *)
    echo "Unsupported OS: $OS"; exit 1
    ;;
esac

bash "$SCRIPT_DIR/_scripts/stow.sh"
