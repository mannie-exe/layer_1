# layer_1 - A Vanilla+ Minecraft Modpack

layer_1 is a carefully curated Fabric modpack that enhances Minecraft while preserving its vanilla essence. With 239 mods focused on performance, visual polish, and quality of life improvements, layer_1 creates the Minecraft experience you always wanted.

## Overview

- **Version**: 0.4.0-alpha
- **Minecraft**: 1.21.1
- **Mod Loader**: Fabric 0.16.14
- **Total Mods**: 239
- **Focus**: Performance, Visual Enhancement, Quality of Life, Vanilla+

## Key Features

### 🚀 Performance First
Aggressive optimization through Sodium, Lithium, and other performance mods ensures smooth gameplay even on modest hardware while maintaining visual quality.

### ✨ Visual Excellence
Subtle visual improvements including animations, particles, and shader support that enhance without changing Minecraft's core identity.

### 🎮 Quality of Life
Thoughtful additions like EMI, Jade, and inventory improvements that reduce tedium without overwhelming the vanilla experience.

### 🌍 Enhanced World
Optimized terrain generation with Larion and William Wythers' Overhauled Overworld, plus new structures and biome improvements that feel like natural extensions of vanilla.

### 🏗️ Builder's Paradise
Extensive decorative options through Supplementaries, Handcrafted, and more - perfect for creative builders.

## Prerequisites

### For Players
- **Java Runtime Environment (JRE) 21+** - Required by Minecraft 1.21.1
  - [Adoptium](https://adoptium.net/) (recommended) or any OpenJDK 21+ distribution
- **Fabric-compatible launcher** - Prism Launcher, MultiMC, ATLauncher, etc.

### For Developers
- **packwiz** - Must be installed and available on PATH
  - Installation: https://packwiz.infra.link/installation
- **Bash scripting environment**:
  - **macOS/Linux**: Native support
  - **Windows**: WSL (Windows Subsystem for Linux) or Git Bash
  - **Alternative**: Ability to run packwiz commands manually

## Documentation

- **[Mod Overview](docs/MODS.md)** - Feature-grouped summary of included mods
- **[Complete Mod List](docs/MOD_LIST.md)** - Full alphabetical listing with all 265 additions
- **[Development Plans](docs/PLAN.md)** - Future enhancements and architecture plans

## Quick Start

### For Players

#### Option 1: Modpack File (Recommended)
1. Download the `.mrpack` file from [releases](https://github.com/mannie-exe/layer_1/releases)
2. Import into your launcher (Prism, MultiMC, ATLauncher, etc.)
3. Allocate 4-8GB RAM for optimal performance
4. Launch and enjoy!

#### Option 2: Instance Import (Custom Icon)
1. Download the `.zip` file from [releases](https://github.com/mannie-exe/layer_1/releases)
2. Extract and import the instance folder into your launcher
3. The instance includes our custom icon and auto-installs mods on first launch
4. Allocate 4-8GB RAM for optimal performance

### For Developers

```bash
# Clone the repository
git clone https://github.com/mannie-exe/layer_1.git
cd layer_1

# Build modpack file (for distribution)
./make.sh mrpack

# Build instance zip (includes custom icon + bootstrapper)
./make.sh instance

# Build everything for release
./make.sh all
```

## Build System

layer_1 uses a streamlined build system built on top of [packwiz](https://github.com/packwiz/packwiz):

- **`make.sh`** - Main build script with multiple targets
- **`pack.sh`** - Quick pack export script  
- **Automated CI/CD** - GitHub Actions handle releases
- **Clean separation** - All build artifacts organized in `dist/`

### Primary Build Targets

- **`mrpack`** - Create Modrinth-compatible modpack file
- **`instance`** - Build launcher instance with custom icon and bootstrapper
- **`clean`** - Clean build directories
- **`all`** - Build both mrpack and instance for release

### Distribution Flow

```bash
./make.sh mrpack     # → dist/layer_1-v0.4.0-alpha.mrpack
./make.sh instance   # → dist/layer_1-v0.4.0-alpha.zip
```

The instance build automatically includes the packwiz bootstrapper, allowing for one-click mod installation while preserving custom icons and configs.

## System Requirements

### Minimum
- 4GB allocated RAM
- GPU with OpenGL 4.5 support
- Fabric-compatible launcher

### Recommended
- 6-8GB allocated RAM
- Dedicated GPU (for shaders)
- SSD for faster loading

## Contributing

Contributions are welcome! Please:
1. Check existing issues before submitting new ones
2. Test changes thoroughly
3. Follow the existing mod curation philosophy
4. Update documentation as needed

## License

This modpack configuration is released under MIT License. Individual mods retain their original licenses.

## Credits

- Built with [packwiz](https://github.com/packwiz/packwiz) by comp500
- All mod authors for their amazing work
- The Fabric team for the mod loader
- The Minecraft modding community
