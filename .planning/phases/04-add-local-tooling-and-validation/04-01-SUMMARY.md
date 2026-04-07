---
phase: 04-add-local-tooling-and-validation
plan: 01
subsystem: infra
tags: [bazel, tests, macos, linux, wrapper, phase-4]
requires: []
provides:
  - Bounded authoritative Bazel test surface under //tools/bazel:test_suite
  - Root ./prusa test front door pointed at the bounded suite instead of //...
  - Contributor docs for the bounded Phase 4 local test scope and tracked legacy CTest exceptions
affects: [phase-04-02, phase-04-verification]
tech-stack:
  added: [Bazel test_suite label, thumbnails regression test target, Docker-backed Linux wrapper path on macOS]
  patterns: [bounded non-GUI suite, shared labels across platforms, explicit legacy exception documentation]
key-files:
  created:
    - tests/thumbnails/BUILD.bazel
    - tests/thumbnails/BazelCatchMain.cpp
    - .planning/phases/04-add-local-tooling-and-validation/04-01-SUMMARY.md
  modified:
    - prusa
    - tools/bazel/BUILD.bazel
    - tests/thumbnails/test_thumbnails_input_string.cpp
    - README.md
    - tools/bazel/README.md
key-decisions:
  - "Use //tests/thumbnails:thumbnails_test as the additional bounded regression target instead of reopening the larger fff_print or slic3rutils surfaces."
  - "Keep one shared Bazel suite label across macOS and Linux, and use Docker on macOS for the Linux path instead of pretending host-side cross-platform toolchains already work."
patterns-established:
  - "The authoritative local test front door can stay honest by pointing at one explicit Bazel suite label instead of //...."
  - "Legacy CTest can remain visible as a tracked exception without being the default contributor workflow."
requirements-completed: [BLD-04]
completed: 2026-04-07
---

# Phase 4 Plan 01 Summary

**A bounded cross-platform Bazel test front door now exists through `./prusa test` and `//tools/bazel:test_suite`**

## Accomplishments

- Added `//tools/bazel:test_suite` as the visible authoritative Bazel test surface for Phase 4.
- Added `//tests/thumbnails:thumbnails_test` as the second bounded non-GUI regression target alongside `//tests/libslic3r:config_test`.
- Repointed `./prusa test` at the bounded suite and made `./prusa test --platform linux` work from macOS through the existing Linux/arm64 Docker proof path.
- Updated the root docs and Bazel tooling docs to describe the exact suite contents and the remaining broader CTest-only exception areas.

## Task Commits

Each task was committed atomically:

1. **Task 1: Define the bounded authoritative Bazel test surface** - `1a2c19086` (`test`)
2. **Task 2: Repoint `./prusa test` at the bounded cross-platform suite** - `d5e8ba39a` (`feat`)
3. **Task 3: Publish honest test-scope guidance and platform verification** - `28933aaf2` (`docs`)

## Verification

- `npx -y @bazel/bazelisk query //tools/bazel:test_suite`
- `npx -y @bazel/bazelisk query 'tests(//tools/bazel:test_suite)'`
- `npx -y @bazel/bazelisk test --config=dev --config=macos //tests/thumbnails:thumbnails_test`
- `./prusa test --platform macos`
- `./prusa test --platform linux`
- `./prusa test --platform macos --dry-run`
- `./prusa test --platform linux --dry-run`
- `rg -n "prusa test|config_test|thumbnails_test|CTest|exception|bounded|Phase 4|test_suite" README.md tools/bazel/README.md prusa`

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Stop the Linux test wrapper after the Docker-backed run**
- **Found during:** Task 2 runtime verification
- **Issue:** `./prusa test --platform linux` on macOS successfully ran the Docker-backed Linux suite, then fell through and retried the same `--config=linux` Bazel test on the host, which failed C++ toolchain resolution.
- **Fix:** Exit immediately after the Docker-backed Linux test helper returns successfully.
- **Files modified:** `prusa`
- **Verification:** `./prusa test --platform linux`
- **Committed in:** `d5e8ba39a`

## Resulting Test Surface

- `//tools/bazel:test_suite`
- `//tests/libslic3r:config_test`
- `//tests/thumbnails:thumbnails_test`

Tracked broader legacy exceptions still remain under CMake/CTest for directories such as `tests/fff_print`, `tests/sla_print`, `tests/slic3rutils`, `tests/arrange`, and the larger `tests/libslic3r` suite beyond `config_test`.
