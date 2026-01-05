"""Test Phase 3+ features: find_dotenv, inline comments, verbose, keys without ="""

from testing import assert_equal, assert_true
from dotenv import dotenv_values, find_dotenv


def test_inline_comments():
    """Test inline comment stripping."""
    var result = dotenv_values("tests/fixtures/inline_comments.env")
    assert_equal(result["KEY1"], "value1")


def test_keys_without_equals():
    """Test keys without = sign return empty string."""
    var result = dotenv_values("tests/fixtures/no_equals.env")
    assert_true(result.__contains__("JUST_A_KEY"), "Should parse standalone keys")
    assert_equal(result["JUST_A_KEY"], "")


def test_verbose_mode():
    """Test verbose mode executes without errors."""
    var result = dotenv_values("tests/fixtures/basic.env", verbose=True)
    assert_true(len(result) > 0, "Should parse values")


def test_find_dotenv():
    """Test find_dotenv() function."""
    # Test with non-existent file
    var not_found = find_dotenv("nonexistent_file_xyz.env")
    assert_equal(not_found, "")


def main():
    from testing import TestSuite
    var suite = TestSuite()
    suite.test[test_inline_comments]()
    suite.test[test_keys_without_equals]()
    suite.test[test_verbose_mode]()
    suite.test[test_find_dotenv]()
    suite^.run()
