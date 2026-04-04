# PrusaSlicer Build Stack Modernization

## What This Is

This project modernizes how PrusaSlicer is built, tested, and maintained for repository maintainers and contributors. The goal is to replace the current CMake-first, custom-dependency-heavy workflow with a more modern, reliable, and repeatable build stack, preferably Bazel, while preserving the existing Linux and macOS product behavior closely enough for the new path to become authoritative.

This is a brownfield migration, not a product redesign. PrusaSlicer remains the same cross-platform slicer application; the work is focused on build orchestration, dependency management, CI, developer tooling, and the minimum source changes required to make that modernization succeed.

## Core Value

Maintainers and contributors can build, test, and work on PrusaSlicer through a simple, repeatable, authoritative toolchain on Linux and macOS.

## Requirements

### Validated

- ✓ PrusaSlicer already exists as a large C++ desktop application with shared CLI and GUI entry paths — existing
- ✓ The product already supports Linux, macOS, and Windows builds, even though the current build flow is CMake-first and platform-conditional — existing
- ✓ The repository already contains reusable core libraries, GUI code, CLI flows, and specialized support libraries that must keep working through the migration — existing
- ✓ The repo already has unit and integration test coverage centered around Catch2 and CTest — existing
- ✓ The current dependency story relies on bundled third-party code, custom discovery logic, and platform-specific build glue that now needs modernization — existing

### Active

- [ ] Evaluate Bazel against Meson + Ninja and select the authoritative modern build stack for this repository
- [ ] Provide a Linux and macOS build path that can build PrusaSlicer reproducibly without CMake remaining the primary maintained workflow
- [ ] Support near-parity for the current Linux and macOS application behavior, allowing sensible deferral of obsolete or low-value legacy edges
- [ ] Move dependency management toward mostly source-fetched, explicit, reproducible inputs while allowing some system libraries when that is the more sensible tradeoff
- [ ] Run the core automated test suites through the new build stack with reliable local and CI execution
- [ ] Add modern C/C++ developer tooling where practical, including formatting, linting, editor/`clangd` support, and other maintainability-focused checks
- [ ] Establish CI around the new authoritative path for Linux and macOS
- [ ] Simplify or replace custom dependency discovery and vendoring patterns where practical so dependency provenance and upgrade paths are clearer

### Out of Scope

- New slicer end-user features — this effort is strictly about build, tooling, CI, and migration work
- Windows as a first-class migration target in the initial authoritative milestone — Linux and macOS come first
- Perfect 100% parity for every obsolete or low-value legacy path — parity matters, but not at the cost of freezing the migration around dead weight
- Permanent dual maintenance of old and new build stacks — temporary overlap is acceptable, but the goal is one authoritative path

## Context

PrusaSlicer is currently a C++17 desktop application with shared CLI and GUI flows, centered around `libslic3r`, wxWidgets, OpenGL, and a substantial amount of platform-conditional CMake logic. The current stack depends on top-level build configuration in `CMakeLists.txt`, presets in `CMakePresets.json`, custom dependency handling in `deps/`, vendored code in `bundled_deps/`, and a mix of bundled and externally discovered libraries.

The current build story works, but it is harder than desired to reason about, repeat, and maintain. Existing concerns include custom find-module drift, bundled dependency maintenance burden, warning suppressions that hide toolchain issues, and fragile platform-specific build glue. The existing test story is centered around Catch2 and CTest, which provides a concrete baseline that the new build path should preserve or improve.

This project should include an explicit evaluation phase instead of assuming Bazel unconditionally. Bazel is the preferred candidate because of its dependency and hermetic-build story, but Meson + Ninja is an acceptable fallback if Bazel proves too painful for this repo's cross-platform C++ desktop reality.

## Constraints

- **Tech stack**: Large existing C++17 desktop codebase with GUI, CLI, geometry-heavy libraries, and many third-party dependencies — the migration must work with the current product rather than replacing it
- **Platform**: Linux and macOS are the first-class targets for the authoritative new path — Windows can be deferred
- **Compatibility**: Existing product behavior should stay near current parity on the supported platforms — maintainers are flexible on obsolete or low-value legacy edges
- **Dependency strategy**: Prefer mostly source-fetched dependencies with explicit provenance — allow some system libraries when that is simpler and more robust
- **Scope**: No intentional slicer feature work beyond source changes required to support the new build/tooling system — the migration should not become a product-feature project
- **Outcome**: The new build path is intended to become authoritative for the repo — a permanent "experimental side build" is not the goal

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Include an explicit build-system evaluation phase | Bazel is preferred, but the repo should not commit blindly if Meson + Ninja fits the migration better | — Pending |
| Prefer Bazel as the initial target candidate | Hermeticity, dependency modeling, repeatability, and CI ergonomics match the stated goals well | — Pending |
| Select Bazel as the authoritative Phase 2 target, with Meson + Ninja as explicit fallback | Phase 1 scorecard favored Bazel on the project’s highest-weighted criteria even though Meson was easier to prototype | — Pending |
| Accept Meson + Ninja as fallback if Bazel is too painful | Simpler C/C++ ergonomics may outweigh Bazel's advantages in practice for this repo | — Pending |
| Target Linux and macOS first | This keeps the migration tractable while still covering the primary near-term authoritative path | — Pending |
| Keep the project focused on build/tooling migration only | Avoids scope creep into unrelated slicer feature development | — Pending |
| Allow temporary legacy-tool overlap where justified | Controlled overlap is acceptable during migration, but only on the way to one authoritative path | — Pending |

---
*Last updated: 2026-04-04 after Phase 1 candidate comparison*
