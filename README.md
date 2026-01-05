# mojo-dotenv 🔥

A modern `.env` file parser and loader for Mojo, compatible with Mojo 2025/2026.

> **Status:** ✅ **Phase 1 & 2 Complete** - MVP functional, python-dotenv compatible

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

### Current (v0.1.0 - MVP Complete)
- [x] Parse `KEY=value` pairs
- [x] Handle comments (`#`)
- [x] Handle quotes (`"value"`, `'value'`)
- [x] Strip whitespace
- [x] Load into environment (`load_dotenv()`)
- [x] Return `Dict[String, String]` (`dotenv_values()`)
- [x] 95%+ compatibility with python-dotenv
- [x] Comprehensive test suite with Python interop validation

### Planned (v0.2.0+)
- [ ] Variable expansion (`${VAR}`)
- [ ] Multiline values
- [ ] Escape sequences
- [ ] Multiple .env files
- [ ] Export prefix support

See [PLAN.md](PLAN.md) for detailed roadmap.

## Installation

**Note:** Not yet released. Coming soon!

### Option 1: Source (Development)
```bash
git clone https://github.com/databooth/mojo-dotenv
cd mojo-dotenv
# Use pixi for development
pixi install
```

### Option 2: Compiled Package (Future)
```bash
# Download from releases (not yet available)
curl -L -o dotenv.mojopkg https://github.com/databooth/mojo-dotenv/releases/download/v0.1.0/dotenv.mojopkg
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

#### `dotenv_values(dotenv_path: String) -> Dict[String, String]`

Parse a .env file and return its content as a dictionary. Does NOT modify environment variables.

**Parameters:**
- `dotenv_path`: Path to .env file (absolute or relative)

**Returns:** Dictionary mapping variable names to values

**Example:**
```mojo
var config = dotenv_values("config/.env")
for item in config.items():
    print(item.key, "=", item.value)
```

#### `load_dotenv(dotenv_path: String, override: Bool = False) -> Bool`

Load variables from a .env file into the environment.

**Parameters:**
- `dotenv_path`: Path to .env file
- `override`: If True, override existing environment variables (default: False)

**Returns:** True if successful, False if file not found

**Example:**
```mojo
if load_dotenv(".env"):
    print("Loaded successfully")
```

### .env File Format

Supported syntax:
```bash
# Comments
KEY=value
QUOTED="value"
SINGLE='value'
EMPTY=
SPACES=  value  # whitespace trimmed
KEY_WITH_EQUALS=value=with=equals
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
- [docs/MOJO_PACKAGE_MANAGEMENT.md](docs/MOJO_PACKAGE_MANAGEMENT.md) - Mojo packaging guide
- [docs/API.md](docs/API.md) - API documentation (coming soon)

## Contributing

Contributions welcome! This is an open-source project (Apache 2.0).

### Ways to Contribute
- Report bugs or request features
- Improve documentation
- Add test cases
- Implement features
- Review code

## Acknowledgments

- **itsdevcoffee** - Original mojoenv author, pioneered `.env` in Mojo
- **Modular** - For creating Mojo
- **python-dotenv** - Reference implementation

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details.

## Links

- [GitHub Repository](https://github.com/databooth/mojo-dotenv)
- [Project Plan](PLAN.md)
- [Mojo Documentation](https://docs.modular.com/mojo/)
- [Modular Discord](https://discord.gg/modular)

---

**Status:** Phase 1 & 2 Complete ✅  
**Next:** Phase 3 - Advanced features (variable expansion, multiline values, escape sequences)
