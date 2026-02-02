# mojo-dotenv Roadmap

## Package Distribution

### ✅ Using `noarch: generic`
**Status:** Already implemented

mojo-dotenv ships as a platform-independent package:
- Pure Mojo source code (no binaries)
- Single build works on all platforms
- Faster installs, smaller footprint

See [docs/PLATFORM_BUILDS.md](docs/PLATFORM_BUILDS.md#noarch-packages) for details.

---

## Feature Roadmap

Tracked in main [README.md](README.md):
- Enhanced .env syntax support
- Performance optimizations
- Additional python-dotenv parity

---

## Maintenance

### Recipe Validation
✅ **Completed (2026-01-29)**
- Local validation with rattler-build
- GitHub Actions automation
- Pre-commit hook integration

### Mojo Version Management
✅ **Completed (2026-01-29)**
- Standardized to `mojo_version: "=0.25.7"` context variable

### Testing / Compatibility TODOs
- Clarify in `tests/test_python_compat.mojo` that python-dotenv warnings like "could not parse statement starting at line 6/8" are expected for deliberately malformed fixtures (e.g. `edge_cases.env`).
- Improve missing-file tests in `tests/test_missing_files.mojo` so that expected warning lines are captured/asserted (or clearly labelled as expected) rather than just printed as "Expected output" plus the raw warning.

---

**Last updated:** 2026-02-02
