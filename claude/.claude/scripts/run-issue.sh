#!/usr/bin/env bash
# One GitHub issue per headless Claude invocation, state posted on the issue.
#
#   run-issue.sh <issue-number> [--budget 5] [--model opus] [--dry-run]
#   run-issue.sh --label wave-1 [--budget 5]      # sequential, one issue at a time
#
# Each run: worktree on branch issue-<n>, "started" comment, claude -p with the
# issue as intent, "finished" comment with exit code, branch, PR url, tail of
# output. A killed run costs one issue. Re-running an issue resumes on its
# existing branch. Run from inside the repo.
set -euo pipefail

budget="${RUN_ISSUE_BUDGET:-5}"
model="${RUN_ISSUE_MODEL:-}"
dry=0; label=""; issue=""
while [ $# -gt 0 ]; do
  case "$1" in
    --budget) budget="$2"; shift 2 ;;
    --model) model="$2"; shift 2 ;;
    --label) label="$2"; shift 2 ;;
    --dry-run) dry=1; shift ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
    *) issue="$1"; shift ;;
  esac
done

root="$(git rev-parse --show-toplevel)"
repo="$(gh repo view --json nameWithOwner -q .nameWithOwner)"
default="$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name)"
logdir="$root/.claude/runs"; mkdir -p "$logdir"

run_one() {
  local n="$1" branch="issue-$1" wt="$root/.claude/worktrees/issue-$1"
  local title body log="$logdir/issue-$1.log" pr=""
  title="$(gh issue view "$n" --json title -q .title)"
  body="$(gh issue view "$n" --json body -q .body)"
  # the comments are where direction lands after the issue is written; a run
  # that reads the body alone works from a stale brief (2026-09-17: #259)
  comments="$(gh issue view "$n" --json comments -q '.comments[] | select(.body | startswith("🤖") | not) | "--- comment by \(.author.login) (\(.createdAt)):\n\(.body)"' 2>/dev/null || true)"
  local prompt
  prompt="$(cat <<EOF
You are working on issue #$n of $repo: "$title".
Issue body (this is the intent; do not widen it):
---
$body
---
Comments on the issue (direction given after it was written; later comments override earlier ones and the body):
---
$comments
---
Rules:
1. First write a ten-line plan as plan.md in this worktree: files that change, order, tests that prove it, out of scope. Then implement.
2. Loops are scripts, models are judges: compute anything deterministic with a script.
3. Run the test suite. If it fails, fix the code, not the test.
4. Commit with conventional commits, push branch $branch, open a PR against $default titled "<type>(<scope>): <summary> (#$n)" whose body starts with "Closes #$n".
5. Finish by printing one line: STATUS: <done|blocked> <one sentence>.
Do not touch anything outside this issue. If blocked, say what would unblock it.
EOF
)"
  if [ "$dry" = 1 ]; then echo "--- would run issue #$n ($title) in $wt"; echo "$prompt" | head -20; return 0; fi

  git fetch -q origin "$default"
  if [ ! -d "$wt" ]; then
    if git show-ref -q "refs/heads/$branch"; then git worktree add -q "$wt" "$branch"
    else git worktree add -q -b "$branch" "$wt" "origin/$default"; fi
  fi
  gh issue comment "$n" -b "🤖 started $(date -u +%FT%TZ) on branch \`$branch\` (budget \$$budget)" >/dev/null

  set +e
  ( cd "$wt" && claude -p "$prompt" \
      --permission-mode acceptEdits \
      --max-budget-usd "$budget" \
      ${model:+--model "$model"} \
      --allowedTools "Read,Edit,Write,Glob,Grep,Bash" \
      --output-format text ) > "$log" 2>&1
  local rc=$?
  set -e

  pr="$(cd "$wt" && gh pr view "$branch" --json url -q .url 2>/dev/null || true)"
  local status; status="$(grep -E '^STATUS:' "$log" | tail -1 || true)"
  gh issue comment "$n" -b "$(cat <<EOF
🤖 finished $(date -u +%FT%TZ) · exit $rc · branch \`$branch\`${pr:+ · PR $pr}
${status:-STATUS: unknown (no STATUS line; see log)}

<details><summary>last 30 lines</summary>

\`\`\`
$(tail -30 "$log")
\`\`\`
</details>
EOF
)" >/dev/null
  echo "issue #$n: exit $rc ${pr:+pr=$pr} log=$log"
  return 0
}

if [ -n "$label" ]; then
  for n in $(gh issue list --label "$label" --state open --json number -q '.[].number' | sort -n); do run_one "$n"; done
else
  [ -n "$issue" ] || { echo "usage: run-issue.sh <n> | --label <l>" >&2; exit 2; }
  run_one "$issue"
fi
