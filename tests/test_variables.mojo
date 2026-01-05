"""Test variable expansion support."""

from testing import assert_equal, assert_true
from dotenv import dotenv_values


def test_variable_expansion_brace_syntax():
    """Test ${VAR} syntax expansion."""
    var result = dotenv_values("tests/fixtures/variables.env")
    assert_equal(result["BIN_DIR"], "/usr/local/bin")
    assert_equal(result["LIB_DIR"], "/usr/local/lib")


def test_variable_expansion_dollar_syntax():
    """Test $VAR syntax expansion."""
    var result = dotenv_values("tests/fixtures/variables.env")
    assert_equal(result["USER_BIN"], "/home/user/bin")


def test_variable_expansion_mixed():
    """Test mixed ${VAR} and $VAR syntax."""
    var result = dotenv_values("tests/fixtures/variables.env")
    assert_equal(result["FULL_PATH"], "/usr/local/share:/home/user/local")


def test_variable_forward_reference():
    """Test forward reference (variable defined later in file)."""
    var result = dotenv_values("tests/fixtures/variables.env")
    assert_equal(result["DERIVED"], "derived_value")
    assert_equal(result["TARGET"], "derived_value")


def test_undefined_variable_literal():
    """Test that undefined variables remain literal."""
    var result = dotenv_values("tests/fixtures/variables.env")
    assert_equal(result["UNDEFINED"], "${DOES_NOT_EXIST}")


def main():
    from testing import TestSuite
    var suite = TestSuite()
    suite.test[test_variable_expansion_brace_syntax]()
    suite.test[test_variable_expansion_dollar_syntax]()
    suite.test[test_variable_expansion_mixed]()
    suite.test[test_variable_forward_reference]()
    suite.test[test_undefined_variable_literal]()
    suite^.run()
