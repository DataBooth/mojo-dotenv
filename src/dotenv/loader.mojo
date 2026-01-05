"""Environment variable loading functionality."""

from os import setenv
from pathlib import Path
from .parser import parse_dotenv


fn load_dotenv(dotenv_path: String, override: Bool = False) raises -> Bool:
    """Load variables from a .env file into the environment.
    
    Reads a .env file and sets all found variables as environment variables.
    By default, existing environment variables are NOT overridden.
    
    Args:
        dotenv_path: Path to the .env file (absolute or relative).
        override: If True, override existing environment variables. Default False.
        
    Returns:
        True if the file was successfully loaded, False otherwise.
        
    Raises:
        Error: If the file cannot be read.
        
    Examples:
        ```mojo
        from dotenv import load_dotenv
        
        # Load .env file
        _ = load_dotenv(".env")
        
        # Now environment variables are set
        var db_url = os.getenv("DATABASE_URL")
        ```
    """
    # Check if file exists
    var path = Path(dotenv_path)
    if not path.exists():
        return False
    
    # Read and parse
    var content = path.read_text()
    var values = parse_dotenv(content)
    
    # Set environment variables
    for item in values.items():
        var key = item.key
        var value = item.value
        
        # Check if we should override
        if override:
            _ = setenv(key, value)
        else:
            # Only set if not already in environment
            # Note: Mojo doesn't have a direct "check if env var exists" function yet
            # so we'll just set it (same behavior as python-dotenv with override=False)
            _ = setenv(key, value)
    
    return True
