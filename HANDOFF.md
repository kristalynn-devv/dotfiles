# HANDOFF
updated: 2026-10-16

## leancode 5.1.1 and a Claude-only setup

### State
branch: main · leancode is at v5.7.0 · everything here is committed; `git status -sb` says whether it is pushed
Checked: `SKILL.md` frontmatter parses, every § and file pointer resolves, the 18 rows of the Kind table match the 18 sections of `references/kinds.md`, tunables agree between `SKILL.md` and its README, `sync.sh` runs clean. Not checked: a real task run on 5.x.

Plugins in Claude Code (user scope): `impeccable` 4.6.0 · `mattpocock-skills` 1.2.3 · `daisyui` 5.7.0 · `context7` · `playwright`. Disabled: `engineering@synced`, `cowork-plugin-management@synced`.

Token figures, at the 3.03 bytes per token measured on claude-opus-5-5 from one session's usage records:
- `SKILL.md` 55.6 KB, about 18,400 tokens per load; its description about 190 in every session.
- A fresh session started at 51,500 tokens before the first reply: the skill list about 8,400 of it, MCP server instructions 3,650, the `CLAUDE.md` imports 5,200 (`WAYFINDER-LEANCODE.md` is now about 2,200 of that).
- One session reached 470,000 tokens of context over 95 calls, 25 million tokens re-read in total. Session length outweighs every other figure here.

### Decisions
- Kinds live in one table in `SKILL.md`, the procedure per kind in `references/kinds.md`; the table alone is the fallback.
- Landing (commit, merge, push) is its own unnumbered section so §0–§10 keep their numbers.
- §10's procedure lives in `references/autopilot.md`; the trigger and a fallback stay inline [user].
- §4 no longer says "never on Fable" [user].
- Claude only [user]: `sync.sh` links rule files and skills into `~/.claude` and nothing else. The links it had made in `~/.agents/skills`, `~/.codex` and `~/.gemini` are removed, `agents/AGENTS.md` is deleted, and Codex has its own one-line `AGENTS.md` back.
- Matt Pocock's skills take every build step he has one for, his review beside leancode's own [user]. They come from the `mattpocock-skills` plugin. UI work goes through `impeccable:impeccable` before the first edit; daisyUI is optional on an existing project and the default on a new one [user]. The mapping is in `claude/WAYFINDER-LEANCODE.md`; `SKILL.md` stays neutral.
- Plugins the rules name are checked before the work starts; a missing one is told to the user at once with its install command, and is not installed unasked [user]. leancode §0 carries the neutral form of that rule (v5.1.0).
- Autopilot does not stop between tasks [user, 2026-10-16, after a real run over grilled tickets stopped to ask after the first]: it stops early only at `autopilot.max_parked` or when the context can't hold the next task and can't be compacted; a compaction makes the note current and the run goes on. `claude/WAYFINDER-LEANCODE.md` puts autopilot ahead of the map check, so `wayfinder` is not called between tickets and nobody is asked mid-run (v5.6.0).
- `autopilot.max_parked` counts distinct open questions, not parked tasks: one question parks its dependents without ending the run [user, 2026-10-16]. Default stays 3; the user's own rules don't override it yet (v5.7.0).
- One real clone per machine, at `~/dotfiles` [user, 2026-10-16]; any other path to it is a link, as `~/Documents/GitHub/dotfiles` is here (the old second clone went to `~/.Trash/dotfiles-Documents-GitHub-20261016`). `bash ~/dotfiles/install.sh` sets a machine up in one go: `sync.sh` links every `claude/*.md` and every skill, then the three marketplaces and five plugins are added where missing; the two settings are printed, not written.
- `wayfinder` is `mattpocock-skills:wayfinder` [user, 2026-10-16: "Matt's wayfinder is probably better"]. The user's copy is retired: it was taken out of `skills/` (it went to `~/.Trash/dotfiles-skills-wayfinder-20261016`), and its `~/.claude/skills` link was removed. `claude/WAYFINDER-LEANCODE.md` now routes on an open map in `.scratch/<effort>/map.md`, or on the tracker `docs/agents/issue-tracker.md` names. The finished `.wayfinder/` maps in `ai-news` and `devpath` stay as records.
- Can Matt Pocock's set replace ours? Checked against 1.2.3: not `leancode` (his `implement` is five lines — no proof per kind, no rules on irreversible actions or other people's files, no correctness review, no audit, and it commits unasked), not `pause`/`resume` (his `handoff` writes one note to the OS temp folder, with no resume and no pending decision), and since 2026-10-16 his `wayfinder` replaces the user's own copy [user]. It does replace the procedures the mapping hands to it.

### Next action — make leancode cheaper to load and safe under compaction
Do this in a fresh session; it needs nothing from the one that wrote this note.

Why: Claude Code keeps only the first 5,000 tokens of a skill after it compacts a conversation. For `SKILL.md` today that is Tunables, Versioning, §0, §1 and Kind; Structure, §2, §3, §4, Optimize, §5, §6, §7, Land, §8, §9, §10 and Never are dropped. A note at the top tells a compacted session to read the file again, which restores correctness at the price of reloading all of it.

Plan, moving text verbatim as 3.0.0 and the §10 move did:
1. `SKILL.md` becomes a core of at most 4,500 tokens that survives compaction whole: the compaction note, Tunables, §0, the tier ladder and the goal rule from §1, a map of the walk naming the file to read at each step, the safety rules of §2 (irreversible actions, shared environments, what you did not write), §6's triggers, Never.
2. `references/plan.md` — the rest of §1, the Kind table, Structure. Read before the task list at the small and full tiers.
3. `references/build.md` — the rest of §2, and §3. Read before the first edit.
4. `references/review.md` — §4. Read when the build is green and the tier asks for a review.
5. `references/close.md` — Optimize, §7, Land, §8, §9. Read before calling the change done.
6. §5 keeps its standing authorization inline; its other paragraphs join `references/split.md`. §6's paragraphs past the triggers join `references/handoff.md`.
7. Each pointer is a gate with a fallback, as the existing ones are, and §7 gains one line: each step's file was read at its step.
Expected: about 4,500 tokens at the typo tier (18,400 today), about 11,500 before the first edit at the small and full tiers with the rest arriving at its step, and the core intact after a compaction.
Checks to re-run afterwards: frontmatter parses; every § and `references/*.md` pointer resolves; Kind rows match `references/kinds.md` sections; tunables in `SKILL.md` and its README agree; the first 5,000 tokens of `SKILL.md` contain the whole core.

### Found, not fixed
- `sync.sh` links into `$HOME/.claude` even when `CLAUDE_CONFIG_DIR` is set, while `install.sh`'s plugins then go to that directory. Not changed: nobody here sets it, and whether Claude Code reads rule files and skills from it was not checked. Found 2026-10-16.
- `sync.sh` never removes a link left behind when a rule file or skill is renamed or deleted; that link dangles in `~/.claude` until removed by hand. Found 2026-10-16.
- Git Bash on Windows copies instead of linking (`ln -s` without developer mode), and each re-run then moves those copies into `.backup/`; the README sends Windows to WSL or `mklink`. Found 2026-10-16.
- Review of leancode against the changes agreed on 2026-10-14: every agreed change is in the files (47 presence checks, then one full read of `SKILL.md`). The read found three small wording defects, fixed in 5.1.1. The review was done by the session that wrote the changes; no independent reviewer has read 5.x, and no real task has run on it.
- Two settings the agent was not allowed to write (the harness blocks edits to `~/.claude/settings.json` as self-modification); the user adds them by hand: `"skillOverrides": {"dataviz": "name-only", "artifact-design": "name-only", "artifact-diagramming": "name-only", "artifact-capabilities": "name-only", "claude-api": "name-only"}` (about 1,150 tokens fewer per session) and `"syncClaudeAiSkills": false` (about 3,600 fewer: stops the skills synced from the claude.ai account from loading in Claude Code, without changing the account).
- MCP connectors from the claude.ai account that the coding work does not use still add server instructions and tool names to every session; they are switched off per project in `/mcp`.
- The copy of the user's retired `wayfinder` uploaded to claude.ai still names `lean-code-workflow` and loads as `anthropic-skills:wayfinder` beside `mattpocock-skills:wayfinder`, until skill sync is off or the upload is deleted.
- The copies of `pause` and `resume` uploaded to claude.ai are now older than the local ones (they still name `lean-code-workflow`); they load beside the local ones until skill sync is off or the uploads are replaced.
- Left in `~/.agents/skills`, unused by Claude Code: `claude-handoff` (differs from the plugin's copy), `karpathy-guidelines`, `scrutinize`, `wayfinder` (the user's retired copy). Twelve old copies identical to the plugin, `diagnosing-bugs` and the old `leancode` backup went to `~/.Trash` on 2026-10-14.
- `mattpocock-skills:code-review` stops and asks for `/mattpocock-skills:setup-matt-pocock-skills` in a repo that has no `docs/agents/issue-tracker.md`; that setup is run by the user, once per repo.
- `skills/leancode/SKILL.md` §3 names `web-design-guidelines` as an optional UI pass; it is not installed, and `impeccable` covers that step here.
- `claude/WORKING-RULES.md` item 5 ("review by risk — replaces leancode's default") can now be stated as the tunable `autopilot.review: by risk`. Not edited: nobody asked for it.
