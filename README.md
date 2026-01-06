# mojo-dotenv 🔥

A modern `.env` file parser and loader for Mojo, compatible with Mojo 2025/2026.

> **Status:** ✅ **Production-ready** - Advanced features, near-100% python-dotenv compatibility

## Overview

`mojo-dotenv` loads environment variables from `.env` files into your Mojo applications.

```mojo
from dotenv import load_dotenv, dotenv_values
from os import getenv

fn main() raises:
    # Option 1: Load .env file into environment
    if load_dotenv(".env"):
        var db_url = getenv("DATABASE_URL")
        print("Connecting to:", db_url)
    
    # Option 2: Parse without modifying environment (with safe key access)
    var config = dotenv_values(".env")
    print("Port:", config.get("PORT", "8080"))  # Default to 8080 if not set
```

## Motivation

This project was inspired by [mojoenv](https://github.com/itsdevcoffee/mojoenv) by itsdevcoffee, which pioneered `.env` support in Mojo. However, mojoenv was built for Mojo in 2023 and is no longer compatible with modern Mojo syntax and stdlib.

`mojo-dotenv` is a complete rewrite using current Mojo patterns (2025/2026), with:
- ✅ Modern Mojo syntax and stdlib
- ✅ Comprehensive tests against python-dotenv
- ✅ Clear documentation and examples
- ✅ Production-ready error handling

## Features

### Current (v0.2.0 - Near-100% python-dotenv Compatible)
- [x] Parse `KEY=value` pairs
- [x] Handle comments (`#` lines and inline comments)
- [x] Handle quotes (`"value"`, `'value'`)
- [x] Strip whitespace
- [x] Load into environment (`load_dotenv()`)
- [x] Return `Dict[String, String]` (`dotenv_values()`)
- [x] Variable expansion (`${VAR}` and `$VAR` syntax)
- [x] Multiline values (quoted strings spanning lines)
- [x] Escape sequences (`\n`, `\t`, `\"`, `\\`, `\'`)
- [x] Export prefix support (`export KEY=value`)
- [x] `find_dotenv()` - automatic .env file discovery
- [x] Keys without `=` (returns empty string)
- [x] Verbose mode for debugging
- [x] 98%+ compatibility with python-dotenv
- [x] Comprehensive test suite (49 tests across 11 test files)

### Planned (v0.3.0+)
- [ ] Multiple .env files with precedence
- [ ] Stream input support
- [ ] Custom encoding options

See [PLAN.md](PLAN.md) for detailed roadmap.

## Installation

Choose the installation method that best fits your workflow:

### Option 1: pixi (Recommended - Coming Soon)

Easiest method using the official modular-community channel.

```bash
# Add modular-community channel to your pixi.toml
[project]
channels = [
  "conda-forge",
  "https://conda.modular.com/max",
  "https://repo.prefix.dev/modular-community"
]

# Install mojo-dotenv
pixi add mojo-dotenv
```

> **Status**: [PR #192](https://github.com/modular/modular-community/pull/192) submitted, pending review. Once merged, this will be the preferred installation method.

### Option 2: Git Submodule

Best for version-controlled projects with easy updates.

```bash
# Add to your project
cd your-project
git submodule add https://github.com/databooth/mojo-dotenv vendor/mojo-dotenv

# Use in your code
mojo -I vendor/mojo-dotenv/src your_app.mojo

# Update to latest version
git submodule update --remote vendor/mojo-dotenv
```

### Option 3: Direct Copy

Simplest method for quick projects.

```bash
# Clone and copy source
git clone https://github.com/databooth/mojo-dotenv
cp -r mojo-dotenv/src/dotenv your-project/lib/dotenv

# Use in your code
mojo -I your-project/lib your_app.mojo
```

### Option 4: Compiled Package (.mojopkg)

Pre-compiled packages available from [GitHub Releases](https://github.com/databooth/mojo-dotenv/releases).

```bash
# Download from releases
curl -L -o dotenv.mojopkg https://github.com/databooth/mojo-dotenv/releases/latest/download/dotenv.mojopkg

# Use in your code
mojo -I . your_app.mojo  # Ensure dotenv.mojopkg is in import path
```

⚠️ **Note**: `.mojopkg` files are tied to specific Mojo versions. Check the release notes for compatibility. Source installation is recommended for maximum compatibility.

See **[docs/DISTRIBUTION.md](docs/DISTRIBUTION.md)** for detailed installation guides and advanced options.

### Development Setup
```bash
git clone https://github.com/databooth/mojo-dotenv
cd mojo-dotenv
pixi install
pixi run test-all
```

## Usage

### Quick Start

```mojo
from dotenv import dotenv_values, load_dotenv
from os import getenv

fn main() raises:
    # Parse .env file without setting environment variables
    var config = dotenv_values(".env")
    # Use .get() for safe key access with defaults
    print("Database:", config.get("DATABASE_URL", "localhost"))
    
    # Load .env file and set environment variables
    if load_dotenv(".env"):
        print("API Key:", getenv("API_KEY"))
```

### API Reference

#### `dotenv_values(dotenv_path: String, verbose: Bool = False) -> Dict[String, String]`

Parse a .env file and return its content as a dictionary. Does NOT modify environment variables.

**Parameters:**
- `dotenv_path`: Path to .env file (absolute or relative)
- `verbose`: Print debug information during parsing (default: False)

**Returns:** Dictionary mapping variable names to values

**Example:**
```mojo
var config = dotenv_values("config/.env")
# Iterate through all values
for item in config.items():
    print(item.key, "=", item.value)

# Safe key access with defaults
var db_url = config.get("DATABASE_URL", "localhost:5432")
var port = config.get("PORT", "8080")
```

#### `load_dotenv(dotenv_path: String, override: Bool = False, verbose: Bool = False) -> Bool`

Load variables from a .env file into the environment.

**Parameters:**
- `dotenv_path`: Path to .env file
- `override`: If True, override existing environment variables (default: False)
- `verbose`: Print debug information during loading (default: False)

**Returns:** True if successful, False if file not found

**Example:**
```mojo
if load_dotenv(".env"):
    print("Loaded successfully")
```

#### `find_dotenv(filename: String = ".env", raise_error_if_not_found: Bool = False, usecwd: Bool = False) -> String`

Search for a .env file by traversing parent directories.

**Parameters:**
- `filename`: Name of .env file to search for (default: ".env")
- `raise_error_if_not_found`: Raise error if file not found (default: False)
- `usecwd`: Start search from current directory instead of file's directory (default: False)

**Returns:** Path to .env file, or empty string if not found

**Example:**
```mojo
var env_path = find_dotenv()
if len(env_path) > 0:
    _ = load_dotenv(env_path)
```

### Differences from python-dotenv

`mojo-dotenv` maintains 98%+ compatibility with python-dotenv. The main difference is in how missing environment variables are handled:

**Environment variable access:**
```python
# Python: os.getenv() returns None for missing variables
import os
value = os.getenv("MISSING_VAR")  # Returns None
print("Value:", value)               # Prints: Value: None
```

```mojo
# Mojo: os.getenv() returns empty string for missing variables  
from os import getenv
var value = getenv("MISSING_VAR")  # Returns ""
print("Value:", value)              # Prints: Value: 
```

This is a difference in the underlying standard libraries, not in mojo-dotenv itself. Both `load_dotenv()` and `dotenv_values()` behave identically to python-dotenv.

**Best practice:** Always check if `load_dotenv()` succeeded before accessing environment variables:
```mojo
if load_dotenv(".env"):
    var api_key = getenv("API_KEY")
    # Use api_key
```

### .env File Format

Supported syntax:
```bash
# Full-line comments
KEY=value
QUOTED="value"
SINGLE='value'
EMPTY=
SPACES=  value  # Inline comments supported
KEY_WITH_EQUALS=value=with=equals

# Export prefix (stripped automatically)
export DATABASE_URL=postgresql://localhost

# Variable expansion
BASE_DIR=/home/user
DATA_DIR=${BASE_DIR}/data
LOG_FILE=$BASE_DIR/app.log

# Escape sequences (in quoted strings only)
MULTILINE="Line 1\nLine 2\nLine 3"
TABS="Col1\tCol2\tCol3"
QUOTE="He said \"hello\""
PATH="C:\\\\Users\\\\name"

# Multiline values (quoted strings can span lines)
PRIVATE_KEY="-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAAS
-----END PRIVATE KEY-----"

# Keys without values
KEY_WITHOUT_VALUE
```

## Project Structure

```
mojo-dotenv/
├── src/dotenv/          # Source code
├── tests/               # Tests
├── examples/            # Examples
├── docs/                # Documentation
├── PLAN.md              # Detailed project plan
└── README.md            # This file
```

## Development

### Prerequisites
- Mojo 2025/2026 (via pixi)
- Python 3.10+ (for testing against python-dotenv)

### Setup
```bash
# Clone repository
git clone https://github.com/databooth/mojo-dotenv
cd mojo-dotenv

# Install dependencies
pixi install

# Run tests
pixi run test          # Basic tests
pixi run test-compat   # Python compatibility tests
pixi run test-load     # load_dotenv tests
pixi run test-all      # All tests

# Run example
pixi run example-simple
```

### Documentation
- [PLAN.md](PLAN.md) - Detailed project plan and roadmap
- [CREDITS.md](CREDITS.md) - Acknowledgments and project history
- [Building mojo-dotenv](https://www.databooth.com.au/posts/mojo/building-mojo-dotenv/) - **Blog post: lessons from building the package**
- [docs/DISTRIBUTION.md](docs/DISTRIBUTION.md) - Packaging and distribution guide
- [docs/MOJO_PACKAGE_MANAGEMENT.md](docs/MOJO_PACKAGE_MANAGEMENT.md) - Mojo packaging ecosystem overview
- [docs/RESEARCH.md](docs/RESEARCH.md) - python-dotenv API analysis and testing
- [docs/MOJOENV_COMPATIBILITY_ANALYSIS.md](docs/MOJOENV_COMPATIBILITY_ANALYSIS.md) - mojoenv compatibility findings

## Contributing

Contributions welcome! This is an open-source project (MIT License).

### Ways to Contribute
- Report bugs or request features
- Improve documentation
- Add test cases
- Implement features
- Review code

## Sponsorship

This project is sponsored by **[DataBooth](https://www.databooth.com.au)** — Data analytics consulting for medium-sized businesses.

DataBooth transforms raw data into actionable strategies that drive growth, reduce costs, and manage emerging risks. Bringing risk expertise refined through quantitative finance, regulatory roles (APRA/ASIC), and hands-on AI development to help organisations make informed, data-driven decisions.

*Need help with data analytics, risk management, or evaluating Mojo for your infrastructure? [Let's talk](https://www.databooth.com.au/about/).*

## Acknowledgments

This project builds on excellent prior work:

- **[python-dotenv](https://github.com/theskumar/python-dotenv)** by Saurabh Kumar - Reference implementation and compatibility target. We validate against python-dotenv 1.2.1 and maintain 98%+ compatibility.
- **[mojoenv](https://github.com/itsdevcoffee/mojoenv)** by itsdevcoffee - Pioneer of `.env` support in Mojo (2023). Inspired this modern rewrite.
- **Modular Team** - For creating the Mojo programming language

See **[CREDITS.md](CREDITS.md)** for detailed acknowledgments and project history.

## License

MIT License - See [LICENSE](LICENSE) for details.

## Links

- [GitHub Repository](https://github.com/databooth/mojo-dotenv)
- [Project Plan](PLAN.md)
- [Mojo Documentation](https://docs.modular.com/mojo/)
