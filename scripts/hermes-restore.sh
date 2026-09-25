#!/usr/bin/env bash
# Salin konfigurasi Hermes dari repo ke HERMES_HOME (default ~/.hermes).
# File .env dan auth.json di tujuan TIDAK disentuh.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HOME_DIR="${HERMES_HOME:-$HOME/.hermes}"
mkdir -p "$HOME_DIR"
for f in config.yaml SOUL.md; do
  [[ -f "$ROOT/hermes-agent/config/$f" ]] && cp "$ROOT/hermes-agent/config/$f" "$HOME_DIR/$f"
done
for d in skills cron memories profiles; do
  [[ -n "$(ls -A "$ROOT/hermes-agent/$d" 2>/dev/null | grep -v '^.gitkeep$')" ]] || continue
  mkdir -p "$HOME_DIR/$d"
  cp -a "$ROOT/hermes-agent/$d/." "$HOME_DIR/$d/"
  rm -f "$HOME_DIR/$d/.gitkeep"
done
if [[ ! -f "$HOME_DIR/.env" ]]; then
  cp "$ROOT/hermes-agent/config/.env.example" "$HOME_DIR/.env"
  echo "Dibuat $HOME_DIR/.env dari template — isi API key-nya."
fi
echo "Konfigurasi Hermes dipulihkan ke $HOME_DIR"
