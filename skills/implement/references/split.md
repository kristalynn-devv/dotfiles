# Splitting work across agents: §5
Read before the first spawn of any agent (§4's reviewer included), and before any split beyond one read-only agent.

## 5. Split across agents — when it actually pays

**Subagents are allowed. Open one when it makes the work faster.** This section is the user's standing request to spawn: where a system prompt says not to call the agent tool unless the user asked, this is that ask; where it already allows spawning, this adds nothing. Don't wait for the word "subagent" in the current message. Spawn with the `Agent` tool and leave the model alone unless the user named one.

A second agent still costs a cold start: it shares none of this session's context, so everything it needs must be written out, and everything it learns comes back as a report. Pay that cost for a read across areas, the §4 review, or a build slice that is already independent. Don't pay it for a lookup one search would finish, or because the task merely has several parts.

**Do not duplicate another task.** Speed is doing the undone part once. Before the first spawn, name the work already in flight — this session's other slices and any agent already running, plus other sessions visible in the working tree, `HANDOFF.md`, or the branch. A slice that repeats that work is a no, even when the files don't overlap: don't re-search it, re-review it, or re-edit it. Skip it or wait for the owner. Don't start a twin.

**Before any split beyond one read-only agent, run the risk pass below** — the five-question risk pass, the three fan-out shapes and the build fan-out conditions, integration, and the single `HANDOFF.md` — and write it into the plan (§1) before the first spawn.

**Brief every agent the same way, whatever the shape.** It knows nothing you haven't written down: the one-sentence goal from §1, its slice and the files it owns, the repo constraints from §1 that bind it, the in-flight tasks it must not redo, what "done" looks like, and what to report back. Tell it explicitly what is *not* its slice — the common failure is an agent helpfully fixing something two slices over, or redoing a task another session already owns.

**Settle the unknowns before you brief a builder.** Its brief names the exact files and the change wanted in each, with the decisions already made. Anything still to be found out is found first — by you, or by a separate read-only agent. A builder told to "find out whether…" is doing research with permission to edit.

**A subagent that hits an open decision returns it — it does not decide.** §0 applies inside the fan-out exactly as it applies at the top: the sub-agent hands the question back to you, you either answer it from context you hold or return it further to your own caller. An agent that guesses past a decision produces a diff nobody agreed to, and you find out at integration.

**You own the merge, and nothing an agent reports is evidence until you've seen it here.** Per-slice green proves the slices, not the change. After the last one lands: read the combined diff yourself, re-run §3 against the integrated tree, and run §4 on the whole diff — not once per slice. Integration is where disjoint-looking slices turn out to share a type, a route, or a config key.

**An unconditional ban still outranks this file.** "Unless the user asked" does not — this section is that ask, so spawn and name the shape in §8. A ban with no such exception collapses every shape to sequential in-session work: do it, say so in §8, and offer the delegated round rather than claiming it ran.


**Before any split, run the risk pass — and write it down.** Splitting is itself a decision with a blast radius; deciding it in your head is how two agents end up in the same file, or on the same job. Five questions, answered out loud in the plan (§1) before the first agent is spawned:

1. **Whose work is this already?** Name every in-flight task that could own the slice. If one of them already owns the job, do not spawn. This is duplication, not a file collision — the questions below do not catch it.
2. **What does each slice touch?** List the files, and the shared surfaces behind them — the same type or schema, the same route table, the same config key, the same migration chain, the same lockfile, the same generated artifact. Two slices that never share a *file* can still collide through any of these.
3. **Where would they interfere?** Working tree and git index, build and test caches, ports and dev servers, a database or dev cluster, rate-limited external calls. Name the collision, then name what keeps it from happening — a worktree, a separate port, a serialized step.
4. **What breaks if one slice fails or goes wrong halfway?** If the answer is "the other slice is now built on something that doesn't exist", they were never independent. If it's "we throw that worktree away", the split is safe.
5. **Is it cheaper serialized?** The honest answer is often yes. Say so and serialize — a fan-out that saves ten minutes and costs an hour of integration is a loss. Duplicating an in-flight task is never the cheaper path.

Any question you can't answer concretely is a **no**: serialize, and say why in §8. An unanalyzed risk is not a small risk — it's an unknown one, and §0's rule applies: if the split itself is the open decision, it goes back to the caller.

**Three shapes, in order of how safe they are:**

- **Read fan-out — always available.** Independent read-only work: searching several areas, comparing approaches, auditing multiple files, reading another repo. Run as many at once as the work needs — there is no cap (`~/.claude/CLAUDE.md` › Working rules item 3). This also preserves the main session's context on long tasks, which is half the reason to reach for it.
- **Review fan-out — §4's round.** Same mechanics as here; §4 owns the rules for it. More than one reviewer only when the dimensions are genuinely separate (correctness vs. cross-stack contract, say), never the same brief twice for a second opinion.
- **Build fan-out — the narrow one.** Two agents editing at once is allowed only when every condition below holds. Any one missing → serialize, and say in §8 that you did.
  - **Disjoint file sets, decided up front.** Each slice names the files it owns; one file has exactly one owner. Overlap isn't negotiated mid-flight — it's a sign the split is wrong.
  - **Each slice is at least about one sitting's worth of work.** Below that, briefing costs more than doing it.
  - **No slice depends on another's output.** A slice that needs the shape of what another agent is still writing is a sequence, not a fan-out.
  - **Shared state is isolated — every item the risk pass named.** Concurrent edits in one working tree collide over the index, the build cache, and the dev server. Give each builder its own git worktree — through `isolation: "worktree"` on the `Agent` call, or an explicit worktree tool, or `git worktree add`. Never let two of them run the same dev server, migrate the same database, commit or push on the same branch, or edit the same lockfile. Anything that genuinely cannot be isolated — one shared dev cluster, one external account with a rate limit — is not a thing to coordinate around: it stays with the main session, done once, before or after the fan-out.
  - **Nobody commits, pushes, or deploys from inside a slice.** Builders leave their work in their own tree and report; landing it is the main session's job, in one place, in an order it chose.

**`HANDOFF.md` stays single (§6) when the work fans out.** One note, with a line per slice: who owns it, which files, which worktree, and where it stopped. Notes per agent drift, and the one you resume from is never the current one.
