#!/usr/bin/env bash
# PostToolUse logger. Records which files this session wrote and whether it
# ran git write commands, so stop-gate.sh only nags about the session's own work.
# NOTE: state lives in $TMPDIR/claude-touched-<session_id>; stale files are harmless.
command -v jq >/dev/null 2>&1 || exit 0
input="$(cat)"
sid="$(printf '%s' "$input" | jq -r '.session_id // empty')"
[ -n "$sid" ] || exit 0
f="${TMPDIR:-/tmp}/claude-touched-$sid"
tool="$(printf '%s' "$input" | jq -r '.tool_name // empty')"
case "$tool" in
  Write|Edit|NotebookEdit)
    printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty' >> "$f"
    ;;
  Bash)
    cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
    case "$cmd" in
      *"git commit"*|*"git push"*|*"gh pr create"*|*"gh pr merge"*) echo "GIT:$cmd" >> "$f" ;;
      *"/dev/null"*) ;;  # NOTE: redirects to /dev/null are not writes
      *"sed -i"*|*">"*|*"tee "*|*"cp "*|*"mv "*) echo "SHELL:$cmd" >> "$f" ;;
    esac
    ;;
esac
exit 0
