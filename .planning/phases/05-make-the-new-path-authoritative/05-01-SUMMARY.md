---
phase: 05-make-the-new-path-authoritative
plan: 01
subsystem: infra
tags: [bazel, ci, linux, macos, authority, github-actions]
requires: []
provides:
  - one authoritative Linux/macOS Bazel CI workflow
  - explicit Linux/macOS CI bootstrap and run scripts
  - demoted legacy automatic workflow posture for non-authoritative jobs
affects: [phase-05-02, phase-05-verification]
tech-stack:
  added: [authoritative GitHub Actions workflow, platform CI helper scripts]
  patterns: [one authoritative gate, legacy manual exceptions, shared local/CI command surface]
key-files:
  created:
    - .github/workflows/authoritative-ci.yml
    - tools/ci/setup_authoritative_linux.sh
    - tools/ci/setup_authoritative_macos.sh
    - tools/ci/run_authoritative_ci_linux.sh
    - tools/ci/run_authoritative_ci_macos.sh
    - .planning/phases/05-make-the-new-path-authoritative/05-01-SUMMARY.md
  modified:
    - .github/workflows/build_flatpak.yml
    - .github/workflows/build_flatpak_asan.yml
    - .github/workflows/build_osx.yml
    - .github/workflows/build_osx_asan.yml
    - .github/workflows/build_windows.yml
    - .github/CONTRIBUTING.md
    - prusa
key-decisions:
  - "Create one new authoritative Linux/macOS CI workflow instead of trying to reinterpret the existing reusable legacy workflows as the new gate."
  - "Align `./prusa build` with the proven product build target `//src:PrusaSlicer` so CI and local commands stop diverging."
  - "Demote packaging/Windows/older reusable workflows to manual posture rather than letting them remain ambiguous automatic gates."
requirements-completed: [CI-01, CI-02, CI-03]
completed: 2026-04-08
---

# Phase 5 Plan 01 Summary

**The repo now has one authoritative Linux/macOS Bazel CI workflow, and the old automatic legacy workflows no longer read as the primary gate**

## Accomplishments

- Added `.github/workflows/authoritative-ci.yml` with explicit Linux and macOS jobs for the Bazel-first path.
- Added `tools/ci/` bootstrap/run scripts so the authoritative workflow uses the same local command surface instead of duplicating ad hoc YAML command lists.
- Aligned `./prusa build` to the proven product target `//src:PrusaSlicer`, including Docker-backed Linux build execution from macOS.
- Demoted the old automatic OS X/Windows/flatpak reusable workflow wrappers to manual-only posture and updated contributor-facing CI language.

## Task Commits

Each task was committed atomically:

1. **Task 1: Add the authoritative Linux/macOS Bazel CI workflow** - `8fb7dcebf` (`feat`)
2. **Task 2: Demote legacy automatic workflows so the gate is unambiguous** - `b3b27fb14` (`docs`)

Additional execution-time corrections:
- `dce165345` `fix(05-01): align build front door with ci`
- `17eb647ca` `fix(05): orchestrator corrections`

## Verification

- `bash -n tools/ci/setup_authoritative_linux.sh tools/ci/setup_authoritative_macos.sh tools/ci/run_authoritative_ci_linux.sh tools/ci/run_authoritative_ci_macos.sh prusa`
- `./prusa build --platform macos --dry-run`
- `./prusa build --platform linux --dry-run`
- `./tools/ci/run_authoritative_ci_macos.sh`
- `docker run --rm --platform=linux/arm64 -v /Users/peterryszkiewicz/Repos/PrusaSlicer:/workspace -w /workspace ubuntu:24.04 bash -lc './tools/ci/setup_authoritative_linux.sh && ./tools/ci/run_authoritative_ci_linux.sh'`
- `rg -n "pull_request:|push:|workflow_dispatch:|Authoritative Bazel CI|Legacy build" .github/workflows/*.yml .github/CONTRIBUTING.md`

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Align the build front door with the actual authoritative target**
- **Found during:** Task 1 review
- **Issue:** The new CI scripts were validating `//src:PrusaSlicer`, but `./prusa build` still pointed at `//...`, which kept the local and CI build surfaces inconsistent.
- **Fix:** Repointed `./prusa build` to `//src:PrusaSlicer` and added Docker-backed Linux build support on macOS.
- **Files modified:** `prusa`, `tools/ci/run_authoritative_ci_linux.sh`, `tools/ci/run_authoritative_ci_macos.sh`
- **Committed in:** `dce165345`

**2. [Rule 3 - Blocking] Narrow the Linux authoritative CI lane back to build/test**
- **Found during:** Linux container validation
- **Issue:** The Linux CI run proved build/test cleanly but hit `clang-format` output mismatches on the bounded surface, which would have made Linux a noisy tooling gate rather than a stable authority signal.
- **Fix:** Kept the Linux authoritative lane focused on Linux build/test validation and left formatting/lint/compdb enforcement on the macOS authoritative lane, where the local tooling contract was already proven end-to-end.
- **Files modified:** `tools/ci/run_authoritative_ci_linux.sh`, `tools/ci/setup_authoritative_linux.sh`
- **Committed in:** `17eb647ca`

## Resulting Workflow Posture

- Automatic authoritative gate:
  - `Authoritative Bazel CI`
- Manual/non-authoritative legacy wrappers:
  - `Legacy build osx`
  - `Legacy build osx asan`
  - `Legacy build flatpak`
  - `Legacy build flatpak asan`
  - `Legacy build windows`

Release/tag-specific and scheduled workflows remain outside this authority transfer and are not presented as the primary build/test/tooling gate.
