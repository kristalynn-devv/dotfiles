# HANDOFF
updated: 2026-11-28

## dotfiles: rules, skills and harness setup

### State
branch: main · `git status -sb` says whether it is pushed. Rewritten 2026-11-28 after leancode was retired (the user:
"clean leancode และอื่นๆ ใน dotfiles" → "ใช่ทั้งหมด"); the earlier note's history is in git (`git log -- HANDOFF.md`).

What is in use:
- Rule files `claude/*.md`, imported by `claude/CLAUDE.md`: `WAYFINDER.md`, `IDENTITY.md`, `GIT.md`,
  `CROSS-REPO-DOCS.md`, `WORKING-RULES.md`, `DB-ACCESS.md` (gitignored). `RULES-HISTORY.md` is not imported.
- Skills in `skills/`: `implement`, `advisor`, `ask-advisor`, `llm-wiki`, `feedback`, `build-steps`, `cursor-dispatch`, `pause`,
  `resume`, `db-access` (gitignored).
- Skills outside this repo, in `~/.claude/skills`: `graphify`, `humanizer`, `impeccable`, `playwright-cli`,
  `security-audit`.
- Plugins, user scope: `mattpocock-skills`, `context7`, `impeccable`, `daisyui`, `caveman`, `claude-mem` (16.1.6),
  `task-observer` (3.12.2). claude.ai-synced: `design`.
- Cursor: `cursor/rules/*.mdc`, `cursor/hooks.json` → `cursor/guard.sh`.
- The advisor repo `~/WORK/advisor` (its own git, no remote) holds `projects.md`, its HANDOFF and every project's wiki.

### Decisions
- **leancode retired** [user, 2026-11-28]: `skills/leancode/` deleted (history in git, last at `7488c6a`, 5.14.0);
  its gitignored friction log kept at `.backup/leancode/FRICTION.md`. Its build rules were gathered the same day into skill
  `implement` [user: "แต่กฏตอน implement ยังใช้เหมือนเดิม" → "ทำของใหม่เลย แต่รวบรวมของเดิมมาใช้"]: every section
  kept, tunables baked in (review only on high-risk work, light check per commit, deploy-gating checks at push, no cap
  on parallel agents), commits by `GIT.md`, `.leancode/` → `.scratch/`, versioning/adapters/FRICTION dropped.
  `WORKING-RULES.md` 10 sends every code change to it; 11 runs a list to the end. The Cursor guard
  moved to `cursor/guard.sh` with `cursor/guard-patterns.txt` (tested: blocks `git reset --hard`, passes
  `git status`). `WAYFINDER-LEANCODE.md` became `WAYFINDER.md`; `session-commit-and-leancode.mdc` became
  `session-commit.mdc`.
- **Advisor workflow** [user, 2026-11-28]: engineer in a project session → `ask-advisor` → the advisor session in
  `~/WORK/advisor` (skill `advisor`, which replaced `hub-session`) answers from the wiki, claude-mem and the repo,
  researches, sends medium to large work to Cursor or worker sessions, checks and merges. Wikis are central
  (`llm-wiki`).
- **claude-mem** [user, 2026-11-26]: provider `claude` (the user's own plan, no cmem.ai account), cloud sync off,
  telemetry off, native auto-memory kept. Its worker needs a `claude` CLI: `~/.local/bin/claude` is a wrapper that runs
  the newest binary bundled with the Claude desktop app; `~/.claude-mem/settings.json` `CLAUDE_CODE_PATH` points at it.
  The "classic.SessionStart hook was skipped" notes come from Claude Code's `cc-plugin-sec-default` and are harmless
  (claude-mem `docs/public/hooks-architecture.mdx`; capture checked in the DB).
- **task-observer** [user, 2026-11-26]: installed as a skill only; its always-on activation (SessionStart hook + a
  31-line block in `CLAUDE.md`) was not added — it would load in every session and overlaps IDENTITY.md "Keep learning".
- Plugins `owasp-security@agamm` and `ui-ux-pro-max@ui-ux-pro-max-skill` uninstalled 2026-11-28 (disabled since
  2026-11-13 for low use).
- `caveman` [user, 2026-11-09]: reinstalled, hooks inject its terse-reply mode into every session and subagent. Not in
  `install.sh`.
- No `playwright` plugin [user, 2026-10-24]: its MCP returned huge snapshots per action; `playwright-cli` (Bash,
  snapshots in files) instead.
- No `rtk` [user, 2026-10-20]: its condensed output hid lines Claude needed.
- `graphify` [user, 2026-10-31]: `uv tool install --upgrade 'graphifyy[sql]'`, skill in `~/.claude/skills/graphify`.
  Its install appends a `# graphify` block to `~/.claude/CLAUDE.md` (written through the link into `claude/CLAUDE.md`)
  → delete the block after each install.
- `antd` MCP [user, 2026-10-29]: from the global `@ant-design/cli`, user scope; `install.sh` step 4c adds it.
- `wayfinder` is `mattpocock-skills:wayfinder` [user, 2026-10-16].
- Every harness [user, 2026-11-11]: Claude Code (VS Code extension + desktop Code tab, both read `~/.claude`) and
  Cursor (`sync.sh` §3). Cursor asks before a commit (`session-commit.mdc`); `GIT.md`'s commit on judgment stays for
  Claude Code.
- Hook `require-agent-model.py` removed [user, 2026-11-17]; a machine set up earlier still has its PreToolUse entry in
  `settings.json` to delete by hand.
- One real clone per machine, at `~/dotfiles` [user, 2026-10-16]; `bash ~/dotfiles/install.sh` sets a machine up.
- Commit email for this repo [user, 2026-11-28]: `git config user.email 61614236+kristalynn-devv@users.noreply.github.com`
  in `~/dotfiles` only (local config, not in the repo: set it again on a new clone), so commits show `kristalynn-devv`
  on GitHub instead of `kristalynntalaadthai`. The global email stays `kristalynn@talaadthai.com` for talaadthai work.
  The 45 earlier commits under that email are left as they are (no history rewrite).

### Found, not fixed
- `skillOverrides` does not reach a plugin's skills (Claude Code 2.1.301); a plugin whose skills duplicate others can
  only be ruled out in the rule files or uninstalled. Found 2026-10-20.
- `sync.sh` never removes a link left behind when a rule file or skill is renamed or deleted; removed by hand so far
  (`hub-session`, `leancode`, `WAYFINDER-LEANCODE.md`, `session-commit-and-leancode.mdc` on 2026-11-28). Found
  2026-10-16.
- `sync.sh` links into `$HOME/.claude` even when `CLAUDE_CONFIG_DIR` is set. Found 2026-10-16.
- Git Bash on Windows copies instead of linking; the README sends Windows to WSL or `mklink`. Found 2026-10-16.
- Two settings the agent may not write (`~/.claude/settings.json`); the user adds them by hand: `skillOverrides` for
  `dataviz`, `artifact-design`, `artifact-diagramming`, `artifact-capabilities`, `claude-api` (`name-only`) and
  `"syncClaudeAiSkills": false`.
- Copies of `pause`, `resume` and the retired `wayfinder` uploaded to claude.ai are older than the local ones and load
  beside them until skill sync is off or the uploads are replaced.
- `mattpocock-skills:code-review` asks for `/mattpocock-skills:setup-matt-pocock-skills` in a repo without
  `docs/agents/issue-tracker.md`; the user runs that once per repo.
- Project memories and HANDOFF notes in other repos (kt-labor, tlt-ops, …) may still name leancode or `hub-session`;
  not swept (outside this repo). Read them as "build with proof" and "advisor". Found 2026-11-28.
