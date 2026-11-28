# Close: §7 Audit, Land, §8 Report, §9 Doc hygiene
Read before the audit, before any commit, merge or push, and before the report.

## 7. Audit — did the walk actually happen

§4 reads the diff; this reads the session. Most failures of this walk are a step that was skipped or half-done rather than a line of code nobody checked — and nothing noticed at the time. This is what notices.

- **Run it in-session, from your own transcript, before the report.** Never delegate it: a subagent sees the diff, and a step that never happened leaves nothing in a diff to see. It re-reads what you already did, so it costs a fraction of §4 — and it does not stand in for §4, it is what catches §4 going missing.
- **Scale it with §1's tier**, exactly like every other section.
- **Each line ends settled — done, fixed now, or named in §8 as deliberately skipped** with the tier or kind that allowed it. Mentioning a step is not doing it: a missing §3, §4, Structure, or Optimize that this change actually needed means go and run it.
- **Audit the rules that are here, not the ones this session wishes were here.** A gap with no rule behind it is named in §8 for the main session to record (`~/.claude/CLAUDE.md` › The dev Keep learning), not a checklist item you add on the spot — same reason the skill doesn't edit its own rules mid-task.

What to walk:

- Tools — a skill or tool this walk names that is missing here was replaced by the section's fallback (or `build-steps`' fallback), and §8 names which. No step was skipped for a missing tool.
- §0 — every open decision went back to the caller. Nothing was guessed past. A capability block went back as an action plus the evidence needed, and nothing is reported verified on someone's word alone. The skills the caller's rules name, and those §3 calls for, were checked before §1 and a missing one was said then; a step given to one ran through it, or §8 says why not.
- §1 — the goal was said out loud before the first edit, and it is still the goal being built to. A goal rewritten mid-flight got its own proof and its own review round.
- §1 — the repo's standing constraints were read, not only the scope-matched docs.
- §1 — no claim of scope rests on a search you cut short, and none about the code rests on a doc you didn't check.
- Kind — the kind was named with the goal, and what §3 produced is the proof its row asks for, not a weaker one. A read-only kind left no edit behind.
- Structure — the case was named before the first edit. Existing, including a refactor: no new folder, layer, or pattern. New: the diff matches the boundary and interface named beforehand, and that seam was not collapsed. The check ran once; a correction did not re-enter §4.
- §1 / §2 — the task list stayed current step by step, and every file touched is on it, or the widening was said out loud *before* it was touched.
- §2 — anything reaching a shared environment has its way back written down; anything irreversible was confirmed before it ran — by the user in an interactive mode, by the harness's guard in an autonomous one, and a one-way change to shared data by the user in both. A block was recorded in Blockers, not routed around.
- §2 — nothing that wasn't yours was committed, stashed, reverted, or tidied. A bulk edit's replacements were counted.
- §3 — the baseline came from a run that finished before the first edit, not from what a doc claims builds.
- §3 — the test that proves new behavior was actually seen red against that baseline — the right red, for the reason predicted — and no check passed by examining nothing.
- §3 — the full diff was read, the checks covering what it touched ran after the last edit (a risky change: the project's whole check), and §8 says the whole check is owed at push, and every result reported is a concrete one (output, exit code, screenshot). No check was run again on a tree it had already passed.
- §3 — UI or user-visible change → seen working in the real app; auth, input handling, rendering user-controlled data, or secrets → `security-review` ran, or §3's in-session fallback ran and §8 names it.
- §4 — a high-risk change had its delegated round before its commit, findings were checked against the code, and rejected ones named; any other change had no round and §8 says it was not reviewed. Spawning agents is forbidden here → say so in §8 and offer the round; a self-read does not count as one.
- Optimize — one pass ran on the diff that shipped, or the tier skipped it and §8 says so. The check §3 used was re-run after the moves and was green, or the breaking move was reverted. A move that would have changed a test was skipped and named. A speed change names its measurement. The pass did not run a second time.
- §5 — a subagent ran only on work no other in-flight task already owned; a duplicate was skipped and named. An "unless the user asked" clause on spawning was treated as satisfied. An unconditional ban → said so in §8.
- §5 — work was split only after the risk pass was written down, and no two agents touched the same file or shared surface.
- §5 — per-slice results were re-verified on the integrated tree; nothing was reported green on a slice's word alone.
- §6 — `HANDOFF.md` matches where the work actually is: this work's entry is current, or marked done and kept while other work in the note is open, or removed once none is. Nobody else's lines were touched.
- Land — the deploy-gating whole check ran on the tree going up before the push; landing by a merge, it ran once, on the merged tree. Every commit, merge and push followed `~/.claude/CLAUDE.md` › Git. Each commit holds one change. The state was re-read before anything left the machine, a merged tree was green before its push, and what the push was meant to set off was seen to happen.
- §10 — autopilot only: every ✅ task has its own commit, holding only its files, verified green, with its own §4 round when it is a risky one, none otherwise. Every pick is in Decisions, its commit, and the report. Every parked task's work is in a named stash with its question in Blockers. Nothing pushed, amended, or rebased. The whole check ran on the final tree.

## Land — commits by `~/.claude/CLAUDE.md` › Git

The walk ends at a verified diff. Committing, merging, and pushing follow `~/.claude/CLAUDE.md` › Git (commit and push on judgment, the word "push", worktree work merged into the local dev branch, the cases that still ask first) — it replaces leancode's "only when asked"; autopilot (§10) commits locally and never pushes. Work left uncommitted or unpushed → §8 says so.

- **One change, one commit.** The commit is the unit that gets reverted, so it holds this change's files and nothing else — staged by path, never `-A` or `.`; what isn't yours stays out (§2). Two changes tangled in one file that can't be staged apart are named in §8, not folded together quietly.
- **No review round here** — the risky changes had theirs before their commits (§4).
- **At "push", the deploy-gating checks run here** (`~/.claude/CLAUDE.md` › Git §What "push" runs first: the jobs the repo's CI runs before deploy, not the rest of the suite) on the tree about to leave, before the push — it is the first full run since the last push for the changes that deferred it. A whole check already green on this exact tree counts (§3), as at the end of an autopilot run; don't run it twice. Red → fix through the walk, in its own commit, and re-run; never push on red.
- **Landing by a merge → the tree about to leave is the merged tree.** Merge locally first, then run the whole check once, there. A run on the branch before the merge would be a second whole check for the same push; the checks each change ended on already cover the branch. Red there that this work caused → fix it through the walk, in its own commit, and re-run; red that comes from what arrived on the base → the merge rule below.
- **Re-read the state before anything leaves the machine.** A branch read ten messages ago has had time to move. Fetch and look at what arrived before a merge or a push; commits you didn't expect are someone's work, to be integrated the way the repo does it or returned (§0) — never overwritten. A rejected push means the remote moved, not that it needs force.
- **A merge is a new tree — verify it before it leaves the machine.** Green on the branch proves the branch, not the result of merging it into a base that has moved. Run §3's full check on the merged tree before pushing it or opening it for review — once: a merged tree identical to one that check already passed is not run again (§3). Red after the merge → stop there: don't push, leave the branch and the merge in place, and say what fails — nothing has left the machine, so it is still cheap to undo. A failure there is never waved off as flaky.
- **Pushed is not delivered.** Confirm the remote holds the commit you verified. When the task depends on what the push sets off — a pipeline, a deploy — that result is part of the proof (Kind): a job that was skipped, or is waiting on a manual step, did not pass.

Landing after §7 has run → walk §7's Land line before the report.

## 8. Report

What changed (files), why, and how it was verified — in a few lines, opening with the kind and tier it was walked at and closing with where the work now sits: uncommitted, committed, or pushed. A claim whose evidence is not in hand is labelled unverified, with what would settle it. §7 already established what was done, skipped, and still open — this says it out loud, gaps included, rather than establishing it a second time.

**How the output reads** — this applies to every message that reaches the user, not only this section: reports, questions, and returns (§0).

- Emoji are signal, not decoration. One on a heading, a status, or a question, where it tells the reader at a glance what kind of thing they are looking at — ✅ done · ⚠️ risk · ❓ needs an answer · 🔴 blocked · 📋 plan. Never inside code, file paths, commands, or command output.
- **Gloss every technical term the first time it appears in a message, when the user writes in a different language from the term.** Pair the term with its equivalent in the user's language, in parentheses, in whichever order reads naturally — `rollback (<the user's word>)` or `<the user's word> (namespace)`. The point is that neither language is the one the reader has to guess at.
- Gloss for meaning, not word-for-word. A translation more confusing than the term it explains is worse than none — leave such a term bare rather than inventing a word nobody uses.
- Gloss once per message, not on every mention.

If this change affects documented behavior (a route, an API contract, a decision, a convention), flag it and ask the user which doc is authoritative for it and whether it needs updating — don't edit docs by default alongside code. See §9 for what to do once they say yes.

## 9. Doc hygiene — keep docs from bloating

- Docs are edited only on the user's go-ahead, never by default — a request whose task is the doc is that go-ahead. Exception (`~/.claude/CLAUDE.md` › The dev, drift): a doc, glossary, comment or UI copy this change itself made stale is fixed in the same piece of work and named in §8. If a change looks like it makes a doc stale, say so and ask which doc is authoritative and whether to update it — only touch it after they confirm it's actually necessary.
- One topic per doc. When a doc has bloated or its scope has grown too wide to read in one pass, that's the one exception to the ask-first rule above — split it automatically: turn it into a folder, one file per topic, no need to ask first since this only reorganizes existing content rather than changing it. Then update whatever router/index points to it so the split doesn't orphan a topic.
- This work depends on or connects to another project/repo/service (a shared package, an API another repo owns, a cross-repo contract) → say so, and ask whether it's worth recording as a reference doc for future work that spans both. Same go-ahead rule as above — note the connection, don't write the doc unasked.
- Scratch or agent-only artifacts that aren't meant for human discovery (self-review notes, in-progress splits, working drafts, and a stand-in backend or driver script built to run the real app that the next change can reuse) → keep them in the repo's `.scratch/` folder instead of scattering them into the docs tree. `HANDOFF.md` (§6) is the one exception — it stays at the repo root itself, precisely so it's the first thing found when resuming interrupted work.
- New doc → use the minimal skeleton in `references/doc-skeleton.md` in this skill's `references/` (Topic line, Rule, Why, Related, Open — skip what doesn't apply), adapted to whatever doc convention the project already has.
