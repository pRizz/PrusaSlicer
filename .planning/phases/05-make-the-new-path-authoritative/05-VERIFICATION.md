---
phase: 05-make-the-new-path-authoritative
verified: 2026-04-08T16:02:52Z
status: passed
score: 4/4 must-haves verified
---

# Phase 5: Make the New Path Authoritative Verification Report

**Phase Goal:** Put Linux/macOS CI and contributor guidance on the new path so the repo has one enforceable source of truth and a clear legacy exit.  
**Verified:** 2026-04-08T16:02:52Z  
**Status:** passed

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Maintainers can run Linux CI jobs against the same authoritative build and test targets used locally. | ✓ VERIFIED | `.github/workflows/authoritative-ci.yml` defines a Linux job using `tools/ci/setup_authoritative_linux.sh` and `tools/ci/run_authoritative_ci_linux.sh`, and container validation reached the same `./prusa build --platform linux` / `./prusa test --platform linux` command surface successfully before the former Linux formatting overreach was removed. |
| 2 | Maintainers can run macOS CI jobs against the same authoritative build and test targets used locally. | ✓ VERIFIED | `.github/workflows/authoritative-ci.yml` defines a macOS job using `tools/ci/setup_authoritative_macos.sh` and `tools/ci/run_authoritative_ci_macos.sh`, and `./tools/ci/run_authoritative_ci_macos.sh` passed locally end-to-end. |
| 3 | Contributors can follow one maintained guide for Linux and macOS build, test, format, lint, and editor setup. | ✓ VERIFIED | `doc/Build and Tooling - Bazel.md` now serves as the maintained guide, while `README.md` and `.github/CONTRIBUTING.md` point to it directly. |
| 4 | Maintainers can verify that the authoritative path, not the legacy build, is the gate for new build/test/tooling changes. | ✓ VERIFIED | `Authoritative Bazel CI` is the automatic Linux/macOS workflow on `push` and `pull_request`, while the older OS X/Windows/flatpak wrappers were demoted to manual legacy posture. |

**Score:** 4/4 truths verified

## Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `.github/workflows/authoritative-ci.yml` | Automatic authoritative Linux/macOS CI gate | ✓ EXISTS + SUBSTANTIVE | Runs on `push`, `pull_request`, and manual dispatch with explicit Linux/macOS jobs. |
| `tools/ci/setup_authoritative_linux.sh` | Linux CI bootstrap | ✓ EXISTS + SUBSTANTIVE | Installs the bounded Linux dependency/tooling set and bootstraps `bazelisk`. |
| `tools/ci/setup_authoritative_macos.sh` | macOS CI bootstrap | ✓ EXISTS + SUBSTANTIVE | Installs Homebrew prerequisites, bootstraps `bazelisk`, and builds the current macOS vendor-tree bridge if missing. |
| `tools/ci/run_authoritative_ci_linux.sh` | Linux CI command surface | ✓ EXISTS + SUBSTANTIVE | Runs the authoritative Linux build/test commands. |
| `tools/ci/run_authoritative_ci_macos.sh` | macOS CI command surface | ✓ EXISTS + SUBSTANTIVE | Runs the authoritative macOS build/test/tooling commands. |
| `doc/Build and Tooling - Bazel.md` | One maintained Linux/macOS contributor guide | ✓ EXISTS + SUBSTANTIVE | Covers build, test, format, lint, editor metadata, current scope, and tracked exceptions. |
| `README.md` + `.github/CONTRIBUTING.md` | Authoritative entry-point docs | ✓ EXISTS + SUBSTANTIVE | Point contributors at the Bazel-first guide and the authoritative workflow. |

## Verification Commands

- `bash -n tools/ci/setup_authoritative_linux.sh tools/ci/setup_authoritative_macos.sh tools/ci/run_authoritative_ci_linux.sh tools/ci/run_authoritative_ci_macos.sh prusa`
- `./prusa build --platform macos --dry-run`
- `./prusa build --platform linux --dry-run`
- `./tools/ci/run_authoritative_ci_macos.sh`
- `docker run --rm --platform=linux/arm64 -v /Users/peterryszkiewicz/Repos/PrusaSlicer:/workspace -w /workspace ubuntu:24.04 bash -lc './tools/ci/setup_authoritative_linux.sh && ./prusa build --platform linux && ./prusa test --platform linux'`
- `rg -n "pull_request:|push:|workflow_dispatch:|Authoritative Bazel CI|Legacy build" .github/workflows/*.yml .github/CONTRIBUTING.md`
- `rg -n "Build and Tooling - Bazel|./prusa build|./prusa test|./prusa fmt|./prusa lint|./prusa compdb|authoritative|legacy|exception|tracked|proof_slice_bridges|system_libraries" README.md .github/CONTRIBUTING.md doc/Build\ and\ Tooling\ -\ Bazel.md doc/How\ to\ build\ -\ Linux\ et\ al.md doc/How\ to\ build\ -\ Mac\ OS.md tools/bazel/README.md tools/bazel/policies/proof_slice_bridges.md tools/bazel/policies/system_libraries.bzl`

## Remaining Explicit Boundaries (Non-Blocking)

- The authoritative local and CI surface remains bounded; broader legacy suites and packaging paths are still explicit exceptions.
- The current macOS CI/bootstrap path still depends on the local vendor-tree bridge under `deps/build/destdir/usr/local`.
- The current Linux CI lane focuses on Linux build/test, while bounded formatting/lint/compdb enforcement remains on the macOS authority lane.

## Conclusion

Phase 5 is complete. The repo now has one authoritative Linux/macOS Bazel-first CI and documentation path, with legacy automation and docs explicitly demoted to tracked exception status.

---
*Verified: 2026-04-08T16:02:52Z*
*Verifier: orchestrator*
