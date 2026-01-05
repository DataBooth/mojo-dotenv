# Awesome Mojo Submission

## For awesome-mojo Lists

### Entry for Libraries Section

```markdown
### Configuration & Environment

- [mojo-dotenv](https://github.com/databooth/mojo-dotenv) - Load environment variables from `.env` files. 95%+ compatible with python-dotenv. Modern Mojo implementation with comprehensive tests.
```

### Alternative (if separate category)

```markdown
- **[mojo-dotenv](https://github.com/databooth/mojo-dotenv)** - `.env` file parser and loader for Mojo. Parse environment variables from files, load into environment, 95%+ python-dotenv compatible. Includes pixi development setup and comprehensive test suite.
```

## PR Details

**Title**: Add mojo-dotenv - .env file loader for Mojo

**Description**:
```
## mojo-dotenv

A modern `.env` file parser and loader for Mojo, compatible with python-dotenv.

**Features:**
- ✅ Parse .env files to Dict (`dotenv_values()`)
- ✅ Load variables into environment (`load_dotenv()`)
- ✅ 95%+ compatible with python-dotenv
- ✅ Comprehensive test suite with Python interop validation
- ✅ Modern Mojo 0.26.x syntax
- ✅ Multiple installation methods (git submodule, .mojopkg)

**Status:** Phase 1 & 2 Complete - MVP functional and production-ready

**Repository:** https://github.com/databooth/mojo-dotenv
**License:** Apache 2.0

This fills a gap in the Mojo ecosystem for configuration management following 12-factor app methodology.
```

## Submission Commands

### For mojicians/awesome-mojo

```bash
# Fork the repo
gh repo fork mojicians/awesome-mojo --clone

cd awesome-mojo

# Create branch
git checkout -b add-mojo-dotenv

# Edit README.md - add entry under appropriate section
# (Libraries > Configuration or similar)

# Commit
git add README.md
git commit -m "Add mojo-dotenv - .env file loader

- Modern .env file parser and loader for Mojo
- 95%+ compatible with python-dotenv
- Comprehensive tests and documentation
- Apache 2.0 licensed"

# Push and create PR
git push origin add-mojo-dotenv
gh pr create --title "Add mojo-dotenv - .env file loader for Mojo" --body "$(cat <<'EOF'
## mojo-dotenv

A modern `.env` file parser and loader for Mojo, compatible with python-dotenv.

**Features:**
- Parse .env files to Dict
- Load variables into environment
- 95%+ compatible with python-dotenv
- Comprehensive test suite
- Modern Mojo 0.26.x

**Repository:** https://github.com/databooth/mojo-dotenv
**License:** Apache 2.0

Fills a gap in Mojo ecosystem for configuration management.
EOF
)"
```

### For ego/awesome-mojo

Same process, different repo:
```bash
gh repo fork ego/awesome-mojo --clone
cd awesome-mojo
# Follow same steps as above
```

## Notes

- Both lists have slightly different structures - adjust placement accordingly
- Check existing entries for formatting consistency
- Include key differentiators: python-dotenv compatibility, modern Mojo syntax
- Mention it supersedes abandoned mojoenv (2023)
