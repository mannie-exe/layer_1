# Layer 1 Modpack - Development Plans

## Overview

This document outlines the planned enhancements for the Layer 1 modpack build system, focusing on profile management, multi-version support, and improved developer experience while maintaining packwiz as the core backend.

**Current Status**: Layer 1 v0.4.0-alpha successfully implemented worldgen optimization, removing Terralith/Tectonic conflicts and achieving stable 4vCPU/8GB server performance with Larion + WWOO combination.

## Core Design Principles

1. **Packwiz as Foundation**: Continue leveraging packwiz for mod management, dependency resolution, and pack distribution
2. **Flat Mod Hierarchy**: Organize mods into logical groups without complex inheritance structures
3. **Profile-Based Building**: Support multiple pack variants from a single source
4. **Version Management**: Maintain multiple Minecraft versions with shared configuration where possible
5. **Developer Experience**: Provide both CLI and TUI/GUI options for management tasks

## Architecture Plans

### 1. Profile System

#### Configuration Structure

```toml
# profiles.toml
[base]
description = "Base configuration for all profiles"
packwiz_version = "1.1.0"

[groups]
# Flat mod hierarchy with semantic groupings
performance = ["sodium", "lithium", "ferrite-core", "krypton", "c2me-fabric", "noisium", "faster-random"]
visual-basic = ["continuity", "cit-resewn", "entity-model-features", "entity-texture-features"]
visual-enhanced = ["iris", "bsl-shaders", "fresh-animations", "visuality", "effective"]
visual-ultra = ["wakes", "particle-rain", "cool-rain", "dynamic-surroundings"]
qol-vanilla = ["appleskin", "better-third-person", "jade", "inventory-essentials", "mouse-tweaks"]
qol-enhanced = ["emi", "traveler-compass", "peek", "chat-heads", "status-effect-bars"]
gameplay-vanilla-plus = ["supplementaries", "handcrafted", "carry-on", "visual-workbench"]
gameplay-additions = ["explorify", "structory", "tidal-towns", "dungeons-and-taverns"]
gameplay-overhaul = ["serene-seasons", "hardcore-revival", "crumbling-hearts"]
server-performance = ["clumps", "no-animal-tempt-delay", "packet-fixer"]
client-only = ["first-person-model", "3d-skin-layers", "wavey-capes", "do-a-barrel-roll"]

# Meta-groups for convenience
all-performance = ["performance", "server-performance"]
all-visual = ["visual-basic", "visual-enhanced", "visual-ultra"]
all-qol = ["qol-vanilla", "qol-enhanced"]
all-gameplay = ["gameplay-vanilla-plus", "gameplay-additions"]

[profiles.lite]
description = "Performance-focused build for lower-end systems"
extends = "base"
include_groups = ["performance", "qol-vanilla"]
exclude_mods = ["iris", "bsl-shaders", "wakes", "particle-rain"]
client_memory = "2G"
server_memory = "3G"

[profiles.standard]
description = "Balanced experience with visual and gameplay enhancements"
extends = "base"
include_groups = ["performance", "visual-basic", "qol-vanilla", "qol-enhanced", "gameplay-vanilla-plus"]
client_memory = "4G"
server_memory = "4G"

[profiles.ultra]
description = "Full experience with all visual enhancements"
extends = "standard"
include_groups = ["visual-enhanced", "visual-ultra", "gameplay-additions"]
client_memory = "6G-8G"
server_memory = "6G"

[profiles.server-optimized]
description = "Server-focused build with performance optimizations"
extends = "base"
include_groups = ["performance", "server-performance", "gameplay-vanilla-plus"]
exclude_groups = ["all-visual", "client-only"]
server_memory = "4G-8G"
side = "server"

[profiles.creative]
description = "Creative mode focused with building aids"
extends = "standard"
include_mods = ["worldedit", "litematica"]
exclude_groups = ["gameplay-overhaul"]
```

#### Implementation Strategy

1. Profile resolution during build:
   - Parse `profiles.toml`
   - Resolve group memberships and inheritance
   - Generate temporary packwiz configuration
   - Execute packwiz with profile-specific parameters

2. Mod group validation:
   - Check for conflicts between groups
   - Validate mod compatibility within profiles
   - Warn about missing dependencies

### 2. Multi-Version Support

#### Directory Structure

```
layer_1/
├── versions/
│   ├── 1.21.1/
│   │   ├── pack/
│   │   │   ├── pack.toml
│   │   │   └── mods/
│   │   └── profiles.toml
│   ├── 1.20.4/
│   │   ├── pack/
│   │   │   ├── pack.toml
│   │   │   └── mods/
│   │   └── profiles.toml
│   └── shared/
│       ├── configs/          # Shared mod configurations
│       ├── mod-mappings.toml # Cross-version mod ID mappings
│       └── resources/        # Shared resource packs
├── build/
│   └── <generated files>
└── tools/
    └── modpack-manager/      # Rust TUI/GUI tool
```

#### Version Management Features

1. **Mod Mapping System**:
   ```toml
   # shared/mod-mappings.toml
   [sodium]
   common_name = "sodium"
   description = "Modern rendering engine"
   "1.21.1" = { id = "AANobbMI", file = "sodium-fabric-0.6.0+mc1.21.1.jar" }
   "1.20.4" = { id = "4OZL6q9h", file = "sodium-fabric-0.5.11+mc1.20.4.jar" }
   ```

2. **Migration Tools**:
   - Automated mod availability checking
   - Version compatibility reports
   - Configuration migration assistance

### 3. Build System Enhancements

#### Enhanced Command Structure

```bash
# Current simple commands
./make.sh client
./make.sh server
./make.sh pack

# Enhanced profile-aware commands
./make.sh build --profile=standard --version=1.21.1 --target=client
./make.sh build --profile=lite --version=1.20.4 --target=server

# Utility commands
./make.sh list-profiles [--version=1.21.1]
./make.sh validate --profile=ultra
./make.sh compare --profiles=lite,standard
./make.sh migrate --from=1.20.4 --to=1.21.1 --profile=standard
```

#### Build Pipeline

1. **Pre-build Phase**:
   - Validate profile configuration
   - Check mod availability
   - Resolve dependencies
   - Generate build plan

2. **Build Phase**:
   - Create temporary workspace
   - Apply profile configuration
   - Execute packwiz commands
   - Process additional resources

3. **Post-build Phase**:
   - Validate output
   - Generate metadata
   - Create distribution artifacts
   - Clean temporary files

### 4. Rust Management Tool

#### Technology Stack

- **TUI**: Ratatui (for terminal interface)
- **GUI**: egui (for cross-platform graphical interface)
- **Core**: 
  - serde for configuration parsing
  - tokio for async operations
  - reqwest for API interactions

#### Key Features

1. **Profile Management**:
   - Visual profile editor
   - Drag-and-drop mod grouping
   - Live preview of profile contents
   - Conflict detection and resolution

2. **Version Management**:
   - Side-by-side version comparison
   - Migration wizard
   - Mod availability checking

3. **Build Automation**:
   - Build queue management
   - Progress visualization
   - Log streaming
   - Error diagnostics

4. **Mod Discovery**:
   - Search integration with Modrinth/CurseForge
   - Compatibility filtering
   - One-click addition to groups

#### Architecture Overview

```rust
// Core structures
pub struct ModpackManager {
    config: ManagerConfig,
    profiles: HashMap<String, Profile>,
    versions: HashMap<MinecraftVersion, VersionData>,
    packwiz: PackwizWrapper,
}

pub struct Profile {
    name: String,
    description: String,
    extends: Option<String>,
    groups: ProfileGroups,
    overrides: ModOverrides,
    settings: ProfileSettings,
}

pub struct ModGroup {
    name: String,
    description: String,
    mods: Vec<ModIdentifier>,
    metadata: GroupMetadata,
}

// Key interfaces
pub trait ProfileBuilder {
    fn resolve_profile(&self, name: &str) -> Result<ResolvedProfile>;
    fn validate_profile(&self, profile: &ResolvedProfile) -> Result<ValidationReport>;
    fn build_profile(&self, profile: &ResolvedProfile, target: BuildTarget) -> Result<BuildArtifact>;
}

pub trait VersionManager {
    fn get_compatible_mods(&self, version: &MinecraftVersion, mod_id: &str) -> Result<Vec<ModVersion>>;
    fn migrate_profile(&self, profile: &Profile, from: &MinecraftVersion, to: &MinecraftVersion) -> Result<MigrationPlan>;
}
```

### 5. Integration Roadmap

#### Phase 1: Foundation (Immediate)
- [x] ~~Create profile configuration schema~~ (Deferred for v0.5.0)
- [x] Enhanced build system with instance management
- [x] Legal distribution system with packwiz bootstrapper
- [x] CI/CD pipeline optimization
- [x] Worldgen performance optimization completed

#### Phase 2: Multi-Version (Short-term)
- [ ] Implement version directory structure
- [ ] Create mod mapping system for 1.20.4 support
- [ ] Add version-aware build commands
- [ ] Implement basic migration tools
- [ ] Evaluate tech mod integration (Oritech focus)

#### Phase 3: Rust Tool MVP (Medium-term)
- [ ] Create CLI with profile management
- [ ] Implement TUI for interactive management
- [ ] Add mod search and discovery
- [ ] Integrate with existing build system

#### Phase 4: Advanced Features (Long-term)
- [ ] GUI application
- [ ] Automated testing framework
- [ ] CI/CD integration
- [ ] Distribution platform integration

## Benefits

1. **Flexibility**: Support multiple use cases from a single codebase
2. **Maintainability**: Simplified mod updates across profiles
3. **User Choice**: Players can select profiles based on their system capabilities
4. **Developer Experience**: Powerful tools for pack development and testing
5. **Version Support**: Easier to maintain packs across Minecraft updates
6. **Performance Focus**: Proven ability to optimize for server constraints
7. **Legal Compliance**: No mod redistribution concerns with bootstrapper system

## Technical Considerations

1. **Backward Compatibility**: Ensure existing workflows continue to function
2. **Performance**: Build times should remain reasonable even with added complexity
3. **Error Handling**: Clear error messages and recovery paths
4. **Documentation**: Comprehensive guides for both users and contributors
5. **Testing**: Automated tests for profile resolution and build processes

## Next Steps

1. Review and refine the profile schema based on actual mod organization needs
2. Prototype the profile resolution system
3. Test integration with current packwiz workflow
4. Begin development of Rust management tool
5. Gather feedback from the community

This plan provides a foundation for evolving the Layer 1 modpack build system while maintaining its current simplicity for basic use cases and adding powerful features for advanced management.