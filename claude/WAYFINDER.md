# Workflow: plan → build

**Core rule: the planning side decides, the build side acts. Never swap roles, never skip a step.**

Planning can come from any skill — `mattpocock-skills:wayfinder` fits best when a map already exists, but it is not the
only way. The build side is always skill **`implement`**: once the decisions are complete and the next move is editing
code, `implement` takes it, whatever the size (`WORKING-RULES.md` 10). Medium to large work goes to the advisor
(`WORKING-RULES.md` 4g). `implement` gathers the rules of the retired `leancode` (2026-11-28).

## Choosing a path

Before starting anything that isn't a quick question, check in this order:

0. **Did the user ask to run a list to the end** ("รันให้จบ", "ทำให้หมด", "autopilot")?
   → Yes: work the whole list in blocking order without stopping between items. A question that comes up mid-run →
   pick or park it, log it in `HANDOFF.md`, go on; the questions reach the user once, in the end-of-run report. Where a
   map exists, `mattpocock-skills:wayfinder` is not called between tickets, and its Work loop's "stop" after one
   ticket does not apply.
1. **Is there an open wayfinder map in the project** (or in a related sibling repo): `.scratch/<effort>/map.md`, or a
   `wayfinder:map` issue on the tracker `docs/agents/issue-tracker.md` names?
   → Yes: `mattpocock-skills:wayfinder` in Work mode — load the map, health check, claim a ticket, resolve one at a
   time. A `.wayfinder/` folder holds a finished map from the user's older copy; read it for its decisions, don't work
   it.
2. **The work is bigger than one session / how to do it is still unclear / several questions are open**
   → Plan first, don't write code yet (`mattpocock-skills:wayfinder` in Chart mode, or another planner that fits
   better).
3. **The way is clear — you know what to change and where**
   → Build through `implement` (small here, medium to large through the advisor).

Not sure whether it's 2 or 3 → plan first, then ask the user one question.

## The dividing line

| | Planning side | Build side |
|---|---|---|
| Output | decisions + a spec that can be built | code that actually runs |
| Writes code? | throwaway prototypes only | yes |
| Where the work lives | the wayfinder map + its tickets | `HANDOFF.md` + diff |

- On the planning side and feeling "I just want to start writing" = you've reached the edge of the map → **stop and
  hand off**, don't keep writing yourself.
- On the build side and hitting a question you can't answer = fog → **throw it back to whoever called you**, with the
  question, the options and the one you'd pick — don't guess and write.
  - Caller is a planner → open it as a ticket/fog there · caller is the user → ask the user directly.
  - Work already built and verified stays; resume from the same step once the answer comes back.
  - In a run-to-the-end list, nobody is asked mid-run (item 0 above). Recorded 2026-10-16 from the user: "it
    shouldn't stop; it should note it down, because it's autopilot".

## Handoff

The map is done when the frontier is empty, no fog is left, and nothing needs deciding before building. At that point:

1. Say plainly that the map is done.
2. Summarize the spec from "Decisions so far" → the input for the build side.
3. Build continuity lives in `HANDOFF.md`, **not** the map — the map is closed as the record of *why* this route was
   chosen.

You can hand off before the whole map is done if one slice has all its decisions — but say clearly which slice.

## Build steps and missing plugins

Which dedicated skill runs each build step (`tdd`, `diagnosing-bugs`, `impeccable:impeccable`, `codebase-design`,
`code-review`, `resolving-merge-conflicts`, `prototype`, `research`, `wizard`, daisyUI) and what each still owes are
in the skill **`build-steps`**. Load it before such a step — new tests, a bug that doesn't yield at first look, UI or
visual work, a new boundary or module reshape, a review, a merge conflict, a prototype, docs research, a step only a
person can take — and when a plugin these rules name (`mattpocock-skills`, `impeccable`, `daisyui`, `context7`,
`playwright-cli`) is missing from the session: it holds the install commands and the fallbacks. A typo fix loads none
of it.
