# Axel Stevens - Development Preferences

## Philosophy
Use what exists, automate what repeats, document what breaks.

## Code Comments Convention
I use a Neovim plugin that highlights special comment tags. Always use these patterns:
- `// TODO:` - tasks to complete
- `// NOTE:` - important notes/explanations
- `// BUG:` - known bugs
- `// FIX:` - areas needing fixes
- `// HACK:` - temporary workarounds
- `// PERF:` - performance optimizations
- `// WARNING:` - potential issues

## Commit Messages
Use conventional commit format: `type(scope): description`

Common types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`

## Workflow Preferences
- Prefer iteration over perfection on first pass
- Run tests before committing when test suite exists
- Use git worktrees for parallel work on different features
- Write plan.md for complex tasks before implementing

## Stack Expertise
- Python automation and scripting
- PowerShell for Windows automation
- n8n workflow automation
- Home Assistant / homelab infrastructure
- Web development (brutalist/minimalist aesthetic)

## Communication Style
- Direct and concise
- Skip the preamble
- Show don't tell when possible

## Project Conventions
- Check for existing CLAUDE.md in project root for project-specific rules
- Look for .editorconfig, pyproject.toml, package.json for style guides
- Respect existing patterns in the codebase

## Available Subagents
Use these for specific workflows:
- `code-simplifier` - Run after implementation to reduce complexity
- `verify-app` - End-to-end verification (build, test, visual)
- `build-validator` - Validate builds and quality gates
- `code-architect` - Design features and review architecture

## Chrome Extension
The Chrome extension is available for visual verification. Use it to:
- Open the app in browser and take screenshots
- Test UI interactions and verify rendering
- Iterate on visual bugs until they're fixed

## Long-Running Tasks
For autonomous work use `/ralph-loop` with clear completion criteria:
```
/ralph-loop "Task description. Output <promise>DONE</promise> when complete." --max-iterations 20 --completion-promise "DONE"
```
