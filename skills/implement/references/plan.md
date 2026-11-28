# Plan: §1, Kind, Structure
Read before the first edit of any change above the typo tier (SKILL.md's walk map). Section numbers (§0–§10) point to the files SKILL.md's walk map names.

## 1. Plan before touching code

- A discussion or a plan-only ask is not build work → answer or plan, then stop here. Don't walk §2–8. Two read-only asks still owe a proof of their own — a review of someone else's change, and a question about what the code does. Take their rows in Kind, and stop when they are answered.
- Restate the goal in one sentence. If it can't be stated in one sentence, the scope is unclear — narrow it.
- **Say that sentence out loud, with the slice it covers and the kind of work it is (Kind), before the first edit.** A goal restated only to yourself is a misreading nobody gets the chance to catch — and the cheapest moment to catch one is before any file is touched.
- **When the goal changes mid-flight, rewrite it before the next edit** — the sentence, the task list, and `HANDOFF.md`'s Goal and Decisions. §4 checks against the goal you are building to *now*, not the one you started the session with. A rewritten goal is a new change: what it adds owes its own proof (§3) and gets its own review round, and the two-round review ceiling (§4) counts again from the rewrite — otherwise the last thing asked for is the one thing nobody reviewed.
- Locate and read the code this touches — existing patterns, callers, related tests — before writing steps. A plan built without this risks resting on wrong assumptions about what's already there.
- **Uncommitted work already sits in a file this change will touch → ask before the first edit whether to commit it first.** Once two changes share a file uncommitted, they can only land as one commit (Land). In autopilot (§10) the previous task's commit already settles this.
- **Scope comes from a search run to its end.** How many callers, which files import it, whether anything uses it at all — count from the full result, never from output you cut short, and never take "the file exists" for "it is used": find the importer. A doc's statement about the code (what exists, what CI runs, what is unused) is a lead to check, not a fact to build on.
- Nothing to read because this is a new project or a part of it that doesn't exist yet → this isn't a coding step, it's a foundational decision (stack, structure, conventions). Return it to the caller (§0) — don't default your way into an architecture nobody chose. Whatever gets decided becomes the "existing pattern" every later change matches against.
- If the project has a docs router or index (e.g. a root `CLAUDE.md` or `AGENTS.md` that maps areas to files), follow it and read only the doc(s) matching this change's scope — never the whole doc tree. If no router exists, grep docs for the specific area instead of opening every file. A doc irrelevant to the current change is not worth its tokens.
- **Constraints are not scoped — read them every time.** A repo's standing prohibitions ("additive only", "don't refactor", "don't touch business logic", a frozen contract) usually live in the root `CLAUDE.md` or its equivalent, and usually do *not* match the scope of your change — so the scope-limited read above walks straight past them. Find them first, and restate the ones that bind this change in the plan. A rule you never read is a rule you will break. When an instruction and a repo constraint collide, say so before building and let the caller resolve it — don't quietly pick a side.
- Write the sequential steps as a task list before editing anything — in the session's todo or task tool. Mark each step done as it finishes, not in a batch at the end. Before each edit, the file belongs to the step marked current; if it doesn't, that is §2's widening, said out loud first, or a new step added to the list first.
- A change that adds a file, moves code, or could be done by reshaping where things live → Structure, before the task list.
- Something doesn't resolve cleanly from the code or project docs — an unfamiliar library's API, a framework convention, a spec detail, a version-specific behavior — look it up (web search, official docs, or a docs tool like Context7) before guessing from memory or training data, which can be stale or simply wrong. Cite what you found when it changes the plan.
- Ask only questions that actually block the work; otherwise pick the obvious default and state the assumption. A genuinely blocking question goes back to the caller (§0), never into the build as a guess. A reference lookup that resolves it is better than either guessing or asking.
- **Scale the ceremony to the change, and say which level you picked.** One file, no behavior change (typo, copy, comment) → read the diff yourself; skip §4, Structure, Optimize, §6, §7, charting. A small fix proven end to end by one test, or, where the code has no seam for a test, by one reproduction in the real app seen red before the fix and green after, or a markup-and-styles change that adds no state, no data the screen did not already have, and no behavior, looked at in the real app (Kind: UI) → §2, §3, Structure, Optimize, §8, with §7 cut to the lines that apply and §4's delegated round only when the change is high-risk. Anything else → the whole walk. Reading the diff before calling it done is never optional at any level.

## Kind — name the work, because it decides the proof

The tier (§1) sets how much ceremony a change gets. The kind sets what §3 has to show and which steps bend — a refactor proven by a brand-new test, or a bug "fixed" without ever being reproduced, passed the wrong exam. Name the kind with the goal sentence. A change that is two kinds owes both proofs. Restructuring a feature or fix needs along the way (§2) is part of that change; a refactor that stands on its own goes first, as its own change, so its proof — nothing changed — can still be read.

`references/kinds.md` holds the procedure for each row. Read your row's section before the task list for every kind except a plain feature; at the typo tier the row is enough. Can't read it → the row is the rule.

| Kind | What §3 must show | What bends |
|---|---|---|
| Feature | a new test, red on the baseline and green after | nothing — the default walk |
| Bug fix | the bug reproduced first; that reproduction red before the fix, green after | the root cause is named, with its evidence, before the first edit |
| Refactor, move, cleanup | the same checks, assertions untouched, green before and after | an assertion that has to change means behavior changed — split it or return it |
| Tests only | each new test seen red by breaking the code on purpose, then restored | no production edits; a bug it exposes is its own change |
| Performance | one measurement, same conditions, before and after | no number, no change |
| UI or visual | the real app, looked at, at every width and state the change can reach | a green sweep is not seeing |
| Config, infra, CI, deploy | the effect observed at the destination | way back first (§2); how the platform behaves is looked up, never recalled |
| Dependency upgrade | the full check green, the app started, each breaking change in the changelog checked at its call sites | one dependency, or one coupled set, per change; lockfiles change only through their tool |
| Schema or data migration | run forward — and back, where a down path exists — on a disposable copy, and the data looked at | additive step first, destructive step last and separate; one-way on shared data is the user's call (§2) |
| One-off script or data fix | a dry run whose output was read, then the real run's counts against it | target verified (§3); safe to re-run, or the data backed up first |
| Contract across services or repos | one side's real payload against the other side's type | rollout order named; every step works with the previous one deployed |
| Port or rewrite | old and new run on the same inputs and agree | behavior is copied before it is improved; a difference found is a decision, not a fix |
| Merge or conflict resolution | the merged tree's full check green, and each side's change still there | both sides read before choosing; neither is dropped wholesale |
| Docs or content | samples run, links resolve, the rendered page seen | §9's go-ahead, unless the doc is the task |
| Prototype or spike | it runs, and answers the one question it was built for | disposable, isolated, labeled; skips §4 and Optimize; reaches production only by being rebuilt through the walk |
| Revert or undo | the check that passed before the change passes again | the version control's own revert of that one change — history kept, never rewritten |
| Review of someone else's change | every finding checked against the code | read-only — §4's dimensions, no edits |
| Investigation | the search or the run behind each claim, taken to its end | read-only — answer, then stop |

Three conditions change how the walk runs, not what it has to prove:

- **No baseline yet** — a new project. The foundational decisions go back to the caller (§1); the first change after them makes a baseline exist: it builds, and one test runs.
- **Urgent** — something is down. Restore first with the smallest reversible move — a revert, a flag, a rollback — and prove recovery at the destination. What was skipped is named in §8, and the real fix then walks as its own kind.
- **No version control** — copy each file before its first edit. Those copies are the diff and the way back.

## Structure — name the case before the edit

Two cases. Name one out loud before the task list. If both seem true, it is existing. New is the case you have to justify.

- **Existing** — a fix, a feature, or a refactor the current layout can hold. Name the neighbor: the file or folder this change sits beside, and the pattern it copies. File layout, naming, and where this kind of logic lives stay as they are. Moved code lands next to the code it already belonged with. The diff adds no new folder, no new layer, and no new pattern. A refactor that also invents a structure is two changes — return it (§0).
- **New** — nothing that already exists can hold the change without a second copy of the same idea. A repo with no pattern yet is not this case: that decision goes back to the caller (§1). Name the boundary and the interface in one sentence each before the task list. If that sentence is still an open decision, return it (§0). A lookup of what this codebase already does, or a design-guidance skill, can settle it; guessing cannot. On the diff, every new file belongs to that boundary, and callers cross only through the named interface. That seam is load-bearing — Optimize does not collapse it for having one call site. The three-call-site rule (§2) still gates a helper extracted inside an existing structure. It does not gate a boundary this case already named.

Check the diff against the case you named once, after §4 when that round ran, before Optimize. A diff that drifted is corrected once to match the case, then the check §3 used is re-run. That correction does not re-enter §4, and it does not refresh this check. If it still does not match, return it (§0). On a match, go to Optimize. The typo tier skips this. A small-tier change names existing and confirms no new folder, layer, or pattern appeared.
