# AIRI Pacman Repository

[![Build Pacman Repo](https://github.com/Fahry-a/airi-pacman-repo/actions/workflows/build-repo.yml/badge.svg)](https://github.com/Fahry-a/airi-pacman-repo/actions/workflows/build-repo.yml)
[![GitHub Release](https://img.shields.io/github/v/release/Fahry-a/airi-pacman-repo?label=latest%20build)](https://github.com/Fahry-a/airi-pacman-repo/releases/tag/latest)
[![License](https://img.shields.io/github/license/moeru-ai/airi)](LICENSE)

Arch Linux package repository for **AIRI** - a self-hosted AI companion application.

## About AIRI

💖🧸 AIRI is a self-hosted Grok Companion, a container of souls of waifu, cyber livings to bring them into our worlds, wishing to achieve Neuro-sama's altitude.

- **Upstream Project**: [moeru-ai/airi](https://github.com/moeru-ai/airi)
- **Documentation**: [airi.moeru.ai/docs](https://airi.moeru.ai/docs/)

## Installation

### Option 1: Using the Pacman Repository (Recommended)

1. Add the repository to your `/etc/pacman.conf`:

```ini
[airi-repo]
SigLevel = Optional
Server = https://github.com/Fahry-a/airi-pacman-repo/releases/download/latest
```

2. Update pacman and install AIRI:

```bash
sudo pacman -Sy airi-bin
```

3. Install the package:

```bash
sudo pacman -S airi-bin
```

### Option 2: Manual Installation from AUR

```bash
# Clone the repository
git clone https://github.com/Fahry-a/airi-pacman-repo.git
cd airi-pacman-repo/pkgbuilds/airi-bin

# Build and install
makepkg -si
```

### Option 3: Download from Releases

Download the latest `.pkg.tar.zst` package from the [releases page](https://github.com/moeru-ai/airi-pacman-repo/releases/tag/latest) and install:

```bash
sudo pacman -U airi-bin-*.pkg.tar.zst
```

## Package Information

| Field | Value |
|-------|-------|
| **Package Name** | `airi-bin` |
| **License** | MIT |
| **Architecture** | x86_64, aarch64 |
| **Dependencies** | `electron40`, `xsel` |
| **Provides** | `airi` |

## Usage

After installation, you can launch AIRI from your application menu or via terminal:

```bash
airi
```

### Wayland Support

To run AIRI with Wayland native support:

```bash
airi --wayland
```

### Configuration

You can add custom flags by creating a configuration file at `~/.config/airi-flags.conf`. Each line should contain one flag.

## Automated Builds

This repository includes a GitHub Actions workflow that:

- **Daily Check**: Automatically checks for new AIRI releases at 20:00 UTC (03:00 WIB)
- **Auto-Build**: Builds new packages when upstream releases a new version
- **Auto-Release**: Publishes packages to the `latest` release tag
- **Repository Database**: Generates pacman repository database files

The workflow automatically:
1. Fetches the latest version from upstream
2. Updates `PKGBUILD` and `.SRCINFO`
3. Builds the package for both x86_64 and aarch64
4. Creates a pacman-compatible repository database
5. Commits changes and publishes to GitHub Releases

## Manual Trigger

You can manually trigger a build by going to the [Actions tab](https://github.com/moeru-ai/airi-pacman-repo/actions) and running the "Build Pacman Repo" workflow.

## Directory Structure

```
airi-pacman-repo/
├── pkgbuilds/
│   └── airi-bin/
│       ├── PKGBUILD      # Arch package build script
│       ├── .SRCINFO      # AUR metadata
│       └── airi.sh       # Launcher script
└── .github/
    └── workflows/
        └── build-repo.yml # CI/CD workflow
```

## License

- **AIRI**: MIT License (see [upstream LICENSE](https://github.com/moeru-ai/airi/blob/main/LICENSE))
- **This Repository**: MIT License

## Acknowledgments

- Original project by [moeru-ai](https://github.com/moeru-ai)
- Package maintained for Arch Linux users
