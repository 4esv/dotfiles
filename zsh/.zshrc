#!/bin/zsh
# =============================================================================
# Axel's Zsh Configuration
# =============================================================================

# =============================================================================
# Environment & Path Setup
# =============================================================================
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.lmstudio/bin"

# Language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Editor preferences
if command -v nvim >/dev/null 2>&1; then
  export EDITOR='nvim'
  export VISUAL='nvim'
else
  export EDITOR='vim'
  export VISUAL='vim'
fi

# =============================================================================
# Oh My Zsh Configuration
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"

# NOTE: Disabled to prevent conflicts with Starship prompt
ZSH_THEME=""

# Performance: Skip slow git status checks in large repos
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Auto-update behavior
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 13

# Enhanced plugin setup
plugins=(
  git
  docker
  kubectl
  brew
  macos
  gh
  npm
  node
  sudo
  copypath
  zsh-autosuggestions
  zsh-syntax-highlighting
  history-substring-search
  colored-man-pages
  extract
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# =============================================================================
# History Configuration
# =============================================================================
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# =============================================================================
# Zsh Options & Behavior
# =============================================================================
# Directory navigation
setopt AUTO_CD              # Auto cd when typing directory name
setopt AUTO_PUSHD           # Push directories onto stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
setopt PUSHD_SILENT         # Don't print stack after pushd/popd

# Completion
setopt COMPLETE_ALIASES     # Complete aliases
setopt LIST_PACKED          # Compact completion lists
setopt AUTO_MENU            # Show menu after second tab

# Globbing
setopt EXTENDED_GLOB        # Extended globbing
setopt NOMATCH              # Error if glob doesn't match

# =============================================================================
# Aliases
# =============================================================================

# Editor shortcuts
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# Enhanced ls alternatives
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --color=auto --group-directories-first'
  alias ll='eza -l --color=auto --group-directories-first --git'
  alias la='eza -la --color=auto --group-directories-first --git'
  alias tree='eza --tree --color=auto'
else
  alias ls='ls --color=auto'
  alias ll='ls -alF'
  alias la='ls -A'
fi

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Git shortcuts
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gst='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gp='git push'
alias gpl='git pull'
alias gb='git branch'
alias gco='git checkout'

# System shortcuts
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# macOS specific
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias finder='open .'
  alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
  alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
  alias copy='pbcopy'
fi

# Network utilities
alias myip='curl -s https://ipinfo.io/ip'
alias localip='ipconfig getifaddr en0'
alias ports='netstat -tuln'

# Development shortcuts
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias json='python3 -m json.tool'

# Better cat with syntax highlighting
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
  alias catp='bat'  # bat with pager
fi

# =============================================================================
# Functions
# =============================================================================

# Create directory and cd into it
function mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract various archive types
function extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Find and kill process by name
function killp() {
  ps aux | grep -v grep | grep "$1" | awk '{print $2}' | xargs kill -9
}

# Create backup of file with timestamp
function backup() {
  cp "$1" "${1}.backup.$(date +%Y%m%d_%H%M%S)"
}

# Weather function
function weather() {
  local city="${1:-}"
  curl -s "wttr.in/${city}?format=3"
}

# =============================================================================
# Prompt & Theme Setup
# =============================================================================

# NOTE: Initialize Starship prompt after Oh My Zsh to prevent conflicts
if command -v starship >/dev/null 2>&1; then
  # Clear Oh My Zsh's prompt before initializing Starship
  unset PROMPT RPROMPT
  eval "$(starship init zsh)"
fi

# Zoxide: smarter cd that learns your habits (use 'z' instead of 'cd')
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# FZF: fuzzy finder keybindings (Ctrl+R history, Ctrl+T files, Alt+C cd)
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# =============================================================================
# API Keys & Sensitive Config
# =============================================================================
# Load secrets from separate file (not version controlled)
[ -f ~/.zshrc.secrets ] && source ~/.zshrc.secrets

# =============================================================================
# Completion Enhancements
# =============================================================================

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BNo matches for: %d%b'

# =============================================================================
# Final Setup & Welcome
# =============================================================================

# Load any additional custom configurations
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Show a subtle welcome message
if [[ -o interactive ]]; then
  echo "Welcome back, $(whoami)!"
fi

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"
