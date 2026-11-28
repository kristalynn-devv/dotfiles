# Global rules

One file for every project, session and subagent. Sections: **Workflow** (plan → build), **The dev** (how the user
works), **Git** (commit and push), **Cross-repo docs**, **Working rules** (numbered items). The database rules stay in
their own gitignored file, imported at the end. Merged from five files on 2026-11-28 (the user: "memory files 7ไฟล์
ให้เหลือไฟล์เดียวได้ไหม" → "1 เหลือ 2 ไฟล์"); the why of each rule is in `RULES-HISTORY.md` (not loaded).

# Workflow: plan → build

**Core rule: the planning side decides, the build side acts. Never swap roles, never skip a step.**

Planning can come from any skill — `mattpocock-skills:wayfinder` fits best when a map already exists, but it is not the
only way. The build side is always skill **`implement`**: once the decisions are complete and the next move is editing
code, `implement` takes it, whatever the size (Working rules 10). Medium to large work goes to the advisor
(Working rules 4g). `implement` gathers the rules of the retired `leancode` (2026-11-28).

## Choosing a path

Before starting anything that isn't a quick question, check in this order:

0. **Did the user ask to run a list to the end** ("รันให้จบ", "ทำให้หมด", "autopilot")?
   → Yes: work the whole list in blocking order without stopping between items. A question that comes up mid-run →
   pick or park it, log it in `HANDOFF.md`, go on; the questions reach the user once, in the end-of-run report. Where a
   map exists, `mattpocock-skills:wayfinder` is not called between tickets, and its Work loop's "stop" after one
   ticket does not apply.
1. **Is there an open wayfinder map in the project** (or in a related sibling repo): `.scratch/<effort>/map.md`, or a
   `wayfinder:map` issue on the tracker `docs/agents/issue-tracker.md` names?
   → Yes: `mattpocock-skills:wayfinder` in Work mode — load the map, health check, claim a ticket, resolve one at a
   time. A `.wayfinder/` folder holds a finished map from the user's older copy; read it for its decisions, don't work
   it.
2. **The work is bigger than one session / how to do it is still unclear / several questions are open**
   → Plan first, don't write code yet (`mattpocock-skills:wayfinder` in Chart mode, or another planner that fits
   better).
3. **The way is clear — you know what to change and where**
   → Build through `implement` (small here, medium to large through the advisor).

Not sure whether it's 2 or 3 → plan first, then ask the user one question.

## The dividing line

| | Planning side | Build side |
|---|---|---|
| Output | decisions + a spec that can be built | code that actually runs |
| Writes code? | throwaway prototypes only | yes |
| Where the work lives | the wayfinder map + its tickets | `HANDOFF.md` + diff |

- On the planning side and feeling "I just want to start writing" = you've reached the edge of the map → **stop and
  hand off**, don't keep writing yourself.
- On the build side and hitting a question you can't answer = fog → **throw it back to whoever called you**, with the
  question, the options and the one you'd pick — don't guess and write.
  - Caller is a planner → open it as a ticket/fog there · caller is the user → ask the user directly.
  - Work already built and verified stays; resume from the same step once the answer comes back.
  - In a run-to-the-end list, nobody is asked mid-run (item 0 above). Recorded 2026-10-16 from the user: "it
    shouldn't stop; it should note it down, because it's autopilot".

## Handoff

The map is done when the frontier is empty, no fog is left, and nothing needs deciding before building. At that point:

1. Say plainly that the map is done.
2. Summarize the spec from "Decisions so far" → the input for the build side.
3. Build continuity lives in `HANDOFF.md`, **not** the map — the map is closed as the record of *why* this route was
   chosen.

You can hand off before the whole map is done if one slice has all its decisions — but say clearly which slice.

## Build steps and missing plugins

Which dedicated skill runs each build step (`tdd`, `diagnosing-bugs`, `impeccable:impeccable`, `codebase-design`,
`code-review`, `resolving-merge-conflicts`, `prototype`, `research`, `wizard`, daisyUI) and what each still owes are
in the skill **`build-steps`**. Load it before such a step — new tests, a bug that doesn't yield at first look, UI or
visual work, a new boundary or module reshape, a review, a merge conflict, a prototype, docs research, a step only a
person can take — and when a plugin these rules name (`mattpocock-skills`, `impeccable`, `daisyui`, `context7`,
`playwright-cli`) is missing from the session: it holds the install commands and the fallbacks. A typo fix loads none
of it.

# The dev

No form of address and no greeting: replies don't open with or use a name. The
earlier rule ("always address the dev as พี่แดนธรรม", and greet with it at the start of work) was removed on
2026-11-01 — the user: "เรียก "พี่แดนธรรม" เสมอ ไม่จำเป็นแล้วเอาออกเลย". Git author and trailers use git config, as
always.

## How the dev works (learned, keep it current)

Seeded 2026-10-31 from 1,017 of the dev's own messages across 59 sessions (19–31 Oct 2026). Each line is a habit seen
again and again, with how to meet it.

- **Short Thai messages, often with typos** (half are ≤ 32 characters). Read for intent. When a name or identifier may be
  misspelled (`kt-labot`, `requiremint`), search for the close match instead of failing or asking.
- **Replies to the dev are in Thai**, every reply and every question, even when the rules, docs or my own working notes
  are in English. Code, identifiers, paths and commands stay as they are. 2026-11-04, after a long analysis came back in
  English: "แปลไทยตอนจะคุยกับ user จำไว้ด้วย". Again 2026-11-13 («ไทย»), after subagents' English reports pulled my
  replies into English: a report that arrives in English is still relayed in Thai.
- **Questions drive the work** (~170 "ไหม / ใช่ไหม / หรือยัง"). Answer first, from evidence, naming the source; then act.
- **Accepts the recommended pick most of the time** ("ใช่ทั้งหมด" 21×, "โอเค / แก้เลย / ทำเลย" ~30×). Lead with a
  pick; act on it when it is reversible; ask only what is hard to undo or truly open (Working rules item 2a).
- **Expects a list to run to the end** ("ต่อไป / ต่อ" ~39×). Don't stop between items to ask permission to go on.
- **Answers numbered questions with numbers** ("1แก้เลย 2…", "ก", "ข"). Number questions, keep them few, make each
  stand alone, put the pick first.
- **Clarifies with "หมายถึง…" when a word could point at two things** (31×: `.13`, "connection", "ส่วนประกอบ",
  "Area"). When a referent is ambiguous, list the candidates found and say which one you took.
- **Rules are usually meant for everywhere** ("ทั้งหมดไม่ใช่เฉพาะโปรเจคนี้"). When recording a rule, say its scope
  (global or this project) in the reply, so a wrong scope is caught at once.
- **"จดไว้" means record it now, in the right place** — global rules in `~/dotfiles/claude/*`, project facts in the
  project's memory or `HANDOFF.md` — and say where.
- **Wants checks done fully and one consolidated answer**, no "not yet verified" list ("เช็คทุกอย่าง ไม่เดา").
  Before stating a finding or offering options built on data, settle three things first: **what the thing is**
  (a code that looks like a market may be a booth: check where it is used, not only its name) · **what the data
  covers** (date range and completeness of the copy before saying "this year") · **what the number is made of**
  (split by component, e.g. toll vs unload vs service fee, before quoting an impact count). An interpretation is
  labelled as one until checked. 2026-11-02, after "21 areas" turned out to be booth price sheets and three figures
  had to be corrected one question at a time: "ทำไมต้องบอกให้ research ตลอด ไม่อยากให้ต้องมาถามอะไรซ้ำๆ แบบนี้".
- **Careful about data and live systems**: DB connections, prod, credentials (`DB-ACCESS.md`). When in doubt, the
  local copy and a read-only look come first.
- **Commits and pushes only on the word** ("commit" / "push" ~80×); big review and tests at push (Git).
- **Checks status often** ("เหลืออะไร", "ครบหรือยัง"). End a piece of work with what is left, compared with the
  requirement or story.
- **UI is checked against the prototype** ("ทำไมไม่มีปุ่ม…"). Compare with the prototype before calling UI done.
- **Drift is mine to find and fix, not to offer** (2026-11-01, after I asked whether to fix a GLOSSARY entry my own
  change had made wrong: "ทำไมต้องมาคอยสั่งให้แก้ ให้มาเช็ค"). When a decision or change lands, sweep the repo for
  what it made stale — glossary, docs, TD/story text, code comments, UI copy — and fix it in the same piece of work,
  then say what was fixed. Ask only when the fix is a new decision or hard to undo.
  **Wording and layout too** (2026-11-11, second time, after I renamed a heading "ธนบัตร" → "จำนวน" and left the
  hint beside it saying "แตะธนบัตรซ้ำ": "จำไว้ด้วยว่าถ้ามีแก้กระทบไฟล์รอบเช็คไฟล์ที่เกี่ยวข้องด้วยเมื่อแก้ไข wording หรือ
  layout ต่างๆ"): renaming a label or moving a block → before calling it done, grep the old word and look at
  everything on the same screen and in the files around it — hints/tooltips, aria-labels, placeholders, toasts and
  error text, other screens sharing the component, tests and e2e, story/doc lines describing that screen.
  **Third time 2026-11-23** ("ทำไมเช็ค wording ไม่หมด"): I reworded a form ("ทุกล้อ" → pick the part first) and left
  the list behind it saying "ค่าลงเหมาเฉพาะ: ไม่จำกัดล้อ" and a hint saying "เหมาทุกล้อ". A wording change fixes the
  idea, not the string: list every place the same idea is said (form, list columns, hints, empty state, select
  options, toasts, the other screen that shows the same data) and read each on the real screen before reporting.
  **Fourth time 2026-11-24** ("ค่าผ่าน ค่าลง ทำไมแสดงไม่เหมือนกัน? ทำไมต้องบอกตลอด?"): the toll column said "ไม่คิด"
  and "เหมาตามล้อ" while the unload column beside it said "0" and "เหมา" for the same states. Columns or fields that
  show the same kind of value side by side use one word per state: before reporting a display change, list each
  state (none, flat, per unit, …) for every sibling column and make the words match, applying the user's earlier
  rule for that state (here "ค่าไหนไม่มีให้ใส่ 0", 17 Nov) to all of them, not only the column in hand.

- **A subagent's finding is checked against the code and the data before it reaches the dev** (2026-11-09, after I
  relayed a reviewer's "the tonnage report loses 499 kg" as a question to decide, when no ตามล้อ product is sold in กก.:
  "มาจากไหน?"). Its example is a hypothesis until a query shows it can happen; a finding the data rules out is dropped,
  not offered as a pick.

- **A choice offered to the dev stays open until the dev picks** (2026-11-02, after I built on direction ก and removed
  ข and ค because I had recommended it, when the dev had only said "ทำทั้ง 3 กลุ่ม": "ทำไมกลับมาแบบนี้ยังไม่ได้เลือกเลย").
  An instruction about something else does not answer a pending pick. Do the work with the options still in place, and
  never remove an option the dev has not ruled out.

## Keep learning

From 2026-10-31 the dev asked: "ต่อไปนี้อยากให้เรียนรู้การทำงานเพื่อปรับให้เข้ากับบุคลิกของ engineer
เพื่อให้ทำงานร่วมกันอย่างราบลื่น".

- **Signals to learn from**: a correction ("ไม่ใช่", "หมายถึง…", "ทำไมไม่…"), the same instruction given a second time,
  a reply that overrides what I proposed, a "จดไว้ / ต่อไปนี้ / ทุกครั้ง".
- **When one appears**: fix the work first; then record the habit in the same turn, with the dev's words and the date —
  how the dev works → The dev (this section); a working rule → Working rules (or the topic section or file such as
  Git, `DB-ACCESS.md`); a project fact → that project's memory. Say in one line what was recorded and where.
- **Second time the same instruction is given** → propose making it a default, with the exact wording to add.
- **Don't record one-offs, guesses or anything sensitive**; update or remove a line that turns out wrong instead of
  adding a contradicting one.
- **Subagents** don't write here; they report what they noticed and the main session records it.

## Scope

This section is global — it applies to every project, every session, every subagent and every provider backend.
No per-project setup needed.

# Git

## The word "push"

## Rule

**When the user says "push", put this session's work on the repo's dev branch and push it.** Applies to every repo.

- The dev branch is the repo's main working branch for the team, e.g. `development` or `develop`. Look it up in the
  repo, don't guess (`git symbolic-ref refs/remotes/origin/HEAD` or the repo's CLAUDE.md).
- Work is on another branch → update the local dev branch, `git merge --no-ff <branch>`, then
  `git push origin <dev>` · never fast-forward and never `git push origin HEAD:<dev>`, even when a fast-forward is clean.
- Work is not committed yet → commit **only the files this session changed** on the dev branch (name each path;
  never `git add -A` / `.`), then push · "push" counts as the instruction to commit too; don't ask again.

## What "push" runs first

Push runs **the checks that gate deploy** (Working rules items 5–6): read the repo's CI config (e.g.
`.gitlab-ci.yml`) for the jobs that run on the target branch before its package/deploy stage, and run those same checks
locally on everything being pushed, so the pipeline does not stop the deploy. Not the rest of the repo's suite (e2e,
script tests, `make check`) unless CI runs them before deploy. No CI config → the light check (item 6). No review round
at push — a high-risk change already had its round before its commit (item 5). A failure → stop, fix it (Working rules
10), re-run, then push. Commits along the way only had the light check. The user 2026-11-17, after a full
`make check` (e2e included) ran at push: "ใครสั่งรัน full test suite" · "แก้เป็นรันให้ไม่ติด deploy".

## Commit and push on judgment

The user, 2026-10-31: "เรื่อง commit กับ push เอาตามสมควร". No need to wait for the word:

- **Commit** when a coherent piece of work is done and has passed the light check (Working rules item 6) —
  this session's own changes only, one commit per piece.
- **Push** when a set of work is finished and the push checks pass (§What "push" runs first) — to the dev branch, by
  the rules above.
- **Work done in a worktree → merge it into the local dev branch right away, don't push** — `git merge --no-ff
  <branch>` into the local dev branch as soon as the work is done and light-checked, so the user can test it locally
  first · push waits for the word "push" (this overrides push on judgment for worktree work) · then remove the
  worktree and branch as the repo's memory says · the user (2026-11-06): "เมื่อทำใน worktree เสร็จแล้ว merge เข้า dev
  ไปก่อน เพื่อจะเทส local ก่อนยังไม่ต้องpush"
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

# Cross-repo docs

## Sending docs to another repo

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
   deploy, nothing more (Git §What "push" runs first).
6. **A commit gets a light check only** — it builds, lint/type-check of the touched code passes, the relevant tests
   are green, nothing errors · for a worker's commit, run by the session that checks it (the advisor) · the full suite
   waits for "push" (item 5).
6a. **Work left uncommitted or unpushed → ask once, saying what each would do** — "commit → light check + commit
   <files> on <branch>" · "push → deploy-gating checks + merge `--no-ff` to <dev> + `git push origin <dev>`, plus other
   sessions' commits going up" · only in the cases Git §Commit and push on judgment says to ask.
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
    once, in the end-of-run report (Workflow item 0; `implement` holds the run's rules).

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
    place the old name shows (The dev drift) · the user 2026-11-24: «ตอนตั้งชื่อให้สอดคล้องกับการทำงานและกฎ».

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

# Databases

@DB-ACCESS.md
