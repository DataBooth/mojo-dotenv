"""Test multiline value support."""

from dotenv import dotenv_values


fn main() raises:
    print("=== Testing multiline values ===\n")
    
    var result = dotenv_values("tests/fixtures/multiline.env")
    
    print("Parsed values:")
    for item in result.items():
        var display_value = item.value
        # Replace actual newlines with \n for display
        var safe_display = String("")
        for i in range(len(display_value)):
            if display_value[i] == "\n":
                safe_display += "\\n"
            else:
                safe_display += String(display_value[i])
        print("  " + item.key + " = " + repr(safe_display))
    
    print()
    
    # Test single line (baseline)
    var single = result["SINGLE_LINE"]
    print("SINGLE_LINE:", repr(single))
    if single != "single line":
        raise Error("Expected 'single line'")
    
    # Test multiline double quotes
    var multiline_double = result["MULTILINE_DOUBLE"]
    print("\nMULTILINE_DOUBLE contains newlines:", "\n" in multiline_double)
    var lines = multiline_double.split("\n")
    print("  Number of lines:", len(lines))
    if len(lines) != 3:
        raise Error("Expected 3 lines in MULTILINE_DOUBLE")
    
    # Test multiline single quotes  
    var multiline_single = result["MULTILINE_SINGLE"]
    print("\nMULTILINE_SINGLE contains newlines:", "\n" in multiline_single)
    var single_lines = multiline_single.split("\n")
    print("  Number of lines:", len(single_lines))
    if len(single_lines) != 3:
        raise Error("Expected 3 lines in MULTILINE_SINGLE")
    
    # Test JSON (multiline with escapes)
    var json = result["JSON"]
    print("\nJSON value:")
    print(json)
    if not ("name" in json and "value" in json):
        raise Error("JSON should contain 'name' and 'value'")
    
    # Test that parsing continues after multiline
    var after = result["AFTER_MULTILINE"]
    print("\nAFTER_MULTILINE:", after)
    if after != "after_value":
        raise Error("Expected 'after_value' after multiline parsing")
    
    print("\n✓ All multiline tests passed!\n")
