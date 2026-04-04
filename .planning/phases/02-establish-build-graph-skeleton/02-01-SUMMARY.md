---
phase: 02-establish-build-graph-skeleton
plan: 01
subsystem: infra
tags: [bazel, bzlmod, wrapper, docs, front-door]
requires: []
provides:
  - Bazel-first root boundary via MODULE.bazel and .bazelrc
  - Thin repo-root ./prusa command surface
  - Bazel-first contributor guidance in root and platform build docs
affects: [phase-02-02, phase-03, contributor-onboarding]
tech-stack:
  added: [Bazel module boundary, bazelrc config skeleton]
  patterns: [thin wrapper front door, Bazel-first docs, placeholder helper package]
key-files:
  created:
    - MODULE.bazel
    - .bazelrc
    - prusa
    - tools/bazel/BUILD.bazel
    - .planning/phases/02-establish-build-graph-skeleton/02-01-SUMMARY.md
  modified:
    - README.md
    - doc/How to build - Linux et al.md
    - doc/How to build - Mac OS.md
key-decisions:
  - "Use a thin ./prusa wrapper as the Bazel-first repo front door instead of raw top-level command files"
  - "Keep the root Bazel skeleton explicit while deferring real target migration to later phases"
patterns-established:
  - "Root-first migration: make Bazel visible before broad target bring-up"
  - "Wrapper surfaces direct Bazel equivalents instead of hiding them"
requirements-completed: [BLD-03]
duration: 6 min
completed: 2026-04-04
---

# Phase 2 Plan 01 Summary

**Bazel-first repo root skeleton with MODULE.bazel, .bazelrc, a thin ./prusa front door, and Bazel-first contributor docs**

## Performance

- **Duration:** 6 min
- **Started:** 2026-04-04T23:48:00Z
- **Completed:** 2026-04-04T23:54:36Z
- **Tasks:** 3
- **Files modified:** 7

## Accomplishments
- Added the root Bazel boundary and shared config skeleton with `MODULE.bazel`, `.bazelrc`, and `tools/bazel/BUILD.bazel`.
- Introduced a thin `./prusa` front door that exposes `build`, `test`, `fmt`, `lint`, `compdb`, and `help` while printing the direct Bazel equivalents.
- Re-anchored the README and Linux/macOS build guides so Bazel is the front door and CMake is explicitly transitional.

## Task Commits

Each task was committed atomically:

1. **Task 1: Establish the repo-root Bazel boundary and default configs** - `9e47a3c8a` (chore)
2. **Task 2: Add the thin `./prusa` front door with direct Bazel escape hatches** - `ecdc4e4b1` (feat)
3. **Task 3: Re-anchor root and platform docs on the Bazel-first path** - `7f6ee4f18` (docs)

**Plan metadata:** To be recorded in the plan metadata commit that accompanies this summary.

## Files Created/Modified
- `MODULE.bazel` - Establishes Bazel as the repo-root module boundary
- `.bazelrc` - Defines shared dev/platform/compdb config names for the wrapper
- `prusa` - Thin root command surface for build, test, fmt, lint, compdb, and help
- `tools/bazel/BUILD.bazel` - Placeholder helper package for Bazel-owned front-door labels
- `README.md` - Adds Bazel-first root guidance and direct Bazel equivalents
- `doc/How to build - Linux et al.md` - Marks the Bazel path as the migration front door and CMake as transitional
- `doc/How to build - Mac OS.md` - Marks the Bazel path as the migration front door and CMake as transitional

## Decisions Made
- Use `./prusa` instead of literal top-level `build` or `test` files because the repo already contains a `build/` directory and the wrapper can stay thin while keeping Bazel visible.
- Keep `tools/bazel/BUILD.bazel` as a placeholder landing zone rather than prematurely wiring product-target migration into the root.
- Phrase the docs honestly: Bazel is the new front door, but the full PrusaSlicer target graph is still a later phase.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Phase 02-02 can now hang centralized platform/toolchain and exception-policy structure off a visible Bazel-first front door.
- The repo root clearly signals the Bazel direction without overstating Phase 3 migration progress.

---
*Phase: 02-establish-build-graph-skeleton*
*Completed: 2026-04-04*
