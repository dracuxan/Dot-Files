# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
autoload -Uz +X compinit && compinit

## case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Exports and Alias
# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=200000

# force zsh to show the complete history
alias history="history 0"

# Some more ls aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ld='du -h -d 1'
alias nv='nvim'
alias neo='clear'
alias noe='neo'
alias cls='clear; fastfetch'
alias tr='tree -Ld 1'
alias trf='tree -I '.git' -I 'out' -L 2'
alias x='exit'
alias nvc='cd ~/dotfiles/nvim && nv'
alias cd='z'

# Zig environment variables
export PATH="$PATH:$HOME/zig/bin"

# Go via Nix
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"


# Elixir env
export PATH="$HOME/.mix/escripts:$PATH"
# Elixir install (official installer)
# NVM Variables
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Load NVM
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Load NVM bash_completion (optional)
export PATH="$HOME/.npm-global/bin:$PATH"

# Neovim Variables
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# Path for custom scripts
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
alias tm='start_tmux'
alias arise='ssh Igris'

# Match Alacritty's Ctrl+; binding and clear the shell like Ctrl+l.
bindkey $'\e[59;5u' clear-screen

export LC_ALL=C.UTF-8

# Git aliases
alias gitupd='git add .; git commit -m "upd"; git push'
alias gitnew='git add .; git commit -m "new"; git push'
alias gitadd='git add .; git commit -m "add"; git push'
alias gitfix='git add .; git commit -m "fix"; git push'
alias gitrebase='git pull --rebase'
alias gitbat='git add .; git commit -m "batman"; git push'
alias ga="git add .;"
alias gc="git commit -m"
alias gp="git push"
alias gpall="git remote | xargs -L1 git push"

# bun completions
[ -s "/home/dracuxan/.bun/_bun" ] && source "/home/dracuxan/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# cargo
export PATH="/home/dracuxan/.cargo/bin:$PATH"

# Python alias
alias py='python3'

# Nuclei alias
alias nuke='nuclei'
alias ff='firefox'

# codex alias
alias cr='codex resume'

# Metasploit variables
export PATH="$PATH:/opt/metasploit-framework/bin"

# nix alias
alias nix-system-add='sudo nix profile add --profile /nix/var/nix/profiles/system'
alias nix-system-upgrade='sudo nix profile upgrade --profile /nix/var/nix/profiles/system dotfiles'
alias nix-system-profile='sudo nix profile list --profile /nix/var/nix/profiles/system'

# Nix system profile (required for Debian + Nix)
export PATH=/nix/var/nix/profiles/system/bin:$PATH

# Startup Commands
eval "$(starship init zsh)"

if [[ -n "$IN_NIX_SHELL" ]]; then
    PROMPT="(nix-shell) $PROMPT"
fi

export POLYBAR_COLLECTION="/home/dracuxan/debian-dots/polybar"
export POLYBAR_BATTERY_ADP="ACAD"
export POLYBAR_BATTERY_BAT="BAT1"
export POLYBAR_WIRELESS="wlan0"
export POLYBAR_WIRED="enp3s0"
export POLYBAR_WEATHER_API="46276f91dcb44de4ac0134024262101"

# opencode
export PATH=/home/dracuxan/.opencode/bin:$PATH
. /etc/profile.d/nix.sh
eval "$(zoxide init zsh)"
export PATH=$HOME/.npm-global/bin:$PATH

export GPG_TTY=$(tty)

export PATH="/home/dracuxan/.pixi/bin:$PATH"
. "$HOME/.asdf/asdf.sh"

preexec() { LAST_CMD="$1" }
precmd() {
  local last_status=$?
  local exclude=("ls" "cd" "source" "clear" "x" "neo" "noe" "nv" "cls" "tm" "git" "lazygit" "vim" "cat")
  local cmd_base="${LAST_CMD%% *}"
  
  if [[ -n "$LAST_CMD" ]] && [[ ! " ${exclude[@]} " =~ " ${cmd_base} " ]]; then
    if [[ "$last_status" -eq 0 ]]; then
      dunstify "command completed: $LAST_CMD"
    else
      dunstify "command failed ($last_status): $LAST_CMD"
    fi
  fi
  LAST_CMD=""
}

eval $(opam env --switch=ocaml-gp)
