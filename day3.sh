#!/usr/bin/env bash
# Day 3: Log & system scan
set -Eeuo pipefail
# shellcheck disable=SC1091
source ./utils.sh

# Disk usage
log INFO "Checking disk usage (warn >= ${DISK_WARN}%)"
df -hP | awk 'NR>1 {print $5, $6}' | while read -r use mount; do
  pct="${use%\%}"
  [[ "$pct" =~ ^[0-9]+$ ]] || continue
  if (( pct >= DISK_WARN )); then
    log WARN "High disk: ${pct}% on ${mount}"
  fi
done

# Failed SSH (last 24h)
log INFO "Recent failed SSH logins (last 24h)"
if [[ -f /var/log/auth.log ]]; then
  sudo grep -i "Failed password" /var/log/auth.log | tail -n 20 | sed 's/^/[AUTH] /' | tee -a "$LOG" >/dev/null
elif command -v journalctl >/dev/null 2>&1; then
  sudo journalctl -u ssh -S -24h -p warning --no-pager | tail -n 20 | sed 's/^/[AUTH] </code>' | tee -a "$LOG" >/dev/null
else
  log WARN "No auth log or journalctl."
fi

# Top CPU
log INFO "Top ${TOP_CPU_N} processes by CPU"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n $((TOP_CPU_N + 1)) | sed 's/^/[CPU] /' | tee -a "$LOG" >/dev/null

log INFO "Scan complete."
