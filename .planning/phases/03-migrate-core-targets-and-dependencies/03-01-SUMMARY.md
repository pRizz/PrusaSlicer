---
phase: 03-migrate-core-targets-and-dependencies
plan: 01
subsystem: infra
tags: [bazel, macos, cli, proof-slice, bridge]
requires: []
provides:
  - Stable Bazel-owned `//src:PrusaSlicer` binary boundary on macOS
  - Narrow Wave 1 proof-slice bridge inventory and bounded dependency manifest
  - Runnable `--help` proof for the macOS binary handoff
affects: [phase-03-02, phase-03-03, phase-03-verification]
tech-stack:
  added: [Bazel macOS proof boundary, proof-slice dependency manifest]
  patterns: [temporary Bazel entry shim, narrow binary handoff seam, bounded proof-slice ownership]
key-files:
  created:
    - src/BUILD.bazel
    - src/BazelMain.cpp
    - src/CLI/BUILD.bazel
    - src/CLI/BazelHandoff.cpp
    - tools/bazel/deps/BUILD.bazel
    - tools/bazel/deps/proof_slice_deps.bzl
    - .planning/phases/03-migrate-core-targets-and-dependencies/03-01-SUMMARY.md
  modified:
    - MODULE.bazel
    - tools/bazel/README.md
    - tools/bazel/platforms/BUILD.bazel
    - tools/bazel/policies/system_libraries.bzl
    - tools/bazel/policies/proof_slice_bridges.md
key-decisions:
  - "Use a temporary Bazel-only entry shim behind `//src:PrusaSlicer` instead of rooting Wave 1 directly on `src/PrusaSlicer.cpp`"
  - "Keep the Wave 1 bridge to one narrow binary seam and explicitly forbid broad `libslic3r`/`admesh` bridging"
patterns-established:
  - "Public Bazel label stays stable while internal ownership deepens across later waves"
  - "Bridge inventory records seam scope and retirement conditions as soon as the seam exists"
requirements-completed: [BLD-02, DEPS-01]
duration: 1 min
completed: 2026-04-06
---

# Phase 3 Plan 01 Summary

**Bazel-owned macOS `//src:PrusaSlicer` binary boundary proven with a narrow entry shim, bounded dependency metadata, and explicit bridge discipline**

## Performance

- **Duration:** 1 min
- **Started:** 2026-04-06T04:44:52-05:00
- **Completed:** 2026-04-06T09:45:51Z
- **Tasks:** 3
- **Files modified:** 11

## Accomplishments
- Created the first stable Bazel-owned `//src:PrusaSlicer` binary label on macOS.
- Added a narrow proof-slice dependency manifest and explicit bridge inventory instead of widening into a broad internal port.
- Proved the binary boundary at runtime by running `--help` through the Bazel-owned label.

## Task Commits

Each task was committed atomically:

1. **Task 1: Create the smallest Bazel-owned macOS binary shape for `PrusaSlicer`** - `b7d6a1b10` (feat)
2. **Task 2: Model direct generated inputs and forbid broad internal binary bridges** - `3490e1dc4` (docs)
3. **Task 3: Prove the macOS handoff with a real command path** - `eff2c6129` (docs)

**Plan metadata:** To be recorded in the plan metadata commit that accompanies this summary.

## Files Created/Modified
- `src/BUILD.bazel` - Defines the Bazel-owned `//src:PrusaSlicer` binary boundary
- `src/BazelMain.cpp` - Temporary Bazel-only entry shim that preserves the public label while avoiding oversized header fanout
- `src/CLI/BUILD.bazel` - Defines the narrow CLI-side handoff seam
- `src/CLI/BazelHandoff.cpp` - Executes the existing local macOS `PrusaSlicer` binary through the approved narrow handoff
- `tools/bazel/deps/proof_slice_deps.bzl` - Declares the bounded proof-slice dependency metadata
- `tools/bazel/policies/proof_slice_bridges.md` - Records the active Wave 1 bridge seam and explicit bridge prohibitions
- `tools/bazel/README.md` - Records the successful macOS Wave 1 proof command and result

## Decisions Made
- The narrowest safe Wave 1 proof is a Bazel-owned binary boundary plus a temporary entry shim, not a direct `src/PrusaSlicer.cpp` root.
- `boost_headers_macos` is an acceptable temporary system-library exception for the Wave 1 proof.
- The root `generated_version_header` artifact from the abandoned broader attempt was unnecessary for this smaller proof and was discarded.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Removed accidental `libslic3r.h` fanout from the first Bazel boundary**
- **Found during:** Task 1 (first macOS binary proof attempt)
- **Issue:** The initial Bazel boundary still referenced `libslic3r/libslic3r.h`, which immediately recreated the oversized Wave 1 seam
- **Fix:** Narrowed the boundary to `PrusaSlicer.hpp` and then introduced a Bazel-only entry shim for the public label
- **Files modified:** `src/BUILD.bazel`, `src/BazelMain.cpp`, `src/CLI/BazelHandoff.cpp`
- **Verification:** `npx -y @bazel/bazelisk build --config=dev --config=macos //src:PrusaSlicer`
- **Committed in:** `b7d6a1b10`

**2. [Rule 4 - Architectural] Approved temporary Bazel-only entry shim**
- **Found during:** Task 1 proof-shape bring-up
- **Issue:** Keeping Wave 1 literally rooted on `src/PrusaSlicer.cpp` made the first proof seam too large
- **Fix:** User approved a temporary `src/BazelMain.cpp` shim that preserves `//src:PrusaSlicer` while deferring the deeper CLI/core seam to later waves
- **Files modified:** `src/BazelMain.cpp`, `src/BUILD.bazel`
- **Verification:** `npx -y @bazel/bazelisk run --config=dev --config=macos //src:PrusaSlicer -- --help`
- **Committed in:** `b7d6a1b10`

---

**Total deviations:** 2 handled (1 blocking, 1 architectural approved)
**Impact on plan:** Both changes kept Wave 1 materially smaller and safer than the abandoned oversized proof attempt.

## Issues Encountered

- `bazel` was not on `PATH`, but the existing `./prusa` front door already fell back to `npx @bazel/bazelisk`, so no extra toolchain policy change was needed.
- The first handoff attempt resolved the built binary relative to Bazel’s run location instead of the workspace; updating it to use `BUILD_WORKSPACE_DIRECTORY` fixed the runtime proof.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Phase `03-02` can now deepen the seam behind the stable `//src:PrusaSlicer` label without reopening the oversized Wave 1 boundary.
- The bridge inventory is in place and can now be tightened or reduced rather than invented later.

---
*Phase: 03-migrate-core-targets-and-dependencies*
*Completed: 2026-04-06*
