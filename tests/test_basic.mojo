"""Basic tests for mojo-dotenv."""

from dotenv import dotenv_values


fn test_basic_parsing() raises:
    """Test basic KEY=value parsing."""
    print("Testing basic.env...")
    var result = dotenv_values("tests/fixtures/basic.env")
    
    # Check that we got the expected keys
    print("  KEY1 =", result["KEY1"])
    print("  KEY2 =", result["KEY2"])
    print("  DATABASE_URL =", result["DATABASE_URL"])
    print("  PORT =", result["PORT"])
    
    # Basic assertions
    if result["KEY1"] != "value1":
        raise Error("Expected KEY1='value1'")
    if result["DATABASE_URL"] != "postgresql://localhost/db":
        raise Error("Expected DATABASE_URL='postgresql://localhost/db'")
    
    print("✓ Basic parsing works!\n")


fn test_quotes() raises:
    """Test quote stripping."""
    print("Testing quotes.env...")
    var result = dotenv_values("tests/fixtures/quotes.env")
    
    print("  SINGLE =", result["SINGLE"])
    print("  DOUBLE =", result["DOUBLE"])
    print("  MIXED =", result["MIXED"])
    
    if result["SINGLE"] != "single quoted value":
        raise Error("Expected SINGLE='single quoted value'")
    if result["DOUBLE"] != "double quoted value":
        raise Error("Expected DOUBLE='double quoted value'")
    if result["MIXED"] != 'has "inner" quotes':
        raise Error('Expected MIXED=\'has "inner" quotes\'')
    
    print("✓ Quote handling works!\n")


fn test_comments() raises:
    """Test comment handling."""
    print("Testing comments.env...")
    var result = dotenv_values("tests/fixtures/comments.env")
    
    print("  KEY1 =", result["KEY1"])
    print("  KEY2 =", result["KEY2"])
    print("  KEY3 =", result["KEY3"])
    
    if result["KEY1"] != "value1":
        raise Error("Expected KEY1='value1'")
    
    print("✓ Comment handling works!\n")


fn test_whitespace() raises:
    """Test whitespace trimming."""
    print("Testing whitespace.env...")
    var result = dotenv_values("tests/fixtures/whitespace.env")
    
    print("  KEY1 =", result["KEY1"])
    print("  KEY2 =", result["KEY2"])
    
    if result["KEY1"] != "value1":
        raise Error("Expected KEY1='value1' (whitespace trimmed)")
    
    print("✓ Whitespace handling works!\n")


fn main() raises:
    print("=== mojo-dotenv Basic Tests ===\n")
    
    test_basic_parsing()
    test_quotes()
    test_comments()
    test_whitespace()
    
    print("=== All tests passed! ===")
