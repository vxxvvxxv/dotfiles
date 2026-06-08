# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Stow-based dotfiles for Linux (Arch and Ubuntu). Each top-level directory (except `_scripts`) is a stow package that gets symlinked into `$HOME`.

## Key Commands

```bash
# Full setup: install packages + set shell + symlink configs
./init.sh

# Just re-link configs (no installs)
bash _scripts/stow.sh

# OS-specific install only
bash _scripts/arch/install.sh
bash _scripts/ubuntu/install.sh
```

## Architecture

- **`init.sh`** — Entry point. Detects OS via `/etc/os-release`, runs the matching `_scripts/<os>/install.sh` and `setup_zsh.sh`, then runs `stow.sh`.
- **`_scripts/stow.sh`** — Iterates over a hardcoded `PACKAGES` array, checks if symlinks are already correct, and runs `stow -R` only when needed.
- **`_scripts/arch/install.sh`** — Single `yay -S` call for all packages.
- **`_scripts/ubuntu/install.sh`** — Per-tool sections with idempotent `command -v` checks and architecture detection (`amd64`/`arm64`). Tools come from apt, GitHub releases, curl installers, or snap.

## Adding a New Tool

- **Arch**: Add the package name to the appropriate `yay -S` block in `_scripts/arch/install.sh`.
- **Ubuntu**: Add a new section following the existing pattern: echo header, `command -v` guard, download/install, cleanup temp files. Use the `$ARCH`/`$GOARCH` variables for architecture-specific URLs.

## Adding a New Stow Package

1. Create `<package>/.config/<tool>/` (or whatever path under `$HOME` the config belongs to).
2. Add the package name to the `PACKAGES` array in `_scripts/stow.sh`.
