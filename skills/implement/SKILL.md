---
name: "implement"
description: "Build rules for any change to code, whatever its size: features, bug fixes, refactors, one-spot edits, UI tweaks, tests, migrations, shipped scripts, resuming build work from HANDOFF.md, and run-to-the-end lists ('รันให้จบ', 'ทำให้หมด', 'autopilot'). States the goal and the kind of work before the first edit, proves the change with the evidence its kind asks for, reviews only high-risk changes, audits its own walk and reports. Not for questions, research, data lookups, or config, docs, memory or rules edits."
---

# Implement

The build side of plan → build: the decisions are settled and the next move is editing code. This file is the core — the goal rule, the tier ladder, the map of the walk, the safety rules and Never. Each step's detail is in `references/`, and each pointer below is a gate: read that file before the step it names. Section numbers (§0–§10) are kept from the retired `leancode` skill; the map says which file holds each one.

**The user's global rules win where they differ** (`~/dotfiles/claude/`: `~/.claude/CLAUDE.md` › Git, `~/.claude/CLAUDE.md` › Working rules, `~/.claude/CLAUDE.md` › The dev). Known differences: commits and pushes follow `~/.claude/CLAUDE.md` › Git (commit and push on judgment), not leancode's "only when asked"; stale docs, wording and drift a change causes are swept and fixed in the same piece of work (`~/.claude/CLAUDE.md` › The dev), not only flagged; anything found goes into `HANDOFF.md` right away (`~/.claude/CLAUDE.md` › Working rules 1a); a builder commits on its own branch and the main session verifies (`~/.claude/CLAUDE.md` › Working rules 4b).

**After a compaction**, a section named below that is no longer in front of you → read this file again, and the reference for the step you are on, before the next edit.

## §0 Entry and return

**You are reached by capability, not by name.** What hands over to this skill is a *state*: the decisions are settled and the next move is editing code. **Note the return address before §1** — one line: who handed the work over (a planning skill, an orchestrator, the advisor, or the user) and what came with it. No caller means the user is the caller.

**Hit something you can't decide → return it, don't route around it.** An open decision, a contradiction in the spec, a missing constraint that no amount of reading the code or looking it up resolves: stop and hand it back to whoever called you — what you were doing, the exact question, the options, and which one you'd pick. Don't guess past it, don't invent the decision, don't pass it to a third skill of your own choosing.

- Returning is not failing. A question returned now costs one message; the same question guessed at costs the whole change.
- Return the question, keep the work. What is built and verified stays; resume at the step you stopped at, locked decisions stay locked.
- Picking *which* work is the caller's call too. A map, a backlog or a pile of tickets with no slice named → ask which one. The one exception is autopilot (§10).
- **A locked decision the facts contradict is open again.** Show the evidence, finish what doesn't depend on it, return the rest.
- **Blocked by a capability, not a decision** — a permission you don't hold, a network you can't reach, a step only a person can trigger: return the exact action and the exact evidence you need back. "It works" is not that evidence; until it is in hand, the claim is unverified and §8 says so.
- Only when there is no caller to return to and the question is how the work should be *shaped*, reach for a planning pass yourself, and say which and why.

**A build step with a skill of its own runs through that skill** — tests for new behavior, a bug that doesn't yield at first look, UI or visual work, a new boundary or module reshape, a review, a merge conflict, a prototype, docs research, a step only a person can take. **Read skill `build-steps` before such a step**: it maps each to its skill, says what proof is still owed, and holds the install commands and fallbacks. That skill supplies the how; this walk still decides what has to be proven (Kind, §3). Check each one this change needs is there before §1; missing → say so at once, do its step from this walk, and say so in §8.

## Goal and tier — before the first edit

- A discussion or a plan-only ask is not build work → answer or plan, then stop. A review of someone else's change and a question about what the code does still owe their proof (Kind rows), then stop.
- **Restate the goal in one sentence and say it out loud, with the slice it covers and the kind of work it is (Kind), before the first edit.** Can't be said in one sentence → the scope is unclear; narrow it. A goal restated only to yourself is a misreading nobody gets the chance to catch.
- **When the goal changes mid-flight, rewrite it before the next edit** — the sentence, the task list, and `HANDOFF.md`'s Goal and Decisions. What the rewrite adds owes its own proof.
- **Scale the ceremony to the change, and say which tier you picked.**
  - *Typo* — one file, no behavior change (typo, copy, comment) → read the diff yourself; skip §4, Structure, Optimize, §6, §7, charting.
  - *Small* — a small fix proven end to end by one test (or, with no seam for a test, by one reproduction in the real app seen red before the fix and green after), or a markup-and-styles change that adds no state, no new data and no behavior, looked at in the real app (Kind: UI) → §2, §3, Structure, Optimize, §8, §7 cut to the lines that apply, §4 only when the change is high-risk.
  - *Full* — anything else → the whole walk.
  - Reading the diff before calling it done is never optional at any tier.

## The walk — read each file before its step

| Step | Gate | File |
|---|---|---|
| §1 Plan, Kind, Structure | before the task list and the first edit (above the typo tier) | `references/plan.md` |
| Kind procedure | before the task list, your kind's section only (not needed for a plain feature or the typo tier) | `references/kinds.md` |
| §2 Build lean (rest), §3 Verify | before the first edit and before the baseline run | `references/build.md` |
| §4 Self-review, Optimize | before the review round on a high-risk change, and before Optimize | `references/review.md` |
| §5 Split across agents | before the first spawn, and before any split beyond one read-only agent | `references/split.md` |
| §6 `HANDOFF.md` | before creating, updating or resuming from it | `references/handoff.md` |
| §7 Audit, Land, §8 Report, §9 Doc hygiene | before the audit, before any commit, merge or push, and before the report | `references/close.md` |
| §10 Autopilot | before the queue is written | `references/autopilot.md` |
| New doc | before writing it | `references/doc-skeleton.md` |

Can't read a gate's file → its step's rule here is the rule; a split or autopilot without its file doesn't happen (serialize, or walk the first task the ordinary way) and §8 says so.

**Checks and review, as set for this user.** A commit inside the walk gets a light check only: it builds, lint and type-check of the touched code pass, the relevant tests are green, nothing errors. The project's whole check — the jobs its CI runs before deploy — runs once at "push" (`~/.claude/CLAUDE.md` › Git §What "push" runs first). The delegated review round runs only on a high-risk change (hard to undo, or touching security, money, or user data), before its commit; no round on other changes, at Land, at push, or at the end of an autopilot run, and §8 says those were not reviewed. A high-risk change also runs the whole check before its commit.

## §2 Safety rules while building

- **The §1 task list is the scope boundary.** A file it doesn't name is out of bounds: a real problem there is written down (`HANDOFF.md`) and reported in §8, not fixed in this change. A file that genuinely blocks the work → say out loud that you're widening the scope, and why, *before* touching it.
- **What you did not write is not yours.** Changes already in the tree, files that appear mid-task, commits you did not make — they belong to another session or a person. Don't commit, stash, revert, reformat, or tidy them. One of them blocks the work → return it (§0). The one exception is a byproduct of a command this session ran — a file a dev server, CLI, or test run generated into the tree: read it, remove it before the report, and name it in §8.
- **Anything reaching an environment you don't solely control needs a known way back — before the first edit, not after the failure.** The exact revert command or rollback step, written down, and known to work; name it in §8 beside what changed. A dev cluster or DB the team shares counts, not just production. No way back — a one-way migration, a message already consumed, mail already sent — is not yours to decide: say so and return it (§0).
- **Verify the target environment before testing against it.** Checked means you ran something that names the target (cluster context, namespace, host, connection string) and read the answer back; a branch name, a file you opened, or a config labelled "dev" is not checking. Checked dev → test it hard. Not verified, or only fairly sure → ask before the first smoke test. Databases: `~/dotfiles/claude/DB-ACCESS.md` and skill `db-access` first.
- **Anything irreversible gets confirmed before it runs** — dropping or rewriting data, a force-push, deleting files or branches, anything reaching an environment that isn't local. Not sure which mode → treat it as interactive.
  - *Interactive* — say what will be lost, then wait for the answer. A permissive allowlist is not consent.
  - *Autonomous* — the user chose to be away (Claude Code auto mode, whose `soft_deny` blocks destructive commands; Cursor auto-run, guarded by `~/dotfiles/cursor/guard.sh`). The guard is the confirmation, so don't stop to ask in chat. The guard blocks a command → write it under `HANDOFF.md`'s Blockers with what it would have done, carry on with work that doesn't depend on it, and never route around the block with a different command, a script, or another tool. A mode with no guard at all (bypass) confirms nothing: treat each such command as blocked.
  - *Always the user's call, in every mode* — a one-way change to data others use: a migration with no down path, or data dropped or rewritten, on a shared database. Interactive → ask. Autonomous → don't run it; it is a blocker.

## §6 Continuity — when `HANDOFF.md` is written

Only files on disk and git state survive a new session. Single-sitting work needs no note; create `HANDOFF.md` (repo root, template in `references/handoff.md`; sections Goal, Steps, State, Decisions, Next action, Blockers, Found, not fixed — `pause` and `resume` find them by name) as soon as any of these is true, whichever comes first:

- more than 3 steps still open, or one step you can't finish in a single go (a long build, a deploy, a review round);
- remaining context is under 20%, or the session has been compacted once (and `~/.claude/CLAUDE.md` › Working rules 4d at ~500k tokens);
- about to start anything irreversible or long-running;
- a rate limit, a context reset (`/clear`), or an interrupt already in sight.

A task that grew past one sitting gets its note retroactively, from `git diff` and `git log`. Update it the moment each step finishes, not at the end.

## Never

- Declare done without having run something.
- Leave work half-finished without saying so.
- Run something irreversible without confirming it first — the user in an interactive mode, the guard in an autonomous one, and the user always for a one-way change to shared data. A permissive allowlist or a guard-less bypass mode is not consent.
- Route around a block the guard made.
- Smoke-test an environment you have not verified is dev.
- Split work across agents without the §5 risk pass, or let two of them edit the same file, branch, or shared surface.
- Open a subagent on work another in-flight task already owns.
- Guess past an open decision instead of returning it to the caller (§0).
- Claim high confidence without evidence to back it, or a scope from a search you cut short.
- Accept a weaker proof than the kind of work asks for, leave an edit behind in a read-only kind, or take a prototype to production without rebuilding it through the walk.
- Commit, stash, revert, or tidy work that isn't yours; commit or push outside what `~/.claude/CLAUDE.md` › Git allows.
- Edit a doc without the user's go-ahead — except the automatic split in §9, and drift this change caused (`~/.claude/CLAUDE.md` › The dev).
- Rewrite for speed without a measurement named in the §8 report.
- Invent a new folder, layer, or pattern on a refactor.
- In autopilot: stop mid-run to ask in chat or end the turn between tasks, push, amend, rebase, or stage with `git add -A`. Turn autopilot on without being asked.
