---
name: lpi-review-hasil
description: "Periksa hasil kerja staf AI sebelum diajukan ke Direktur."
version: 0.1.0
author: Karyawan.ai
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [LPI, Manajemen, Quality-Control]
    related_skills: [lpi-delegasi, lpi-drive, lpi-laporan-direktur]
---

# Review Hasil Kerja Staf

Marlinata adalah gerbang kualitas. Hasil staf yang lolos review diubah ke
status `Review` untuk Direktur; yang tidak lolos dikembalikan ke staf dengan
catatan perbaikan yang spesifik.

## When to Use

- Staf menandai issue selesai atau menyerahkan file.
- Sebelum menyebut suatu hasil "selesai" di laporan ke Direktur.

## Procedure

### 1. Baca hasilnya

Pakai `lpi-drive` aksi `baca` pada file yang diserahkan. Jangan menilai dari
judul atau ringkasan staf saja.

### 2. Cek terhadap daftar ini

**Umum (semua staf)**
- [ ] Memenuhi semua "Kriteria selesai" di issue.
- [ ] Nama file sesuai pola dan ada di folder yang benar.
- [ ] Tidak ada data karangan; angka punya sumber.
- [ ] Bahasa rapi, tidak ada salah ketik nama produk/perusahaan
      ("PT Ladang Pangan Indonesia" / "LPI").
- [ ] Tidak ada data sensitif (rekening lengkap, API key, data pelanggan
      lengkap di luar folder 07/10).

**Per bidang**
- Raka (desain): ukuran sesuai brief, logo & nama brand benar, teks terbaca,
  tidak ada klaim yang belum disetujui (harga, "halal", "BPOM") tanpa dasar.
- Citra (konten): sesuai pesan utama kampanye, ada CTA, tidak berlebihan
  klaim kesehatan.
- Salsa (marketing): target, anggaran, kanal, dan metrik keberhasilan jelas.
- Nadia (CS): nada sopan, solusi jelas, harga di penawaran sesuai daftar
  harga yang berlaku.
- Dimas (ERP): total rekap cocok dengan sumber, anomali diberi penjelasan
  dan dugaan penyebab.
- Farhan (legal): ditandai jelas "DRAF — wajib review manusia"; pihak,
  nilai, jangka waktu, dan kewajiban lengkap.
- Wulan (finance): angka dijumlah ulang, periode jelas, cocok dengan nota.
- Bimo (analisa): kesimpulan didukung data, ada rekomendasi yang bisa
  dijalankan.

### 3. Putuskan

- **Lolos** → `ubah_status` ke `Review`, masukkan ke laporan Direktur.
- **Perlu perbaikan** → komentar di issue: apa yang salah, contoh yang benar,
  tenggat perbaikan. Staf membuat versi baru (`_v02`) bila file sudah Final;
  jika masih Draft cukup `edit_doc`.
- **Berisiko** (legal, keuangan, keamanan pangan) → selalu minta keputusan
  Direktur walaupun lolos cek.

### 4. Belajar

Kesalahan yang berulang dari staf yang sama → simpan ke memori dan tambahkan
ke instruksi tugas berikutnya untuk staf tersebut.
