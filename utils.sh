#!/usr/bin/env bash
# Very small helper sourced by all day*.sh
set -Eeuo pipefail

ROOT_DIR="$(pwd)"
CONF="${ROOT_DIR}/config.env"
EXAMPLE="${ROOT_DIR}/config.env.example"
LOG="${ROOT_DIR}/suite.log"

if [[ -f "$CONF" ]]; then
  # shellcheck disable=SC1090
  source "$CONF"
else
  echo "Config not found: $CONF"
  echo "Copy $EXAMPLE to $CONF and edit."
  exit 1
fi

LOG="${SUITE_LOG:-$LOG}"

log() {
  local level="$1"; shift
  printf "[%s] [%s] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$*" | tee -a "$LOG"
}

pkg_manager() {
  if command -v apt-get >/dev/null 2>&1; then echo apt; return; fi
  if command -v dnf >/dev/null 2>&1; then echo dnf; return; fi
  if command -v pacman >/dev/null 2>&1; then echo pacman; return; fi
  echo unknown
}
