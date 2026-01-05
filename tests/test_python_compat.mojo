"""Python compatibility tests - compare mojo-dotenv with python-dotenv."""

from dotenv import dotenv_values
from python import Python, PythonObject


fn compare_results(mojo_result: Dict[String, String], py_result: PythonObject, fixture_name: String) raises:
    """Compare Mojo and Python results for a fixture."""
    print("  Comparing", fixture_name, "...")
    
    var py_len = len(py_result)
    var mojo_len = len(mojo_result)
    
    if mojo_len != py_len:
        print("    ⚠️  Key count mismatch: Mojo=" + String(mojo_len) + ", Python=" + String(py_len))
    
    var matches = 0
    var mismatches = 0
    
    # Compare Mojo keys against Python
    for item in mojo_result.items():
        var key = item.key
        var mojo_val = item.value
        var py_key = PythonObject(key)
        
        if py_result.__contains__(py_key):
            var py_val = String(py_result[py_key])
            
            if mojo_val == py_val:
                matches += 1
                print("    ✓", key, "=", repr(mojo_val))
            else:
                mismatches += 1
                print("    ✗", key, "mismatch:")
                print("      Mojo:  ", repr(mojo_val))
                print("      Python:", repr(py_val))
        else:
            mismatches += 1
            print("    ✗", key, "not in Python result")
    
    print("    Matches:", matches, "| Mismatches:", mismatches)
    
    if mismatches > 0:
        print("    ⚠️  Some differences found\n")
    else:
        print("    ✓ Perfect match!\n")


fn test_fixture(fixture_path: String, fixture_name: String) raises:
    """Test a single fixture against python-dotenv."""
    print("\n" + fixture_name + ":")
    print("  " + "=" * 50)
    
    # Mojo version
    var mojo_result = dotenv_values(fixture_path)
    
    # Python version
    var py = Python.import_module("dotenv")
    var py_result = py.dotenv_values(fixture_path)
    
    # Compare
    compare_results(mojo_result, py_result, fixture_name)


fn main() raises:
    print("=" * 60)
    print("Python Compatibility Test")
    print("Comparing mojo-dotenv vs python-dotenv")
    print("=" * 60)
    
    # Test all fixtures
    test_fixture("tests/fixtures/basic.env", "basic.env")
    test_fixture("tests/fixtures/quotes.env", "quotes.env")
    test_fixture("tests/fixtures/comments.env", "comments.env")
    test_fixture("tests/fixtures/whitespace.env", "whitespace.env")
    test_fixture("tests/fixtures/edge_cases.env", "edge_cases.env")
    
    print("\n" + "=" * 60)
    print("Compatibility test complete!")
    print("=" * 60)
