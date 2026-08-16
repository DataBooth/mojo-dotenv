from dotenv import dotenv_values, load_dotenv, find_dotenv

def main() raises:
    # Basic smoke test: ensure we can import and call the public API without error.
    var path = find_dotenv()
    # We do not assert on specific values here; we just ensure calls succeed.
    var _ = dotenv_values(path)
    var _ = load_dotenv(path, verbose=False, override=False)

    print("ok")
