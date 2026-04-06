---
phase: 03-migrate-core-targets-and-dependencies
plan: 02
subsystem: infra
tags: [bazel, macos, cli, proof-slice, bridge, deps]
requires:
  - phase: 03-01
    provides: stable Bazel-owned `//src:PrusaSlicer` binary boundary on macOS
provides:
  - Narrower Bazel-owned CLI seam behind `//src:PrusaSlicer`
  - Reduced proof-slice bridge surface and explicit bridge inventory updates
  - Explicit empty third-party dependency set for the current narrowed seam
affects: [phase-03-03, phase-03-04, phase-03-verification]
tech-stack:
  added: []
  patterns: [CLI-first seam deepening, bridge shrink before core expansion]
key-files:
  created:
    - src/libslic3r/BUILD.bazel
    - .planning/phases/03-migrate-core-targets-and-dependencies/03-02-SUMMARY.md
  modified:
    - src/BUILD.bazel
    - src/CLI/BazelHandoff.cpp
    - MODULE.bazel
    - tools/bazel/README.md
    - tools/bazel/deps/proof_slice_deps.bzl
    - tools/bazel/policies/proof_slice_bridges.md
    - tools/bazel/policies/system_libraries.bzl
key-decisions:
  - "Serve `--help` directly from Bazel-owned CLI source to deepen the seam without reopening the oversized core boundary"
  - "Remove the temporary macOS Boost system-header exception because the narrowed seam no longer needs it"
patterns-established:
  - "Shrink the bridge before deepening ownership further"
  - "Record an explicit empty dependency set when a wave proves no third-party deps are actually needed"
requirements-completed: [BLD-02, DEPS-01, DEPS-03]
duration: 2 min
completed: 2026-04-06
---

# Phase 3 Plan 02 Summary

**Bazel-owned macOS `--help` seam proven behind `//src:PrusaSlicer`, with a smaller bridge surface and no remaining third-party dependency exception**

## Performance

- **Duration:** 2 min
- **Started:** 2026-04-06T04:56:53-05:00
- **Completed:** 2026-04-06T04:58:26-05:00
- **Tasks:** 3
- **Files modified:** 8

## Accomplishments
- Moved the `--help` path behind Bazel-owned source in `src/CLI/BazelHandoff.cpp`.
- Reduced the proof-slice bridge inventory to the remaining runtime handoff only.
- Removed the temporary macOS Boost header exception and made the current proof-slice dependency set explicitly empty.

## Task Commits

Each task was committed atomically:

1. **Task 1: Choose one useful CLI/core seam and source-own only that seam** - `037f544e9` (feat)
2. **Task 2: Promote directly required generated inputs and shrink the temporary bridge** - `3d8fae9a4` (docs)
3. **Task 3: Own only the third-party dependencies proven by the narrowed seam** - `03ac36f84` (docs)

**Plan metadata:** To be recorded in the plan metadata commit that accompanies this summary.

## Files Created/Modified
- `src/BUILD.bazel` - drops the unnecessary Wave 1 Boost header dependency from the binary boundary
- `src/CLI/BazelHandoff.cpp` - serves `--help` directly from Bazel-owned source while keeping the remaining runtime handoff narrow
- `src/libslic3r/BUILD.bazel` - reserves a stable package boundary for later core-side seam deepening
- `MODULE.bazel` - removes the temporary `@boost_headers_macos` local repository
- `tools/bazel/deps/proof_slice_deps.bzl` - records that the current narrowed seam owns no third-party dependencies yet
- `tools/bazel/policies/proof_slice_bridges.md` - updates the remaining bridge description to the smaller runtime handoff
- `tools/bazel/policies/system_libraries.bzl` - removes the Wave 1 macOS Boost exception
- `tools/bazel/README.md` - documents the current Wave 2 seam result and the absence of a remaining system-library exception

## Decisions Made

- The smallest useful deepening step is a Bazel-owned CLI `--help` seam, not a deeper `libslic3r` source seam yet.
- The current narrowed seam does not justify any third-party dependency ownership or system-library exception.
- The remaining runtime handoff should stay explicit until a later wave can replace it with a deeper owned seam.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Removed the Wave 1 Boost header exception once the seam no longer needed it**
- **Found during:** Task 3 (dependency cut-line review)
- **Issue:** The old Wave 1 binary boundary needed Boost headers only because it still leaned on a broader seam assumption that this wave intentionally narrowed away
- **Fix:** Removed `@boost_headers_macos` from `MODULE.bazel` and from the binary boundary dependencies
- **Files modified:** `MODULE.bazel`, `src/BUILD.bazel`, `tools/bazel/policies/system_libraries.bzl`
- **Verification:** `npx -y @bazel/bazelisk build --config=dev --config=macos //src:PrusaSlicer`
- **Committed in:** `03ac36f84`

---

**Total deviations:** 1 auto-fixed (1 blocking)
**Impact on plan:** The correction made the seam smaller and more honest. It did not widen scope.

## Issues Encountered

- The Wave 2 seam is still more CLI than core. It proves a deeper owned source path than Wave 1, but it does not yet source-own a meaningful `libslic3r` implementation seam.
- That limitation is explicit and should be tested by later verification rather than hidden.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Phase `03-03` can now add a representative `tests/libslic3r:config_test` target against the same bounded seam.
- Phase `03-04` can later enforce Linux parity and finalize the bridge inventory.
- Final phase verification should explicitly judge whether this wave's seam is sufficiently core-adjacent or whether a smaller follow-up gap will still be needed.

---
*Phase: 03-migrate-core-targets-and-dependencies*
*Completed: 2026-04-06*
