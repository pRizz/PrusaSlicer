# Codebase Concerns

**Analysis Date:** 2026-04-03

## Tech Debt

**Compiler and dependency warning suppressions:**
- Issue: `CMakeLists.txt` disables several warnings instead of fixing the underlying code or dependency issues, including deprecated Eigen adaptor typedefs, deprecated OpenGL calls, and some signed/unsigned conversion warnings.
- Why: This keeps the project building across MSVC, GCC, and Clang while older code paths and vendor dependencies remain in place.
- Impact: Real regressions can be hidden by the suppression layer, and toolchain upgrades may surface a large burst of failures at once.
- Fix approach: Remove suppressions incrementally, isolate third-party warnings behind tighter boundaries, and add CI coverage for newer compilers before tightening flags.

**Vendored dependency and custom CMake maintenance burden:**
- Issue: The build pulls in many third-party components through `bundled_deps/`, custom find modules in `cmake/modules/`, and bespoke dependency notes in `doc/Dependencies.md`.
- Why: Several upstream packages are unavailable, hard to package, or customized for slicer-specific behavior.
- Impact: Updates are slower, dependency drift is easy, and build logic can break in only one platform configuration.
- Fix approach: Prefer upstream packages where possible, keep custom find logic minimal, and document the exact upgrade path for each vendored library.

## Known Bugs

**STL and OBJ export functions ignore write failures:**
- Symptoms: `store_stl` and `store_obj` return `true` even if the underlying mesh write fails.
- Trigger: Disk full, permission errors, invalid output paths, or any failure inside `TriangleMesh::write_*`.
- Workaround: None in these functions; callers receive a success result unless they detect the failure elsewhere.
- Root cause: The write result is discarded in `src/libslic3r/Format/STL.cpp` and `src/libslic3r/Format/OBJ.cpp`.
- Blocked by: The mesh write APIs need a real success/failure signal, or these wrappers need to propagate exceptions.

**SLA config export still carries secret-handling risk:**
- Symptoms: `src/libslic3r/Format/SL1.cpp` explicitly blacklists `print_host`, `printhost_apikey`, and `printhost_cafile`, but the code still contains a FIXME saying print-host keys may no longer belong in the exported config.
- Trigger: New sensitive configuration keys being added without updating the blacklist.
- Workaround: The current denylist prevents the known keys from being exported.
- Root cause: Sensitive config handling is based on a manual blacklist instead of a stronger classification model.
- Blocked by: A typed schema or explicit secret/non-secret separation for exportable config.

## Security Considerations

**CI workflows inherit secrets into reusable workflows:**
- Risk: `.github/workflows/*.yml` calls `Prusa-Development/PrusaSlicer-Actions@master` and uses `secrets: inherit`.
- Current mitigation: The reusable workflow target is at least pinned to a specific repository and branch.
- Recommendations: Pin to a tag or commit SHA, review workflow permissions, and keep secret exposure as narrow as possible.

**Export paths must keep credentials out of artifacts:**
- Risk: File export code can accidentally serialize settings that should never leave the local environment.
- Current mitigation: `src/libslic3r/Format/SL1.cpp` maintains a denylist for known sensitive keys.
- Recommendations: Convert the blacklist into a stricter allowlist or schema-driven export policy, and add regression tests for sensitive keys.

## Performance Bottlenecks

**Geometry-heavy support and path-generation code:**
- Problem: Hot paths in `src/libslic3r/Arachne/SkeletalTrapezoidation.cpp`, `src/libslic3r/SLA/SupportIslands/UniformSupportIsland.cpp`, and related geometry code contain many TODOs, debug branches, and repeated geometric calculations.
- Measurement: The repository does not document a stable benchmark number for these paths.
- Cause: These modules do complex computational geometry with a lot of intermediate state and conditional behavior.
- Improvement path: Add focused benchmarks before refactoring, then reduce repeated geometry work and isolate debug-only instrumentation.

## Fragile Areas

**Format import/export code:**
- Why fragile: Parsing and writing are manually handled, with edge-case logic for OBJ face counts, vertex indices, and mesh emptiness in `src/libslic3r/Format/OBJ.cpp` and `src/libslic3r/Format/STL.cpp`.
- Common failures: Non-triangular OBJ faces, invalid indices, empty meshes, and silent export failures.
- Safe modification: Add format-specific regression tests in `tests/libslic3r/` before changing parser or writer behavior.
- Test coverage: The format code is exercised by unit tests, but the write-failure path is not obviously guarded.

**Platform-specific build glue:**
- Why fragile: `CMakeLists.txt` and the custom modules under `cmake/modules/` contain many OS- and compiler-specific branches, warning toggles, and package probes.
- Common failures: A new compiler or SDK version breaks only one platform, often without an obvious root cause.
- Safe modification: Change one toolchain branch at a time and validate with the matching platform build.
- Test coverage: CI workflows exist, but they are external reusable workflows rather than local integration tests in the repo.

## Test Coverage Gaps

**Core app and packaging paths are not mirrored in the local test tree:**
- What's not tested: `tests/CMakeLists.txt` builds suites for `arrange`, `thumbnails`, `libslic3r`, `fff_print`, `sla_print`, and `cpp17`, but the GUI app and packaging flows are not represented there.
- Risk: A change can pass unit tests while still breaking app startup, GUI integration, or release packaging.
- Priority: High.
- Difficulty to test: These paths need platform-specific smoke tests and end-to-end validation, not just library tests.

**Test layout is still consolidated:**
- What's not tested: The TODO in `tests/CMakeLists.txt` explicitly says to split individual tests into separate executables/directories.
- Risk: A monolithic layout makes it harder to isolate regressions and target narrow test subsets.
- Priority: Medium.
- Difficulty to test: Reorganizing the suite requires build-system work and careful target migration.

## Dependencies at Risk

**Custom packaged third-party libraries:**
- Risk: `bundled_deps/` carries libraries that are either customized, hard to package, or not available in a suitable system version, including `qhull`, `glu-libtess`, `imgui`, `miniz`, and others documented in `doc/Dependencies.md`.
- Impact: Security fixes and upstream bug fixes arrive slowly, and build compatibility depends on this repo keeping its wrappers current.
- Migration plan: Keep the bundled copy small, prefer system packages where they exist, and track each vendored library with a dedicated upgrade note.

**Custom find modules can drift from upstream package behavior:**
- Risk: The project relies on bespoke modules such as `cmake/modules/FindOpenVDB.cmake`, `cmake/modules/FindTBB.cmake`, and `cmake/modules/FindwxWidgets.cmake`.
- Impact: Discovery logic can become stale or platform-specific bugs can stay hidden until a dependency upgrade lands.
- Migration plan: Prefer config-mode packages where possible and trim custom module logic to the minimum needed for this repository.

*Concerns audit: 2026-04-03*
*Update as issues are fixed or new ones discovered*
