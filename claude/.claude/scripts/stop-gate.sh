#!/usr/bin/env bash
# Stop hook: definition-of-done gate.
# Uncommitted / unpushed work -> one-line status message, no re-prompt.
# Open PR on the current branch -> blocks the first stop once so Claude
# merges or says why not. The second stop always passes (stop_hook_active).
command -v jq >/dev/null 2>&1 || exit 0
input="$(cat)"
[ "$(printf '%s' "$input" | jq -r '.stop_hook_active // false')" = "true" ] && exit 0
sid="$(printf '%s' "$input" | jq -r '.session_id // empty')"
touched="${TMPDIR:-/tmp}/claude-touched-$sid"
# Only gate sessions that actually did work.
[ -s "$touched" ] || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
root="$(git rev-parse --show-toplevel)"

notes=()   # shown to user only
reasons=() # block once

# 1. Uncommitted changes among files this session touched (plus any untracked
#    file under a directory it touched, to catch new files written via shell).
dirty="$(git status --porcelain=v1 --untracked-files=all 2>/dev/null | cut -c4- | sed 's/^.* -> //')"
if [ -n "$dirty" ]; then
  mine=""
  while IFS= read -r p; do
    case "$p" in GIT:*|SHELL:*) continue ;; esac
    rel="${p#$root/}"
    if printf '%s\n' "$dirty" | grep -qxF -- "$rel"; then mine+="$rel"$'\n'; fi
  done < "$touched"
  # If the session ran shell writes we can't attribute, fall back to all dirty files.
  if grep -q '^SHELL:' "$touched" 2>/dev/null; then mine="$dirty"$'\n'; fi
  mine="$(printf '%s' "$mine" | sort -u | sed '/^$/d')"
  if [ -n "$mine" ]; then
    n="$(printf '%s\n' "$mine" | wc -l | tr -d ' ')"
    notes+=("$n uncommitted file(s) you changed in $(basename "$root"): $(printf '%s\n' "$mine" | head -8 | tr '\n' ' ')")
  fi
fi

# 2. Open PR for the current branch.
if command -v gh >/dev/null 2>&1; then
  branch="$(git branch --show-current 2>/dev/null)"
  default="$(git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@')"
  if [ -n "$branch" ] && [ "$branch" != "${default:-main}" ] && [ "$branch" != "master" ]; then
    pr="$(timeout 8 gh pr view "$branch" --json number,state,url,mergeable,statusCheckRollup 2>/dev/null || true)"
    if [ -n "$pr" ] && [ "$(printf '%s' "$pr" | jq -r '.state')" = "OPEN" ]; then
      num="$(printf '%s' "$pr" | jq -r '.number')"
      url="$(printf '%s' "$pr" | jq -r '.url')"
      checks="$(printf '%s' "$pr" | jq -r '[.statusCheckRollup[]? | (.conclusion // .state // "PENDING")] | group_by(.) | map("\(.[0]):\(length)") | join(" ")')"
      reasons+=("PR #$num is open, not merged ($url; checks: ${checks:-none})")
    fi
  fi
  # Unpushed commits on any branch.
  ahead="$(git rev-list --count '@{upstream}..HEAD' 2>/dev/null || echo 0)"
  [ "$ahead" -gt 0 ] 2>/dev/null && notes+=("$ahead commit(s) not pushed")
fi

if [ "${#reasons[@]}" -gt 0 ]; then
  msg="Definition of done: "
  for r in "${reasons[@]}"; do msg+="$r. "; done
  msg+="Merge it (verify CI, then verify live) or say in one line why it stays open, then stop."
  jq -n --arg r "$msg" '{decision:"block", reason:$r}'
  exit 0
fi
if [ "${#notes[@]}" -gt 0 ]; then
  msg="⏸ "; for n in "${notes[@]}"; do msg+="$n. "; done
  jq -n --arg m "$msg" '{systemMessage:$m, suppressOutput:true}'
fi
exit 0
