# Awesome Mojo Submission

## For awesome-mojo Lists

### Entry for Libraries Section

```markdown
### Configuration & Environment

- [mojo-dotenv](https://github.com/databooth/mojo-dotenv) - Load environment variables from `.env` files. 98%+ compatible with python-dotenv. Features variable expansion, multiline values, escape sequences, and auto-discovery. 42 comprehensive tests.
```

### Alternative (if separate category)

```markdown
- **[mojo-dotenv](https://github.com/databooth/mojo-dotenv)** - Production-ready `.env` file parser and loader for Mojo. Parse to Dict or load into environment. 98%+ python-dotenv compatible with variable expansion, multiline values, escape sequences, and `find_dotenv()` auto-discovery. 42 tests using Mojo's TestSuite framework. MIT License.
```

## PR Details

**Title**: Add mojo-dotenv - .env file loader for Mojo

**Description**:
```
## mojo-dotenv

A production-ready `.env` file parser and loader for Mojo with near-100% python-dotenv compatibility.

**Features:**
- ✅ Parse .env files to Dict (`dotenv_values()`)
- ✅ Load variables into environment (`load_dotenv()`)
- ✅ Variable expansion (`${VAR}` and `$VAR` syntax)
- ✅ Multiline values and escape sequences (`\n`, `\t`, etc.)
- ✅ Auto-discovery with `find_dotenv()`
- ✅ 98%+ compatible with python-dotenv
- ✅ 42 comprehensive tests using Mojo's TestSuite framework
- ✅ Modern Mojo 2025/2026 syntax
- ✅ Multiple installation methods (git submodule, direct copy, .mojopkg)

**Status:** Production-ready - v0.2.0

**Repository:** https://github.com/databooth/mojo-dotenv
**License:** MIT License

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

- Production-ready .env file parser and loader for Mojo
- 98%+ compatible with python-dotenv
- Variable expansion, multiline values, escape sequences
- 42 comprehensive tests with TestSuite framework
- MIT License"

# Push and create PR
git push origin add-mojo-dotenv
gh pr create --title "Add mojo-dotenv - .env file loader for Mojo" --body "$(cat <<'EOF'
## mojo-dotenv v0.2.0

A production-ready `.env` file parser and loader for Mojo with near-100% python-dotenv compatibility.

**Features:**
- Parse .env files to Dict or load into environment
- Variable expansion (${VAR} and $VAR syntax)
- Multiline values and escape sequences
- Auto-discovery with find_dotenv()
- 98%+ compatible with python-dotenv
- 42 comprehensive tests with TestSuite
- Modern Mojo 2025/2026

**Repository:** https://github.com/databooth/mojo-dotenv
**License:** MIT License

Fills a gap in Mojo ecosystem for configuration management following 12-factor app methodology.
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
