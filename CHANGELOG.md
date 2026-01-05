# Changelog

All notable changes to mojo-dotenv will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned for v0.2.0 (Phase 3)
- Variable expansion (`${VAR}` and `$VAR`)
- Multiline values (quoted strings spanning multiple lines)
- Escape sequences (`\n`, `\t`, `\"`, `\\`)
- Inline comments (`KEY=value # comment`)
- Support for keys without `=` (return as None value)

### Planned for v0.3.0 (Phase 4)
- `find_dotenv()` - automatic .env file discovery
- Multiple .env file support
- Export prefix support
- Performance optimizations
- Enhanced error messages
- Logging/verbose mode

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

- **v0.1.0** (2026-01-05): Phase 1 & 2 MVP complete
- **v0.0.0** (2026-01-04): Phase 0 research & setup

---

**Links:**
- [GitHub Releases](https://github.com/databooth/mojo-dotenv/releases)
- [Project Plan](PLAN.md)
- [Distribution Guide](docs/DISTRIBUTION.md)
