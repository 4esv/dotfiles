---
name: terminal-graph
description: >
  Fluency for Terminal Graph — Axel's primary workspace: a macOS canvas app where
  terminals, browsers, notes, and utility nodes are spatial nodes wired together by
  typed ports. Use whenever a task touches the canvas: spawning terminals or agents,
  building project workspaces/clusters, wiring pipelines (grep/jq/gate/delay/webhook),
  moving/resizing/grouping nodes, screenshotting the canvas, or driving a running
  terminal. Trigger words: terminal graph, canvas, node, workspace, spawn a terminal,
  wire, pipeline, blueprint.
---

# Terminal Graph

Canvas app where work is spatial: every terminal, browser, note, and utility is a node
with typed ports. Axel thinks in this space — treat the canvas as the primary UI, not
an afterthought. Nodes you create are things he will look at and touch.

## Connection

- MCP server `terminalgraph` (user scope): `http://127.0.0.1:4930/mcp`, tools appear as
  `mcp__terminalgraph__*`. 25 tools.
- If tools aren't loaded this session (server added mid-session), drive it with raw
  JSON-RPC — it works fine:
  ```sh
  curl -s -X POST http://127.0.0.1:4930/mcp \
    -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" \
    -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"list_nodes","arguments":{}}}'
  ```
  The server is single-session: `initialize` returns "already initialized" — skip it
  and call `tools/call` directly. Image results (screenshots) come back base64 in
  `result.content[].data` — decode to a file.

## Ritual

1. `get_context` FIRST, every time — nodes, frames, connections, groups, focused node.
   Never assume canvas state; the user rearranges things between turns.
2. After ANY layout change (create/move/resize/group): `capture_canvas` and actually
   look at the image. Overlaps, blocked prompts, and error states are only visible there.
3. Clean up after yourself: demo/scratch nodes get deleted when their purpose is served.

## Coordinates & capture

- Canvas is y-UP. A node's frame (x, y) is its LOWER-LEFT corner; same for
  `capture_canvas` regions. Nodes at the same y with different heights align at the bottom.
- `capture_canvas` max 4000 canvas points per dimension; x/y/width/height must be passed
  together for off-screen regions. Renders 1:1 regardless of user zoom.

## Layout doctrine (Axel, 2026-07-16: "windows are too small and crammed")

- Terminals ≥ 900×600; active-work terminals 950×700. Browsers ≥ 1250×900.
- Gutters ≥ 200pt between nodes. Never tile nodes edge-to-edge.
- Group related nodes (`create_group` freeform) so clusters read as one workspace.
- Place new clusters well clear of existing nodes — check frames via `get_context`.

## Port type system (enforced, and the errors teach you)

Compatibility: stream→stream; signal→stream/signal/state; state→stream/signal/state.
**stream→signal is invalid** — bridge with a `collect` node (stream → one signal per
delimiter). Connection errors list the target node's actual ports — read them.

Known ports:
- terminal: `stdout`/`stderr` (stream out), `stdin` (stream in), `text` (signal in),
  `exit` (signal out), `cwd` (state out)
- run: `input` (signal in), `latest`, `output`, `error`, `exit` — NOT stdin/stdout
- collect: `input` (stream in), `output` (signal out)

Terminal output only routes through ports when wrapped: `terminalgraph run <cmd>`
(filter) or `terminalgraph run -o <cmd>` (generator). Plain commands don't emit.

## Node types

Content: `terminal` (command, working_directory), `note` (content), `browser` (url),
`image`/`video`/`editor` (file_path).
Utility: `run` (per-input command; templates: grep/jq/sed/sort/wc/custom), `collect`,
`gate`, `delay` (queue/debounce/throttle), `template` ({{name}} interpolation),
`switch` (regex router), `webhook` (HTTP in), `trigger` (manual/interval),
`file_watcher` (glob → signal).

## Building

- Multi-node builds: ONE `create_workflow` call (nodes + connections + optional group)
  — refs like `"a"`, `"b"` wire connections before real IDs exist. Returns ref→ID map.
  Keep the returned IDs; you need them for move/resize/exec/delete.
- `connect_ports` upserts (reconnecting an edge re-routes it); `waypoints` bends edges.
- `add_project` fails in the global workspace ("can't hold projects") — fall back to
  explicit coords + a group. Project zones only work in project-bound workspaces.
- Blueprints: `capture_blueprint` a proven cluster, `instantiate_blueprint` to stamp
  copies. Configs are captured as-is (paths included) — best for generic shapes.

## Driving terminals

- `exec_in_terminal` writes to stdin, newline auto-appended. Works for answering
  interactive prompts (brew y/n, etc.) — check `capture_canvas` for blocked prompts
  after spawning anything that installs or asks.
- **Agent-in-terminal pattern** (spawning Claude to do delegated work, visibly):
  1. Write a self-contained brief to a file (context, constraints, steps, "stop and
     report if surprised"). Include what NOT to touch (e.g. unrelated dirty git files).
  2. Terminal node: `command: claude "$(cat /path/to/brief.md)"`, working_directory set.
  3. Verify outcomes independently (git log, gh, curl) — don't trust the transcript alone.
- Long waits: background-poll the observable outcome (port open, file exists) rather
  than watching the terminal.

## Known gotchas

- Browser nodes do NOT auto-reload. To refresh after a dead server comes up:
  delete + recreate the node with the same url/frame, then re-add to its group.
- The Claude Code session itself appears as a node — don't exec into or delete it.
- Workspace title "Untitled"/null = the global workspace (no projects allowed).
- `create_workflow` validates before creating — a port error means nothing was made;
  fix and resend the whole call.

## Proven cluster: project workspace

Four nodes, grouped, for "get me working on X": dev-server terminal (or
`zsh bootstrap.sh` if runtime setup is needed), browser on the local port, editor
terminal (`nvim <entry file>`), and a Claude terminal (`claude --continue || claude`).
2×2 grid, browser largest, 200pt gutters. Verify with a screenshot; check the dev
terminal didn't block on a prompt.
