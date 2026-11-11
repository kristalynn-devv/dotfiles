#!/usr/bin/env bash
# Single source of truth for Claude Code's instructions and skills: ~/dotfiles
# Claude Code reads ~/.claude/*.md (supports @imports) and ~/.claude/skills/<name>/
set -euo pipefail
D="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"  # -P: links point at the real clone, not a path linked to it

link() {  # link <source> <target> [backup-dir]
  local src="$1" dst="$2" bak="${3:-}"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    if [ -n "$bak" ]; then
      mkdir -p "$bak"
      mv "$dst" "$bak/$(basename "$dst").$(date +%Y%m%d%H%M%S)"
    else
      mv "$dst" "$dst.bak.$(date +%Y%m%d%H%M%S)"
    fi
  fi
  ln -sfn "$src" "$dst"
  echo "linked $dst -> $src"
}

# 1. Rule files: link every claude/*.md so @imports resolve from either directory
for f in "$D"/claude/*.md; do
  link "$f" "$HOME/.claude/$(basename "$f")"
done

# 2. Skills: link each skills/<name>/ to ~/.claude/skills/<name>
#    (an existing real folder there is moved to .backup/ in this repo, never deleted;
#    left beside the link it would load as a second copy of the skill)
for s in "$D"/skills/*/; do
  s="${s%/}"
  link "$s" "$HOME/.claude/skills/$(basename "$s")" "$D/.backup/claude-skills"
done

# 3. Cursor, when installed: global rules that point at the files above, and leancode's guard on shell commands.
#    Cursor reads skills from ~/.claude/skills itself, so they need no link here
if [ -d "$HOME/.cursor" ]; then
  for r in "$D"/cursor/rules/*.mdc; do
    link "$r" "$HOME/.cursor/rules/$(basename "$r")" "$D/.backup/cursor"
  done
  link "$D/cursor/hooks.json" "$HOME/.cursor/hooks.json" "$D/.backup/cursor"
fi
