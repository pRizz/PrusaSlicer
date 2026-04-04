---
phase: 02-establish-build-graph-skeleton
plan: 02
subsystem: infra
tags: [bazel, platforms, toolchains, policy, dependencies]
requires:
  - phase: 02-01
    provides: Bazel-first root boundary, ./prusa front door, and Bazel-first docs
provides:
  - Centralized Linux/macOS platform skeleton under tools/bazel
  - Placeholder toolchain-registration structure for later phases
  - Centralized system-library exception registry and policy
affects: [phase-03, dependency-policy, contributor-docs]
tech-stack:
  added: [Bazel platform skeleton, placeholder toolchain registration hooks]
  patterns: [centralized platform policy, centralized exception registry, placeholder-only bring-up]
key-files:
  created:
    - tools/bazel/README.md
    - tools/bazel/platforms/BUILD.bazel
    - tools/bazel/toolchains/BUILD.bazel
    - tools/bazel/policies/BUILD.bazel
    - tools/bazel/policies/system_libraries.bzl
    - .planning/phases/02-establish-build-graph-skeleton/02-02-SUMMARY.md
  modified:
    - MODULE.bazel
    - .bazelrc
    - prusa
    - doc/Dependencies.md
key-decisions:
  - "Keep platform/toolchain work at placeholder registration scope only in Phase 2"
  - "Route all system-library exceptions through one centralized registry with explicit metadata"
patterns-established:
  - "Platform and toolchain structure belongs under tools/bazel, not scattered across product targets"
  - "Legacy dependency inventory is not the same as Bazel-approved system-library exceptions"
requirements-completed: [BLD-03, DEPS-02]
duration: 3 min
completed: 2026-04-04
---

# Phase 2 Plan 02 Summary

**Centralized Bazel platform skeleton and explicit system-library exception policy wired back into the repo front door**

## Performance

- **Duration:** 3 min
- **Started:** 2026-04-04T23:54:36Z
- **Completed:** 2026-04-04T23:57:24Z
- **Tasks:** 3
- **Files modified:** 9

## Accomplishments
- Added a centralized `tools/bazel/` skeleton for Linux/macOS platforms and placeholder toolchain-registration structure.
- Created one explicit system-library exception registry and documented the difference between legacy dependency inventory and Bazel-approved exceptions.
- Wired the new platform and policy locations back into `MODULE.bazel`, `.bazelrc`, and `./prusa` so the root front door points at real structural anchors.

## Task Commits

Each task was committed atomically:

1. **Task 1: Create the centralized Linux/macOS Bazel platform and toolchain packages** - `d1907d727` (chore)
2. **Task 2: Define the centralized system-library exception registry and policy** - `96e93509d` (docs)
3. **Task 3: Wire the platform and policy structure back into the front door** - `3687d551d` (feat)

**Plan metadata:** To be recorded in the plan metadata commit that accompanies this summary.

## Files Created/Modified
- `tools/bazel/README.md` - Documents the Bazel-owned skeleton layout and root command surface
- `tools/bazel/platforms/BUILD.bazel` - Centralizes Linux/macOS platform definitions and future Windows placeholder
- `tools/bazel/toolchains/BUILD.bazel` - Adds placeholder toolchain-registration structure for later phases
- `tools/bazel/policies/BUILD.bazel` - Exposes the Bazel policy package
- `tools/bazel/policies/system_libraries.bzl` - Central registry schema for approved system-library exceptions
- `MODULE.bazel` - Registers the placeholder execution platforms and toolchain hooks
- `.bazelrc` - Points named platform configs at the centralized platform labels
- `prusa` - Surfaces platform and policy locations while keeping the wrapper thin
- `doc/Dependencies.md` - Separates the legacy dependency inventory from Bazel-approved exceptions

## Decisions Made
- Platform and toolchain work in Phase 2 stops at visible placeholder structure and registration hooks; real bring-up is later work.
- System-library exceptions must be source-fetched by default and explicitly approved through a single registry file.
- The root front door should point at structural platform and policy locations without overstating migration progress.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Corrected the Bazel query syntax used to verify multiple structural packages**
- **Found during:** Task 1 (placeholder package verification)
- **Issue:** Querying multiple package wildcards without a `set(...)` expression caused Bazel to reject the verification command
- **Fix:** Re-ran verification with `query 'set(//tools/bazel/platforms:all //tools/bazel/toolchains:all //tools/bazel/policies:all)'`
- **Files modified:** None
- **Verification:** Bazel query returned all expected placeholder targets under the new skeleton
- **Committed in:** not applicable (verification-only correction)

---

**Total deviations:** 1 auto-fixed (1 blocking)
**Impact on plan:** The correction affected only verification syntax, not the phase output or scope.

## Issues Encountered

None

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Phase 3 can now attach real Bazel target migration work to a stable repo-root command surface and centralized policy layout.
- Platform branching and exception policy no longer need to be invented ad hoc during product-target bring-up.

---
*Phase: 02-establish-build-graph-skeleton*
*Completed: 2026-04-04*
