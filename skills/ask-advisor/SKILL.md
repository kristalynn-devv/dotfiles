---
name: "ask-advisor"
description: "From a project session, bring a problem, a research question or a piece of work to the advisor session (~/WORK/advisor), which keeps every project's wiki and memory and sends work to workers (Cursor, Claude). Use when the engineer says to ask / consult / send to the advisor (ถาม advisor, ปรึกษา advisor, ส่งให้ advisor, ส่ง worker, /ask-advisor), when a question needs research or the project's past knowledge beyond this repo, and when work is medium to large (several files or layers, migration, money / security / user data, design question)."
---

# ask-advisor — the project session's line to the advisor

The workflow, set by the user 2026-11-28: the engineer gives orders in a project session; the advisor (its own repo,
`~/WORK/advisor`, skill `advisor`) holds each project's wiki and memory, researches, sends work to workers and checks
and merges what they return.

## What goes to the advisor, what stays here

- **Stays here**: questions this repo answers (code, its HANDOFF, docs), and small work with every decision made
  (about 1–3 files, no migration, no money / security / user data, no design choice) — built here (`~/.claude/CLAUDE.md` › Working rules 10).
- **Goes to the advisor**:
  - a question that needs research, or what the project knew or decided before (the wiki, past sessions);
  - medium to large work, or unsure of the size: the advisor slices it and sends it to Cursor or a worker session;
  - anything the engineer says to send there.
- Before sending, search here first (`~/.claude/CLAUDE.md` › Working rules 2a) and put what was found in the message, so the advisor does
  not redo it.

## Sending

1. Find the advisor: `mcp__ccd_session_mgmt__list_sessions` and look for a session titled `advisor` whose folder is
   `~/WORK/advisor` and which is not archived. Found → `SendMessage` with `to` = its `local_…` id.
2. None → start it: `start_session` with `initiation: "user_asked"` (the engineer's word, or this skill's standing
   rule, sent it there), `context: "fresh"`, `cwd: "~/WORK/advisor"` (absolute path), `use_worktree: false`,
   `title: "advisor"`, the message below as its brief, prefixed with "Load skill advisor first." Before the call: a bold
   title line and one sentence.
3. The message, in this shape:

```
From: <project> session <this session's local_… id, if known>
Repo: <absolute repo path> · branch <current branch>
Ask: question | research | work
What: <the problem or the work, in the engineer's words where possible, with the date they said it>
Found here already: <files:lines, HANDOFF headings, what was ruled out>
Decisions made: <each with the engineer's words and date>; open: <questions still open, numbered, pick first>
Reply to: this session, in Thai
```

4. Tell the engineer in one line what was sent and to which session, linked as [advisor](#local_<id>).

## After sending

- Do not poll. The advisor's reply arrives as a message or a side-session note.
- A reply is the advisor's report: for work, check that the merge it names is on this repo's base branch
  (`git log --oneline -3 <base>`) before telling the engineer it is in.
- A follow-up on the same ask goes to the same advisor session, not a new one.
- Work the advisor took over is not built here as well: one owner per piece of work.
