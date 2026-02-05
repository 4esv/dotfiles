#!/bin/bash
# Claude Code notification with Clawd icon
# Usage: notification.sh "title" "message"

TITLE="${1:-Claude Code}"
MESSAGE="${2:-Awaiting your input}"

"$HOME/.claude/ClawdNotifier.app/Contents/MacOS/terminal-notifier" \
    -title "$TITLE" \
    -message "$MESSAGE" \
    -sound "Blow" \
    -ignoreDnD
