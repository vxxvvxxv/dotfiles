#!/usr/bin/env bash
set -euo pipefail

ARCH=$(dpkg --print-architecture)  # amd64 | arm64
case "$ARCH" in
    amd64) GOARCH="amd64"; LAZYGIT_ARCH="linux_x86_64"; NVIM_ARCH="x86_64"; LAZYDOCKER_ARCH="Linux_x86_64"; K9S_ARCH="Linux_amd64"; AWS_ARCH="x86_64"; YAZI_ARCH="x86_64-unknown-linux-gnu"; VIMONGO_ARCH="Linux_x86_64" ;;
    arm64) GOARCH="arm64"; LAZYGIT_ARCH="linux_arm64"; NVIM_ARCH="arm64"; LAZYDOCKER_ARCH="Linux_arm64"; K9S_ARCH="Linux_arm64"; AWS_ARCH="aarch64"; YAZI_ARCH="aarch64-unknown-linux-gnu"; VIMONGO_ARCH="Linux_arm64" ;;
    *)     echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

echo "=== Installing packages (arch: $ARCH) ==="

# --- apt packages ---
APT_PACKAGES=(
  git curl wget unzip stow build-essential
  python3 python3-pip python3-venv
  nodejs npm golang-go
  fzf ripgrep foot keepassxc waybar wofi xclip
)
MISSING=()
for pkg in "${APT_PACKAGES[@]}"; do
    if ! dpkg -s "$pkg" &>/dev/null; then
        MISSING+=("$pkg")
    fi
done
if [ ${#MISSING[@]} -gt 0 ]; then
    echo "-> apt packages: installing ${MISSING[*]}"
    sudo apt-get update
    sudo apt-get install -y "${MISSING[@]}"
else
    echo "-> apt packages: all already installed"
fi

export PATH="$HOME/go/bin:$PATH"

# --- neovim ---
echo "-> neovim"
if command -v nvim &>/dev/null && [[ "$(nvim --version | head -1 | grep -oP '\d+\.\d+')" > "0.10" ]]; then
    echo "   already installed: $(nvim --version | head -1)"
else
    NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep -oP '"tag_name":\s*"\K[^"]+')
    curl -fsSL "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-${NVIM_ARCH}.tar.gz" -o /tmp/nvim.tar.gz
    sudo tar xzf /tmp/nvim.tar.gz -C /opt
    sudo ln -sf "/opt/nvim-linux-${NVIM_ARCH}/bin/nvim" /usr/local/bin/nvim
    rm -f /tmp/nvim.tar.gz
fi

# --- rustup ---
echo "-> rustup"
if command -v rustup &>/dev/null; then
    echo "   already installed"
else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# --- tree-sitter ---
echo "-> tree-sitter"
if command -v tree-sitter &>/dev/null; then
    echo "   already installed: $(tree-sitter --version)"
else
    if command -v npm &>/dev/null; then
        sudo npm install -g tree-sitter-cli
    elif command -v cargo &>/dev/null; then
        cargo install tree-sitter-cli
    else
        echo "   ERROR: need cargo or npm to install tree-sitter-cli"
        exit 1
    fi
fi

# --- starship ---
echo "-> starship"
if command -v starship &>/dev/null; then
    echo "   already installed: $(starship --version)"
else
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# --- zoxide ---
echo "-> zoxide"
if command -v zoxide &>/dev/null; then
    echo "   already installed"
else
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# --- yazi ---
echo "-> yazi"
if command -v yazi &>/dev/null; then
    echo "   already installed"
else
    YAZI_DEB_URL=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest | grep -oP '"browser_download_url":\s*"\K[^"]*yazi-'"${YAZI_ARCH}"'\.deb')
    curl -fsSL "$YAZI_DEB_URL" -o /tmp/yazi.deb
    sudo dpkg -i /tmp/yazi.deb || sudo apt-get install -yf
    rm -f /tmp/yazi.deb
fi

# --- lazygit ---
echo "-> lazygit"
if command -v lazygit &>/dev/null; then
    echo "   already installed"
else
    LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -oP '"tag_name":\s*"v\K[^"]+')
    curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_${LAZYGIT_ARCH}.tar.gz" | tar xz -C /tmp lazygit
    sudo install /tmp/lazygit /usr/local/bin/lazygit
    rm -f /tmp/lazygit
fi

# --- lazydocker ---
echo "-> lazydocker"
if command -v lazydocker &>/dev/null; then
    echo "   already installed"
else
    LAZYDOCKER_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | grep -oP '"tag_name":\s*"v\K[^"]+')
    curl -fsSL "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_${LAZYDOCKER_ARCH}.tar.gz" | tar xz -C /tmp lazydocker
    sudo install /tmp/lazydocker /usr/local/bin/lazydocker
    rm -f /tmp/lazydocker
fi

# --- kubectl ---
echo "-> kubectl"
if command -v kubectl &>/dev/null; then
    echo "   already installed: $(kubectl version --client --short 2>/dev/null || kubectl version --client)"
else
    curl -fsSL "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/${GOARCH}/kubectl" -o /tmp/kubectl
    sudo install /tmp/kubectl /usr/local/bin/kubectl
    rm -f /tmp/kubectl
fi

# --- k9s ---
echo "-> k9s"
if command -v k9s &>/dev/null; then
    echo "   already installed"
else
    K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep -oP '"tag_name":\s*"\K[^"]+')
    curl -fsSL "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_${K9S_ARCH}.tar.gz" | tar xz -C /tmp k9s
    sudo install /tmp/k9s /usr/local/bin/k9s
    rm -f /tmp/k9s
fi

# --- bottom ---
echo "-> bottom"
if command -v btm &>/dev/null; then
    echo "   already installed"
else
    BTM_DEB_URL=$(curl -s https://api.github.com/repos/ClementTsang/bottom/releases/latest | grep -oP '"browser_download_url":\s*"\K[^"]*bottom_[^"]*_'"${ARCH}"'\.deb')
    curl -fsSL "$BTM_DEB_URL" -o /tmp/bottom.deb
    sudo dpkg -i /tmp/bottom.deb
    rm -f /tmp/bottom.deb
fi

# --- gdu ---
echo "-> gdu"
if command -v gdu &>/dev/null; then
    echo "   already installed"
else
    curl -fsSL "https://github.com/dundee/gdu/releases/latest/download/gdu_linux_${GOARCH}.tgz" | tar xz -C /tmp
    sudo install "/tmp/gdu_linux_${GOARCH}" /usr/local/bin/gdu
    rm -f "/tmp/gdu_linux_${GOARCH}"
fi

# --- golangci-lint ---
echo "-> golangci-lint"
if command -v golangci-lint &>/dev/null; then
    echo "   already installed"
else
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/bin
fi

# --- nerd fonts (symbols) ---
echo "-> Nerd Fonts (Symbols Only)"
FONT_DIR="$HOME/.local/share/fonts/NerdFontsSymbols"
if [ -d "$FONT_DIR" ] && ls "$FONT_DIR"/*.ttf &>/dev/null; then
    echo "   already installed"
else
    mkdir -p "$FONT_DIR"
    NERD_VERSION=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep -oP '"tag_name":\s*"\K[^"]+')
    curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_VERSION}/NerdFontsSymbolsOnly.tar.xz" -o /tmp/NerdFontsSymbols.tar.xz
    tar xf /tmp/NerdFontsSymbols.tar.xz -C "$FONT_DIR"
    rm -f /tmp/NerdFontsSymbols.tar.xz
    fc-cache -f "$FONT_DIR"
fi

# --- ghostty ---
echo "-> ghostty"
if command -v ghostty &>/dev/null; then
    echo "   already installed"
else
    echo "   NOTE: install manually — https://ghostty.org/docs/install"
fi

# --- hyprland & friends ---
echo "-> hyprland"
if command -v Hyprland &>/dev/null; then
    echo "   already installed"
else
    echo "   NOTE: install via official guide — https://wiki.hyprland.org/Getting-Started/Installation/"
fi

# --- aws cli v2 ---
echo "-> aws-cli v2"
if command -v aws &>/dev/null; then
    echo "   already installed: $(aws --version)"
else
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" -o /tmp/awscliv2.zip
    unzip -oq /tmp/awscliv2.zip -d /tmp
    sudo /tmp/aws/install
    rm -rf /tmp/awscliv2.zip /tmp/aws
fi

# --- google chrome ---
echo "-> google-chrome"
if command -v google-chrome &>/dev/null; then
    echo "   already installed"
else
    if [ "$ARCH" = "amd64" ]; then
        curl -fsSL "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -o /tmp/chrome.deb
        sudo apt-get install -y /tmp/chrome.deb
        rm -f /tmp/chrome.deb
    else
        echo "   NOTE: Google Chrome not available for arm64, install Chromium instead"
        sudo apt-get install -y chromium-browser
    fi
fi

# --- slack ---
echo "-> slack"
if command -v slack &>/dev/null || snap list slack &>/dev/null 2>&1; then
    echo "   already installed"
else
    if [ "$ARCH" = "amd64" ]; then
        sudo snap install slack
    else
        echo "   NOTE: Slack snap not available for arm64, install via Flatpak or web app"
    fi
fi

# --- telegram ---
echo "-> telegram-desktop"
if command -v telegram-desktop &>/dev/null || snap list telegram-desktop &>/dev/null 2>&1; then
    echo "   already installed"
else
    sudo snap install telegram-desktop
fi

# --- vi-mongo ---
echo "-> vi-mongo"
if command -v vi-mongo &>/dev/null; then
    echo "   already installed"
else
    VIMONGO_VERSION=$(curl -s https://api.github.com/repos/kopecmaciej/vi-mongo/releases/latest | grep -oP '"tag_name":\s*"\K[^"]+')
    curl -fsSL "https://github.com/kopecmaciej/vi-mongo/releases/download/${VIMONGO_VERSION}/vi-mongo_${VIMONGO_ARCH}.tar.gz" | tar xz -C /tmp vi-mongo
    sudo install /tmp/vi-mongo /usr/local/bin/vi-mongo
    rm -f /tmp/vi-mongo
fi

# --- postman ---
echo "-> postman"
if snap list postman &>/dev/null 2>&1; then
    echo "   already installed"
else
    sudo snap install postman
fi
