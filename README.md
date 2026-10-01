# ClipHistory

แอปเมนูบาร์สำหรับ macOS เก็บประวัติคลิปบอร์ด (ข้อความ + รูปภาพ) กด `⌘⇧V` แล้วคลิกรายการเดียวเพื่อวางทันที  
A tiny macOS menu-bar clipboard history. Press `⌘⇧V`, click an item, it is pasted.

- ค้นหาในประวัติ · ปักหมุดรายการสำคัญ · ปุ่มลบ/ปักหมุดโผล่เมื่อชี้เมาส์
- ตั้งจำนวนรายการที่เก็บได้ 1–120 (ค่าเริ่มต้น 50) · เปิดอัตโนมัติเมื่อเข้าเครื่อง
- ใช้ได้กับ **macOS 11 Big Sur ขึ้นไป** ทั้ง Intel และ Apple silicon
- ข้อมูลอยู่ในเครื่องเท่านั้น ไม่ส่งเข้าเครือข่าย · ข้ามรายการจากตัวจัดการรหัสผ่าน (1Password, KeeWeb และแอปที่ติด concealed marker)

## ติดตั้ง / Install

เปิด Terminal แล้ววางคำสั่งเดียว:

```sh
curl -fsSL https://raw.githubusercontent.com/chantanawat/ClipHistory/main/install.sh | sh
```

หรือโหลด `ClipHistory.zip` จากหน้า [Releases](../../releases/latest) แล้วรัน `sh install.sh ~/Downloads/ClipHistory.zip`
(สคริปต์จะลบ quarantine flag ให้ — แอปนี้เซ็นแบบ ad-hoc ไม่ได้ผ่าน notarization ของ Apple เลยดับเบิลคลิกเปิดตรง ๆ จาก zip ที่โหลดด้วยเบราว์เซอร์แล้ว macOS จะเตือน)

## ใช้งานครั้งแรก

1. ไอคอน `▣` จะขึ้นที่แถบเมนู · กด `⌘⇧V` เพื่อเปิดประวัติ
2. คลิกรายการ → macOS ถามสิทธิ์ **Accessibility** → เปิดให้ ClipHistory ใน  
   System Settings → Privacy & Security → Accessibility (ใช้ส่ง `⌘V` ให้เอง)
3. ภาพหน้าจอ (`⇧⌘3/4/5`) เข้าประวัติอัตโนมัติ — ถ้า macOS ถามสิทธิ์โฟลเดอร์ Desktop ให้อนุญาต
4. ไอคอนฟันเฟืองในหน้าประวัติ = ตั้งค่า (จำนวนที่เก็บ, ช่องค้นหา, เปิดอัตโนมัติ, ล้างประวัติ, ออก)

หลังอัปเดตแอป macOS อาจให้ยืนยันสิทธิ์ Accessibility ใหม่ (ลายเซ็น ad-hoc เปลี่ยนทุกเวอร์ชัน) — ปิดแล้วเปิดสวิตช์ ClipHistory อีกครั้ง

## ถอนการติดตั้ง / Uninstall

```sh
curl -fsSL https://raw.githubusercontent.com/chantanawat/ClipHistory/main/uninstall.sh | sh
```

ประวัติเก็บที่ `~/Library/Application Support/ClipHistory/history.json` (สิทธิ์ไฟล์ 0600)

## Build from source

ต้องมี Xcode Command Line Tools (`xcode-select --install`):

```sh
git clone https://github.com/chantanawat/ClipHistory.git && cd ClipHistory
./release.sh        # builds universal app -> dist/release/ClipHistory.zip
```

## License

MIT
