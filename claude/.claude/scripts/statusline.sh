#!/bin/bash
# Claude Code Status Line
# Displays: project/subdir on branch [dirty] [ahead/behind]

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
project=$(echo "$input" | jq -r '.workspace.project_dir')

# Colors (ANSI)
CYAN='\033[36m'
GREEN='\033[32m'
MAGENTA='\033[35m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

# Directory display
if [ "$cwd" = "$project" ]; then
    dir=$(basename "$cwd")
else
    project_name=$(basename "$project")
    subdir=$(realpath --relative-to="$project" "$cwd" 2>/dev/null || echo "${cwd#$project/}")
    dir="${project_name}/${subdir}"
fi

# Git info
git_info=""
if git -C "$cwd" --no-optional-locks rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || echo "detached")
    
    # Check for uncommitted changes
    dirty=""
    if ! git -C "$cwd" --no-optional-locks diff --quiet 2>/dev/null || \
       ! git -C "$cwd" --no-optional-locks diff --cached --quiet 2>/dev/null; then
        dirty=" ${YELLOW}*${RESET}"
    fi
    
    # Check ahead/behind
    upstream=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
    ahead_behind=""
    if [ -n "$upstream" ]; then
        ahead=$(git -C "$cwd" --no-optional-locks rev-list --count '@{upstream}..HEAD' 2>/dev/null || echo 0)
        behind=$(git -C "$cwd" --no-optional-locks rev-list --count 'HEAD..@{upstream}' 2>/dev/null || echo 0)
        [ "$ahead" -gt 0 ] && ahead_behind=" ${GREEN}↑${ahead}${RESET}"
        [ "$behind" -gt 0 ] && ahead_behind="${ahead_behind} ${RED}↓${behind}${RESET}"
    fi
    
    git_info=" on ${MAGENTA}${branch}${RESET}${dirty}${ahead_behind}"
fi

printf "${CYAN}%s${RESET}${git_info}" "$dir"
