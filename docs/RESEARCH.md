# Phase 0 Research Findings

**Date**: 2026-01-05  
**python-dotenv Version**: 1.2.1  
**Mojo Version**: 0.26.1.0.dev2026010405

## python-dotenv API Analysis

### Core Functions

#### 1. `load_dotenv()`
```python
load_dotenv(
    dotenv_path: str | os.PathLike[str] | None = None,
    stream: IO[str] | None = None,
    verbose: bool = False,
    override: bool = False,
    interpolate: bool = True,
    encoding: str | None = 'utf-8'
) -> bool
```

**Purpose**: Parse a .env file and load all variables as environment variables.

**Key parameters**:
- `dotenv_path`: Absolute or relative path to .env file
- `override`: If `True`, override existing environment variables
- `interpolate`: If `True`, expand variables like `${VAR}` (Phase 3 feature)
- Returns `bool`: Success/failure

**Mojo MVP equivalent**: Phase 2 feature

#### 2. `dotenv_values()`
```python
dotenv_values(
    dotenv_path: str | os.PathLike[str] | None = None,
    stream: IO[str] | None = None,
    verbose: bool = False,
    interpolate: bool = True,
    encoding: str | None = 'utf-8'
) -> Dict[str, str | None]
```

**Purpose**: Parse a .env file and return its content as a dictionary.

**Key behaviour**:
- Returns `Dict[str, str | None]`
- `None` values for keys without values (e.g., `KEY` without `=`)
- Does NOT modify environment variables
- Quotes are stripped from values
- Whitespace is trimmed from keys and values

**Mojo MVP equivalent**: Phase 1 core feature

#### 3. `find_dotenv()`
```python
find_dotenv(
    filename: str = '.env',
    raise_error_if_not_found: bool = False,
    usecwd: bool = False
) -> str
```

**Purpose**: Search in increasingly higher folders for the given file.

**Behaviour**:
- Searches upward from current directory
- Returns path if found, empty string otherwise
- Can optionally raise error if not found

**Mojo MVP equivalent**: Phase 2 feature

## Parsing Behaviour Reference

Based on testing with fixtures in `tests/fixtures/`, here's how python-dotenv handles various cases:

### 1. Basic Key-Value Pairs (`basic.env`)
```
KEY1=value1
DATABASE_URL=postgresql://localhost/db
PORT=8080
```

**Result**:
```python
{
    'KEY1': 'value1',
    'DATABASE_URL': 'postgresql://localhost/db',
    'PORT': '8080'
}
```

**Notes**: Straightforward parsing, all values are strings.

### 2. Quoted Values (`quotes.env`)
```
SINGLE='single quoted value'
DOUBLE="double quoted value"
MIXED='has "inner" quotes'
EMPTY_SINGLE=''
SPACES_SINGLE='  spaces  '
```

**Result**:
```python
{
    'SINGLE': 'single quoted value',      # Quotes stripped
    'DOUBLE': 'double quoted value',      # Quotes stripped
    'MIXED': 'has "inner" quotes',        # Outer quotes stripped, inner preserved
    'EMPTY_SINGLE': '',                   # Empty string (not None)
    'SPACES_SINGLE': '  spaces  '         # Spaces preserved inside quotes
}
```

**Notes**:
- Outer quotes (single or double) are **stripped**
- Inner quotes of opposite type are **preserved**
- Whitespace inside quotes is **preserved**
- Empty quoted strings return `''`, not `None`

### 3. Comments (`comments.env`)
```
# This is a comment
KEY1=value1
# Another comment
KEY2=value2
```

**Result**:
```python
{
    'KEY1': 'value1',
    'KEY2': 'value2'
}
```

**Notes**:
- Lines starting with `#` are **ignored**
- Blank lines are **ignored**
- Comments must be at start of line (inline comments are Phase 3)

### 4. Whitespace Handling (`whitespace.env`)
```
  KEY1  =  value1  
KEY2=value2
   KEY3=value3
```

**Result**:
```python
{
    'KEY1': 'value1',   # All whitespace trimmed
    'KEY2': 'value2',
    'KEY3': 'value3'
}
```

**Notes**:
- Leading/trailing whitespace around keys is **trimmed**
- Leading/trailing whitespace around values is **trimmed**
- Whitespace around `=` is **ignored**

### 5. Edge Cases (`edge_cases.env`)
```
VALID=value
EMPTY_VALUE=
NO_EQUALS_SIGN
=NO_KEY
KEY_WITH_EQUALS=value=with=equals
MULTILINE_START="line1
```

**Result**:
```python
{
    'VALID': 'value',
    'EMPTY_VALUE': '',                    # Empty string
    'NO_EQUALS_SIGN': None,               # No value -> None
    'KEY_WITH_EQUALS': 'value=with=equals' # Only first = is delimiter
}
```

**Warnings**:
```
python-dotenv could not parse statement starting at line 6  # =NO_KEY
python-dotenv could not parse statement starting at line 8  # MULTILINE_START
```

**Notes**:
- Empty values (`KEY=`) return `''` (empty string)
- Keys without `=` return `None` as value
- Lines starting with `=` are **invalid** (warning, skipped)
- Only the **first** `=` is used as delimiter
- Unclosed quotes cause parse errors (Phase 3 multiline support)

## Phase 1 MVP Scope

Based on this research, Phase 1 should implement:

### Must Have (MVP)
1. ✅ Parse `KEY=value` format
2. ✅ Strip leading/trailing whitespace from keys and values
3. ✅ Ignore blank lines
4. ✅ Ignore lines starting with `#`
5. ✅ Handle single and double quotes (strip outer, preserve inner)
6. ✅ Preserve whitespace inside quotes
7. ✅ Handle empty values (`KEY=` → `''`)
8. ✅ Handle keys without values (`KEY` → `None` or skip)
9. ✅ Split on first `=` only
10. ✅ Return `Dict[String, String]` equivalent

### Deferred to Phase 2+
- Variable interpolation (`${VAR}`)
- Inline comments (`KEY=value # comment`)
- Multiline values (quoted strings spanning lines)
- Escape sequences (`\n`, `\t`, `\"`)
- `load_dotenv()` functionality (modifying os.environ)
- `find_dotenv()` functionality (searching upward)

## Mojo Implementation Considerations

### String Operations Needed
- `strip()` - whitespace trimming ✅ (available)
- `split(delimiter, maxsplit)` - splitting on first `=` ✅ (available)
- `startswith()` - detecting comments ✅ (available)
- `len()` - checking empty strings ✅ (available)
- String indexing/slicing - quote stripping ✅ (available)

### File I/O
- Read file line by line
- Handle UTF-8 encoding (Mojo default)
- Path operations (check existence)

### Data Structures
- `Dict[String, String]` ✅ (available)
- Optional/nullable values for keys without `=`

### Error Handling
- File not found
- Invalid UTF-8
- Parse warnings (optional, like python-dotenv)

## Testing Strategy

### Phase 1 Tests
1. **Basic parsing**: `basic.env` fixture
2. **Quote handling**: `quotes.env` fixture
3. **Comment handling**: `comments.env` fixture
4. **Whitespace handling**: `whitespace.env` fixture
5. **Edge cases**: `edge_cases.env` fixture

### Validation Approach
- Use Python interop to call `python-dotenv.dotenv_values()`
- Compare Mojo output with Python output
- Document any intentional differences

### Example Test Pattern
```mojo
from dotenv import dotenv_values  # Our Mojo implementation
from python import Python

fn test_basic() raises:
    # Mojo version
    var mojo_result = dotenv_values("tests/fixtures/basic.env")
    
    # Python reference
    var py = Python.import_module("dotenv")
    var py_result = py.dotenv_values("tests/fixtures/basic.env")
    
    # Compare
    assert_equal(mojo_result, py_result)
```

## Next Steps

1. ✅ Test fixtures created
2. ✅ python-dotenv API documented
3. ✅ Parsing behaviour validated
4. 🎯 Begin Phase 1 implementation:
   - Create `src/dotenv/__init__.mojo`
   - Create `src/dotenv/parser.mojo`
   - Implement `parse_line()` function
   - Implement `dotenv_values()` function
   - Write basic tests

---

**References**:
- python-dotenv: https://github.com/theskumar/python-dotenv
- Fixtures: `tests/fixtures/`
- API signatures captured from version 1.2.1
