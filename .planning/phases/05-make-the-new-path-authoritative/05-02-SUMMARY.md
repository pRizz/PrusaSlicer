---
phase: 05-make-the-new-path-authoritative
plan: 02
subsystem: docs
tags: [docs, bazel, contributors, authority, legacy-exit]
requires:
  - phase: 05-01
    provides: one authoritative Linux/macOS Bazel CI workflow and demoted legacy automation
provides:
  - one maintained Bazel-first Linux/macOS contributor guide
  - README and CONTRIBUTING entry-point updates
  - legacy CMake docs recast as tracked exception references
affects: [phase-05-verification]
tech-stack:
  added: [single maintained Bazel contributor guide]
  patterns: [one guide, explicit legacy exceptions, authority policy tied to bridge inventories]
key-files:
  created:
    - doc/Build and Tooling - Bazel.md
    - .planning/phases/05-make-the-new-path-authoritative/05-02-SUMMARY.md
  modified:
    - README.md
    - .github/CONTRIBUTING.md
    - doc/How to build - Linux et al.md
    - doc/How to build - Mac OS.md
    - tools/bazel/README.md
    - tools/bazel/policies/proof_slice_bridges.md
    - tools/bazel/policies/system_libraries.bzl
key-decisions:
  - "Use one maintained Bazel-first Linux/macOS guide instead of trying to keep multiple transition notes synchronized forever."
  - "Recast the Linux/macOS CMake build docs as tracked exception references instead of deleting them or pretending they are still peers."
  - "Keep the bridge and system-library inventories as the explicit source of truth for remaining legacy exceptions during authority transfer."
requirements-completed: [TOOL-04, CI-03]
completed: 2026-04-08
---

# Phase 5 Plan 02 Summary

**The repo now has one maintained Bazel-first contributor guide, and the legacy build docs read as tracked exception references instead of the primary workflow**

## Accomplishments

- Added `doc/Build and Tooling - Bazel.md` as the maintained Linux/macOS guide for build, test, format, lint, and editor metadata.
- Updated `README.md` and `.github/CONTRIBUTING.md` so contributors are pointed at the authoritative Bazel-first workflow and CI gate first.
- Recast `doc/How to build - Linux et al.md` and `doc/How to build - Mac OS.md` as legacy CMake exception references.
- Updated the Bazel subtree docs and policy files so the remaining bridge/system-library exception inventories are explicitly part of the authority-transfer story.

## Task Commits

Each task was committed atomically:

1. **Task 1: Publish one maintained Bazel-first Linux/macOS contributor guide** - `62699bc34` (`docs`)
2. **Task 2: Recast legacy build docs as tracked exception references with a clear legacy exit policy** - `62699bc34` (`docs`)

Additional execution-time correction:
- `17eb647ca` `fix(05): orchestrator corrections` (updated Linux prerequisites in the authoritative guide to match the CI bootstrap)

## Verification

- `rg -n "Build and Tooling - Bazel|./prusa build|./prusa test|./prusa fmt|./prusa lint|./prusa compdb|authoritative|legacy|exception|tracked|proof_slice_bridges|system_libraries" README.md .github/CONTRIBUTING.md doc/Build\ and\ Tooling\ -\ Bazel.md doc/How\ to\ build\ -\ Linux\ et\ al.md doc/How\ to\ build\ -\ Mac\ OS.md tools/bazel/README.md tools/bazel/policies/proof_slice_bridges.md tools/bazel/policies/system_libraries.bzl`

## Resulting Authority Language

- One maintained Linux/macOS Bazel guide is the documented front door.
- Bazel is stated as authoritative for Linux/macOS build, test, format, lint, and editor metadata changes.
- Legacy CMake docs remain only as tracked exception references.
- The remaining bridge/system-library inventories remain visible and are explicitly named as the source of truth for what is still deferred.
