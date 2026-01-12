"""Test handling of non-existent .env files."""

from testing import assert_equal, assert_true, assert_false
from dotenv import load_dotenv, dotenv_values, find_dotenv
from os import getenv, setenv


def test_load_dotenv_missing_file():
    """Test load_dotenv with non-existent file returns False."""
    var success = load_dotenv("tests/fixtures/does_not_exist.env")
    assert_false(success, "Should return False for non-existent file")


def test_load_dotenv_missing_file_verbose():
    """Test load_dotenv with non-existent file in verbose mode."""
    print("Expected output: '[dotenv] File not found: tests/fixtures/missing.env'")
    var success = load_dotenv("tests/fixtures/missing.env", verbose=True)
    assert_false(success, "Should return False for non-existent file")


def test_dotenv_values_missing_file_returns_empty():
    """Test dotenv_values with non-existent file returns empty dict."""
    print("Expected output: '[dotenv] WARNING: File not found: tests/fixtures/nonexistent.env (returning empty dict)'")
    var result = dotenv_values("tests/fixtures/nonexistent.env")
    assert_equal(len(result), 0, "Should return empty dict for non-existent file")


def test_find_dotenv_missing_raises():
    """Test find_dotenv with non-existent file raises when requested."""
    var raised = False
    try:
        _ = find_dotenv("absolutely_does_not_exist.env", raise_error_if_not_found=True)
    except:
        raised = True

    assert_true(raised, "Should raise error when raise_error_if_not_found=True")


def test_find_dotenv_missing_returns_empty():
    """Test find_dotenv with non-existent file returns empty string."""
    var result = find_dotenv("absolutely_does_not_exist.env", raise_error_if_not_found=False)
    assert_equal(result, "", "Should return empty string for non-existent file")


def test_load_dotenv_missing_does_not_affect_env():
    """Test that loading non-existent file doesn't affect existing environment."""
    # Set a known environment variable
    _ = setenv("TEST_EXISTING_VAR", "original_value")

    # Try to load non-existent file
    var success = load_dotenv("tests/fixtures/missing_file.env")
    assert_false(success, "Should return False")

    # Verify existing environment variable unchanged
    var value = getenv("TEST_EXISTING_VAR")
    assert_equal(value, "original_value", "Existing env var should be unchanged")


def test_load_dotenv_empty_path():
    """Test load_dotenv with empty path."""
    var success = load_dotenv("")
    assert_false(success, "Should return False for empty path")


def main():
    from testing import TestSuite
    var suite = TestSuite()
    suite.test[test_load_dotenv_missing_file]()
    suite.test[test_load_dotenv_missing_file_verbose]()
    suite.test[test_dotenv_values_missing_file_returns_empty]()
    suite.test[test_find_dotenv_missing_raises]()
    suite.test[test_find_dotenv_missing_returns_empty]()
    suite.test[test_load_dotenv_missing_does_not_affect_env]()
    suite.test[test_load_dotenv_empty_path]()
    suite^.run()
