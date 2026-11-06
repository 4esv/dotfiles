. "$HOME/.cargo/env"
# NOTE: non-interactive ssh (bench → herdr/mosh) only reads .zshenv.
export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"
[ -f "$HOME/.zshenv.local" ] && . "$HOME/.zshenv.local"
