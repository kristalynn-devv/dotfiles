#!/usr/bin/env bash
# Run Cursor's agent headless on a brief, inside a git worktree, and keep its JSON result.
# usage: dispatch.sh --workspace <dir> --brief <file> --out <file.json> [--model <name>] [--resume <session>] [--ask]
#   --ask     read-only question (--mode ask, no --force)
#   default   build: --force inside the workspace (writes and shell commands without prompts)
set -euo pipefail

AGENT="${CURSOR_AGENT:-$HOME/.local/bin/cursor-agent}"
workspace="" brief="" out="" model="" resume="" ask=0
while [ $# -gt 0 ]; do
  case "$1" in
    --workspace) workspace="$2"; shift 2 ;;
    --brief) brief="$2"; shift 2 ;;
    --out) out="$2"; shift 2 ;;
    --model) model="$2"; shift 2 ;;
    --resume) resume="$2"; shift 2 ;;
    --ask) ask=1; shift ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

[ -x "$AGENT" ] || { echo "cursor-agent not found at $AGENT (install: curl https://cursor.com/install -fsS | bash)" >&2; exit 3; }
[ -n "$workspace" ] && [ -n "$brief" ] && [ -n "$out" ] || { echo "need --workspace, --brief and --out" >&2; exit 2; }
[ -f "$brief" ] || { echo "brief not found: $brief" >&2; exit 2; }
git -C "$workspace" rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "not a git work tree: $workspace" >&2; exit 2; }
"$AGENT" status 2>&1 | grep -qi "not logged in" && { echo "cursor-agent is not logged in: the user runs 'cursor-agent login' (or exports CURSOR_API_KEY)" >&2; exit 4; }

args=(-p --trust --output-format json --workspace "$workspace")
if [ "$ask" = 1 ]; then args+=(--mode ask); else args+=(--force); fi
[ -n "$model" ] && args+=(--model "$model")
[ -n "$resume" ] && args+=(--resume "$resume")

echo "dispatch: workspace=$workspace base=$(git -C "$workspace" log --oneline -1) mode=$([ "$ask" = 1 ] && echo ask || echo build)" >&2
"$AGENT" "${args[@]}" "$(cat "$brief")" > "$out"
status=$?
echo "dispatch: exit=$status · result in $out" >&2
exit $status
