"""Test escape sequence support."""

from testing import assert_equal
from dotenv import dotenv_values


def test_escape_newline():
    """Test newline escape sequence."""
    var result = dotenv_values("tests/fixtures/escapes.env")
    assert_equal(result["NEWLINE"], "line1\nline2")


def test_escape_tab():
    """Test tab escape sequence."""
    var result = dotenv_values("tests/fixtures/escapes.env")
    assert_equal(result["TAB"], "col1\tcol2")


def test_escape_backslash():
    """Test backslash escape sequence."""
    var result = dotenv_values("tests/fixtures/escapes.env")
    assert_equal(result["BACKSLASH"], "path\\to\\file")


def test_escape_quote():
    """Test quote escape sequence."""
    var result = dotenv_values("tests/fixtures/escapes.env")
    assert_equal(result["QUOTE"], 'He said "hello"')


def test_unquoted_no_escapes():
    """Test that unquoted values don't process escapes."""
    var result = dotenv_values("tests/fixtures/escapes.env")
    assert_equal(result["UNQUOTED"], "no_escapes\\nhere")


def main():
    from testing import TestSuite
    var suite = TestSuite()
    suite.test[test_escape_newline]()
    suite.test[test_escape_tab]()
    suite.test[test_escape_backslash]()
    suite.test[test_escape_quote]()
    suite.test[test_unquoted_no_escapes]()
    suite^.run()
