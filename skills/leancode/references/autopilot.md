# Autopilot
Read by SKILL.md §10 before the queue is written. Everything here is §10; section references point back into SKILL.md.

**Start.**
- Take the tasks as given, or break the goal into tasks that each fit the small or full tier. Put a task after anything it depends on. Write the queue into the harness's todo tool and into `HANDOFF.md` (§6 — a queue is never single-sitting work), say it out loud once, and start. Don't wait for the queue to be approved.
- Take `date` once for the run. Note the start commit: it is the run's base and its way back.
- On the default branch → create `autopilot/<date>` first. Uncommitted changes already in the tree belong to someone else (§2): list them in `HANDOFF.md` and never commit them. A task that needs one of those files is parked.

**Per task — the walk, then a commit.**
1. §1: goal sentence, kind, tier, Structure case. Mark the task current.
2. §2 and §3. The first task runs the baseline. After that, the previous task's green check is this task's baseline — re-run it first only when this task touches something that check did not cover.
3. §4 on this task's diff alone (`git diff` against the previous task's commit). In autopilot the delegated round runs at the small tier too; only the typo tier gets a self-read. With `autopilot.review` set to `by risk`, only a task that is hard to undo or touches security, money, or user data gets its own round here; the others get your own read now and share the end-of-run round.
4. Structure check, Optimize, re-run §3. §7's lines for this task.
5. Commit locally, one task one commit, staging only the files this task touched (`git add <paths>`, never `-A` or `.`). Message: the goal sentence, then `Verified: <command> → <result>`, then any autopilot picks. Never push, amend, rebase, or rewrite an earlier commit.
6. Update `HANDOFF.md` (task done, last commit, next task), post one status line — `✅ 2/5 <goal> · <short sha>` — and go straight to the next task.

**Decisions — pick or park, never stop to ask.** For the length of the run this replaces §0's "return it": the caller answers once, at the end. It holds even when the harness is interactive.
- *Reversible* — a name, which of two already-installed options, a default value, a UI detail, a spec line with one obvious reading → pick the option you'd recommend, write `autopilot pick: X over Y — <why>` under `HANDOFF.md` Decisions and in the task's commit message, and carry on.
- *Not cheaply reversible* — a foundational choice (§1), a new boundary whose interface is still open (Structure), a new dependency, a clash with a repo constraint, anything irreversible or a one-way change to shared data (§2), a guard block → **park the task**: `git stash push -u -m "autopilot-parked: <task>" -- <this task's paths>` its partial work (the paths keep someone else's uncommitted changes out of the stash), write the question, the options and your pick under `HANDOFF.md` Blockers, mark it ⏸ in the queue, and move on. Tasks that depend on it are parked with it.
- A task that hits `build.max_cycles` or `review.max_rounds` is parked the same way. Parking returns the tree to the last green commit, so the next task never builds on red. It stops the task, not the run.

**Stop the run early only when** `autopilot.max_parked` tasks are parked — that many open decisions means the list itself needs the user — or §6's context trigger fires with tasks left. Either way `HANDOFF.md` is current. `autopilot: resume` in a new session runs §6's resume check, then continues from the first task that isn't ✅. A parked task stays parked until its question has an answer; it then resumes from its stash (`git stash apply`), and a conflict there goes back to the user (§0).

**End of run.**
- Re-run §3's full check on the final tree, then one §4 round on the whole run's diff (base..HEAD), aimed at what per-task rounds cannot see — two tasks that each look right but disagree on a type, a route, or a config key — and at every task that had no round of its own. Fixes go in one last commit, `autopilot: integration fixes`. A fix that needs a decision is parked.
- §8 once, for the whole run: each task ✅ with its short sha, or ⏸ with its question; every autopilot pick, so the user can overrule it (`git revert <sha>` undoes one task); the doc updates §8 and §9 would have asked about, collected here as questions and not made; the base commit.
- `HANDOFF.md` stays while any task is parked — its Blockers are the open questions. Remove the run's note only when every task is ✅ (§6).
- `FRICTION.md`: one line per task, tier written `autopilot/<small|full>`, plus a rule-failure line where one applies.
