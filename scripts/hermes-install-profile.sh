#!/usr/bin/env bash
# Pasang SOUL.md + skills dari hermes-agent/profiles/<nama> ke profil Hermes.
#   ./scripts/hermes-install-profile.sh marlinata
# SOUL.md lama di-backup ke SOUL.md.bak-<waktu>. Memori, .env, config.yaml,
# dan sesi profil TIDAK disentuh.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="${1:?pakai: $0 <nama-profil>}"
SRC="$ROOT/hermes-agent/profiles/$NAME"
HERMES_ROOT="${HERMES_HOME:-$HOME/.hermes}"
DST="$HERMES_ROOT/profiles/$NAME"

[[ -d "$SRC" ]] || { echo "Tidak ada $SRC" >&2; exit 1; }
if [[ ! -d "$DST" ]]; then
  echo "Profil '$NAME' belum ada di $DST." >&2
  echo "Cek nama dengan: docker exec hermes hermes profile list" >&2
  exit 1
fi

if [[ -f "$SRC/SOUL.md" ]]; then
  if [[ -f "$DST/SOUL.md" ]]; then
    bak="$DST/SOUL.md.bak-$(date +%Y%m%d-%H%M%S)"
    cp "$DST/SOUL.md" "$bak"
    echo "Backup SOUL.md lama -> $bak"
  fi
  cp "$SRC/SOUL.md" "$DST/SOUL.md"
fi

if [[ -d "$SRC/skills" ]]; then
  mkdir -p "$DST/skills"
  cp -a "$SRC/skills/." "$DST/skills/"
fi

# Container Hermes berjalan sebagai HERMES_UID:HERMES_GID (default 10000).
if [[ "$(id -u)" == 0 ]]; then
  chown -R "${HERMES_UID:-10000}:${HERMES_GID:-10000}" "$DST/SOUL.md" "$DST/skills" 2>/dev/null || true
fi

echo "Profil '$NAME' diperbarui di $DST."
echo "Muat ulang: docker restart hermes (atau mulai sesi baru di Web UI)."
