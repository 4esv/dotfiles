# Catchup

Read all files changed in the current git branch compared to main/master.
Summarize the current state of the work and what remains to be done.

```bash
git diff --name-only main...HEAD 2>/dev/null || git diff --name-only master...HEAD
```

Read each changed file and provide a brief status report.
