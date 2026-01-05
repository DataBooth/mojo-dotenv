# Distribution Guide

This document describes how to package, distribute, and use mojo-dotenv in your projects.

## Current State (2026-01-05)

**Status**: Phase 2 Complete - MVP functional, ready for distribution

Mojo packaging is still evolving. Currently, there are three main ways to use mojo-dotenv:

1. ✅ **Source inclusion** (recommended for now)
2. 🚧 **Compiled package** (.mojopkg) - experimental
3. 🔮 **Future**: Central package registry (when available)

## Option 1: Source Inclusion (Recommended)

The most reliable method currently is to include the source directly in your project.

### Method A: Git Submodule

```bash
# In your project root
cd your-project
git submodule add https://github.com/databooth/mojo-dotenv vendor/mojo-dotenv

# Use in your code
# Add vendor/mojo-dotenv/src to your import path
mojo -I vendor/mojo-dotenv/src your_app.mojo
```

**Pros:**
- Version controlled
- Easy to update (`git submodule update`)
- Works reliably with current Mojo

**Cons:**
- Requires git submodule management
- Increases repository size slightly

### Method B: Direct Copy

```bash
# Copy the source files into your project
cp -r mojo-dotenv/src/dotenv your-project/lib/dotenv

# Use in your code
mojo -I lib your_app.mojo
```

**Pros:**
- Simple, no git submodules
- Full control over the code

**Cons:**
- Manual updates required
- Harder to track version

### Method C: pixi Dependency (Development)

For development with pixi:

```toml
# pixi.toml
[dependencies]
# Add your dependencies

[activation]
env = { MOJO_PATH = "$PIXI_PROJECT_ROOT/vendor/mojo-dotenv/src:$PIXI_PROJECT_ROOT/src" }
```

Then clone mojo-dotenv into `vendor/`:

```bash
mkdir -p vendor
git clone https://github.com/databooth/mojo-dotenv vendor/mojo-dotenv
```

## Option 2: Compiled Package (.mojopkg)

**Status**: Experimental - .mojopkg format changes between Mojo versions

### Building a Package

```bash
cd mojo-dotenv

# Build the package
mojo package src/dotenv -o dist/dotenv.mojopkg

# The package is now at dist/dotenv.mojopkg
```

### Using a Compiled Package

```bash
# Download or copy the .mojopkg file
curl -L -o dotenv.mojopkg https://github.com/databooth/mojo-dotenv/releases/download/v0.1.0/dotenv.mojopkg

# Use it (exact method TBD - Mojo packaging evolving)
# Add to your import path or install location
```

**⚠️ Warning**: .mojopkg files are **not portable** across Mojo versions. A package built with Mojo 0.26.1 may not work with 0.26.2 or 0.27.0. This is a known limitation as Mojo approaches 1.0.

**Current challenges:**
- Binary format changes between versions
- No standard installation location
- No dependency resolution

## Option 3: Future Package Management

Modular has indicated plans for:
- **Official package registry** (like PyPI, npm, crates.io)
- **magic/pixi integration** for Mojo packages  
- **Standard package format** with version stability
- **Dependency resolution**

When available, installation will be:

```bash
# Future (hypothetical)
magic add mojo-dotenv
# or
pixi add mojo-dotenv
```

```mojo
# Your code
from dotenv import load_dotenv  # Just works!
```

## Recommended Approach (January 2026)

For production use:

1. **Use git submodule or direct copy** (Option 1)
2. **Pin to a specific commit/tag** for stability
3. **Test with your Mojo version** before deploying
4. **Check for updates** regularly as Mojo evolves

Example `DEPENDENCIES.md` in your project:

```markdown
# Dependencies

## mojo-dotenv
- **Version**: v0.1.0
- **Repository**: https://github.com/databooth/mojo-dotenv
- **Commit**: 37c2737
- **Method**: Git submodule at vendor/mojo-dotenv
- **Mojo version**: 0.26.1.0
```

## Versioning & Compatibility

### mojo-dotenv Versioning

We follow [Semantic Versioning](https://semver.org/):
- **v0.1.x**: MVP releases (Phase 1 & 2 complete)
- **v0.2.x**: Advanced features (Phase 3)
- **v0.3.x**: Production hardening (Phase 4)
- **v1.0.0**: Stable API, production ready

### Mojo Compatibility

| mojo-dotenv | Mojo Versions | Status |
|-------------|---------------|--------|
| v0.1.0      | 0.26.1+       | ✅ Tested |
| v0.1.0      | 0.27.0        | 🔄 TBD |

**Breaking changes**: We will clearly document Mojo version requirements and any breaking changes in release notes.

## Release Process

### For Maintainers

1. **Update version** in README, PLAN.md
2. **Run full test suite**: `pixi run test-all`
3. **Update CHANGELOG.md**
4. **Create git tag**: `git tag -a v0.1.0 -m "Release v0.1.0"`
5. **Push tag**: `git push origin v0.1.0`
6. **Create GitHub release** with:
   - Source code (automatic)
   - CHANGELOG excerpt
   - Installation instructions
   - (Optional) Compiled .mojopkg with Mojo version note

### For Users

To use a specific version:

```bash
# Git submodule
git submodule add -b v0.1.0 https://github.com/databooth/mojo-dotenv vendor/mojo-dotenv

# Or clone specific tag
git clone --branch v0.1.0 https://github.com/databooth/mojo-dotenv vendor/mojo-dotenv
```

## Platform Support

Currently tested on:
- ✅ macOS (Apple Silicon)
- 🔄 macOS (Intel) - should work, untested
- 🔄 Linux (x86_64) - should work, untested  
- 🔄 Linux (ARM64) - should work, untested

**Windows support**: Requires Mojo Windows support (not yet available)

## Migration from mojoenv

If you're using mojoenv:

1. **Check compatibility**: See [docs/MOJOENV_COMPATIBILITY_ANALYSIS.md](MOJOENV_COMPATIBILITY_ANALYSIS.md)
2. **API is similar**:
   - `load_mojo_env()` → `load_dotenv()`
   - Functionality matches
3. **Update imports**:
   ```mojo
   # Old (mojoenv)
   from mojoenv import load_mojo_env
   
   # New (mojo-dotenv)
   from dotenv import load_dotenv
   ```
4. **Test thoroughly** - subtle parsing differences may exist

## Integration Examples

### With pixi

```toml
# pixi.toml
[workspace]
name = "my-app"
channels = ["conda-forge", "https://conda.modular.com/max-nightly"]

[dependencies]
mojo = ">=0.26.1,<0.27"

[activation]
env = { MOJO_PATH = "$PIXI_PROJECT_ROOT/vendor/mojo-dotenv/src:$PIXI_PROJECT_ROOT/src" }
```

### With magic (Modular's tool)

```bash
# Current approach
magic init my-app
cd my-app
mkdir -p vendor
git clone https://github.com/databooth/mojo-dotenv vendor/mojo-dotenv

# Use with -I flag
magic run mojo -I vendor/mojo-dotenv/src app.mojo
```

### In CI/CD

```yaml
# GitHub Actions example
- name: Install Mojo dependencies
  run: |
    git submodule update --init --recursive
    
- name: Run tests
  run: |
    mojo -I vendor/mojo-dotenv/src tests/test_app.mojo
```

## Troubleshooting

### "unable to locate module 'dotenv'"

**Solution**: Add `-I` flag pointing to the source:
```bash
mojo -I path/to/mojo-dotenv/src your_app.mojo
```

### .mojopkg incompatibility

**Symptom**: `error: expected mlir::TypedAttr, but got: @stdlib`

**Solution**: 
1. Rebuild .mojopkg with your Mojo version
2. Or use source inclusion (Option 1)

### Version mismatch

**Solution**: Check `mojo --version` and compare with [Compatibility Matrix](#mojo-compatibility)

## Questions?

- **Issues**: https://github.com/databooth/mojo-dotenv/issues
- **Discussions**: https://github.com/databooth/mojo-dotenv/discussions
- **Modular Discord**: Ask in #community-packages channel

## Future Improvements

As Mojo's packaging story matures, we'll update this guide with:
- [ ] Official package registry integration
- [ ] Prebuilt binaries for common platforms
- [ ] Dependency management integration
- [ ] Automatic version compatibility checking

---

**Last Updated**: 2026-01-05  
**mojo-dotenv Version**: v0.1.0 (Phase 2)  
**Mojo Version**: 0.26.1.0.dev2026010405
