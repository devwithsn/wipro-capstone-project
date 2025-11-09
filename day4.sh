#!/usr/bin/env bash
# Day 4: Menu runner
set -Eeuo pipefail
# shellcheck disable=SC1091
source ./utils.sh

pause() { read -r -p "Press Enter to continue..." _ || true; }

while true; do
  clear
  echo "==== Wipro-Style Maintenance Suite ===="
  echo "1) Backup now (day1.sh)"
  echo "2) Update & clean (day2.sh)"
  echo "3) Scan logs & system (day3.sh)"
  echo "4) Show suite log (last 150 lines)"
  echo "5) Exit"
  echo
  read -r -p "Choose [1-5]: " choice || true
  case "$choice" in
    1) bash ./day1.sh ; pause ;;
    2) bash ./day2.sh ; pause ;;
    3) bash ./day3.sh ; pause ;;
    4) tail -n 150 "${SUITE_LOG:-$LOG}" || echo "No log yet." ; pause ;;
    5) echo "Bye!"; exit 0 ;;
    *) echo "Invalid."; pause ;;
  esac
done
