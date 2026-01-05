"""Test export prefix support."""

from dotenv import dotenv_values


fn main() raises:
    print("=== Testing export prefix ===\n")
    
    var result = dotenv_values("tests/fixtures/export.env")
    
    print("Parsed values:")
    for item in result.items():
        print("  " + item.key + " = " + item.value)
    
    print()
    
    # Verify values
    if result["KEY1"] != "value1":
        raise Error("Expected KEY1='value1'")
    
    if result["KEY2"] != "quoted value":
        raise Error("Expected KEY2='quoted value'")
    
    if result["KEY3"] != "no_export":
        raise Error("Expected KEY3='no_export'")
    
    if result["KEY4"] != "extra_spaces":
        raise Error("Expected KEY4='extra_spaces'")
    
    if result["KEY5"] != "single quotes":
        raise Error("Expected KEY5='single quotes'")
    
    print("✓ All export prefix tests passed!\n")
