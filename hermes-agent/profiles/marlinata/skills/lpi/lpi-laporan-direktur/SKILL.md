---
name: lpi-laporan-direktur
description: "Susun laporan harian/mingguan tim AI untuk Direktur LPI."
version: 0.1.0
author: Karyawan.ai
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [LPI, Manajemen, Laporan]
    related_skills: [lpi-drive, lpi-delegasi, lpi-review-hasil]
---

# Laporan ke Direktur

## When to Use

- Laporan harian (sore, WIB) dan laporan mingguan (Jumat/Sabtu).
- Direktur bertanya "gimana progres tim?" atau "apa yang perlu saya
  putuskan?".

## Procedure

### 1. Kumpulkan fakta

- Status issue Multica tiap staf (selesai, berjalan, macet, lewat tenggat).
- File baru di Drive hari/minggu ini: pakai `lpi-drive` aksi `daftar` di
  folder tiap staf, atau `baca` sheet INDEX Dokumen Tim AI.
- Untuk angka penjualan/stok/keuangan: ambil dari laporan Bimo, Dimas, Wulan,
  atau folder `baca.laporan-sales`. Jangan mengarang; kalau belum ada, tulis
  "belum ada data".

### 2. Tulis dengan format ini

```
LAPORAN [HARIAN/MINGGUAN] TIM AI — <tanggal WIB>

Ringkasan (≤3 kalimat): <yang paling penting hari ini>

Perlu keputusan Direktur:
1. <masalah> — Opsi: A / B. Rekomendasi: <A, karena ...>. Tenggat keputusan: <...>

Selesai:
- <staf>: <hasil> (<link Drive / issue>)

Berjalan:
- <staf>: <tugas> — <progres>, target <tanggal>

Macet / risiko:
- <tugas> — <penyebab> — <tindakan saya>

Angka penting (jika ada): <angka> (sumber: <file>)

Rencana besok / minggu depan:
- <prioritas 1-3>
```

Bagian yang kosong ditulis "Tidak ada", jangan dihapus, supaya Direktur tahu
bagian itu sudah dicek.

### 3. Kirim dan simpan

- Kirim versi ringkas lewat chat (Telegram/Web UI).
- Laporan mingguan juga disimpan sebagai Google Doc di folder
  `marlinata.laporan`, nama
  `YYYY-MM-DD_NOISSUE_laporan_mingguan-tim-ai_v01`, status `Review`.

## Pitfalls

- Jangan menaruh keputusan penting di bawah; "Perlu keputusan Direktur"
  selalu di atas.
- Jangan menulis "semua lancar" kalau ada tugas lewat tenggat.
- Sertakan link/nama file untuk setiap hasil agar Direktur bisa mengecek.
