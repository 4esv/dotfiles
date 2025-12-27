# Claude Code Configuration

My [Claude Code](https://docs.anthropic.com/claude-code) setup with custom commands, hooks, and the Clawd notification mascot.

## Setup

```bash
./setup.sh
```

Use `--force` to reinstall ClawdNotifier.app if terminal-notifier was upgraded.

## What's Included

### Commands

| Command | Description |
|---------|-------------|
| `/catchup` | Resume context on a git branch |
| `/plan <task>` | Think before coding, outputs plan.md |
| `/fix-issue <num>` | Fix a GitHub issue end-to-end |
| `/pr` | Stage, commit, push, create PR |
| `/review` | Pre-commit code review |
| `/refactor <file>` | Clean up code smells |
| `/test <thing>` | Write tests |
| `/doc <thing>` | Generate documentation |

### Hooks

- **Notification**: Clawd appears when Claude needs input
- **PostToolUse**: Auto-format Python (ruff), JS/TS/JSON (prettier)

### Assets

- `clawd.png` / `clawd.icns` — The notification mascot

## Files

```
.claude/
├── CLAUDE.md           # Global preferences & context
├── settings.json       # Hooks, plugins, model config
├── settings.local.json # Permissions (gitignored, created by setup.sh)
├── commands/           # Slash commands
├── scripts/            # Helper scripts
└── assets/             # Icons
```

## Note

`settings.local.json` contains permission settings and is gitignored. The setup script creates a template with sensible defaults.
