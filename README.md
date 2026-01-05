# mojo-dotenv 🔥

A modern `.env` file parser and loader for Mojo, compatible with Mojo 2025/2026.

> **Status:** 🚧 **Under Development** - Phase 0 (Research & Validation)

## Overview

`mojo-dotenv` loads environment variables from `.env` files into your Mojo applications, following the [12-factor app](https://12factor.net/config) methodology.

```mojo
from dotenv import load_dotenv

def main():
    # Load .env file
    load_dotenv()
    
    # Access environment variables
    from os import getenv
    var db_url = getenv("DATABASE_URL")
    print("Connecting to:", db_url)
```

## Motivation

This project was inspired by [mojoenv](https://github.com/itsdevcoffee/mojoenv) by itsdevcoffee, which pioneered `.env` support in Mojo. However, mojoenv was built for Mojo in 2023 and is no longer compatible with modern Mojo syntax and stdlib.

`mojo-dotenv` is a complete rewrite using current Mojo patterns (2025/2026), with:
- ✅ Modern Mojo syntax and stdlib
- ✅ Comprehensive tests against python-dotenv
- ✅ Clear documentation and examples
- ✅ Production-ready error handling

## Features

### Current (v0.1.0 - In Development)
- [ ] Parse `KEY=value` pairs
- [ ] Handle comments (`#`)
- [ ] Handle quotes (`"value"`, `'value'`)
- [ ] Strip whitespace
- [ ] Load into `os.environ`
- [ ] Return `Dict[String, String]`

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

**Coming soon** - API under development. See [PLAN.md](PLAN.md) for proposed API.

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

# Run tests (once implemented)
pixi run test
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

**Status:** Phase 0 - Research & Validation  
**Next:** Test mojoenv compatibility, document package management, begin MVP implementation
