# Claude Code Configuration

My [Claude Code](https://docs.claude.com/en/docs/claude-code) setup: one agent, three skills, hooks, and the headless issue runner. Kept deliberately small: everything here has been used in a real session.

## Setup

```bash
./setup.sh
```

The script links `CLAUDE.md` and `settings.json`, then populates `~/.claude/{agents,skills,scripts}` with per-file symlinks.

## Agents

| Agent | Purpose |
|-------|---------|
| `omni` | Canonical interface for the `~/omni` Obsidian vault. All vault reads and writes route through it |

**Every agent file needs `name` and `description` in its frontmatter.** A file missing either is skipped at load time with no error, no warning, and no entry in the agent list. Two files sharing a `name` in one directory collide, and the winner follows readdir order, so which one is live can differ between machines. `setup.sh` prints a warning for any agent file it links that has no `name:`.

## Scripts

| Script | Purpose |
|--------|---------|
| `run-issue.sh <n>` or `--label <l>` | One GitHub issue per headless `claude -p` run in its own worktree. Posts started and finished comments on the issue with exit code, branch, PR link, log tail. A killed run costs one issue |
| `stop-gate.sh` | Stop hook. Uncommitted or unpushed work shows as a one-line status message. An open PR on the current branch blocks the first stop once so Claude merges or says why not |
| `touched.sh` | PostToolUse logger that records which files a session wrote, so the stop gate only nags about the session's own work |

## Skills

| Skill | Description |
|-------|-------------|
| `obsidian` | Conventions for the `~/omni` vault: naming, tags, frontmatter contract |

## Hooks

Configured in `settings.json`.

| Event | What runs |
|-------|-----------|
| `PostToolUse` on `*.py` | `ruff format` |
| `PostToolUse` on `*.js`, `*.ts`, `*.tsx`, `*.json` | `prettier --write` |
| `PostToolUse` on `*.md` | `omni check` — validates vault frontmatter |
| `PostToolUse` on `Write`, `Edit`, `Bash` | `touched.sh` — records the session's own writes |
| `Notification`, `Stop`, `SubagentStop` | Taphaptic haptic cue |
| `SessionStart`, `Stop` | `omni status` and `rms status` — vault and relationship state lines |
| `Stop` | `stop-gate.sh` — definition-of-done check (see Scripts) |

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
├── agents/             # omni
├── skills/             # obsidian
├── scripts/            # run-issue.sh, stop-gate.sh, touched.sh
└── assets/             # clawd.png, clawd.icns (unused since Taphaptic)
```

## Note

`settings.local.json` holds machine-local permission rules and is gitignored. `settings.json` is symlinked from `~/.claude/`, so changes made through `/config` or by editing either path land in `git status`.
