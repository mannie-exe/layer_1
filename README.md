# layer_1 - A Vanilla+ Minecraft Modpack

layer_1 is a carefully curated Fabric modpack that enhances Minecraft while preserving its vanilla essence. With over 220 mods focused on performance, visual polish, and quality of life improvements, layer_1 creates the Minecraft experience you always wanted.

## Overview

- **Version**: 0.1.1-alpha
- **Minecraft**: 1.21.1
- **Mod Loader**: Fabric 0.16.14
- **Total Mods**: 226
- **Focus**: Performance, Visual Enhancement, Quality of Life, Vanilla+

## Key Features

### 🚀 Performance First
Aggressive optimization through Sodium, Lithium, and other performance mods ensures smooth gameplay even on modest hardware while maintaining visual quality.

### ✨ Visual Excellence
Subtle visual improvements including animations, particles, and shader support that enhance without changing Minecraft's core identity.

### 🎮 Quality of Life
Thoughtful additions like EMI, Jade, and inventory improvements that reduce tedium without overwhelming the vanilla experience.

### 🌍 Enhanced World
Overhauled terrain generation with Terralith, new structures, and biome improvements that feel like natural extensions of vanilla.

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
- **[Complete Mod List](docs/MOD_LIST.md)** - Full alphabetical listing with all 255 additions
- **[Development Plans](docs/PLAN.md)** - Future enhancements and architecture plans

## Quick Start

### For Players

1. Install a Fabric-compatible launcher (Prism Launcher, MultiMC, etc.)
2. Import the modpack using the `.mrpack` file from releases
3. Allocate 4-8GB RAM depending on desired performance
4. Launch and enjoy!

#### 🔄 Auto-Updates (Optional)
For automatic updates, add this pre-launch command in your launcher:
```
"$INST_JAVA" -jar packwiz-installer-bootstrap.jar https://github.com/mannie-exe/layer_1/releases/latest/download/pack.toml
```
This will automatically download new mods and updates before each launch.

### For Developers

> ⚠️ `./make.sh (server|client|all)`
> will auto-clean the appropriate build directory before building.

```bash
# Clone the repository
git clone https://github.com/zer0cell/layer_1.git
cd layer_1

# Create modpack file
./make.sh pack

# Build server version
./make.sh server

# Build client version
./make.sh client

# Build everything (includes clean)
./make.sh all
```

## Build System

layer_1 uses a custom build system built on top of [packwiz](https://github.com/packwiz/packwiz):

- `make.sh` - Main build script with multiple targets
- `pack.sh` - Quick pack export script
- Supports client, server, and modpack builds
- Clean separation of build artifacts in `dist/`

### Build Targets

- `client` - Build client-side mod installation
- `server` - Build server-side mod installation
- `pack` / `mrpack` - Create distributable modpack file
- `clean` - Clean build directories
- `all` - Build everything

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
