# Working rules (moved out of memory)

These apply to every project, every session, every subagent — not tied to any one task.
Moved out of the Claude auto-memory of workspace `~/Documents/GitLab` on 2026-09-29
(the `--no-ff` merge rule is in `GIT.md` · GitLab/CI facts are in `~/Documents/GitLab/CLAUDE.md` §Environments)

## Tracking work

1. **`HANDOFF.md` is in git in every repo** — it is the team's work tracker. Never gitignore it; commit it with the
   work it describes · a repo that ignores it → remove the rule · on "push", HANDOFF.md edits made by this session
   count as this session's files · `.scratch/` and `.wayfinder/` are not covered; leave them as each repo has them —
   the user: "let handoff go into git, it's there for tracking work" · **exception: tlt-ops** keeps `HANDOFF.md`
   gitignored (commit 2f78fa2): several people work there and a tracked file would conflict; write to the local file
   under a heading naming the module, never stage it, never touch its ignore rule — the user, 2026-10-25
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
2a. **Search before asking — whatever raises the question** (a skill's interview or grilling step, a subagent's open
   question, a plugin's prompt, or my own) — before it reaches the user, search every source inside the frame for the
   answer, then show per question: found or not · where (file:line, doc section, table + query, earlier decision or
   memory) · how it is done there · a short example. Ask only what is still unclear after that, each with the options
   and a pick · the frame is what is already set: the task's scope (named project/repo/module), `DB-ACCESS.md` (which
   databases, in which order), read-only unless asked, nothing the user ruled out · a source outside the
   frame is listed as "not checked (outside scope)", never visited · a subagent runs the same search before it hands a
   question back — the user (2026-10-31): "ถ้าจะตั้งคำถามมาจากไหนก็ตามเช่น skill agents หรือ plugin ต่างๆ
   อยากให้ค้นหาให้ครบก่อนแล้วแสดงผลลัพธ์ว่าเจอไหมที่ไหนทำแบบไหนยกตัวอย่าง ถ้าข้อไหนไม่ชัดเจนก็ค่อยถาม
   แต่การค้นหาต้องอยู่ในกรอบที่ตั้งไว้"

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
4c. **Every spawn names its model; Opus only where judgment is the job** — pass `model` on every `Agent` call (or set
   it in the agent's frontmatter), never let it inherit by default · `haiku`: pure lookups — find a file, grep a
   name, read a page, collect facts with sources · `sonnet`: building from a full brief (item 4a), mechanical edits,
   test writing, broad searches, summaries · `opus`: review (item 5), diagnosing a bug that didn't yield, planning or
   research that has to weigh options, anything high-risk (security, money, user data) · a `fork` always runs on the
   main model; spawn a fresh agent on a cheaper model instead when the work doesn't need this conversation · not sure
   → `sonnet` · this is the user naming the model for `leancode`'s spawn rule · why: 30 days of this machine's logs
   (2026-10-02 → 11-01) had 210 of 215 subagents on Opus because none named a model — about 515k input-equivalent
   tokens each, 17% of all spend — the user (2026-11-01): "ทำเลย", to the proposal that search and spec-driven agents
   run on Sonnet in every project
5. **Big review and big tests happen at "push", not at each commit** — the deep review (leancode's round, plus the
   `code-review` Standards/Spec reviewers when the change is high-risk: hard to undo, or touching security, money or
   user data) and the full test suite run once, on everything going up, when the user says "push" (`GIT.md`) ·
   a high-risk task is still flagged as such when it is committed, so the push review knows to look hard at it ·
   replaces leancode's default of reviewing every task
6. **A commit inside a skill's or agent's walk gets a light check only** — it builds or compiles, lint/type-check of the
   touched code passes, the relevant tests (`--filter`, a path) are green, nothing errors · no full suite, no review
   round at that point · run by the main session (item 4b), not the builder
6a. **Work done but not committed or pushed → ask, saying what each would do** — the user sometimes forgets, so at the
   end of a piece of work that is left uncommitted or unpushed, ask once, with both options spelled out for this repo:
   "commit → light check (item 6) + commit <these files> on <branch>" · "push → full suite + deep review (item 5) +
   merge `--no-ff` to <dev> + `git push origin <dev>`, plus any other sessions' commits that would go up with it" ·
   since 2026-10-31 commit and push are on judgment (`GIT.md` §Commit and push on judgment); this question is only
   for the cases that section says to ask about — the user (2026-10-31):
   "ถ้าจะ review หรือ test ใหญ่ๆ ให้ทำตอนสั่ง push ส่วน commit ส่วนย่อยๆ ของ skill หรือ agent ไม่ต้องใหญ่แค่เช็คแล้ว
   ไม่ error แต่บางครั้งอาจจะลืมก็ให้ถามพร้อมบอกว่า ถ้า push หรือ commit จะทำอะไรบ้าง"
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

10. **Every implementation goes through `leancode`** — any change to code, whatever its size: features, bug fixes,
    refactors, a one-spot edit, UI tweaks, tests, migrations, scripts that ship, resuming from HANDOFF, autopilot
    (leancode scales itself; a one-line fix is its smallest tier, not a reason to skip it) · not leancode: answering
    questions, research and data lookups, editing config/docs/memory/rules, routine git/shell work — do those
    directly · the user saying "รันให้จบ" or "ทำให้หมด" = leancode autopilot (§10) — the user (2026-10-31): "ทุกงานที่
    implement ให้ส่งไป leancode ทั้งหมด" (replaces 2026-10 "call leancode only for suitable work")
11. **Edits to the `leancode` skill itself stay neutral** (`~/.claude/skills/leancode`, public GitHub repo) — usable on
    any harness and in any language (English only, no language-specific rules), no local repo rules ·
    harness-specific points are worded "if the harness has X, otherwise Y" · enforcement lives in `adapters/` · every
    SKILL.md edit bumps `version` + CHANGELOG and puts the version in the commit subject —
    the user: "don't lock in the local repos' rules, keep it neutral"
