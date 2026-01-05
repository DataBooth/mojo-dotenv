# Community Announcements

## Modular Forum (forum.modular.com)

### Category: Community Showcase

**Title**: mojo-dotenv - Load .env files in Mojo (python-dotenv compatible)

**Post**:

```markdown
# mojo-dotenv 🔥

I'm excited to share **mojo-dotenv** - a modern `.env` file parser and loader for Mojo!

## What is it?

Load environment variables from `.env` files into your Mojo applications, following the [12-factor app](https://12factor.net/config) methodology.

```mojo
from dotenv import load_dotenv, dotenv_values
from os import getenv

fn main() raises:
    # Option 1: Load into environment
    _ = load_dotenv(".env")
    print(getenv("DATABASE_URL"))
    
    # Option 2: Parse to Dict
    var config = dotenv_values(".env")
    print(config["API_KEY"])
```

## Features

✅ **Parse .env files** - `dotenv_values()` returns `Dict[String, String]`  
✅ **Load into environment** - `load_dotenv()` sets environment variables  
✅ **95%+ python-dotenv compatible** - Validated with Python interop tests  
✅ **Modern Mojo** - Built for Mojo 0.26.x with latest syntax  
✅ **Comprehensive tests** - Basic, compatibility, and integration tests  
✅ **Multiple installation methods** - Git submodule, source copy, or .mojopkg

## Why?

- Separate configuration from code
- Different configs for dev/staging/prod
- Keep secrets out of version control
- Standard practice in Python, Node, Ruby ecosystems
- Now available in Mojo!

## Acknowledgments

This project builds on:
- **python-dotenv** - Reference implementation and compatibility target
- **mojoenv** by itsdevcoffee - Pioneer of .env in Mojo (2023), inspired this modern rewrite

## Status

**Phase 1 & 2 Complete** ✅ - MVP functional and production-ready

**Repository**: https://github.com/databooth/mojo-dotenv  
**License**: Apache 2.0

## Installation

**Quick start (Git submodule):**
```bash
git submodule add https://github.com/databooth/mojo-dotenv vendor/mojo-dotenv
mojo -I vendor/mojo-dotenv/src your_app.mojo
```

See [distribution guide](https://github.com/databooth/mojo-dotenv/blob/main/docs/DISTRIBUTION.md) for other methods.

## What's Next?

Phase 3 planned features:
- Variable expansion (`${VAR}`)
- Multiline values
- Escape sequences
- Inline comments

## Feedback Welcome!

This is a community project - PRs, issues, and feedback welcome!

- Repo: https://github.com/databooth/mojo-dotenv
- Issues: https://github.com/databooth/mojo-dotenv/issues

Let me know if you use it in your projects! 🚀
```

---

## Modular Discord

### Channel: #community-packages or #show-and-tell

**Short announcement:**

```
🔥 **mojo-dotenv** - Load .env files in Mojo!

Just released v0.1.0 - a modern .env parser/loader for Mojo, 95%+ compatible with python-dotenv.

```mojo
from dotenv import load_dotenv
_ = load_dotenv(".env")
print(os.getenv("DATABASE_URL"))
```

✅ Parse to Dict or load to environment
✅ Comprehensive tests with Python interop validation
✅ Modern Mojo 0.26.x

📦 https://github.com/databooth/mojo-dotenv

Built to fill the gap left by mojoenv (2023). Feedback welcome!
```

**Longer version (if allowed):**

```
🎉 **Announcing mojo-dotenv v0.1.0** 🔥

A production-ready `.env` file parser and loader for Mojo!

**What it does:**
Load environment variables from .env files (12-factor app methodology)

**Quick example:**
```mojo
from dotenv import load_dotenv, dotenv_values
from os import getenv

fn main() raises:
    _ = load_dotenv(".env")
    print(getenv("DATABASE_URL"))
```

**Highlights:**
✅ 95%+ python-dotenv compatible (validated with Python interop tests)
✅ `dotenv_values()` - parse to Dict
✅ `load_dotenv()` - set environment variables
✅ Modern Mojo 0.26.x syntax
✅ Comprehensive test suite
✅ Multiple installation methods

**Installation:**
Git submodule (recommended):
```bash
git submodule add https://github.com/databooth/mojo-dotenv vendor/mojo-dotenv
mojo -I vendor/mojo-dotenv/src app.mojo
```

Or see distribution guide for other methods.

**Built on great prior work:**
- python-dotenv (reference implementation)
- mojoenv by @itsdevcoffee (inspired this modern rewrite)

**Repository:** https://github.com/databooth/mojo-dotenv
**License:** Apache 2.0
**Status:** Phase 1 & 2 complete, Phase 3 in progress

PRs and feedback welcome! 🚀
```

---

## Social Media (Optional)

### Twitter/X

```
🔥 Just released mojo-dotenv v0.1.0!

Load .env files in @Modular_AI Mojo - 95%+ compatible with python-dotenv

✅ Parse to Dict
✅ Load to environment  
✅ Comprehensive tests
✅ Modern Mojo 0.26.x

📦 https://github.com/databooth/mojo-dotenv

#MojoLang #ModularML
```

### LinkedIn

```
Excited to share mojo-dotenv v0.1.0 🔥

A production-ready .env file parser and loader for Modular's Mojo programming language.

Key features:
• 95%+ compatible with python-dotenv
• Parse .env files to Dict or load into environment
• Comprehensive test suite with Python interop validation
• Modern Mojo 0.26.x implementation

This fills a gap in the Mojo ecosystem for configuration management following the 12-factor app methodology.

Built on the excellent work of python-dotenv (Saurabh Kumar) and mojoenv (itsdevcoffee).

Apache 2.0 licensed, contributions welcome!

Repository: https://github.com/databooth/mojo-dotenv

#Mojo #Modular #OpenSource #ProgrammingLanguages
```

---

## Response to Common Questions

**Q: Why not update mojoenv?**
A: mojoenv was built for Mojo in 2023 and requires significant refactoring due to language evolution (List syntax, inout→mut, trait conformance, .mojopkg format). A modern rewrite with current best practices and comprehensive testing was more appropriate. Full analysis in repo.

**Q: What's different from python-dotenv?**
A: 95%+ compatible! Minor differences: more lenient with unclosed quotes, skips keys without `=` instead of returning None. Documented in CHANGELOG.

**Q: Production ready?**
A: Yes for basic use cases (Phase 1 & 2 complete). Advanced features (variable expansion, multiline values) planned for Phase 3.

**Q: Package manager support?**
A: Currently git submodule or source copy recommended. .mojopkg available but not portable across Mojo versions. Will integrate with official package registry when available.

**Q: How to contribute?**
A: Issues and PRs welcome! See CONTRIBUTING.md (coming soon) or open an issue to discuss.
