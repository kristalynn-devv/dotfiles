# Review and Optimize: §4, Optimize
Read before the §4 round on a high-risk change, and before Optimize on any change above the typo tier.

## 4. Self-review — delegated, once, on high-risk changes only

Review deliberately, not repeatedly. One pass by a reader that didn't write the code beats several re-reads by the model that just wrote it — that model is the worst reviewer of its own work.

- **When it runs — high-risk changes only.** A change that is hard to undo, or touches security, money, or user data, gets its round here, before its commit, and §8 says it was flagged; the round is this file's reviewer plus the `code-review` Standards and Spec reviewers (skill `build-steps`). Every other change ends at §3's checks for what it touched, Structure and Optimize, and its commit — no round here, at Land, at push, or at the end of an autopilot run; §8 says the change was not reviewed, so nobody takes it as reviewed.

- **Delegate it** — §5 owns the mechanics of spawning, briefing, and the spawning-forbidden fallback, and its standing authorization covers this round. A missing "use a subagent" in the current message is not a ban. Spawn a general-purpose agent (the `Agent` tool with `subagent_type: "general-purpose"`). It runs in the background, so draft the §8 report and walk §7's lines up to §3 while the round runs — neither edits the diff, and the rest of §7 waits for what comes after. Optimize and any fix wait for the findings. **The reviewer reads and reports; it never edits.** Fixing is the main session's job — a reviewer that patches its own findings puts changes into the diff that nobody reviewed, and collides with §5.
- **Brief it properly.** The reviewer doesn't share this session's context: give it the one-sentence goal from §1, the full diff (`git diff`, plus `--staged` if anything is staged), and the surrounding files it should read. Ask for concrete findings — file, line, what breaks — not a grade.
- **Every pass covers all three dimensions:**
  - *Correctness* — edge cases, empty/null inputs, error paths, off-by-one, async ordering, resource cleanup, security (auth checks, input trust), performance (extra queries/renders, unbounded work the change introduced).
  - *Fit* — dead code, leftover debug output, naming, broken callers, structure and file placement matching project convention, anything the change silently regressed.
  - *Cross-stack contract* (skip if the change touches only one side) — do the request/response shape, field name, type, and error format actually match on both ends? A frontend type and a backend response can each look correct in isolation while drifting apart; diff the real payload/type against what the other side sends or expects, don't just re-read each side separately.
- **Ask what should be there and isn't.** A diff can only show what was written; these get missed precisely because nobody typed them — rate limiting or lockout on anything guessable, an authorization check on a path that just became reachable, an upper bound on payload size and page size, a timeout and a retry cap on every outbound call. A new surface usually needs a control no one wrote.
- **Findings are evidence, not verdicts.** The reviewer lacks this session's context and will sometimes be wrong. Check each finding against the code before acting on it, and name the ones you rejected and why. "Fixing" a finding you don't believe makes the code worse and buries the findings that were real.
- Fix what it finds and re-run §3. Send it back for a second round only if the fixes amount to a new change of their own — otherwise one round is the whole loop. A correction the Structure check makes is not that new change.
- **Two rounds is a hard ceiling, not a budget to spend.** Hitting it is a signal, not a step: stop delegating, say plainly that the change has outgrown one review cycle, and hand the caller (§0) the findings that are still open plus what you'd do next. Re-reviewing past the ceiling hides a scope problem instead of surfacing it.
- A clean pass means the process is clean, not that the goal is met. Before moving on, confirm the one-sentence goal from §1 is actually satisfied, not just that no more issues turned up. Then run the Structure check on the diff, then Optimize — a correct diff the caller still has to clean is not done.

## Optimize — one pass, then stop

§4 asks what breaks. This asks what the caller will still want to delete once the change is correct. A finding §4 already fixed is not done again here.

Run it on the diff you are about to hand over, after §4 when that round ran, and after §3 has been re-run for any fix that landed. The session that holds the goal runs it — it edits, so it is not delegated and it is not a second review. The typo tier skips it. A small-tier change runs it only on the lines it touched.

Three moves, in order:

1. **Remove.** Dead code, unused names, debug leftovers, a branch the final shape made unreachable, a comment that restates the next line. If removing it does not change behavior, it goes. Orphans this change created go; pre-existing dead code stays and is named in §8.
2. **Collapse.** A helper, parameter, or branch this change added that now has a single call site and no reason to vary. Inline it. A seam Structure named as load-bearing stays, including when it has one call site. Do not add an abstraction, a config key, or a layer to make the diff cleaner.
3. **Bound the cost this change introduced.** An N+1, an unbounded loop or payload, a query or render that now runs per item with no cap. Fix those in place. A cache, an index, a pool, or a new dependency needs a measurement named in the §8 report. No measurement, no speed rewrite.

Out of scope: behavior the goal didn't ask for, files the task list doesn't name, and anything that changes what the tests assert. A move that would need a new or changed test is skipped and named in §8. It does not go back to §3 — going back reopens the walk, and §4 would run this pass again.

After the three moves, re-read the diff and re-run the check §3 already used. A pass that made no move re-runs nothing (§3). Green means the pass kept behavior. Red means revert the move that broke it — do not patch forward. An orphan the pass itself just created (an import left behind by a removal) is still this pass. Then stop. One pass is the whole budget. Anything you still see and did not do is named in §8 — it is not a reason to walk the diff again, and not a question for the caller.
