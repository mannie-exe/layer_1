# Development Setup

Complete setup guide for contributing to layer_1.

## Prerequisites

### Required Tools
- **packwiz** - Modpack management tool
  - Installation: https://github.com/packwiz/packwiz#installation
  - Go installation recommended (supports all platforms), or download from [GitHub Actions](https://github.com/packwiz/packwiz/actions/) for convenience on x86-64
- **tq** - TOML query tool for extracting pack metadata
  - Installation: https://github.com/cryptaliagy/tomlq#installing
  - Requires Cargo/Rust for installation
- **mrpack-install** - Server installation tool for Fabric modpacks
  - Manual installation: Download from https://github.com/nothub/mrpack-install and add to PATH
  - No package manager installation available
- **Bash scripting environment**:
  - **macOS/Linux**: Native support
  - **Windows**: WSL (Windows Subsystem for Linux) or Git Bash
  - **Alternative**: Ability to run packwiz commands manually
- **Java Runtime Environment (JRE) 21+** - Required for local testing
- **Git** - For version control

### Optional Tools
- **act** - For local GitHub Actions testing
  - Installation: `brew install act` (macOS) or see [GitHub](https://github.com/nektos/act)

### Dependency Overview
The build system relies on these tools for specific functions:
- **packwiz**: Core modpack management, mod installation, and .mrpack generation
- **tq**: Extracts metadata (name, version, author, etc.) from `pack/pack.toml` for template processing
- **mrpack-install**: Downloads and installs Fabric server jars for full server builds
- **Java**: Required for packwiz-installer execution during builds and testing

## Quick Start

```bash
# Clone the repository
git clone https://github.com/mannie-exe/layer_1.git
cd layer_1

# Show all available build commands
./empack help

# Build modpack file (for distribution)
./empack mrpack

# Build bootstrapped client installer
./empack client

# Clean build directories
./empack clean

# Build everything for release (mrpack + client + server)
./empack all

# Build multiple commands (automatically sorted by priority)
./empack clean mrpack client server
```

## File Structure

```
layer_1/
├── docs/                    # Documentation
│   ├── contributing/        # Development guides
│   ├── MODS.md             # Mod overview
│   ├── MOD_LIST.md         # Complete mod list
│   ├── FX.md               # Visual effects analysis
│   └── PLAN.md             # Development plans
├── pack/                    # Modpack content
│   ├── config/             # Mod configurations
│   ├── mods/               # Mod definitions (.pw.toml files)
│   ├── resourcepacks/      # Resource pack definitions
│   ├── shaderpacks/        # Shader pack definitions
│   └── pack.toml           # Main pack configuration
├── templates/              # Template files
│   ├── client/             # Client template files (launcher configs, icon)
│   └── server/             # Server template files (server.properties, etc.)
├── installer/              # Packwiz installer
├── dist/                   # Build outputs (generated)
├── empack                  # Main build script
├── man                     # Print packaged mods
└── release                 # Release tagging script
```