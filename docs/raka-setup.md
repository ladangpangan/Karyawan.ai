# Implementasi Raka (Design Graphic) — step by step

Semua file ada di branch `claude/agent-raka-bejo-quality-pfk2a3`:
- `hermes-agent/profiles/design-graphic/SOUL.md`
- `hermes-agent/skills/poster-designer/SKILL.md`
- `n8n/workflows/raka-design.json`

## Tahap 1 — Siapkan logo & referensi di Google Drive (±10 menit)

1. Buat folder Drive **"Raka - Aset Brand"**.
2. Upload logo **PNG latar transparan** (min. 1000px) ke folder itu.
3. Klik kanan folder → Bagikan → Akses umum: **"Siapa saja yang memiliki link"** → Pelihat.
4. Klik kanan file logo → Bagikan → Salin link. Simpan link ini.
5. Buat subfolder **"Referensi"** di dalamnya, isi 3–10 poster/feed yang Anda suka.

## Tahap 2 — Isi MEMORY.md Raka (±5 menit)

Buka `/home/hermeswebui/.hermes/profiles/design-graphic/MEMORY.md`
(lewat Hermes WebUI atau `nano`), tambahkan di bagian bawah:

```
## Aset brand Ladang Pangan
- Logo perusahaan: <link logo dari Tahap 1>
- Warna utama: #xxxxxx (nama), warna kedua: #xxxxxx, aksen: #xxxxxx
- Font/gaya huruf: <mis. bold rounded sans-serif>
- Gaya visual: bersih, segar, terpercaya; foto makanan yang menggugah selera
- Folder referensi: <link folder Referensi>
```

## Tahap 3 — Pasang SOUL.md dan SKILL.md (±5 menit)

Lewat terminal VPS:

```bash
cd ~
git clone -b claude/agent-raka-bejo-quality-pfk2a3 https://github.com/ladangpangan/Karyawan.ai.git raka-update
P=/home/hermeswebui/.hermes/profiles/design-graphic
sudo cp $P/SOUL.md $P/SOUL.md.bak                        # cadangan
sudo cp raka-update/hermes-agent/profiles/design-graphic/SOUL.md $P/SOUL.md
sudo mkdir -p $P/skills/poster-designer
sudo cp raka-update/hermes-agent/skills/poster-designer/SKILL.md $P/skills/poster-designer/
sudo chown -R --reference=$P $P/SOUL.md $P/skills/poster-designer
```

Tanpa terminal: buka file di GitHub → tombol **Copy raw file** → tempel
menggantikan isi SOUL.md di Hermes WebUI; buat skill baru `poster-designer`
dan tempel isi SKILL.md.

Lalu restart Raka: Hermes WebUI → Profiles → design-graphic → start/restart
gateway (atau `docker restart hermes`), dan mulai **chat/session baru**.

## Tahap 4 — Import workflow n8n (±10 menit)

1. GitHub → `n8n/workflows/raka-design.json` → **Download raw file**.
2. n8n → buka workflow lama "Raka - Design Graphic (Nano Banana Pro)" →
   matikan toggle **Active** (path webhook sama, harus dimatikan dulu).
3. n8n → **Create workflow** → menu ⋯ → **Import from File** → pilih file tadi.
4. Buka node **Panggil OpenRouter** → Credential: pilih kredensial OpenRouter Anda.
5. Buka node **Upload ke Google Drive** dan **Share File (Public Link)** →
   pilih "Google Drive account", pastikan folder tujuan "8. TIM AI".
6. **Save** → nyalakan toggle **Active**.

## Tahap 5 — Tes (±10 menit)

Kirim ke Raka:

> Raka, tolong buatkan feed Instagram 4:5 untuk promo Ayam Frozen Ladang Pangan.
> Headline: "AYAM SEGAR BEKU, PRAKTIS TIAP HARI". Harga: "Rp 45.000/kg".
> CTA: "Pesan Sekarang". Referensi: <link 1 poster dari folder Referensi>.
> Issue: LADA-4

Yang harus terjadi: Raka menjelaskan gaya referensi → mengajukan konsep →
setelah Anda setujui, memanggil n8n → posting link Drive ke issue.

Cek di n8n → **Executions**: semua node hijau.

## Kalau gagal

| Pesan / gejala | Solusi |
|---|---|
| `model not found` / `invalid model` | Buka node **Susun Request**, ganti ID model di baris paling atas sesuai nama di openrouter.ai/models |
| `Link bukan gambar (text/html)` | Akses file Drive belum "Siapa saja yang memiliki link" |
| Seedream error saat ada logo/referensi | Pakai `nano-banana-pro` untuk desain dengan logo/referensi |
| Hasil persegi padahal minta 4:5 / A4 | Kirim screenshot Execution node **Panggil OpenRouter** ke Claude |
| Logo berubah bentuk | Pastikan PNG transparan & tajam; kalau tetap, minta tambah langkah tempel logo di n8n |
| Raka tidak mengikuti alur baru | Pastikan SOUL tersalin, restart, dan mulai session baru |
| Workflow tidak jalan sama sekali | Workflow lama masih Active (path bentrok) |

Kembalikan ke versi lama: `sudo cp $P/SOUL.md.bak $P/SOUL.md` dan aktifkan lagi workflow lama di n8n.
