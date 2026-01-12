"""Environment variable loading functionality."""

from os import setenv, getenv
from pathlib import Path
from .parser import parse_dotenv


fn load_dotenv(dotenv_path: String, override: Bool = False, verbose: Bool = False) raises -> Bool:
    """Load variables from a .env file into the environment.

    Reads a .env file and sets all found variables as environment variables.
    By default, existing environment variables are NOT overridden.

    Args:
        dotenv_path: Path to the .env file (absolute or relative).
        override: If True, override existing environment variables. Default False.
        verbose: Print debug information during loading. Default False.

    Returns:
        True if the file was successfully loaded, False otherwise.

    Raises:
        Error: If the file cannot be read.

    Examples:
        ```mojo
        from dotenv import load_dotenv

        # Load .env file
        _ = load_dotenv(".env")

        # With verbose output
        _ = load_dotenv(".env", verbose=True)

        # Now environment variables are set
        var db_url = os.getenv("DATABASE_URL")
        ```
    """
    # Check if file exists
    var path = Path(dotenv_path)
    if not path.exists():
        if verbose:
            print("[dotenv] File not found: " + dotenv_path)
        return False

    if verbose:
        print("[dotenv] Loading from: " + dotenv_path)

    # Read and parse
    var content = path.read_text()
    var values = parse_dotenv(content, verbose)

    # Set environment variables
    var count = 0
    for item in values.items():
        var key = item.key
        var value = item.value

        # Check if we should override
        if override:
            _ = setenv(key, value)
            count += 1
        else:
            # Only set if not already in environment
            var existing = getenv(key)
            if len(existing) == 0:
                _ = setenv(key, value)
                count += 1
            elif verbose:
                print("[dotenv] Skipping existing var: " + key)

    if verbose:
        print("[dotenv] Loaded " + String(count) + " variables")

    return True
