#!/usr/bin/env bash
# Status line: model · dir · context size of the current conversation.
# Context = input + cache tokens of the last main-thread reply in the transcript.
# NOTE: past ~150k the session is soup; /clear and restart from a short summary.
input="$(cat)"
model="$(printf '%s' "$input" | jq -r '.model.display_name // "?"')"
dir="$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // ""')"
tp="$(printf '%s' "$input" | jq -r '.transcript_path // empty')"
ctx=""
if [ -f "$tp" ]; then
  ctx="$(tail -n 400 "$tp" | jq -rs '
    [.[] | select(.type == "assistant" and (.isSidechain | not) and .message.usage)]
    | last | .message.usage
    | ((.input_tokens // 0) + (.cache_read_input_tokens // 0) + (.cache_creation_input_tokens // 0))
    // empty' 2>/dev/null)"
fi
line="$model · ${dir/#$HOME/~}"
if [ -n "$ctx" ] && [ "$ctx" -gt 0 ] 2>/dev/null; then
  k=$((ctx / 1000))
  if [ "$k" -ge 150 ]; then line="$line · ctx ${k}k ⚠ /clear"; else line="$line · ctx ${k}k"; fi
fi
printf '%s' "$line"
