"""Test helper functions and edge cases."""

from testing import assert_equal, assert_true
from dotenv import dotenv_values, find_dotenv
from pathlib import Path


def test_backslash_counting():
    """Test backslash counting in multiline parsing."""
    var result = dotenv_values("tests/fixtures/escapes.env")
    assert_true("UNQUOTED" in result, "Should not consume next line")


def test_undefined_variables_remain_literal():
    """Test undefined variables remain as literals."""
    var result = dotenv_values("tests/fixtures/variables.env")
    assert_equal(result["UNDEFINED"], "${DOES_NOT_EXIST}")


def test_find_dotenv_nonexistent():
    """Test find_dotenv returns empty for non-existent file."""
    var not_found = find_dotenv("nonexistent.env", raise_error_if_not_found=False)
    assert_equal(not_found, "")


def test_verbose_mode():
    """Test verbose mode works."""
    var result = dotenv_values("tests/fixtures/basic.env", verbose=True)
    assert_true(len(result) > 0, "Should parse values")


def test_keys_without_equals():
    """Test keys without '=' return empty string."""
    var result = dotenv_values("tests/fixtures/no_equals.env")
    assert_true("JUST_A_KEY" in result, "Should parse standalone key")
    assert_equal(result["JUST_A_KEY"], "")
    assert_equal(result["NORMAL_KEY"], "normal_value")


def test_empty_file():
    """Test empty file handling."""
    var empty_path = "/tmp/empty_test.env"
    with open(empty_path, "w") as f:
        pass

    var result = dotenv_values(empty_path)
    assert_equal(len(result), 0)


def test_comments_only_file():
    """Test file with only comments."""
    var comments_path = "/tmp/comments_only.env"
    with open(comments_path, "w") as f:
        f.write("# Just a comment\n")
        f.write("  # Another comment\n")
        f.write("\n")
        f.write("# More comments\n")

    var result = dotenv_values(comments_path)
    assert_equal(len(result), 0)


def test_inline_comments_respect_quotes():
    """Test inline comments respect quoted values."""
    var inline_path = "/tmp/inline_test.env"
    with open(inline_path, "w") as f:
        f.write('QUOTED="value # not a comment"\n')
        f.write('UNQUOTED=value # this is a comment\n')

    var result = dotenv_values(inline_path)
    assert_equal(result["QUOTED"], "value # not a comment")
    assert_equal(result["UNQUOTED"], "value")


def main():
    from testing import TestSuite
    var suite = TestSuite()
    suite.test[test_backslash_counting]()
    suite.test[test_undefined_variables_remain_literal]()
    suite.test[test_find_dotenv_nonexistent]()
    suite.test[test_verbose_mode]()
    suite.test[test_keys_without_equals]()
    suite.test[test_empty_file]()
    suite.test[test_comments_only_file]()
    suite.test[test_inline_comments_respect_quotes]()
    suite^.run()
