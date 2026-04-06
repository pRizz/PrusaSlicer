---
phase: 03-migrate-core-targets-and-dependencies
plan: 04
subsystem: infra
tags: [bazel, linux, macos, policy, proof-slice, parity]
requires:
  - phase: 03-03
    provides: macOS Bazel proof for //src:PrusaSlicer and //tests/libslic3r:config_test
provides:
  - Linux/arm64 Bazel proof for //src:PrusaSlicer
  - Linux/arm64 Bazel proof for //tests/libslic3r:config_test
  - cross-platform bridge and system-library classification for the bounded proof slice
  - refreshed proof commands for macOS and Linux
affects: [phase-03-verification, phase-03-closeout]
tech-stack:
  added: [Linux/arm64 platform constraint, Linux system-lib bridge, explicit bgcode/I18N compat stubs]
  patterns: [shared target labels across platforms, documented system-lib exception, deferred compatibility shim]
key-files:
  created:
    - .planning/phases/03-migrate-core-targets-and-dependencies/03-04-SUMMARY.md
  modified:
    - .bazelrc
    - deps/build/destdir/usr/local/lib/BUILD.bazel
    - src/CLI/BazelHandoff.cpp
    - src/libslic3r/BazelConfigCompat.cpp
    - tools/bazel/README.md
    - tools/bazel/deps/proof_slice_deps.bzl
    - tools/bazel/platforms/BUILD.bazel
    - tools/bazel/policies/proof_slice_bridges.md
    - tools/bazel/policies/system_libraries.bzl
key-decisions:
  - "Pin the current Linux proof to Linux/arm64 so the available Docker-hosted toolchain resolves against the same shared labels."
  - "Use distro-provided Boost/TBB/EXPAT/libpng/Catch2 on Linux instead of pretending the checked-in macOS Mach-O archives are portable."
  - "Replace remaining bgcode/I18N link pressure with an explicit proof-slice compatibility shim instead of widening the slice into GCode parsing or GUI translation."
requirements-completed: [BLD-01, DEPS-03]
completed: 2026-04-06
---

# Phase 3 Plan 04 Summary

**Linux/arm64 now proves the same bounded Bazel-owned labels as macOS: `//src:PrusaSlicer` and `//tests/libslic3r:config_test`**

## Accomplishments

- Added an explicit Linux/arm64 platform constraint so the bounded proof slice resolves a real C++ toolchain in a Linux environment.
- Switched Linux linking to a narrow documented system-library bridge while keeping the same Bazel labels and config-oriented seam.
- Replaced remaining `LibBGCode`/I18N link pressure with explicit proof-slice compatibility stubs, which let the representative config test pass without widening into the full GCode stack.
- Refreshed the bridge inventory, system-library exception registry, and `tools/bazel/README.md` so maintainers can reproduce both platform proofs and inspect the remaining temporary exceptions.

## Verification

- `docker run --rm --platform=linux/arm64 ... bazelisk build --config=dev --config=linux //src:PrusaSlicer`
- `docker run --rm --platform=linux/arm64 ... bazelisk test --config=dev --config=linux //tests/libslic3r:config_test`
- `npx -y @bazel/bazelisk build --config=dev --config=macos //src:PrusaSlicer`
- `npx -y @bazel/bazelisk test --config=dev --config=macos //tests/libslic3r:config_test`

## Resulting Exception Boundaries

- `//src:PrusaSlicer -> src/BazelMain.cpp` remains a temporary entry shim on both platforms.
- `//src:PrusaSlicer -> build/src/{Debug/,}PrusaSlicer|prusa-slicer` remains the explicit legacy runtime handoff.
- macOS still uses the checked-in vendor include/lib bridge for the bounded slice.
- Linux/arm64 uses a documented temporary system-library exception for Boost/TBB/EXPAT/libpng/Catch2.
- Binary G-code metadata parsing and GUI translation are explicitly deferred through `src/libslic3r/BazelConfigCompat.cpp` instead of hidden behind legacy side effects.
