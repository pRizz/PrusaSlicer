---
phase: 03-migrate-core-targets-and-dependencies
plan: 03
subsystem: infra
tags: [bazel, macos, tests, catch2, config, proof-slice]
requires:
  - phase: 03-02
    provides: narrowed Bazel-owned CLI seam behind //src:PrusaSlicer
provides:
  - macOS Bazel test proof for //tests/libslic3r:config_test
  - a small config-oriented core seam shared by the binary and the representative test
  - explicit proof-slice dependency and bridge inventory updates from real test pressure
affects: [phase-03-04, phase-03-verification]
tech-stack:
  added: [Bazel config_core seam, Bazel Catch2 test main, local vendor header/lib bridge packages]
  patterns: [representative test first, generated-header seam, bounded external dependency bridge]
key-files:
  created:
    - BUILD.bazel
    - bundled_deps/fast_float/BUILD.bazel
    - bundled_deps/int128/BUILD.bazel
    - bundled_deps/localesutils/BUILD.bazel
    - bundled_deps/semver/BUILD.bazel
    - deps/build/destdir/usr/local/include/BUILD.bazel
    - deps/build/destdir/usr/local/lib/BUILD.bazel
    - src/libslic3r/BazelConfigCompat.cpp
    - tests/BUILD.bazel
    - tests/libslic3r/BUILD.bazel
    - tests/libslic3r/BazelCatchMain.cpp
    - .planning/phases/03-migrate-core-targets-and-dependencies/03-03-SUMMARY.md
  modified:
    - src/BUILD.bazel
    - src/libslic3r/BUILD.bazel
    - tools/bazel/deps/proof_slice_deps.bzl
    - tools/bazel/policies/proof_slice_bridges.md
key-decisions:
  - "Keep the representative test bounded to config_test instead of migrating the monolithic libslic3r_tests bundle"
  - "Use a narrow BazelConfigCompat shim instead of dragging in Preset.cpp, utils.cpp, and GCode.cpp wholesale"
  - "Treat already-built third-party headers/static libraries under deps/build/destdir/usr/local as a temporary explicit bridge for the current proof slice"
patterns-established:
  - "One representative test can deepen the seam without widening the whole slice"
  - "Generated and compatibility seams should be made explicit in Bazel rather than hidden in legacy side effects"
requirements-completed: [BLD-02, DEPS-01, DEPS-03]
duration: 0 min
completed: 2026-04-06
---

# Phase 3 Plan 03 Summary

**macOS `//tests/libslic3r:config_test` passes in Bazel against a bounded config-oriented seam shared with `//src:PrusaSlicer`**

## Performance

- **Duration:** 0 min
- **Started:** 2026-04-06T00:00:00Z
- **Completed:** 2026-04-06T00:00:00Z
- **Tasks:** 3
- **Files modified:** 15

## Accomplishments
- Added `//tests/libslic3r:config_test` as the representative Bazel test target for the proof slice.
- Introduced a small `config_core` seam and supporting Bazel packages for generated headers, bundled headers, and vendor static libs.
- Updated the proof-slice dependency manifest and bridge inventory from real test execution on macOS.

## Task Commits

Each task was committed atomically:

1. **Task 1: Create `//tests/libslic3r:config_test` as the bounded Phase 3 test target** - `d87fe8b95` (test)
2. **Task 2: Reuse the same owned core seam in `config_test`** - `8442f24a7` (feat)
3. **Task 3: Refresh the bounded ownership and bridge inventory from test evidence** - `433739ad1` (docs)

**Plan metadata:** To be recorded in the plan metadata commit that accompanies this summary.

## Files Created/Modified
- `tests/libslic3r/BUILD.bazel` - declares the bounded `config_test` Bazel target
- `tests/libslic3r/BazelCatchMain.cpp` - provides an explicit Catch2 test main for Bazel
- `src/libslic3r/BUILD.bazel` - defines the `config_core` seam and generated version-header handling
- `src/libslic3r/BazelConfigCompat.cpp` - provides a narrow compatibility shim for config-related helpers
- `tools/bazel/deps/proof_slice_deps.bzl` - records the direct proof-slice dependencies now required by the test seam
- `tools/bazel/policies/proof_slice_bridges.md` - records the active external dependency bridge used by `config_core`

## Decisions Made

- The representative test can be kept bounded by owning a config-oriented seam instead of widening into `libslic3r_tests`.
- A small Bazel-only compatibility shim is preferable to dragging large production translation units into the proof slice prematurely.
- The already-built vendor include/lib tree is an acceptable temporary bridge for the current proof slice and must remain explicit.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Generated `libslic3r_version.h` inside Bazel**
- **Found during:** Task 2
- **Issue:** `Config.cpp` and related headers required `libslic3r_version.h`, which was previously only a build-product outside Bazel
- **Fix:** Added a Bazel genrule and minimal root `BUILD.bazel` export for `version.inc`
- **Files modified:** `BUILD.bazel`, `src/libslic3r/BUILD.bazel`
- **Verification:** `bazel build --config=dev --config=macos //src:PrusaSlicer`
- **Committed in:** `8442f24a7`

**2. [Rule 3 - Blocking] Replaced brittle Catch2 include hacks with a local Bazel test main**
- **Found during:** Task 1
- **Issue:** Forcing `catch_main.hpp` in through compiler flags was unreliable across package boundaries
- **Fix:** Added `tests/libslic3r/BazelCatchMain.cpp` with an explicit `Catch::Session` main
- **Files modified:** `tests/libslic3r/BUILD.bazel`, `tests/libslic3r/BazelCatchMain.cpp`
- **Verification:** `bazel test --config=dev --config=macos //tests/libslic3r:config_test`
- **Committed in:** `d87fe8b95`

**3. [Rule 3 - Blocking] Used a narrow BazelConfigCompat shim instead of linking broad config helpers**
- **Found during:** Task 2
- **Issue:** `Config.cpp` and `PrintConfig.cpp` pulled a handful of helper symbols whose original implementations would have widened the seam too much
- **Fix:** Added `src/libslic3r/BazelConfigCompat.cpp` with narrowly scoped implementations for the config proof path
- **Files modified:** `src/libslic3r/BazelConfigCompat.cpp`, `src/libslic3r/BUILD.bazel`
- **Verification:** `bazel test --config=dev --config=macos //tests/libslic3r:config_test`
- **Committed in:** `8442f24a7`

---

**Total deviations:** 3 auto-fixed (3 blocking)  
**Impact on plan:** All fixes stayed inside the bounded config/test seam and avoided broadening the proof slice.

## Issues Encountered

- The test seam required more internal/local support than the binary seam, but the pressure stayed centered on config/printconfig support rather than exploding into GUI or packaging work.
- The current proof still uses a temporary external dependency bridge to the already-built vendor include/lib tree under `deps/build/destdir/usr/local`.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Phase `03-04` can now focus on Linux parity for the same `//src:PrusaSlicer` and `//tests/libslic3r:config_test` labels.
- The proof-slice bridge inventory is now grounded in both binary and test execution on macOS, so Linux work can classify blockers cleanly as owned, bridged, or deferred.

---
*Phase: 03-migrate-core-targets-and-dependencies*
*Completed: 2026-04-06*
