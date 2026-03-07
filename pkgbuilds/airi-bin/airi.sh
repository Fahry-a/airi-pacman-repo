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

# Parse command-line arguments
_WAYLAND_OPTION=false
declare -a user_args=()
for arg in "$@"; do
  if [[ "${arg}" == "--wayland" ]]; then
    _WAYLAND_OPTION=true
  else
    # Filter out dangerous flags that could be used for privilege escalation
    case "${arg}" in
      --gpu-launcher*|--inspect*|--remote-debugging*|--js-flags*)
        echo "Warning: Ignoring potentially dangerous flag: ${arg}" >&2
        ;;
      *)
        user_args+=("${arg}")
        ;;
    esac
  fi
done

# Parse flags from configuration file (only when NOT running as root)
declare -a config_flags=()
if [[ "${EUID:-}" -ne 0 ]]; then
  export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
  _FLAGS_FILE="${XDG_CONFIG_HOME}/@appname@-flags.conf"
  if [[ -f "${_FLAGS_FILE}" ]]; then
    # Verify file ownership and permissions before reading
    local _file_owner _file_perms
    _file_owner=$(stat -c '%u' "${_FLAGS_FILE}" 2>/dev/null || echo "9999")
    _file_perms=$(stat -c '%a' "${_FLAGS_FILE}" 2>/dev/null || echo "000")

    # Only read if owned by current user and not world-writable
    if [[ "${_file_owner}" == "${UID}" && "${_file_perms:$(( ${#_file_perms} - 1 ))}" != "w" ]]; then
      mapfile -t < "${_FLAGS_FILE}"
      for line in "${MAPFILE[@]:-}"; do
        # Skip comments and empty lines
        if [[ ! "${line}" =~ ^[[:space:]]*#.* ]] && [[ -n "${line}" ]]; then
          # Filter dangerous flags
          case "${line}" in
            --gpu-launcher*|--inspect*|--remote-debugging*|--js-flags*)
              echo "Warning: Ignoring potentially dangerous flag in config: ${line}" >&2
              ;;
            *)
              config_flags+=("${line}")
              ;;
          esac
        fi
      done
    else
      echo "Warning: Skipping config file due to unsafe ownership or permissions" >&2
    fi
  fi
fi

# Enable Wayland native mode if requested
if [[ "${_WAYLAND_OPTION}" == true ]]; then
  echo "Enabling Wayland native mode..."
  config_flags+=(
    "--enable-features=UseOzonePlatform,WaylandWindowDecorations,VaapiVideoDecodeLinuxGL"
    "--ozone-platform=wayland"
  )
fi

# Change to application directory
cd "${_APPDIR}"

# Launch application
# Use filtered arguments to prevent security issues
final_args=("${config_flags[@]}" "${user_args[@]}")
if [[ "${EUID:-}" -ne 0 ]] || [[ -n "${ELECTRON_RUN_AS_NODE:-}" ]]; then
  exec electron@electronversion@ "${_RUNNAME}" "${_OPTIONS}" "${final_args[@]}" || exit $?
else
  echo "Warning: Running as root. This is highly discouraged and may decrease security." >&2
  exec electron@electronversion@ "${_RUNNAME}" "${_OPTIONS}" --no-sandbox "${final_args[@]}" || exit $?
fi
