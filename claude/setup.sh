#!/bin/bash
# Claude Code Setup Script
# Links Claude Code configuration: CLAUDE.md, settings, agents, skills, scripts

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "🤖 Setting up Claude Code configuration..."

# Create directories
mkdir -p "$CLAUDE_DIR"/{agents,scripts,skills}

# Symlink or copy config files
echo "  → Linking configuration..."
ln -sf "$SCRIPT_DIR/.claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
ln -sf "$SCRIPT_DIR/.claude/settings.json" "$CLAUDE_DIR/settings.json"

# Symlink skills
echo "  → Linking skills..."
for skill_dir in "$SCRIPT_DIR/.claude/skills"/*/; do
    [ -d "$skill_dir" ] && ln -sfn "$skill_dir" "$CLAUDE_DIR/skills/$(basename "$skill_dir")"
done

# Symlink agents
# NOTE: every agent file needs `name` and `description` in its frontmatter or
# Claude Code skips it silently — no error, the agent just never appears.
echo "  → Linking agents..."
for agent in "$SCRIPT_DIR/.claude/agents"/*.md; do
    [ -f "$agent" ] || continue
    if ! awk 'NR==1 && $0!="---" {exit 1} NR>1 && /^---/{exit 1} /^name:/{found=1} END{exit !found}' "$agent"; then
        echo "    ! $(basename "$agent") has no 'name:' in frontmatter — will not load"
    fi
    ln -sf "$agent" "$CLAUDE_DIR/agents/$(basename "$agent")"
done

# Symlink scripts (hooks in settings.json reference the dotfiles path directly)
echo "  → Linking scripts..."
chmod +x "$SCRIPT_DIR/.claude/scripts"/*.sh
for s in "$SCRIPT_DIR/.claude/scripts"/*.sh; do
    ln -sf "$s" "$CLAUDE_DIR/scripts/$(basename "$s")"
done


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
      "Bash(brew:*)",
      "Bash(ls:*)",
      "Bash(cat:*)",
      "Bash(head:*)",
      "Bash(tail:*)",
      "Bash(grep:*)",
      "Bash(find:*)",
      "Bash(git:*)",
      "Bash(gh:*)",
      "Bash(python:*)",
      "Bash(python3:*)",
      "Bash(pip:*)",
      "Bash(npm:*)",
      "Bash(node:*)",
      "Bash(cargo:*)",
      "Bash(docker:*)",
      "Bash(make:*)",
      "Bash(prettier:*)",
      "Bash(eslint:*)",
      "Bash(ruff:*)",
      "Bash(black:*)"
    ],
    "deny": [
      "Bash(rm -rf /)*",
      "Bash(rm -rf ~)*",
      "Bash(sudo:*)",
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
echo "Restart Claude Code to apply changes."
