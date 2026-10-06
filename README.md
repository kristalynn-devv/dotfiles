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

## Adding a rule file

1. Write `claude/<NAME>.md` — rules that apply to every project go here, not in Claude auto-memory.
2. Add `@<NAME>.md` to `claude/CLAUDE.md` — Claude Code picks it up from the next session; no extra link needed.
3. To make Codex/Gemini see it too → add the name to the loop in `sync.sh` that builds `AGENTS.md`, then run `sync.sh`.
4. Add a line under "Layout" above.

## Adding a skill

1. Create `skills/<name>/SKILL.md` — `<name>` must match the `name:` in its frontmatter.
2. Run `sync.sh` once to link it into `~/.claude/skills/`. Later edits need no re-run: the folder is a symlink.
3. Add a line under "Layout" above.
