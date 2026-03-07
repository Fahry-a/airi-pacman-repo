# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Arch Linux pacman repository for AIRI, a self-hosted AI companion application. The repository hosts prebuilt `.pkg.tar.zst` packages for both `x86_64` and `aarch64` architectures, distributed via GitHub Releases.

**Upstream Project**: [moeru-ai/airi](https://github.com/moeru-ai/airi)

## Build Commands

### Local Package Build
```bash
cd pkgbuilds/airi-bin
makepkg -sd  # Build package, skip dependency checks
makepkg -si  # Build and install locally
```

### Update Checksums
```bash
cd pkgbuilds/airi-bin
updpkgsums  # Regenerate sha256sums in PKGBUILD
```

### Regenerate .SRCINFO
```bash
cd pkgbuilds/airi-bin
makepkg --printsrcinfo > .SRCINFO
```

### Build Repository Database
```bash
mkdir -p repo-out
cp pkgbuilds/airi-bin/*.pkg.tar.zst repo-out/
cd repo-out
repo-add airi-repo.db.tar.gz *.pkg.tar.zst
```

## Architecture

### Package Structure (`pkgbuilds/airi-bin/`)

- **PKGBUILD**: Main build script that:
  - Downloads prebuilt RPMs from upstream releases
  - Extracts and repackages for Arch Linux
  - Uses system `electron40` instead of bundled Electron
  - Supports both `x86_64` and `aarch64` architectures
  - Cleans up unnecessary platform-specific binaries (darwin, win32, opposite arch)
  - Includes Maintainer tag for AUR compliance

- **airi.sh**: Launcher script template with placeholders (`@appname@`, `@electronversion@`, etc.) that get substituted during `prepare()`. Features:
  - Custom flags via `~/.config/airi-flags.conf`
  - Wayland native mode via `--wayland` flag
  - Root/sandbox handling
  - Proper error handling with `set -euo pipefail`

- **.SRCINFO**: AUR metadata, must be regenerated when PKGBUILD changes

### CI/CD Workflow (`.github/workflows/build-repo.yml`)

1. **check job**: Compares upstream latest release version against local PKGBUILD
2. **build job**: Runs in `archlinux:latest` container:
   - Updates `pkgver` and `pkgrel` in PKGBUILD
   - Recalculates checksums with `updpkgsums`
   - Regenerates `.SRCINFO`
   - Builds package with `makepkg -sd`
   - Creates pacman repo database
   - Commits PKGBUILD changes and uploads to GitHub Releases

### Version Handling

- PKGBUILD uses underscore format for `pkgver` (e.g., `0.9.0_alpha.1`)
- Upstream GitHub releases use hyphen format (e.g., `v0.9.0-alpha.1`)
- The `_tag_ver` variable converts underscores back to hyphens for download URLs

## Code Quality Standards

### PKGBUILD
- Use `$CARCH` variable instead of hard-coded architecture strings
- Include `# Maintainer:` header
- Use `local` keyword for local variables in functions
- Keep comments in English

### Launcher Script (airi.sh)
- Use `set -euo pipefail` for strict error handling
- Handle empty variables with `${VAR:-default}` syntax
- Use `[[ ]]` for conditionals (bash-specific)
- **Security**: Never load user-controlled config files when running as root
- **Security**: Filter dangerous flags (`--gpu-launcher`, `--inspect*, `--remote-debugging*`, `--js-flags*`)
- **Security**: Verify file ownership and permissions before reading config files

### CI/CD Workflow
- All comments in English
- Clear step names describing actions
- Proper error handling with fallbacks

## Key Files to Update When Bumping Version

1. `pkgbuilds/airi-bin/PKGBUILD` - Update `pkgver` and reset `pkgrel=1`
2. Run `updpkgsums` to update checksums
3. Regenerate `.SRCINFO`
4. Commit with message: `chore(airi-bin): bump to v<version>`
