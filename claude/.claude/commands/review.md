# Review

Review the current changes for issues before committing:

1. Get the diff: `git diff` and `git diff --cached`
2. Check for:
   - Debug statements left in (console.log, print, debugger)
   - Commented-out code that should be removed
   - TODO comments that should be addressed
   - Hardcoded values that should be configs
   - Security issues (exposed secrets, SQL injection, etc.)
   - Missing error handling
   - Type issues or potential null references
3. Provide a summary of issues found, grouped by severity
4. Suggest specific fixes

Be direct. Skip the praise. Just tell me what's wrong.
