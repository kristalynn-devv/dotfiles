# Kinds of work
Read by SKILL.md's Kind section: before the task list, read the section for the kind you named — only that one. Every kind still walks its tier's steps (§1); what is written here is where it differs. Section references point back into SKILL.md.

## Feature

The default walk. A new test, red on the baseline and green after (§3). Restructuring the feature needs along the way is part of it (§2); a refactor that stands on its own goes first, as its own change.

## Bug fix

1. **Reproduce before you read for a fix.** A command, a request, or a test that shows the failure — keep its output. Can't reproduce it → that is the finding: return what you tried and what you would need (§0). Don't fix blind.
2. **Cut variables before you chase.** Start with the one check that removes the most unknowns in a single move — call the component directly, skip the layers in front of it — rather than walking back from the far end. On someone else's machine or account, rule out their local state first: which build, which login, which settings.
3. **A hypothesis is a guess until a run confirms it.** Mid-diagnosis is when a memory of how the platform behaves gets stated as fact. Ask the live system or read the source — §1's lookup rule holds here too.
4. **Name the root cause in one sentence, with its evidence, before the first edit.** A fix that makes the symptom go away without that sentence is a patch on a guess.
5. **The reproduction becomes the regression test** — red before the fix, green after (§3).
6. **Look for siblings.** The same mistake elsewhere, found by a search run to its end (§1). Fix the ones the task list covers; name the rest in §8.
7. `build.max_cycles` failed fixes → stop. The model of the bug is wrong, not the patch.

## Refactor, move, cleanup

- **The proof is that nothing changed.** The checks that existed before, with their assertions untouched, green before and after. Updating an import path in a test is fine; editing what it asserts means behavior changed — that part is a feature or a fix: split it out, or return it (§0).
- **Nothing covers what you are about to move → pin it first.** A characterization test, green on the baseline and shown able to fail: break the code once on purpose, see it go red, restore.
- **Green after a deletion proves only that no test covered it.** Say what was checked instead — callers and importers searched to the end (§1), the app run.
- Bulk and scripted edits: §2's counting rule.
- Structure's case is *existing*: no new folder, layer, or pattern.
- Renaming something others reach from outside — an export, a route, a config key, a column — is a contract change. Take that kind's section too.

## Tests only

- **Every new test is seen red once.** Break the behavior it guards, watch it fail for the reason you predicted, restore. The diff at the end holds no production file.
- **A guard or a scan proves it sees its targets.** Print or assert how many things it examined; zero examined is a failure, not a pass.
- A test that asserts nothing happened first proves the action ran.
- **Flaky test** — reproduce the flake by repeating the run and note the failure rate. Fix the cause, not the symptom: no added retry, no longer sleep. Report the rate before and after.
- A real bug the test exposes is its own change, kind *bug fix*. Report it, and leave the failing test the way the caller wants it — red, or skipped with the reason written on it.

## Performance

- **One measurement, named:** what is measured, on what input, how many runs. Take it before the first edit and again after, on the same machine under the same conditions. Both numbers go in §8.
- Profile before guessing where the time goes.
- The correctness checks stay green. A faster wrong answer is a regression.
- A cache, an index, a pool, or a new dependency carries a cost of its own — invalidation, write cost, memory. Name it beside the number; Optimize's measurement rule applies.

## UI or visual

- **Look at it.** A screenshot at each width, theme, and state the change can reach, and then read the picture: fitting is not the same as readable, and no test measures "looks wrong". Scale it with the tier — a small-tier change looks at what it touched, a new screen at everything the project supports.
- States, not only the happy one: empty, loading, error, long text, the keyboard path and focus.
- **Check that the existing harness renders what you changed.** An end-to-end sweep stopped by a login wall or an error branch passes without ever drawing your component. If it doesn't reach it, mount the component yourself with a temporary probe, look, then delete the probe (§3). A stand-in backend that lets the real app run past the wall is not a probe: keep it in `.leancode/` (§9) for the next change, check it is still there before building another, and check it answers every request this change makes before trusting what it shows — a route it lacks fails exactly like a broken change.
- A size, a radius, or a spacing has partners — the padding around it, the icon inside it, the height of its neighbor. Zoom in on the changed element next to its neighbors.
- **One rule across many places → write the check first** and let it list the violators, then fix the list; the check stays as the guard. Count the non-obvious cases: a link styled as a button, an input behind a wrapper component.
- A choice between designs is the caller's (§0). Show the options; don't pick.

## Config, infra, CI, deploy

- The way back is written down first (§2), and the target is verified before anything touches it (§3).
- **Proof is at the destination:** the job that ran, the header the public URL returns, the variable inside the running process. A config file that reads right says nothing about the layer in front of it.
- **How the platform behaves is looked up or asked of the live system** — rule precedence, defaults, what triggers what. Never recalled.
- A CI change is tested by the pipeline run it produces. Name the jobs that actually ran; skipped, manual, or allowed-to-fail is not passed.
- Every surface gets the key (§2). Secrets stay out of the diff, the logs, and the report.
- An effect you can't observe from where you are is a capability block (§0): say what someone has to run and what to send back.

## Dependency upgrade

- **Read the changelog or migration guide for every major version crossed** (§1: look it up), and list the breaking changes that touch this codebase — found by search, to the end.
- One dependency, or one set that has to move together, per change. Follow the guide's stepping when it says not to skip a major.
- Lockfiles and generated files change only by running the tool that owns them. Nothing else rides in the change.
- **Proof:** the full check green, the app actually started — types passing is not running — and each listed breaking change checked at its call sites.
- The way back is reverting the manifest and the lockfile together.
- Adding or swapping a dependency is a decision (§2): return it unless it was the ask. Where the project or the harness has a dependency-audit tool, run it on the new version.

## Schema or data migration

- **Write the down path, or say there is none.** None, on data others use → the user's call in every mode (§2).
- **Run it on a disposable copy first** — forward, then back and forward again where a down path exists — and look at the data, not the exit code: row counts before and after, a sample of the rows that changed.
- **Shape it so every step is safe with the code on either side.** Add first (a new column, nullable or defaulted), move the code to work with both shapes, backfill, and remove the old shape last, in its own change.
- Large tables: batch the backfill, and name the lock it takes and how long it ran on the copy.
- Never against a database you have not verified (§3), and never unconfirmed (§2).

## One-off script or data fix

- **Dry run first.** It prints what it would change — the counts and a sample — and you read that output before the real run.
- Safe to run twice, or the data it touches is exported first. Say which.
- Target verified (§3). One-way on shared data → the user's call (§2).
- After the real run, compare its counts with the dry run's. A mismatch is a finding to report, not to explain away.
- The script is scratch unless the caller wants it kept: `.leancode/` (§9), or deleted.

## Contract across services or repos

- **Compare the real thing.** One side's actual payload — captured, not imagined — against the other side's type or parser (§4's cross-stack dimension).
- **Name the rollout order before the first edit:** the additive change on the provider, then the consumers, then the removal — each step working with the previous one already deployed. A step that needs both sides deployed at the same moment is a decision; return it (§0).
- Find every consumer by a search run to its end, in the other repos too where you can read them. Name the ones you could not check.
- One `HANDOFF.md` for the whole change, in the repo the work is driven from (§6).

## Port or rewrite

- **The old implementation is the spec for behavior** — unless the caller said the port is also a redesign. Copy the behavior first; improving it is its own change, afterwards.
- **Proof is parity.** The old one's tests run against the new one, or both run on the same inputs and the outputs are compared. No tests on the old one → pin it with characterization tests first.
- A difference you find — a bug in the old code, an edge it handles oddly — is a decision: keep it or fix it. Return it (§0); don't improve it silently.
- Move in slices that each run: one module, screen, or endpoint at a time, each proven, with old and new able to live side by side until the last slice lands.
- When the old code itself is in doubt, what the feature is meant to do comes from Investigation's rule on intent, below.

## Merge or conflict resolution

- **Read both sides before touching a marker** — what each one changed and why: its commits, its tests. The resolution keeps both intents. Where they truly can't coexist, that is a decision; return it (§0).
- Never settle a conflict by taking one side wholesale unless that was the ask. A lockfile or generated file is regenerated by its tool, not merged by hand.
- **Proof:** the full check on the merged tree (Land), and each side's change still there — its tests present and green.
- A conflict in a file your change never touched is someone else's work meeting someone else's work. Ask before resolving it.

## Docs or content

- §9's go-ahead rule holds unless the doc is the task.
- **Proof:** every command and sample in it was run, the links resolve, and the rendered page was looked at.
- A statement about the code is checked against the code (Investigation, below). A doc is where a stale claim goes to be believed.
- Match the structure and voice the doc already has; one topic per doc (§9).

## Prototype or spike

- **State the one question it answers** — which design, can this API do it, is it fast enough. Done means that question is answered, shown running.
- **Disposable and labeled.** Its own branch, or a folder whose name says what it is; nothing on a production path imports it.
- Skips the delegated review (§4), Optimize, and — inside its own folder — Structure's no-new-pattern rule. Keeps §2's rules on irreversible actions, secrets, and shared environments, and still means reading the diff, running it, and looking at it.
- Several options → show them side by side. The choice is the caller's (§0).
- **Promotion is not a merge.** The chosen option is rebuilt through the full walk as a feature — tests seen red, the review, Structure — and the scaffolding of the experiment (the switcher, the losing variants, their styles) is deleted in that same change.

## Revert or undo

- **Committed → the version control's own revert of that one change:** a new commit, history kept. Rewriting history is §2's irreversible action.
- **Not committed yet → undo your own edits, file by file.** A blanket restore also wipes work that isn't yours (§2).
- Look for what was built on top of it since. A revert that conflicts is a decision; return it (§0).
- **Proof:** the check that passed before the change passes again, and whatever the change did outside the code — a migration, a config key, a flag — is undone too, or named as still in place.

## Review of someone else's change

- **Read-only.** No edits, no commits, no pushes. Asked afterwards to fix what you found → that is a new change, and it starts at §1.
- Where the harness has a dedicated review skill or tool, use it. Otherwise run §4's three dimensions yourself, plus its question about what should be there and isn't.
- Read what the change touches, not only the hunks: the callers, the tests, the other side of any contract.
- **A finding is a file, a line, what breaks, and the input or sequence that breaks it.** Check each one against the code before reporting it — run it when that is cheap. What you can't substantiate is dropped, or asked as a question and labeled as one.
- Order by what breaks: correctness, security, and data loss first. No grade, and no style notes the project's linter would raise anyway.
- Say what was not reviewed — files skipped, things not run.

## Investigation

- **Answer from the code and the running system.** Docs and comments are leads. A memory of how a tool behaves is a guess until checked.
- Every claim of scope, use, or absence rests on a search run to its end (§1). "Nothing uses this" needs the search that could have found a user.
- **What a feature is meant to do is not what an existing implementation happens to do.** Intent comes from the spec — oldest first — and from the first commits. No such source → say so plainly.
- Give each claim its evidence — the file and line, or the command and its output — and keep what was verified apart from what is inferred. Say what you did not check.
- Read-only. A probe or script you add is removed afterwards. Against a live system: verify the target first (§3), and read-only operations only.
- **Check before declaring a dead end.** The assumption that makes it one is usually the thing nobody verified.
- Stop when the question is answered. If the answer implies a change, offer it; don't start it.

## Conditions

These change how the walk runs. The proof stays what the kind asks for.

### No baseline yet — a new project

- Stack, structure, and conventions are foundational decisions, and the caller's (§1). Once made, record them where the next session will find them — with the go-ahead §9 asks for.
- Use the stack's own generator for the skeleton where it has one, and keep that generated baseline separate from the first real change, so real work has a diff someone can read.
- The first change's job is to make a baseline exist: it builds, one test runs, the linter runs. Everything after is measured against it (§3).

### Urgent — something is down

- **The order changes; the proof does not.** Restore first with the smallest reversible move there is — revert the change that caused it, turn the flag off, roll the release back — rather than writing new code under pressure.
- Urgency never waives verifying the target (§3), confirming what is irreversible (§2), or reading the diff.
- Evidence is recovery seen at the destination — the request succeeds, the error rate drops — not "the deploy finished".
- Everything skipped is named in §8. The real fix then walks as a bug fix: reproduce, root cause, regression test.

### No version control

- Copy each file into one scratch folder before its first edit. Those copies are the baseline, the diff, and the way back.
- Say so in §8, and suggest putting the project under version control — don't do it unasked.
