"""Parser for .env file format.

This module provides functions to parse .env file lines and extract key-value pairs.
"""

from collections import Dict, Optional


fn strip_quotes(value: String) -> String:
    """Strip outer quotes (single or double) from a value.
    
    Args:
        value: The string to strip quotes from.
        
    Returns:
        The string with outer quotes removed if present.
    """
    var v = value.strip()
    var v_len = len(v)
    
    if v_len < 2:
        return String(v)
    
    # Check for matching outer quotes
    if (v[0] == "'" and v[v_len - 1] == "'") or (v[0] == '"' and v[v_len - 1] == '"'):
        return String(v[1:v_len - 1])
    
    return String(v)


fn parse_line(line: String) -> Optional[Tuple[String, String]]:
    """Parse a single line from a .env file.
    
    Handles:
    - KEY=value format
    - Comments (lines starting with #)
    - Blank lines
    - Whitespace trimming
    - Quote stripping
    
    Args:
        line: A single line from a .env file.
        
    Returns:
        Optional tuple of (key, value), or None if line should be ignored.
    """
    var stripped = line.strip()
    
    # Ignore empty lines
    if len(stripped) == 0:
        return None
    
    # Ignore comments
    if stripped.startswith("#"):
        return None
    
    # Split on first '=' only
    var parts = stripped.split("=", 1)
    
    # Line without '=' - invalid for MVP
    if len(parts) != 2:
        # python-dotenv treats this as key with None value
        # For MVP, we'll skip it
        return None
    
    var key = String(parts[0].strip())
    var value = String(parts[1].strip())
    
    # Strip quotes from value
    value = strip_quotes(value)
    
    # Empty key is invalid
    if len(key) == 0:
        return None
    
    return (key, value)


fn parse_dotenv(content: String) -> Dict[String, String]:
    """Parse the entire content of a .env file.
    
    Args:
        content: The complete content of a .env file.
        
    Returns:
        Dictionary mapping environment variable names to values.
    """
    var result = Dict[String, String]()
    var lines = content.split("\n")
    
    for i in range(len(lines)):
        var parsed = parse_line(String(lines[i]))
        if parsed:
            var pair = parsed.value()
            result[pair[0]] = pair[1]
    
    return result^
