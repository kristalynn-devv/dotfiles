# dotfiles — agent instructions

The single source of truth for the instructions every agent reads.

## Layout

- `claude/` — the source files (edit here only) · `~/.claude/CLAUDE.md` is a symlink to `claude/CLAUDE.md`, and its
  `@import`s resolve from the real path in `claude/`
  - `CLAUDE.md` — the entry point that `@import`s the others
  - `IDENTITY.md` — how to address the dev + the leancode greeting
  - `GIT.md` — the word "push": put the work on the repo's dev branch (merge `--no-ff`) and push
  - `CROSS-REPO-DOCS.md` — sending docs to another repo: write them there + in its `HANDOFF.md`, then the sender is done
  - `WORKING-RULES.md` — general working rules (HANDOFF, finding answers, agents, auto mode, leancode), moved out of
    Claude auto-memory
  - `RTK.md`, `WAYFINDER-LEANCODE.md`
- `skills/` — Claude Code skills, one folder per skill (the folder name matches the `name:` in its `SKILL.md`) ·
  `sync.sh` links each one to `~/.claude/skills/<name>`
  - `leancode/` — coding workflow (moved here from `kristalynn-devv/leancode` with its history; its `FRICTION.md` is
    gitignored, keep yours in this folder)
  - `pause/` — `/pause`: save the context, where work stopped and any open decision to `HANDOFF.md`; also checkpoints
  - `resume/` — `/resume`: find the note, check it against reality, settle the open decision, continue
- `agents/AGENTS.md` — **generated** flat file for agents without `@import` support (Codex, Gemini) — don't edit by
  hand · inlines only the files listed in `sync.sh` (currently `IDENTITY.md`, `RTK.md`, `WAYFINDER-LEANCODE.md`)

## Usage

```bash
git clone https://github.com/kristalynn-devv/dotfiles.git ~/dotfiles && bash ~/dotfiles/sync.sh
```

Re-run `sync.sh` after every edit under `claude/` to regenerate `agents/AGENTS.md`.

## Installing the skills

**Full setup** (your own machine): the Usage line above already links every skill in `skills/` into
`~/.claude/skills/`, together with `CLAUDE.md` and the rule files.

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
  `sync.sh` (or the loop) only when a new skill is added.

## Adding a rule file

1. Write `claude/<NAME>.md` — rules that apply to every project go here, not in Claude auto-memory.
2. Add `@<NAME>.md` to `claude/CLAUDE.md` — Claude Code picks it up from the next session; no extra link needed.
3. To make Codex/Gemini see it too → add the name to the loop in `sync.sh` that builds `AGENTS.md`, then run `sync.sh`.
4. Add a line under "Layout" above.

## Adding a skill

1. Create `skills/<name>/SKILL.md` — `<name>` must match the `name:` in its frontmatter.
2. Run `sync.sh` once to link it into `~/.claude/skills/`. Later edits need no re-run: the folder is a symlink.
3. Add a line under "Layout" above.
