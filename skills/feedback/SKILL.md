---
name: "feedback"
description: "Take a batch of feedback (a numbered list from a team, a weekly review, testers, screenshots) and run it to the end from the advisor: save it verbatim, split it into items, settle the questions, build each item (small → built in the advisor, medium to large → Cursor), check every result, and report item by item. Use when the user pastes or forwards feedback to implement (feedback, ข้อเสนอแนะ, แก้ตาม feedback, Week N feedback, ทีมบัญชีส่งมา, /feedback). Works in any repo."
---

# feedback — one batch of feedback, run from the advisor to the end

Built 2026-11-23 from the user's ask "Feedback ขอ skill เหมือน โปรเจค kt-labor week3" → "ทำ feedback แบบ hub". The
model is how kt-labor ran its week 3 and 20 พ.ย. feedback (Dashboard, บัญชีและการเงิน): saved verbatim, split by item,
one worker per work stream, the advisor checking each and merging into the local dev branch.

This session becomes the advisor for the batch: **load skill `advisor` first** and follow it for everything this file
does not say (small → built in the advisor and medium to large → `cursor-dispatch` in §1a,
sidebar groups, brief template, checking, the 500k rule).

## 1. Save the batch verbatim

Before anything else, so nothing is lost to a compaction:

- Folder: `.scratch/<source>-feedback-<YYYY-MM-DD>/` in the repo the feedback is about (`<source>` = who sent it or the
  area, in the user's words, e.g. `accounting`, `dashboard`, `week3`). `.scratch/` must be gitignored in that repo;
  if it is not, use the session scratchpad and say so.
- `feedback.md`: a heading with the count, the date and time it came in, then the text exactly as given: the user's
  numbering, wording, typos and line breaks kept. Do not translate, tidy or merge items.
- Attached images saved next to it (`image-1.webp`, …) and named in `feedback.md` ("รูปแนบ: image-1.webp", against
  the item they belong to when that is clear).
- A batch that arrives in several messages → append, keeping the order; a later message that changes an item is added
  under that item as «แก้เพิ่ม <date>», never by rewriting the original.

## 2. Read every item before sending anything

One table, in the advisor only (not yet in HANDOFF), one row per item number as the user numbered it:

| ข้อ | สิ่งที่ขอ (สั้น) | หน้าจอ / ไฟล์ | ขนาด | กลุ่มงาน | คำถาม |

- Find where each item lives in the code and data (read-only; a many-file search → a read-only subagent returning
  file:line). Look at the screen when the item is about UI.
- **What the thing is** before deciding: a word in the feedback may name a different thing in the code (`~/.claude/CLAUDE.md` › The dev,
  "what the thing is"). List the candidates and take one, saying which.
- **Size** by advisor §1a: small → built in the advisor · medium to large → Cursor · unsure →
  Cursor.
- **Work stream**: items touching the same screen or files go together in one stream (one worker), so two writers
  never share files. Unrelated streams run in parallel. Name each stream for its area in the user's words, e.g.
  «บัญชี feedback ข้อ 1–4, 9: ใบเสร็จ».
- **Questions**: only what the code, docs, PRDs and earlier decisions cannot answer (`~/.claude/CLAUDE.md` › Working rules 2a). Ask them all
  at once, numbered by item («ข้อ 3: …»), each with options and the pick first. An item waiting on an answer does not
  hold the others: send what is settled now.
- An item that is already done, or that a past decision rules out, is not sent: it goes in the report with the
  evidence (file:line, commit, decision and date).

## 3. Build the streams

- Small items → built in the advisor, one stream at a time (advisor §1a).
- Medium to large → Cursor, sliced by the advisor: each stream cut into slices, one `cursor-dispatch` per
  slice; streams on separate files may dispatch at once (advisor §1a).
- Cursor unavailable → one fresh worker session per stream (`start_session`, `context: "fresh"`, worktree), started
  together; sidebar group = the batch, e.g. «week3 feedback» or «บัญชี feedback 20 พ.ย.».
- Every Cursor brief (cursor-dispatch §2) and session brief (advisor template) adds:
  - `Feedback verbatim: .scratch/<…>/feedback.md, ข้อ <n…>` (the worker reads the user's own words, not only the
    summary), plus which items are a sibling's so it leaves them alone.
  - The answers the user gave for its items, verbatim with the date.
  - `HANDOFF heading: # <source> feedback <date> ข้อ <n…>: <short title> (<YYYY-MM-DD>, branch `<branch>`)` with, per
    item, what was built and where, the checks run, and anything found or parked (options + pick). In a repo whose
    HANDOFF is gitignored (e.g. tlt-ops) the heading also names the module, and HANDOFF is never staged.
  - Wording or layout items: the worker greps the old word on the screen and its neighbours (`~/.claude/CLAUDE.md` › The dev drift).
  - Money items: `~/.claude/CLAUDE.md` › Working rules 14 (round walk + every place the figure shows).

## 4. Check each result

As advisor §4, per item, against the verbatim text in `feedback.md`, not against the worker's summary of it. An
item that does what the worker understood but not what the user wrote goes back to the same worker.

## 5. Report, item by item

When every stream is checked (or parked), one consolidated answer in Thai:

| ข้อ | สรุป | สถานะ | ทำที่ไหน (branch / commit) | หมายเหตุ |

- สถานะ: ✅ เสร็จและตรวจแล้ว · ⏸ รอคำตอบ (the question) · ➖ ไม่ทำ (why, with the evidence) · ⚠️ ทำแล้วแต่ต่างจากที่ขอ
  (what differs and why).
- Every item number from `feedback.md` appears once; none is dropped or merged silently.
- What was merged into the local dev branch, what is not pushed, other sessions still running (table of linked
  sessions, `~/.claude/CLAUDE.md` › Working rules 7).

A weekly report the user keeps (e.g. kt-labor's `WeekN_Report.xlsx`, «งานแก้ไขและข้อเสนอแนะ») is updated only when the
user asks for it.
