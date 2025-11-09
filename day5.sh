#!/usr/bin/env bash
# Day 5: Basic tests and sanity checks
set -Eeuo pipefail
# shellcheck disable=SC1091
source ./utils.sh

ok=0; fail=0

t() {
  local name="$1"; shift
  echo -n "[TEST] $name ... "
  if "$@"; then echo "OK"; ok=$((ok+1)); else echo "FAIL"; fail=$((fail+1)); fi
}

t "config present" test -f "./config.env"
t "rsync exists" command -v rsync >/dev/null 2>&1

mkdir -p /tmp/wipro-test-src && echo "hello" > /tmp/wipro-test-src/file.txt
BACKUP_SRC="/tmp/wipro-test-src" BACKUP_DEST="/tmp/wipro-test-dest" bash ./day1.sh || true

echo "[RESULT] OK=$ok FAIL=$fail"
log INFO "Day5 tests done. OK=$ok FAIL=$fail"
exit 0
