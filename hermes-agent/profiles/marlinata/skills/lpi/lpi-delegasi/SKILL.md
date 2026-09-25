---
name: lpi-delegasi
description: "Pecah arahan Direktur jadi tugas yang jelas untuk 9 staf AI LPI."
version: 0.1.0
author: Karyawan.ai
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [LPI, Manajemen, Delegasi, Multica]
    related_skills: [lpi-drive, lpi-review-hasil, lpi-laporan-direktur]
---

# Delegasi Tugas ke Staf AI

Ubah arahan (sering singkat dan informal) dari Direktur menjadi tugas yang
bisa langsung dikerjakan staf tanpa bertanya balik.

## When to Use

- "Tolong buatkan promo ayam untuk minggu depan."
- "Cek kenapa stok karkas beda dengan penjualan."
- "Siapkan kontrak untuk reseller baru."
- Setiap arahan yang butuh lebih dari satu langkah atau lebih dari satu staf.

Don't use for: pertanyaan status sederhana (jawab langsung) atau laporan
(pakai `lpi-laporan-direktur`).

## Procedure

### 1. Tentukan hasil akhir

Tulis satu kalimat: "Selesai berarti ___." Contoh: "Selesai berarti ada 3
desain feed IG promo ayam frozen ukuran 1080x1350 yang sudah disetujui
Direktur, siap diposting Senin."

### 2. Pecah dan urutkan

Pecah menjadi tugas per staf. Tandai ketergantungan (tugas B menunggu A).
Pola umum:

| Kebutuhan | Urutan |
|---|---|
| Promo / kampanye | Bimo (data penjualan, opsional) → Salsa (rencana) → Citra (caption/script) → Raka (desain) |
| Selisih stok / data aneh | Dimas (rekap & anomali) → Wulan (cocokkan keuangan) → Bimo (dampak) |
| Pelanggan / reseller baru | Nadia (penawaran) → Farhan (draf kontrak) → Wulan (invoice) |
| Komplain produk | Nadia (rekap & balasan) → Dimas (cek batch/stok) → naikkan ke Direktur jika menyangkut keamanan pangan |
| Rapat | Ayu (agenda) → rapat → Ayu (notulen) → Marlinata (tindak lanjut & delegasi) |
| File baru di Inbox | Ayu (tentukan pemilik) → staf pemilik |

### 3. Tulis instruksi tugas

Setiap tugas WAJIB berisi format berikut (satu issue Multica per tugas,
di-assign ke staf yang dituju):

```
Judul: [kata kerja] [objek] — [konteks singkat]
Untuk: <nama staf>
Tujuan: <kenapa tugas ini ada, hasil akhir yang dibutuhkan>
Input: <file Drive (file_id/nama), data, atau issue sebelumnya>
Output: <jenis file + format + jumlah>, simpan di folder <kunci folder>
        dengan nama YYYY-MM-DD_<ISSUE>_<jenis>_<judul-singkat>_v01
Kriteria selesai:
- <poin yang bisa dicek>
- <poin yang bisa dicek>
Tenggat: <tanggal & jam WIB>
Batasan: <hal yang tidak boleh, misal: jangan sebut harga sebelum disetujui>
Tergantung pada: <issue lain, jika ada>
```

### 4. Catat rencananya

Untuk pekerjaan yang melibatkan 3 tugas atau lebih, simpan rencana delegasi
sebagai Google Doc di folder `marlinata.rencana` (skill `lpi-drive`,
aksi `buat_doc`, jenis `rencana`).

### 5. Pantau

Catat di memori issue mana yang sedang berjalan dan tenggatnya. Saat
tenggat lewat atau staf mentok, tindak lanjuti: perjelas instruksi, sediakan
input yang kurang, atau naikkan ke Direktur.

## Pitfalls

- Instruksi "buatkan konten promo" tanpa ukuran, jumlah, tenggat, dan
  pesan utama akan menghasilkan pekerjaan ulang. Selalu isi format lengkap.
- Jangan menugaskan Raka tanpa brief tertulis; minta Citra/Salsa menyiapkan
  brief dulu, atau tulis brief sendiri di tugasnya.
- Aksi Drive `pindah`, `ganti_nama`, `buat_folder`, `arsipkan` hanya boleh
  dilakukan Ayu. Delegasikan ke Ayu bila perlu.
