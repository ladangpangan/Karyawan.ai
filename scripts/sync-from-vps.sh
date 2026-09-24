#!/usr/bin/env bash
# Tarik konfigurasi Multica, Hermes Agent, dan n8n yang sedang berjalan di VPS
# ke dalam repo ini, lalu (opsional) commit & push.
#
# Butuh: git, docker, python3.
# Jalankan DI VPS, dari dalam clone repo ini:
#   ./scripts/sync-from-vps.sh              # salin saja, cek hasilnya dengan git diff
#   ./scripts/sync-from-vps.sh --push       # salin + commit + push
#
# Opsi:
#   --push            commit & push setelah sinkron
#   --with-memories   ikut salin ~/.hermes/memories (data pribadi; pastikan repo PRIVATE)
#   --db-backup       pg_dump database Multica ke backups/ (tidak di-commit)
#
# Variabel lingkungan (auto-detect bila kosong):
#   HERMES_HOME       default ~/.hermes
#   N8N_CONTAINER     nama container n8n
#   MULTICA_DIR       folder tempat docker-compose Multica dijalankan
#   MULTICA_DB_CONTAINER  nama container postgres Multica

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

PUSH=0; WITH_MEMORIES=0; DB_BACKUP=0
for arg in "$@"; do
  case "$arg" in
    --push) PUSH=1 ;;
    --with-memories) WITH_MEMORIES=1 ;;
    --db-backup) DB_BACKUP=1 ;;
    -h|--help) sed -n '2,20p' "$0"; exit 0 ;;
    *) echo "Opsi tidak dikenal: $arg" >&2; exit 1 ;;
  esac
done

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }

# Ubah file .env menjadi template: nama variabel tetap, nilai dikosongkan.
env_to_template() {
  sed -E -e 's/^([[:space:]]*(export[[:space:]]+)?[A-Za-z_][A-Za-z0-9_]*)=.*/\1=/' "$1"
}

have_docker() { command -v docker >/dev/null 2>&1; }

# ---------------------------------------------------------------- n8n
sync_n8n() {
  log "n8n: export workflow"
  local out="$ROOT/n8n/workflows" c="${N8N_CONTAINER:-}"
  if [[ -z "$c" ]] && have_docker; then
    c="$( (docker ps --format '{{.Names}} {{.Image}}' 2>/dev/null || true) | awk 'tolower($0) ~ /n8n/ {print $1; exit}')"
  fi

  local tmp; tmp="$(mktemp -d)"
  if [[ -n "$c" ]]; then
    docker exec "$c" sh -c 'rm -rf /tmp/wf-export && mkdir -p /tmp/wf-export && n8n export:workflow --all --separate --pretty --output=/tmp/wf-export' >/dev/null
    docker cp "$c:/tmp/wf-export/." "$tmp/"
    docker exec "$c" rm -rf /tmp/wf-export
  elif command -v n8n >/dev/null 2>&1; then
    n8n export:workflow --all --separate --pretty --output="$tmp" >/dev/null
  else
    warn "n8n tidak ditemukan (set N8N_CONTAINER=...). Dilewati."
    rm -rf "$tmp"; return
  fi

  find "$out" -name '*.json' -delete
  # Beri nama file yang mudah dibaca: <nama-workflow>__<id>.json
  local f name id slug
  for f in "$tmp"/*.json; do
    [[ -e "$f" ]] || continue
    id="$(basename "$f" .json)"
    name="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("name",""))' "$f" 2>/dev/null || true)"
    slug="$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')"
    cp "$f" "$out/${slug:+${slug}__}$id.json"
  done
  rm -rf "$tmp"
  log "n8n: $(find "$out" -name '*.json' | wc -l) workflow tersalin ke n8n/workflows/"
  warn "Credentials n8n TIDAK disalin. Catat N8N_ENCRYPTION_KEY lama ke .env di server tujuan."
}

# ---------------------------------------------------------------- Hermes
sync_hermes() {
  local home="${HERMES_HOME:-$HOME/.hermes}"
  if [[ ! -d "$home" ]]; then
    warn "Hermes: $home tidak ada (set HERMES_HOME=...). Dilewati."
    return
  fi
  log "Hermes: salin konfigurasi dari $home"
  local dst="$ROOT/hermes-agent"

  for f in config.yaml SOUL.md; do
    [[ -f "$home/$f" ]] && cp "$home/$f" "$dst/config/$f"
  done
  [[ -f "$home/.env" ]] && env_to_template "$home/.env" > "$dst/config/.env.example"

  local dirs=(skills cron)
  (( WITH_MEMORIES )) && dirs+=(memories)
  for d in "${dirs[@]}"; do
    [[ -d "$home/$d" ]] || continue
    rm -rf "${dst:?}/$d"
    cp -a "$home/$d" "$dst/$d"
    find "$dst/$d" \( -name '*.db' -o -name '*.db-*' -o -name '*.sqlite*' -o -name '*.log' \
      -o -name '.env' -o -name 'auth.json' \) -delete
    touch "$dst/$d/.gitkeep"
  done
  (( WITH_MEMORIES )) || warn "Hermes: memories/ dilewati (pakai --with-memories bila ingin ikut)."
}

# ---------------------------------------------------------------- Multica
sync_multica() {
  local dir="${MULTICA_DIR:-}"
  if [[ -z "$dir" ]] && have_docker; then
    # `docker compose ls` menampilkan path file compose tiap project yang berjalan
    dir="$(docker compose ls --format json 2>/dev/null \
      | python3 -c 'import json,sys
for p in json.load(sys.stdin):
    if "multica" in p["Name"].lower():
        print(p["ConfigFiles"].split(",")[0].rsplit("/",1)[0]); break' 2>/dev/null || true)"
  fi
  if [[ -z "$dir" || ! -d "$dir" ]]; then
    warn "Multica: folder deploy tidak ditemukan (set MULTICA_DIR=...). Dilewati."
    return
  fi
  log "Multica: salin compose & template env dari $dir"
  local dst="$ROOT/multica/vps"
  mkdir -p "$dst"
  local f
  for f in "$dir"/docker-compose*.yml "$dir"/docker-compose*.yaml "$dir"/compose*.yml "$dir"/Caddyfile; do
    [[ -f "$f" ]] && cp "$f" "$dst/"
  done
  [[ -f "$dir/.env" ]] && env_to_template "$dir/.env" > "$ROOT/multica/.env.example"
  if [[ -d "$dir/.git" ]]; then
    git -C "$dir" rev-parse HEAD > "$dst/UPSTREAM_COMMIT" 2>/dev/null || true
  fi

  if (( DB_BACKUP )); then
    local c="${MULTICA_DB_CONTAINER:-}"
    [[ -z "$c" ]] && c="$( (docker ps --format '{{.Names}}' 2>/dev/null || true) | awk '/multica/ && /postgres/ {print; exit}')"
    if [[ -n "$c" ]]; then
      mkdir -p "$ROOT/backups"
      local out="$ROOT/backups/multica-$(date +%Y%m%d-%H%M%S).sql.gz"
      docker exec "$c" sh -c 'pg_dump -U "${POSTGRES_USER:-multica}" "${POSTGRES_DB:-multica}"' | gzip > "$out"
      log "Multica: backup DB -> $out (tidak di-commit)"
    else
      warn "Multica: container postgres tidak ditemukan untuk backup."
    fi
  fi
}

# ---------------------------------------------------------------- cek rahasia
scan_secrets() {
  log "Memindai kemungkinan rahasia yang ikut tersalin"
  local pattern='(sk-[A-Za-z0-9_-]{20,}|sk-ant-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}|xox[baprs]-[A-Za-z0-9-]{10,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|-----BEGIN [A-Z ]*PRIVATE KEY-----|[0-9]{8,10}:AA[0-9A-Za-z_-]{30,})'
  local hits
  hits="$(git ls-files -mo --exclude-standard -z \
    | xargs -0 -r grep -nIE "$pattern" 2>/dev/null || true)"
  if [[ -n "$hits" ]]; then
    warn "Ditemukan string yang mirip API key / token:"
    printf '%s\n' "$hits" | cut -c1-160
    warn "Hapus/ganti dulu (pindahkan ke .env) lalu jalankan ulang. Commit dibatalkan."
    return 1
  fi
}

sync_n8n
sync_hermes
sync_multica
scan_secrets

git add -A
if git diff --cached --quiet; then
  log "Tidak ada perubahan."
  exit 0
fi
git status --short

if (( PUSH )); then
  git commit -m "sync: konfigurasi VPS $(hostname) $(date +%Y-%m-%d)"
  git push -u origin "$(git rev-parse --abbrev-ref HEAD)"
  log "Selesai: sudah di-push."
else
  log "Perubahan sudah di-stage. Cek dengan 'git diff --cached', lalu commit & push, atau jalankan ulang dengan --push."
fi
