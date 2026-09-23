#!/usr/bin/env bash
# PostToolUse on Write|Edit. Formats the written file only where the repo opted
# in (a prettier or ruff config is found), and runs the vault contract check.
# NOTE: replaces the old per-extension hooks, which never fired: their matchers
# used permission-rule syntax and they read $CLAUDE_FILE, which is never set.
command -v jq >/dev/null 2>&1 || exit 0
f="$(jq -r '.tool_input.file_path // empty')"
[ -f "$f" ] || exit 0

# Walk up from the file looking for a ruff config.
has_config() {
  local d; d="$(dirname "$f")"
  while [ "$d" != "/" ]; do
    [ -f "$d/ruff.toml" ] || [ -f "$d/.ruff.toml" ] && return 0
    [ -f "$d/pyproject.toml" ] && grep -q '^\[tool\.ruff' "$d/pyproject.toml" && return 0
    d="$(dirname "$d")"
  done
  return 1
}

case "$f" in
  "$HOME"/omni/*.md)
    # Exit 2 so Claude sees the contract error; omni's own exit 1 reaches only the user.
    /bin/sh "$HOME/omni/meta/scripts/omni" check "$f" || exit 2 ;;
  *.py)
    command -v ruff >/dev/null && has_config && ruff format --quiet "$f" ;;
  *.js|*.mjs|*.cjs|*.ts|*.tsx|*.jsx|*.json|*.css)
    command -v prettier >/dev/null && prettier --find-config-path "$f" >/dev/null 2>&1 \
      && prettier --write --log-level warn "$f" ;;
esac
exit 0
