"""Simple example using mojo-dotenv."""

from dotenv import dotenv_values, load_dotenv
from os import getenv


fn main() raises:
    print("=" * 60)
    print("mojo-dotenv Example")
    print("=" * 60)
    print()
    
    # Example 1: Parse .env file without modifying environment
    print("1. Using dotenv_values() - parse without setting env vars:")
    print("-" * 60)
    
    var config = dotenv_values("tests/fixtures/basic.env")
    
    print("Parsed", len(config), "variables:")
    for item in config.items():
        print("  " + item.key + " = " + item.value)
    
    print()
    
    # Example 2: Load .env file into environment
    print("2. Using load_dotenv() - set environment variables:")
    print("-" * 60)
    
    var success = load_dotenv("tests/fixtures/basic.env")
    
    if success:
        print("✓ Loaded .env file successfully")
        print()
        print("Environment variables now accessible:")
        print("  DATABASE_URL =", getenv("DATABASE_URL"))
        print("  PORT =", getenv("PORT"))
        print("  DEBUG =", getenv("DEBUG"))
    else:
        print("✗ Failed to load .env file")
    
    print()
    print("=" * 60)
