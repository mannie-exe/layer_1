# Contributing to layer_1

This guide covers the complete development setup, build system, and testing procedures for layer_1.

## Prerequisites

### Required Tools
- **packwiz** - Must be installed and available on PATH
  - Installation: https://packwiz.infra.link/installation
- **Bash scripting environment**:
  - **macOS/Linux**: Native support
  - **Windows**: WSL (Windows Subsystem for Linux) or Git Bash
  - **Alternative**: Ability to run packwiz commands manually
- **Java Runtime Environment (JRE) 21+** - Required for local testing
- **Git** - For version control

### Optional Tools
- **act** - For local GitHub Actions testing
  - Installation: `brew install act` (macOS) or see [GitHub](https://github.com/nektos/act)

## Quick Start for Developers

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
- **`man.sh`** - Quick pack export script  
- **Automated CI/CD** - GitHub Actions handle releases
- **Clean separation** - All build artifacts organized in `dist/`

### Primary Build Targets

- **`mrpack`** - Create Modrinth-compatible modpack file
- **`instance`** - Build launcher instance with custom icon and bootstrapper
- **`clean`** - Clean build directories
- **`all`** - Build both mrpack and instance for release

### Distribution Flow

```bash
./make.sh mrpack     # → dist/layer_1-v0.4.2-alpha.mrpack
./make.sh instance   # → dist/layer_1-v0.4.2-alpha.zip
```

The instance build automatically includes the packwiz bootstrapper, allowing for one-click mod installation while preserving custom icons and configs.

## Local GitHub Actions Testing with `act`

### Quick Commands

```bash
# Install act (macOS)
brew install act

# List all workflows and jobs
act -l

# Dry run (show what would execute)
act -n

# Test validation workflow (PR simulation)
act pull_request -n -e .github/act-events/pull_request.json

# Test release workflow (tag simulation) 
act push -n -e .github/act-events/tag.json

# Actually run validation (for real testing)
act pull_request -e .github/act-events/pull_request.json

# Test specific job only
act -j validate -n
act -j build -n
```

### Event Files

- `.github/act-events/push.json` - Regular push events
- `.github/act-events/tag.json` - Release tag events  
- `.github/act-events/pull_request.json` - PR events

### Configuration

- `.actrc` - Default act configuration
  - Uses improved Ubuntu images
  - Enables container reuse for speed
  - Sets default push event
  - Enables offline mode

### Notes

- Add `--container-architecture linux/amd64` if you have issues on Apple Silicon
- First run will be slower (pulling Docker images)
- Subsequent runs are much faster with `--reuse`
- Use `-n` flag for dry runs before real execution

## Development Workflow

1. **Clone and Setup**: Follow the quick start above
2. **Make Changes**: Add/remove mods, update configs, modify scripts
3. **Test Locally**: Use `./make.sh mrpack` to test pack generation
4. **Test CI**: Use `act` to verify GitHub Actions workflows
5. **Submit PR**: Push changes and create pull request
6. **Review**: Address feedback and iterate

## Mod Curation Philosophy

When contributing mod suggestions or changes:
1. **Vanilla+**: Mods should enhance, not fundamentally change Minecraft
2. **Performance**: Performance impact should be minimal or positive
3. **Quality**: Only well-maintained, stable mods
4. **Compatibility**: Must work well with existing mod selection
5. **Purpose**: Each mod should serve a clear purpose without redundancy

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
├── instance-template/       # Instance template files
├── installer/              # Packwiz installer
├── dist/                   # Build outputs (generated)
├── make.sh                 # Main build script
└── man.sh                  # Quick export script
```