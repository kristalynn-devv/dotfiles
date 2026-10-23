# Workflow: plan → build

**Core rule: the planning side decides, the build side acts. Never swap roles, never skip a step.**

Planning can come from any skill — `mattpocock-skills:wayfinder` fits best when a map already exists, but it is not the only way. The build side **doesn't need to be named**: once the decisions are complete and the next move is editing code, the skill that takes build work is picked by its own description.

## Choosing a skill

Before starting anything that isn't a quick question, check in this order:

0. **Did the user ask for autopilot** (`leancode` §10's trigger, or the phrases in `WORKING-RULES.md` item 10)?
   → Yes: `leancode` autopilot runs the whole list, even where a map exists. The tickets the user named, whether from a map, a grill or a list, are its queue in blocking order. `mattpocock-skills:wayfinder` is not called between tickets, and its Work loop's "stop" after one ticket does not apply.
1. **Is there an open wayfinder map in the project** (or in a related sibling repo): `.scratch/<effort>/map.md`, or a `wayfinder:map` issue on the tracker `docs/agents/issue-tracker.md` names?
   → Yes: `mattpocock-skills:wayfinder` in Work mode — load the map, health check, claim a ticket, resolve one at a time. A `.wayfinder/` folder holds a finished map from the user's older copy; read it for its decisions, don't work it.
2. **The work is bigger than one session / how to do it is still unclear / several questions are open**
   → Plan first, don't write code yet (`mattpocock-skills:wayfinder` in Chart mode, or another planner that fits better).
3. **The way is clear — you know what to change and where**
   → Go ahead and build. No need to announce which skill you'll call.

Not sure whether it's 2 or 3 → plan first, then ask the user one question.

## The dividing line

| | Planning side | Build side |
|---|---|---|
| Output | decisions + a spec that can be built | code that actually runs |
| Writes code? | throwaway prototypes only | yes |
| Where the work lives | the wayfinder map + its tickets | `HANDOFF.md` + diff |

- On the planning side and feeling "I just want to start writing" = you've reached the edge of the map → **stop and hand off**, don't keep writing yourself.
- On the build side and hitting a question you can't answer = fog → **throw it back to whoever called you**, with the question, the options and the one you'd pick — don't guess and write, and don't pick the next skill for them.
  - Caller is a planner → open it as a ticket/fog there · caller is the user → ask the user directly.
  - Work already built and verified stays; no need to tear it down. Resume from the same step once the answer comes back.
  - In autopilot, nobody is asked mid-run, neither the planner nor the user: pick or park (`leancode` §10), log it in `HANDOFF.md`, and go on to the next ticket. The questions reach the user once, in the end-of-run report.

Recorded 2026-10-16 from the user, after a real autopilot run over grilled tickets stopped to ask once the first ticket was done: "it shouldn't stop; it should note it down, because it's autopilot".

## Handoff

The map is done when the frontier is empty, no fog is left, and nothing needs deciding before building. At that point:

1. Say plainly that the map is done.
2. Summarize the spec from "Decisions so far" → the input for the build side.
3. Build continuity lives in `HANDOFF.md`, **not** the map — the map is closed as the record of *why* this route was chosen.

You can hand off before the whole map is done if one slice has all its decisions — but say clearly which slice is being handed off.

## Build steps with a skill of their own

`leancode` walks the build and decides what has to be proven. The steps below run through a dedicated skill: Matt Pocock's, from the `mattpocock-skills` plugin and called as `mattpocock-skills:<name>`, and for UI work `impeccable:impeccable`. The skill supplies the how; what `leancode` asks to be shown for the step is still owed.

| Step of the walk | Skill | Still owed to `leancode` |
|---|---|---|
| Tests for new behavior (§3) | `tdd` | the test seen red for the right reason; the full check before done |
| A bug that doesn't yield at first look | `diagnosing-bugs` | the root cause in one sentence, with its evidence, before the fix; the search for siblings |
| UI or visual work, before the first edit | `impeccable:impeccable` — `shape` to plan the structure of something new, `audit` or `critique` to check what is already there | the real app looked at, at every width and state the change can reach |
| A new boundary, or reshaping a module (Structure) | `codebase-design` | the case named before the edit; no new pattern on a refactor |
| Review (§4) | `code-review` — two more reviewers, Standards and Spec, only on a high-risk change (hard to undo, or touching security, money, or user data); any other change gets `leancode`'s own round alone | `leancode`'s own round still runs; every finding is checked against the code before it is fixed |
| A merge or rebase conflict | `resolving-merge-conflicts` | intents that can't coexist go back to the caller; the merged tree's full check before it is pushed |
| A prototype or spike | `prototype` | it reaches production only by being rebuilt through the walk |
| Facts from docs or other primary sources | `research` | each claim keeps its source; no recommendations |
| A step only a person can take (§0) | `wizard` | the evidence that has to come back |

- `code-review` takes two inputs up front: the fixed point — the commit this change started from (in autopilot the previous task's commit; at the end of a run, the run's base) — and the spec: the ticket or spec file, or the goal sentence when there is none.
- When one of these skills says to ask the user, or to commit: interactive → ask, as it says. Autopilot → pick or park (`leancode` §10) and log it. Commits and pushes follow `GIT.md` and `leancode`'s Land, never the skill.
- **daisyUI** (`daisyui:daisyui`) is optional on an existing project: use it where the project already uses daisyUI, or when the user asks. A new project uses it from the start — that choice is already made, so it is not a question to return. The skill's own description says to load it for any HTML or JSX; this rule is the one that holds.
- The typo tier has none of these steps, and loads none of these skills.

Recorded 2026-10-14 from the user: "use Matt Pocock's for all of it" — chosen as: every step he has a skill for, with his review added beside `leancode`'s own, not instead of it. And: "on UI work, use impeccable to look at the structure and check first; daisyUI is optional, but a new project uses it right away."

## Missing skills (use the fallback, don't stall)

**Check before the work starts.** The plugins these rules name — `mattpocock-skills`, `impeccable`, `daisyui`, `context7` — have to be in the session's skill or tool list (`claude plugin list` settles a doubt). One is missing → tell the user at once, with its install command, then carry on with the fallback; don't install it yourself unless asked. The command is `claude plugin install <name>@claude-plugins-official`, except `impeccable@impeccable` (first `claude plugin marketplace add pbakaus/impeccable`) and `daisyui@daisyui` (first `claude plugin marketplace add saadeghi/daisyui`). On a machine set up from dotfiles, offer `bash ~/dotfiles/install.sh` before the single commands: it installs or re-enables all four, and adds `anthropics/claude-plugins-official` where a fresh install lacks it.

- `mattpocock-skills` plugin not installed → `research`: a subagent reads and searches, reports facts with sources, no recommendations · `prototype`: the smallest artifact that reacts, labeled disposable · the build steps above: `leancode`'s own text · `wayfinder`: plan in the conversation, one open question at a time; there is no map to keep.
- **Looking at the real app** has no browser MCP: write a short Playwright script — the project's own `@playwright/test`, or `npx playwright` — run it through Bash, save one screenshot per width and state to the scratchpad, and Read only the images the check needs. A flow that has to be explored click by click is the same script, grown one step at a time.
- `wayfinder` here means `mattpocock-skills:wayfinder`. Its map lives on the tracker that `docs/agents/issue-tracker.md` names, which `/setup-matt-pocock-skills` writes (the user runs it once per repo); with no tracker doc it defaults to local markdown in `.scratch/<effort>/`. The user's older copy, which kept maps in `.wayfinder/`, is retired.

Recorded 2026-10-16 from the user: "Matt's wayfinder is probably better", after comparing it with the user's own copy. The two `.wayfinder/` maps that existed (`ai-news`, `devpath`) were finished, so they stay as records and were not converted.

Recorded 2026-10-24 from the user: the `playwright` plugin uninstalled to save tokens ("ลบเลย ต้องการประหยัด token") — every MCP click returned a full page snapshot.

Recorded 2026-10-15 from the user: the extra Standards and Spec reviewers run only on high-risk changes ("2 ok", to the proposal that low-risk work gets leancode's single deep review).
