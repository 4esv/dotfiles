# Claude Code Configuration

My [Claude Code](https://docs.claude.com/en/docs/claude-code) setup: agents, slash commands, skills, hooks, and the Clawd notification mascot.

## Setup

```bash
./setup.sh
```

The script links `CLAUDE.md` and `settings.json`, then populates `~/.claude/{agents,commands,skills}` with per-file symlinks, copies `scripts/` and `assets/`, and builds ClawdNotifier.app. Pass `--force` to rebuild ClawdNotifier.app after a terminal-notifier upgrade.

## Agents

Six subagents in `.claude/agents/`, each dispatched by name through the Agent tool.

| Agent | Purpose |
|-------|---------|
| `omni` | Canonical interface for the `~/omni` Obsidian vault. All vault reads and writes route through it |
| `code-simplifier` | Reduces complexity in recently modified code without changing behavior |
| `code-architect` | Designs features to fit the patterns already in the codebase |
| `code-pedant` | Blunt whole-repo review: is this engineering or dressed-up vibecoding |
| `build-validator` | Clean build plus type, lint, and test gates |
| `verify-app` | End-to-end verification, including visual checks in the browser |

**Every agent file needs `name` and `description` in its frontmatter.** A file missing either is skipped at load time with no error, no warning, and no entry in the agent list. Two files sharing a `name` in one directory collide, and the winner follows readdir order, so which one is live can differ between machines. `setup.sh` prints a warning for any agent file it links that has no `name:`.

## Commands

| Command | Description |
|---------|-------------|
| `/autonomous` | Long-running autonomous work with completion criteria |
| `/catchup` | Resume context on a git branch |
| `/commit-push-pr` | Stage, commit, push, open a PR |
| `/plan <task>` | Think before coding, outputs plan.md |
| `/review` | Pre-commit code review |

## Skills

| Skill | Description |
|-------|-------------|
| `obsidian` | Conventions for the `~/omni` vault: naming, tags, frontmatter contract |
| `promote-note` | Raw note to fully-processed note, with verified wikilinks |
| `terminal-graph` | Port type system, layout rules, and gotchas for the Terminal Graph canvas |

## Hooks

Configured in `settings.json`.

| Event | What runs |
|-------|-----------|
| `PostToolUse` on `*.py` | `ruff format` |
| `PostToolUse` on `*.js`, `*.ts`, `*.tsx`, `*.json` | `prettier --write` |
| `PostToolUse` on `*.md` | `omni check` — validates vault frontmatter |
| `Notification` | Clawd appears on permission prompts and idle prompts |
| `SessionStart`, `Stop` | `omni status` — vault state line |
| `SubagentStop` | Clawd subagent notification |

The formatter hooks are guarded with `command -v`, so **they no-op silently when `ruff` or `prettier` is missing**. Both are in the repo Brewfile for that reason. To confirm a hook actually fires, run its command string directly with `CLAUDE_FILE` exported:

```bash
CLAUDE_FILE=/tmp/x.json prettier --write "$CLAUDE_FILE"
```

Exporting matters. A bare `CLAUDE_FILE=... sh -c '... "$CLAUDE_FILE"'` leaves the variable empty inside the subshell, and `prettier --write ""` falls back to formatting the entire working directory.

## Files

```
.claude/
├── CLAUDE.md           # Global preferences & context
├── settings.json       # Hooks, plugins, permissions, model config
├── settings.local.json # Permissions (gitignored, machine-local)
├── agents/             # Subagent definitions
├── commands/           # Slash commands
├── skills/             # Skills
├── scripts/            # statusline.sh, pre-commit-check.sh
└── assets/             # clawd.png, clawd.icns
```

## Note

`settings.local.json` holds machine-local permission rules and is gitignored. `settings.json` is symlinked from `~/.claude/`, so changes made through `/config` or by editing either path land in `git status`.
