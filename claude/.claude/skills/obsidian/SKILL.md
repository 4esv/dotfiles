---
name: obsidian
description: Conventions for Axel's ~/omni Obsidian vault — naming, frontmatter contract, tags, links, rms, rhizome. Load before reading or writing notes in ~/omni.
---

# obsidian vault skill — ~/omni

second brain. densely networked chaos. structure emerges from connections, not hierarchy.

## vault location

`~/omni`

## rule zero: dumping is free

**A bare note is a finished note.** No frontmatter, no tags, any filename, any
half-thought — dropped at the root and left alone. It is not a draft or a debt.
This is the intended entry path, not a lesser one.

What makes it safe, mechanically:

- **Axel's words are never overwritten.** `author: axel` — or no `author` at all,
  which means the same — makes a note's _body_ off limits to every tool and agent.
  Never rewrite, tidy, condense, or merge it. Append a marked section or write a
  linked note. Ideas and creative writing are the point of the vault; an edit that
  loses them defeats the reason they were written.
- **Everything else is expected to be edited.** Frontmatter, tags, links and
  formatting are maintenance anywhere. Generated output, references, documents,
  transcripts, and any note with an explicit non-Axel `author` should be rewritten
  in place without asking.
- **Creating notes is not modifying notes.** Tools and agents write into the vault
  freely — that is the point of an output place. Bare or complete, never partial.
- **Bare always passes the write-time hook.** The only rejected state is _partial_
  frontmatter — half a contract.
- **Nothing expires.** No auto-archiving, no auto-tagging, no nagging.

When Axel dumps, do not treat it as a task list. Process only what he asks you to.
Never respond to a dump by tidying the vault around it.

## naming

lowercase with spaces. no PascalCase, no kebab-case, no underscores. filenames match titles exactly.

**titles name the thing, not the action**: `axel writing style` not `writing like axel`. `obd-ii protocols` not `how to use obd-ii`. `compensation dossier` not `negotiating my comp`. Nouns over verbs — the title is the name of a concept, not an instruction.

examples: `cfr session 8`, `self admixture results`, `fire district technology proposal`

## structure

flat. no MOCs. no hierarchy.

- root — evergreen knowledge (concepts, references, projects, ideas, meetings, recipes, essays). **all notes live here.**
- `archive/` — finished work, won't revisit
- `meta/` — operational tooling FOR the vault itself: scripts, audit reports of the vault, conventions, attachments. `.txt`/`.html` extensions so obsidian doesn't index them. not a graveyard for past-relevance notes.
- `rms/` — the relationship layer (people, orgs, engagements, assets). the one sanctioned subfolder of real notes: on the graph, linked into the root, isolated so the root stays axel's. see "rms" below.
- `.claude/CLAUDE.md` — the schema doc that lives in the vault, so a session landing in `~/omni` gets the rules even without invoking this skill. It sits in `.claude/` rather than the vault root because obsidian never indexes dot-directories: the vault root is Axel's, and only `.md` notes belong there.

**session/task docs that served their purpose get deleted, not moved.** A pre-meeting brief after the meeting happened, a one-time audit of a non-vault thing, a transient analysis — once they've done their job, they're clutter. delete. the only session-shaped things that go in `meta/` are vault-meta artifacts (audits OF the vault, conventions, scripts).

navigation is via tags, search, and graph. **no indexes** — a file that links to every note becomes a gravitational pole that distorts the graph and hides the natural cluster topology. axel tried it; it ruined the graph view. to verify a wikilink target exists, use `ls ~/omni | grep -i "candidate name"` (or obsidian-cli, or rhizome).

## file extensions

- `.md` — actual notes only
- `.txt` or `.html` — operational files (conventions, changelogs, reports, scripts) so obsidian doesn't index them

## frontmatter & the janitor

raw notes are bare — no frontmatter. axel dumps them. **the janitor** (Windmill `axel` workspace, `f/vault/janitor`, every 5 min against the headless-synced vault) adds frontmatter and links once a note has sat unchanged for two ticks. presence of frontmatter means processed; there is no `status` field any more.

**rule**: half-assed frontmatter is worse than no frontmatter. either bare or complete — never partial.

a processed note has:

- `tags:` — one `type/`, 1–3 topic tags, and an `area/` only when one genuinely fits
- `ent:` — optional; who owns the work (see below)
- `created:` — YYYY-MM-DD
- `author:` — `axel` | `claude` | `bookmark` | `mixed`
  - `bookmark` notes also set `source: <url>`
  - `claude` notes also set `source: claude:<context>` (date or session)
- `processed:` — YYYY-MM-DD, set by the janitor

**weekly maintenance** (`f/vault/maintenance`, Sundays 20:00) reports broken wikilinks with a suggested target, contract drift, stale bare notes, missing embeds, and gives up to 20 orphans a judged `see also:` line; report in `meta/audits/<date>-maintenance.txt`, summary on Telegram. Fix broken links by hand from that report; it never guesses a target.

the janitor only judges what cannot be computed: type (among six), area, topics, ent (only when an entity keyword fired), which of the nearest notes deserve a `see also:`, and a title for files literally named `Untitled`. everything else is computed. it renames only `Untitled*`. a new topic tag can only appear as a suggestion in the nightly Telegram digest; accept it by editing `TOPICS` in the janitor and this list together.

**hard rule for claude**: when `author: axel`, claude does not rewrite the body of the note. options are (a) append a `## claude's notes` section at the bottom, or (b) create a separate concept note that links back. preserves attribution. prevents the vault from drifting into ai-synthesized prose indistinguishable from axel's claims — load-bearing for succession-readiness and for hallucination containment when claude later re-ingests its own output as if it were authoritative source.

## tags

every processed note gets one `type/` tag and 1–3 topic tags. `area/` and `ent:` are optional and mean different things: area is what the note is *about*, ent is who *owns the work*. entities are not areas.

### area/ (domain of thought — what it is about)

- `area/technology`
- `area/ems` — axel's own emergency-medicine study and practice (his, not the district's)
- `area/music`
- `area/philosophy`
- `area/finance`

no default. a note about cooking or a dog crate has no area. never `area/personal`.

### ent: (who owns the work — optional, reserved for rms entities)

`koskinens` | `metf` | `enfield fire district` | `cornell`. set only when the note *is work for* that entity: a feature, an issue, a deliverable, a meeting, a proposal. venting about koskinen's is not owned by koskinen's; a web feature for koskinen's is. anything done for the district gets `ent: enfield fire district`; axel's ems notes do not. cornell joins the list because its tracking is moving here out of Notion.

### type/ (what kind of note)

- `type/reference` — knowledge that could be looked up
- `type/idea` — something not yet built
- `type/essay` — prose written to think
- `type/doc` — a deliverable, spec, contract
- `type/project` — work with a start and an end
- `type/course` — study or session notes
- `type/meeting`, `type/log`, `type/recipe`, `type/clipping` — keyword-detected by the janitor, not judged

`certification` folded into `doc`, `book` into `reference`, `note` retired.

### topic tags (flat)

closed list, what the note is about at finer grain, 1–3 per note:
`code`, `tooling`, `ai`, `web`, `writing`, `fiction`, `genetics`, `health`, `career`, `cooking`, `making`, `automotive`, `audio`, `quant`, `people`, `home`

### tag rules

- every note: one `type/` + 1–3 topics; `area/` only when it fits; `ent:` only when owned
- no hex color codes, no duplicate tags, no tags that duplicate structure
- new `area/` only for a new domain of thought, new `ent` only for a new rms org
- a new topic enters through the janitor's digest suggestion, then `TOPICS` in `f/vault/janitor.py` and this list, in the same change
- no one-off tags, no `status`

## links

dense. every note links to related notes directly. no intermediary index pages.

- cluster-level density: notes within a topic area should be richly interlinked
- cross-cluster links only for genuine conceptual bridges
- prefer inline links where the target name appears naturally in text
- use `see also:` sections for related notes that don't fit inline
- never write a `[[wikilink]]` to a note that doesn't exist. check with `ls ~/omni | grep -i "candidate name"` first. if uncertain, use plain text with a `<!-- candidate-link: concept -->` marker for later promotion. fabricated wikilinks become orphan-pointer rot.

## key entities

- **koskinen's towing & repair** — axel's wife savannah's tow business in ithaca, ny. also a consulting client. `ent: koskinens`
- **metf** — transparency-first portfolio construction tool. startup project. `ent: metf`
- **cornell university** — axel's employer (systems integrator, college of human ecology). `ent: cornell`
- **enfield fire district / evfc** — volunteer fire service, multiple roles. `ent: enfield fire district` (axel's own ems study is `area/ems`, not the district's)

## rms (people · customers · engagements · renewals)

`rms/people/ orgs/ engagements/ assets/`. schema + rules in `rms/rms schema.md`, live views in `rms/rms.base`, tool `rms` (= `omni rms`, `meta/scripts/rms.py`, stdlib python, also deployed to the hermes box as `~/.local/bin/rms`).

- **before any customer work** — "let's keep working on that thing for koskinen's" — run `rms context <query>`: stakeholders, stage, rate, next action, log tail, upcoming dates. don't work from memory.
- `rms status` (one line; also the SessionStart hook), `rms upcoming [--days N]`, `rms stale`, `rms pipeline`, `rms find <q>`.
- write through the tool: `rms touch <q> -m "…"`, `rms next <q> "…" --due YYYY-MM-DD`, `rms stage <q> <stage>`, `rms log <q> "…"`, `rms new person|org|engagement|asset NAME …`. pass `--by claude`. it edits only the touched frontmatter key and appends to `## log`, which is why it is safe on `author: axel` notes.
- rms notes carry the vault contract **plus** `kind:`; dates `YYYY-MM-DD` (year unknown → 1900); flat frontmatter; link fields are `"[[wikilinks]]"` to notes that exist. `rms check` is the write hook inside `rms/` (bare notes are rejected there — the opposite of the root).
- `## status` on an engagement is meant to be rewritten (one paragraph, present tense). everything else follows the author rule.
- never invent people, dates, allergies, rates. a name mentioned once is not an entity — ask before `rms new person`.

## rhizome (semantic backlink generator)

installed at `~/Code/forks/rhizome`. generates `## Related Notes` sections using local ONNX inference. no cloud, no APIs.

config: `~/Code/forks/rhizome/.env`

### commands (run from `~/Code/forks/rhizome`)

```
rhizome status        # vault stats + model cache status
rhizome audit         # analyze connectivity, suggest links (read-only)
rhizome run           # generate links (shows dry-run preview first)
rhizome run --yes     # skip confirmation
rhizome clean         # remove all generated Related Notes sections
rhizome backups       # list available backups
rhizome restore       # interactively restore a backup
rhizome download-model  # pre-cache the ONNX model
```

all commands support `--verbose`.

### settings

| var                  | value            | notes                            |
| -------------------- | ---------------- | -------------------------------- |
| VAULT_PATH           | /Users/axel/omni | absolute path                    |
| VAULT_APP            | obsidian         |                                  |
| SIMILARITY_THRESHOLD | medium (0.75)    | low=0.60, medium=0.75, high=0.88 |
| TOP_K                | 5                | max related notes per file       |
| EXCLUDE_DIRS         | meta, .obsidian  | skipped during indexing          |

### workflow

1. `rhizome audit` — see what would change
2. `rhizome run` — review dry-run, confirm
3. if something goes wrong: `rhizome restore`

never run `rhizome run` without axel's explicit go-ahead.

## official skills (use these for mechanics)

kepano's `obsidian-skills` plugin handles the format and tooling layer. defer to those skills for:

- **obsidian-markdown** — wikilinks, embeds, callouts, properties/frontmatter
- **obsidian-cli** — backlinks, aliases, append, vault-aware ops via `/Applications/Obsidian.app/Contents/MacOS/obsidian`
- **defuddle** — pulling web pages into clean markdown for clipping
- **obsidian-bases**, **json-canvas** — for those file types

this skill stays focused on _what's specific to ~/omni_: conventions, taxonomy, entities, rhizome.

## tagging clippings (vault-specific)

when defuddle pulls a web page into the vault, it becomes a note with `type/clipping`. pair it with an area:

| subject                               | area             | topic (optional) |
| ------------------------------------- | ---------------- | ---------------- |
| pkm, productivity, general tech       | `area/personal`  | `tech`           |
| automotive, diagnostics, OBD          | `area/koskinens` | `automotive`     |
| firefighting, EMS, ICS, grants        | `area/fire`      |                  |
| portfolio theory, quant, finance      | `area/metf`      | `quant`          |
| cornell, higher ed, systems           | `area/cornell`   |                  |
| music theory, production, instruments | `area/music`     | `audio`          |

if subject is unclear, default to `area/personal` and ask before saving. don't invent new area or topic tags for one-off captures. clippings start `status: raw` until triaged. unlinked clippings are dead weight — either add `[[wikilinks]]` to related notes or archive them.

## when working in this vault

1. read this skill first for ~/omni-specific rules
2. follow naming conventions (lowercase with spaces, match title exactly)
3. raw notes (bare, no frontmatter) are intentional — axel dumps; claude processes. when you process, apply the full contract (tags + status + created + author + source-where-applicable) or leave it bare. never half-assed.
4. when `author: axel`, do not rewrite the body — append `## claude's notes` or create a linked note
5. never write `[[wikilinks]]` to non-existent notes (creates orphan-pointer rot)
6. link densely, inline where the target name appears naturally
7. operational files get .txt/.html, not .md
8. don't create MOCs, index pages, or new folders (`rms/` is the one sanctioned subfolder; entities go in via `rms new`)
9. don't run `rhizome run` without asking
10. before writing a new note, check `ls ~/omni/ | grep -i "candidate name"` for collision — prefer appending to an existing note over creating a duplicate
11. defer to obsidian-skills plugin (obsidian-markdown, obsidian-cli, defuddle, obsidian-bases, json-canvas) for format and tooling mechanics
