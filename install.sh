#!/usr/bin/env bash
# One command for a machine's whole Claude Code setup: the links (sync.sh), the command-line tools,
# then the plugins, playwright-cli and the antd MCP, brought to their latest version. Safe to re-run.
set -euo pipefail
D="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SETTINGS="$HOME/.claude/settings.json"

MARKETPLACES=(anthropics/claude-plugins-official pbakaus/impeccable saadeghi/daisyui)
PLUGINS=(
  mattpocock-skills@claude-plugins-official
  context7@claude-plugins-official
  impeccable@impeccable
  daisyui@daisyui
)
# node: step 5 merges settings.json with it
TOOLS=(node)

# skillOverrides added to settings.json; a skill already listed there keeps the user's value
#   name-only: the skill stays, its description stops loading in every session
#   A plugin's skills can't be hidden here (Claude Code 2.1.301): "<plugin>:<skill>" and "<skill>" both had no effect
SKILL_OVERRIDES='{
  "dataviz": "name-only", "artifact-design": "name-only", "artifact-diagramming": "name-only",
  "artifact-capabilities": "name-only", "claude-api": "name-only"
}'

# 1. Rule files and skills
bash "$D/sync.sh"

# 2. Command-line tools: Homebrew installs a missing one; without Homebrew, say how and go on
for t in "${TOOLS[@]}"; do
  command -v "$t" >/dev/null && continue
  if command -v brew >/dev/null; then
    brew install "$t"
  else
    echo "$t not found and no Homebrew: install it by hand, then run $0 again" >&2
  fi
done

command -v claude >/dev/null || { echo "claude not found: install Claude Code, then run $0 again" >&2; exit 1; }

# 3. Marketplaces: adding one that is already there is a no-op; one of the same name from
#    another source is kept as it is
for m in "${MARKETPLACES[@]}"; do
  claude plugin marketplace add "$m" || echo "marketplace $m: kept the one already configured" >&2
done
claude plugin marketplace update

# 4. Plugins: install also re-enables a disabled one; update brings each to the latest version
for p in "${PLUGINS[@]}"; do
  claude plugin install --scope user "$p"
  claude plugin update --scope user "$p"
done

# 4b. playwright-cli: looks at the real app from Bash; its skill goes to ~/.claude/skills.
#     Run from a temp folder: the CLI writes .playwright-cli/ into the folder it runs in
if command -v npm >/dev/null; then
  npm install -g @playwright/cli@latest
  (cd "$(mktemp -d)" && playwright-cli install --skills --global)
else
  echo "npm not found: install @playwright/cli by hand (npm install -g @playwright/cli@latest), then run $0 again" >&2
fi

# 4c. antd MCP (official, from @ant-design/cli): Ant Design docs, demos and tokens, user scope.
#     Adding a server that is already there is an error, so only add a missing one
if command -v npm >/dev/null; then
  npm install -g @ant-design/cli@latest
  claude mcp get antd >/dev/null 2>&1 || claude mcp add --scope user antd -- antd mcp
else
  echo "npm not found: install @ant-design/cli by hand, then claude mcp add --scope user antd -- antd mcp" >&2
fi

# 5. skillOverrides, merged into settings.json
if command -v node >/dev/null; then
  SETTINGS="$SETTINGS" SKILL_OVERRIDES="$SKILL_OVERRIDES" node -e '
    const fs = require("fs"), f = process.env.SETTINGS;
    const s = fs.existsSync(f) ? JSON.parse(fs.readFileSync(f, "utf8")) : {};
    const want = JSON.parse(process.env.SKILL_OVERRIDES), have = s.skillOverrides ||= {};
    const added = Object.keys(want).filter(k => !(k in have));
    if (!added.length) process.exit(0);
    for (const k of added) have[k] = want[k];
    fs.writeFileSync(f, JSON.stringify(s, null, 2) + "\n");
    console.log("skillOverrides: added " + added.join(", "));
  '
else
  echo "node not found: add to $SETTINGS by hand  \"skillOverrides\": $SKILL_OVERRIDES" >&2
fi

grep -q '"syncClaudeAiSkills"' "$SETTINGS" 2>/dev/null || cat <<'EOF'

Optional, saves tokens in every session: add to ~/.claude/settings.json by hand
  "syncClaudeAiSkills": false
EOF
