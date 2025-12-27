#!/bin/bash
# Stop hook for autonomous work loops
# Checks if there's a TODO.md with remaining tasks
# If tasks remain, tells Claude to continue

TODO_FILE="${CLAUDE_WORKING_DIR:-$(pwd)}/TODO.md"

# If no TODO file, let Claude stop normally
if [ ! -f "$TODO_FILE" ]; then
    exit 0
fi

# Check if there are unchecked items
if grep -q "^\s*- \[ \]" "$TODO_FILE"; then
    # There are remaining tasks - tell Claude to continue
    echo '{"decision": "block", "reason": "Unchecked tasks remain in TODO.md. Continue working through the list."}'
    exit 0
fi

# All tasks complete, allow stop
exit 0
