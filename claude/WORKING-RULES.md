# Working rules

Every project, every session, every subagent. The why of each rule, with the user's words and dates, is in
`RULES-HISTORY.md` (not loaded; read it when a rule's intent is unclear). GitLab/CI facts: `~/Documents/GitLab/CLAUDE.md`.

## Tracking work

1. **`HANDOFF.md` is in git in every repo** — the team's work tracker: never gitignore it, commit it with the work it
   describes; on "push", this session's HANDOFF edits count as its files · `.scratch/` and `.wayfinder/` stay as each
   repo has them · **exception tlt-ops**: HANDOFF stays gitignored — write the local file under a heading naming the
   module, never stage it, never touch its ignore rule.
1a. **Anything found goes into that repo's `HANDOFF.md` right away** — gap, residual, parked question, stale doc:
   file:line, what breaks, options + pick, on the branch carrying the work · a repo this session can't commit to →
   the nearest repo's HANDOFF as "to send to <repo>".

## Finding answers

2. **Business rules come from the earliest PRDs + the original code**, not from an existing client; a client is a
   reference only for wiring · no older document → say so.
2a. **Search before asking, whatever raises the question** (a skill, a subagent, a plugin, me) — search every source
   inside the frame first, then per question show: found or not · where · how it is done there · a short example ·
   ask only what is still unclear, with options and a pick · the frame = the task's scope, `DB-ACCESS.md`, read-only
   unless asked, nothing the user ruled out · a source outside it is listed "not checked (outside scope)", not visited ·
   subagents do the same.

## Agents

3. **No cap on parallel agents** — the split rules stay: a slice needing another's output waits · one owner per
   repo/worktree · never two agents on one branch/tree · each builder its own worktree.
3a. **An agent with a large slice may spawn workers one layer down** — only for independent parts; workers execute
   (4a) and spawn nothing; the main session still verifies (4b).
4. **New, non-continuous work → a fresh agent**, never a resumed one (resume only to finish or extend) · same for the
   main session: only the user can `/clear`, so say when it is a good moment.
4a. **Brief a subagent to execute, not to investigate** — exact files + lines, the exact change, decisions made,
   commands, what done looks like · settle unknowns first (or a separate read-only research agent).
4b. **Builders build, the main session verifies** — a builder writes the change and its tests, commits on its branch,
   hands back; no review round or full suite of its own.
4c. **Lookups on the small model, building on the mid one, the rest on the main one** — a subagent that only finds,
   greps or reads and returns facts → small (Claude Code: `haiku`) · a builder working from a full brief → mid
   (`sonnet`) at effort `low` · review and all other work → no `model` and no `effort`, it runs on the main model
   at its usual effort (never `low` for review) · this rule is the user's standing ask to set `effort` on builders
   · no hook enforces this.
4d. **Context at ~500k tokens → move to a nested session** — bring the step to a safe stop, write where it stands to
   `HANDOFF.md` (`pause`), fork into a nested session myself (harness fork / hand-off, with the remaining plan and the
   HANDOFF heading), and start no new work here · plain CLI → ask the user to run `/branch` (or `/fork` with agent
   view) · in autopilot, finish the ticket in hand first · check 4e first.
4e. **Before any fork, check it is worth it** — a nested session starts at ~80k tokens · worth it: long work left,
   or work that runs in parallel · not worth it: a handful of tool calls or a short finish → stay (past 500k too) ·
   say the call in one line: work left, rough size, fork or stay.
4f. **Keep what enters the context small** —
   (a) cap Bash output where it is made (`tail -n 40`, `head`, `grep -c`, `--quiet`, failures-only); output that may
   pass ~5k characters → a scratchpad file, read only the part needed ·
   (b) a script over ~40 lines or run twice → Write it to the scratchpad, run by path; project files → Edit the exact
   spot, never a heredoc or `python - <<` rewrite ·
   (c) screenshots at `scale: 0.5` unless detail needs more; take and Read only what the check needs; a UI check
   across widths/states → a subagent returning findings + paths of the problem images ·
   (d) large files by offset/limit after `grep -n`; a many-file search → a subagent returning the conclusion ·
   (e) check the context size at the start of every user turn; past ~500k, 4d first · a request building on nothing
   here → say it is a good moment for `/clear` ·
   (f) the same long paste twice → suggest keeping it as a file and passing its path.
5. **Review only high-risk changes; the full suite runs at "push"** — `leancode` tunables `review.when: risky only`,
   `autopilot.review: by risk` · high-risk (hard to undo, security, money, user data) → review round before its commit
   (leancode's round + `code-review` Standards/Spec) · everything else: no review round, not per ticket, not at the
   end of autopilot, not at push · full test suite once, on everything going up, at "push" (`GIT.md`).
6. **A commit inside a skill's or agent's walk gets a light check only** — `check.full_when: at land`: it builds,
   lint/type-check of the touched code passes, the relevant tests are green, nothing errors · run by the main session.
6a. **Work left uncommitted or unpushed → ask once, saying what each would do** — "commit → light check + commit
   <files> on <branch>" · "push → full suite + merge `--no-ff` to <dev> + `git push origin <dev>`, plus other
   sessions' commits going up" · only in the cases `GIT.md` §Commit and push on judgment says to ask.
7. **Every progress update carries a table of all summoned agents** — what each does, repo/worktree, status
   (running / done / parked), including agents a builder spawned · `ListAgents` before writing · mention other
   sessions in the same repos when it matters.

## Auto mode

8. **Destructive commands → blocked, not asked** — the built-in `soft_deny` already blocks force-push,
   `reset --hard`, `rm -rf`, DROP/TRUNCATE, kubectl/helm/terraform.
9. **Commands using dev keys/secrets → confirm, don't block** (kubectl exec, get/patch Secret) via a
   `permissions.ask` rule the user adds · `permissions.ask` prompts in auto mode (not for unattended runs); a
   PreToolUse hook returning "ask" does not prompt · Claude can't edit settings itself → give the user the rule.

## Skill leancode

10. **Every implementation goes through `leancode`** — any code change, whatever its size (features, fixes,
    refactors, one-spot edits, UI tweaks, tests, migrations, shipped scripts, resuming from HANDOFF, autopilot) · not
    leancode: questions, research, data lookups, config/docs/memory/rules edits, routine git/shell · "รันให้จบ" or
    "ทำให้หมด" = leancode autopilot (§10).
11. **Edits to the `leancode` skill itself stay neutral** (`~/.claude/skills/leancode`, public repo) — any harness,
    any language (English only), no local repo rules · harness points worded "if the harness has X, otherwise Y" ·
    enforcement in `adapters/` · every SKILL.md edit bumps `version` + CHANGELOG, version in the commit subject.

## UI

12. **No "—" as a placeholder for a missing value**, every project and screen — hide a column that can't be known;
    say a single missing value in words or leave the cell empty · existing "—" change only when the screen is worked
    on or asked.

## Code

13. **No hardcoded values in a project** — every file in a project folder, shipped code and also helper scripts,
    stand-ins, seeds and probes (`.leancode/`, `scripts/`, even gitignored) · hosts, ports, URLs, DB and container
    names, users, passwords, secrets, tokens, IDs, phone numbers come from env files, config/constants, or a
    parameter · a value the project already defines is read from there · test data made at run time or from fixtures ·
    an existing hardcode found → that repo's `HANDOFF.md`.

## Money

14. **Money work is checked across every round and every place a figure shows, before done** — billing, payment,
    receipts, งวด / installments, VAT, shares, reports · (a) walk several rounds: pay below what is due, exactly,
    above, then later rounds (the rest, part, cancel, carry to a new receipt); each round agrees with the one before
    (owed, due now, which งวด) · (b) list every place the figure shows (bill screen before issuing, printed receipt /
    tax invoice, receipts list, payment history, reports, exports, audit) and check each says the same, stored and
    shown · (c) a figure readable two ways gets one name per meaning · the round walk goes in a test; the report names
    the places checked.
