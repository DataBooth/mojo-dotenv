"""Test escape sequence support."""

from dotenv import dotenv_values


fn main() raises:
    print("=== Testing escape sequences ===\n")
    
    var result = dotenv_values("tests/fixtures/escapes.env")
    
    print("Parsed values:")
    for item in result.items():
        print("  " + item.key + " = " + repr(item.value))
    
    print()
    
    # Test newline
    var newline_val = result["NEWLINE"]
    print("NEWLINE contains newline:", "\\n" in newline_val)
    if "line1\nline2" != newline_val:
        print("  Expected: line1\\nline2")
        print("  Got:", repr(newline_val))
        raise Error("Newline escape not processed correctly")
    
    # Test tab
    var tab_val = result["TAB"]
    print("TAB contains tab:", "\\t" in tab_val)
    if "col1\tcol2" != tab_val:
        print("  Expected: col1\\tcol2")
        print("  Got:", repr(tab_val))
        raise Error("Tab escape not processed correctly")
    
    # Test backslash
    var backslash_val = result["BACKSLASH"]
    print("BACKSLASH value:", repr(backslash_val))
    if "path\\to\\file" != backslash_val:
        print("  Expected: path\\\\to\\\\file")
        print("  Got:", repr(backslash_val))
        raise Error("Backslash escape not processed correctly")
    
    # Test quote
    var quote_val = result["QUOTE"]
    print("QUOTE value:", repr(quote_val))
    if 'He said "hello"' != quote_val:
        print("  Expected: He said \"hello\"")
        print("  Got:", repr(quote_val))
        raise Error("Quote escape not processed correctly")
    
    # Test unquoted (no escape processing)
    var unquoted_val = result["UNQUOTED"]
    print("UNQUOTED value:", repr(unquoted_val))
    if "no_escapes\\nhere" != unquoted_val:
        print("  Expected: no_escapes\\\\nhere (literal)")
        print("  Got:", repr(unquoted_val))
        raise Error("Unquoted should not process escapes")
    
    print("\n✓ All escape sequence tests passed!\n")
