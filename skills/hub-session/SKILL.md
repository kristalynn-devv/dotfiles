---
name: "hub-session"
description: "Run this session as the checking hub: it verifies work and answers questions, and every piece of work asked here goes out: small simple work to Cursor (cursor-dispatch), medium to large work as a brief to a fresh new session (start_session) that builds it through leancode under the 500k rule. Use when the user sets a session as the checking / dispatching one (session นี้เอาไว้ตรวจเช็คงาน, สั่งงานแล้วส่ง brief เปิด session ใหม่, /hub-session), and again after a compaction or a hub hand-over when HANDOFF says the session is the hub."
---

# hub-session — this session checks, other sessions build

Set by the user 2026-11-20: "กำหนดให้ session นี้เอาตรวจเช็คงาน หากมีการสั่งงานที่นี่ให้การส่ง brief ไปเปิด session
ใหม่ และ session นั้นๆ ทำงานกฏ 500k ที่ตั้งไว้". The role holds for the whole session until the user lifts it.

## 1. What stays here, what goes out

Stays in the hub:

- Answering questions, reading code, docs, HANDOFF and data (read-only, `DB-ACCESS.md`).
- Checking what a worker session handed back (§4).
- Recording a habit or rule the user gives (IDENTITY.md "Keep learning"), memory edits.
- Routine git reads (`status`, `log`, `diff`).

Goes out, whatever its size: any change to code, config, docs, tests, migrations or a repo's HANDOFF; any build, fix,
refactor, UI tweak, data write, commit or push. A one-line edit goes out too: the hub does not edit project files.
Where it goes depends on its size (§1a).

## 1a. Small → Cursor, medium to large → a leancode session

The user 2026-11-23: "ถ้างานเล็กไม่ซับซ้อนให้ใช้ /cursor-dispatch ถ้างานกลางถึงใหญ่ให้ใช้ /leancode". This role is the
user's standing ask to send small work to Cursor, so `cursor-dispatch`'s "only on the user's ask" is met inside the hub.

- **Small, not complex → skill `cursor-dispatch`**, run by the hub: every decision made, the files and exact change
  known (about 1–3 files in one repo), no migration, no money / security / user-data logic, no new design or UX choice,
  no boundary or module reshape. E.g. a wording or label change and its neighbours, a column moved, a toggle default,
  a small validation, a one-spot bug whose cause is already found. The hub writes the brief (cursor-dispatch §2), makes
  the worktree on the dev branch, dispatches, then checks the result as §4 and does the commit and `--no-ff` merge
  itself (GIT.md).
- **Medium to large → a fresh worker session building through `leancode`** (§2): several files or layers, a
  migration, money / security / user data, a cause not yet found, a design question, anything that needs its own
  tests planned, or a list of items that build on each other.
- Unsure → medium (a leancode session). Cursor missing, not logged in, or blocked by the sandbox (cursor-dispatch §1)
  → the same piece goes to a leancode session instead; say so in the line announcing it.
- Say the pick in one line before sending: "→ Cursor (เล็ก: <why>)" or "→ session leancode (กลาง/ใหญ่: <why>)".
- A Cursor result that fails the check twice, or turns out bigger than it looked → hand it to a leancode session with
  what was found, don't dispatch it a third time.

A follow-up on work a worker session already holds (a fix after the check, an answer to its question) goes to **that**
session with `SendMessage` (its `local_…` id), not to a new one.

## 2. Starting a worker session (medium to large work)

- `start_session` with `initiation: "user_asked"` (this role is the user's standing word to send work out),
  `context: "fresh"` (never `fork`: a fork copies the hub's whole context), `use_worktree: true` for anything that writes
  code or docs in a repo. Two writers never share files; work that touches the same files waits for the first to land.
- Settle open questions before sending (`WORKING-RULES.md` 2a, 4a): the brief tells the worker what to do, not what to
  find out. A question only the user can answer is asked here first, numbered, pick first.
- Before the call: a bold title line and one sentence on what the session will do. Several at once:
  `mark_chapter` first.
- Independent pieces → one session each, started together.

### Sidebar group: one per work stream

Every worker session goes into a sidebar group named for the work stream it belongs to, right after `start_session`
returns its id. The user 2026-11-20: "ทุกครั้งที่มีการส่งไปเปิด session ให้ว่าสิ่งที่ส่งเป็นกลุ่มไหนก็สร้างไว้".

- A work stream is the story, feature or HANDOFF heading the work serves (e.g. "week3 feedback", "รับชำระ แบ่งงวด"),
  not the single task: one group per task would hold one session each and say nothing a session title does not.
- `list_groups` first; reuse a group that already names that stream, create one (`create_group`) only when none fits.
  Name it in the user's words, Thai where the stream is Thai.
- `move_sessions` with the new session's id into that group. Several sessions started together for one stream → one
  call with all their ids.
- The brief names the group (line `Group:` in the template), so a nested session the worker starts at ~500k is filed in
  the same group (`move_sessions` with `self` from the nested session, or the worker moving it).
- A follow-up sent to an existing worker with `SendMessage` changes nothing: it is already in its group.
- The hub itself stays outside the worker groups (it checks every stream).
- Say the group in the line announcing the session, e.g. "→ กลุ่ม week3 feedback".

### Brief template

```
Goal: <one sentence, in the user's words where possible>
Repo / area: <repo path, files + lines, HANDOFF heading if resuming>
Group: <sidebar group of this work stream; a nested session you start goes into it too>
Decisions already made: <each with the user's words and date>
The change: <exact behaviour, UI copy, data rules>
Done when: <tests / checks that must pass, screens to match, data to hold>
Rules: build through leancode (WORKING-RULES 10). At ~500k context follow WORKING-RULES 4d/4e (the context-check hook
reminds): safe stop, HANDOFF, fresh nested session, never fork. Worktree work merges --no-ff into the local dev branch
when light-checked (GIT.md); push only on the user's word.
Report back: branch + commit hashes, what was merged where, checks run with results, what is left or parked and why.
Reply language to the user: Thai.
```

The 500k rule and its hook are global, so the worker has them without this skill; the brief names them so they are not
missed.

## 3. While workers run

- Do not poll. A worker's turn ending reaches the hub as a `<side-sessions-event>` note.
- The hub stays free for the user's questions meanwhile.
- Every progress update carries the table of linked sessions and agents (`WORKING-RULES.md` 7): what each does,
  repo/worktree, state. `list_sessions {"linked": true}` before writing it.

## 4. Checking a worker's result

A note is the worker's report, not proof. Before telling the user it is done:

1. Read the diff on its branch or in the local dev branch (`git log`, `git diff <base>..<branch>`), against the brief.
2. Re-run the light check (`WORKING-RULES.md` 6) on what changed: build, typecheck, the relevant tests. Money work →
   item 14's round walk and every place a figure shows.
3. UI → compare with the prototype; wording/layout change → grep the old word on that screen and its neighbours
   (IDENTITY.md, drift).
4. A finding is a hypothesis until the code or data shows it can happen; drop what the data rules out.
5. Findings → back to the same worker session with `SendMessage`, as an exact change (files, lines, what done looks
   like). Then check again when it reports.

Report to the user in Thai, one consolidated answer: what was checked, where, the result, what is left compared with
the requirement or story.

## 5. The hub's own context

The hub follows the same 500k rule. At ~500k (the hook says so): write the hub's state to the repo's `HANDOFF.md`
under "Hub" (linked sessions with ids and state, checks pending, open questions to the user), then start a fresh hub
session whose brief says "load skill hub-session, continue from HANDOFF › Hub". Never fork. Check 4e first.
