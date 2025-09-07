eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

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

# Aliases
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

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/home/sokol/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# pnpm
export PNPM_HOME="/home/sokol/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Go (local)
export PATH=$PATH:/usr/local/go/bin

# Go bin
export PATH="/home/sokol/go/bin:$PATH"

# Gem bin
export PATH="/home/sokol/.local/share/gem/ruby/3.3.0/bin:$PATH"

# Set gpg for ssh
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
# GPG fix
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

