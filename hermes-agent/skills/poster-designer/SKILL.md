---
name: poster-designer
description: Cara mendesain poster (promo, event, katalog, cetak A4) dan konten Instagram (feed, carousel, story) berkualitas profesional, termasuk membaca poster referensi dan memakai logo perusahaan. Pakai setiap kali user minta poster, flyer, banner, feed/story Instagram, atau gambar iklan.
---

# Poster Designer

Kualitas datang dari proses: brief → pelajari referensi → konsep → prompt
terstruktur → generate → laporan. Jangan langsung generate dari satu kalimat.

## 1. Brief

Pastikan jelas (kalau kurang, tanya SEKALI, maks 5 pertanyaan):
- Tujuan: promo/diskon, produk baru, event, katalog, edukasi, awareness
- Teks persis: headline, subheadline, harga, CTA
- Format (lihat tabel), target audiens
- Poster referensi yang diinginkan (link Drive)

| Kebutuhan | dimensi | Catatan desain |
|---|---|---|
| Poster cetak | `A4` / `A4 landscape` | Info boleh lebih lengkap, headline terbaca dari 2 meter |
| Feed Instagram | `4:5 1080x1350` | Paling efektif di feed; headline ≤ 6 kata |
| Feed persegi / carousel | `1:1 1080x1080` | Carousel: 1 konsep per slide, gaya seragam |
| Story / Reels cover | `9:16 1080x1920` | Kosongkan 250px atas & bawah (area UI Instagram) |

## 2. Pelajari referensi (kalau ada)

Referensi = standar minimal. Lihat gambarnya lalu tulis ke user:
- **Layout**: posisi headline, produk, harga, CTA; proporsi ruang kosong
- **Hierarki**: urutan mata membaca
- **Tipografi**: jenis huruf (bold condensed, rounded, serif), ukuran relatif
- **Warna & cahaya**: palet dominan, kontras, gaya foto/ilustrasi
- **Mood**: premium, ceria, hangat, segar, dll.
Tanya: "Apakah ini yang Bapak/Ibu suka dari referensi ini?" lalu lanjut.
Ambil GAYA-nya saja; teks, produk, dan logo tetap milik Ladang Pangan.

## 3. Konsep

Ajukan 2–3 arah berbeda (bukan sekadar beda warna). Tiap konsep:
big idea 1 kalimat, gaya visual, palet (hex dari MEMORY.md), layout. Tunggu setuju.

## 4. Tulis deskripsi_visual (bahasa Inggris, 120–250 kata)

Urutan:
1. **STYLE**: gaya visual + kaitannya dengan referensi
   ("clean commercial food photography, layout inspired by the reference: ...")
2. **SUBJECT**: produk dengan detail nyata — ayam golden crispy, juicy, uap
   panas, piring, garnish segar; kemasan frozen dengan es jika relevan
3. **COMPOSITION**: posisi subject, area kosong untuk teks, posisi harga & CTA
4. **TYPOGRAPHY**: gaya huruf dan warna teks (isi teksnya di teks_presisi,
   workflow otomatis menyisipkannya)
5. **COLOR & LIGHT**: palet hex, pencahayaan (soft studio, natural daylight, rim light)
6. **DETAILS**: badge diskon, ikon halal, tekstur, dekorasi

Aturan: maksimal 3–4 blok teks di gambar. Info panjang (alamat, S&K, nomor
HP) taruh di caption, bukan di gambar.

## 5. Generate

- Default `model: "nano-banana-pro"`. Pakai `"nano-banana"` hanya untuk draf cepat.
- Selalu isi `logo_url` dari MEMORY.md dan `referensi_gambar` jika ada.
- Satu panggilan webhook per konsep.

## 6. Laporan

Kirim link hasil + alasan tiap konsep + saran caption Instagram (jika feed/story),
dan checklist review:
- [ ] Ejaan teks & harga sesuai brief
- [ ] Logo tidak berubah bentuk
- [ ] Produk terlihat menggugah selera
- [ ] Setara atau lebih baik dari referensi
- [ ] Rasio sesuai platform

Kalau teks salah eja atau logo rusak: panggil ulang dengan prompt yang lebih
tegas, atau ganti model ke nano-banana-pro. Simpan preferensi user
(gaya yang disukai) ke memori.
