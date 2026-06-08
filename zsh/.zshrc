eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

MOZ_ENABLE_WAYLAND=1

# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)


# ================================================
# Alias
# ================================================

alias k="kubectl"
alias task="go-task"
alias cl="clear"
alias i="sudo pacman -S"
alias m="make"
alias n="nvim"
alias v="vim"
alias c="clear"
alias q="exit"
alias gptd="cd $1 nvim"
alias l="ls -la"
alias pps="podman ps"
alias lg="lazygit"
alias y="yazi"
alias t="task"
alias uuid="uuidgen"
alias ts="date +%s"
alias gg="git clone"

# ================================================
# PATH
# ================================================

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Local (bin)
export PATH="$HOME/.local/bin:$PATH"
# Local (Go)
export PATH="/usr/local/go/bin:$PATH"
# Go bin
export PATH="$HOME/go/bin:$PATH"

# Gem bin
export PATH="$HOME/.local/share/gem/ruby/3.3.0/bin:$PATH"

# Added by Antigravity CLI installer
export PATH="/home/sokol/.local/bin:$PATH"

# Set gpg for ssh
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
# GPG fix
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# Gvm
[[ -s "/home/sokol/.gvm/scripts/gvm" ]] && source "/home/sokol/.gvm/scripts/gvm"

# Work configs
source ~/.zshrc_work


