# Next Steps for mojo-dotenv

## ✅ Completed

- [x] Research existing solutions (mojoenv)
- [x] Create project structure
- [x] Write comprehensive PLAN.md
- [x] Document Mojo package management state
- [x] Initial git commit
- [x] Set up pixi development environment
- [x] Test mojoenv compatibility - documented in `docs/MOJOENV_COMPATIBILITY_ANALYSIS.md`

## 🎯 Immediate Next Steps

### 1. Test mojoenv Compatibility

**Goal:** Verify that mojoenv doesn't work with modern Mojo

```bash
# Clone mojoenv
cd ~/code/github/databooth
git clone https://github.com/itsdevcoffee/mojoenv
cd mojoenv

# Try to build/run
mojo main.mojo

# Expected: Compilation errors due to outdated Mojo syntax
# Document the errors in a new file: mojoenv-compatibility-test.md
```

**Document findings:**
- What errors occur?
- Which Mojo features have changed?
- What needs updating?

This validates the need for mojo-dotenv.

### 2. Set Up Development Environment

```bash
cd ~/code/github/databooth/mojo-dotenv

# Initialize pixi
pixi init -c conda-forge -c https://conda.modular.com/max-nightly

# Edit pixi.toml to add:
# [dependencies]
# mojo = "*"
# python-dotenv = "*"  # For testing reference

pixi install
```

### 3. Review python-dotenv API

Study the reference implementation:

```bash
# In a separate terminal
python3 -m pip install python-dotenv
python3
```

```python
from dotenv import load_dotenv, dotenv_values, find_dotenv

# Try the API
load_dotenv()  # Load .env
config = dotenv_values(".env")  # Get as dict
path = find_dotenv()  # Find .env file

# Read the source
import dotenv
print(dotenv.__file__)
# Go read: /path/to/dotenv/main.py
```

Take notes on:
- Function signatures
- Error handling patterns
- Edge cases handled
- What to emulate vs skip

### 4. Create Test Fixtures

Create sample .env files for testing:

```bash
cd ~/code/github/databooth/mojo-dotenv
mkdir -p tests/fixtures
```

Create these files in `tests/fixtures/`:

**basic.env:**
```
KEY1=value1
KEY2=value2
DATABASE_URL=postgresql://localhost/db
```

**quotes.env:**
```
SINGLE='single quoted'
DOUBLE="double quoted"
MIXED='has "inner" quotes'
```

**comments.env:**
```
# This is a comment
KEY1=value1
# Another comment
KEY2=value2  # Inline comment (future)
```

**whitespace.env:**
```
  KEY1  =  value1  
KEY2=value2
   # Comment with spaces
```

### 5. Start Phase 1: MVP Implementation

Begin with the parser:

```bash
cd ~/code/github/databooth/mojo-dotenv
touch src/dotenv/__init__.mojo
touch src/dotenv/parser.mojo
touch src/dotenv/loader.mojo
```

Start simple in `parser.mojo`:

```mojo
# src/dotenv/parser.mojo
from collections import Dict

fn parse_line(line: String) -> Optional[Tuple[String, String]]:
    """
    Parse a single line of .env file.
    
    Returns (key, value) tuple or None if line should be ignored.
    """
    var stripped = line.strip()
    
    # Ignore empty lines
    if len(stripped) == 0:
        return None
    
    # Ignore comments
    if stripped.startswith("#"):
        return None
    
    # Split on first '='
    var parts = stripped.split("=", 1)
    if len(parts) != 2:
        return None  # Invalid line
    
    var key = parts[0].strip()
    var value = parts[1].strip()
    
    # TODO: Handle quotes
    # TODO: Handle escapes
    
    return (key, value)
```

## 📋 Phase 0 Checklist

Track completion of Phase 0 tasks:

- [x] Clone and test mojoenv - document errors
- [x] Set up pixi development environment  
- [ ] Review python-dotenv API - take notes
- [ ] Create test fixtures (basic, quotes, comments, whitespace)
- [ ] Document findings in `docs/RESEARCH.md`

## 🚀 When Phase 0 Complete

Update PLAN.md:
```markdown
### Phase 0: Research & Validation (COMPLETED)
- [x] All tasks
```

Then create GitHub repo and push:

```bash
cd ~/code/github/databooth/mojo-dotenv

# Create repo on GitHub (via web or gh CLI)
gh repo create databooth/mojo-dotenv --public --source=. --remote=origin

# Push
git push -u origin main
```

Then move to Phase 1 implementation!

## 📚 Reference Materials

Keep these handy:

1. **Mojo Docs:**
   - https://docs.modular.com/mojo/manual/
   - https://docs.modular.com/mojo/lib/

2. **python-dotenv:**
   - https://github.com/theskumar/python-dotenv
   - https://saurabh-kumar.com/python-dotenv/

3. **12-Factor Config:**
   - https://12factor.net/config

4. **Mojo String API:**
   - https://docs.modular.com/mojo/stdlib/builtin/string

5. **Mojo Collections:**
   - https://docs.modular.com/mojo/stdlib/collections/

## 💡 Tips

- **Start small:** Get basic parsing working first
- **Test as you go:** Create tests before implementation (TDD)
- **Use python-dotenv:** Run same tests in Python for comparison
- **Document decisions:** Why you chose certain approaches
- **Commit often:** Small, focused commits

## 🤔 Questions to Answer

As you work through Phase 0:

1. What Mojo features changed since 2023 that broke mojoenv?
2. What's the best way to handle String operations in current Mojo?
3. Should we support all python-dotenv features or subset?
4. What error messages would be most helpful?
5. How should we handle malformed .env files?

Document answers in `docs/RESEARCH.md`

## 🎯 Success Criteria for Phase 0

You're ready for Phase 1 when:

- ✅ You've confirmed mojoenv is incompatible
- ✅ Development environment set up (pixi working)
- ✅ Test fixtures created
- ✅ python-dotenv API understood
- ✅ Research documented
- ✅ Confident about the approach

---

**Current Status:** Ready to begin Phase 0 validation!  
**Next Action:** Clone and test mojoenv
