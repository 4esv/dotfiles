# PR

Prepare a pull request for the current branch:

1. Review all staged and unstaged changes
2. Run any available linters/formatters
3. Stage all changes if appropriate
4. Write a commit message following conventional commit format: `type(scope): description`
5. Create a PR description summarizing:
   - What changed
   - Why it changed
   - Any breaking changes or migration notes
6. Push the branch and create the PR using `gh pr create`

Ask for confirmation before pushing.
