---
name: build-steps
description: Which dedicated skill runs each build step under leancode (tdd, diagnosing-bugs, impeccable, codebase-design, code-review, resolving-merge-conflicts, prototype, research, wizard, daisyUI) and what leancode still requires of it; the plugin check before work starts, install commands, and the fallback when a plugin or playwright-cli is missing. Load before a build step that has its own skill (new tests, a bug that doesn't yield, UI or visual work, a new boundary or module reshape, a review, a merge conflict, a prototype, docs research, a step only a person can take), and when a plugin or skill these rules name is missing.
---

# Build steps with a skill of their own

`leancode` walks the build and decides what has to be proven. The steps below run through a dedicated skill: Matt Pocock's, from the `mattpocock-skills` plugin and called as `mattpocock-skills:<name>`, and for UI work `impeccable:impeccable`. The skill supplies the how; what `leancode` asks to be shown for the step is still owed.

| Step of the walk | Skill | Still owed to `leancode` |
|---|---|---|
| Tests for new behavior (§3) | `tdd` | the test seen red for the right reason; the relevant tests green before the commit (the full suite runs at push) |
| A bug that doesn't yield at first look | `diagnosing-bugs` | the root cause in one sentence, with its evidence, before the fix; the search for siblings |
| UI or visual work, before the first edit | `impeccable:impeccable` — `shape` to plan the structure of something new, `audit` or `critique` to check what is already there | the real app looked at, at every width and state the change can reach |
| A new boundary, or reshaping a module (Structure) | `codebase-design` | the case named before the edit; no new pattern on a refactor |
| Review (§4) | `code-review` — two more reviewers, Standards and Spec, only on a high-risk change (hard to undo, or touching security, money, or user data); any other change gets `leancode`'s own round alone | `leancode`'s own round still runs; every finding is checked against the code before it is fixed |
| A merge or rebase conflict | `resolving-merge-conflicts` | intents that can't coexist go back to the caller; the merged tree's full check before it is pushed |
| A prototype or spike | `prototype` | it reaches production only by being rebuilt through the walk |
| Facts from docs or other primary sources | `research` | each claim keeps its source; no recommendations |
| A step only a person can take (§0) | `wizard` | the evidence that has to come back |

- Review (§4) runs only on a high-risk change, before its commit — `leancode`'s `review.when: risky only` and `autopilot.review: by risk` (`WORKING-RULES.md` items 5–6a); every other change gets no round, and "push" runs the full test suite without one.
- `code-review` takes two inputs up front: the fixed point — the commit this change started from (the commit before the high-risk change) — and the spec: the ticket or spec file, or the goal sentence when there is none.
- When one of these skills says to ask the user, or to commit: interactive → ask, as it says. Autopilot → pick or park (`leancode` §10) and log it. Commits and pushes follow `GIT.md` and `leancode`'s Land, never the skill.
- **daisyUI** (`daisyui:daisyui`) is optional on an existing project: use it where the project already uses daisyUI, or when the user asks. A new project uses it from the start — that choice is already made, so it is not a question to return. The skill's own description says to load it for any HTML or JSX; this rule is the one that holds.
- The typo tier has none of these steps, and loads none of these skills.

Recorded 2026-10-14 from the user: "use Matt Pocock's for all of it" — chosen as: every step he has a skill for, with his review added beside `leancode`'s own, not instead of it. And: "on UI work, use impeccable to look at the structure and check first; daisyUI is optional, but a new project uses it right away."

## Missing skills (use the fallback, don't stall)

**Check before the work starts.** The plugins these rules name — `mattpocock-skills`, `impeccable`, `daisyui`, `context7` — have to be in the session's skill or tool list (`claude plugin list` settles a doubt). One is missing → tell the user at once, with its install command, then carry on with the fallback; don't install it yourself unless asked. The command is `claude plugin install <name>@claude-plugins-official`, except `impeccable@impeccable` (first `claude plugin marketplace add pbakaus/impeccable`) and `daisyui@daisyui` (first `claude plugin marketplace add saadeghi/daisyui`). On a machine set up from dotfiles, offer `bash ~/dotfiles/install.sh` before the single commands: it installs or re-enables all four, installs `playwright-cli` with its skill, and adds `anthropics/claude-plugins-official` where a fresh install lacks it.

- `mattpocock-skills` plugin not installed → `research`: a subagent reads and searches, reports facts with sources, no recommendations · `prototype`: the smallest artifact that reacts, labeled disposable · the build steps above: `leancode`'s own text · `wayfinder`: plan in the conversation, one open question at a time; there is no map to keep.
- **Looking at the real app** has no browser MCP: use `playwright-cli` (skill `playwright-cli`) through Bash — one named session per project (`-s=<project>`), `resize <w> <h>` per width, `screenshot --filename=<scratchpad>/<width>-<state>.png` per width and state, and Read only the images the check needs; `close` the session when done. A flow explored click by click is the same session, one command at a time. It writes snapshots to `.playwright-cli/` in the current folder → the repo has to ignore it (`.playwright-*` or `.playwright-cli/`); add the line if it doesn't. `playwright-cli` missing → tell the user (`npm install -g @playwright/cli@latest`, then `playwright-cli install --skills --global`) and fall back to a short Playwright script — the project's own `@playwright/test`, or `npx playwright` — saving the same screenshots.
- `wayfinder` here means `mattpocock-skills:wayfinder`. Its map lives on the tracker that `docs/agents/issue-tracker.md` names, which `/setup-matt-pocock-skills` writes (the user runs it once per repo); with no tracker doc it defaults to local markdown in `.scratch/<effort>/`. The user's older copy, which kept maps in `.wayfinder/`, is retired.

Recorded 2026-10-16 from the user: "Matt's wayfinder is probably better", after comparing it with the user's own copy. The two `.wayfinder/` maps that existed (`ai-news`, `devpath`) were finished, so they stay as records and were not converted.

Recorded 2026-10-24 from the user: the `playwright` plugin uninstalled to save tokens ("ลบเลย ต้องการประหยัด token") — every MCP click returned a full page snapshot.

Recorded 2026-10-29 from the user: `microsoft/playwright-cli` installed (CLI global, skill in `~/.claude/skills`) and made the way to look at the real app ("ทำไว้เลย"); the hand-written script stays as the fallback.

Recorded 2026-10-15 from the user: the extra Standards and Spec reviewers run only on high-risk changes ("2 ok", to the proposal that low-risk work gets leancode's single deep review).
