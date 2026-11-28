# Long-run continuity: §6 and the HANDOFF.md template
Read before creating, updating or resuming from `HANDOFF.md`. The triggers for writing it are in SKILL.md. Other skills (`pause`, `resume`) find the sections below by name — keep the names.

## 6. Long-run continuity

Only files on disk and git state survive a new session. Nothing else carries over.

**Maintain `HANDOFF.md` at the repo root** for any task spanning more than one sitting. Skip this section entirely for a task that finishes in the current sitting — don't create or touch the file for single-sitting work just because this skill runs on every task.
 Update it the moment each step finishes — not at the end — so an interrupted run still leaves a current note. Its template is at the end of this file; the sections are Goal, Steps (current one marked), State (branch, last commit, uncommitted files), Decisions, Next action, Blockers, and Found, not fixed.
The single-sitting skip above lapses the moment any of SKILL.md's continuity triggers becomes true — a task that grew past one sitting gets its note retroactively, reconstructed from `git diff` and `git log`. Writing it costs a few hundred tokens; not writing it costs the whole session's state. The note is a checkpoint, not a stopping point. Context summarized by the harness still loses what isn't on disk, so the note matters whether or not the harness compacts. If it turns out the work finishes in this sitting, the paragraph on other writers says what happens to its entry.

**The note can have other writers.** A teammate, another session, or a pause tool may write to the same file. Read it again immediately before every write, change only the lines this work owns, and leave everything else exactly as it is. A note that is already there about other work is not yours to replace — add this work under its own heading. When this work finishes, mark its entry done and keep it while any other work in the note is still open, so the note shows the whole run; once no open work is left, remove the finished entries, and delete the file only when nothing else is left in it. Whether the note is tracked in git is the project's call, but tracked is safer — a clobbered note can be restored — so never add it to an ignore file yourself.

**Work spanning more than one repo gets one note, not one per repo.** Put `HANDOFF.md` in the repo where the build is driven, and name the other repos in it along with what is pending in each. Separate notes drift apart, and the one you resume from is never the one that was current.

**When resuming, never trust the note on its own.** Read `HANDOFF.md`, then confirm against reality — `git status`, `git diff`, `git log -5`, and run the checks covering what the work has touched so far (§3's narrow check; the whole check stays at push). Where they disagree, the repo wins: correct `HANDOFF.md` first, then continue. A previous run may have been cut off before it could update the note.

**When a session ends or a rate limit interrupts work,** keeping `HANDOFF.md` current is the whole job — resuming is then just a new session pointed at that file (skill `resume`), which costs less than dragging a long, bloated session forward. Schedule a wake-up (a scheduled task), naming the file's absolute path, only when nobody will be at the keyboard when work can resume. No scheduler → the note is enough; say so.

**`HANDOFF.md` tracks one known route — it is not a planning tool.** If step 1 shows the work is still a field of open decisions rather than a sequence of steps, branching and too large to settle in one sitting, don't force it into a handoff note. Stop and return it to the caller (§0) — charting is their call to make, and a handoff note is the wrong container for it. Come back here to build once the decisions are settled. If you are the end of the line with no caller to return to, propose a charting pass yourself and name the one you'd use.

## HANDOFF.md template
Use it when creating the note. Update it the moment each step finishes. The file already holds other work → add this under its own heading; don't replace what is there.

```markdown
# HANDOFF
updated: <timestamp>

## Goal
<one line>

## Steps
- [x] 1. ...
- [ ] 2. ...   <- current

## State
branch: <branch>   last commit: <sha>
uncommitted: <files>

## Decisions
- chose X over Y because ...

## Next action
<the exact command or edit to do next>

## Blockers
- <if any>

## Found, not fixed
- <file:line> — <what breaks> — <the options, and the one you'd pick>
```
