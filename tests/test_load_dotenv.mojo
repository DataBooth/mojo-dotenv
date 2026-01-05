"""Test load_dotenv functionality."""

from dotenv import load_dotenv
from os import getenv


fn main() raises:
    print("=== Testing load_dotenv() ===\n")
    
    # Load the basic.env fixture
    print("Loading tests/fixtures/basic.env...")
    var success = load_dotenv("tests/fixtures/basic.env")
    
    if not success:
        raise Error("Failed to load .env file")
    
    print("✓ File loaded successfully\n")
    
    # Check that environment variables were set
    print("Checking environment variables:")
    
    var key1 = getenv("KEY1")
    print("  KEY1 =", key1)
    if key1 != "value1":
        raise Error("Expected KEY1='value1', got '" + key1 + "'")
    
    var db_url = getenv("DATABASE_URL")
    print("  DATABASE_URL =", db_url)
    if db_url != "postgresql://localhost/db":
        raise Error("Expected DATABASE_URL='postgresql://localhost/db'")
    
    var port = getenv("PORT")
    print("  PORT =", port)
    if port != "8080":
        raise Error("Expected PORT='8080'")
    
    print("\n✓ All environment variables set correctly!")
    print("\n=== load_dotenv() test passed! ===")
