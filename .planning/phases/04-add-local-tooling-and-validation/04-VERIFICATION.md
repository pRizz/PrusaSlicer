---
phase: 04-add-local-tooling-and-validation
verified: 2026-04-07T22:52:28Z
status: passed
score: 4/4 must-haves verified
---

# Phase 4: Add Local Tooling and Validation Verification Report

**Phase Goal:** Make the new path credible for daily contributor use by running tests and developer tooling without falling back to the legacy build.  
**Verified:** 2026-04-07T22:52:28Z  
**Status:** passed

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Contributors can run the core automated test suites through the authoritative path on Linux and macOS. | ✓ VERIFIED | `./prusa test --platform macos` passes natively, `./prusa test --platform linux` passes through the Docker-backed Linux path, and both resolve to `//tools/bazel:test_suite` with `//tests/libslic3r:config_test` plus `//tests/thumbnails:thumbnails_test`. |
| 2 | Contributors can run repository formatting through the authoritative toolchain. | ✓ VERIFIED | `./prusa fmt --check` and `./prusa fmt --fix` both run through Bazel-backed formatter targets with explicit bounded scope. |
| 3 | Contributors can run an initial lint/static-analysis pass through the authoritative toolchain. | ✓ VERIFIED | `./prusa lint` runs a bounded `clang-tidy` pass against the Bazel-owned glue and adjacent non-GUI tests using Bazel-derived compile flags. |
| 4 | Contributors can use `clangd` or equivalent editor metadata without generating build information from the legacy build. | ✓ VERIFIED | `./prusa compdb` writes `build/compdb/compile_commands.json`, and `.clangd` points editors at `build/compdb` directly. |

**Score:** 4/4 truths verified

## Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `prusa` | One obvious local tooling front door | ✓ EXISTS + SUBSTANTIVE | Exposes bounded `test`, `fmt`, `lint`, and `compdb` workflows with explicit dry-run output. |
| `tools/bazel/BUILD.bazel` | Visible tooling/test labels | ✓ EXISTS + SUBSTANTIVE | Exposes `test_suite`, `fmt`, `lint`, and `compdb` through concrete aliases. |
| `tools/bazel/format/BUILD.bazel` | Real formatting targets | ✓ EXISTS + SUBSTANTIVE | Defines bounded `check` and `fix` formatter binaries. |
| `tools/bazel/lint/BUILD.bazel` | Real lint target | ✓ EXISTS + SUBSTANTIVE | Defines the bounded `clang_tidy` runner. |
| `tools/bazel/compdb/BUILD.bazel` | Real metadata refresh target | ✓ EXISTS + SUBSTANTIVE | Defines the explicit compile-command refresh path. |
| `.clang-tidy` | Initial bounded lint policy | ✓ EXISTS + SUBSTANTIVE | Captures the high-signal initial clang-tidy policy and header filter. |
| `.clangd` | Editor metadata hint | ✓ EXISTS + SUBSTANTIVE | Points `clangd` at `build/compdb`. |
| `build/compdb/compile_commands.json` | Generated editor metadata | ✓ GENERATED | Produced by `./prusa compdb` without invoking legacy build generation. |

## Verification Commands

- `./prusa test --platform macos`
- `./prusa test --platform linux`
- `./prusa fmt --check`
- `./prusa fmt --fix`
- `./prusa lint`
- `./prusa compdb`
- `npx -y @bazel/bazelisk query 'set(//tools/bazel/format:all //tools/bazel/lint:all //tools/bazel/compdb:all)'`
- `rg -n "build/compdb/compile_commands\\.json|exclude|defer|bounded|clang-format|clang-tidy|compile_commands|compdb|refresh" README.md tools/bazel/README.md .clang-tidy .clangd prusa`

## Remaining Explicit Boundaries (Non-Blocking)

- The authoritative test surface is still intentionally bounded to `//tools/bazel:test_suite`; broader CTest-only suites remain tracked legacy exceptions.
- Formatting excludes the inherited proof-slice core translation units in `src/libslic3r/{BoundingBox.cpp,Config.cpp,Point.cpp,PrintConfig.cpp}`.
- Lint excludes `tests/libslic3r/test_config.cpp` and broader legacy/GUI surfaces because the current signal-to-noise ratio is not yet acceptable.

## Conclusion

Phase 4 is complete. The Bazel-first local workflow now has real bounded tests, formatting, lint, and editor metadata without relying on legacy build generation.

---
*Verified: 2026-04-07T22:52:28Z*
*Verifier: orchestrator*
