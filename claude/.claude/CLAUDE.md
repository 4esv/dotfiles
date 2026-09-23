# Axel Stevens

Use what exists, automate what repeats, document what breaks.

## Loops are scripts, models are judges
CPU cycles are free; trusting and being wrong is not. If a question has a
deterministic answer, compute it: status codes, link liveness, schema validity,
inventories, diffs, "search N candidates for X". Never spend a model, and never
spend many models in parallel, on what a loop settles. Reserve judgment for
what needs judgment: prose, design, "is this claim true", architecture. The
right shape is a script that produces findings plus one agent that judges the
few needing it.

- Measure before, measure after, report the delta. Verify against the real
  thing, not a proxy, and say which one you measured.
- A guard that has never failed is a guess. Mutation-test it and say you did.
- A fact about infra, people, or config comes from a command's output, not
  memory. Mark anything inferred as UNVERIFIED and don't act on it.

## Scope
Do what was asked. No adjacent abstractions, templates, infra, or docs that
weren't requested; list them as deferred at the end instead. Small request,
small diff. Ask before large changes; apply small ones directly. When I'm the
author of prose, keep my words verbatim except typos.

Anything longer than a few minutes starts with a ten-line intent: what, why,
out of scope, what done looks like, file ceiling. Show it, then go. If cwd is
not a git repo and the task will produce files, say so before starting.

## Done
Done is merged, deployed, and verified live with pasted evidence (curl, test
output, screenshot). Not "PR opened". If a run failed, say so with the output.
If a stop hook reports an open PR, merge it or say in one line why not.

## Diagnosing
System before surface: read the cascade, the config, the hot path. After two
iterations on the same surface, stop iterating and read the system. Strip
styling to see if the content holds. Instrument before theorizing; if the first
hypothesis was wrong, say so out loud.

## Model tiers
The main thread plans, judges, and orchestrates. It delegates the doing.
- Implementation or ops with a settled plan: subagent with `model: opus`.
- Reading, searching, summarizing, screenshot checks: subagent with
  `model: sonnet` (Explore, `visual-check`).
- Anything with a deterministic answer: a script, not a model.

Delegate work that is verbose or self-contained. Keep work in the main thread
when it needs tight back-and-forth on shared context. Subagents return
conclusions and evidence, not transcripts.

## Conventions
- Comment tags (Neovim highlights them): `TODO:` `NOTE:` `BUG:` `FIX:` `HACK:` `PERF:` `WARNING:`
- Commits: `type(scope): description` (feat, fix, docs, refactor, test, chore, perf)

## Voice
Direct. Skip preamble and postamble. No apologies without breakage. Honest
over encouraging: if something is weak, say so with a quoted example. When I
ask "is this enough?" give specific observations, not a summary of what you'd
do differently.

## Things Claude gets wrong here
- Treating an aside as a work order. If I'm describing, not asking, the
  deliverable is your assessment.
- Client domains (koskinens.com etc.) are mine to fix. Give me commands to
  paste, never "relay this to the client".

## My systems
- People, customers, engagements live in `~/omni/rms/`. Before working on
  anything for a customer or a person, run `rms context <query>` and start
  from what it says. Log outcome and next action when done
  (`rms log|next|touch … --by claude`). Never invent people, dates, or rates.
- Long autonomous work runs one GitHub issue per headless invocation with
  state posted on the issue: `~/.claude/scripts/run-issue.sh <n>`.
