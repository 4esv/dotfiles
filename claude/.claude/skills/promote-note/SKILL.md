---
name: promote-note
description: Promote a raw vault note (bare, no frontmatter — or a partially-tagged `status: raw` note) into a fully-processed note with the complete ~/omni frontmatter contract and verified wikilinks. Use when Axel drops a raw note or a clipping is awaiting triage. Surfaces decisions; never acts silently.
---

# /promote-note — raw → processed

A raw note is bare: no frontmatter. This skill takes one (or a batch) and produces a fully processed note matching the `~/omni` contract. It is the worry-free side of "dump and forget" — Axel writes; you process.

## input

- A specific file path (e.g. `~/omni/some new idea.md`), OR
- A batch invocation — find raw notes via:
  - `find ~/omni -maxdepth 1 -name '*.md' -not -path '*/meta/*' -size +0` and filter to those without an opening `---` line (bare = raw)
  - PLUS `grep -l '^status: raw$' ~/omni/*.md` for partially-processed `status: raw` notes

## workflow

For each raw note:

### 1. read

Read the full body. Don't skim — author/source decisions depend on knowing what's there.

### 2. determine `author` and `source`

- Hand-written by Axel → `author: axel`. No source (or `source: axel:hand` if you want to be explicit).
- Clipping from Obsidian Web Clipper → `author: bookmark`. Preserve the existing `source:` URL field.
- You (Claude) synthesized the content from other vault notes → `author: claude`, `source: claude:<YYYY-MM-DD>`.
- Axel and Claude both contributed substantive content → `author: mixed`.

If uncertain, default to `author: axel` (most conservative — it locks Claude out of rewriting the body, which is the safer error).

### 3. infer `area/` and `type/` tags

Read the body for signal. Match against the taxonomy in the `obsidian` skill:

**Areas:** `area/personal` (default catchall), `area/metf`, `area/koskinens`, `area/fire`, `area/cornell`, `area/music`.

**Types:** `type/reference` (knowledge card, lookup, data), `type/doc` (deliverable, spec, contract), `type/meeting`, `type/idea` (not yet built), `type/essay` (creative prose), `type/project`, `type/course`, `type/certification`, `type/log` (time-stamped record), `type/recipe`, `type/clipping`, `type/book`, `type/note` (catchall — use sparingly, ≤6 vault-wide).

**Topic tags** (optional, only when cross-cutting): `automotive`, `genetics`, `philosophy`, `tech`, `web`, `bqn`, `quant`, `rust`, `audio`, `statistics`.

Never invent new `area/` or `type/` tags. Never invent a new topic tag for a single note.

### 4. determine `status`

- `processed` — default for triaged content
- `active` — in-progress work
- `idea` — unbuilt concept
- `evergreen` — reference card meant to be perpetually maintained
- `finished` — deliverable that's done
- `raw` — leave this only if you're explicitly deferring full processing

### 5. find verified wikilink candidates

Search for related existing notes:

```bash
# by area or type
grep -l 'area/<X>' ~/omni/*.md
grep -l 'type/reference' ~/omni/*.md

# by keyword from the body
grep -li '<keyword>' ~/omni/*.md
```

**Verify every link target exists before writing.** Use `ls ~/omni | grep -i "<name>"`. If a concept comes up that has no existing note, write it as plain text with `<!-- candidate-link: concept -->` so it can be promoted later when the anchor is written.

Aim for 2-5 wikilinks. Inline them where the target name appears naturally in the prose; collect the rest into a `see also:` section if there's no natural anchor.

### 6. apply the frontmatter

Insert at the top of the file:

```yaml
---
tags:
  - area/<X>
  - type/<Y>
  - <topic>  # optional
status: <X>
created: YYYY-MM-DD
author: <axel|claude|bookmark|mixed>
source: <axel:hand | url | claude:date>  # when applicable
---
```

### 7. apply wikilinks to the body

For **`author: axel`** notes: do NOT rewrite the body. Only insert `[[wikilinks]]` where the target names already appear in the prose. If you'd need to restructure or add prose to make links work, add a `## claude's notes` section at the bottom with your synthesis + links there instead.

For **`author: claude`** notes you're creating from scratch (e.g., a synthesized reference card): write the body fully, including a `## Synthesized from` section at the bottom that lists the source `[[wikilinks]]` (so any claim can be traced back to its origins — load-bearing for succession-readiness and hallucination containment).

### 8. surface for review

Report what you changed: file path, decided `author`, tags assigned, wikilinks added, status set. If anything was ambiguous (area tag uncertain, candidate link to a non-existent concept, big restructure needed for an `author: axel` note), say so explicitly so Axel can flip it.

## what you do NOT do

- Don't auto-promote without surfacing decisions.
- Don't infer `area/` tags from filename alone — read the body.
- Don't add frontmatter fields outside the contract (tags, status, created, author, source). Resist field sprawl.
- Don't fabricate wikilinks. Verify or stage as `<!-- candidate-link: concept -->`.
- Don't rewrite `author: axel` bodies. Append `## claude's notes` or create a separate linked note.
- Don't run `rhizome run` (audit is fine if requested).
- Don't create folders.

## anti-patterns

- **Half-processed:** tags but no status, or frontmatter but no `author`. Either complete or bare — never partial.
- **Pre-emptive promotion:** a clipping from Web Clipper gets promoted before Axel has read it. Promotion is deliberate, not automatic. "What caught Axel's attention" is a real signal.
- **Folder creation:** never create new folders in `~/omni`.
- **MOCs and indexes:** don't create them. The graph is the navigation.
- **Author overconfidence:** when in doubt, prefer `author: axel`. It's the conservative default — it locks Claude out of body rewrites. Flipping to `author: claude` later is cheap; flipping the other way after Claude has rewritten history is impossible.
