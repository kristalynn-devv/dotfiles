# The word "push"

## Rule

**When the user says "push", put this session's work on the repo's dev branch and push it.** Applies to every repo.

- The dev branch is the repo's main working branch for the team, e.g. `development` or `develop`. Look it up in the
  repo, don't guess (`git symbolic-ref refs/remotes/origin/HEAD` or the repo's CLAUDE.md).
- Work is on another branch → update the local dev branch, `git merge --no-ff <branch>`, then
  `git push origin <dev>` · never fast-forward and never `git push origin HEAD:<dev>`, even when a fast-forward is clean.
- Work is not committed yet → commit **only the files this session changed** on the dev branch (name each path;
  never `git add -A` / `.`), then push · "push" counts as the instruction to commit too; don't ask again.

## What "push" runs first

Push is where the big checks happen (`WORKING-RULES.md` items 5–6): before anything goes up, run the full test suite
and the deep review on everything being pushed (the `code-review` Standards/Spec reviewers too when it is high-risk).
A failure or a finding that needs fixing → stop, fix through `leancode`, re-run, then push. Commits along the way only
had the light check.

## Commit and push on judgment

The user, 2026-10-31: "เรื่อง commit กับ push เอาตามสมควร". No need to wait for the word:

- **Commit** when a coherent piece of work is done and has passed the light check (`WORKING-RULES.md` item 6) —
  this session's own changes only, one commit per piece.
- **Push** when a set of work is finished and the push checks pass (§What "push" runs first) — to the dev branch, by
  the rules above.
- **Still ask first** when: the repo's own rules say not to commit or push until told (e.g. tlt-ops `CLAUDE.md`) ·
  the remote is public and the content carries internal hosts, people's data or personal notes · the target is not
  the dev branch · a file mixes this session's changes with another session's uncommitted ones · the change is
  high-risk (security, money, user data) and about to be pushed.
- Say in the reply what was committed or pushed (hash, branch), and what was held back and why.

## Scope

- Files other sessions left modified stay out of the commit.
- Other sessions' commits waiting in local history go up with the push → always say so in the report; don't stop to wait.
- One commit per piece of work. No AI trailer (`Co-Authored-By`), following each repo's / memory's rules.
- A new branch still needs a real reason · "push" never means force-push or rebasing what is already pushed.
- Pushing to a remote branch that is not the dev branch (e.g. main/production) still needs asking first.

Recorded 2026-09-28 from the user: "if I say push, it means merge the branch or the session's code changes to dev
and push" · "not only this repo, every repo" · on `--no-ff` (2026-09-24): "from now on don't fast-forward, push normally"
