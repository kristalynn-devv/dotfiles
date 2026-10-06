---
name: "pause"
description: "Use when the user types /pause or asks to pause and save where work stopped (พักงาน, หยุดไว้ก่อน); also on your own as a checkpoint before risky or long steps in multi-sitting work. Writes HANDOFF.md; works with leancode."
---

# /pause — save where we stopped

Leave a note, HANDOFF.md, that lets a fresh session with no memory of this chat pick up the work in under two minutes: the context, exactly where the work stopped, and any decision still open. `/resume` reads it back.

This skill runs two ways:

- **Pause**: the user typed `/pause` or explicitly asked to stop and save. Stop the work, write the note, reply.
- **Checkpoint**: Claude runs it on its own, without stopping, so an unplanned stop (stop button, crash, rate limit, full context) never loses the work. In work that won't finish this sitting, checkpoint when any of these first becomes true:
  - more than 3 steps are still open;
  - the next step is irreversible (send, publish, migrate, delete, pay) or long-running;
  - context is getting low, or the chat has been compacted;
  - the work reaches a decision only the user can make.

  A checkpoint updates the same note, says at most one line ("checkpoint saved"), and carries on. In implement mode leancode §6 already keeps HANDOFF.md current at these moments; only make sure the sections below are there.

A casual "wait" or "pause, let me think" is neither, so just wait. Text typed after `/pause` is the user's note for this pause; put it in the note verbatim.

**This skill never commits and never pushes.** It doesn't commit the note, doesn't commit work in progress, and doesn't push any branch, even as a backup. Code is backed up as files (section 6). The only commits that happen during this work are leancode autopilot's own local per-task commits, under leancode's rules.

If a tool named here isn't available in this session (in Claude Code CLI, for example), skip that step and say what was skipped. There, the note at the project root is enough on its own.

## 1. Pick the mode

- **implement**: the work is code in a git repo, leancode or lean-code-workflow is driving it, or a HANDOFF.md with leancode's sections (Goal, Steps, State, Decisions, Next action, Blockers) already exists at the repo root. Follow leancode §6: one HANDOFF.md at the repo root with its sections kept. This skill adds its own sections to that same file and never creates a second one.
- **general**: everything else, such as docs, research, design, planning, a prototype, or a conversation that produced decisions. Planning-only work counts, because settled decisions and open questions are worth saving even when no file exists yet.

If nothing at all has been done or decided, say so in one line and write nothing.

## 2. Stop at a safe point (pause only)

- Finish or undo the step in progress, so no file is left half-written. If the step can't finish quickly, leave it and record exactly what is half-done.
- Start nothing new. Take no irreversible action after /pause, even if it was the next step; record it as not yet done.
- Check background work started this session: agents, background commands, scheduled tasks. Stop what should stop; record what keeps running and when it ends.
- If leancode autopilot is running: finish the current task's commit if it is close to green, otherwise park it the autopilot way (named stash, question under Blockers). Update the queue.
- Verify state when it's cheap (run the tests, open the file, read the artifact), so the note records checked facts.

## 3. Gather the picture

Gather from the conversation and the real files, not from recollection.

- **Context**: what this work is, who it is for, the background a new session needs, constraints and preferences the user stated, key facts and sources found.
- **Stopped at**: the exact point (step, file and section, the half-done item).
- **Pending decision**, when stopped at a fork: the question; the options, each with what it gains, what it costs and what the next step would be; what is still needed to decide; Claude's pick, marked as a suggestion; what is blocked on it and what can go ahead without it. Hold only the decisions that block the next step, at most three. More than that means the work is still being planned: list them under Blockers and suggest a planning pass (the wayfinder skill, for example) instead of forcing them into a handoff (leancode §6).
- Steps done, current and not started. Decisions already locked, with reasons. Approaches tried and rejected.
- **State**: for implement, the repo, branch, last commit, uncommitted files and test result. For general, where each piece lives (artifact URL, folder path, connected app) and its latest version.
- **External effects already done**: messages sent, migrations applied, things published, tasks scheduled, payments. For each, record what, when, and whether it can be undone. Effects that are planned but not done go under Next action, marked "needs confirmation".
- The single next action.

If earlier parts of this chat are no longer in context because the chat is long or was compacted, re-read them with read_conversation (conversation "current") instead of reconstructing them. Mark anything that still can't be confirmed "(unverified)".

Keep provenance honest: tag each decision [user] or [Claude's pick, unconfirmed]. Never present a suggestion as a decision.

## 4. Write the note

Get the date and time from the time tool. Keep the headings in English, because /resume and leancode find sections by name; write the content in the user's language. Record state, not the story of the session. Aim for about one page and drop empty sections. Write Stopped at, Pending decision and Next action first: if context runs out mid-write, those matter most.

```markdown
# HANDOFF — <task name>
Mode: implement | general · Updated: <YYYY-MM-DD HH:MM TZ>
Status: paused at decision | paused mid-step | paused between steps | checkpoint (work continuing) | in progress (resumed <time>)

## Stopped at
<exact point; what was half-done, and whether it was finished or undone>

## Pending decision
**Question:** …
- **A** — gains … / costs … → next: …
- **B** — gains … / costs … → next: …
Claude's pick (suggestion): B — <why>
Needed before deciding: … · Blocked on it: … · Can go ahead without it: …

## Goal
<one sentence>

## Context
<what this is, who it is for, background, constraints, user preferences, key facts and sources>

## Steps
- ✅ …
- ▶ … (current)
- ⏳ …
- ⏸ … (parked: <why>)

## State
<implement: repo · branch · last commit · uncommitted files · tests → result>
<general: piece → where it lives (URL / path / app) · version>

## External effects
- <what> · <when> · <undoable? how>

## Running in background
- <agent / task> · <ends when>

## Decisions
- <decision> — <why> [user | Claude's pick, unconfirmed]

## Tried & rejected
- <approach> — <why>

## Next action
<one concrete action>; with a pending decision: A → …, B → …; irreversible → "needs confirmation"

## Blockers
- <open question> (see Pending decision)

## Resume with
- Main copy: <repo root | folder path | artifact "HANDOFF — <task name>">
- Code: <on disk in the repo | pause-<date>.bundle + .patch, sent in chat>
- Attach: <files, or "nothing">
- Type: `/resume`, or `/resume <choice>` to answer the decision

## Notes from /pause
- <the user's text after /pause>

## Log
- <date> — <paused | checkpoint> at <point>
```

If a note already exists, read it first and update it in place: keep leancode's sections and any lines written by others, carry over items that are still open, and add a Log line. Keep the last five Log lines and roll older ones into one summary line.

If the chat holds several separate workstreams, write one note per workstream. When two share a location, the implement one keeps HANDOFF.md and the other becomes HANDOFF-<slug>.md.

## 5. Check for secrets

Never write keys, tokens, passwords, or card or account numbers into the note; write where they live instead (e.g. "in .env, not committed"). Before saving or sending anything, scan the note and any patch, and for a bundle the commits it holds (`git log -p <BASE>..HEAD`):

```bash
grep -nEi 'sk-[A-Za-z0-9_-]{16,}|AKIA[0-9A-Z]{16}|BEGIN [A-Z ]*PRIVATE KEY|eyJ[A-Za-z0-9_-]{20,}\.|(password|passwd|secret|api[_-]?key|token)[A-Za-z_]*\W{0,3}[:=]\s*\S{6,}' <files>
```

A hit in the note: replace it with where the secret lives. A hit in code: don't send anything; tell the user the file and line and let them decide (remove it, gitignore it, rotate the key). Gitignored files never enter the patch or bundle.

## 6. Save it where it survives

The first that applies is the main copy:

1. **implement, repo on the user's computer or on GitHub**: HANDOFF.md at the repo root, which persists on disk. This skill doesn't commit it, but the note belongs in git: it goes in with the work it describes when the user commits or pushes. Never gitignore it.
2. **general, work in a connected folder**: HANDOFF.md at that folder's root, or HANDOFF-<slug>.md if a note for other work is already there.
3. **Anything else**: a private Markdown artifact titled `HANDOFF — <task name>`. This skill asks for a .md artifact: load artifact-design (the Artifact tool requires it), write the note to a .md file, publish it, and update that same artifact on every later pause or checkpoint. It survives a crash, and /resume finds it by listing artifacts.

**Code that exists only in this cloud workspace** disappears with the session, unpushed commits included; a plain patch fails to apply once local commits exist. Back it up as files in a folder outside the repo, without committing or pushing:

```bash
OUT=<folder outside the repo>; D=<YYYYMMDD>
BASE=$(git merge-base HEAD @{u} 2>/dev/null || git merge-base HEAD origin/HEAD 2>/dev/null || true)
if [ -z "$BASE" ]; then git bundle create "$OUT/pause-$D.bundle" --all
elif [ "$(git rev-list --count "$BASE"..HEAD)" -gt 0 ]; then git bundle create "$OUT/pause-$D.bundle" "$BASE"..HEAD; fi
IDX=$(mktemp); cp "$(git rev-parse --git-path index)" "$IDX"
GIT_INDEX_FILE="$IDX" git add -A && GIT_INDEX_FILE="$IDX" git diff --cached --binary HEAD > "$OUT/pause-$D.patch"; rm -f "$IDX"
```

The bundle holds unpushed commits and the patch holds uncommitted and untracked changes; the real index, branch and working tree are left untouched. Files in this workspace die with a crash, so send the bundle and patch into the chat with SendUserFile, where they stay with the conversation: on every /pause, and at a checkpoint whenever they changed since the last send.

On **/pause**, also send HANDOFF.md with SendUserFile, plus any work files the next session needs (zip them if there are more than three). Artifacts and files in connected apps persist, so link those instead. List everything under Resume with.

If the folder can't be reached (computer asleep, app closed), use the artifact route, send the note in chat, and say it isn't in the folder yet.

Task progress does not go into memory; the note is the record.

If the user names a time to come back (e.g. "/pause ถึงพรุ่งนี้ 9 โมง"), set a send_later reminder into this chat that says to run /resume.

## 7. Reply (pause only)

Keep it short, in the user's language:
- where the work stopped, in one line;
- the pending decision as a question with its options, if there is one;
- where the note and any code backup are;
- how to resume: `/resume` in this chat or in a new one (attach whatever Resume with lists, if anything). With a decision pending, `/resume <choice>` answers it in the same message.
- If the code lived only in the cloud workspace, add once that opening the repo from a folder on their computer keeps everything on disk and makes the bundle unnecessary.