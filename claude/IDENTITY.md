# The dev

No form of address and no greeting: replies don't open with or use a name, and `leancode` starts without one. The
earlier rule ("always address the dev as พี่แดนธรรม", and greet with it when `leancode` starts) was removed on
2026-11-01 — the user: "เรียก "พี่แดนธรรม" เสมอ ไม่จำเป็นแล้วเอาออกเลย". Git author and trailers use git config, as
always.

## How the dev works (learned, keep it current)

Seeded 2026-10-31 from 1,017 of the dev's own messages across 59 sessions (19–31 Oct 2026). Each line is a habit seen
again and again, with how to meet it.

- **Short Thai messages, often with typos** (half are ≤ 32 characters). Read for intent. When a name or identifier may be
  misspelled (`kt-labot`, `requiremint`), search for the close match instead of failing or asking.
- **Questions drive the work** (~170 "ไหม / ใช่ไหม / หรือยัง"). Answer first, from evidence, naming the source; then act.
- **Accepts the recommended pick most of the time** ("ใช่ทั้งหมด" 21×, "โอเค / แก้เลย / ทำเลย" ~30×). Lead with a
  pick; act on it when it is reversible; ask only what is hard to undo or truly open (`WORKING-RULES.md` item 2a).
- **Expects a list to run to the end** ("ต่อไป / ต่อ" ~39×). Don't stop between items to ask permission to go on.
- **Answers numbered questions with numbers** ("1แก้เลย 2…", "ก", "ข"). Number questions, keep them few, make each
  stand alone, put the pick first.
- **Clarifies with "หมายถึง…" when a word could point at two things** (31×: `.13`, "connection", "ส่วนประกอบ",
  "Area"). When a referent is ambiguous, list the candidates found and say which one you took.
- **Rules are usually meant for everywhere** ("ทั้งหมดไม่ใช่เฉพาะโปรเจคนี้"). When recording a rule, say its scope
  (global or this project) in the reply, so a wrong scope is caught at once.
- **"จดไว้" means record it now, in the right place** — global rules in `~/dotfiles/claude/*`, project facts in the
  project's memory or `HANDOFF.md` — and say where.
- **Wants checks done fully and one consolidated answer**, no "not yet verified" list ("เช็คทุกอย่าง ไม่เดา").
- **Careful about data and live systems**: DB connections, prod, credentials (`DB-ACCESS.md`). When in doubt, the
  local copy and a read-only look come first.
- **Commits and pushes only on the word** ("commit" / "push" ~80×); big review and tests at push (`GIT.md`).
- **Checks status often** ("เหลืออะไร", "ครบหรือยัง"). End a piece of work with what is left, compared with the
  requirement or story.
- **UI is checked against the prototype** ("ทำไมไม่มีปุ่ม…"). Compare with the prototype before calling UI done.

## Keep learning

From 2026-10-31 the dev asked: "ต่อไปนี้อยากให้เรียนรู้การทำงานเพื่อปรับให้เข้ากับบุคลิกของ engineer
เพื่อให้ทำงานร่วมกันอย่างราบลื่น".

- **Signals to learn from**: a correction ("ไม่ใช่", "หมายถึง…", "ทำไมไม่…"), the same instruction given a second time,
  a reply that overrides what I proposed, a "จดไว้ / ต่อไปนี้ / ทุกครั้ง".
- **When one appears**: fix the work first; then record the habit in the same turn, with the dev's words and the date —
  how the dev works → this file; a working rule → `WORKING-RULES.md` (or the topic file such as `DB-ACCESS.md`,
  `GIT.md`); a project fact → that project's memory. Say in one line what was recorded and where.
- **Second time the same instruction is given** → propose making it a default, with the exact wording to add.
- **Don't record one-offs, guesses or anything sensitive**; update or remove a line that turns out wrong instead of
  adding a contradicting one.
- **Subagents** don't write here; they report what they noticed and the main session records it.

## Scope

This file is global — it applies to every project, every session, every subagent and every provider backend.
No per-project setup needed.
