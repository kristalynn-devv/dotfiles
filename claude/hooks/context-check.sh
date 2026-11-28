#!/bin/bash
# UserPromptSubmit: WORKING-RULES 4d — remind to move to a nested session once context passes the limit.
# Context size = the last assistant turn's input tokens (fresh + cache read + cache write) in the transcript.
LIMIT="${CLAUDE_CONTEXT_FORK_LIMIT:-500000}"
transcript=$(jq -r '.transcript_path // empty')
[ -n "$transcript" ] && [ -f "$transcript" ] || exit 0
used=$(tail -n 400 "$transcript" | jq -s -r '
  [ .[] | select(.type == "assistant" and .message.usage != null) | .message.usage ] | last
  | if . == null then 0 else ((.input_tokens // 0) + (.cache_read_input_tokens // 0) + (.cache_creation_input_tokens // 0)) end' 2>/dev/null)
[ -n "$used" ] && [ "$used" -ge "$LIMIT" ] 2>/dev/null || exit 0
jq -n --arg used "$used" --arg limit "$LIMIT" '{hookSpecificOutput: {hookEventName: "UserPromptSubmit",
  additionalContext: ("Context is \($used) tokens (limit \($limit)). WORKING-RULES 4d/4e: before new work, bring the current step to a safe stop, write where it stands to HANDOFF.md (pause), then start a FRESH nested session (start_session with context \"fresh\" and a brief naming the HANDOFF heading; never a fork or hand_off_to_session, they copy the whole conversation; plain CLI: ask the user to /clear then /resume). Stay only if what is left is a handful of tool calls; say the call in one line.")}}'
