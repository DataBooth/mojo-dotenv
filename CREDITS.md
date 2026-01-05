# Credits & Acknowledgments

## Inspiration & Prior Art

### python-dotenv
- **Repository**: https://github.com/theskumar/python-dotenv
- **Author**: Saurabh Kumar and contributors
- **Role**: Reference implementation and compatibility target

`mojo-dotenv` is designed to be compatible with python-dotenv's API and behaviour. We use python-dotenv as our reference implementation for testing and validation. The .env file format, parsing rules, and API design are heavily inspired by python-dotenv's excellent work.

**Compatibility**: We validate against python-dotenv 1.2.1 and maintain 95%+ compatibility.

### mojoenv
- **Repository**: https://github.com/itsdevcoffee/mojoenv
- **Author**: itsdevcoffee
- **Role**: Pioneer of .env support in Mojo

`mojoenv` was the first implementation of .env file parsing for Mojo, created in 2023. It pioneered the concept and proved the need for environment variable management in Mojo projects. We're grateful for itsdevcoffee's vision and early work.

**Why a rewrite?** mojoenv was built for Mojo circa 2023 and is incompatible with modern Mojo (2025/2026) due to language evolution:
- List type parameters changed from `List[String, 0]` to `List[String]`
- Parameter syntax changed from `inout self` to `mut self`  
- Path type trait conformance requirements changed
- Binary package format (.mojopkg) is incompatible

Rather than fork and update mojoenv, we chose a clean rewrite using modern Mojo idioms, comprehensive testing, and python-dotenv compatibility validation.

## Contributors

### Core Development
- **Michael Booth** ([@mjboothaus](https://github.com/mjboothaus)) - Initial implementation, testing, documentation

### AI Assistance
- **Warp AI Agent** - Code generation, testing assistance, documentation

## Technology Stack

### Mojo
- **Modular Team** - For creating the Mojo programming language
- **Version**: 0.26.1.0.dev2026010405
- **Website**: https://www.modular.com/mojo

### Development Tools
- **pixi** - Package and environment management
- **python-dotenv** - Testing reference implementation
- **Python** - Interop testing and validation

## Testing Approach

Our testing methodology validates compatibility with python-dotenv using Python interop:

```mojo
from dotenv import dotenv_values  # mojo-dotenv
from python import Python

fn test() raises:
    # Test with Mojo
    var mojo_result = dotenv_values("test.env")
    
    # Validate against Python
    var py = Python.import_module("dotenv")
    var py_result = py.dotenv_values("test.env")
    
    # Compare results
    assert_equal(mojo_result, py_result)
```

This ensures behavioural compatibility beyond just API similarity.

## Community

Special thanks to:
- The Modular Discord community for Mojo support and feedback
- python-dotenv contributors for maintaining excellent documentation
- Early mojo-dotenv testers and users

## Standing on the Shoulders of Giants

This project wouldn't exist without:
1. **python-dotenv** establishing the de facto standard for .env file handling
2. **mojoenv** proving the need and viability in the Mojo ecosystem
3. **Modular** creating Mojo and enabling Python-level ergonomics with C++-level performance

We're grateful to build upon this foundation.

---

**How to Contribute**: See [CONTRIBUTING.md](CONTRIBUTING.md) (coming soon)

**Report Issues**: https://github.com/databooth/mojo-dotenv/issues
