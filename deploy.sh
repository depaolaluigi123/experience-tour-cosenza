#!/usr/bin/env sh
set -eu

usage() {
  cat <<'EOF'
Uso:
  ./deploy.sh <cartella-destinazione> [--clean]

Esempi:
  ./deploy.sh /var/www/geolocation-sito
  ./deploy.sh /var/www/geolocation-sito --clean

Opzioni:
  --clean   Rimuove dalla destinazione i file non presenti nel progetto.
EOF
}

if [ "${1:-}" = "" ] || [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

DEST="$1"
CLEAN="${2:-}"

if [ "$CLEAN" != "" ] && [ "$CLEAN" != "--clean" ]; then
  echo "Errore: opzione non valida '$CLEAN'"
  usage
  exit 1
fi

if [ "$DEST" = "." ] || [ "$DEST" = "./" ]; then
  echo "Errore: la destinazione non puo' essere la root del progetto."
  exit 1
fi

mkdir -p "$DEST"

RSYNC_DELETE_FLAG=""
if [ "$CLEAN" = "--clean" ]; then
  RSYNC_DELETE_FLAG="--delete"
fi

rsync -av --human-readable \
  --exclude '.git/' \
  --exclude '.agents/' \
  --exclude '.codex/' \
  --exclude 'backup/' \
  --exclude '.DS_Store' \
  --exclude 'deploy.sh' \
  --exclude 'README.md' \
  $RSYNC_DELETE_FLAG \
  ./ "$DEST/"

echo "Deploy completato in: $DEST"
