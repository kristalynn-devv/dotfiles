#!/usr/bin/env python3
# PreToolUse hook for the Agent tool: refuse a spawn that names no model (WORKING-RULES.md item 4c).
# Passes: a `model` in the call · subagent_type "fork" (always runs on the main model) · an agent whose
# definition in .claude/agents/<type>.md (project or ~) sets `model:` in its frontmatter.
# Anything unreadable passes, so a broken hook never blocks work.
import json
import os
import re
import sys


def defines_model(agent_type):
    if not re.fullmatch(r"[A-Za-z0-9_-]+", agent_type or ""):
        return False
    dirs = [os.path.expanduser("~/.claude/agents")]
    if os.environ.get("CLAUDE_PROJECT_DIR"):
        dirs.insert(0, os.path.join(os.environ["CLAUDE_PROJECT_DIR"], ".claude", "agents"))
    for d in dirs:
        try:
            text = open(os.path.join(d, agent_type + ".md"), encoding="utf-8").read()
        except OSError:
            continue
        front = text.split("---", 2)[1] if text.startswith("---") else ""
        return bool(re.search(r"^model:\s*\S", front, re.M))
    return False


def main():
    try:
        call = json.load(sys.stdin)
    except ValueError:
        return
    if call.get("tool_name") not in ("Agent", "Task"):
        return
    args = call.get("tool_input") or {}
    agent_type = args.get("subagent_type") or ""
    if (args.get("model") or "").strip() or agent_type == "fork" or defines_model(agent_type):
        return
    json.dump({"hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": (
            "No model named for this subagent (WORKING-RULES.md 4c). Call again with `model`: "
            "haiku = lookups (find, grep, read a page, collect facts) · "
            "sonnet = build from a full brief, mechanical edits, tests, broad search, summaries (default when unsure) · "
            "opus = review, a bug that didn't yield, planning/research that weighs options, high-risk work."
        ),
    }}, sys.stdout)


main()
