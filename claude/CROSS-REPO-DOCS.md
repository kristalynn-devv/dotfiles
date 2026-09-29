# Sending docs to another repo

## Rule

**Sending a doc to another repo = write it in the target repo itself + add it to the target repo's `HANDOFF.md`, and the
sender is done.**

1. Write the doc in the target repo (e.g. `docs/to-<team>-<date>-*.md`, `docs/issues/`), not in the sender's repo.
2. Add an entry pointing at it in the target repo's `HANDOFF.md` (create the file if it doesn't exist).
3. The sender closes its own work right away — no "waiting" step, no chasing, no follow-up item in the sender's
   HANDOFF/tickets.

## Receiving side: look only at your own repo

Asked about outstanding work / work to hand off while in a repo → **look only at that repo** (its own `HANDOFF.md`,
`docs/`). Don't go through other repos or look for what someone sent — whatever has been delivered is already in our
own `HANDOFF.md`.

## Scope

- In the target repo touch only docs (the doc itself + `HANDOFF.md`); no code/config edits.
- No `git add`/`commit`/`push` in the target repo — its owner commits.
  Exception: the user scopes a cross-repo task and explicitly says to merge/push there.
- Files another session left modified in the target repo: don't touch them.
- The report always says what was written where, with the status "written, uncommitted, in <repo>".
- Applies to every repo, every session.

Recorded 2026-09-29 from the user: "when sending a doc, write it in the target repo directly and add it to that repo's
handoff too — the sender then has nothing left to do; closing your own work is the end, no waiting" · "applies to every
repo, every session" · "when asked in your own repo, don't look at other people's repos, only your own, for work that
needs handing off"
