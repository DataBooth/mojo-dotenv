"""Test multiline value support."""

from testing import assert_equal, assert_true
from dotenv import dotenv_values


def test_single_line_baseline():
    """Test single line value (baseline)."""
    var result = dotenv_values("tests/fixtures/multiline.env")
    assert_equal(result["SINGLE_LINE"], "single line")


def test_multiline_double_quotes():
    """Test multiline value with double quotes."""
    var result = dotenv_values("tests/fixtures/multiline.env")
    var multiline_double = result["MULTILINE_DOUBLE"]
    assert_true("\n" in multiline_double, "Should contain newlines")
    var lines = multiline_double.split("\n")
    assert_equal(len(lines), 3)


def test_multiline_single_quotes():
    """Test multiline value with single quotes."""
    var result = dotenv_values("tests/fixtures/multiline.env")
    var multiline_single = result["MULTILINE_SINGLE"]
    assert_true("\n" in multiline_single, "Should contain newlines")
    var single_lines = multiline_single.split("\n")
    assert_equal(len(single_lines), 3)


def test_json_multiline():
    """Test JSON-like multiline value."""
    var result = dotenv_values("tests/fixtures/multiline.env")
    var json = result["JSON"]
    assert_true("name" in json, "JSON should contain 'name'")
    assert_true("value" in json, "JSON should contain 'value'")


def test_parsing_continues_after_multiline():
    """Test that parsing continues correctly after multiline values."""
    var result = dotenv_values("tests/fixtures/multiline.env")
    assert_equal(result["AFTER_MULTILINE"], "after_value")


def main():
    from testing import TestSuite
    var suite = TestSuite()
    suite.test[test_single_line_baseline]()
    suite.test[test_multiline_double_quotes]()
    suite.test[test_multiline_single_quotes]()
    suite.test[test_json_multiline]()
    suite.test[test_parsing_continues_after_multiline]()
    suite^.run()
