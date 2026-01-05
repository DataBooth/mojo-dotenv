"""Test load_dotenv override parameter functionality."""

from testing import assert_equal
from dotenv import load_dotenv
from os import setenv, getenv, unsetenv


def test_override_false_preserves_existing():
    """Test that override=False preserves existing variables."""
    _ = setenv("PORT", "9999")
    _ = setenv("DEBUG", "false")
    _ = load_dotenv("tests/fixtures/basic.env", override=False)
    
    assert_equal(getenv("PORT"), "9999")
    assert_equal(getenv("DEBUG"), "false")


def test_override_true_replaces_existing():
    """Test that override=True replaces existing variables."""
    _ = setenv("PORT", "7777")
    _ = setenv("DEBUG", "maybe")
    _ = load_dotenv("tests/fixtures/basic.env", override=True)
    
    assert_equal(getenv("PORT"), "8080")
    assert_equal(getenv("DEBUG"), "true")


def test_new_variables_always_set():
    """Test that new variables are set regardless of override."""
    _ = unsetenv("KEY1")
    _ = load_dotenv("tests/fixtures/basic.env", override=False)
    
    assert_equal(getenv("KEY1"), "value1")


def test_verbose_mode_with_override_false():
    """Test verbose mode reports skipped variables."""
    _ = setenv("API_KEY", "existing_key")
    _ = load_dotenv("tests/fixtures/basic.env", override=False, verbose=True)
    
    assert_equal(getenv("API_KEY"), "existing_key")


def main():
    from testing import TestSuite
    var suite = TestSuite()
    suite.test[test_override_false_preserves_existing]()
    suite.test[test_override_true_replaces_existing]()
    suite.test[test_new_variables_always_set]()
    suite.test[test_verbose_mode_with_override_false]()
    suite^.run()
