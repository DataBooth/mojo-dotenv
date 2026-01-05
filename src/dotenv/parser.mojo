"""Parser for .env file format.

This module provides functions to parse .env file lines and extract key-value pairs.
"""

from collections import Dict, Optional
from os import getenv


fn expand_variables(value: String, env_dict: Dict[String, String]) raises -> String:
    """Expand variable references in a value.
    
    Supports:
    - ${VAR} syntax
    - $VAR syntax (simple form)
    - Falls back to system environment if not in env_dict
    - Leaves unexpanded if variable not found
    
    Args:
        value: String potentially containing variable references.
        env_dict: Dictionary of already-parsed variables.
        
    Returns:
        String with variables expanded.
    """
    var result = String("")
    var i = 0
    var len_val = len(value)
    
    while i < len_val:
        if value[i] == "$":
            if i + 1 < len_val and value[i + 1] == "{":
                # ${VAR} syntax
                var closing = -1
                for j in range(i + 2, len_val):
                    if value[j] == "}":
                        closing = j
                        break
                
                if closing != -1:
                    var var_name = String(value[i + 2:closing])
                    # Try env_dict first, then system environment
                    if env_dict.__contains__(var_name):
                        result += String(env_dict[var_name])
                    else:
                        var sys_val = getenv(var_name)
                        if len(sys_val) > 0:
                            result += sys_val
                        else:
                            # Variable not found, keep literal
                            result += String(value[i:closing + 1])
                    i = closing + 1
                else:
                    # No closing brace, keep literal
                    result += String(value[i])
                    i += 1
            elif i + 1 < len_val:
                # Check if next char starts a variable name (letter or underscore)
                var next_char = value[i + 1]
                if (next_char >= "A" and next_char <= "Z") or (next_char >= "a" and next_char <= "z") or next_char == "_":
                    # $VAR syntax (simple form)
                    var var_end = i + 1
                    while var_end < len_val:
                        var c = value[var_end]
                        if not ((c >= "A" and c <= "Z") or (c >= "a" and c <= "z") or (c >= "0" and c <= "9") or c == "_"):
                            break
                        var_end += 1
                    
                    var var_name = String(value[i + 1:var_end])
                    # Try env_dict first, then system environment
                    if env_dict.__contains__(var_name):
                        result += String(env_dict[var_name])
                    else:
                        var sys_val = getenv(var_name)
                        if len(sys_val) > 0:
                            result += sys_val
                        else:
                            # Variable not found, keep literal
                            result += String(value[i:var_end])
                    i = var_end
                else:
                    # Not a variable name, just a dollar sign
                    result += String(value[i])
                    i += 1
            else:
                # Just a dollar sign
                result += String(value[i])
                i += 1
        else:
            result += String(value[i])
            i += 1
    
    return result


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


fn parse_dotenv(content: String) raises -> Dict[String, String]:
    """Parse the entire content of a .env file.
    
    Performs two passes:
    1. Parse all lines to extract key-value pairs
    2. Expand variable references in values
    
    Args:
        content: The complete content of a .env file.
        
    Returns:
        Dictionary mapping environment variable names to values.
    """
    var result = Dict[String, String]()
    var lines = content.split("\n")
    
    # First pass: parse all lines
    for i in range(len(lines)):
        var parsed = parse_line(String(lines[i]))
        if parsed:
            var pair = parsed.value()
            result[pair[0]] = pair[1]
    
    # Second pass: expand variables
    var expanded = Dict[String, String]()
    for item in result.items():
        var key = item.key
        var value = item.value
        expanded[key] = expand_variables(value, result)
    
    return expanded^
