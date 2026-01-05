"""Parser for .env file format.

This module provides functions to parse .env file lines and extract key-value pairs.
"""

from collections import Dict, Optional


fn process_escapes(value: String) -> String:
    """Process escape sequences in a string.
    
    Handles:
    - \n -> newline
    - \t -> tab
    - \\ -> backslash
    - \" -> double quote
    - \' -> single quote
    
    Args:
        value: String potentially containing escape sequences.
        
    Returns:
        String with escape sequences processed.
    """
    var result = String("")
    var i = 0
    var len_val = len(value)
    
    while i < len_val:
        if value[i] == "\\" and i + 1 < len_val:
            # Escape sequence found
            var next_char = value[i + 1]
            if next_char == "n":
                result += "\n"
                i += 2
            elif next_char == "t":
                result += "\t"
                i += 2
            elif next_char == "\\":
                result += "\\"
                i += 2
            elif next_char == '"':
                result += '"'
                i += 2
            elif next_char == "'":
                result += "'"
                i += 2
            else:
                # Unknown escape, keep backslash
                result += String(value[i])
                i += 1
        else:
            result += String(value[i])
            i += 1
    
    return result


fn strip_quotes(value: String) -> String:
    """Strip outer quotes (single or double) from a value and process escapes.
    
    Args:
        value: The string to strip quotes from.
        
    Returns:
        The string with outer quotes removed and escape sequences processed.
    """
    var v = value.strip()
    var v_len = len(v)
    
    if v_len < 2:
        return String(v)
    
    # Check for matching outer quotes
    var unquoted: String
    if (v[0] == "'" and v[v_len - 1] == "'") or (v[0] == '"' and v[v_len - 1] == '"'):
        unquoted = String(v[1:v_len - 1])
        # Process escape sequences only within quoted strings
        return process_escapes(unquoted)
    
    return String(v)


fn parse_line(line: String) -> Optional[Tuple[String, String]]:
    """Parse a single line from a .env file.
    
    Handles:
    - KEY=value format
    - export KEY=value format (strips 'export ' prefix)
    - Comments (lines starting with #)
    - Blank lines
    - Whitespace trimming
    - Quote stripping
    
    Args:
        line: A single line from a .env file.
        
    Returns:
        Optional tuple of (key, value), or None if line should be ignored.
    """
    var stripped = String(line.strip())
    
    # Ignore empty lines
    if len(stripped) == 0:
        return None
    
    # Ignore comments
    if stripped.startswith("#"):
        return None
    
    # Strip 'export ' prefix if present
    if stripped.startswith("export "):
        stripped = String(String(stripped[7:]).strip())  # Remove 'export ' and trim
    
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
