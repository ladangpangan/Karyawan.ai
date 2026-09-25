---
name: lpi-drive
description: "Baca/tulis Google Drive tim AI LPI lewat webhook n8n lpi-drive."
version: 0.1.0
author: Karyawan.ai
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [LPI, Google-Drive, n8n, Penyimpanan]
    related_skills: [lpi-delegasi, lpi-laporan-direktur]
---

# Google Drive Tim AI (webhook `lpi-drive`)

Semua akses Drive tim AI lewat workflow n8n **LPI Drive - Penyimpanan Tim
AI**. Workflow ini memvalidasi izin, pola nama file, dan otomatis mencatat
file baru di sheet **INDEX Dokumen Tim AI**. Jangan akses Drive dengan cara
lain.

## When to Use

- Mencari/membaca laporan staf, INDEX, atau data di folder tim manusia.
- Menyimpan rencana delegasi atau laporan ke Direktur.
- Mengubah status dokumen (Draft → Review → Final).

## Cara memanggil

```bash
curl -s -X POST http://localhost:5678/webhook/lpi-drive \
  -H 'Content-Type: application/json' \
  -d '{"agent":"marlinata","aksi":"daftar","folder":"marlinata.laporan"}'
```

Field `agent` selalu `"marlinata"`. Respons sukses berisi
`"status":"sukses"`; gagal berisi `"status":"gagal"` dan `"alasan"`.
**Baca `alasan`, perbaiki payload, lalu coba lagi** — jangan menyerah dan
jangan mengarang hasil.

## Aksi yang boleh dipakai Marlinata

| Aksi | Field wajib | Catatan |
|---|---|---|
| `daftar` | `folder` | Daftar file terbaru di folder |
| `cari` | `kata_kunci` (+ `folder` opsional) | Cari file |
| `baca` | `file_id` | Baca isi Doc/Sheet/PDF/gambar |
| `buat_doc` | `folder`, `nama_file`, `isi` (markdown) | + `judul`, `jenis`, `issue_id`, `status`, `catatan` opsional |
| `buat_sheet` | `folder`, `nama_file`, `baris` (array of array) | Baris pertama = header |
| `tambah_baris` | `file_id`, `baris` | Hanya Google Sheet |
| `edit_doc` | `file_id`, `isi`, `mode` (`tambah`/`ganti`) | Tidak bisa untuk dokumen Final |
| `ubah_status` | `file_id`, `status` | `Draft`, `Review`, `Final`, `Arsip` |
| `salin_template` | `file_id`, `folder`, `nama_file` | + `isian` (objek placeholder) |
| `ekspor_pdf` | `file_id` | Untuk Doc/Sheet/Slides |
| `unggah_file` | `folder`, `nama_file`, `mime`, `isi_base64` | |

`pindah`, `ganti_nama`, `buat_folder`, `arsipkan` **hanya untuk Ayu** —
delegasikan lewat issue.

## Kunci folder

- Milik Marlinata (tulis): `marlinata.laporan`, `marlinata.rencana`
- Umum: `inbox`, `panduan`, `project`, `arsip`
- Folder staf (tulis hanya jika memang perlu, biasanya cukup baca):
  `ayu.notulen|memo|agenda|sop`, `raka.brief|draft|final`,
  `citra.caption|script|kalender`, `salsa.kampanye|performa`,
  `nadia.faq|komplain|penawaran`, `dimas.rekap|anomali`,
  `farhan.kontrak|regulasi|template`, `wulan.cashflow|invoice|nota|laporan`,
  `bimo.penjualan|insight`
- Folder tim manusia (hanya `daftar`/`cari` lalu `baca`):
  `baca.laporan-sales` (LAPORAN HARIAN SALES), `baca.meeting` (2. Meeting)
- Subfolder: `"kunci/Nama Subfolder"`, contoh `"arsip/2026"`.

## Aturan nama file

`YYYY-MM-DD_ISSUE_jenis_judul-singkat_vNN` — huruf kecil, pisah `-`, tanpa
spasi. Tanpa issue tulis `NOISSUE`. Tanggal WIB.
Contoh: `2026-09-25_LADA-15_rencana_promo-ayam-oktober_v01`.

Jenis untuk Marlinata biasanya `laporan` atau `rencana`.

## Contoh

Simpan laporan mingguan:

```json
{"agent":"marlinata","aksi":"buat_doc","folder":"marlinata.laporan",
 "nama_file":"2026-09-26_NOISSUE_laporan_mingguan-tim-ai_v01",
 "judul":"Laporan Mingguan Tim AI 26 Sep 2026","status":"Review",
 "isi":"# Laporan Mingguan Tim AI\n\n..."}
```

Baca laporan sales harian terbaru:

```json
{"agent":"marlinata","aksi":"daftar","folder":"baca.laporan-sales"}
```
lalu `{"agent":"marlinata","aksi":"baca","file_id":"<id dari hasil daftar>"}`.

## Pitfalls

- Dokumen Final tidak bisa diedit: buat versi baru (`_v02`).
- Jangan menyimpan password, API key, nomor rekening lengkap, atau data
  pelanggan lengkap.
- INDEX diisi otomatis oleh workflow; jangan menulis ke INDEX langsung.
