# Code Overview: mojo-dotenv Architecture

A high-level guide to understanding the mojo-dotenv codebase structure and implementation.

---

## 📦 Project Structure

```
mojo-dotenv/
├── src/dotenv/          # Core library code (4 files)
│   ├── __init__.mojo    # Public API exports
│   ├── parser.mojo      # Line/file parsing logic
│   ├── loader.mojo      # Environment loading
│   └── finder.mojo      # Auto-discovery
├── tests/               # Test suite (10 files)
│   ├── test_*.mojo      # Feature-specific tests
│   └── fixtures/        # Test .env files
├── examples/            # Usage examples
│   └── simple.mojo
└── docs/                # Documentation
```

---

## 🏗️ Architecture: Three-Layer Design

### Layer 1: Public API (`__init__.mojo`)

**Purpose:** Exposes the functions users call

**Three main functions:**
```mojo
fn dotenv_values(path, verbose) -> Dict[String, String]
fn load_dotenv(path, override, verbose) -> Bool  
fn find_dotenv(filename, raise_error, usecwd) -> String
```

**Implementation:** Thin wrappers that delegate to the other modules. Reads file, calls parser, returns result.

**Complexity:** ~50 lines, straightforward

**Start here:** `src/dotenv/__init__.mojo`

---

### Layer 2: Core Logic

#### 2a. Parser (`parser.mojo`)

**Purpose:** The heavy lifting—converts text file → Dict[String, String]

**Key functions in order of dependency:**

**Helper functions** (lines 10-65):
- `count_trailing_backslashes()` — Counts `\` before a quote (for multiline detection)
- `lookup_variable()` — Looks up variable in dict → system env → fallback literal
- `strip_inline_comment()` — Removes `# comment` while respecting quotes

**Expansion functions** (lines 67-210):
- `expand_variables()` — Handles `${VAR}` and `$VAR` syntax
- `process_escapes()` — Converts `\n` → newline, `\t` → tab, etc.
- `strip_quotes()` — Removes outer quotes and calls `process_escapes()`

**Line parser** (lines 229-289):
- `parse_line()` — Parses single line: handles export prefix, splits on `=`, strips quotes

**File parser** (lines 292-390):
- `parse_dotenv()` — Main entry point, two-pass algorithm:
  - **Pass 1:** Parse all lines including multiline values
  - **Pass 2:** Expand variables in all values

**The tricky bits:**
- Lines 310-380: Multiline value detection (tracks quote state across lines)
- Lines 67-130: Variable expansion (handles nested refs, system env fallback)

**Complexity:** ~390 lines, most complex module

**Start here:** Read bottom-up:
1. `parse_line()` — Understand single-line parsing
2. `parse_dotenv()` — See how lines are assembled
3. Helper functions — Understand the pieces

---

#### 2b. Loader (`loader.mojo`)

**Purpose:** Takes parsed Dict and sets environment variables

**Main function:**
- `load_dotenv()` — Reads file, calls parser, iterates dict setting env vars

**The key logic** (lines 60-70):
```mojo
if override:
    _ = setenv(key, value)  # Always set
else:
    var existing = getenv(key)
    if len(existing) == 0:  # Only set if not already present
        _ = setenv(key, value)
    elif verbose:
        print("[dotenv] Skipping existing var: " + key)
```

**Complexity:** ~75 lines, very straightforward

**Start here:** `src/dotenv/loader.mojo`

---

#### 2c. Finder (`finder.mojo`)

**Purpose:** Searches for `.env` file by walking up parent directories

**Main function:**
- `find_dotenv()` — Starts at current dir, checks for file, moves to `..`, repeats

**The algorithm:**
```
current = "."
for 20 levels:
    if (current / filename).exists():
        return path
    current = current / ".."
```

**Complexity:** ~65 lines, simple loop

**Start here:** `src/dotenv/finder.mojo`

---

## 🔄 Data Flow: How Everything Connects

### When you call `load_dotenv(".env")`:

```
1. User calls load_dotenv()
   ↓
2. loader.mojo reads file content
   ↓
3. Calls parse_dotenv(content)
   ↓
4. parser.mojo processes:
   - Split into lines
   - For each line, call parse_line()
   - If quoted value, check for multiline
   - Store in Dict[String, String]
   ↓
5. Second pass: expand_variables()
   - For each value, replace ${VAR} with actual value
   ↓
6. Returns Dict back to loader
   ↓
7. loader iterates Dict calling setenv()
```

### When you call `dotenv_values(".env")`:

Same as above, but stops at step 6 (returns Dict without calling setenv).

### When you call `find_dotenv()`:

```
1. Start at current directory "."
   ↓
2. Check if .env exists
   ↓
3. If yes: return path
   ↓
4. If no: move to parent directory
   ↓
5. Repeat (max 20 levels)
```

---

## 🧪 Test Structure

Tests mirror the implementation:

| Test File | What It Tests |
|-----------|---------------|
| `test_basic.mojo` | Basic KEY=value, quotes, comments |
| `test_python_compat.mojo` | Validates against Python dotenv |
| `test_load_dotenv.mojo` | Environment loading |
| `test_export.mojo` | `export KEY=value` prefix |
| `test_escapes.mojo` | Escape sequences `\n` `\t` `\\` |
| `test_variables.mojo` | Variable expansion `${VAR}` |
| `test_multiline.mojo` | Quoted values spanning lines |
| `test_phase3plus.mojo` | find_dotenv(), inline comments |
| `test_override.mojo` | override parameter behaviour |
| `test_helpers.mojo` | Edge cases, helper functions |

**Each test follows the pattern:**
1. Load a fixture file from `tests/fixtures/`
2. Parse it with `dotenv_values()` or `load_dotenv()`
3. Assert expected values
4. Print success message

**Test fixtures:** `tests/fixtures/*.env` contain various .env file patterns

---

## 🎯 Suggested Reading Order

For understanding the codebase:

### 1. **Start Simple** (30 minutes)

Read these files completely:
- `src/dotenv/finder.mojo` — Simplest module
- `src/dotenv/loader.mojo` — Straightforward logic
- `src/dotenv/__init__.mojo` — See the public API

### 2. **The Core** (1 hour)

Read `src/dotenv/parser.mojo` in this order:
- Read `parse_line()` function (lines 229-289)
- Read `strip_quotes()` and `process_escapes()` (lines 204-210, 154-201)
- Read `parse_dotenv()` main loop (lines 310-380) — the multiline logic
- Read `expand_variables()` (lines 67-130)
- Skim the helper functions at the top

### 3. **See It Work** (30 minutes)

Run and read tests:
```bash
pixi run mojo -I src tests/test_basic.mojo        # Simplest
pixi run mojo -I src tests/test_escapes.mojo      # Tricky escapes
pixi run mojo -I src tests/test_multiline.mojo    # Hardest part
```

Check the fixture files they load:
```bash
cat tests/fixtures/basic.env
cat tests/fixtures/escapes.env
cat tests/fixtures/multiline.env
```

### 4. **Trace Through** (1 hour)

Pick a simple `.env` file and manually trace through the code:

```bash
# tests/fixtures/basic.env
KEY1=value1
PORT=8080
```

Follow the execution:
1. `dotenv_values("tests/fixtures/basic.env")` called
2. File read into `content` string
3. `parse_dotenv(content)` splits on `\n`
4. For `"KEY1=value1"`, `parse_line()` called:
   - Strips whitespace
   - Splits on `=` → `["KEY1", "value1"]`
   - Returns tuple `("KEY1", "value1")`
5. Stored in Dict
6. Second pass: `expand_variables("value1", dict)` → no vars, returns as-is
7. Returns Dict to caller

---

## 🔍 Key Concepts to Understand

### 1. **Two-Pass Parsing**

**Why?** Variables can reference other variables:
```bash
BASE=/app
DIR=${BASE}/data    # Needs BASE to already be parsed
```

**Pass 1:** Extract all KEY=value pairs into Dict  
**Pass 2:** Replace `${...}` with actual values from Dict

This allows forward references and cross-references.

---

### 2. **Multiline Detection**

**Problem:** How do we know if `"` closes the string or is escaped?

**Solution:** Count backslashes before it:
- `"value"` → 0 backslashes → CLOSED ✅
- `"value\\"` → 2 backslashes (even) → CLOSED ✅ (the `\\` means literal backslash)
- `"value\"` → 1 backslash (odd) → NOT CLOSED ❌ (escaped quote)
- `"value\\\\"` → 4 backslashes (even) → CLOSED ✅

**Implementation:**
```mojo
fn count_trailing_backslashes(text: String, end_pos: Int) -> Int:
    var count = 0
    var idx = end_pos - 1
    while idx >= 0 and text[idx] == "\\":
        count += 1
        idx -= 1
    return count

# Even count = quote NOT escaped
# Odd count = quote IS escaped
if count_trailing_backslashes(line, len(line) - 1) % 2 == 0:
    closed = True
```

---

### 3. **StringSlice vs String**

**Mojo's distinction:** String slicing returns `StringSlice`, not `String`.

**Must convert explicitly:**
```mojo
var s = "hello"
var slice = s[1:3]          # StringSlice
var str = String(slice)     # String
```

**Most string methods return StringSlice:**
```mojo
String(line.strip())                    # strip() returns StringSlice
String(String(x[7:]).strip())           # Both slice and strip() return StringSlice
```

**Why the double `String()` wrapper?**
- First `String(x[7:])` converts slice to String
- Second `String(...)` converts the result of `.strip()` (which is StringSlice) to String

This is a Mojo stdlib limitation, not redundant code.

---

### 4. **Ownership Transfer with `^`**

**When returning a Dict from a function, use `^` to transfer ownership:**
```mojo
fn parse_dotenv(...) -> Dict[String, String]:
    var result = Dict[String, String]()
    # ... populate result ...
    return result^    # Transfer ownership, don't copy
```

**Why?** Mojo tracks ownership for memory safety. The `^` operator transfers ownership from the function to the caller, avoiding an expensive copy.

**Where you'll see it:**
- End of `parse_dotenv()` function
- Anywhere a Dict/complex type is returned

---

### 5. **Variable Expansion Algorithm**

**Challenge:** Handle both `${VAR}` and `$VAR`, with fallback to system environment.

**Implementation approach:**
1. Scan character by character
2. When `$` found:
   - Check if next char is `{` → `${VAR}` syntax
   - Else check if next char is alphanumeric → `$VAR` syntax
3. Extract variable name
4. Look up: env_dict first, then system env, else keep literal
5. Replace in result string

**Key function:** `lookup_variable(var_name, env_dict, fallback_literal)`

---

### 6. **Escape Sequence Processing**

**Only processed within quoted strings:**
```bash
QUOTED="Line 1\nLine 2"   # \n becomes newline
UNQUOTED=Line 1\nLine 2   # \n stays literal
```

**Implementation:**
- `strip_quotes()` checks if value is quoted
- If quoted, calls `process_escapes()` on the unquoted content
- If unquoted, returns as-is

**Supported escapes:** `\n`, `\t`, `\\`, `\"`, `\'`

---

### 7. **Inline Comment Detection**

**Challenge:** `#` can be part of value or start a comment:
```bash
PORT=8080 # comment               → value is "8080"
URL="http://example.com#anchor"   → value is "http://example.com#anchor"
```

**Solution:** Track quote state character-by-character:
```mojo
fn strip_inline_comment(line: String) -> String:
    var in_quote = False
    for each char:
        if char == quote and not escaped:
            toggle in_quote
        if char == '#' and not in_quote:
            return line up to this point
    return line
```

---

## 💡 Deep Dive Topics

Based on what interests you:

### **If you want to understand parsing:**
Focus on `parser.mojo`:
- `parse_line()` (lines 229-289) — Single line parsing
- `parse_dotenv()` (lines 292-390) — File-level parsing

### **If you want to understand the tricky multiline logic:**
Focus on:
- `count_trailing_backslashes()` helper (lines 10-25)
- Multiline detection in `parse_dotenv()` (lines 327-353)
- Trace through `tests/fixtures/multiline.env` manually

### **If you want to understand variable expansion:**
Focus on:
- `expand_variables()` (lines 67-130) — Main expansion logic
- `lookup_variable()` (lines 27-45) — Variable lookup
- Trace through `tests/fixtures/variables.env`

### **If you want to understand testing patterns:**
Read tests in this order:
- `test_basic.mojo` — Simplest patterns
- `test_python_compat.mojo` — Python interop testing
- `test_helpers.mojo` — Edge case testing

### **If you want to understand Mojo patterns:**
Look for:
- `StringSlice` → `String` conversions (throughout `parser.mojo`)
- Ownership transfers with `^` (end of `parse_dotenv()`)
- Python interop in tests (e.g., `Python.import_module()`)
- Dict iteration patterns (e.g., `for item in dict.items()`)

---

## 🎓 Ready to Explore?

**Recommended path:**

1. **Start with `finder.mojo`** (65 lines, dead simple)
   - Understand the file search algorithm
   - See basic Mojo path operations

2. **Then `loader.mojo`** (75 lines, straightforward)
   - Understand the overall flow
   - See override parameter logic

3. **Then `parse_line()` in parser.mojo** (60 lines)
   - Core single-line parsing logic
   - Understand export prefix, splitting, quote stripping

4. **Then trace through a test**
   - Run `test_basic.mojo` with print statements
   - Follow execution through the stack
   - See how Dict is built

5. **Finally tackle multiline parsing**
   - Read `parse_dotenv()` multiline detection
   - Understand `count_trailing_backslashes()`
   - Trace through `test_multiline.mojo`

---

## 📚 Additional Resources

**Documentation:**
- [README.md](../README.md) — Usage guide and API reference
- [CHANGELOG.md](../CHANGELOG.md) — Version history and features
- [CREDITS.md](../CREDITS.md) — Acknowledgments and project history

**Implementation details:**
- [RESEARCH.md](RESEARCH.md) — python-dotenv API analysis
- [MOJOENV_COMPATIBILITY_ANALYSIS.md](MOJOENV_COMPATIBILITY_ANALYSIS.md) — Why rebuild

**Community:**
- [COMMUNITY_ANNOUNCEMENTS.md](COMMUNITY_ANNOUNCEMENTS.md) — Sharing templates
- [AWESOME_MOJO_SUBMISSION.md](AWESOME_MOJO_SUBMISSION.md) — PR templates

---

## 💬 Questions?

The code is well-commented. Reading through should reveal the "why" behind most decisions. When you hit something confusing, check:

1. **Function docstrings** — Every function documents its purpose, args, and return
2. **Inline comments** — Complex logic has explanatory comments
3. **Test files** — Often show usage patterns and edge cases
4. **Git history** — Commit messages explain why changes were made

If still unclear, open a GitHub issue with your question!
