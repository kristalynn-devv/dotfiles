# dotfiles — Claude Code instructions and skills

The single source of truth for the rule files and skills Claude Code reads.

## Layout

- `claude/` — the source files (edit here only) · `~/.claude/CLAUDE.md` is a symlink to `claude/CLAUDE.md`, and its
  `@import`s resolve from the real path in `claude/`
  - `CLAUDE.md` — the entry point that `@import`s the others
  - `IDENTITY.md` — how to address the dev + the leancode greeting
  - `GIT.md` — the word "push": put the work on the repo's dev branch (merge `--no-ff`) and push
  - `CROSS-REPO-DOCS.md` — sending docs to another repo: write them there + in its `HANDOFF.md`, then the sender is done
  - `WORKING-RULES.md` — general working rules (HANDOFF, finding answers, agents, auto mode, leancode), moved out of
    Claude auto-memory
  - `WAYFINDER-LEANCODE.md`
- `skills/` — Claude Code skills, one folder per skill (the folder name matches the `name:` in its `SKILL.md`) ·
  `sync.sh` links each one to `~/.claude/skills/<name>` · a real folder found at a link target is moved to `.backup/`,
  not deleted
  - `leancode/` — coding workflow (moved here from `kristalynn-devv/leancode` with its history; its `FRICTION.md` is
    gitignored, keep yours in this folder)
  - `pause/` — `/pause`: save the context, where work stopped and any open decision to `HANDOFF.md`; also checkpoints
  - `resume/` — `/resume`: find the note, check it against reality, settle the open decision, continue
- `sync.sh` — links every `claude/*.md` and every `skills/<name>/` into `~/.claude/`
- `install.sh` — the whole setup in one command: `sync.sh`, then `node` (Homebrew), the plugins below
  installed or updated to their latest version, and `skillOverrides` merged into
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

- leancode's friction log stays on each machine (gitignored); start it with
  `cp ~/dotfiles/skills/leancode/FRICTION.template.md ~/dotfiles/skills/leancode/FRICTION.md`
- Check: start Claude Code and type `/pause`, `/resume` or `/leancode`; if it is listed, it is installed.
- Update: `git -C ~/dotfiles pull`. The skills are symlinks, so edits arrive without re-running anything; re-run
  `install.sh` (or the loop) only when a new skill or plugin is added.

## What leancode works with

`claude/WAYFINDER-LEANCODE.md` hands some build steps to the skills below. Each one is optional. leancode checks for
them before the work starts, names any that are missing with the command to install it, and uses its own text for that
step instead. `install.sh` installs all of them; the commands below are for doing it by hand.

| What | From | Install |
|---|---|---|
| `leancode`, `pause`, `resume` | `skills/` in this repo | `sync.sh` |
| `mattpocock-skills` (wayfinder, tdd, diagnosing-bugs, code-review, research, …) | plugin | `claude plugin marketplace add anthropics/claude-plugins-official` (a fresh machine may not have it yet), then `claude plugin install mattpocock-skills@claude-plugins-official` |
| `context7` (library docs), `playwright` (driving the real app) | plugin | `claude plugin install context7@claude-plugins-official` · `claude plugin install playwright@claude-plugins-official` |
| `impeccable` (UI structure and checks) | plugin | `claude plugin marketplace add pbakaus/impeccable && claude plugin install impeccable@impeccable` |
| `daisyui` (on new projects, and where a project already uses it) | plugin | `claude plugin marketplace add saadeghi/daisyui && claude plugin install daisyui@daisyui` |

Check with `claude plugin list`. The guard against destructive commands needs nothing installed in Claude Code; see
`skills/leancode/adapters/`.

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
