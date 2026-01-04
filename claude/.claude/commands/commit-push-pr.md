# Commit, Push, and Open PR

Commit all staged and unstaged changes, push to remote, and open a pull request.

## Context

```bash
# Current branch
BRANCH=$(git branch --show-current)

# Base branch (main or master)
BASE=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")

# Status
git status --short

# Staged changes
git diff --cached --stat

# Unstaged changes
git diff --stat

# Recent commits on this branch
git log --oneline $BASE..HEAD 2>/dev/null | head -10

# Full diff from base
git diff $BASE...HEAD --stat 2>/dev/null
```

## Instructions

1. **Stage all changes** - Add any untracked/modified files that should be included
2. **Create commit** - Write a conventional commit message based on the changes
3. **Push to remote** - Push the branch, setting upstream if needed
4. **Create PR** - Use `gh pr create` with:
   - Clear title summarizing the change
   - Body with Summary (bullet points) and Test Plan sections
   - Target the correct base branch

If the branch doesn't exist on remote yet, push with `-u origin $BRANCH`.

If a PR already exists for this branch, report the existing PR URL instead of creating a new one.

## Commit Message Format

Use conventional commits: `type(scope): description`

Types: feat, fix, docs, refactor, test, chore, perf
