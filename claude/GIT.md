# คำว่า "push"

## กติกา

**ผู้ใช้บอก "push" = เอางานของ session นี้ลง branch dev ของ repo แล้ว push** ใช้กับทุก repo

- branch dev คือ branch หลักที่ทีมใช้ของ repo นั้น เช่น `development` หรือ `develop` ให้ดูจาก repo
  ไม่ต้องเดา (`git symbolic-ref refs/remotes/origin/HEAD` หรือ CLAUDE.md ของ repo)
- งานอยู่บน branch อื่น → อัปเดต branch dev ใน local แล้ว `git merge --no-ff <branch>` แล้ว
  `git push origin <dev>` · ห้าม fast-forward และห้าม `git push origin HEAD:<dev>` แม้จะ ff ได้สะอาด
- งานยังไม่ได้ commit → commit **เฉพาะไฟล์ที่ session นี้แก้** บน branch dev (ระบุ path ทีละไฟล์
  ห้าม `git add -A` / `.`) แล้ว push · คำว่า "push" นับเป็นคำสั่งให้ commit ด้วย ไม่ต้องถามซ้ำ

## ขอบเขต

- ไฟล์ที่ session อื่นแก้ค้างไว้ไม่เอาเข้า commit
- commit ของ session อื่นที่ค้างอยู่ใน local จะติดขึ้นไปตอน push → บอกในรายงานเสมอ ไม่ต้องหยุดรอ
- แยก commit ตามงาน ไม่ใส่ AI trailer (`Co-Authored-By`) ตามกฎของแต่ละ repo/memory
- แตก branch ใหม่ยังต้องมีเหตุผลจริง · "push" ไม่ได้แปลว่า force-push หรือ rebase ของที่ push ไปแล้ว
- push ไป remote ที่ไม่ใช่ branch dev (เช่น main/production) ยังต้องถามก่อน

บันทึก 2026-09-28 จากผู้ใช้: "ถ้าบอก push คือ merge branch or code changes in session to dev and
push" · "ไม่ใช่แค่ repo นี้ ทุก repo" · เรื่อง `--no-ff` (2026-09-24): "ต่อไปไม่ต้อง ff ให้ push ปกติ"
