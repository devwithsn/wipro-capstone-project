#!/usr/bin/env bash
# Day 1: backup (rsync)
set -Eeuo pipefail
# shellcheck disable=SC1091
source ./utils.sh

mkdir -p "$BACKUP_DEST"

DATE_TAG="$(date '+%Y%m%d-%H%M%S')"
DEST="${BACKUP_DEST}/backup-${DATE_TAG}"
LAST="$(ls -1dt "${BACKUP_DEST}"/backup-* 2>/dev/null | head -n1 || true)"

log INFO "Backup start -> $DEST"
mkdir -p "$DEST"

OPTS=(-aAX --delete --human-readable)
[[ -f "$EXCLUDE_FILE" ]] && OPTS+=(--exclude-from="$EXCLUDE_FILE")
[[ -n "$LAST" && -d "$LAST" ]] && OPTS+=(--link-dest="$LAST")

for SRC in $BACKUP_SRC; do
  [[ -e "$SRC" ]] || { log WARN "Missing: $SRC (skip)"; continue; }
  NAME="$(basename "$SRC")"
  log INFO "Sync $SRC -> $DEST/$NAME"
  rsync "${OPTS[@]}" "$SRC"/ "$DEST/$NAME"/
done

# prune old backups
find "$BACKUP_DEST" -maxdepth 1 -type d -name 'backup-*' -mtime "+${RETAIN_DAYS}" -print -exec rm -rf {} \; 2>/dev/null || true

log INFO "Backup done."
