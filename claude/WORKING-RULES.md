# Working rules (moved out of memory)

These apply to every project, every session, every subagent — not tied to any one task.
Moved out of the Claude auto-memory of workspace `~/Documents/GitLab` on 2026-09-29
(the `--no-ff` merge rule is in `GIT.md` · GitLab/CI facts are in `~/Documents/GitLab/CLAUDE.md` §Environments)

## Tracking work

1. **`HANDOFF.md` is in git in every repo** — it is the team's work tracker. Never gitignore it; commit it with the
   work it describes · a repo that ignores it → remove the rule · on "push", HANDOFF.md edits made by this session
   count as this session's files · `.wayfinder/` is not covered; leave it as each repo has it —
   the user: "let handoff go into git, it's there for tracking work"
1a. **Anything found goes into that repo's `HANDOFF.md` right away** — a new gap, a residual, a parked question, a
   stale doc: write it (file:line, what breaks, options + pick) into the HANDOFF of the repo it lives in, on the
   branch carrying the work, not only into a run note or the chat · a finding in a repo this session can't commit to
   (other session's uncommitted HANDOFF, no clone) → record it in the nearest repo's HANDOFF as "to send to <repo>" —
   the user (2026-09-30): "whatever you find, keep it in that repo's handoff"

## Finding answers

2. **Business rules come from the earliest PRDs + the original code, not from an existing client** — for what a
   feature is supposed to allow, trace the oldest PRD/spec first, then the first commits / legacy snapshot · a client
   (web/app) is a reference only for wiring (which API, which screen) when porting between clients · no document
   older than the current one → say so plainly —
   the user: "web isn't the reference, look at how the early PRDs had it"

## Agents

3. **No cap on parallel agents** (overrides leancode's `parallel.max_agents` = 3) — only the cap is lifted; the split
   rules stay: a slice that needs another slice's output waits · one owner per repo/worktree · never two agents on the
   same branch/tree · each builder gets its own worktree — the user: "call as many agents as you want"
3a. **An agent holding a large slice may spawn workers one layer down** — only when the parts of its slice don't
   depend on each other · the split rules of item 3 hold at every layer · workers are briefed to execute (item 4a) and
   spawn nothing further · the agent hands its workers' output back as its own slice, and the main session still
   verifies (item 4b) — the user (2026-10-14): "I want agents to split into subs in several layers so the work goes
   faster"
4. **New, non-continuous work → always a fresh agent**, never a resumed one · resume only to finish or directly extend
   what it was doing · a fresh agent gets a compact brief (repo, worktree, branch, contracts, queue) · the main session
   is the same, but only the user can `/clear` — say when it's a good moment for a clean break —
   the user: "when it's new work that doesn't continue from before, clear the session every time"
4a. **Brief a subagent to execute, not to investigate** — the main session does the finding first, then hands over
   everything: exact files + lines, the exact change for each item, decisions already made (callers checked, picks
   locked), commands to run, what done looks like · the subagent must not have to work out *what* to do or *where* ·
   anything still unknown → settle it before briefing (or brief a separate read-only research agent first), don't
   hand the builder a "find out whether…" — the user (2026-09-30): "when handing work to a sub agent, specify
   everything so it goes to do the work, not so the subagents go looking for it themselves"
4b. **Builders build, the main session verifies** — a builder subagent writes the change (and the tests for it),
   commits on its own branch, and hands back; it does not spawn a review round or run the full suite itself · the main
   session runs the tests and the review (items 5–6) on what comes back — the user (2026-09-30): "when a subagent
   finishes, it doesn't review/test itself, send it back to the main one"
5. **Review by risk** — high-risk tasks (hard to undo if wrong, or touching security/money/user data) are reviewed one
   task at a time · other tasks share one review at the end of the run (replaces leancode's default of reviewing every task)
6. **While iterating, run only the relevant tests** (`--filter`, a path) · the full suite once before each task's
   commit and once more at the end of the run · both run by the main session (item 4b), not the builder
7. **Every progress update carries a table of all summoned agents** — what each does, which repo/worktree, status
   (running / done / parked), including agents a builder spawned · call `ListAgents` before writing · mention other
   sessions working in the same repos when it matters — the user: "while working, show every agent you summoned"

## Auto mode

8. **Auto mode: destructive commands → blocked, not asked** — the built-in `soft_deny` (`claude auto-mode defaults`)
   already blocks force-push, `reset --hard`, `rm -rf`, DROP/TRUNCATE, kubectl/helm/terraform —
   the user: "auto mode should just do it without asking — it isn't plan mode or ask"
9. **Auto mode: commands that use dev keys/secrets → confirm, don't block** (kubectl exec, get/patch Secret) via a
   `permissions.ask` rule the user adds — the user: "auto mode doesn't need to block key use, just confirm" · tested
   facts: `permissions.ask` does prompt in auto mode (don't rely on it for unattended runs) · a PreToolUse hook
   returning "ask" does not prompt · Claude can't edit settings itself (blocked as Self-Modification) → give the user
   the rule to add

## Skill leancode

10. **Call `leancode` only for work that suits it** (overrides the skill's description "Use for any coding task") —
    suits: multi-step / multi-file build work such as features, bugs that need tracing through several places,
    refactors, resuming from HANDOFF, autopilot · not needed: answering questions, editing config/docs/memory, a
    one-spot edit with a clear path, routine git/shell work — do those directly · for anything else the user wants it
    on, the user calls `/leancode` · the user saying "รันให้จบ" or "ทำให้หมด" = leancode autopilot (§10) —
    the user: "adjust it so leancode is called for suitable work, and for work I want it on I can call it myself"
11. **Edits to the `leancode` skill itself stay neutral** (`~/.claude/skills/leancode`, public GitHub repo) — usable on
    any harness and in any language (English only, no language-specific rules), no local repo rules ·
    harness-specific points are worded "if the harness has X, otherwise Y" · enforcement lives in `adapters/` · every
    SKILL.md edit bumps `version` + CHANGELOG and puts the version in the commit subject —
    the user: "don't lock in the local repos' rules, keep it neutral"
