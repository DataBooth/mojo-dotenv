"""Test load_dotenv override parameter functionality."""

from dotenv import load_dotenv
from os import setenv, getenv, unsetenv


fn main() raises:
    print("=== Testing override parameter ===\n")
    
    # Test 1: override=False should preserve existing variables
    print("Test 1: override=False preserves existing variables")
    _ = setenv("PORT", "9999")
    _ = setenv("DEBUG", "false")
    
    var initial_port = getenv("PORT")
    var initial_debug = getenv("DEBUG")
    print("  Initial PORT:", initial_port)
    print("  Initial DEBUG:", initial_debug)
    
    # Load with override=False (default)
    _ = load_dotenv("tests/fixtures/basic.env", override=False)
    
    var port_after = getenv("PORT")
    var debug_after = getenv("DEBUG")
    print("  After load_dotenv(override=False):")
    print("    PORT:", port_after)
    print("    DEBUG:", debug_after)
    
    if port_after != "9999":
        raise Error("Expected PORT to remain '9999', got '" + port_after + "'")
    if debug_after != "false":
        raise Error("Expected DEBUG to remain 'false', got '" + debug_after + "'")
    
    print("  ✓ Existing variables preserved\n")
    
    # Test 2: override=True should replace existing variables
    print("Test 2: override=True replaces existing variables")
    _ = setenv("PORT", "7777")
    _ = setenv("DEBUG", "maybe")
    
    print("  Set PORT to 7777, DEBUG to 'maybe'")
    
    # Load with override=True
    _ = load_dotenv("tests/fixtures/basic.env", override=True)
    
    var port_override = getenv("PORT")
    var debug_override = getenv("DEBUG")
    print("  After load_dotenv(override=True):")
    print("    PORT:", port_override)
    print("    DEBUG:", debug_override)
    
    if port_override != "8080":
        raise Error("Expected PORT to be '8080', got '" + port_override + "'")
    if debug_override != "true":
        raise Error("Expected DEBUG to be 'true', got '" + debug_override + "'")
    
    print("  ✓ Existing variables overridden\n")
    
    # Test 3: New variables should be set regardless of override setting
    print("Test 3: New variables set regardless of override")
    
    # Clear KEY1 if it exists
    try:
        _ = unsetenv("KEY1")
    except:
        pass
    
    _ = load_dotenv("tests/fixtures/basic.env", override=False)
    var key1 = getenv("KEY1")
    print("  KEY1 after override=False:", key1)
    
    if key1 != "value1":
        raise Error("Expected KEY1 to be set to 'value1', got '" + key1 + "'")
    
    print("  ✓ New variables set correctly\n")
    
    # Test 4: Verbose mode should report skipped variables
    print("Test 4: Verbose mode with override=False")
    _ = setenv("API_KEY", "existing_key")
    print("  Set API_KEY to 'existing_key'")
    print("  Loading with verbose=True, override=False:")
    _ = load_dotenv("tests/fixtures/basic.env", override=False, verbose=True)
    
    var api_key = getenv("API_KEY")
    if api_key != "existing_key":
        raise Error("Expected API_KEY to remain 'existing_key', got '" + api_key + "'")
    
    print("  ✓ Verbose mode working\n")
    
    print("✓ All override parameter tests passed!\n")
