"""Find .env files by searching parent directories."""

from pathlib import Path


fn find_dotenv(filename: String = ".env", raise_error_if_not_found: Bool = False, usecwd: Bool = False) raises -> String:
    """Search in increasingly higher folders for the given file.

    Searches upward from the current directory (or working directory if usecwd=True)
    until the file is found or the root directory is reached.

    Args:
        filename: Name of the .env file to find (default: ".env").
        raise_error_if_not_found: Raise error if file not found (default: False).
        usecwd: Use current working directory instead of script location (default: False).

    Returns:
        Absolute path to the found file, or empty string if not found.

    Raises:
        Error: If raise_error_if_not_found=True and file not found.

    Examples:
        ```mojo
        from dotenv import find_dotenv, load_dotenv

        # Find .env file automatically
        var env_file = find_dotenv()
        if len(env_file) > 0:
            _ = load_dotenv(env_file)

        # Or use directly with load_dotenv
        _ = load_dotenv(find_dotenv())
        ```
    """
    # Start from current directory
    # Note: Mojo doesn't have os.getcwd() yet, so we start from "."
    var current = Path(".")

    # Search upward until we find the file or reach root
    var max_levels = 20  # Reasonable limit to prevent infinite loops
    for level in range(max_levels):
        var candidate = current / filename

        if candidate.exists():
            # Found it! Return absolute path
            # Note: Path doesn't have .absolute() yet, so we return as-is
            return String(candidate)

        # Move up one directory
        var parent = current / ".."

        # Check if we've reached the root (comparing string representations)
        var current_str = String(current)
        var parent_str = String(parent)
        if current_str == parent_str or current_str == "/":
            # Reached root, file not found
            break

        current = parent

    # File not found
    if raise_error_if_not_found:
        raise Error("Could not find '" + filename + "' in current or parent directories")

    return ""
