#!/usr/bin/env bash
# Day 2: Updates & cleanup
set -Eeuo pipefail
# shellcheck disable=SC1091
source ./utils.sh

PM="$(pkg_manager)"
log INFO "Pkg manager: $PM"

case "$PM" in
  apt)
    sudo -n true 2>/dev/null || log WARN "May prompt for sudo."
    sudo apt-get update
    sudo apt-get -y upgrade
    sudo apt-get -y autoremove
    sudo apt-get clean
    ;;
  dnf)
    sudo -n true 2>/dev/null || log WARN "May prompt for sudo."
    sudo dnf -y upgrade
    sudo dnf clean all
    ;;
  pacman)
    sudo -n true 2>/dev/null || log WARN "May prompt for sudo."
    sudo pacman -Syu --noconfirm
    sudo pacman -Sc --noconfirm
    ;;
  *)
    log ERROR "Unknown package manager."
    exit 2
    ;;
esac

log INFO "Updates done."
