# The word "push"

## Rule

**When the user says "push", put this session's work on the repo's dev branch and push it.** Applies to every repo.

- The dev branch is the repo's main working branch for the team, e.g. `development` or `develop`. Look it up in the
  repo, don't guess (`git symbolic-ref refs/remotes/origin/HEAD` or the repo's CLAUDE.md).
- Work is on another branch → update the local dev branch, `git merge --no-ff <branch>`, then
  `git push origin <dev>` · never fast-forward and never `git push origin HEAD:<dev>`, even when a fast-forward is clean.
- Work is not committed yet → commit **only the files this session changed** on the dev branch (name each path;
  never `git add -A` / `.`), then push · "push" counts as the instruction to commit too; don't ask again.

## Scope

- Files other sessions left modified stay out of the commit.
- Other sessions' commits waiting in local history go up with the push → always say so in the report; don't stop to wait.
- One commit per piece of work. No AI trailer (`Co-Authored-By`), following each repo's / memory's rules.
- A new branch still needs a real reason · "push" never means force-push or rebasing what is already pushed.
- Pushing to a remote branch that is not the dev branch (e.g. main/production) still needs asking first.

Recorded 2026-09-28 from the user: "if I say push, it means merge the branch or the session's code changes to dev
and push" · "not only this repo, every repo" · on `--no-ff` (2026-09-24): "from now on don't fast-forward, push normally"
