# Mojo Package Management (2025/2026)

This document explains the current state of package management in Mojo as of January 2026.

## Current State Summary

**TL;DR:** Mojo has basic packaging capabilities but no centralized package registry yet. You can create and share packages, but distribution is manual.

---

## 📦 What Mojo Has

### 1. **Modules** (.mojo files)
A single `.mojo` file that can be imported:

```mojo
# mymodule.mojo
struct MyStruct:
    var value: Int
    
    fn __init__(out self, value: Int):
        self.value = value
```

```mojo
# main.mojo
from mymodule import MyStruct

def main():
    var obj = MyStruct(42)
```

**Limitation:** Module must be in same directory or you need packages.

### 2. **Packages** (directories with `__init__.mojo`)

A directory with an `__init__.mojo` file:

```
mypackage/
├── __init__.mojo      # Makes this a package
├── module1.mojo
└── module2.mojo
```

```mojo
# main.mojo
from mypackage import module1
from mypackage.module2 import SomeFunction
```

### 3. **Compiled Packages** (.mojopkg / .📦)

You can compile a package into a distributable file:

```bash
mojo package mypackage -o mypackage.mojopkg
```

This creates a **portable binary package** that:
- Works across systems (architecture-independent)
- Contains non-elaborated code
- Can be imported like source packages
- More secure (obfuscated)

**Usage:**
```mojo
# Import from compiled package
from mypackage import something
```

Mojo finds `.mojopkg` files in:
- Current directory
- Directories in `MOJO_LIBRARY_PATH` environment variable

---

## ❌ What Mojo Doesn't Have (Yet)

### 1. **No Central Package Registry**
- No equivalent of PyPI, npm, crates.io
- Can't `mojo install package-name`
- Manual distribution only

### 2. **No Dependency Management**
- No `requirements.txt` or `Cargo.toml` equivalent
- No automatic dependency resolution
- Must manually manage dependencies

### 3. **No Package Metadata Standard**
- No standard for version, author, license
- No semantic versioning enforcement
- No dependency declaration format

### 4. **No Built-in Package Manager**
- `mojo` CLI doesn't have package management commands (yet)
- Must use external tools (pixi, conda, etc.)

---

## 🛠️ Current Best Practices

### For Development

**Use pixi** (Recommended by Modular):

```toml
# pixi.toml
[project]
name = "mojo-dotenv"
version = "0.1.0"
channels = ["conda-forge", "https://conda.modular.com/max-nightly"]

[dependencies]
mojo = "*"

[tasks]
test = "mojo test tests/"
build = "mojo package src/dotenv -o dotenv.mojopkg"
```

```bash
pixi run test
pixi run build
```

**Benefits:**
- Virtual environment management
- Lock files for reproducibility
- Task runner built-in
- Works with conda ecosystem

### For Distribution

**Manual sharing:**

1. **Source code:**
   ```bash
   git clone https://github.com/user/mojo-dotenv
   # Copy src/ to your project
   ```

2. **Compiled package:**
   ```bash
   # Build
   mojo package src/dotenv -o dotenv.mojopkg
   
   # Share .mojopkg file
   # Users add to their project
   ```

3. **Via GitHub releases:**
   - Tag version: `git tag v0.1.0`
   - Create GitHub release
   - Attach `.mojopkg` file
   - Users download and import

---

## 📚 Package Structure Standards

While there's no official standard, the community has converged on:

### Directory Structure

```
mypackage/
├── src/
│   └── mypackage/
│       ├── __init__.mojo      # Package entry point
│       ├── module1.mojo
│       └── module2.mojo
├── tests/
│   ├── test_module1.mojo
│   └── test_module2.mojo
├── examples/
│   └── example.mojo
├── README.md
├── LICENSE
└── pixi.toml                  # Or magic.toml
```

### `__init__.mojo` Pattern

**Expose public API:**
```mojo
# src/mypackage/__init__.mojo

# Import from modules
from .module1 import PublicFunction1
from .module2 import PublicFunction2, PublicStruct

# Now users can:
# from mypackage import PublicFunction1, PublicStruct
```

### Naming Conventions

- **Package names:** `snake_case` or `kebab-case`
- **Module names:** `snake_case.mojo`
- **Compiled packages:** `packagename.mojopkg`

---

## 🔮 Future: What's Coming

Based on Modular's roadmap and community discussions:

### Package Registry (Planned)
- Central repository for Mojo packages
- CLI commands: `mojo add`, `mojo install`, `mojo publish`
- Versioning and dependency resolution
- Package discovery and search

### Package Manifest (Expected)
Likely similar to:

```toml
# mojoproject.toml (hypothetical)
[package]
name = "mojo-dotenv"
version = "0.1.0"
authors = ["Your Name <email@example.com>"]
license = "Apache-2.0"
description = "Load environment variables from .env files"
repository = "https://github.com/user/mojo-dotenv"

[dependencies]
# No dependencies

[dev-dependencies]
# Testing dependencies
```

### Integration with Magic/Pixi
Modular's `magic` CLI (built on pixi) may become the official package manager:

```bash
magic add mojo-dotenv
magic install
magic run tests
```

---

## 🎯 Practical Guide for mojo-dotenv

### Phase 1: Development

**Use pixi:**

```toml
# pixi.toml
[project]
name = "mojo-dotenv"
version = "0.1.0"
channels = ["conda-forge", "https://conda.modular.com/max-nightly"]

[dependencies]
mojo = "*"
python-dotenv = "*"  # For testing

[tasks]
test = "mojo tests/test_basic.mojo"
build = "mojo package src/dotenv -o dotenv.mojopkg"
example = "mojo examples/simple.mojo"
```

### Phase 2: Distribution

**Via GitHub:**

1. **Source distribution:**
   ```bash
   # Users clone and copy
   git clone https://github.com/user/mojo-dotenv
   cp -r mojo-dotenv/src/dotenv /path/to/project/
   ```

2. **Binary distribution:**
   ```bash
   # Build package
   mojo package src/dotenv -o dotenv.mojopkg
   
   # Create GitHub release
   gh release create v0.1.0 dotenv.mojopkg --title "v0.1.0" --notes "Initial release"
   
   # Users download
   curl -L -o dotenv.mojopkg https://github.com/user/mojo-dotenv/releases/download/v0.1.0/dotenv.mojopkg
   ```

3. **Installation instructions:**
   ```markdown
   ## Installation
   
   ### Option 1: Source
   1. Clone the repository
   2. Copy `src/dotenv/` to your project
   3. Import: `from dotenv import load_dotenv`
   
   ### Option 2: Compiled Package
   1. Download `dotenv.mojopkg` from releases
   2. Place in your project root or add to `MOJO_LIBRARY_PATH`
   3. Import: `from dotenv import load_dotenv`
   ```

### Phase 3: Environment Setup

**For users:**

```bash
# Set library path (if needed)
export MOJO_LIBRARY_PATH="/path/to/packages:$MOJO_LIBRARY_PATH"

# Or add to shell profile
echo 'export MOJO_LIBRARY_PATH="/path/to/packages:$MOJO_LIBRARY_PATH"' >> ~/.zshrc
```

---

## 🔗 References

- [Mojo Packages Documentation](https://docs.modular.com/mojo/manual/packages/)
- [Pixi Documentation](https://pixi.sh/)
- [Modular Community Discord](https://discord.gg/modular)

---

## 📝 Summary for mojo-dotenv

**For now:**
1. ✅ Use pixi for development
2. ✅ Structure as proper package with `__init__.mojo`
3. ✅ Build `.mojopkg` for distribution
4. ✅ Share via GitHub releases
5. ✅ Document installation clearly

**Watch for:**
- Official package registry announcement
- `magic` CLI package management features
- Standardized manifest format

**Future-proof:**
- Use semantic versioning
- Keep good documentation
- Follow community conventions
- Be ready to migrate to official registry

---

**Last Updated:** 2026-01-05
