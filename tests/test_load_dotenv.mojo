"""Test load_dotenv functionality."""

from testing import assert_equal, assert_true
from dotenv import load_dotenv
from os import getenv


def test_load_dotenv_basic():
    """Test loading .env file into environment."""
    var success = load_dotenv("tests/fixtures/basic.env")
    assert_true(success, "Failed to load .env file")
    
    # Check that environment variables were set
    assert_equal(getenv("KEY1"), "value1")
    assert_equal(getenv("DATABASE_URL"), "postgresql://localhost/db")
    assert_equal(getenv("PORT"), "8080")


def main():
    from testing import TestSuite
    var suite = TestSuite()
    suite.test[test_load_dotenv_basic]()
    suite^.run()
