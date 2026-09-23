#!/usr/bin/env bash
# PreToolUse(Bash): refuse `gh pr merge` unless every check on that PR has passed.
# NOTE: GitHub can't enforce required checks on free private repos, so this gate lives client-side.
in=$(cat)
cmd=$(jq -r '.tool_input.command // ""' <<<"$in")
# Only a segment that starts with the command counts; the words inside a commit message don't.
starts='^[[:space:](!{]*([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]+)*gh[[:space:]]+pr[[:space:]]+merge([[:space:]]|$)'
grep -qE 'gh[[:space:]]+pr[[:space:]]+merge' <<<"$cmd" || exit 0
cd "$(jq -r '.cwd // "."' <<<"$in")" 2>/dev/null || true
deny() { jq -n --arg r "merge gate: $1" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'; exit 0; }
# Check every `gh pr merge` segment of a chained command on its own.
while IFS= read -r seg; do
  grep -qE "$starts" <<<"$seg" || continue
  args=$(sed -E 's/.*gh[[:space:]]+pr[[:space:]]+merge//; s/[[:space:]]*[)}]+[[:space:]]*$//' <<<"$seg")
  grep -q '\$' <<<"$args" && deny "can't resolve shell variables in '$seg'; write the PR and repo literally."
  repo=$(grep -oE -- '(-R|--repo)[= ]+[^ ]+' <<<"$args" | head -1 | sed -E 's/^(-R|--repo)[= ]+//')
  # PR selector: first non-flag token that isn't the -R value; empty means current branch
  pr=$(sed -E 's/(-R|--repo)[= ]+[^ ]+//' <<<"$args" | tr ' ' '\n' | grep -vE '^(-|$)' | head -1 | tr -d "\"'")
  out=$(gh pr checks $pr ${repo:+-R "$repo"} --json name,bucket 2>&1)
  if ! jq -e . >/dev/null 2>&1 <<<"$out"; then
    grep -qi 'no checks' <<<"$out" && continue   # repo without CI: nothing to gate on
    deny "could not read checks for ${repo:+$repo }${pr:-current branch} ($out)"
  fi
  bad=$(jq -r '[.[] | select(.bucket != "pass" and .bucket != "skipping") | "\(.name)=\(.bucket)"] | join(", ")' <<<"$out")
  [ -n "$bad" ] && deny "checks not green on ${repo:+$repo }PR ${pr:-current}: $bad. Wait (gh pr checks --watch) or fix the failure first."
done < <(sed -E 's/(&&|\|\||;|\|)/\n/g' <<<"$cmd")
exit 0
