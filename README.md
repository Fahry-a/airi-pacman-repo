# AIRI Pacman Repository

[![Build Pacman Repo](https://github.com/Fahry-a/airi-pacman-repo/actions/workflows/build-repo.yml/badge.svg)](https://github.com/Fahry-a/airi-pacman-repo/actions/workflows/build-repo.yml)
[![GitHub Release](https://img.shields.io/github/v/release/Fahry-a/airi-pacman-repo?label=latest%20build)](https://github.com/Fahry-a/airi-pacman-repo/releases/tag/latest)
[![License](https://img.shields.io/github/license/moeru-ai/airi)](https://github.com/moeru-ai/airi/blob/main/LICENSE)

Arch Linux package repository for **AIRI** - a self-hosted AI companion application.

## About AIRI

AIRI is a self-hosted Grok Companion, a container of souls of waifu and cyber livings, bringing them into our world.

- **Upstream Project**: [moeru-ai/airi](https://github.com/moeru-ai/airi)
- **Documentation**: [airi.moeru.ai/docs](https://airi.moeru.ai/docs/)

## Features

- Prebuilt packages for `x86_64` and `aarch64` architectures
- Uses system Electron (smaller download, better integration)
- Automatic daily builds via GitHub Actions
- Wayland native support

## Installation

### Option 1: Using the Pacman Repository (Recommended)

1. Add the repository to your `/etc/pacman.conf`:

   ```ini
   [airi-repo]
   SigLevel = Optional
   Server = https://github.com/Fahry-a/airi-pacman-repo/releases/download/latest
   ```

2. Refresh package databases and install AIRI:

   ```bash
   sudo pacman -Sy airi-bin
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

Download the latest `.pkg.tar.zst` package from the [releases page](https://github.com/Fahry-a/airi-pacman-repo/releases/tag/latest) and install:

```bash
sudo pacman -U airi-bin-*.pkg.tar.zst
```

## Package Information

| Field           | Value                       |
|-----------------|-----------------------------|
| Package Name    | `airi-bin`                  |
| License         | MIT                         |
| Architecture    | x86_64, aarch64             |
| Dependencies    | `electron40`, `xsel`        |
| Provides        | `airi`                      |

## Usage

### Launch Application

From your application menu or terminal:

```bash
airi
```

### Wayland Support

Run with native Wayland support:

```bash
airi --wayland
```

### Custom Flags

Create `~/.config/airi-flags.conf` with one flag per line:

```bash
# Example: Enable hardware acceleration
--enable-gpu-rasterization
--enable-zero-copy
```

## Automated Builds

This repository uses GitHub Actions for automated package builds:

| Feature           | Description                                      |
|-------------------|--------------------------------------------------|
| Schedule          | Daily at 20:00 UTC (03:00 WIB)                   |
| Auto-update       | Detects new upstream releases automatically      |
| Multi-arch        | Builds for both x86_64 and aarch64               |
| Auto-release      | Publishes to GitHub Releases                     |

### Manual Trigger

Go to [Actions](https://github.com/Fahry-a/airi-pacman-repo/actions) and run the "Build Pacman Repo" workflow.

## Directory Structure

```
airi-pacman-repo/
├── pkgbuilds/
│   └── airi-bin/
│       ├── PKGBUILD      # Arch package build script
│       ├── .SRCINFO      # AUR metadata
│       └── airi.sh       # Launcher script
├── .github/
│   └── workflows/
│       └── build-repo.yml # CI/CD workflow
├── CLAUDE.md             # Developer instructions
└── README.md             # This file
```

## Troubleshooting

### Application won't start

1. Ensure Electron is installed: `pacman -S electron40`
2. Check for missing dependencies: `pacman -S xsel`

### Wayland issues

If Wayland mode doesn't work, try:
```bash
airi --wayland --enable-features=UseOzonePlatform --ozone-platform=wayland
```

### GPU acceleration problems

Add to `~/.config/airi-flags.conf`:
```bash
--disable-gpu
--disable-software-rasterizer
```

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

- **AIRI**: MIT License ([upstream LICENSE](https://github.com/moeru-ai/airi/blob/main/LICENSE))
- **This Repository**: MIT License

## Acknowledgments

- Original project by [moeru-ai](https://github.com/moeru-ai)
- Package maintained for Arch Linux users
