# dotfiles — agent instructions

แหล่งความจริงเดียวสำหรับคำสั่งที่ agent ทุกตัวต้องอ่าน

## โครงสร้าง

- `claude/` — ไฟล์ต้นฉบับ (แก้ที่นี่เท่านั้น) ถูก symlink ไป `~/.claude/`
  - `CLAUDE.md` — ตัว entry ที่ `@import` ไฟล์อื่น
  - `IDENTITY.md` — เรียก dev ว่าอะไร + กติกา leancode
  - `RTK.md`, `WAYFINDER-LEANCODE.md`
- `agents/AGENTS.md` — **generated** ไฟล์แบนที่ inline ทุกอย่างเข้าด้วยกัน
  สำหรับ agent ที่ไม่รองรับ `@import` (Codex, Gemini) — อย่าแก้มือ

## ใช้งาน

```bash
git clone <repo> ~/dotfiles && bash ~/dotfiles/sync.sh
```

รัน `sync.sh` ซ้ำทุกครั้งหลังแก้ไฟล์ใน `claude/` เพื่อ regenerate `agents/AGENTS.md`
