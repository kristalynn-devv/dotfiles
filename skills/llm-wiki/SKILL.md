---
name: "llm-wiki"
description: "Build and keep a project's LLM-maintained knowledge wiki (Karpathy's LLM Wiki pattern), kept centrally in the advisor repo (~/WORK/advisor/wiki/<project>/): raw sources stay untouched, the agent writes and updates interlinked markdown pages, an index and a log. Use when the user asks to start a wiki, add/ingest a source into it, ask the wiki a question, or health-check it (wiki, LLM wiki, ingest, เพิ่มเข้า wiki, สรุปเข้า wiki, ถาม wiki, เช็ค wiki, /llm-wiki), and when the advisor answers a question about what a project's wiki covers. Works for any project."
---

# LLM Wiki

Source: Karpathy, "LLM Wiki" (gist 442a6bf555914893e9891c11519de94f). The wiki is a persistent, compounding
artifact: each source is read once and folded into pages that are kept current, instead of re-retrieved from raw
files on every question. The user curates sources and asks questions; the agent does all the writing and
bookkeeping.

## Where the wiki lives

All project wikis live together in the advisor repo (`$ADVISOR_ROOT`, default `~/WORK/advisor`), one folder per
project: `$ADVISOR_ROOT/wiki/<project>/`, the name from the `wiki` column of `$ADVISOR_ROOT/projects.md`. Decided by the
user 2026-11-28 (advisor workflow, "ใช่ทั้งหมด").

- Called from a project session: find the project's row in `projects.md` by its repo path and use that folder. A project
  not listed yet → add its row (repo, origin default, base "repo rules", wiki = repo folder name in kebab-case).
- No advisor repo on this machine, or the repo already has its own `wiki/` folder → use `<project root>/wiki/`.
- Writes land in the advisor repo, not the project repo; the advisor commits them (GIT.md).

## Layout (per wiki)

```
<wiki folder>/
  SCHEMA.md     this wiki's own conventions: domain, page types, what to emphasise (co-evolved with the user)
  index.md      catalog: every page, one line each, grouped by type
  log.md        append-only timeline of ingests, queries filed back, lint passes
  raw/          sources as given: articles, notes, exports, images (raw/assets/) — never edited
  pages/        everything the agent writes: sources/, entities/, concepts/, analyses/, overview.md
```

- `SCHEMA.md` holds the domain rules, not the project's `CLAUDE.md`, so the always-loaded context stays small. Read it
  before every operation.
- Paths below (`raw/`, `pages/`, `index.md`, `log.md`) are relative to the wiki folder.

## Operations

### init (no wiki yet)

1. Ask in one question what the wiki is about and which page types matter, with a pick (entities + concepts + sources).
2. Create the layout above. `SCHEMA.md`: domain, page types, page template, naming (`kebab-case.md`), link style
   (relative markdown links, so it reads in any viewer and in Obsidian), language of the pages (the user's language).
3. First `log.md` entry.

### ingest (a new source)

1. Put the source in `raw/` as given (copy a file, save a URL's text as markdown with the URL and fetch date at the
   top). Never edit it afterwards.
2. Read it fully. Tell the user the 3–5 key takeaways in a few lines; follow their steer on what to emphasise.
3. Write `pages/sources/<name>.md`: summary, key claims, link to the raw file.
4. Update every entity and concept page the source touches (create missing ones). Typically 5–15 pages. Where the new
   source contradicts a page, keep both claims, each with its source, and mark it `> Contradiction:` on that page.
5. Update `pages/overview.md` if the overall picture moved, `index.md` for every new or renamed page.
6. Append to `log.md`: `## [YYYY-MM-DD] ingest | <source title>` + one line per page touched.

One source at a time unless the user asks for a batch.

### query

1. Read `index.md` first, then only the pages it points to. Go to `raw/` only when a page lacks the detail.
2. Answer with links to the pages (and sources) each claim came from. Say plainly what the wiki does not cover.
3. An answer worth keeping (comparison, analysis, a connection found) → offer to file it as `pages/analyses/<name>.md`,
   link it from related pages and `index.md`, log `## [YYYY-MM-DD] query | <question>`.

### lint (health check)

Report, then fix what the user approves: contradictions between pages, claims superseded by newer sources, orphan
pages (no inbound links), concepts mentioned on several pages without their own page, missing cross-links, broken
links, pages missing from `index.md`, gaps worth a new source or question. Log `## [YYYY-MM-DD] lint | <summary>`.

## Rules

- `raw/` is read-only after a source lands. Pages are the agent's; the user reads them.
- Every claim on a page traces to a source page or a raw file. Interpretations are labelled as such.
- Never put credentials, tokens, connection strings or personal data from a source into a page; note "redacted" instead.
- Log lines start with `## [YYYY-MM-DD] <op> |` so `grep "^## \[" wiki/log.md | tail` works.
- Committing the wiki follows the repo it lives in (the advisor repo by default) and GIT.md; this skill does not commit.
- Past a few hundred pages, `index.md` alone gets slow: suggest a local search tool (e.g. qmd) instead of building one
  unasked.
