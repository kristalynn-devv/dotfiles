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
- `agents/AGENTS.md` — **generated** flat file for agents without `@import` support (Codex, Gemini) — don't edit by
  hand · inlines only the files listed in `sync.sh` (currently `IDENTITY.md`, `RTK.md`, `WAYFINDER-LEANCODE.md`)

## Usage

The repo is private — run `gh auth login` before cloning.

```bash
git clone https://github.com/kristalynn-devv/dotfiles.git ~/dotfiles && bash ~/dotfiles/sync.sh
```

Re-run `sync.sh` after every edit under `claude/` to regenerate `agents/AGENTS.md`.

## Adding a rule file

1. Write `claude/<NAME>.md` — rules that apply to every project go here, not in Claude auto-memory.
2. Add `@<NAME>.md` to `claude/CLAUDE.md` — Claude Code picks it up from the next session; no extra link needed.
3. To make Codex/Gemini see it too → add the name to the loop in `sync.sh` that builds `AGENTS.md`, then run `sync.sh`.
4. Add a line under "Layout" above.
