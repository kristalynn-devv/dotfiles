# dotfiles — agent instructions

แหล่งความจริงเดียวสำหรับคำสั่งที่ agent ทุกตัวต้องอ่าน

## โครงสร้าง

- `claude/` — ไฟล์ต้นฉบับ (แก้ที่นี่เท่านั้น) · `~/.claude/CLAUDE.md` เป็น symlink มาที่ `claude/CLAUDE.md`
  และ `@import` ในนั้น resolve จาก path จริงใน `claude/`
  - `CLAUDE.md` — ตัว entry ที่ `@import` ไฟล์อื่น
  - `IDENTITY.md` — เรียก dev ว่าอะไร + กติกา leancode
  - `GIT.md` — คำว่า "push": เอางานลง branch dev ของ repo (merge `--no-ff`) แล้ว push
  - `WORKING-RULES.md` — กติกาการทำงานทั่วไป (HANDOFF, การหาคำตอบ, agents, auto mode, leancode)
    ย้ายมาจาก Claude auto-memory
  - `RTK.md`, `WAYFINDER-LEANCODE.md`
- `agents/AGENTS.md` — **generated** ไฟล์แบนสำหรับ agent ที่ไม่รองรับ `@import` (Codex, Gemini) — อย่าแก้มือ ·
  inline เฉพาะไฟล์ในรายชื่อของ `sync.sh` (ตอนนี้ `IDENTITY.md`, `RTK.md`, `WAYFINDER-LEANCODE.md`)

## ใช้งาน

repo เป็น private — `gh auth login` ก่อน clone

```bash
git clone https://github.com/kristalynn-devv/dotfiles.git ~/dotfiles && bash ~/dotfiles/sync.sh
```

รัน `sync.sh` ซ้ำทุกครั้งหลังแก้ไฟล์ใน `claude/` เพื่อ regenerate `agents/AGENTS.md`

## เพิ่มไฟล์กติกาใหม่

1. เขียน `claude/<NAME>.md` — กติกาที่ใช้ทุกโปรเจกต์เขียนที่นี่ ไม่ใช่ใน Claude auto-memory
2. เพิ่ม `@<NAME>.md` ใน `claude/CLAUDE.md` — Claude Code เห็นตั้งแต่ session ถัดไป ไม่ต้อง link เพิ่ม
3. ให้ Codex/Gemini เห็นด้วย → เพิ่มชื่อในลูปที่สร้าง `AGENTS.md` ใน `sync.sh` แล้วรัน `sync.sh`
4. เพิ่มบรรทัดในหัวข้อ "โครงสร้าง" ด้านบน
