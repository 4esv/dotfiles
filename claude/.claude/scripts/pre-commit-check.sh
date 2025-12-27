#!/bin/bash
# Block git commit unless tests pass
# Used as a PreToolUse hook for Bash(git commit*)

# Check if tests passed flag exists
if [ -f "/tmp/.claude-tests-passed-$$" ]; then
    exit 0
fi

# Check if there's a test command available
if [ -f "package.json" ] && grep -q '"test"' package.json 2>/dev/null; then
    echo '{"error": "Run tests before committing: npm test"}'
    exit 1
elif [ -f "pyproject.toml" ] || [ -f "pytest.ini" ] || [ -d "tests" ]; then
    echo '{"error": "Run tests before committing: pytest"}'
    exit 1
elif [ -f "Cargo.toml" ]; then
    echo '{"error": "Run tests before committing: cargo test"}'
    exit 1
fi

# No test framework detected, allow commit
exit 0
