# Coding Conventions

**Analysis Date:** 2026-04-03

## Naming Patterns

**Files:**
- Production files use feature-oriented names in PascalCase or mixed camel/Pascal case, such as `src/libslic3r/PrintConfig.cpp` and `src/slic3r/GUI/UserAccountCommunication.hpp`.
- Test files are typically prefixed with `test_`, for example `tests/libslic3r/test_config.cpp` and `tests/fff_print/test_gcode.cpp`.
- Each test suite has its own `CMakeLists.txt` under `tests/<suite>/`.

**Functions:**
- Functions and methods use camelCase, such as `generate_login_redirect_url`, `get_storage`, and `testCaseStarting`.
- Local helper functions in tests follow the same pattern, for example `has_moves_below_z_offset`.
- Async or callback-heavy code does not use special prefixes; naming stays descriptive.

**Variables:**
- Locals and parameters are usually camelCase.
- Private members use the `m_` prefix, as shown in `src/slic3r/GUI/UserAccountCommunication.hpp`.
- Constants are not fully standardized to one style; the repo mixes `constexpr`, `static constexpr`, and descriptive names.

**Types:**
- Classes, structs, and enums use PascalCase, such as `UserAccountCommunication`, `CodeChalengeGenerator`, and `SerializationTestData`.
- Nested namespaces are explicit, typically `namespace Slic3r { namespace GUI { ... } }`.

## Code Style

**Formatting:**
- Formatting is driven by `.clang-format`.
- The formatter is set to C++11 syntax compatibility with a `ColumnLimit` of 100 and `IndentWidth` of 4.
- Tabs are disabled (`UseTab: Never`).

**Linting:**
- I did not find a repo-local `clang-tidy` or equivalent lint config in the root scan.
- In practice, style is enforced by formatting, compiler warnings, and review rather than a single lint gate.

## Import Organization

**Order:**
- Includes are grouped loosely by standard library, third-party dependencies, then project headers.
- The repo keeps `#include` blocks readable but does not appear to enforce a strict import sorter.

**Grouping:**
- Blank lines separate major include groups in most files.
- `namespace` aliases are used for long dependencies, for example `namespace fs = boost::filesystem;` in `src/slic3r/Utils/PrusaConnect.cpp`.

**Path Aliases:**
- No source alias system like `@/` is present; paths are explicit and relative to the repo layout.

## Error Handling

**Patterns:**
- Hard failures usually throw exceptions, such as `throw Slic3r::IOError(...)` and `throw JobException(...)`.
- Invariants are frequently guarded with `assert(...)`, especially in GUI and geometry code.
- Expected failure paths often return `bool` and fill an out-parameter or callback error message, as in `src/slic3r/Utils/PrusaConnect.cpp`.

**Error Types:**
- Parsing and IO boundaries commonly use narrow `try/catch` blocks.
- Broad `catch (...)` appears in a few wrapper-style areas, but that is not the default pattern.

## Logging

**Framework:**
- Logging uses `BOOST_LOG_TRIVIAL(...)` extensively, especially in network, GUI, and job code.

**Patterns:**
- Log calls include contextual data such as URLs, HTTP status, and object names.
- Console-style `printf` logging is not the normal pattern in committed code.

## Comments

**When to Comment:**
- Comments usually explain intent, workarounds, or external constraints rather than obvious code behavior.
- `TODO` and `FIXME` comments are present in both source and build files, for example `CMakeLists.txt` and `src/slic3r/GUI/Jobs/EmbossJob.cpp`.
- Some code comments are used to explain why an unusual branch or assert exists.

**JSDoc/TSDoc:**
- Not applicable; this is a C++ codebase and I did not find a public-API doc convention enforced in the repo.

**TODO Comments:**
- TODOs are free-form and not tied to a required ticket syntax.

## Function Design

**Size:**
- Functions are often kept focused, but large subsystems still have sizable implementation files.
- Early returns are common in validation-heavy code paths.

**Parameters:**
- Descriptive positional parameters are common.
- Larger stateful operations often use structs or config objects instead of many scalars.

**Return Values:**
- Explicit returns are preferred.
- `bool` return values are common for operations that can fail without throwing.

## Module Design

**Exports:**
- Public APIs are exposed through headers under `src/libslic3r/` and `src/slic3r/`.
- Tests and helper utilities commonly live in the same suite directory.

**Barrel Files:**
- I did not find a strong barrel-file convention.
- Public surface area is organized by module headers rather than aggregate re-export files.

---

*Convention analysis: 2026-04-03*
*Update when patterns change*
