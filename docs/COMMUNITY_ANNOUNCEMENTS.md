# Community Announcements

## Modular Forum (forum.modular.com)

### Category: Community Showcase

**Title**: mojo-dotenv v0.2.0 - Load .env files in Mojo (98%+ python-dotenv compatible)

**Post**:

```markdown
# mojo-dotenv 🔥

I'm excited to share **mojo-dotenv v0.2.0** - a modern `.env` file parser and loader for Mojo!

## What is it?

Load environment variables from `.env` files into your Mojo applications, following the [12-factor app](https://12factor.net/config) methodology.

```mojo
from dotenv import load_dotenv, dotenv_values, find_dotenv
from os import getenv

fn main() raises:
    # Option 1: Load into environment
    _ = load_dotenv(".env")
    print(getenv("DATABASE_URL"))
    
    # Option 2: Parse to Dict
    var config = dotenv_values(".env")
    print(config["API_KEY"])
    
    # Option 3: Auto-discover .env file
    var env_path = find_dotenv()
    _ = load_dotenv(env_path)
```

## Features

✅ **Parse .env files** - `dotenv_values()` returns `Dict[String, String]`  
✅ **Load into environment** - `load_dotenv()` sets environment variables  
✅ **Variable expansion** - `${VAR}` and `$VAR` syntax supported  
✅ **Multiline values** - Quoted strings can span multiple lines  
✅ **Escape sequences** - `\n`, `\t`, `\"`, `\\`, `\'` in quoted strings  
✅ **Auto-discovery** - `find_dotenv()` searches parent directories  
✅ **98%+ python-dotenv compatible** - Validated with comprehensive test suite  
✅ **Modern Mojo** - Built for Mojo 2025/2026 with latest syntax  
✅ **42 comprehensive tests** - Using Mojo's TestSuite framework  
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

**Production-ready** ✅ - Near-100% python-dotenv compatibility with advanced features

**Repository**: https://github.com/databooth/mojo-dotenv  
**Blog post**: https://www.databooth.com.au/posts/mojo/building-mojo-dotenv/  
**License**: MIT License

## Installation

**Quick start (Git submodule):**
```bash
git submodule add https://github.com/databooth/mojo-dotenv vendor/mojo-dotenv
mojo -I vendor/mojo-dotenv/src your_app.mojo
```

See [distribution guide](https://github.com/databooth/mojo-dotenv/blob/main/docs/DISTRIBUTION.md) for other methods.

## What's Next?

Future enhancements:
- Multiple .env files with precedence
- Stream input support
- Custom encoding options

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
🔥 **mojo-dotenv v0.2.0** - Load .env files in Mojo!

Just released v0.2.0 - a modern .env parser/loader for Mojo, 98%+ compatible with python-dotenv.

```mojo
from dotenv import load_dotenv, find_dotenv
var env_path = find_dotenv()  # Auto-discover .env
_ = load_dotenv(env_path)
print(os.getenv("DATABASE_URL"))
```

✅ Variable expansion, multiline values, escape sequences
✅ Auto-discovery with `find_dotenv()`
✅ 42 comprehensive tests with TestSuite framework
✅ Modern Mojo 2025/2026

📦 https://github.com/databooth/mojo-dotenv

Built to fill the gap left by mojoenv (2023). Feedback welcome!
```

**Longer version (if allowed):**

```
🎉 **Announcing mojo-dotenv v0.2.0** 🔥

A production-ready `.env` file parser and loader for Mojo with near-100% python-dotenv compatibility!

**What it does:**
Load environment variables from .env files (12-factor app methodology)

**Quick example:**
```mojo
from dotenv import load_dotenv, dotenv_values, find_dotenv
from os import getenv

fn main() raises:
    var env_path = find_dotenv()  # Auto-discover
    _ = load_dotenv(env_path)
    print(getenv("DATABASE_URL"))
```

**Highlights:**
✅ 98%+ python-dotenv compatible (42 comprehensive tests)
✅ Variable expansion (`${VAR}` and `$VAR` syntax)
✅ Multiline values and escape sequences (`\n`, `\t`, etc.)
✅ `find_dotenv()` - automatic .env file discovery
✅ `dotenv_values()` - parse to Dict, `load_dotenv()` - set environment
✅ Modern Mojo 2025/2026 syntax
✅ Mojo's TestSuite framework for all tests

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
**Blog post:** https://www.databooth.com.au/posts/mojo/building-mojo-dotenv/  
**License:** MIT License  
**Status:** Production-ready with advanced features

PRs and feedback welcome! 🚀
```

---

## Social Media (Optional)

### Twitter/X

```
🔥 Just released mojo-dotenv v0.2.0!

Load .env files in @Modular_AI Mojo - 98%+ compatible with python-dotenv

✅ Variable expansion (${VAR})
✅ Multiline values & escape sequences
✅ Auto-discovery with find_dotenv()
✅ 42 tests with TestSuite
✅ Modern Mojo 2025/2026

📦 https://github.com/databooth/mojo-dotenv  
📝 https://www.databooth.com.au/posts/mojo/building-mojo-dotenv/

#MojoLang #ModularML
```

### LinkedIn

```
Excited to share mojo-dotenv v0.2.0 🔥

A production-ready .env file parser and loader for Modular's Mojo programming language with near-100% python-dotenv compatibility.

Key features:
• 98%+ compatible with python-dotenv
• Variable expansion (${VAR} and $VAR syntax)
• Multiline values and escape sequences (\n, \t, etc.)
• Auto-discovery with find_dotenv()
• Parse .env files to Dict or load into environment
• 42 comprehensive tests using Mojo's TestSuite framework
• Modern Mojo 2025/2026 implementation

This fills a gap in the Mojo ecosystem for configuration management following the 12-factor app methodology.

Built on the excellent work of python-dotenv (Saurabh Kumar) and mojoenv (itsdevcoffee).

MIT License, contributions welcome!

Repository: https://github.com/databooth/mojo-dotenv

#Mojo #Modular #OpenSource #ProgrammingLanguages
```

---

## Response to Common Questions

**Q: Why not update mojoenv?**
A: mojoenv was built for Mojo in 2023 and requires significant refactoring due to language evolution (List syntax, inout→mut, trait conformance, .mojopkg format). A modern rewrite with current best practices and comprehensive testing was more appropriate. Full analysis in repo.

**Q: What's different from python-dotenv?**
A: 98%+ compatible! Minor differences: more lenient with unclosed quotes, keys without `=` return empty string instead of None. Documented in CHANGELOG.

**Q: Production ready?**
A: Yes! Full-featured with variable expansion, multiline values, escape sequences, and auto-discovery.

**Q: Package manager support?**
A: Currently git submodule or source copy recommended. .mojopkg available but not portable across Mojo versions. Will integrate with official package registry when available.

**Q: How to contribute?**
A: Issues and PRs welcome! See CONTRIBUTING.md (coming soon) or open an issue to discuss.
