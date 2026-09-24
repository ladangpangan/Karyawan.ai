# Karyawan.ai

Satu repo untuk seluruh stack "karyawan AI":

| Komponen | Peran | Upstream |
|---|---|---|
| **Multica** | Papan kerja / manajemen tugas untuk agent (issue, workspace, runtime) | [multica-ai/multica](https://github.com/multica-ai/multica) |
| **Hermes Agent** | Agent-nya: model, memori, skill, gateway (Telegram, dll.), cron | [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) |
| **n8n** | Otomasi workflow & integrasi (webhook, API pihak ketiga) | [n8n-io/n8n](https://github.com/n8n-io/n8n) |

Repo ini **tidak menyalin source code** ketiga proyek tersebut. Yang disimpan
di sini adalah bagian yang membuat instalasi kamu unik: konfigurasi Docker,
workflow n8n, konfigurasi/persona/skill Hermes, dan template environment.
Source code upstream diambil sebagai image Docker resmi, jadi update cukup
dengan `make pull && make up`.

## Struktur

```
.
├── docker-compose.yml        # stack gabungan (include ketiga layanan)
├── .env.example              # semua variabel; salin ke .env
├── Makefile                  # perintah singkat
├── multica/
│   ├── docker-compose.yml    # postgres + backend + frontend
│   └── vps/                  # salinan compose asli dari VPS (hasil sync)
├── hermes-agent/
│   ├── docker-compose.yml    # gateway + dashboard
│   ├── config/               # config.yaml, SOUL.md, .env.example
│   ├── skills/               # skill buatan sendiri
│   ├── cron/                 # jadwal job Hermes
│   └── memories/             # (opsional) memori agent
├── n8n/
│   ├── docker-compose.yml
│   └── workflows/            # workflow n8n dalam JSON
└── scripts/
    ├── sync-from-vps.sh      # tarik konfigurasi dari VPS ke repo
    └── hermes-restore.sh     # pulihkan konfigurasi Hermes ke ~/.hermes
```

## 1. Upload isi VPS sekarang ke GitHub

Jalankan di VPS (butuh `git`, `docker`, `python3`):

```bash
git clone https://github.com/ladangpangan/Karyawan.ai.git
cd Karyawan.ai

# lihat dulu apa yang akan tersalin
./scripts/sync-from-vps.sh
git diff --cached --stat

# kalau sudah oke
./scripts/sync-from-vps.sh --push
```

Script akan otomatis mendeteksi:

- **n8n** — container yang namanya mengandung `n8n`, lalu menjalankan
  `n8n export:workflow --all`. Kalau tidak ketemu: `N8N_CONTAINER=nama ./scripts/sync-from-vps.sh`
- **Hermes** — folder `~/.hermes`. Kalau beda: `HERMES_HOME=/path ./scripts/sync-from-vps.sh`
- **Multica** — project compose yang namanya mengandung `multica` (dari `docker compose ls`).
  Kalau beda: `MULTICA_DIR=/path/ke/multica ./scripts/sync-from-vps.sh`

Opsi tambahan: `--with-memories` (ikut salin memori Hermes) dan
`--db-backup` (dump DB Multica ke `backups/`, tidak di-commit).

### Keamanan

- `.env`, `auth.json`, session, log, dan database **tidak pernah** di-commit.
  Nilai `.env` diubah menjadi `.env.example` dengan nilai kosong.
- Credentials n8n tidak diekspor. Simpan `N8N_ENCRYPTION_KEY` lama di tempat aman.
- Sebelum commit, script memindai pola API key/token (OpenAI, Anthropic,
  GitHub, Slack, AWS, Google, bot Telegram, private key) dan membatalkan
  commit bila ada yang cocok.
- Tetap jadikan repo ini **private**.

## 2. Deploy ulang di server baru

```bash
git clone https://github.com/ladangpangan/Karyawan.ai.git && cd Karyawan.ai
cp .env.example .env            # isi password, JWT secret, N8N_ENCRYPTION_KEY, dll.
make hermes-restore             # salin config Hermes ke ~/.hermes, lalu isi ~/.hermes/.env
make up                         # jalankan semua
make n8n-import                 # import workflow n8n
```

Butuh Docker Compose v2.20+ (fitur `include`).

| Layanan | Alamat (di VPS) |
|---|---|
| Multica web | http://127.0.0.1:3000 |
| Multica API | http://127.0.0.1:8080 |
| n8n | http://127.0.0.1:5678 |
| Hermes dashboard | http://127.0.0.1:9119 |

Semua hanya listen di `127.0.0.1`. Untuk akses dari internet pasang reverse
proxy (Caddy/nginx) dengan HTTPS, atau pakai Tailscale.

## Cara ketiganya saling terhubung

- Hermes berjalan dengan `network_mode: host`, jadi bisa memanggil
  n8n (`http://localhost:5678/webhook/...`) dan API Multica
  (`http://localhost:8080`) langsung.
- n8n memicu Hermes lewat platform **Webhooks** di gateway Hermes (aktifkan di `config.yaml`, lihat docs Hermes "Messaging → Webhooks").
- Multica menjalankan agent lewat daemon runtime-nya; daftarkan Hermes sebagai
  runtime di Multica (lihat dokumentasi Multica "CLI & daemon").

## Rutin

```bash
make sync-push   # setelah mengubah workflow n8n / config Hermes di VPS
make pull && make up   # update Multica, Hermes, n8n ke versi terbaru
```
