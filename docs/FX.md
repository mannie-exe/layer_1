# Visual Effects Mod Feature Analysis

This document analyzes potential feature collisions between visual effects mods in the Layer 1 modpack.

## Analyzed Mods

- **[Aurae](https://github.com/ChorusTeam/Aurae)** (ChorusTeam) - General ambiance enhancement
- **[Subtle Effects](https://github.com/MincraftEinstein/SubtleEffects)** (MincraftEinstein) - Comprehensive subtle particle and sound effects
- **[Particle Interactions](https://github.com/Enchanted-Games/block-place-particles)** (Enchanted-Games) - Block interaction particle overhaul
- **[Effective](https://github.com/Ladysnake/Effective)** (Ladysnake) - Terrain and environmental visual effects
- **[Particle Effects](https://github.com/LopyMine/particle-effects)** (LopyMine) - Entity effect particle textures
- **[Visuality](https://github.com/PinkGoosik/visuality)** (PinkGoosik) - Cosmetic particles and mob hit effects

## Feature Collision Matrix

| Feature Category              | [Aurae](https://github.com/ChorusTeam/Aurae) | ❌ [Subtle Effects](https://github.com/MincraftEinstein/SubtleEffects) | ❌ [Particle Interactions](https://github.com/Enchanted-Games/block-place-particles) | [Effective](https://github.com/Ladysnake/Effective) | [Particle Effects](https://github.com/LopyMine/particle-effects) | ❌ [Visuality](https://github.com/PinkGoosik/visuality) |
| ----------------------------- | -------------------------------------------- | --------------------------------------------------------------------- | ----------------------------------------------------------------------------------- | --------------------------------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------ |
| Block Placement Particles     |                                              | ❗                                                                     | ‼️                                                                                   |                                                     |                                                                  |                                                        |
| Block Breaking Particles      |                                              | ❗                                                                     | ‼️                                                                                   |                                                     |                                                                  |                                                        |
| Fire/Campfire Sparks          |                                              | ‼️                                                                     | ❗                                                                                   |                                                     |                                                                  |                                                        |
| Redstone Particles            |                                              | ❗                                                                     | ❗                                                                                   |                                                     |                                                                  |                                                        |
| Entity Effect Particles       |                                              | ‼️                                                                     |                                                                                     | ❗                                                   | ‼️                                                                |                                                        |
| Water Effects                 |                                              |                                                                       | ❗                                                                                   | ‼️                                                   |                                                                  |                                                        |
| Environmental Ambiance        | ‼️                                            | ❗                                                                     |                                                                                     | ‼️                                                   |                                                                  | ❗                                                      |
| Furnace/Smelting Particles    |                                              |                                                                       | ❗                                                                                   |                                                     |                                                                  |                                                        |
| Tool Interaction Particles    |                                              | ❗                                                                     | ‼️                                                                                   |                                                     |                                                                  |                                                        |
| Minecart Sparks               |                                              |                                                                       | ❗                                                                                   |                                                     |                                                                  |                                                        |
| Anvil/Stonecutter Sparks      |                                              |                                                                       | ❗                                                                                   |                                                     |                                                                  |                                                        |
| Mob-Specific Particles        |                                              | ‼️                                                                     | ❗                                                                                   | ❗                                                   | ‼️                                                                | ‼️                                                      |
| Mob Hit Particles             |                                              | ❗                                                                     |                                                                                     |                                                     |                                                                  | ‼️                                                      |
| Crystal Sparkles              |                                              |                                                                       |                                                                                     |                                                     |                                                                  | ‼️                                                      |
| Slime Blob Effects            |                                              | ❗                                                                     |                                                                                     |                                                     |                                                                  | ‼️                                                      |
| Vanilla Particle Overrides    |                                              | ❗                                                                     |                                                                                     | ❗                                                   | ‼️                                                                |                                                        |
| Biome-Specific Effects        |                                              | ❗                                                                     | ❗                                                                                   | ‼️                                                   |                                                                  |                                                        |
| Sound Enhancements            |                                              | ❗                                                                     |                                                                                     |                                                     |                                                                  |                                                        |
| Particle Culling/Optimization |                                              | ‼️                                                                     | ❗                                                                                   |                                                     |                                                                  |                                                        |
| Screen Shake Effects          |                                              |                                                                       |                                                                                     | ‼️                                                   |                                                                  |                                                        |
| Underwater Bubbles            |                                              |                                                                       | ❗                                                                                   | ❗                                                   |                                                                  |                                                        |
| Leaf/Foliage Particles        |                                              | ❗                                                                     | ‼️                                                                                   |                                                     |                                                                  |                                                        |
| Fireflies                     |                                              |                                                                       | ❗                                                                                   | ‼️                                                   |                                                                  |                                                        |
| **SCOPE**                     | **General Ambiance**                         | **General Subtle FX**                                                 | **Block Interactions**                                                              | **Terrain/Environment**                             | **Entity Effects**                                               | **Cosmetic Particles**                                 |
| Client-Side Only              |                                              | Mixed                                                                 | ❗                                                                                   | ❗                                                   | ❗                                                                | ❗                                                      |
| Configurability               |                                              | ‼️                                                                     | ‼️                                                                                   | ‼️                                                   |                                                                  | ❗                                                      |
| Performance Impact            |                                              | Medium                                                                | Medium                                                                              | Medium                                              | Low                                                              | Low                                                    |

**Legend:**
- `‼️` = Core Feature
- `❗` = Secondary Feature
- Blank = Not Present/Unknown
- `❌` = Has Feature Collisions

## Critical Collision Zones

### HIGH RISK
**Block placement/breaking, fire sparks, tool interactions, leaf particles**
- **Subtle Effects + Particle Interactions** = Direct overlap in block interaction particles
- Both modify core game particle systems extensively

### MEDIUM RISK
**Entity effects, water effects, environmental ambiance, mob particles**
- **Effective + Subtle Effects** = Some environmental overlap (fireflies, ambient particles)
- **Particle Effects + Subtle Effects** = Entity particle system modifications
- **Visuality + Subtle Effects** = Mob-specific particles and slime effects overlap

## Detailed Feature Breakdown

### Subtle Effects
- **Core Focus**: General subtle particle and sound enhancements
- **Key Features**:
  - Fire-related blocks have sparks
  - Slimes leave slime trails
  - Burning entities have enhanced effects
  - Player health/hunger audio cues
  - Particle culling and render distance
  - Running dust clouds
- **Compatibility**: Explicitly compatible with "Particle Core, Visuality, Particular"

### Particle Interactions
- **Core Focus**: Block interaction particle overhaul
- **Key Features**:
  - Unique block breaking/placement particles for 14+ block types
  - Tool interaction particles (tilling, stripping, flattening)
  - Fire/campfire sparks and embers
  - Redstone interaction particles
  - Furnace/smelting particles
  - Pixel-consistent particle rendering
- **Client-Side Only**: Yes (with some multiplayer limitations)

### Effective
- **Core Focus**: Terrain and environmental visual effects
- **Key Features**:
  - Water splashes, waterfall clouds, mist
  - Fireflies in humid biomes
  - Will o' Wisps in soul sand valleys
  - Screen shake effects
  - Improved entity effects (Allay trails, Glow squid)
  - Sculk dust effects
- **Water System**: Extensive water effect overhaul

### Particle Effects
- **Core Focus**: Entity effect particle texture replacement
- **Key Features**:
  - Unique textured particles for vanilla effects
  - Visual enhancement without gameplay changes
  - Simple texture replacement system
- **Scope**: Narrow, focused on visual texture improvements

### Visuality
- **Core Focus**: Cosmetic particles and mob hit effects
- **Key Features**:
  - Crystal sparkles around crystals
  - Mob hit particles (bones from skeletons, etc.)
  - Custom blob particles for slimes
  - Environmental particles
  - Stone particles in caves
  - Armor glimmer effects
- **Scope**: Client-side cosmetic enhancements
- **Client-Side Only**: Yes

### Aurae (Limited Information)
- **Core Focus**: General ambient effects
- **Key Features**: Unknown (limited documentation available)
- **Scope**: Appears to be general ambiance enhancement

## Compatibility Assessment

### Known Compatibility
- **Subtle Effects** explicitly states compatibility with similar particle mods
- All mods offer extensive configuration options
- Client-side nature reduces server-side conflicts

### Recommended Configurations
1. **Test all five mods together** with default settings first
2. **Priority configuration order**:
   - Disable overlapping features in Particle Interactions if Subtle Effects handles them better
   - Configure fire/campfire effects to use only one mod's implementation
   - Ensure block interaction particles don't duplicate
3. **Performance monitoring** during gameplay with all mods active

### Risk Mitigation
- All mods provide granular configuration options
- Start with most essential mods (Effective, Subtle Effects) and add others incrementally
- Monitor for visual conflicts and duplicate effects during testing

## Conclusion

**Highest Collision Risk**: Subtle Effects + Particle Interactions due to extensive overlap in block interaction particles, fire effects, and tool usage particles.

**Secondary Collision Risk**: Visuality + Subtle Effects may have some overlap in mob-specific particles and slime effects.

**Recommendation**: Enable all six mods but prioritize configuring Subtle Effects and Particle Interactions to avoid duplicate effects on block placement/breaking and fire-related particles. Monitor Visuality's mob hit particles for potential overlap with Subtle Effects' mob-specific features. The extensive configurability of these mods should allow for successful integration with minor adjustments.
