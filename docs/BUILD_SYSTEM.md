# Build System

layer_1 uses a streamlined build system built on top of [packwiz](https://github.com/packwiz/packwiz).

## Pack Configuration Source of Truth

The `pack/pack.toml` file serves as the **single source of truth** for all modpack metadata and configuration. This file drives the entire build system:

```toml
name = "layer_1"                    # Pack name - used in filenames and templates
author = "mannie-exe"               # Pack author - used in launcher configs  
version = "0.4.5-alpha"             # Pack version - used in all build artifacts
pack-format = "packwiz:1.1.0"       # Packwiz format version

[versions]
fabric = "0.16.14"                  # Fabric loader version
minecraft = "1.21.1"                # Target Minecraft version
```

### Build System Integration

The following scripts automatically extract and use values from `pack/pack.toml`:

- **`empack`** - Main build script uses ALL metadata for artifact generation
- **`release`** - Uses version for git tagging and releases  
- **`man`** - Prints packaged mods (including side-only content)
- **Template processing** - All `*.template` files support variable substitution:
  - `{{NAME}}` - Pack name
  - `{{AUTHOR}}` - Pack author
  - `{{VERSION}}` - Pack version
  - `{{MC_VERSION}}` - Minecraft version
  - `{{FABRIC_VERSION}}` - Fabric loader version

### Mod Loader Support

Currently **Fabric only** - the build system is designed specifically for Fabric modpacks. 

🚧 **Future planned support**: Quilt and NeoForge

## Available Commands

The build system supports multiple commands that can be combined and are automatically sorted by execution priority:

| Command | Description |
|---------|-------------|
| **`clean`** | Clean the dist (build) directories |
| **`mrpack`** | Build a Modrinth-compatible '*.mrpack' file |
| **`client`** | Build a bootstrapped client installer |
| **`server`** | Build a bootstrapped server installer |
| **`client-full`** | Build a non-redistributable client (⚠️ embeds non-redistributable content) |
| **`server-full`** | Build a non-redistributable server (⚠️ embeds non-redistributable content) |
| **`all`** | Equivalent to 'mrpack client server' |

## Advanced Usage

```bash
# Multiple commands (auto-sorted by execution priority)
./empack client server        # Builds client first, then server
./empack clean mrpack         # Cleans first, then builds mrpack
./empack server client        # Automatically sorts to: client, server

# Help and command information
./empack help                 # Show usage and all available commands
./empack                      # Same as help (no arguments)
```

## Distribution Flow

```bash
./empack mrpack      # → dist/layer_1-v0.4.5-alpha.mrpack
./empack client      # → dist/layer_1-v0.4.5-alpha-client.zip
./empack server      # → dist/layer_1-v0.4.5-alpha-server.zip
./empack all         # → All files above
```

The client and server builds automatically include the packwiz bootstrapper, allowing for streamlined installation while preserving custom configurations.

## Components

- **`empack`** - Main build script with multiple commands and comprehensive help
- **`man`** - Print packaged mods script  
- **`release`** - Release tagging script
- **Automated CI/CD** - GitHub Actions handle releases
- **Clean separation** - All build artifacts organized in `dist/`