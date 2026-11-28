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
   hands back; no review round or push checks of its own.
4d. **Context at ~500k tokens → move to a nested session** — bring the step to a safe stop, write where it stands to
   `HANDOFF.md` (`pause`), start a **fresh** nested session myself (`start_session` with `context: "fresh"`: a brief
   naming the HANDOFF heading, files, decisions and what done looks like), and start no new work here · **never a fork
   or `hand_off_to_session`** — both copy the whole conversation, so the new session starts at the same 500k+ (the
   user 2026-11-18 "ทำไม fork ออกไปแล้วใช้ context เดิม?", measured 560k) · plain CLI → ask the user to `/clear` then
   `/resume` from HANDOFF (`/branch` and `/fork` copy the context too) · in a run-to-the-end list, finish the item in hand first
   · check 4e first.
4e. **Before any move, check it is worth it** — a fresh nested session starts at ~80k tokens · worth it: long work left,
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
4g. **The advisor → skill `advisor`; a project session reaches it through skill `ask-advisor`** — the advisor lives
   in its own repo `~/WORK/advisor` (every project's wiki under `wiki/<project>/`, `projects.md`, its HANDOFF) · it
   answers from the wiki, claude-mem and the repo, researches what is unknown and files it in the wiki · work is sized
   first: small, simple → built directly (in the project session, or in the advisor when asked there) · medium to
   large → Cursor through `cursor-dispatch` (the advisor's standing ask): the advisor plans, slices, briefs, checks
   and merges · unsure → Cursor · Cursor unavailable → a fresh worker session in the project repo (worktree, 4d) · findings go back to the same Cursor slice or session · a batch of feedback to implement → skill
   `feedback` (runs in the advisor) · replaces `hub-session` (the user 2026-11-24, 2026-11-28 "ใช่ทั้งหมด").
5. **Review only high-risk changes; the deploy-gating checks run at "push"** — high-risk (hard to undo, security,
   money, user data) → a review round before its commit (`code-review` Standards/Spec, or `/code-review`) · everything
   else: no review round, not per ticket, not at the end of a run-to-the-end list, not at push · at "push", once, on everything going up: the checks the repo's CI runs before
   deploy, nothing more (`GIT.md` §What "push" runs first).
6. **A commit gets a light check only** — it builds, lint/type-check of the touched code passes, the relevant tests
   are green, nothing errors · for a worker's commit, run by the session that checks it (the advisor) · the full suite
   waits for "push" (item 5).
6a. **Work left uncommitted or unpushed → ask once, saying what each would do** — "commit → light check + commit
   <files> on <branch>" · "push → deploy-gating checks + merge `--no-ff` to <dev> + `git push origin <dev>`, plus other
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

## Building

10. **Every implementation goes through skill `implement`** — any code change, whatever its size (features, fixes,
    refactors, one-spot edits, UI tweaks, tests, migrations, shipped scripts, resuming from HANDOFF) · not `implement`:
    questions, research, data lookups, config/docs/memory/rules edits, routine git/shell · it holds the build rules
    gathered from the retired `leancode` (plan and goal, proof per kind, build lean, verify, review on risk, audit,
    land, report) · medium to large work → the advisor (4g) · the user 2026-11-28: "แต่กฏตอน implement ยังใช้เหมือนเดิม"
    → "ทำของใหม่เลย แต่รวบรวมของเดิมมาใช้".
11. **"รันให้จบ" / "ทำให้หมด" / "autopilot" = run the whole list to the end** — blocking order, no stop between
    items; a question mid-run → pick or park, log in `HANDOFF.md`, go on; questions and parked items reach the user
    once, in the end-of-run report (`WAYFINDER.md` item 0; `implement` holds the run's rules).

## UI

12. **No "—" as a placeholder for a missing value**, every project and screen — hide a column that can't be known;
    say a single missing value in words or leave the cell empty · existing "—" change only when the screen is worked
    on or asked.
12a. **antd is restyled through its tokens, never CSS or inline style** — every project on Ant Design: a colour, fill,
    border, radius, shadow, font size/weight or padding antd sizes goes in the theme's component tokens, or a scoped
    `ConfigProvider theme={{ components: {…} }}` when one place differs (it wraps a Tooltip/Dropdown, never sits between
    it and its trigger) · look the token up first (`node_modules/antd/es/<component>/style/token.js`, antd MCP
    `antd_token`) · CSS only where antd has no token (say why in a comment) or for the project's own layout · the user
    2026-11-23: «ต้องไม่ใช้ custom token ของ css», «เอากฎไปจำไว้ด้วย».
12b. **A name says what the thing does and the rule it follows** — menus, tabs, headings, buttons, fields: read the
    code and rules behind it first, then name it for what it does to the user's work (e.g. a profile that makes the flat
    price apply only to the chosen wheel counts is named for that, not a vague "แบบเหมาตามล้อ") · a rename sweeps every
    place the old name shows (IDENTITY.md drift) · the user 2026-11-24: «ตอนตั้งชื่อให้สอดคล้องกับการทำงานและกฎ».

## Code

13. **No hardcoded values in a project** — every file in a project folder, shipped code and also helper scripts,
    stand-ins, seeds and probes (`scripts/`, `.scratch/`, even gitignored) · hosts, ports, URLs, DB and container
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
