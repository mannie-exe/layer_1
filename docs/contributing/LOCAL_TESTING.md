# Contributing to layer_1

Complete guide for contributing to the layer_1 modpack.

## Getting Started

1. **[Development Setup](SETUP.md)** - Install required tools and dependencies
2. **[Contributing Philosophy](PHILOSOPHY.md)** - Understand our curation approach and direction
3. **[Build System](../BUILD_SYSTEM.md)** - Learn how the build system works
4. **[Testing Guide](TESTING.md)** - Test your changes locally and with CI

## Quick Reference

```bash
# Clone and setup
git clone https://github.com/mannie-exe/layer_1.git
cd layer_1

# Common commands
./empack help        # Show all available commands
./empack mrpack      # Build modpack file
./empack all         # Build everything for release
./empack clean       # Clean build directories

# View packaged mods
./man

# Test changes
./empack mrpack      # Verify pack builds correctly
```

## Development Dependencies

**Required tools** (see [setup guide](SETUP.md) for installation):
- packwiz, tq, mrpack-install, Java 21+, Git, Bash environment

**Repository requires these tools** - check the setup guide before cloning.

## Workflow Summary

1. **Setup** → **Research** → **Implement** → **Test** → **Submit**
2. Follow the [contributing philosophy](PHILOSOPHY.md)
3. Use the [build system](../BUILD_SYSTEM.md) to create artifacts
4. Test locally and with CI using the [testing guide](TESTING.md)