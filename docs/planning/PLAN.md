# mojo-dotenv Project Plan

A modern `.env` file parser and loader for Mojo 🔥, compatible with Mojo 2025/2026.

## 📋 Project Overview

**Goal:** Create a production-ready dotenv library for Mojo that loads environment variables from `.env` files, following the 12-factor app methodology.

**Inspiration:** This project is inspired by [mojoenv](https://github.com/itsdevcoffee/mojoenv) by itsdevcoffee. However, mojoenv was built for Mojo in 2023 and is no longer compatible with modern Mojo. This is a complete rewrite using current Mojo patterns and stdlib.

## 🎯 Goals

1. **Compatibility:** Work with latest Mojo (2025/2026)
2. **Correctness:** Validate against python-dotenv behaviour
3. **Simplicity:** Clean API, easy to use
4. **Educational:** Well-documented, good learning resource
5. **Production-ready:** Proper error handling, edge cases covered

## 📦 Project Structure

```
mojo-dotenv/
├── src/
│   └── dotenv/
│       ├── __init__.mojo          # Public API
│       ├── parser.mojo            # Core parsing logic
│       ├── loader.mojo            # Environment loading
│       └── errors.mojo            # Error types
├── tests/
│   ├── test_basic.mojo            # Basic functionality tests
│   ├── test_quotes.mojo           # Quote handling tests
│   ├── test_comments.mojo         # Comment handling tests
│   ├── test_python_compat.mojo    # Validate vs python-dotenv
│   └── fixtures/
│       ├── basic.env
│       ├── quotes.env
│       ├── comments.env
│       ├── multiline.env
│       └── expansion.env
├── examples/
│   ├── simple.mojo                # Basic usage
│   ├── custom_path.mojo           # Custom .env path
│   └── no_override.mojo           # Don't override existing vars
├── docs/
│   ├── API.md                     # API documentation
│   ├── FEATURES.md                # Feature support matrix
│   └── COMPARISON.md              # vs python-dotenv, mojoenv
├── README.md
├── PLAN.md                        # This file
├── LICENSE                        # Apache 2.0
├── .gitignore
└── pixi.toml                      # Package management
```

## 🚀 Development Phases

### Phase 0: Research & Validation (CURRENT)

**Tasks:**
- [x] Research existing solutions (mojoenv)
- [ ] Clone and test mojoenv compatibility
- [ ] Document Mojo package management state
- [ ] Review python-dotenv API for reference
- [ ] Set up development environment

**Deliverables:**
- This PLAN.md document
- Validation results from mojoenv test
- Package management documentation

### Phase 1: MVP Implementation (v0.1.0)

**Features:**
- Parse simple `KEY=value` pairs
- Handle comments (lines starting with `#`)
- Handle basic quotes (`"value"`, `'value'`)
- Strip leading/trailing whitespace
- Load into `os.environ`
- Return `Dict[String, String]`

**API:**
```mojo
from dotenv import load_dotenv, dotenv_values

# Load into environment
load_dotenv()  # Load from .env
load_dotenv(".env.local")  # Custom path
load_dotenv(override=False)  # Don't override existing vars

# Get as dict without loading
var config = dotenv_values(".env")
var db_url = config["DATABASE_URL"]
```

**Tasks:**
- [ ] Implement `parser.mojo` - basic parsing
- [ ] Implement `loader.mojo` - environment loading
- [ ] Implement `__init__.mojo` - public API
- [ ] Create basic tests
- [ ] Create examples
- [ ] Write README

**Success Criteria:**
- Parses simple .env files correctly
- Loads into environment successfully
- Tests pass
- Examples run without errors

### Phase 2: Python Compatibility Testing (v0.1.1)

**Tasks:**
- [ ] Set up python-dotenv for comparison
- [ ] Create comprehensive test fixtures
- [ ] Implement compatibility tests
- [ ] Document differences
- [ ] Fix any discovered bugs

**Deliverables:**
- `test_python_compat.mojo`
- Test fixtures that work in both
- `COMPARISON.md` documenting differences

### Phase 3: Advanced Features (v0.2.0)

**Features:**
- Variable expansion: `PATH=${HOME}/bin`
- Multiline values (with `\` continuation)
- Basic escape sequences: `\n`, `\t`, `\\`, `\"`
- Multiple .env files (`.env`, `.env.local`, etc.)
- Export prefix support: `export KEY=value`

**Tasks:**
- [ ] Implement variable expansion
- [ ] Implement multiline support
- [ ] Implement escape sequences
- [ ] Add multi-file loading
- [ ] Update tests
- [ ] Update documentation

### Phase 4: Production Hardening (v0.3.0)

**Features:**
- Comprehensive error handling
- Validation and warnings
- Performance optimization
- Memory safety audit
- Security review

**Tasks:**
- [ ] Add detailed error messages
- [ ] Implement validation
- [ ] Profile and optimize
- [ ] Security audit
- [ ] Edge case testing
- [ ] Fuzzing tests

### Phase 5: Distribution (v1.0.0)

**Tasks:**
- [ ] Package as `.mojopkg`
- [ ] Publish to Mojo package registry (when available)
- [ ] Create release notes
- [ ] Announce on Discord/forums
- [ ] Write blog post/tutorial

## 📊 Feature Support Matrix

| Feature | v0.1.0 | v0.2.0 | v0.3.0 | python-dotenv | Notes |
|---------|--------|--------|--------|---------------|-------|
| `KEY=value` | ✅ | ✅ | ✅ | ✅ | Basic parsing |
| Comments (`#`) | ✅ | ✅ | ✅ | ✅ | Ignore comment lines |
| Quotes (`"`, `'`) | ✅ | ✅ | ✅ | ✅ | Strip quotes |
| Whitespace stripping | ✅ | ✅ | ✅ | ✅ | Trim spaces |
| Empty lines | ✅ | ✅ | ✅ | ✅ | Ignore |
| `export KEY=value` | ❌ | ✅ | ✅ | ✅ | Optional prefix |
| Variable expansion | ❌ | ✅ | ✅ | ❌ | `${VAR}` syntax |
| Multiline values | ❌ | ✅ | ✅ | ✅ | With `\` continuation |
| Escape sequences | ❌ | ✅ | ✅ | ✅ | `\n`, `\t`, etc. |
| Inline comments | ❌ | ❌ | ✅ | ✅ | `KEY=value # comment` |
| Command substitution | ❌ | ❌ | ❌ | ❌ | Use dotenvx instead |

## 🧪 Testing Strategy

### Unit Tests
- Parser tests: Each parsing rule independently
- Loader tests: Environment manipulation
- Error handling: Invalid input

### Integration Tests
- End-to-end: Load actual .env files
- Python compatibility: Compare with python-dotenv
- Edge cases: Malformed files, special characters

### Test Fixtures
Create .env files covering:
- Basic key=value pairs
- All quote styles
- Comments (inline and full-line)
- Empty lines and whitespace
- Special characters
- Unicode
- Very long lines
- Malformed syntax

## 📝 API Design

### Public API (`__init__.mojo`)

```mojo
fn load_dotenv(
    dotenv_path: String = ".env",
    override: Bool = True,
) raises -> Dict[String, String]:
    """
    Load .env file into environment.
    
    Args:
        dotenv_path: Path to .env file (default: ".env")
        override: Override existing environment variables (default: True)
    
    Returns:
        Dictionary of loaded variables
    
    Raises:
        Error: If file cannot be read or parsed
    """

fn dotenv_values(
    dotenv_path: String = ".env",
) raises -> Dict[String, String]:
    """
    Parse .env file without loading into environment.
    
    Args:
        dotenv_path: Path to .env file
    
    Returns:
        Dictionary of parsed variables
    
    Raises:
        Error: If file cannot be read or parsed
    """

fn find_dotenv(
    filename: String = ".env",
    raise_error_if_not_found: Bool = False,
) raises -> String:
    """
    Find .env file by searching parent directories.
    
    Args:
        filename: Name of .env file to find
        raise_error_if_not_found: Raise error if not found
    
    Returns:
        Path to found .env file, or empty string
    
    Raises:
        Error: If raise_error_if_not_found and file not found
    """
```

### Internal API

**`parser.mojo`:**
```mojo
fn parse_line(line: String) -> Optional[Tuple[String, String]]:
    """Parse a single line, returning (key, value) or None."""

fn strip_quotes(value: String) -> String:
    """Remove surrounding quotes from value."""

fn expand_variables(value: String, env: Dict[String, String]) -> String:
    """Expand ${VAR} references in value."""
```

**`loader.mojo`:**
```mojo
fn set_env_var(key: String, value: String, override: Bool):
    """Set environment variable if appropriate."""

fn load_env_file(path: String, override: Bool) -> Dict[String, String]:
    """Load and parse .env file."""
```

## 🎓 Learning Goals

This project teaches:
1. **File I/O** - Reading and parsing text files
2. **String manipulation** - Parsing, splitting, trimming
3. **Collections** - Dict usage, iteration
4. **Error handling** - `raises`, custom errors
5. **OS interaction** - Environment variables
6. **Testing** - Unit and integration tests
7. **Python interop** - Using python-dotenv for validation
8. **Packaging** - Creating distributable Mojo packages

## 📚 Resources

### Mojo Documentation
- [Mojo Manual](https://docs.modular.com/mojo/manual/)
- [Mojo Standard Library](https://docs.modular.com/mojo/lib/)
- [Modules and Packages](https://docs.modular.com/mojo/manual/packages/)

### Reference Implementations
- [python-dotenv](https://github.com/theskumar/python-dotenv) - Python reference
- [dotenv (Node.js)](https://github.com/motdotla/dotenv) - JavaScript reference
- [godotenv](https://github.com/joho/godotenv) - Go reference
- [mojoenv](https://github.com/itsdevcoffee/mojoenv) - Original Mojo attempt (2023)

### Specifications
- [12-Factor App: Config](https://12factor.net/config)
- [.env file format](https://hexdocs.pm/dotenvy/dotenv-file-format.html)

## 🤝 Collaboration

This project is open source (Apache 2.0). Contributions welcome!

### Ways to Contribute
- Report bugs or request features
- Improve documentation
- Add test cases
- Implement features
- Review code

### Acknowledgments
- **itsdevcoffee** - Original mojoenv author, pioneered .env in Mojo
- **Modular** - For creating Mojo
- **python-dotenv** - Reference implementation

## 🗓️ Timeline Estimate

- **Phase 0 (Research):** 1-2 days
- **Phase 1 (MVP):** 3-5 days
- **Phase 2 (Testing):** 2-3 days
- **Phase 3 (Advanced):** 5-7 days
- **Phase 4 (Hardening):** 3-5 days
- **Phase 5 (Distribution):** 2-3 days

**Total:** ~3-4 weeks of focused work

## 📈 Success Metrics

- [ ] Compiles with latest Mojo
- [ ] Passes all tests
- [ ] 90%+ compatibility with python-dotenv (basic features)
- [ ] Used by at least 3 other projects
- [ ] Documented and easy to understand
- [ ] Performance: Parse 1000 lines in <10ms

## 🚦 Current Status

**Phase:** 0 - Research & Validation
**Next Steps:**
1. Test mojoenv compatibility
2. Document Mojo package management
3. Set up development environment
4. Begin Phase 1 implementation

---

**Last Updated:** 2026-01-05
**Maintainer:** @mjboothaus
