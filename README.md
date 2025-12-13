# dotfiles

```
     _       _    __ _ _
  __| | ___ | |_ / _(_) | ___  ___
 / _` |/ _ \| __| |_| | |/ _ \/ __|
| (_| | (_) | |_|  _| | |  __/\__ \
 \__,_|\___/ \__|_| |_|_|\___||___/
```

Personal dotfiles for macOS terminal-based development. Managed with [GNU Stow](https://www.gnu.org/software/stow/) and a simple `dots` CLI.

## Quick Start

```bash
git clone --recurse-submodules https://github.com/4esv/dotfiles.git ~/dotfiles
~/dotfiles/bin/.local/bin/dots install
```

## What's Included

| Package | Description |
|---------|-------------|
| `zsh` | Zsh config with Oh My Zsh, aliases, functions |
| `git` | Git config and global ignore patterns |
| `nvim` | Neovim config ([my fork](https://github.com/4esv/nvim-config)) |
| `ghostty` | Ghostty terminal with custom shaders |
| `starship` | Minimal prompt with GitHub Dark theme |
| `claude` | Claude Code preferences |
| `bin` | The `dots` CLI itself |

## The `dots` Command

```bash
dots install     # Full setup on a new machine
dots sync        # Pull latest + re-link configs
dots update      # Commit and push changes
dots link [pkg]  # Create symlinks (all or specific)
dots unlink      # Remove symlinks
dots status      # Check git & symlink health
dots brew        # Install Homebrew packages
dots macos       # Apply macOS preferences
dots edit        # Open in $EDITOR
```

## Structure

```
~/dotfiles/
├── bin/                    # dots CLI
├── zsh/                    # .zshrc, .zprofile, .zshenv
├── git/                    # .gitconfig, .config/git/ignore
├── ghostty/                # .config/ghostty/ + shaders
├── starship/               # .config/starship.toml
├── claude/                 # .claude/CLAUDE.md
├── nvim/                   # .config/nvim (submodule)
├── Brewfile                # Homebrew packages
├── .macos                  # macOS preferences
└── README.md
```

## Dependencies

Core tools installed via Brewfile:

- **Editor**: neovim
- **Shell**: zsh, starship, oh-my-zsh
- **Search**: fzf, ripgrep, fd, eza
- **Dev**: gh, git-delta, tmux, jq
- **Terminal**: ghostty

## Manual Steps

After `dots install`:

1. **Restart terminal** or `source ~/.zshrc`
2. **Add secrets** to `~/.zshrc.secrets` (API keys, tokens)
3. **Apply macOS prefs** with `dots macos` (optional)
4. **Set Ghostty** as default terminal

## Secrets

Sensitive data lives in `~/.zshrc.secrets` (not version controlled):

```bash
# ~/.zshrc.secrets
export OPENAI_API_KEY="..."
export GITHUB_TOKEN="..."
```

## License

MIT
