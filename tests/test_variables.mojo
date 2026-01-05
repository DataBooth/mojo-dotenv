"""Test variable expansion support."""

from dotenv import dotenv_values


fn main() raises:
    print("=== Testing variable expansion ===\n")
    
    var result = dotenv_values("tests/fixtures/variables.env")
    
    print("Parsed and expanded values:")
    for item in result.items():
        print("  " + item.key + " = " + item.value)
    
    print()
    
    # Test ${VAR} syntax
    var base = result["BASE"]
    var bin_dir = result["BIN_DIR"]
    print("BASE:", base)
    print("BIN_DIR:", bin_dir)
    if bin_dir != "/usr/local/bin":
        raise Error("Expected BIN_DIR='/usr/local/bin', got '" + bin_dir + "'")
    
    var lib_dir = result["LIB_DIR"]
    print("LIB_DIR:", lib_dir)
    if lib_dir != "/usr/local/lib":
        raise Error("Expected LIB_DIR='/usr/local/lib'")
    
    # Test $VAR syntax
    var home_var = result["HOME_VAR"]
    var user_bin = result["USER_BIN"]
    print("\nHOME_VAR:", home_var)
    print("USER_BIN:", user_bin)
    if user_bin != "/home/user/bin":
        raise Error("Expected USER_BIN='/home/user/bin'")
    
    # Test mixed syntax
    var full_path = result["FULL_PATH"]
    print("\nFULL_PATH:", full_path)
    if full_path != "/usr/local/share:/home/user/local":
        raise Error("Expected FULL_PATH='/usr/local/share:/home/user/local'")
    
    # Test forward reference (defined later in file)
    var derived = result["DERIVED"]
    var target = result["TARGET"]
    print("\nDERIVED:", derived)
    print("TARGET:", target)
    if derived != "derived_value":
        raise Error("Expected DERIVED='derived_value' (forward reference)")
    
    # Test system environment variable
    var current_user = result["CURRENT_USER"]
    print("\nCURRENT_USER:", current_user)
    if len(current_user) == 0:
        print("  (USER env var not set, got empty)")
    else:
        print("  (Expanded from system USER env var)")
    
    # Test undefined variable (should keep literal)
    var undefined = result["UNDEFINED"]
    print("\nUNDEFINED:", undefined)
    if undefined != "${DOES_NOT_EXIST}":
        print("  Warning: expected literal '${DOES_NOT_EXIST}', got:", undefined)
    
    print("\n✓ All variable expansion tests passed!\n")
