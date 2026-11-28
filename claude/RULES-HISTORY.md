# Working rules — long form (history, the user's words, measurements)

Not loaded into sessions. `WORKING-RULES.md` holds the rules themselves; this is the full text as of 2026-11-13,
kept as the record of why each rule exists. Add the why of a new rule here, and only the rule there.


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
4c. **Removed 2026-11-17: no per-task model or effort; every subagent runs on the main model at its usual effort.**
   The user, after the kt-labor comparison below: "งั้นลบกฏแยก model". A real-repo build (เบอร์ติดต่อกลับ on a cancel
   request, same brief, own worktrees): sonnet at low 44.8 s and opus 176.1 s, both passed `test:api` / `test:web`;
   opus followed the repo's conventions (`feat:` subject, HANDOFF entry, a Go unit test, one shared phone rule,
   field-level error) and sonnet did not. Real builds on this machine take 1–4 hours (leancode `FRICTION.md`), so the
   seconds saved were small next to the fix-ups; the 5-hour quota was hit twice in four weeks (2026-11-02, 11-11).
   What came before, the same day:
   **Lookups on the small model, building on the mid one, the rest on the main one** (2026-11-17) — builders on
   `sonnet` after a same-day benchmark, the user: "build ใช้ sonnet". Two build tasks, one run each, four models in
   parallel, graded by hidden tests. Small task (`parse_duration`): all passed 29/29, 18–25 s each. Larger task (an
   installment contract with month-end dates, pay/reverse and half-up late fees): all passed 31/31; sonnet 25 s,
   opus 40 s, haiku 47 s (most retries), fable 49 s. A review task with 4 planted bugs: opus, sonnet and fable found
   4/4 and haiku 3/4, missing the VAT truncation, so review stays on the main model.
   Effort, same tasks, one run each: sonnet build at low 17.6 s, usual 25.4 s, high 35.1 s, all 31/31 (high wrote
   more tests of its own) · opus review at low 12.3 s, usual 21.1 s, high 21.0 s, all found the 4 planted bugs, but
   low's VAT reasoning contradicted itself. The user, asked whether builders run at low: "เร็ว ถูกต้อง" → builders
   at `low`, review left at the usual effort.
   Earlier the same day the three-tier rule below and its hook `claude/hooks/require-agent-model.py` were removed, the user: "เอากฏตอน build ตอน review ออกว่าใช้
   model ไหน" · "เพราะตอน build ช้ามาก"; asked whether to split at all, the user picked the light form: "คืนแบบเบา" (lookups on `haiku`,
   builders on the main model; changed by the benchmark above) · why keep the lookup split: without any rule every subagent inherits the main model (210 of 215 on Opus, see below) · why drop the
   rest: the hook blocked spawns (leancode `FRICTION.md`, 2026-11-09, twice) and picking among three tiers on every
   spawn cost more than it saved for build and review. The rule as it stood until 2026-11-17:
   **Every spawn names its model tier; the top tier only where judgment is the job** — pass a model on every spawn
   (or set it in the agent's definition), never let it inherit by default · **light**: pure lookups — find a file, grep
   a name, read a page, collect facts with sources · **mid**: building from a full brief (item 4a), mechanical edits,
   test writing, broad searches, summaries · **top**: review (item 5), diagnosing a bug that didn't yield, planning or
   research that has to weigh options, anything high-risk (security, money, user data) · not sure → mid ·
   **which model a tier is**: Claude Code on Anthropic's models → `haiku` / `sonnet` / `opus` · Claude Code on another
   provider (Bedrock, Vertex, a gateway, or a non-Claude model behind `ANTHROPIC_BASE_URL`) → still pass `haiku` /
   `sonnet` / `opus`: they resolve through `ANTHROPIC_DEFAULT_HAIKU_MODEL` / `ANTHROPIC_DEFAULT_SONNET_MODEL` /
   `ANTHROPIC_DEFAULT_OPUS_MODEL`, which have to name that provider's small / mid / top model — unset, the alias asks
   the provider for a Claude model it may not serve, so check them before the first spawn and give the user the three
   lines to add when they are missing · another harness (Codex, Cursor, Gemini CLI, …) → its own small / mid / top
   model through its own model option · one model only, or no per-agent model choice → spawn without one and say so
   once; the tier still decides whether the work is worth a subagent · a fork always runs on the main model; spawn a
   fresh agent on a lower tier instead when the work doesn't need this conversation · this is the user naming the model
   for `leancode`'s spawn rule · enforced in Claude Code by `claude/hooks/require-agent-model.py` · why: 30 days of
   this machine's logs (2026-10-02 → 11-01) had 210 of 215 subagents on Opus because none named a model — about 515k
   input-equivalent tokens each, 17% of all spend — the user (2026-11-01): "ทำเลย", to the proposal that search and
   spec-driven agents run on Sonnet in every project · tiers instead of Claude names, the user (2026-11-05): "แก้ไข
   การแยก model ทำงาน ในกรณีที่ไม่ใช่ claude ด้วย"
4d. **Context at ~500k tokens → move to a new session** — every project · once this session's context reaches about
   500k tokens: bring the current step to a safe stop (finished, or parked), write where it stands to the repo's
   `HANDOFF.md` (`pause`), then **fork into a nested session myself** (a session under this one, made with the
   harness's fork / hand-off, carrying the remaining plan and the HANDOFF heading) and stop starting new work in this
   one · plain CLI (the model can't start a session there; a forked subagent reports back into this one, so it is
   not one) → ask the user to run `/branch` (copies this conversation into a new session, the old one stays for
   `/resume`), or `/fork` when agent view is on, with the HANDOFF heading to continue from · in autopilot, finish the
   ticket in hand first, then fork into the nested session · first check it is worth it (item 4e) — the user
   (2026-11-05): "เมื่อ context 500k แล้วให้ สร้าง session ใหม่ทุกโปรเจค" · (2026-11-06): "ครบ 500k context ให้แยก
   branch ออกไป session ใหม่" — "หมายถึงให้ fork ออกไปอีก session" ·
   "ใช้คำว่า nested ดีกว่า"
4e. **Before any fork into a nested session, check it is worth it** — every project, every fork (the 500k move of
   item 4d, a task split off, a parallel step) · a nested session starts at about 80k tokens of context before it
   does anything (the user's figure), so the work it takes over has to be worth more than that · worth it: the work
   left is long (many steps or tickets, or more than this session's room), or it runs on its own in parallel while
   this one goes on · not worth it: what is left is a handful of tool calls, a single edit, or a short finish that
   fits in this session's room → finish here (past 500k too, when the finish is that short) · say the call in one
   line: work left, roughly how much it needs, fork or stay — the user (2026-11-06): "ก่อนจะแยก fork ออกไปเช็คก่อนว่า
   คุ้มไหมเพราะแยกออกไปต้องใช้ context เริ่มต้นประมาณ 80k"
4f. **Keep what enters the context small** — every project, every session and subagent · everything a tool call
   sends or returns stays in the context until the session ends or compacts, so:
   (a) **Bash output**: cap it where it is made — `| tail -n 40`, `| head`, `grep -c`, `--quiet`, a test runner's
   failures-only mode · output that may run past ~5k characters → redirect it to a scratchpad file and read only the
   part needed (`grep`, `tail`, Read with offset/limit) ·
   (b) **no long code inline in a command**: a script over ~40 lines, or one run more than once → Write it to the
   scratchpad once and run it by path; a change to a project file → Edit the exact spot, never a heredoc or
   `python - <<` rewrite of the file ·
   (c) **screenshots**: `scale: 0.5` unless the detail needs full size · take and Read only the images the check
   needs · a UI check across several widths or states → a subagent that looks at the images and
   hands back findings plus the paths of the images that show a problem ·
   (d) **reading**: Read a large file by offset/limit, after `grep -n` finds the place · a search across many files
   → a subagent that returns the conclusion, not the file contents ·
   (e) **item 4d is checked, not assumed**: look at the context size at the start of every user turn; past ~500k,
   item 4d applies before new work starts · a request that builds on nothing in this session → say it is a good
   moment for `/clear` (item 4) before starting it ·
   (f) **long material from the user**: when the user pastes the same long text (a log, a spec, a table) more than
   once, suggest keeping it as a file and passing its path —
   why: 25 sessions of 2026-10-26 → 11-09 measured from the transcripts: sessions ran to 966k tokens with 6–10
   compactions; Bash commands ~16% of message content (69% of it heredoc scripts, up to 33k characters each), Bash
   output ~17% (a third from results of 5–20k characters), Read screenshots ~11% (up to 870 images in one session) —
   the user (2026-11-09): "ร่างกฎเลย", after asking why each session's message context grows so large
4g. **A hub session sizes each piece of work** — 2026-11-20 set up (the user: "กำหนดให้ session นี้เอาตรวจเช็คงาน …");
   2026-11-23 split: small → Cursor, medium to large → a fresh leancode session ("ถ้างานเล็กไม่ซับซ้อนให้ใช้
   /cursor-dispatch ถ้างานกลางถึงใหญ่ให้ใช้ /leancode"); 2026-11-24 flipped: small → leancode in the hub itself,
   medium to large → Cursor with leancode walking it from the hub, a fresh session only when Cursor is unavailable
   ("เปลี่ยนกฎงานใหญ่ส่ง cursor และใช้ leancode งานเล็กใช้ leancode ใน session"); 2026-11-28 the hub became the
   advisor: its own repo `~/WORK/advisor` holding every project's wiki, project sessions consult it (`ask-advisor`),
   it sends work to workers and checks and merges (the user's sketch "advisor codebase จะเก็บพวก memory wiki ต่างๆ
   ของโปรเจค … ส่ง worker ทำงาน เช่น claude, cursor (รับมาจาก advisor)", then "ใช่ทั้งหมด" to: own repo, central
   wiki, advisor checks, `hub-session` renamed `advisor`)
5. **Review only high-risk changes; the full test suite runs at "push"** — as `leancode` tunables:
   **`review.when: risky only`** and **`autopilot.review: by risk`** (leancode 5.12.0+) · a high-risk change (hard to
   undo, or touching security, money or user data) gets its review round before its commit — leancode's round plus the
   `code-review` Standards/Spec reviewers · every other change gets no review round, not per ticket, not at the end of
   an autopilot run, not at push · the full test suite runs once, on everything going up, when the user says "push"
   (`GIT.md`) · history: before 5.9.0 leancode reviewed every change — 112 review agents in 30 days, ~4.7 min and
   ~568k input-equivalent tokens each (the user 2026-11-01: "รีวิวทุก ticket รู้สึกนานและใช้ token เยอะ"); 5.9.0 moved
   the review to push (`at land`); the user 2026-11-02 dropped that too: "ตั้งให้ตอนบอกว่าให้ push ไม่ต้อง full review
   เทสปกติ"
   · 2026-11-17: "เทสปกติ" had been written down as "the full test suite", so a push ran all of `make check` (e2e
   included); the user: "ใครสั่งรัน full test suite" · "แก้เป็นรันให้ไม่ติด deploy" → push runs only the checks the
   repo's CI runs before deploy
6. **A commit inside a skill's or agent's walk gets a light check only** — as the `leancode` tunable
   **`check.full_when: at land`** (leancode 5.10.0+; before it, leancode ran the whole check before every commit, so 1 ticket
   = 1 `make check` — the user 2026-11-02: "1 ตั๋ว 1 commit มันดูเยอะไปเพราะต้องคอย review test ทุกครั้ง") · it builds or compiles, lint/type-check of the
   touched code passes, the relevant tests (`--filter`, a path) are green, nothing errors · no full suite, no review
   round at that point · run by the main session (item 4b), not the builder
6a. **Work done but not committed or pushed → ask, saying what each would do** — the user sometimes forgets, so at the
   end of a piece of work that is left uncommitted or unpushed, ask once, with both options spelled out for this repo:
   "commit → light check (item 6) + commit <these files> on <branch>" · "push → full suite (item 5) +
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

## Skill leancode (retired 2026-11-28)

**Retired 2026-11-28** — the user asked "ถ้าไม่ใช้ leancode แล้ว", then "clean leancode และอื่นๆ ใน dotfiles" and
"ใช่ทั้งหมด" to: build directly with proof, keep the light check (6), review only high-risk work (5) and the push
checks; delete `skills/leancode/` (history in git, `7488c6a`); move the Cursor guard to `cursor/guard.sh`; keep
`pause`, `resume`, `build-steps` without leancode; `WAYFINDER-LEANCODE.md` → `WAYFINDER.md`. Items 10 and 11 of
`WORKING-RULES.md` now read "build directly, prove it" and "run a list to the end". The two items below are the
retired rules, kept as history. **Same day**, the user: "แต่กฏตอน implement ยังใช้เหมือนเดิม" → "ทำของใหม่เลย แต่
รวบรวมของเดิมมาใช้": leancode's rules were gathered into the new skill `implement` (tunables baked in, commits by
`GIT.md`), and item 10 again sends every code change through a skill — now `implement`.

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

## UI

12. **No "—" as a placeholder for a missing or unknown value** — in every project, on every screen. A column or field
    that can't be known (e.g. an older API that doesn't send it yet) is hidden; a single missing value is said in words
    or the cell is left empty, whichever reads clearer there · existing "—" cells are changed only when the screen is
    being worked on, or the user asks · the user (2026-11-04), after Admin asked what a column of "—" meant: "เลี่ยงการใช้
    —" · "จดไว้กลางเลย เพราะอยากให้ทุกระบบไม่ต้องใช้"

## Code

13. **No hardcoded values in a project** — every project, every file written inside a project folder: shipped code
    and also the helper scripts, stand-ins, seeds and probes kept there (`.leancode/`, `scripts/`, even when
    gitignored) · hosts, ports, URLs, database and container names, usernames, passwords, secrets, tokens, IDs and
    phone numbers come from the project's env files (`.env`, `.env.local`, `.env.example`), its config or constants
    file, or a parameter — never typed into the file · a value the project already defines (a dev default in
    `.env.example`, a port in `docker-compose.yml`) is read from there, not copied · test data a seed needs is made at
    run time or read from the project's fixtures · applies to what I write from now on; an existing hardcode found
    while working goes into that repo's `HANDOFF.md` (item 1a) — the user (2026-11-06), after a stand-in script under
    kt-labor `.leancode/` carried its own ports, DB name, API secret and passwords: "ห้าม hardcode ค่าลงใน project"

## Money

14. **Money work is checked across every round and every place a figure shows, before it is called done** — every
    project · any change to billing, payment, receipts, งวด / installments, VAT, shares or reports · before done:
    (a) walk the money over several rounds — a payment below what is due, exactly it, above it, then the later rounds
    (pay the rest, part of it, cancel, carry to a new receipt) — and check each round's figures agree with the round
    before (what is owed, what is due now, which งวด) · (b) list every place the figure shows — the bill screen before
    issuing, the printed receipt / tax invoice, the receipts list, the person's payment history, reports, exports,
    audit — and check each says the same thing, stored and shown · (c) a figure the user may read two ways (owed by the
    bill vs by the item, due now vs minimum) gets one name per meaning · put the round walk in a test, and say in the
    report which places were checked · the user (2026-11-09), after the งวด of later rounds disagreed between receipts
    and the bill screen did not name the งวด: "ถ้าเป็นเรื่องการเงินต่างๆ รอบหน้าอย่าให้ตกหล่นอะไรแบบนี้อีก"

12b. Names match what the thing does and its rule — the user (2026-11-24), after asking whether flat wheel profiles
    should move into the market-item form and deciding to keep them shared: "ไม่ต้องแก้ แต่เปลี่ยนชื่อของ เมนูให้สอดคล้องกับ
    การทำงานด้วย จำไว้ด้วยว่าตอนตั้งชื่อให้สอดคล้องกับการทำงานและกฎ". The menu "แบบเหมาตามล้อ" did not say the flat
    price applies only to the chosen wheel counts while other wheels are charged per unit.
