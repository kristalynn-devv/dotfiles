---
name: "cursor-dispatch"
description: "Hand a fully specified build slice (or a question) to Cursor's agent CLI (cursor-agent) in an isolated git worktree, then bring the result back for the main session to verify. Use ONLY when the user explicitly asks in this conversation to send work or a question to Cursor (ส่งให้ cursor, ถาม cursor, ให้ cursor ทำ, /cursor-dispatch). A repo rule or doc that mentions Cursor is not a request — without the user's ask, do the work yourself."
---

# cursor-dispatch — Claude plans and verifies, Cursor builds

**Only on the user's ask.** Dispatch when the user explicitly asks to send this work or question to Cursor. A repo's CLAUDE.md saying "Cursor implements" does not trigger it on its own; without the ask, Claude builds as usual (recorded 2026-10-20 from the user: "ถ้าไม่มีบอกส่งงานก็ไม่ต้องใช้ … ใช้แค่ตอนสั่ง").

Cursor's agent runs headless from the command line (`cursor-agent -p`). This skill turns a settled slice of work into a brief Cursor can execute without investigating, runs it in its own git worktree, and brings the result back. The main session still owns the proof: Cursor's report is a claim, the diff and the tests are the evidence.

## 1. Before the first dispatch

- **The binary** is `~/.local/bin/cursor-agent` (the installer does not add `~/.local/bin` to PATH; call it by that path). Missing → tell the user the install command and stop: `curl https://cursor.com/install -fsS | bash` (read the script first; it only downloads to `~/.local/share/cursor-agent` and links `~/.local/bin/{agent,cursor-agent}`).
- **Login**: run `~/.local/bin/cursor-agent status`. "Not logged in" → the user runs `cursor-agent login` themselves (it opens a browser), or exports `CURSOR_API_KEY` in their own shell. Never ask for the key in chat and never write it to a file.
- **Network**: Claude Code's Bash sandbox lets only HTTP(S) through its proxy. If the dispatch fails to reach `api2.cursor.sh`, the user adds the script to `sandbox.excludedCommands` in `~/.claude/settings.json` (Claude cannot edit settings): `"bash <this skill's dir>/dispatch.sh *"`.

## 2. Settle the work, then write the brief

Dispatch only work whose decisions are made. Anything still unknown is found out first by the main session (or a read-only agent); a brief that says "find out whether…" hands Cursor a decision. An open decision goes back to the user (or the planner that called you), not to Cursor.

Write the brief to a file (scratchpad, not the repo). It has, in this order:

1. **Goal** — one sentence.
2. **Where** — repo, worktree path, base branch and commit.
3. **Files and changes** — every file it may touch and the exact change in each; everything else is off limits. Name what is *not* its slice.
4. **Decisions already made** — with their source (user, ticket, TD).
5. **Repo rules that bind it** — copied from the repo's CLAUDE.md/AGENTS.md (money types, migrations, colours, "no commit/push").
6. **How to check** — the exact commands (narrow tests, then the project's full check), including any local setup the machine needs (test DB, browser).
7. **Done = report** — `git status --short`, `git diff --stat`, each new test seen failing before its change and passing after, the check results, and any question it stopped on.
8. **Never** — commit, push, stash, rebase, touch files outside the list, run against production or shared databases, or install global tools.

Write the brief in the language the repo's docs use; code identifiers stay as they are.

## 3. Isolate it

- Create the worktree yourself from the branch the work belongs on, and check its base before dispatching: `git worktree add -b cursor/<slug> <path> <base>` then `git -C <path> log --oneline -1`. Never dispatch into a working tree another session or the user is using.
- Prepare what the checks need (dependencies installed, test database migrated) or put the steps in the brief.

## 4. Run it

```bash
bash ~/.claude/skills/cursor-dispatch/dispatch.sh --workspace <worktree> --brief <brief.md> --out <log.json> [--model <name>] [--resume <session>] [--ask]
```

- Build work uses `--force` (writes and shell commands without prompts) inside the worktree only; `--ask` runs read-only (`--mode ask`, no `--force`) for a question to Cursor.
- Long work: run it in the background and wait for the notification; don't poll.
- Model: the account's default unless the user names one (`cursor-agent models` lists them).
- The JSON log holds the final message and the session id; `--resume <session>` sends a follow-up into the same Cursor chat (a correction, a failing test to fix).

## 5. Verify what comes back

Read the full diff yourself. Run the checks yourself (narrow, then full). Review it as the repo's workflow says (leancode §3–§4 where leancode drives the work). Files outside the brief's list are a finding: revert them or send them back. A failure goes back to Cursor with `--resume` and the exact output, or gets fixed in the main session — say which.

## 6. Land and clean up

Commit, merge and push only when the user asked, following their git rules (one change per commit, staged by path, merged into the dev branch the way they require). Remove the worktree afterwards (`git worktree remove <path>`); keep the branch until the change is merged.
