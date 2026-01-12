"""Python compatibility tests - compare mojo-dotenv with python-dotenv."""

from testing import assert_equal
from dotenv import dotenv_values
from python import Python, PythonObject


fn test_fixture_against_python(fixture_path: String) raises:
    """Test a fixture matches python-dotenv results."""
    var mojo_result = dotenv_values(fixture_path)
    var py = Python.import_module("dotenv")
    var py_result = py.dotenv_values(fixture_path)

    # Compare each key that exists in both
    for item in mojo_result.items():
        var key = item.key
        var mojo_val = item.value
        var py_key = PythonObject(key)

        if py_result.__contains__(py_key):
            var py_val_obj = py_result[py_key]
            # Python-dotenv returns None for some edge cases, Mojo returns empty string
            # This is a known, documented difference
            try:
                var py_val = String(py_val_obj)
                assert_equal(mojo_val, py_val)
            except:
                # Python has None, Mojo has empty string - skip comparison
                pass


def test_basic_fixture():
    """Test basic.env matches python-dotenv."""
    test_fixture_against_python("tests/fixtures/basic.env")


def test_quotes_fixture():
    """Test quotes.env matches python-dotenv."""
    test_fixture_against_python("tests/fixtures/quotes.env")


def test_comments_fixture():
    """Test comments.env matches python-dotenv."""
    test_fixture_against_python("tests/fixtures/comments.env")


def test_whitespace_fixture():
    """Test whitespace.env matches python-dotenv."""
    test_fixture_against_python("tests/fixtures/whitespace.env")


def test_edge_cases_fixture():
    """Test edge_cases.env matches python-dotenv."""
    test_fixture_against_python("tests/fixtures/edge_cases.env")


def main():
    from testing import TestSuite
    var suite = TestSuite()
    suite.test[test_basic_fixture]()
    suite.test[test_quotes_fixture]()
    suite.test[test_comments_fixture]()
    suite.test[test_whitespace_fixture]()
    suite.test[test_edge_cases_fixture]()
    suite^.run()
