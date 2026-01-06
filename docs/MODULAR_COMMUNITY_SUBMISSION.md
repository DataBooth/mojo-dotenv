# Submitting to modular-community Channel

This guide explains how to submit `mojo-dotenv` to the official **modular-community** conda channel.

## Overview

The `modular-community` channel is an **official Modular-hosted repository** that makes community packages available via https://repo.prefix.dev/modular-community. This is more official than awesome-mojo lists and allows users to install packages with `pixi add`.

## Requirements

<cite index="21-5,21-6,21-14">To submit your package to the Modular community channel, you'll need to fork the Modular community channel GitHub repository, add a folder to the /recipes folder with the same name as your package, and include a rattler-build recipe file named recipe.yaml and a file that includes tests for your package.</cite>

## Step-by-Step Guide

### 1. Fork and Clone modular-community

```bash
# Fork the repository
gh repo fork modular/modular-community --clone

cd modular-community
```

### 2. Create Package Directory

```bash
# Create directory for your package
mkdir -p recipes/mojo-dotenv
cd recipes/mojo-dotenv
```

### 3. Create recipe.yaml

Create `recipes/mojo-dotenv/recipe.yaml`:

```yaml
context:
  version: "0.2.0"

package:
  name: mojo-dotenv
  version: ${{ version }}

source:
  git: https://github.com/DataBooth/mojo-dotenv
  tag: v${{ version }}

build:
  number: 0
  # Mojo packages are typically noarch (architecture-independent source)
  noarch: generic
  script:
    - mkdir -p $PREFIX/lib/mojo/dotenv
    - cp -r src/dotenv/* $PREFIX/lib/mojo/dotenv/

requirements:
  host:
    - max >=25.1.0
  run:
    - max >=25.1.0

tests:
  - script:
      - test -f $PREFIX/lib/mojo/dotenv/__init__.mojo
      - test -f $PREFIX/lib/mojo/dotenv/parser.mojo
      - test -f $PREFIX/lib/mojo/dotenv/loader.mojo
      - test -f $PREFIX/lib/mojo/dotenv/finder.mojo

about:
  homepage: https://github.com/DataBooth/mojo-dotenv
  repository: https://github.com/DataBooth/mojo-dotenv
  documentation: https://github.com/DataBooth/mojo-dotenv/blob/main/README.md
  license: MIT
  license_file: LICENSE
  summary: Load environment variables from .env files in Mojo
  description: |
    A production-ready .env file parser and loader for Mojo with near-100% python-dotenv compatibility.
    
    Features:
    - Parse .env files to Dict or load into environment
    - Variable expansion (${VAR} and $VAR syntax)
    - Multiline values and escape sequences
    - Auto-discovery with find_dotenv()
    - 98%+ compatible with python-dotenv
    - 42 comprehensive tests using Mojo's TestSuite framework
```

### 4. Create test.mojo (Optional but Recommended)

Create `recipes/mojo-dotenv/test.mojo`:

```mojo
from dotenv import dotenv_values, load_dotenv

fn main() raises:
    # Basic smoke test
    print("Testing mojo-dotenv import...")
    
    # Test dotenv_values exists
    var config = dotenv_values(".env.test") 
    print("dotenv_values: OK")
    
    # Test load_dotenv exists
    _ = load_dotenv(".env.test")
    print("load_dotenv: OK")
    
    print("All import tests passed!")
```

### 5. Test Locally with rattler-build

```bash
# Install rattler-build if you haven't
pixi global install rattler-build

# Build the package locally
cd ../..  # Back to modular-community root
rattler-build build --recipe recipes/mojo-dotenv/recipe.yaml

# Test the built package
rattler-build test --package-file output/noarch/mojo-dotenv-0.2.0-*.conda
```

### 6. Create PR

```bash
# Create branch
git checkout -b add-mojo-dotenv

# Add files
git add recipes/mojo-dotenv/
git commit -m "Add mojo-dotenv package

- Production-ready .env file parser and loader for Mojo
- 98%+ compatible with python-dotenv  
- Variable expansion, multiline values, escape sequences
- Auto-discovery with find_dotenv()
- 42 comprehensive tests with TestSuite
- MIT License"

# Push and create PR
git push origin add-mojo-dotenv
gh pr create --title "Add mojo-dotenv - .env file loader for Mojo" \
  --body "$(cat <<'EOF'
## mojo-dotenv v0.2.0

A production-ready `.env` file parser and loader for Mojo with near-100% python-dotenv compatibility.

**Features:**
- Parse .env files to Dict or load into environment  
- Variable expansion (`${VAR}` and `$VAR` syntax)
- Multiline values and escape sequences
- Auto-discovery with `find_dotenv()`
- 98%+ compatible with python-dotenv
- 42 comprehensive tests using Mojo's TestSuite framework

**Repository:** https://github.com/DataBooth/mojo-dotenv  
**License:** MIT License

This fills a gap in the Mojo ecosystem for configuration management following 12-factor app methodology.

**Testing:**
- [x] Recipe builds successfully locally
- [x] Tests pass
- [x] Follows modular-community guidelines
EOF
)"
```

## After Approval

Once your PR is merged, users can install mojo-dotenv with:

```toml
# pixi.toml
[project]
channels = [
  "conda-forge",
  "https://conda.modular.com/max",
  "https://repo.prefix.dev/modular-community"  # Add this
]

[dependencies]
max = ">=25.1.0"
mojo-dotenv = "0.2.0"
```

Or via command line:

```bash
pixi add mojo-dotenv
```

## Important Notes

### Source Distribution vs .mojopkg

For modular-community, distribute **source code** rather than compiled `.mojopkg` files because:
1. Mojo's package format is not yet stable across versions
2. Source is architecture-independent (noarch)
3. Users compile on their own systems with their Mojo version

### Package Installation Path

The recipe installs to `$PREFIX/lib/mojo/dotenv/` which users can access with:

```mojo
# In user's code
from dotenv import load_dotenv, dotenv_values
```

Users need to ensure `$PREFIX/lib/mojo` is in their `MOJO_PATH`.

### Version Updates

When releasing new versions:
1. Create new git tag (e.g. v0.2.1)
2. Submit PR to update version in recipe.yaml context section
3. Update sha256 if using URL source (not needed for git source with tags)

## Troubleshooting

### Build Fails

```bash
# Check build logs
rattler-build build --recipe recipes/mojo-dotenv/recipe.yaml --verbose
```

### Test Fails

```bash
# Run tests manually
rattler-build test --package-file output/noarch/mojo-dotenv-*.conda
```

### Import Issues

Make sure MOJO_PATH includes the installation directory:

```bash
export MOJO_PATH="$PREFIX/lib/mojo:$MOJO_PATH"
```

## Resources

- **modular-community repo**: https://github.com/modular/modular-community
- **rattler-build docs**: https://prefix-dev.github.io/rattler-build/
- **Example recipes**: https://github.com/modular/modular-community/tree/main/recipes
- **Community channel**: https://repo.prefix.dev/modular-community

## Benefits of modular-community

1. **Official Modular hosting** - More authoritative than third-party lists
2. **Easy installation** - Users can `pixi add mojo-dotenv`
3. **Version management** - Pixi handles dependencies and versions
4. **Discoverability** - Listed in official Modular ecosystem
5. **Automatic builds** - CI builds for multiple platforms
6. **Community visibility** - Featured in Modular's ecosystem
