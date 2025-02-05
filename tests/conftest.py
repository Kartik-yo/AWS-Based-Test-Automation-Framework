import pytest

@pytest.fixture(scope="session")
def setup():
    print("Setup before tests")
    yield
    print("Teardown after tests")
