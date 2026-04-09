---
phase: 07-replace-runtime-handoff
plan: 01
subsystem: cli
tags: [bazel, cli, macos, runtime-handoff, save-workflow]
requires: []
provides:
  - Bazel-owned non-help `--save` CLI workflow on macOS
  - Direct config save/load path behind `//src:PrusaSlicer`
  - Regression test for the owned save seam
requirements-completed: [EXEC-01, EXEC-03, BRDG-01]
completed: 2026-04-09
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 07-2026-04-09T07-29-06
generated_at: 2026-04-09T07:29:06Z
---

# Phase 7 Plan 01 Summary

**Bazel now owns a real non-help `--save` CLI workflow on macOS behind the stable `//src:PrusaSlicer` label**

## Accomplishments

- Added a narrow owned CLI seam for `--save <file>` with optional repeated `--load <file>`.
- Kept unsupported arguments on the legacy fallback, so the runtime handoff is narrower rather than hidden.
- Added `//src/CLI:bazel_owned_cli_test` as a regression guard for the new owned seam.
