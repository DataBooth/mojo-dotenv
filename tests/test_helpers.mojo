"""Test helper functions and edge cases."""

from dotenv import dotenv_values, find_dotenv
from pathlib import Path


fn main() raises:
    print("=== Testing helper functions and edge cases ===\n")
    
    # Test 1: count_trailing_backslashes functionality (tested via multiline parsing)
    print("Test 1: Backslash counting in multiline values")
    var result1 = dotenv_values("tests/fixtures/escapes.env")
    
    # MIXED has 4 backslashes before closing quote - should be parsed correctly
    var mixed = result1["MIXED"]
    print("  MIXED value:", repr(mixed))
    
    # Should contain processed escapes, not consume next line
    if "UNQUOTED" not in result1:
        raise Error("Multiline parser incorrectly consumed UNQUOTED line")
    
    print("  ✓ Backslash counting works correctly\n")
    
    # Test 2: Variable lookup with fallback to system environment
    print("Test 2: Variable expansion with system env fallback")
    var result2 = dotenv_values("tests/fixtures/variables.env")
    
    # CURRENT_USER should expand from system USER env var
    if "CURRENT_USER" in result2:
        var user = result2["CURRENT_USER"]
        print("  CURRENT_USER:", user)
        # Should be non-empty if USER env var exists
        if len(user) > 0:
            print("  ✓ System environment fallback works\n")
        else:
            print("  ⚠ USER env var not set (may be expected)\n")
    
    # Test 3: Undefined variables remain literal
    if "UNDEFINED" in result2:
        var undef = result2["UNDEFINED"]
        print("Test 3: Undefined variables remain literal")
        print("  UNDEFINED:", undef)
        
        if "${DOES_NOT_EXIST}" not in undef:
            raise Error("Undefined variable should remain as literal ${DOES_NOT_EXIST}")
        
        print("  ✓ Undefined variables handled correctly\n")
    
    # Test 4: find_dotenv() with non-existent file
    print("Test 4: find_dotenv() with non-existent file")
    var not_found = find_dotenv("nonexistent.env", raise_error_if_not_found=False)
    print("  Result for nonexistent.env:", repr(not_found))
    
    if len(not_found) > 0:
        raise Error("Expected empty string for non-existent file")
    
    print("  ✓ Returns empty string for missing file\n")
    
    # Test 5: find_dotenv() with existing file
    print("Test 5: find_dotenv() finds existing file")
    var found = find_dotenv(".env")
    print("  Found .env at:", found)
    
    # Should find it or return empty (both are valid depending on repo state)
    print("  ✓ find_dotenv() executed without error\n")
    
    # Test 6: Verbose mode with dotenv_values
    print("Test 6: Verbose mode with dotenv_values")
    print("  Loading with verbose=True:")
    var result3 = dotenv_values("tests/fixtures/basic.env", verbose=True)
    
    if len(result3) == 0:
        raise Error("Expected to parse some values")
    
    print("  ✓ Verbose mode works with dotenv_values\n")
    
    # Test 7: Keys without '=' return empty string
    print("Test 7: Keys without '=' return empty string")
    var result4 = dotenv_values("tests/fixtures/no_equals.env")
    
    print("  Keys found:", len(result4))
    for item in result4.items():
        print("    " + item.key + " =", repr(item.value))
    
    if "JUST_A_KEY" in result4:
        var val = result4["JUST_A_KEY"]
        if val != "":
            raise Error("Expected empty string for key without '=', got: " + repr(val))
        print("  ✓ JUST_A_KEY has empty string value")
    
    if "NORMAL_KEY" in result4:
        if result4["NORMAL_KEY"] != "normal_value":
            raise Error("Normal key should have its value")
        print("  ✓ Normal keys still work")
    
    print("  ✓ Keys without '=' return empty string\n")
    
    # Test 8: Empty file handling
    print("Test 8: Empty file handling")
    var empty_path = "/tmp/empty_test.env"
    var p = Path(empty_path)
    
    # Create empty file
    with open(empty_path, "w") as f:
        pass
    
    var result5 = dotenv_values(empty_path)
    print("  Parsed", len(result5), "entries from empty file")
    
    if len(result5) != 0:
        raise Error("Expected 0 entries from empty file")
    
    print("  ✓ Empty file handled correctly\n")
    
    # Test 9: File with only comments
    print("Test 9: File with only comments")
    var comments_path = "/tmp/comments_only.env"
    
    with open(comments_path, "w") as f:
        f.write("# Just a comment\n")
        f.write("  # Another comment\n")
        f.write("\n")
        f.write("# More comments\n")
    
    var result6 = dotenv_values(comments_path)
    print("  Parsed", len(result6), "entries from comments-only file")
    
    if len(result6) != 0:
        raise Error("Expected 0 entries from comments-only file")
    
    print("  ✓ Comments-only file handled correctly\n")
    
    # Test 10: Inline comments with quotes
    print("Test 10: Inline comments respect quotes")
    var inline_path = "/tmp/inline_test.env"
    
    with open(inline_path, "w") as f:
        f.write('QUOTED="value # not a comment"\n')
        f.write('UNQUOTED=value # this is a comment\n')
    
    var result7 = dotenv_values(inline_path)
    
    var quoted = result7["QUOTED"]
    var unquoted = result7["UNQUOTED"]
    
    print("  QUOTED:", repr(quoted))
    print("  UNQUOTED:", repr(unquoted))
    
    if quoted != "value # not a comment":
        raise Error("Inline comment incorrectly stripped from quoted value")
    
    if unquoted != "value":
        raise Error("Inline comment not stripped from unquoted value")
    
    print("  ✓ Inline comments respect quotes\n")
    
    print("✓ All helper function and edge case tests passed!\n")
