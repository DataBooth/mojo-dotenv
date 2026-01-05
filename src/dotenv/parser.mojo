"""Parser for .env file format.

This module provides functions to parse .env file lines and extract key-value pairs.
"""

from collections import Dict, Optional
from os import getenv


fn count_trailing_backslashes(text: String, end_pos: Int) -> Int:
    """Count consecutive backslashes before the given position.
    
    Args:
        text: String to examine.
        end_pos: Position to count backwards from (exclusive).
        
    Returns:
        Number of consecutive backslashes.
    """
    var count = 0
    var idx = end_pos - 1
    while idx >= 0 and text[idx] == "\\":
        count += 1
        idx -= 1
    return count


fn lookup_variable(var_name: String, env_dict: Dict[String, String], fallback_literal: String) raises -> String:
    """Look up a variable in env_dict, then system environment, else return literal.
    
    Args:
        var_name: Variable name to look up.
        env_dict: Dictionary of parsed variables.
        fallback_literal: Literal string to return if variable not found.
        
    Returns:
        Variable value or fallback literal.
    """
    if env_dict.__contains__(var_name):
        return env_dict[var_name]
    
    var sys_val = getenv(var_name)
    if len(sys_val) > 0:
        return sys_val
    
    return fallback_literal


fn strip_inline_comment(line: String) -> String:
    """Strip inline comments from a line.
    
    Handles # comments after values, but not within quotes.
    
    Args:
        line: Line potentially containing inline comment.
        
    Returns:
        Line with inline comment removed.
    """
    var in_single_quote = False
    var in_double_quote = False
    var escaped = False
    
    for i in range(len(line)):
        var c = line[i]
        
        if escaped:
            escaped = False
            continue
        
        if c == "\\":
            escaped = True
            continue
        
        if c == "'" and not in_double_quote:
            in_single_quote = not in_single_quote
        elif c == '"' and not in_single_quote:
            in_double_quote = not in_double_quote
        elif c == "#" and not in_single_quote and not in_double_quote:
            # Found unquoted comment
            return String(line[:i])
    
    return line


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
                    result += lookup_variable(var_name, env_dict, String(value[i:closing + 1]))
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
                    result += lookup_variable(var_name, env_dict, String(value[i:var_end]))
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


fn parse_line(line: String, verbose: Bool = False) -> Optional[Tuple[String, String]]:
    """Parse a single line from a .env file.
    
    Handles:
    - KEY=value format
    - export KEY=value format (strips 'export ' prefix)
    - Comments (lines starting with #)
    - Inline comments (# after value)
    - Blank lines
    - Whitespace trimming
    - Quote stripping
    
    Args:
        line: A single line from a .env file.
        verbose: Print debug information during parsing.
        
    Returns:
        Optional tuple of (key, value), or None if line should be ignored.
    """
    var stripped = String(line.strip())
    
    # Ignore empty lines
    if len(stripped) == 0:
        return None
    
    # Ignore full-line comments
    if stripped.startswith("#"):
        return None
    
    # Strip inline comments (after checking for full-line comments)
    stripped = strip_inline_comment(stripped)
    
    # Strip 'export ' prefix if present
    if stripped.startswith("export "):
        stripped = String(String(stripped[7:]).strip())
    
    # Split on first '=' only
    var parts = stripped.split("=", 1)
    
    # Line without '=' - treat as key with empty value
    if len(parts) != 2:
        # python-dotenv treats this as key with None value
        # We'll use empty string (Mojo Dict doesn't support None values easily)
        if len(parts) == 1 and len(parts[0].strip()) > 0:
            var key = String(parts[0].strip())
            if verbose:
                print("[dotenv] Key without value: " + key + " (using empty string)")
            return (key, "")
        return None
    
    var key = String(parts[0].strip())
    var value = String(parts[1].strip())
    
    # Strip quotes from value
    value = strip_quotes(value)
    
    # Empty key is invalid
    if len(key) == 0:
        return None
    
    return (key, value)


fn parse_dotenv(content: String, verbose: Bool = False) raises -> Dict[String, String]:
    """Parse the entire content of a .env file.
    
    Performs two passes:
    1. Parse all lines to extract key-value pairs (handles multiline values)
    2. Expand variable references in values
    
    Args:
        content: The complete content of a .env file.
        verbose: Print debug information during parsing.
        
    Returns:
        Dictionary mapping environment variable names to values.
    """
    var result = Dict[String, String]()
    var lines = content.split("\n")
    
    # First pass: parse all lines, handling multiline values
    var i = 0
    while i < len(lines):
        var line = String(lines[i])
        
        # Check if line starts a quoted value that may span multiple lines
        var stripped = String(line.strip())
        if len(stripped) > 0 and not stripped.startswith("#"):
            # Strip export prefix if present
            if stripped.startswith("export "):
                stripped = String(String(stripped[7:]).strip())
            
            # Check for KEY= pattern
            var parts = stripped.split("=", 1)
            if len(parts) == 2:
                var key = String(parts[0].strip())
                var value_part = String(parts[1].strip())
                
                # Check if value starts with quote
                if len(value_part) > 0 and (value_part[0] == '"' or value_part[0] == "'"):
                    var quote_char = value_part[0]
                    var value_len = len(value_part)
                    
                    # Check if quote is closed on same line
                    var closed = False
                    if value_len > 1 and value_part[value_len - 1] == quote_char:
                        # Even number (or 0) of backslashes means quote is not escaped
                        if count_trailing_backslashes(value_part, value_len - 1) % 2 == 0:
                            closed = True
                    
                    if not closed:
                        # Multiline value - collect until closing quote
                        var full_value = value_part
                        i += 1
                        while i < len(lines):
                            var next_line = String(lines[i])
                            full_value += "\n" + next_line
                            
                            # Check if this line closes the quote
                            var next_len = len(next_line)
                            if next_len > 0 and next_line[next_len - 1] == quote_char:
                                # Even number (or 0) of backslashes means quote is not escaped
                                if count_trailing_backslashes(next_line, next_len - 1) % 2 == 0:
                                    break
                            i += 1
                        
                        # Parse the complete multiline value
                        var complete_line = key + "=" + full_value
                        var parsed = parse_line(complete_line, verbose)
                        if parsed:
                            var pair = parsed.value()
                            result[pair[0]] = pair[1]
                            if verbose:
                                print("[dotenv] Parsed multiline: " + key)
                    else:
                        # Single line value
                        var parsed = parse_line(line, verbose)
                        if parsed:
                            var pair = parsed.value()
                            result[pair[0]] = pair[1]
                else:
                    # Unquoted value
                    var parsed = parse_line(line, verbose)
                    if parsed:
                        var pair = parsed.value()
                        result[pair[0]] = pair[1]
            else:
                # No '=' sign - might be a standalone key
                var parsed = parse_line(line, verbose)
                if parsed:
                    var pair = parsed.value()
                    result[pair[0]] = pair[1]
        
        i += 1
    
    # Second pass: expand variables
    var expanded = Dict[String, String]()
    for item in result.items():
        var key = item.key
        var value = item.value
        expanded[key] = expand_variables(value, result)
    
    return expanded^
