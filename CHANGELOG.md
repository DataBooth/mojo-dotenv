# Changelog

All notable changes to mojo-dotenv will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned for v0.3.0
- Multiple .env file support with precedence handling
- Stream input support (reading from StringRef/file handles)
- Custom encoding options
- Performance optimizations for large files
- Enhanced error messages with line numbers

## [0.2.1] - 2026-01-06

### Changed
- **Improved missing file handling**: `dotenv_values()` now returns empty dict with WARNING instead of raising error (matches python-dotenv behavior)
- **Better error visibility**: Added WARNING message when .env file not found
- **Updated documentation**: README examples now show proper error handling patterns
- **Added stdlib differences section**: Documented that Mojo's `getenv()` returns empty string vs Python's `None`

### Added
- 7 new tests for missing file scenarios (total: 49 tests across 11 test files)
- Examples showing safe key access with `dict.get(key, default)`
- Side-by-side Python/Mojo comparison in documentation

### Fixed
- README examples that would crash on missing files or keys
- Test expectations to match new graceful error handling

## [0.2.0] - 2026-01-05

### Added - Phase 3+ Complete ✅

**Advanced Features:**
- Variable expansion with `${VAR}` and `$VAR` syntax
- Two-pass parsing: parse lines first, then expand variables
- System environment fallback for undefined variables
- Multiline values (quoted strings spanning multiple lines)
- Proper quote state tracking across line boundaries
- Escape sequences in quoted strings: `\n`, `\t`, `\\`, `\"`, `\'`
- Inline comment handling with quote-awareness
- Export prefix support (`export KEY=value` stripped automatically)
- Keys without `=` return empty string (Mojo Dict limitation)
- Verbose mode on all APIs (`verbose: Bool` parameter)
- `find_dotenv()` function for automatic .env discovery (up to 20 parent directories)

**Bug Fixes:**
- Fixed multiline quote detection to properly handle escaped backslashes (e.g., `\\\\` before closing quote)
- Consecutive backslash counting ensures correct quote escape detection

**Testing:**
- 8 comprehensive test files covering all features
- test_export.mojo - export prefix handling
- test_escapes.mojo - escape sequence processing
- test_variables.mojo - variable expansion
- test_multiline.mojo - multiline value parsing
- test_phase3plus.mojo - find_dotenv(), inline comments, verbose mode
- Dynamic test-all task runs all test_*.mojo files automatically

**Compatibility:**
- 98%+ feature parity with python-dotenv
- All Phase 3+ features implemented
- Near-100% compatibility achieved

### Known Differences from python-dotenv
1. **Keys without `=`**: Returns `""` instead of `None` (Mojo Dict limitation documented)
2. **Stream input**: Not supported (file paths only)
3. **Encoding parameter**: UTF-8 only (Mojo default)

## [0.1.0] - 2026-01-05

### Added - Phase 1 & 2 Complete ✅

**Core Functionality:**
- `dotenv_values(dotenv_path)` - Parse .env files to Dict
- `load_dotenv(dotenv_path, override)` - Load variables into environment
- Support for `KEY=value` format
- Comment handling (lines starting with `#`)
- Quote handling (single `'` and double `"` quotes)
- Whitespace trimming (keys and values)
- Empty value support (`KEY=` → empty string)
- Values with equals signs (`KEY=value=with=equals`)

**Testing:**
- Comprehensive test suite (basic, quotes, comments, whitespace, edge cases)
- Python interop compatibility testing against python-dotenv 1.2.1
- 95%+ compatibility achieved (21/22 test cases match)
- Example application demonstrating both APIs

**Documentation:**
- Complete README with API reference and usage examples
- PLAN.md with detailed roadmap through Phase 5
- CREDITS.md acknowledging python-dotenv and mojoenv
- DISTRIBUTION.md with packaging and installation guide
- MOJO_PACKAGE_MANAGEMENT.md explaining Mojo packaging ecosystem
- RESEARCH.md with python-dotenv API analysis
- MOJOENV_COMPATIBILITY_ANALYSIS.md documenting migration path

**Infrastructure:**
- pixi development environment
- Build task for creating .mojopkg packages
- Multiple test tasks (test, test-compat, test-load, test-all)
- Example runner task
- Git commit history with clear messages

**Compatibility:**
- Tested with Mojo 0.26.1.0.dev2026010405
- macOS (Apple Silicon) - fully tested
- Modern Mojo syntax (StringSlice handling, ownership transfers)

### Known Limitations
- No variable expansion yet (Phase 3)
- No multiline value support yet (Phase 3)
- No `find_dotenv()` yet (Phase 4)
- More lenient than python-dotenv with unclosed quotes
- Keys without `=` are skipped (python-dotenv returns None value)
- .mojopkg format not portable across Mojo versions

### Differences from python-dotenv
1. **More lenient**: Accepts unclosed quotes (e.g., `KEY="value` without closing quote)
2. **Skips invalid lines**: Keys without `=` are ignored instead of returning None value
3. **Simpler override behaviour**: No check for existing env vars when override=False (sets unconditionally)

### Migration from mojoenv
- API change: `load_mojo_env()` → `load_dotenv()`
- Import change: `from mojoenv import` → `from dotenv import`
- Compatible with modern Mojo (mojoenv requires 2023-era Mojo)
- See MOJOENV_COMPATIBILITY_ANALYSIS.md for details

## [0.0.0] - 2026-01-04

### Research & Setup (Phase 0)
- Validated mojoenv incompatibility with modern Mojo
- Set up pixi development environment
- Created project structure
- Analyzed python-dotenv API and behaviour
- Created test fixtures
- Documented Mojo package management landscape

---

## Release Checklist

Before tagging a release:

- [ ] Update version in README.md
- [ ] Update this CHANGELOG.md
- [ ] Run full test suite: `pixi run test-all`
- [ ] Update PLAN.md if scope changed
- [ ] Build package: `pixi run build`
- [ ] Test package can be imported
- [ ] Create git tag: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
- [ ] Push tag: `git push origin vX.Y.Z`
- [ ] Create GitHub release with CHANGELOG excerpt
- [ ] (Optional) Upload .mojopkg to GitHub release with Mojo version note

## Version History

- **v0.2.1** (2026-01-06): Improved error handling - graceful missing file behavior
- **v0.2.0** (2026-01-05): Phase 3+ complete - Advanced features, near-100% python-dotenv compatibility
- **v0.1.0** (2026-01-05): Phase 1 & 2 MVP complete
- **v0.0.0** (2026-01-04): Phase 0 research & setup

---

**Links:**
- [GitHub Releases](https://github.com/databooth/mojo-dotenv/releases)
- [Project Plan](PLAN.md)
- [Distribution Guide](docs/DISTRIBUTION.md)
