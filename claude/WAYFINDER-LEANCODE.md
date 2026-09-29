# Workflow: plan → build

**Core rule: the planning side decides, the build side acts. Never swap roles, never skip a step.**

Planning can come from any skill — `wayfinder` fits best when a map already exists, but it is not the only way. The build side **doesn't need to be named**: once the decisions are complete and the next move is editing code, the skill that takes build work is picked by its own description.

## Choosing a skill

Before starting anything that isn't a quick question, check in this order:

1. **Is there a `.wayfinder/map.md` in the project** (or in a related sibling repo)?
   → Yes: `wayfinder` in Work mode — load the map, health check, claim a ticket, resolve one at a time.
2. **The work is bigger than one session / how to do it is still unclear / several questions are open**
   → Plan first, don't write code yet (`wayfinder` in Chart mode, or another planner that fits better).
3. **The way is clear — you know what to change and where**
   → Go ahead and build. No need to announce which skill you'll call.

Not sure whether it's 2 or 3 → plan first, then ask the user one question.

## The dividing line

| | Planning side | Build side |
|---|---|---|
| Output | decisions + a spec that can be built | code that actually runs |
| Writes code? | throwaway prototypes only | yes |
| Where the work lives | `.wayfinder/map.md` + tickets | `HANDOFF.md` + diff |

- On the planning side and feeling "I just want to start writing" = you've reached the edge of the map → **stop and hand off**, don't keep writing yourself.
- On the build side and hitting a question you can't answer = fog → **throw it back to whoever called you**, with the question, the options and the one you'd pick — don't guess and write, and don't pick the next skill for them.
  - Caller is a planner → open it as a ticket/fog there · caller is the user → ask the user directly.
  - Work already built and verified stays; no need to tear it down. Resume from the same step once the answer comes back.

## Handoff

The map is done when the frontier is empty, no fog is left, and nothing needs deciding before building. At that point:

1. Say plainly that the map is done.
2. Summarize the spec from "Decisions so far" → the input for the build side.
3. Build continuity lives in `HANDOFF.md`, **not** the map — the map is closed as the record of *why* this route was chosen.

You can hand off before the whole map is done if one slice has all its decisions — but say clearly which slice is being handed off.

## Missing skills (use the fallback, don't stall)

- `research` → a subagent reads and searches, reports facts with sources; no recommendations.
- `prototype` → the smallest artifact that reacts, labeled disposable.
- `grilling` ✅ / `domain-modeling` ✅ / `leancode` ✅ / `wayfinder` ✅ all available.
