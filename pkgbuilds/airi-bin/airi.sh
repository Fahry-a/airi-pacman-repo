#!/usr/bin/env bash
# AIRI Launcher Script
# This script launches AIRI using the system Electron installation

set -euo pipefail

# Application paths (substituted during build)
_APPDIR="/usr/lib/@appname@"
_RUNNAME="${_APPDIR}/@runname@"
_OPTIONS="@options@"

# Environment setup
export PATH="${_APPDIR}:${PATH}"
export LD_LIBRARY_PATH="${_APPDIR}/swiftshader:${_APPDIR}/lib:${LD_LIBRARY_PATH:-}"
export ELECTRON_IS_DEV=0
export ELECTRON_FORCE_IS_PACKAGED=true
export ELECTRON_DISABLE_SECURITY_WARNINGS=true
export NODE_ENV=production

# Configuration file location
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
_FLAGS_FILE="${XDG_CONFIG_HOME}/@appname@-flags.conf"

# Parse flags from configuration file
declare -a flags=()
if [[ -f "${_FLAGS_FILE}" ]]; then
  mapfile -t < "${_FLAGS_FILE}"
  for line in "${MAPFILE[@]:-}"; do
    # Skip comments and empty lines
    if [[ ! "${line}" =~ ^[[:space:]]*#.* ]] && [[ -n "${line}" ]]; then
      flags+=("${line}")
    fi
  done
fi

# Check for Wayland mode
_WAYLAND_OPTION=false
for arg in "$@"; do
  if [[ "${arg}" == "--wayland" ]]; then
    _WAYLAND_OPTION=true
    break
  fi
done

# Enable Wayland native mode if requested
if [[ "${_WAYLAND_OPTION}" == true ]]; then
  echo "Enabling Wayland native mode..."
  flags+=(
    "--enable-features=UseOzonePlatform,WaylandWindowDecorations,VaapiVideoDecodeLinuxGL"
    "--ozone-platform=wayland"
  )
fi

# Change to application directory
cd "${_APPDIR}"

# Launch application
# When running as root, use --no-sandbox flag for compatibility
if [[ "${EUID:-}" -ne 0 ]] || [[ -n "${ELECTRON_RUN_AS_NODE:-}" ]]; then
  exec electron@electronversion@ "${_RUNNAME}" "${_OPTIONS}" "${flags[@]}" "$@" || exit $?
else
  exec electron@electronversion@ "${_RUNNAME}" "${_OPTIONS}" --no-sandbox "${flags[@]}" "$@" || exit $?
fi
