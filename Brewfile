# =============================================================================
# Brewfile - Essential macOS Development Tools
# =============================================================================
# Install with: brew bundle --file=Brewfile
# =============================================================================

# -----------------------------------------------------------------------------
# Core Tools
# -----------------------------------------------------------------------------
brew "git"                  # Version control
brew "stow"                 # Symlink farm manager
brew "starship"             # Cross-shell prompt

# NOTE: neovim is deliberately NOT installed via brew. The nvim config is
# vim.pack-based and needs 0.12+; the brew formula still ships 0.11.x, and
# brew's build is broken on macOS 27. `dots nvim` installs the standalone
# release into ~/.local/nvim instead. See the Neovim section of README.md.

# -----------------------------------------------------------------------------
# Search & Navigation
# -----------------------------------------------------------------------------
brew "fzf"                  # Fuzzy finder
brew "ripgrep"              # Fast grep alternative (rg)
brew "fd"                   # Fast find alternative
brew "eza"                  # Modern ls replacement
brew "zoxide"               # Smarter cd command
brew "tree"                 # Directory tree view
brew "bat"                  # Better cat with syntax highlighting
brew "tldr"                 # Simplified man pages
brew "dust"                 # Better du (disk usage)
brew "duf"                  # Better df (disk free)

# -----------------------------------------------------------------------------
# Development
# -----------------------------------------------------------------------------
brew "gh"                   # GitHub CLI
brew "git-delta"            # Better git diffs
brew "git-lfs"              # Git large file storage
brew "lazygit"              # Terminal UI for git
brew "tmux"                 # Terminal multiplexer
brew "jq"                   # JSON processor
brew "yq"                   # YAML processor
brew "httpie"               # Modern curl alternative

# -----------------------------------------------------------------------------
# Languages & Runtimes
# -----------------------------------------------------------------------------
brew "node"                 # Node.js
brew "python"               # Python 3
brew "rustup"               # Rust toolchain

# -----------------------------------------------------------------------------
# Formatters — required by the Claude Code PostToolUse hooks
# -----------------------------------------------------------------------------
# WARNING: the hooks are `command -v <tool> && <tool> ... || true`, so if these
# are missing they no-op silently and nothing gets formatted. Keep them here.
brew "ruff"                 # Python formatter/linter
brew "prettier"             # JS/TS/JSON/Markdown formatter

# -----------------------------------------------------------------------------
# Applications
# -----------------------------------------------------------------------------
cask "ghostty"              # GPU-accelerated terminal
