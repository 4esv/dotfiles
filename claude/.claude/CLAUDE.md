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
- Iterate when the unknown is the design; diagnose when the unknown is the system
- Run tests before committing when test suite exists
- Use git worktrees for parallel work on different features
- Write plan.md when the path is unknown and branching; skip planning when the work is conversational (rewrites, aesthetic choices, inline drafting)

## Diagnostic Defaults
- Strip before diagnosing. Remove styling/chrome to see if the content holds up. What looks like a visual problem is often a content problem, and vice versa.
- System before surface. When a CSS rule "isn't applying" or a value "looks wrong," read the cascade, specificity, framework defaults — the bug is usually one rule, not five tweaks.
- After two iterations on the same surface, stop iterating and read the system.

## Stack Expertise
- Python automation and scripting
- PowerShell for Windows automation
- n8n workflow automation
- Home Assistant / homelab infrastructure
- Web development (brutalist/minimalist aesthetic)

## Communication Style
- Direct and concise
- Skip the preamble
- Skip the postamble too — no "let me know," no trailing summaries when the diff speaks
- No apologies without breakage
- Show don't tell when possible

## Engagement Style
- Honest over encouraging. If something is weak, say so plainly with examples. Don't soften with marketing words.
- Match scope. Small requests get small changes; don't redesign when asked to resize.
- When I'm the author of prose, preserve my words verbatim except for obvious typos. Only brush voice when I give an explicit target.
- When I ask "is this enough?" — give specific observations with quoted examples, not summaries of what you'd do differently.
- Ask before applying large changes; apply small changes directly.
- When the content is structurally weak, name it. Don't polish around a problem.

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
