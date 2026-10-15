#!/usr/bin/env bash
# One command for a machine's whole Claude Code setup: the links (sync.sh), then the plugins
# claude/WAYFINDER-LEANCODE.md names, brought to their latest version. Safe to re-run.
set -euo pipefail
D="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

MARKETPLACES=(anthropics/claude-plugins-official pbakaus/impeccable saadeghi/daisyui)
PLUGINS=(
  mattpocock-skills@claude-plugins-official
  context7@claude-plugins-official
  playwright@claude-plugins-official
  impeccable@impeccable
  daisyui@daisyui
)

# 1. Rule files and skills
bash "$D/sync.sh"

command -v claude >/dev/null || { echo "claude not found: install Claude Code, then run $0 again" >&2; exit 1; }

# 2. Marketplaces: adding one that is already there is a no-op; one of the same name from
#    another source is kept as it is
for m in "${MARKETPLACES[@]}"; do
  claude plugin marketplace add "$m" || echo "marketplace $m: kept the one already configured" >&2
done
claude plugin marketplace update

# 3. Plugins: install also re-enables a disabled one; update brings each to the latest version
for p in "${PLUGINS[@]}"; do
  claude plugin install --scope user "$p"
  claude plugin update --scope user "$p"
done

# 4. Settings: Claude Code doesn't let the agent write its own, so they stay a manual step
grep -q '"syncClaudeAiSkills"' "$HOME/.claude/settings.json" 2>/dev/null || cat <<'EOF'

Optional, saves tokens in every session: add to ~/.claude/settings.json by hand
  "skillOverrides": {"dataviz": "name-only", "artifact-design": "name-only", "artifact-diagramming": "name-only", "artifact-capabilities": "name-only", "claude-api": "name-only"},
  "syncClaudeAiSkills": false
EOF
