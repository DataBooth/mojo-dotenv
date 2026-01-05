"""mojo-dotenv: .env file parsing for Mojo.

A modern implementation of .env file parsing for Mojo, compatible with python-dotenv.
"""

from pathlib import Path
from collections import Dict
from .parser import parse_dotenv
from .loader import load_dotenv
from .finder import find_dotenv


fn dotenv_values(dotenv_path: String, verbose: Bool = False) raises -> Dict[String, String]:
    """Parse a .env file and return its content as a dictionary.
    
    This function reads a .env file and returns a dictionary mapping
    environment variable names to their values. It does NOT modify
    the actual environment variables.
    
    Args:
        dotenv_path: Path to the .env file (absolute or relative).
        verbose: Print debug information during parsing (default: False).
        
    Returns:
        Dictionary mapping variable names to values.
        
    Raises:
        Error: If the file cannot be read.
        
    Examples:
        ```mojo
        from dotenv import dotenv_values
        
        var config = dotenv_values(".env")
        print(config["DATABASE_URL"])
        
        # With verbose output
        var config2 = dotenv_values(".env", verbose=True)
        ```
    """
    # Read the file content
    var path = Path(dotenv_path)
    var content = path.read_text()
    
    if verbose:
        print("[dotenv] Loading from: " + dotenv_path)
    
    # Parse and return
    return parse_dotenv(content, verbose)
