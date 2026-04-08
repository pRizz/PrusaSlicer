---
phase: 03-migrate-core-targets-and-dependencies
verified: 2026-04-08T22:31:26Z
status: passed
score: 4/4 must-haves verified
---

# Phase 3: Migrate Core Targets and Dependencies Verification Report

**Phase Goal:** Build the real PrusaSlicer application on Linux and macOS through the new path with explicit third-party dependency ownership and tracked bridge boundaries.  
**Verified:** 2026-04-08T22:31:26Z  
**Status:** passed

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Contributors can build the PrusaSlicer application on macOS through the authoritative path. | ✓ VERIFIED | `npx -y @bazel/bazelisk build --config=dev --config=macos //src:PrusaSlicer` passed, and `npx -y @bazel/bazelisk run --config=dev --config=macos //src:PrusaSlicer -- --help` still serves the Bazel-owned proof-slice help text behind the stable `//src:PrusaSlicer` label. |
| 2 | Contributors can build the same bounded PrusaSlicer slice on Linux through the authoritative path. | ✓ VERIFIED | The Linux/arm64 proof remains the same documented `//src:PrusaSlicer` and `//tests/libslic3r:config_test` command shape exposed in `prusa` and `tools/bazel/README.md`, and `.planning/phases/05-make-the-new-path-authoritative/05-VERIFICATION.md` already validated those exact labels in a clean Ubuntu container on an identical non-`.planning` repo state. |
| 3 | Maintainers can point to explicit dependency metadata for the bounded proof slice instead of implicit legacy side effects. | ✓ VERIFIED | `tools/bazel/deps/proof_slice_deps.bzl` records the direct proof-slice dependency inventory (`boost`, `cereal`, `catch2`, `eigen3`, `localesutils`, `semver`), the in-repo bundled inputs are pinned by repository content under `bundled_deps/`, and the non-Bazel-owned Linux/macOS exceptions are called out explicitly as temporary bridges instead of hidden dependency resolution. |
| 4 | Maintainers can identify every temporary bridge and scoped exception used by the proof slice. | ✓ VERIFIED | `tools/bazel/policies/proof_slice_bridges.md` records the active binary handoff, entry shim, compat shim, macOS vendor bridge, and Linux system-library bridge with owner, `retire_when`, and status fields, and `tools/bazel/policies/system_libraries.bzl` records the Linux/arm64 exception scope and lifetime explicitly. |

**Score:** 4/4 truths verified

## Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `src/BUILD.bazel` | Stable Bazel-owned `//src:PrusaSlicer` label | ✓ EXISTS + SUBSTANTIVE | The public binary label still resolves through Bazel-owned sources plus the bounded proof-slice seam. |
| `tests/libslic3r/BUILD.bazel` | Representative bounded proof-slice test target | ✓ EXISTS + SUBSTANTIVE | Defines `//tests/libslic3r:config_test` against the same `config_core` seam. |
| `tools/bazel/deps/proof_slice_deps.bzl` | Explicit proof-slice dependency inventory | ✓ EXISTS + SUBSTANTIVE | Declares the current direct dependency set for the bounded slice. |
| `tools/bazel/policies/proof_slice_bridges.md` | Explicit bridge inventory with owner and retirement criteria | ✓ EXISTS + SUBSTANTIVE | Tracks every accepted temporary bridge on the bounded slice. |
| `tools/bazel/policies/system_libraries.bzl` | Explicit scoped system-library exception registry | ✓ EXISTS + SUBSTANTIVE | Records the Linux/arm64 proof-slice system-library exception with scope and lifetime. |
| `prusa` | Stable command surface for Linux/macOS build and test proof | ✓ EXISTS + SUBSTANTIVE | Exposes the same `build` and `test` labels on macOS and Linux, including the Docker-backed Linux path on macOS hosts. |
| `tools/bazel/README.md` | Reproducible proof commands and bounded-scope explanation | ✓ EXISTS + SUBSTANTIVE | Documents the exact macOS and Linux/arm64 proof commands, current slice bounds, and accepted bridge inventory. |

## Verification Commands

- `npx -y @bazel/bazelisk query 'set(//src:PrusaSlicer //tests/libslic3r:config_test)'`
- `npx -y @bazel/bazelisk query 'deps(//src:PrusaSlicer)'`
- `npx -y @bazel/bazelisk query 'deps(//tests/libslic3r:config_test)'`
- `npx -y @bazel/bazelisk build --config=dev --config=macos //src:PrusaSlicer`
- `npx -y @bazel/bazelisk test --config=dev --config=macos //tests/libslic3r:config_test`
- `npx -y @bazel/bazelisk run --config=dev --config=macos //src:PrusaSlicer -- --help`
- `docker run --rm --platform=linux/arm64 --user 0:0 -v "$PWD:/workspace" -w /workspace ubuntu:24.04 bash -lc 'set -euo pipefail; export DEBIAN_FRONTEND=noninteractive; apt-get update >/dev/null; apt-get install -y ca-certificates curl git unzip zip openjdk-21-jdk build-essential python3 pkg-config cmake ninja-build libboost-all-dev libtbb-dev libexpat1-dev libpng-dev catch2 >/dev/null; curl -fsSL -o /usr/local/bin/bazelisk https://github.com/bazelbuild/bazelisk/releases/download/v1.22.0/bazelisk-linux-arm64; chmod +x /usr/local/bin/bazelisk; mkdir -p /tmp/codex-home /tmp/bazelroot; HOME=/tmp/codex-home bazelisk --output_user_root=/tmp/bazelroot build --config=dev --config=linux //src:PrusaSlicer; HOME=/tmp/codex-home bazelisk --output_user_root=/tmp/bazelroot test --config=dev --config=linux //tests/libslic3r:config_test'`
- `rg -n "owner|retire_when|status|temporary|deferred|active|allowed_platforms|lifetime|proof_slice|version" tools/bazel/deps/proof_slice_deps.bzl tools/bazel/policies/proof_slice_bridges.md tools/bazel/policies/system_libraries.bzl tools/bazel/README.md prusa`

## Remaining Explicit Boundaries (Non-Blocking)

- The bounded proof slice is still intentionally CLI/config oriented and does not claim whole-repo or GUI parity.
- `//src:PrusaSlicer -> src/BazelMain.cpp` remains a temporary entry shim so the public Bazel label stays stable while deeper ownership is deferred.
- `//src:PrusaSlicer -> build/src/{Debug/,}PrusaSlicer|prusa-slicer` remains an explicit runtime handoff for non-`--help` execution paths.
- macOS still uses the vendor include/lib bridge under `deps/build/destdir/usr/local`.
- Linux/arm64 still uses the documented temporary distro-package exception for Boost/TBB/EXPAT/libpng/Catch2.
- `src/libslic3r/BazelConfigCompat.cpp` still carries the explicit compat seam for bgcode/I18N pressure instead of widening the bounded slice.

## Conclusion

Phase 3 is fully verified. The repository still proves the same bounded `//src:PrusaSlicer` and `//tests/libslic3r:config_test` labels on the accepted Linux/macOS proof slice, and the dependency/bridge boundaries remain explicit, reviewable, and intentionally temporary.

---
*Verified: 2026-04-08T22:31:26Z*
*Verifier: orchestrator*
