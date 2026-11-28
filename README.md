# dotfiles — Claude Code instructions and skills

The single source of truth for the rule files and skills Claude Code reads.

## Layout

- `claude/` — the source files (edit here only) · `~/.claude/CLAUDE.md` is a symlink to `claude/CLAUDE.md`, and its
  `@import`s resolve from the real path in `claude/`
  - `CLAUDE.md` — the entry point that `@import`s the others
  - `IDENTITY.md` — how the dev works (habits learned from their messages) and how to keep learning them
  - `GIT.md` — the word "push": put the work on the repo's dev branch (merge `--no-ff`) and push
  - `CROSS-REPO-DOCS.md` — sending docs to another repo: write them there + in its `HANDOFF.md`, then the sender is done
  - `WORKING-RULES.md` — general working rules (HANDOFF, finding answers, agents and the advisor, checks, building),
    moved out of Claude auto-memory
  - `WAYFINDER.md` — plan versus build: when to plan first, `implement` builds, run-to-the-end lists
  - `RULES-HISTORY.md` — the long form of `WORKING-RULES.md` (the why, the user's words, dates); not imported
  - `DB-ACCESS.md` — gitignored (internal hosts): the always-loaded core of the DB rules; the rest is the `db-access` skill
- `skills/` — Claude Code skills, one folder per skill (the folder name matches the `name:` in its `SKILL.md`) ·
  `sync.sh` links each one to `~/.claude/skills/<name>` · a real folder found at a link target is moved to `.backup/`,
  not deleted
  - `implement/` — the build rules for any code change (gathered from the retired leancode, 2026-11-28): plan and
    goal, proof per kind, build lean, verify, review on risk, audit, land, report; a small core with `references/` read
    at each step
  - `pause/` — `/pause`: save the context, where work stopped and any open decision to `HANDOFF.md`; also checkpoints
  - `resume/` — `/resume`: find the note, check it against reality, settle the open decision, continue
  - `build-steps/` — which skill runs each build step and the proof it still owes, the plugin check and the fallbacks
    (loads only when a build step needs it)
  - `advisor/` — run a session in `~/WORK/advisor` as the advisor: every project's wiki and memory, research, work sent
    to Cursor or worker sessions, checked and merged there
  - `ask-advisor/` — from a project session: bring a question, research or medium to large work to the advisor
  - `llm-wiki/` — Karpathy's LLM Wiki pattern; each project's wiki lives in `~/WORK/advisor/wiki/<project>/`
  - `feedback/` — run a batch of feedback to the end from the advisor
  - `db-access/` — gitignored (internal hosts): the full DB rules and the DB map; copy it to a new machine by hand
  - `cursor-dispatch/` — only when the user asks: hand a settled build slice to Cursor's agent CLI (`cursor-agent -p`)
    in its own git worktree, then verify the result in Claude · needs `cursor-agent` (`curl https://cursor.com/install -fsS | bash`)
    and `cursor-agent login` once
- `cursor/` — Cursor's side, linked only when `~/.cursor` exists · Cursor reads the skills from `~/.claude/skills`
  itself
  - `rules/global-rules.mdc` — an always-on user rule pointing Cursor at the same `~/.claude/*.md` rule files
  - `rules/session-commit.mdc` — code work proves itself; ask before commit; commits staged by path
  - `hooks.json` + `guard.sh` + `guard-patterns.txt` — `guard.sh cursor` on `beforeShellExecution`: blocks
    irreversible shell commands (moved out of leancode 2026-11-28)
- `sync.sh` — links every `claude/*.md` and every `skills/<name>/` into `~/.claude/`, and `cursor/` into `~/.cursor/`
- `install.sh` — the whole setup in one command: `sync.sh`, then `node` (Homebrew), the plugins, `playwright-cli` and
  the `antd` MCP below installed or updated to their latest version, and `skillOverrides` merged into
  `~/.claude/settings.json` (a skill already listed there keeps its value); safe to re-run

## Usage

```bash
git clone https://github.com/kristalynn-devv/dotfiles.git ~/dotfiles && bash ~/dotfiles/install.sh
```

Everything is a symlink, so edits need no re-run. Run `install.sh` (or only `sync.sh`) again after adding a skill.

Keep one clone per machine, at `~/dotfiles`. The links point at the clone `sync.sh` ran from, so edits made in a second
clone are not live until they are pushed and that clone pulls them. To have the repo next to your other repos as well,
link that path instead of cloning again, after moving any old clone there aside:
`mkdir -p ~/Documents/GitHub && ln -s ~/dotfiles ~/Documents/GitHub/dotfiles`.

## Installing the skills

**Full setup** (your own machine): the Usage line above links every skill in `skills/` into `~/.claude/skills/`,
together with `CLAUDE.md` and the rule files, and installs the plugins.

**Skills only** (another machine, without this repo's `CLAUDE.md`):

```bash
git clone https://github.com/kristalynn-devv/dotfiles.git ~/dotfiles
mkdir -p ~/.claude/skills
for s in ~/dotfiles/skills/*/; do ln -sfn "${s%/}" ~/.claude/skills/"$(basename "$s")"; done
```

A real folder with the same name already in `~/.claude/skills/` (an old clone, say) has to be moved aside first;
`sync.sh` does that for you, the loop above does not.

**Windows:** run the above in WSL, or link each skill from an elevated Command Prompt:

```bat
mklink /D "%USERPROFILE%\.claude\skills\pause" C:\src\dotfiles\skills\pause
```

**After installing**

- Check: start Claude Code and type `/pause`, `/resume` or `/advisor`; if it is listed, it is installed.
- Update: `git -C ~/dotfiles pull`. The skills are symlinks, so edits arrive without re-running anything; re-run
  `install.sh` (or the loop) only when a new skill or plugin is added.

## What the build steps use

The `build-steps` skill (pointed at from `claude/WAYFINDER.md`) hands some build steps to the skills below. Each one
is optional: a missing one is named with the command to install it, and the step is done by hand with its proof. `install.sh` installs all of them; the commands below are for doing it by hand.

| What | From | Install |
|---|---|---|
| `implement`, `pause`, `resume`, `advisor`, `ask-advisor`, `llm-wiki`, `feedback`, `build-steps`, `cursor-dispatch` | `skills/` in this repo | `sync.sh` |
| `mattpocock-skills` (wayfinder, tdd, diagnosing-bugs, code-review, research, …) | plugin | `claude plugin marketplace add anthropics/claude-plugins-official` (a fresh machine may not have it yet), then `claude plugin install mattpocock-skills@claude-plugins-official` |
| `context7` (library docs) | plugin | `claude plugin install context7@claude-plugins-official` |
| `impeccable` (UI structure and checks) | plugin | `claude plugin marketplace add pbakaus/impeccable && claude plugin install impeccable@impeccable` |
| `daisyui` (on new projects, and where a project already uses it) | plugin | `claude plugin marketplace add saadeghi/daisyui && claude plugin install daisyui@daisyui` |
| `playwright-cli` (looking at the real app from Bash) | npm + skill | `npm install -g @playwright/cli@latest`, then `playwright-cli install --skills --global` |
| `antd` (Ant Design docs, demos and tokens, official) | npm + MCP | `npm install -g @ant-design/cli@latest`, then `claude mcp add --scope user antd -- antd mcp` |

Check with `claude plugin list`. Claude Code blocks destructive commands itself (auto mode `soft_deny`); Cursor gets `cursor/guard.sh`.

Two settings save tokens in every session. Add them to `~/.claude/settings.json` by hand, since Claude Code does not
let the agent edit its own settings; `install.sh` prints them at the end until they are there:

```json
"skillOverrides": {"dataviz": "name-only", "artifact-design": "name-only", "artifact-diagramming": "name-only", "artifact-capabilities": "name-only", "claude-api": "name-only"},
"syncClaudeAiSkills": false
```

`syncClaudeAiSkills: false` also stops older copies of `pause`, `resume` and the user's retired `wayfinder` uploaded to
claude.ai from loading beside the ones in use.

## Adding a rule file

1. Write `claude/<NAME>.md` — rules that apply to every project go here, not in Claude auto-memory.
2. Add `@<NAME>.md` to `claude/CLAUDE.md` — Claude Code picks it up from the next session; no extra link needed.
3. Add a line under "Layout" above.

## Adding a skill

1. Create `skills/<name>/SKILL.md` — `<name>` must match the `name:` in its frontmatter.
2. Run `sync.sh` once to link it into `~/.claude/skills/`. Later edits need no re-run: the folder is a symlink.
3. Add a line under "Layout" above.
