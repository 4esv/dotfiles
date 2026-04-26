# obsidian vault skill — ~/omni

second brain. densely networked chaos. structure emerges from connections, not hierarchy.

## vault location

`~/omni`

## naming

lowercase with spaces. no PascalCase, no kebab-case, no underscores. filenames match titles exactly.

examples: `cfr session 8`, `self admixture results`, `fire district technology proposal`

## structure

flat. no MOCs. no hierarchy.

- root — everything lives here
- `archive/` — finished work, won't revisit
- `meta/` — templates, scripts, reports, conventions

navigation via tags, search, and graph. never indexes.

## file extensions

- `.md` — actual notes only (and templates, since templater needs them)
- `.txt` or `.html` — operational files (conventions, changelogs, reports, scripts) so obsidian doesn't index them

## tags

every note gets at least one `area/` tag and one `type/` tag.

### area/ (which domain)

- `area/personal` — default catchall
- `area/metf` — metf startup
- `area/koskinens` — koskinen's towing & repair
- `area/fire` — fire district, evfc, firefighting/ems
- `area/cornell` — cornell employment + degree
- `area/music` — production, theory, instruments, album work

### type/ (what kind of note)

- `type/reference` — knowledge cards, concepts, lookups, data
- `type/doc` — documents, deliverables, specs, contracts
- `type/meeting` — meeting notes
- `type/idea` — something not yet built
- `type/essay` — creative writing, prose
- `type/project` — active or past project
- `type/course` — course material, session notes
- `type/certification` — cert or qualification record
- `type/log` — time-stamped records
- `type/recipe` — cooking
- `type/clipping` — captured from elsewhere
- `type/book` — book notes
- `type/note` — genuine catch-all (use sparingly, <=6 notes)

### topic tags (flat)

no nesting. use sparingly for genuine cross-cutting themes:
`automotive`, `genetics`, `philosophy`, `tech`, `web`, `bqn`, `quant`, `rust`, `audio`, `statistics`

### tag rules

- every note: at least one `area/` + one `type/`
- no hex color codes, no duplicate tags, no tags that duplicate structure
- new `area/` tags only for major life domains (new job, new client)
- new topic tags only when a cross-cutting theme spans multiple notes
- no one-off tags

## status lifecycle

depends on note type:

| type | lifecycle |
|---|---|
| fleeting (meetings, captures) | `raw` → `processed` or `archive` |
| ideas and concepts | `idea` → `active` → `living` |
| documents and deliverables | `raw` → `active` → `finished` |
| evergreen reference | `evergreen` (perpetually maintained) |

`raw` replaces the old inbox concept. new stuff starts as `raw`, gets triaged from there.

## links

dense. every note links to related notes directly. no intermediary index pages.

- cluster-level density: notes within a topic area should be richly interlinked
- cross-cluster links only for genuine conceptual bridges
- prefer inline links where the target name appears naturally in text
- use `see also:` sections for related notes that don't fit inline

## key entities

- **koskinen's towing & repair** — axel's wife savannah's tow business in ithaca, ny. also a consulting client. `area/koskinens`
- **metf** — transparency-first portfolio construction tool. startup project. `area/metf`
- **cornell university** — axel's employer (systems integrator, college of human ecology). `area/cornell`
- **enfield fire district / evfc** — volunteer fire service, multiple roles. `area/fire`

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

| var | value | notes |
|---|---|---|
| VAULT_PATH | /Users/axel/omni | absolute path |
| VAULT_APP | obsidian | |
| SIMILARITY_THRESHOLD | medium (0.75) | low=0.60, medium=0.75, high=0.88 |
| TOP_K | 5 | max related notes per file |
| EXCLUDE_DIRS | meta, .obsidian | skipped during indexing |

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

this skill stays focused on *what's specific to ~/omni*: conventions, taxonomy, entities, rhizome.

## tagging clippings (vault-specific)

when defuddle pulls a web page into the vault, it becomes a note with `type/clipping`. pair it with an area:

| subject | area | topic (optional) |
|---|---|---|
| pkm, productivity, general tech | `area/personal` | `tech` |
| automotive, diagnostics, OBD | `area/koskinens` | `automotive` |
| firefighting, EMS, ICS, grants | `area/fire` | |
| portfolio theory, quant, finance | `area/metf` | `quant` |
| cornell, higher ed, systems | `area/cornell` | |
| music theory, production, instruments | `area/music` | `audio` |

if subject is unclear, default to `area/personal` and ask before saving. don't invent new area or topic tags for one-off captures. clippings start `status: raw` until triaged. unlinked clippings are dead weight — either add `[[wikilinks]]` to related notes or archive them.

## when working in this vault

1. read this skill first for ~/omni-specific rules
2. defer to obsidian-skills plugin for markdown format, CLI, and clipping mechanics
3. follow naming conventions (lowercase with spaces, match title exactly)
4. tag every note (area/ + type/, no exceptions)
5. link densely, inline where the target name appears naturally
6. operational files get .txt/.html, not .md
7. don't create MOCs, index pages, or new folders
8. don't run `rhizome run` without asking
9. before writing a new note, check `ls ~/omni/ | grep -i "candidate name"` for collision — prefer appending to an existing note over creating a duplicate
