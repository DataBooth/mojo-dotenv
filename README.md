# mojo-dotenv 🔥

A modern `.env` file parser and loader for Mojo, compatible with Mojo 2025/2026.

> **Status:** ✅ **Phase 3+ Complete** - Advanced features, near-100% python-dotenv compatibility

## Overview

`mojo-dotenv` loads environment variables from `.env` files into your Mojo applications, following the [12-factor app](https://12factor.net/config) methodology.

```mojo
from dotenv import load_dotenv, dotenv_values
from os import getenv

fn main() raises:
    # Option 1: Load .env file into environment
    _ = load_dotenv(".env")
    var db_url = getenv("DATABASE_URL")
    print("Connecting to:", db_url)
    
    # Option 2: Parse without modifying environment
    var config = dotenv_values(".env")
    print("Port:", config["PORT"])
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
- [x] Comprehensive test suite (8 test files)

### Planned (v0.3.0+)
- [ ] Multiple .env files with precedence
- [ ] Stream input support
- [ ] Custom encoding options

See [PLAN.md](PLAN.md) for detailed roadmap.

## Installation

**Recommended**: Source inclusion via git submodule or direct copy.

See **[docs/DISTRIBUTION.md](docs/DISTRIBUTION.md)** for complete installation options and packaging guide.

### Quick Start (Git Submodule)
```bash
# Add to your project
cd your-project
git submodule add https://github.com/databooth/mojo-dotenv vendor/mojo-dotenv

# Use in your code
mojo -I vendor/mojo-dotenv/src your_app.mojo
```

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
    print(config["DATABASE_URL"])
    
    # Load .env file and set environment variables
    _ = load_dotenv(".env")
    print(getenv("API_KEY"))
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
for item in config.items():
    print(item.key, "=", item.value)
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
- [docs/DISTRIBUTION.md](docs/DISTRIBUTION.md) - **Packaging and distribution guide**
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

- **[python-dotenv](https://github.com/theskumar/python-dotenv)** by Saurabh Kumar - Reference implementation and compatibility target. We validate against python-dotenv 1.2.1 and maintain 95%+ compatibility.
- **[mojoenv](https://github.com/itsdevcoffee/mojoenv)** by itsdevcoffee - Pioneer of `.env` support in Mojo (2023). Inspired this modern rewrite.
- **Modular Team** - For creating the Mojo programming language

See **[CREDITS.md](CREDITS.md)** for detailed acknowledgments and project history.

## License

MIT License - See [LICENSE](LICENSE) for details.

## Links

- [GitHub Repository](https://github.com/databooth/mojo-dotenv)
- [Project Plan](PLAN.md)
- [Mojo Documentation](https://docs.modular.com/mojo/)
- [Modular Discord](https://discord.gg/modular)

---

**Status:** Phase 1 & 2 Complete ✅  
**Next:** Phase 3 - Advanced features (variable expansion, multiline values, escape sequences)
