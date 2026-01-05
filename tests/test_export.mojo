"""Test export prefix support."""

from testing import assert_equal
from dotenv import dotenv_values


def test_export_prefix():
    """Test that export prefix is stripped correctly."""
    var result = dotenv_values("tests/fixtures/export.env")
    
    assert_equal(result["KEY1"], "value1")
    assert_equal(result["KEY2"], "quoted value")
    assert_equal(result["KEY3"], "no_export")
    assert_equal(result["KEY4"], "extra_spaces")
    assert_equal(result["KEY5"], "single quotes")


def main():
    from testing import TestSuite
    var suite = TestSuite()
    suite.test[test_export_prefix]()
    suite^.run()
