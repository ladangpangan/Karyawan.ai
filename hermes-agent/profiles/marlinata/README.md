# Profil Hermes: Marlinata

Manajer tim AI PT Ladang Pangan Indonesia. Folder ini berisi "otak" Marlinata
yang di-versioning:

| File | Isi |
|---|---|
| `SOUL.md` | Identitas, tim yang dipimpin, nilai TUMBUH, cara berpikir, kapan eskalasi ke Direktur, aturan kejujuran |
| `skills/lpi/lpi-delegasi` | Memecah arahan Direktur jadi tugas lengkap per staf |
| `skills/lpi/lpi-laporan-direktur` | Format laporan harian/mingguan |
| `skills/lpi/lpi-drive` | Cara memakai webhook n8n `lpi-drive` (Drive tim AI) |
| `skills/lpi/lpi-review-hasil` | Checklist kualitas hasil staf sebelum ke Direktur |

## Pasang di VPS

```bash
cd ~/Karyawan.ai && git pull
make hermes-profile P=marlinata   # backup SOUL.md lama, salin SOUL.md + skills
docker restart hermes
```

Kalau di VPS sudah ada SOUL.md Marlinata yang ditulis manual, bagian
pentingnya (sapaan, aturan khusus) bisa digabung ke `SOUL.md` di sini, karena
file lama akan diganti (backup tetap ada: `SOUL.md.bak-*`).

## Tes cepat setelah dipasang

Tanya ke Marlinata di Web UI:

1. "Siapa saja timmu dan apa tugas masing-masing?"
2. "Minggu depan saya mau promo ayam frozen untuk reseller. Atur ya."
   → harus dipecah jadi tugas Bimo/Salsa/Citra/Raka lengkap dengan output,
   folder, nama file, dan tenggat.
3. "Berapa penjualan kemarin?" → harus membaca `baca.laporan-sales` lewat
   `lpi-drive`, atau jujur bilang belum ada data. Tidak boleh mengarang.
4. "Buat laporan harian." → format laporan dengan bagian "Perlu keputusan
   Direktur" di atas.

## Supaya makin pintar (tahap berikutnya)

- **Jadwal otomatis**: minta Marlinata membuat cron sendiri, misalnya
  "setiap hari 16:30 WIB kirimkan laporan harian ke saya".
- **Model**: untuk peran manajer, pakai model yang kuat di reasoning di
  `config.yaml` profil ini.
- **Memori**: koreksi Marlinata langsung di chat ("ingat, laporan saya
  maunya jam 5 sore"); ia akan menyimpannya ke memori.
