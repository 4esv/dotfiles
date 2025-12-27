# Autonomous

Work autonomously on: $ARGUMENTS

## Setup Phase
1. Create a `TODO.md` file with a checklist of all tasks needed
2. Each task should be a checkbox: `- [ ] task description`
3. Break down the work into small, atomic steps
4. Include a final task: `- [ ] Create PR with gh pr create`

## Work Phase
Work through each task in TODO.md sequentially:
1. Complete the task
2. Mark it done: `- [x] task description`
3. Commit the changes with a descriptive message
4. Move to the next unchecked task

## Rules
- Do NOT ask for confirmation between tasks
- Do NOT stop until all tasks are checked off
- If you hit an error, add a new task to fix it and continue
- Keep commits atomic and focused
- Run tests if they exist before marking tasks complete

## Completion
When all tasks are complete:
1. Push the branch
2. Create a PR with `gh pr create`
3. The stop hook will see no remaining tasks and let you stop
4. I'll get a Clawd notification that you're done

Begin by creating the TODO.md with your task breakdown.
