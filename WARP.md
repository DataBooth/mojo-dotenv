# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

mojo-dotenv is a modern `.env` file parser and loader for Mojo, compatible with Mojo 2025/2026. It provides near-100% python-dotenv compatibility (v1.2.1) and follows the 12-factor app methodology for configuration management.

**Key Stats:**
- v0.2.1 - Production-ready with 98%+ python-dotenv compatibility
- 49 tests across 11 test files
- Core modules: parser, loader, finder

## Development Commands

### Testing
```bash
# Run all tests (recommended for validation)
pixi run test-all

# Individual test suites (for quick iteration)
pixi run test-basic        # Basic parsing functionality
pixi run test-escapes      # Escape sequence handling
pixi run test-export       # Export prefix support
pixi run test-load         # Environment loading
pixi run test-multiline    # Multiline value handling
pixi run test-variables    # Variable expansion
pixi run test-phase3plus   # Advanced features
pixi run test-override     # Override behaviour
pixi run test-helpers      # Helper functions
pixi run test-compat       # Python compatibility validation
pixi run test-missing      # Missing file handling
```

### Building
```bash
# Build .mojopkg package
pixi run build-package

# Clean build artifacts
pixi run clean
```

### Examples
```bash
# Run simple example
pixi run example-simple

# Check Mojo version
pixi run mojo-version
```

### Running Code
All Mojo files must be run with the `-I src` flag to include the dotenv package:
```bash
mojo -I src your_file.mojo
```

## Code Architecture

### Module Structure
The package follows a clean separation of concerns:

**src/dotenv/__init__.mojo**: Public API
- Exports: `dotenv_values()`, `load_dotenv()`, `find_dotenv()`
- `dotenv_values()`: Parses .env files without modifying environment
- `load_dotenv()`: Loads variables into environment
- `find_dotenv()`: Searches parent directories for .env files

**src/dotenv/parser.mojo**: Core parsing engine
- `parse_dotenv()`: Main parsing function - handles .env format
- `expand_variables()`: Variable expansion (`${VAR}` and `$VAR` syntax)
- `process_escapes()`: Escape sequence processing (`\n`, `\t`, `\\`, `\"`, `\'`)
- `strip_inline_comment()`: Removes comments outside quotes
- Quote handling: Supports single (`'`), double (`"`) quotes and multiline values
- Export prefix: Automatically strips `export` keyword

**src/dotenv/loader.mojo**: Environment variable management
- `load_dotenv()`: Loads parsed variables into `os.environ`
- Default behaviour: Does NOT override existing environment variables
- Override mode: Set `override=True` to replace existing values
- Returns Bool indicating success/failure

**src/dotenv/finder.mojo**: File discovery
- `find_dotenv()`: Searches up directory tree for .env files
- Traverses up to 20 parent directories
- Optional error raising if file not found
- Returns absolute path or empty string

### Parsing Logic Flow
1. Read file content via `Path.read_text()`
2. Split into lines, handling multiline quoted strings
3. For each line:
   - Strip inline comments (preserving quoted content)
   - Parse key=value pairs
   - Handle export prefix
   - Strip quotes
   - Process escape sequences (in quoted strings only)
   - Expand variable references
4. Return `Dict[String, String]`

### Variable Expansion
Supports two syntaxes with cascading lookup:
- `${VAR}` - Braced form (preferred)
- `$VAR` - Simple form

Lookup order:
1. Previously parsed variables from same .env file
2. System environment variables
3. Fallback to literal string if not found

### Key Design Decisions
- **Empty string for missing keys**: Mojo's `getenv()` returns `""` for missing variables (Python returns `None`)
- **Override default is False**: Matches python-dotenv - existing env vars preserved by default
- **Quote stripping**: Both single and double quotes are removed from values
- **Escape processing**: Only applies to quoted strings (not bare values)
- **Comment handling**: Full-line and inline comments supported, respecting quotes

## Testing Strategy

### Test Organisation
Tests use Mojo's built-in `testing` module with `TestSuite` and assertions:
- Each test file covers a specific feature area
- Uses fixture files in `tests/fixtures/`
- Comprehensive coverage of edge cases

### Python Compatibility Validation
The project maintains 98%+ compatibility with python-dotenv 1.2.1:
- `test_python_compat.mojo` validates behaviour against python-dotenv
- Known difference: Mojo's `getenv()` returns `""` vs Python's `None`
- All parsing and loading behaviour matches python-dotenv exactly

### When Adding Features
1. Add test cases first (TDD approach)
2. Run relevant individual test for quick iteration: `pixi run test-<name>`
3. Validate full suite before committing: `pixi run test-all`
4. Check python-dotenv compatibility if relevant

## Important Constraints

### Mojo Version Compatibility
- Requires Mojo >=0.26.1 (specified in pixi.toml)
- Uses modern Mojo syntax (2025/2026)
- Dependencies managed via pixi (not pip/conda directly)

### .env File Format Support
Fully supports:
- `KEY=value` pairs
- Comments (`#` full-line and inline)
- Quotes (`"value"`, `'value'`)
- Export prefix (`export KEY=value`)
- Variable expansion (`${VAR}`, `$VAR`)
- Multiline values (quoted strings spanning lines)
- Escape sequences (`\n`, `\t`, `\\`, `\"`, `\'`)
- Keys without values (returns empty string)

Not supported (by design):
- Command substitution (use dotenvx for this)
- Multiple .env files with precedence (planned for v0.3.0)
- Stream input (planned for v0.3.0)

### Project Management
- Uses `pixi` for all dependency and task management
- No direct use of `mojo package` command (use `pixi run build-package`)
- Git branching workflow preferred for features and fixes
- Commit messages should be complete yet succinct

## Documentation References

Key documentation files:
- **PLAN.md**: Detailed project roadmap and development phases
- **CREDITS.md**: Acknowledgements and project history
- **docs/DISTRIBUTION.md**: Packaging and distribution guide
- **docs/RESEARCH.md**: python-dotenv API analysis
- **docs/MOJOENV_COMPATIBILITY_ANALYSIS.md**: Comparison with original mojoenv

Blog post: [Building mojo-dotenv](https://www.databooth.com.au/posts/mojo/building-mojo-dotenv/) - Lessons from building the package

## Contributing Guidelines

When modifying code:
- Use Australian English for all documentation and comments (prefer US spelling for code identifiers)
- Maintain python-dotenv compatibility - validate against `test_python_compat.mojo`
- Follow existing code style and patterns in the codebase
- Update tests alongside code changes
- Run `pixi run test-all` before committing

When fixing bugs:
- Check if python-dotenv has the same behaviour
- Add regression test case
- Update CHANGELOG.md

When adding features:
- Consult PLAN.md for roadmap alignment
- Reference python-dotenv implementation if applicable
- Add comprehensive tests
- Update README.md API documentation
