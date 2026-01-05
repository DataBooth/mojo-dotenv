# Building mojo-dotenv 🔥: Modern Configuration Management for Mojo

*Bringing the beloved .env pattern to Mojo with near-100% python-dotenv compatibility*

2026-01-05

---

## Why Configuration Matters (Even More in Production)

If you've worked with Python applications, you've likely used `python-dotenv` to manage environment variables. It's the de facto standard for the 12-factor app methodology—keeping configuration separate from code. But as businesses adopt Mojo for high-performance workloads, this foundational tooling needs to come along for the ride.

Enter **mojo-dotenv**: a modern, production-ready `.env` parser and loader for Mojo, achieving 98%+ compatibility with python-dotenv whilst leveraging Mojo's performance advantages.

## The Approach: Standing on Python's Shoulders

### Starting Point: Survey the Landscape

Before writing a single line of code, I surveyed the existing Mojo ecosystem. The community had already produced [mojoenv](https://github.com/itsdevcoffee/mojoenv) by itsdevcoffee—a pioneering effort that brought `.env` support to early Mojo.

However, mojoenv was built for Mojo in 2023. Running it against modern Mojo (2025/2026) revealed four breaking changes:
- `String.unsafe_ptr()` removed
- File reading APIs completely overhauled
- `Dict` constructor signature changed
- Standard library reorganisations

Rather than patching legacy code against a moving target, I made the call: **build fresh, aim for python-dotenv compatibility**.

### The Template: python-dotenv as North Star

Why reinvent the wheel? Python-dotenv has years of production hardening, edge case discovery, and community feedback. It's the reference implementation.

My strategy:
1. **Study python-dotenv's behaviour** — Not just the docs, but actual testing
2. **Implement progressively** — Start simple, add complexity incrementally  
3. **Validate continuously** — Compare Mojo output against Python output

This meant I could skip the "figure out edge cases" phase. Python-dotenv already discovered them. My job: implement in Mojo, verify compatibility.

### Progressive Implementation: Walking Before Running

#### Foundation: Parse `KEY=value`

Started with the absolute basics:
```mojo
# tests/fixtures/basic.env
KEY1=value1
DATABASE_URL=postgresql://localhost/db
PORT=8080
```

Core functions:
- `parse_line()` — Handle a single line
- `dotenv_values()` — Parse entire file to Dict
- `load_dotenv()` — Load into environment

**Key insight:** Mojo's `StringSlice` vs `String` distinction required careful handling. String operations return `StringSlice`, which must be explicitly converted:
```mojo
var stripped = String(line.strip())  // StringSlice -> String
```

#### Validation: Python Interop Testing

Created `test_python_compat.mojo` that loads the same `.env` file in both Mojo and Python, then compares:

```mojo
from python import Python

fn main() raises:
    # Load in Python
    var py_dotenv = Python.import_module("dotenv")
    var py_result = py_dotenv.dotenv_values("tests/fixtures/basic.env")
    
    # Load in Mojo
    var mojo_result = dotenv_values("tests/fixtures/basic.env")
    
    # Compare each key
    for key in expected_keys:
        var py_val = String(py_result[key])
        var mojo_val = mojo_result[key]
        if py_val != mojo_val:
            raise Error("Mismatch on " + key)
```

This interop testing became my continuous validation throughout development. If python-dotenv returned `X`, mojo-dotenv had to return `X`.

#### Layer 2: Quotes, Comments, Whitespace

Added support for:
- Single and double quotes: `QUOTED="value"`, `SINGLE='value'`
- Comments: Lines starting with `#`
- Whitespace trimming: `  KEY  =  value  ` → `KEY=value`

Each addition came with new test fixtures and Python comparison. At this stage: **95%+ compatibility achieved** for basic use cases.

#### Layer 3: Advanced Features

This is where things got interesting. Python-dotenv supports:

**1. Variable expansion:**
```bash
BASE_DIR=/app
LOG_DIR=${BASE_DIR}/logs  # Expands to /app/logs
```

Implementation challenge: Need two-pass parsing. First pass extracts all variables, second pass expands references. Also need to fallback to system environment if variable not found in `.env`.

**2. Multiline values:**
```bash
PRIVATE_KEY="-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAAS
-----END PRIVATE KEY-----"
```

Implementation challenge: Track quote state across lines. A closing quote is only valid if preceded by an even number of backslashes (odd means the quote itself is escaped).

**3. Escape sequences:**
```bash
MESSAGE="Line 1\nLine 2\tTabbed"
```

Implementation challenge: Process escape sequences (`\n`, `\t`, `\\`, `\"`, `\'`) but only within quoted strings. Unquoted values keep backslashes literal.

**4. Export prefix:**
```bash
export DATABASE_URL=postgresql://localhost
```

Implementation challenge: Strip `export ` prefix while preserving everything else.

**5. Inline comments:**
```bash
PORT=8080 # web server
QUOTED="value # not a comment"  # this IS a comment
```

Implementation challenge: Track quote state character-by-character to know when `#` starts a comment vs is part of the value.

Each feature required careful study of python-dotenv's behaviour, implementation in Mojo, and validation via Python interop tests. The test suite grew to 8 test files covering all edge cases.

### The Gnarly Bit: Multiline Quote Detection

The trickiest part? Detecting when a quoted string closes across multiple lines. Consider:

```bash
ESCAPED="Has backslash: \\"
MULTILINE="Line 1
Line 2"
```

Both end with `"`, but only MULTILINE should span lines. The difference? The number of consecutive backslashes before the quote.

Solution: Count backwards from the quote. Even count (including zero) means quote is NOT escaped:

```mojo
fn count_trailing_backslashes(text: String, end_pos: Int) -> Int:
    """Count consecutive backslashes before position."""
    var count = 0
    var idx = end_pos - 1
    while idx >= 0 and text[idx] == "\\":
        count += 1
        idx -= 1
    return count

# In multiline parser:
if count_trailing_backslashes(line, len(line) - 1) % 2 == 0:
    # Quote is NOT escaped, string is closed
```

This pattern—extracting helpers for complex logic—made the codebase maintainable.

### Code Review: Finding the Hidden Bugs

Before releasing v0.2.0, I did a systematic code review looking for:
- **Duplication** — Variable lookup logic repeated twice
- **Unused parameters** — `override=False` not actually working!
- **Edge cases** — Keys without `=` not being parsed in `parse_dotenv()`

**Critical bug found:** `load_dotenv(override=False)` was broken. Both `override=True` and `override=False` called `setenv()` unconditionally:

```mojo
// BEFORE: Bug - both branches identical
if override:
    _ = setenv(key, value)
else:
    _ = setenv(key, value)  // Also overwrites!

// AFTER: Fixed
if not override:
    var existing = getenv(key)
    if len(existing) == 0:
        _ = setenv(key, value)
    elif verbose:
        print("[dotenv] Skipping existing var: " + key)
```

This is why systematic review matters. The bug existed since v0.1.0 but wasn't caught because there were no tests specifically for the `override` parameter.

**Refactoring added:**
- `lookup_variable()` helper — Eliminated duplicated "check env_dict → system env → literal fallback" logic
- `count_trailing_backslashes()` helper — Cleaner multiline parsing
- `test_override.mojo` — Comprehensive override parameter testing
- `test_helpers.mojo` — Edge cases like empty files, comment-only files, inline comments with quotes

Result: **Reduced duplication by ~30 lines**, improved readability, and found bugs that would've surfaced in production.

## The Result: Production-Ready Library

Final feature set (v0.2.0):
- ✅ All basic parsing (`KEY=value`, quotes, comments, whitespace)
- ✅ Variable expansion (`${VAR}` and `$VAR` syntax)
- ✅ Multiline values with proper quote handling
- ✅ Escape sequences in quoted strings
- ✅ Export prefix support
- ✅ Inline comments (quote-aware)
- ✅ `find_dotenv()` — Auto-discovery searching parent directories
- ✅ Verbose mode for debugging
- ✅ Keys without `=` (returns empty string)
- ✅ **98%+ compatibility with python-dotenv**

Known differences (by design):
- Keys without `=` return `""` instead of `None` (Mojo Dict limitation)
- Stream input not supported (file paths only)  
- UTF-8 only (Mojo default)

**Test coverage:** 10 test files, 50+ test cases, including Python interop validation.

## Key Lessons for Building Mojo Libraries

### 1. Don't Reinvent—Adapt

There's a mature Python ecosystem. For libraries like configuration management, database drivers, or logging, the hard work of discovering edge cases is done. Your job: implement in Mojo, validate compatibility.

Using python-dotenv as the reference saved weeks of "what should happen when...?" questions.

### 2. Python Interop is Your Testing Superpower

Mojo's Python interop isn't just for migration—it's a testing tool. You can validate Mojo behaviour against Python in the same test file:

```mojo
var py_result = Python.import_module("dotenv").dotenv_values("test.env")
var mojo_result = dotenv_values("test.env")
// Assert they match
```

This continuous validation caught subtle differences (like how inline comments interact with quotes) that would've been painful to debug in production.

### 3. Progressive Implementation Beats Big Bang

Start with the 80% use case, validate it thoroughly, then add complexity. The progression:
1. Basic `KEY=value` parsing
2. Quotes and comments
3. Advanced features (variables, multiline, escapes)
4. Polish (verbose mode, find_dotenv, edge cases)

Each step was validated before moving forward. This made debugging tractable—I always knew what "last worked" looked like.

### 4. Systematic Code Review Finds Real Bugs

The `override=False` bug existed for two weeks before discovery. A checklist-driven code review (check unused parameters, check duplication, check edge cases) found it immediately.

For production libraries, this review step isn't optional.

### 5. Test What You Refactor

After refactoring to add helper functions, I added `test_helpers.mojo` specifically to test:
- The backslash-counting logic
- Variable lookup with system env fallback
- Edge cases like empty files and comment-only files

These tests validated the refactoring didn't change behaviour—critical for a library others depend on.

## Real-World Impact: Configuration at Scale

For businesses moving production workloads to Mojo, configuration management isn't optional. You need:

- **Secrets rotation** without redeployment
- **Environment-specific config** (dev/staging/prod)
- **Developer onboarding** with familiar patterns
- **Audit trails** (verbose mode logs what's loaded)

mojo-dotenv provides all this whilst maintaining Python-dotenv compatibility. Your ops team doesn't need to learn new patterns; your Mojo services just work.

## Try It Yourself

```bash
# Add to your project via git submodule
git submodule add https://github.com/databooth/mojo-dotenv vendor/mojo-dotenv

# Use in your code
mojo -I vendor/mojo-dotenv/src your_app.mojo
```

Or clone and explore:
```bash
git clone https://github.com/databooth/mojo-dotenv
cd mojo-dotenv
pixi install
pixi run test-all  # Watch 10 test files pass
```

Full example:
```mojo
from dotenv import load_dotenv, dotenv_values, find_dotenv
from os import getenv

fn main() raises:
    # Auto-discover .env file
    var env_path = find_dotenv()
    
    # Load into environment (respects existing vars)
    _ = load_dotenv(env_path, override=False, verbose=True)
    
    # Or parse without modifying environment
    var config = dotenv_values(".env.production")
    var db_url = config["DATABASE_URL"]
```

## What's Next?

**v0.3.0 Roadmap:**
- Multiple .env files with precedence (`.env` + `.env.local`)
- Stream input support
- Performance optimizations for large files
- Enhanced error messages with line numbers

Want to contribute? The project follows standard Git workflow. Issues and PRs welcome!

## Closing Thoughts

Building mojo-dotenv reinforced why Mojo is compelling for production systems:
- **Performance** when you need it (compiled, no interpreter overhead)
- **Compatibility** when you want it (Python interop for testing, familiar APIs)
- **Safety** when it matters (ownership tracking prevents entire classes of bugs)

For medium-sized businesses evaluating Mojo, configuration management might seem mundane. But it's precisely these foundational libraries—the ones you don't think about until they break—that enable confident production deployments.

The approach here—reference implementation in Python, progressive Mojo implementation, continuous validation—generalises to other libraries. Database drivers, HTTP clients, logging frameworks. Stand on Python's shoulders, bring the ecosystem to Mojo incrementally, validate rigorously.

If you're running Python workloads and considering Mojo, mojo-dotenv is one less thing to rebuild. Focus your migration effort on your actual business logic, not reinventing configuration management.

---

**Links:**
- [mojo-dotenv on GitHub](https://github.com/databooth/mojo-dotenv)
- [Documentation](https://github.com/databooth/mojo-dotenv/blob/main/README.md)
- [CHANGELOG](https://github.com/databooth/mojo-dotenv/blob/main/CHANGELOG.md)

**Questions or feedback?** Comments are enabled below, or reach out via GitHub issues.

---

*Building production-ready data systems for medium-sized businesses. Need help evaluating Mojo for your infrastructure? [Let's talk](https://www.databooth.com.au/about/).*
