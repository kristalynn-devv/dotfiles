# HANDOFF
updated: 2026-10-14

## leancode 5.0.0 — every kind of work, and a Claude-only skill setup

### Goal
Make `skills/leancode` fit every kind of coding work, cut what it costs in tokens, and settle which skills and plugins Claude Code loads.

### State
branch: main · committed locally on 2026-10-14 as three commits, not pushed: leancode v5.0.0 (`skills/leancode/`), the `sync.sh` change (with `README.md`), and the skill mapping (`claude/WAYFINDER-LEANCODE.md`, the regenerated `agents/AGENTS.md`, this file)
uncommitted, someone else's: `claude/WORKING-RULES.md` — not touched
Checked: frontmatter parses, every § and file pointer resolves, the 18 rows of the Kind table match the 18 sections of `references/kinds.md`, tunables agree between `SKILL.md` and its README, `sync.sh` runs clean. Not checked: a real task run on 5.0.0.

Plugins in Claude Code (user scope): `impeccable@impeccable` 4.5.2 · `mattpocock-skills@claude-plugins-official` 1.2.3 · `daisyui@daisyui` 5.7.0 · `context7@claude-plugins-official` · `playwright@claude-plugins-official` (the last two installed by the user).

Token figures, at the 3.03 bytes per token measured on claude-opus-5-5 from one session's usage records:
- `SKILL.md` 55.4 KB, about 18,300 tokens per load (4.1.1: about 15,600). Description about 190 tokens in every session.
- A fresh session started at 51,500 tokens before the first reply. Of that: the skill list about 8,400 (19 skills synced from the claude.ai account 3,600 · 16 bundled 2,500 · plugins and personal the rest), MCP server instructions about 3,650, the `CLAUDE.md` imports about 5,200 (now 5,600: the mapping added to `WAYFINDER-LEANCODE.md` costs about 800).
- That one session reached 470,000 tokens of context over 95 calls, 25 million tokens re-read in total. Session length outweighs every other figure here.

### Decisions
- Kinds live in one table in `SKILL.md` with the procedure per kind in `references/kinds.md`; the table alone is the fallback.
- Landing (commit, merge, push) is its own unnumbered section so §0–§10 keep their numbers.
- §10's procedure moved to `references/autopilot.md`; the trigger and a fallback stay inline [user].
- 4.2.0 is not released on its own: one commit, one changelog line, 5.0.0 [user].
- `sync.sh` links this repo's skills into `~/.agents/skills` as well as `~/.claude/skills`, and moves a real folder it finds at a link target into `.backup/<agent>-skills/` [user]. The old `~/.agents/skills/leancode` is in `.backup/agents-skills/`; its run log was carried over unchanged into `skills/leancode/FRICTION.md` (gitignored).
- §4 no longer says "never on Fable" [user].
- Matt Pocock's skills take every build step he has one for, his review beside leancode's own [user]. They come from the `mattpocock-skills` plugin, all 25 of them [user: "link all of Matt's", "Claude only"]; the five links from `~/.agents/skills` into `~/.claude/skills` made earlier the same day are removed again, as is the `sync.sh` step that made them. The mapping is in `claude/WAYFINDER-LEANCODE.md`; `SKILL.md` stays neutral (§0: a step the caller's rules give to another skill runs through it).
- Can Matt Pocock's set replace ours? Checked against 1.2.3: not `leancode` (his `implement` is five lines — no proof per kind, no rules on irreversible actions or other people's files, no correctness review, no audit, and it commits unasked), not `pause`/`resume` (his `handoff` writes one note to the OS temp folder, with no resume, no checkpoint and no pending decision), not the user's `wayfinder` (his keeps the map on an issue tracker; the user's copy keeps it in `.wayfinder/` and hands off to `leancode`). It does replace the procedures for a hard bug, a prototype, a merge conflict and doc research, which is what the mapping uses.

### Next action — make leancode cheaper to load and safe under compaction
Do this in a fresh session; it needs nothing from the one that wrote this note.

Why: Claude Code keeps only the first 5,000 tokens of a skill after it compacts a conversation. For `SKILL.md` today that is Tunables, Versioning, §0, §1 and Kind. Structure, §2, §3, §4, Optimize, §5, §6, §7, Land, §8, §9, §10 and Never are dropped — in exactly the long sessions the skill is for. A one-line note at the top now tells a compacted session to read the file again; that restores correctness at the price of reloading all 18,300 tokens.

Plan, moving text verbatim as 3.0.0 and the §10 move did:
1. `SKILL.md` becomes a core of at most 4,500 tokens that survives compaction whole: the compaction note, Tunables, §0, the tier ladder and the goal rule from §1, a map of the walk naming the file to read at each step, the safety rules of §2 (irreversible actions, shared environments, what you did not write), §6's triggers, Never.
2. `references/plan.md` — the rest of §1, the Kind table, Structure. Read before the task list at the small and full tiers.
3. `references/build.md` — the rest of §2, and §3. Read before the first edit.
4. `references/review.md` — §4. Read when the build is green and the tier asks for a review.
5. `references/close.md` — Optimize, §7, Land, §8, §9. Read before calling the change done.
6. §5 keeps its standing authorization inline; its other paragraphs join `references/split.md`. §6's paragraphs past the triggers join `references/handoff.md`.
7. Each pointer is a gate with a fallback, as the existing ones are ("Can't read it → …"), and §7 gains one line: each step's file was read at its step.
Expected: about 4,500 tokens at the typo tier (18,300 today), about 11,500 before the first edit at the small and full tiers with the rest arriving at its step, and the core intact after a compaction. Total for a full-tier run stays about the same.
Checks to re-run afterwards: frontmatter parses; every § and `references/*.md` pointer resolves; Kind rows match `references/kinds.md` sections; tunables in `SKILL.md` and its README agree; the first 5,000 tokens of `SKILL.md` contain the whole core.
Not started: it reshapes how the skill loads, and the user has not said go.

### Found, not fixed
- Context7 is connected twice in Claude Code: the claude.ai connector and the `context7` plugin, same server. Options: (a) uninstall the plugin; (b) turn the connector off for Claude Code. Pick: (a) — the connector needs no setup. The user installed the plugin, so it was left alone.
- Skills synced from the claude.ai account cost about 3,600 tokens in every Claude Code session. Seven duplicate something local or are superseded: `leancode`, `lean-code-workflow`, `pause`, `resume` (copies of `skills/`), and `wayfinder`, whose uploaded text still names `lean-code-workflow` as the build skill where the copy in `~/.agents/skills/wayfinder` says `leancode`. Office and browser skills (`docx`, `pptx`, `xlsx`, `pdf`, `docs`, `google-workspace`, `computer-use`, `chrome-browser`, `built-in-browser`) are about 2,600 of it. Only the account owner can switch them off, in claude.ai's settings.
- The user's `wayfinder` reaches Claude Code only as that stale upload. Options: (a) move `~/.agents/skills/wayfinder` into `skills/wayfinder` here so `sync.sh` links the current copy, then delete the upload; (b) leave it. Pick: (a).
- Bundled skills the coding work never uses can be hidden with `skillOverrides` in `~/.claude/settings.json` (`"off"` or `"name-only"`): `dataviz` about 480 tokens, `artifact-capabilities` 240, `artifact-design` and `artifact-diagramming` 130, `claude-api` 360 if no Claude API work is planned. Not applied: it is a settings change and a choice about what Claude can see.
- MCP connectors from the claude.ai account that the coding work does not use add server instructions and tool names to every session. The user is already switching some off.
- `skills/resume/SKILL.md` §6 — says leancode's rule is "delete the note once every step is ✅"; leancode §6 now removes only its own lines. The pointer still works; the paraphrase is stale. Not edited, because the uploaded copy of `resume` is byte-identical today.
- `claude/WORKING-RULES.md` item 5 ("review by risk — replaces leancode's default") can now be stated as the tunable `autopilot.review: by risk`. Not edited: the file has another session's uncommitted changes.
- The links for `leancode`, `pause` and `resume` in `~/.agents/skills` (for Codex) are still there. With the setup now Claude-only they do nothing for Claude and harm nothing; removing them means dropping `agents` from the loop in `sync.sh` step 2.
- `claude.ai` copy of `leancode`: needs the whole folder uploaded again (it now needs `references/`), or deleting.

### On "push"
`git push origin main` — the repo has one branch. `claude/WORKING-RULES.md` stays out until its own session commits it.
