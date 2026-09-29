# กติกาการทำงาน (รวมจาก memory)

ใช้กับทุกโปรเจกต์ ทุก session ทุก subagent — ไม่ผูกกับงานใดงานหนึ่ง
ย้ายมาจาก auto-memory ของ workspace `~/Documents/GitLab` เมื่อ 2026-09-29
(merge `--no-ff` อยู่ใน `GIT.md` · ข้อเท็จจริง GitLab/CI อยู่ใน `~/Documents/GitLab/CLAUDE.md` §Environments)

## การติดตามงาน

1. **`HANDOFF.md` อยู่ใน git ทุก repo** — เป็นตัว tracking งานของทีม ห้าม gitignore, commit ไปพร้อมงาน ·
   repo ไหน ignore ไว้ให้ลบ rule ออก · ตอน "push" ถือว่า HANDOFF.md ที่ session นี้แก้เป็นไฟล์ของ session นี้ ·
   `.wayfinder/` ไม่เกี่ยว ปล่อยตามที่ repo ตั้งไว้ — ผู้ใช้: "เปิดให้ handoff ขึ้น git ได้เพราะเอาไว้ tracking งาน"

## การหาคำตอบ

2. **business rule ดูจาก PRD แรก ๆ + โค้ดตั้งต้น ไม่ใช่ client ที่มีอยู่** — ถามว่าฟีเจอร์ควรทำอะไรได้ ให้ไล่
   PRD/spec ฉบับเก่าสุดก่อน แล้วดู commit แรก / legacy snapshot · client (web/app) ใช้อ้างอิงได้แค่เรื่อง wiring
   (เรียก API ไหน หน้าไหน) ตอน port ระหว่าง client · ไม่มีเอกสารเก่ากว่านี้ให้บอกตรง ๆ —
   ผู้ใช้: "web ไม่ได้เป็นตัวตั้ง ต้องดูว่า prd แรกๆ มายังไง"

## Agents

3. **เรียก agent พร้อมกันได้ไม่จำกัด** (override `parallel.max_agents` = 3 ของ leancode) — ยกแค่เพดาน กติกาแบ่งงาน
   ยังอยู่: slice ที่รอผลของอีก slice ต้องรอ · หนึ่งเจ้าของต่อ repo/worktree · ห้ามสอง agent บน branch/tree
   เดียวกัน · builder แต่ละตัวมี worktree ของตัวเอง — ผู้ใช้: "เรียก agents ได้ไม่จำกัด"
4. **งานใหม่ที่ไม่ต่อเนื่อง → agent ใหม่เสมอ** ไม่ resume ตัวเดิม · resume ได้แค่เพื่อทำต่อ/ขยายงานเดิมโดยตรง ·
   agent ใหม่ได้ brief สั้น (repo, worktree, branch, contracts, queue) · session หลักก็เหมือนกัน แต่ `/clear`
   ได้แค่ผู้ใช้ — บอกเมื่อถึงจังหวะที่ควรตัด — ผู้ใช้: "เมื่อเป็นงานใหม่ที่ไม่ต่อเนื่องให้ clear session ทุกครั้ง"
5. **review ตามความเสี่ยง** — task เสี่ยงสูง (พลาดแล้วแก้ย้อนยาก หรือกระทบความปลอดภัย/เงิน/ข้อมูลผู้ใช้) review
   แยกทีละ task · task อื่นรวม review ครั้งเดียวตอนจบรอบ (ใช้แทน default ของ leancode ที่ review ทุก task)
6. **ระหว่างแก้รันเฉพาะ test ที่เกี่ยวข้อง** (`--filter`, path) · full suite ครั้งเดียวก่อน commit ของแต่ละ task
   และอีกครั้งตอนจบรอบ · ข้อ 5–6 ใส่ใน brief ของ builder ทุกตัว
7. **รายงานความคืบหน้าทุกครั้งมีตาราง agent ทั้งหมดที่เรียกมา** — ทำอะไร อยู่ repo/worktree ไหน สถานะ
   (running / done / parked) รวม agent ที่ builder เรียกต่อ · เรียก `ListAgents` ก่อนเขียน · บอก session อื่นที่ทำ
   repo เดียวกันเมื่อมีผล — ผู้ใช้: "ตอนทำงานให้แสดง agent ที่ summon ทั้งหมดด้วย"

## Auto mode

8. **auto mode: คำสั่งทำลายของ → บล็อก ไม่ถาม** — `soft_deny` ในตัว (`claude auto-mode defaults`) บล็อก
   force-push, `reset --hard`, `rm -rf`, DROP/TRUNCATE, kubectl/helm/terraform อยู่แล้ว —
   ผู้ใช้: "auto mode มันต้องทำเองไม่ถามแล้ว ไม่ใช่หมวดแพลน หรือ ask"
9. **auto mode: คำสั่งที่ใช้ key/secret ของ dev → ให้ยืนยัน ไม่บล็อก** (kubectl exec, get/patch Secret) ผ่าน rule
   `permissions.ask` ที่ผู้ใช้เพิ่มเอง — ผู้ใช้: "auto mode ไม่ต้องบล็อกการใช้คีย์ แค่ให้ยืนยัน" ·
   ข้อเท็จจริงที่ทดสอบแล้ว: `permissions.ask` ถามจริงใน auto mode (อย่าใช้กับงานไม่มีคนเฝ้า) · PreToolUse hook
   ที่คืน "ask" ไม่ถาม · Claude แก้ settings เองไม่ได้ (โดนบล็อกเป็น Self-Modification) → ส่ง rule ที่ต้องเพิ่มให้ผู้ใช้

## Skill leancode

10. **เรียก `leancode` เฉพาะงานที่เหมาะ** (ใช้แทน description ของ skill ที่บอก "Use for any coding task") —
    เหมาะ: งาน build หลายขั้น/หลายไฟล์ เช่น ฟีเจอร์, bug ที่ต้องไล่หลายจุด, refactor, ทำต่อจาก HANDOFF, autopilot ·
    ไม่ต้องใช้: ตอบคำถาม, แก้ config/เอกสาร/memory, แก้จุดเดียวที่ทางชัด, งาน git/shell ทั่วไป — ทำตรง ๆ ·
    งานไหนผู้ใช้อยากใช้ ผู้ใช้เรียก `/leancode` เอง — ผู้ใช้: "ปรับให้งานที่เหมาะสมค่อยเรียก leancode
    หรืองานที่อยากเรียกก็เรียกเองได้"
11. **แก้ตัว skill `leancode` ต้องเป็นกลาง** (`~/.claude/skills/leancode`, public GitHub repo) — ใช้ได้ทุก harness
    ไม่ใส่กฎของ repo ในเครื่อง · เรื่องเฉพาะ harness เขียนแบบ "ถ้า harness มี X ไม่งั้น Y" · enforcement อยู่ใน
    `adapters/` · แก้ SKILL.md ทุกครั้ง bump `version` + Changelog และใส่ version ใน subject ของ commit —
    ผู้ใช้: "ไม่ต้องล็อคกฏของ repo ในเครื่อง ให้เป็นกลางๆ"
