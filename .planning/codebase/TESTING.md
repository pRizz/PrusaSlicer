# Testing Patterns

**Analysis Date:** 2026-04-03

## Test Framework

**Runner:**
- Catch2 3.8 is the test framework used by the repo.
- `tests/CMakeLists.txt` wires `Catch2::Catch2WithMain` into the shared `test_common` target.
- Tests are registered with CTest via `add_test(...)`, so `ctest` is the umbrella runner. This is inferred from the CMake wiring, not from a dedicated test script.

**Assertion Library:**
- Catch2 assertions are used throughout: `REQUIRE`, `CHECK`, `REQUIRE_THROWS_AS`, `REQUIRE_NOTHROW`, `INFO`, and `FAIL`.
- BDD-style macros are used in some suites: `SCENARIO`, `GIVEN`, `WHEN`, and `THEN`.

**Run Commands:**
```bash
ctest --output-on-failure
ctest -R arrange
ctest -R libslic3r
cmake --build <build-dir> --target <suite>_tests
```

## Test File Organization

**Location:**
- Tests live under `tests/<suite>/`, with suites such as `arrange`, `fff_print`, `libslic3r`, `sla_print`, `slic3rutils`, and `thumbnails`.
- Shared fixtures and helpers live in `tests/test_utils.hpp`, `tests/catch_main.hpp`, and `tests/data/`.

**Naming:**
- Most test files are named `test_*.cpp`.
- Suite entry points are named `*_tests_main.cpp` or `*_tests.cpp` depending on the directory.
- Suite `CMakeLists.txt` files define executables like `arrange_tests` and `libslic3r_tests`.

**Structure:**
```text
tests/
  CMakeLists.txt
  catch_main.hpp
  test_utils.hpp
  data/
  arrange/
    CMakeLists.txt
    test_arrange.cpp
    test_arrange_integration.cpp
  libslic3r/
    CMakeLists.txt
    test_config.cpp
```

## Test Structure

**Suite Organization:**
```cpp
TEST_CASE("Dynamic config serialization - tests ConfigBase", "[Config]") {
    // Arrange
    DynamicPrintConfig config;

    // Act
    config.set_key_value("layer_height", new ConfigOptionFloat(0.3));

    // Assert
    CHECK(config.opt_serialize("layer_height") == "0.3");
}
```

**Patterns:**
- Arrange/Act/Assert is common, but not mechanically enforced.
- Tests also use BDD nesting for behavior-heavy flows, especially in arrange and gcode suites.
- Shared setup is often kept inline or in suite-local helpers rather than in a large fixture hierarchy.

## Mocking

**Framework:**
- I did not find a dedicated mocking framework in the repo.
- Tests mostly use real objects, small helper functions, and deterministic data files instead of mocks.

**Patterns:**
- File, mesh, and config fixtures are loaded from `tests/data/`.
- Helper functions such as `tests/test_utils.hpp::load_model` and `tests/fff_print/test_data.cpp::init_print` act like lightweight factories.

**What to Mock:**
- External dependencies are usually minimized by using local data and direct object construction.
- When callbacks are needed, tests often pass lambdas instead of mock classes.

**What NOT to Mock:**
- Pure geometry and config logic are usually exercised directly with real implementations.

## Fixtures and Factories

**Test Data:**
- `tests/data/` contains OBJ, SVG, 3MF, INI, and font fixtures.
- `tests/CMakeLists.txt` injects `TEST_DATA_DIR` through the shared `test_common` interface target.
- `tests/data/prusaparts.cpp` and `tests/data/prusaparts.hpp` provide reusable geometry data for multiple suites.

**Location:**
- Shared helpers live beside the tests, not in a separate framework directory.
- Domain-specific helpers are kept near the suite that uses them, for example `tests/fff_print/test_data.cpp`.

## Coverage

**Requirements:**
- I did not find a repo-local coverage target or coverage threshold in the current scan.
- Coverage appears to be driven by suite execution rather than an enforced percentage gate.

**Configuration:**
- Catch2 is built with `CATCH_CONFIG_FAST_COMPILE` in `tests/CMakeLists.txt`.
- `CATCH_EXTRA_ARGS` can inject additional filters or runner flags.

**View Coverage:**
- No canonical coverage command was found in the repo.

## Test Types

**Unit Tests:**
- Common for config, parsing, and geometry logic.
- Usually test a single behavior or function with direct assertions.

**Integration Tests:**
- Present in suites like `tests/arrange/test_arrange_integration.cpp` and `tests/fff_print/`.
- These tests often exercise end-to-end slicing or arrangement flows with real models and configs.

**E2E Tests:**
- I did not find a separate browser/UI E2E harness in this repo.

## Common Patterns

**Async Testing:**
- Most tests are synchronous.
- Where async behavior matters, the suite tends to use direct callbacks or helper functions rather than a separate async test harness.

**Error Testing:**
- Exception assertions are common, especially around invalid config or parsing input.
- `REQUIRE_NOTHROW` is used for valid fixture paths and `REQUIRE_THROWS_AS` for invalid ones.

**Snapshot Testing:**
- I did not find a dedicated snapshot-testing system.

---

*Testing analysis: 2026-04-03*
*Update when test patterns change*
