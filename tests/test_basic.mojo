"""Basic tests for mojo-dotenv."""

from testing import assert_equal
from dotenv import dotenv_values


def test_basic_parsing():
    """Test basic KEY=value parsing."""
    var result = dotenv_values("tests/fixtures/basic.env")

    # Basic assertions
    assert_equal(result["KEY1"], "value1")
    assert_equal(result["KEY2"], "value2")
    assert_equal(result["DATABASE_URL"], "postgresql://localhost/db")
    assert_equal(result["PORT"], "8080")


def test_quotes():
    """Test quote stripping."""
    var result = dotenv_values("tests/fixtures/quotes.env")

    assert_equal(result["SINGLE"], "single quoted value")
    assert_equal(result["DOUBLE"], "double quoted value")
    assert_equal(result["MIXED"], 'has "inner" quotes')


def test_comments():
    """Test comment handling."""
    var result = dotenv_values("tests/fixtures/comments.env")

    assert_equal(result["KEY1"], "value1")
    assert_equal(result["KEY2"], "value2")
    assert_equal(result["KEY3"], "value3")


def test_whitespace():
    """Test whitespace trimming."""
    var result = dotenv_values("tests/fixtures/whitespace.env")

    assert_equal(result["KEY1"], "value1")
    assert_equal(result["KEY2"], "value2")


def main():
    from testing import TestSuite
    var suite = TestSuite()
    suite.test[test_basic_parsing]()
    suite.test[test_quotes]()
    suite.test[test_comments]()
    suite.test[test_whitespace]()
    suite^.run()
