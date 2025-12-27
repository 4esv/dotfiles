# Refactor

Refactor the specified file or component: $ARGUMENTS

1. Read the target file/component
2. Identify code smells:
   - Long functions (>30 lines)
   - Deep nesting (>3 levels)
   - Repeated code patterns
   - Poor naming
   - Missing abstractions
   - Tight coupling
3. Think hard about the cleanest approach
4. Implement the refactor in small, atomic commits
5. Ensure behavior is preserved (run tests if available)

Prefer small, focused changes over sweeping rewrites.
