# dotfiles

```
     _       _    __ _ _
  __| | ___ | |_ / _(_) | ___  ___
 / _` |/ _ \| __| |_| | |/ _ \/ __|
| (_| | (_) | |_|  _| | |  __/\__ \
 \__,_|\___/ \__|_| |_|_|\___||___/
```

Personal dotfiles for macOS terminal-based development. Managed with [GNU Stow](https://www.gnu.org/software/stow/) and a `dots` CLI.

## Quick Start

```bash
git clone https://github.com/4esv/dotfiles.git ~/dotfiles
~/dotfiles/bin/.local/bin/dots install
```

`dots install` sets up Homebrew, the Brewfile packages, Neovim, Oh My Zsh with plugins, and every symlink.

## What's Included

| Package | Description |
|---------|-------------|
| `zsh` | Zsh config with Oh My Zsh, aliases, functions |
| `git` | Git config and global ignore patterns |
| `nvim` | Neovim config, vendored (no submodule) |
| `ghostty` | Ghostty terminal with custom shaders |
| `starship` | Minimal prompt with GitHub Dark theme |
| `claude` | Claude Code config: agents, commands, skills, hooks ([details](claude/README.md)) |
| `terminalgraph` | Terminal Graph app preferences and blueprints |
| `bin` | The `dots` CLI itself |

## The `dots` Command

```bash
dots install     # Full setup on a new machine
dots sync        # Pull latest + re-link configs
dots update      # Commit and push changes
dots link [pkg]  # Create symlinks (all or specific)
dots unlink      # Remove symlinks
dots fix-paths   # Scan configs for hardcoded /Users/<name>/ paths
dots status      # Check git & symlink health
dots brew        # Install Homebrew packages
dots nvim        # Install/update Neovim from the upstream tarball
dots macos       # Apply macOS preferences
dots edit        # Open in $EDITOR
```

## Neovim

Neovim is installed from the upstream release tarball into `~/.local/nvim`, with a symlink at `~/.local/bin/nvim`. It is deliberately not a Brewfile entry.

The config uses `vim.pack`, Neovim's native plugin manager, so it requires **0.12 or newer**. Homebrew's `neovim` formula still ships 0.11.x, and its build is broken on macOS 27. Installing Neovim from brew produces an editor that cannot load this config.

```bash
dots nvim                      # install the pinned version (v0.12.4)
NVIM_VERSION=v0.12.5 dots nvim # or pin a different tag
```

If brew's `neovim` is already installed it shadows this build whenever `/opt/homebrew/bin` precedes `~/.local/bin` on `PATH`. `dots nvim` warns when it detects this. Remove it with `brew uninstall neovim`.

## Dependencies

The Brewfile installs the core tools. Zsh, starship and oh-my-zsh run the shell, while fzf, ripgrep, fd and eza handle search. Additionally, gh, git-delta, lazygit, tmux and jq cover day-to-day development, and node, python and rustup provide the language runtimes. Ghostty is the terminal. Neovim is the one exception, installed separately for the reason above.

Two entries exist for a specific reason:

| Package | Why it's required |
|---------|-------------------|
| `ruff` | The Claude Code `PostToolUse` hook formats Python with it |
| `prettier` | The same hook formats JS, TS, and JSON with it |

Those hooks are written as `command -v <tool> && <tool> ... || true`, so a missing formatter makes them no-op silently and nothing gets formatted. Keep both installed.

Installed outside Homebrew:

| Tool | Source |
|------|--------|
| Neovim | upstream tarball, via `dots nvim` |
| Oh My Zsh | installer script, run by `dots install` |
| zsh-autosuggestions, zsh-syntax-highlighting | git clones, run by `dots install` |
| Terminal Graph | the app is installed manually; only its config is versioned here |

## Terminal Graph

The `terminalgraph` package versions `config.json` and `blueprints/`. Everything else in `~/.config/terminalgraph/` stays local and gitignored: `credentials.json` holds an API key, `sessions/` and `pipes/` are runtime state, `global.terminalgraph-workspace` is live canvas state that rewrites constantly, and `ghostty.conf` is managed by the app.

`config.json` is symlinked into the repo, so preference changes made in the app show up in `git status`. If the app ever replaces the file instead of writing through the symlink, `dots status` reports it missing and `dots link terminalgraph` restores it.

## Structure

```
~/dotfiles/
├── bin/                    # dots CLI
├── zsh/                    # .zshrc, .zprofile, .zshenv
├── git/                    # .gitconfig, .config/git/ignore
├── ghostty/                # .config/ghostty/ + shaders
├── starship/               # .config/starship.toml
├── claude/                 # .claude/ + setup.sh
├── terminalgraph/          # .config/terminalgraph/
├── nvim/                   # .config/nvim (vendored)
├── Brewfile                # Homebrew packages
├── .macos                  # macOS preferences
└── README.md
```

## Manual Steps

After `dots install`:

1. **Restart terminal** or `source ~/.zshrc`
2. **Add secrets** to `~/.zshrc.secrets` (API keys, tokens)
3. **Apply macOS prefs** with `dots macos` (optional)
4. **Set Ghostty** as default terminal
5. **Run `claude/setup.sh`** to link Claude Code agents, commands, and skills

## Secrets

Sensitive data lives in `~/.zshrc.secrets`, which is not version controlled:

```bash
# ~/.zshrc.secrets
export OPENAI_API_KEY="..."
export GITHUB_TOKEN="..."
```

## License

MIT
