#!/bin/bash
# Claude Code Setup Script
# Installs Claude Code configuration, commands, and Clawd notifications

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "🤖 Setting up Claude Code configuration..."

# Create directories
mkdir -p "$CLAUDE_DIR"/{commands,scripts,assets,skills}

# Symlink or copy config files
echo "  → Linking configuration..."
ln -sf "$SCRIPT_DIR/.claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
ln -sf "$SCRIPT_DIR/.claude/settings.json" "$CLAUDE_DIR/settings.json"

# Symlink commands
echo "  → Linking commands..."
for cmd in "$SCRIPT_DIR/.claude/commands"/*.md; do
    [ -f "$cmd" ] && ln -sf "$cmd" "$CLAUDE_DIR/commands/$(basename "$cmd")"
done

# Copy scripts (not symlink, they need to be executable)
echo "  → Installing scripts..."
cp "$SCRIPT_DIR/.claude/scripts"/*.sh "$CLAUDE_DIR/scripts/"
chmod +x "$CLAUDE_DIR/scripts"/*.sh

# Copy assets
echo "  → Installing assets..."
cp "$SCRIPT_DIR/.claude/assets"/* "$CLAUDE_DIR/assets/"

# Install terminal-notifier if not present
if ! command -v terminal-notifier &> /dev/null; then
    echo "  → Installing terminal-notifier..."
    brew install terminal-notifier
fi

# Create ClawdNotifier.app (custom notification app with Clawd icon)
echo "  → Setting up Clawd notifications..."
NOTIFIER_SRC="/opt/homebrew/Cellar/terminal-notifier/$(ls /opt/homebrew/Cellar/terminal-notifier 2>/dev/null | head -1)/terminal-notifier.app"
CLAWD_APP="$CLAUDE_DIR/ClawdNotifier.app"

if [ -d "$NOTIFIER_SRC" ]; then
    if [ ! -d "$CLAWD_APP" ] || [ "$1" = "--force" ]; then
        rm -rf "$CLAWD_APP"
        cp -R "$NOTIFIER_SRC" "$CLAWD_APP"
        
        # Replace icon with Clawd
        if [ -f "$CLAUDE_DIR/assets/clawd.icns" ]; then
            cp "$CLAUDE_DIR/assets/clawd.icns" "$CLAWD_APP/Contents/Resources/Terminal.icns"
            echo "  → Clawd icon installed!"
        fi
    else
        echo "  → ClawdNotifier.app already exists (use --force to reinstall)"
    fi
else
    echo "  ⚠ terminal-notifier not found at expected path, skipping Clawd setup"
fi

# Create settings.local.json template if it doesn't exist
if [ ! -f "$CLAUDE_DIR/settings.local.json" ]; then
    echo "  → Creating settings.local.json template..."
    cat > "$CLAUDE_DIR/settings.local.json" << 'EOF'
{
  "permissions": {
    "allow": [
      "WebSearch",
      "Edit",
      "Write",
      "Read",
      "Bash(test:*)",
      "Bash(brew *)",
      "Bash(ls:*)",
      "Bash(cat:*)",
      "Bash(head:*)",
      "Bash(tail:*)",
      "Bash(grep:*)",
      "Bash(find:*)",
      "Bash(git *)",
      "Bash(gh *)",
      "Bash(python *)",
      "Bash(python3 *)",
      "Bash(pip *)",
      "Bash(npm *)",
      "Bash(node *)",
      "Bash(cargo *)",
      "Bash(docker *)",
      "Bash(make *)",
      "Bash(prettier *)",
      "Bash(eslint *)",
      "Bash(ruff *)",
      "Bash(black *)"
    ],
    "deny": [
      "Bash(rm -rf /)*",
      "Bash(rm -rf ~)*",
      "Bash(sudo *)",
      "Read(.env)",
      "Read(.env.*)"
    ]
  }
}
EOF
fi

echo ""
echo "✅ Claude Code setup complete!"
echo ""
echo "Available commands:"
ls -1 "$CLAUDE_DIR/commands" | sed 's/.md$//' | sed 's/^/  \//'
echo ""
echo "Restart Claude Code to apply changes."
