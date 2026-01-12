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

    If the file does not exist, returns an empty dictionary and prints a warning.
    This matches python-dotenv behavior (empty dict) but adds visibility.

    Args:
        dotenv_path: Path to the .env file (absolute or relative).
        verbose: Print debug information during parsing (default: False).

    Returns:
        Dictionary mapping variable names to values. Empty dict if file not found.

    Examples:
        ```mojo
        from dotenv import dotenv_values

        var config = dotenv_values(".env")
        if "DATABASE_URL" in config:
            print(config["DATABASE_URL"])

        # With verbose output
        var config2 = dotenv_values(".env", verbose=True)
        ```
    """
    # Check if file exists
    var path = Path(dotenv_path)
    if not path.exists():
        print("[dotenv] WARNING: File not found: " + dotenv_path + " (returning empty dict)")
        return Dict[String, String]()

    # Read the file content
    var content = path.read_text()

    if verbose:
        print("[dotenv] Loading from: " + dotenv_path)

    # Parse and return
    return parse_dotenv(content, verbose)
