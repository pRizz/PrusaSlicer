---
phase: 09-re-establish-linux-parity
plan: 01
subsystem: linux
tags: [bazel, linux, parity, system-libraries]
requires: []
provides:
  - Linux build/test proof for the deepened runtime slice
  - Explicit Linux runtime-vs-test system-library split
requirements-completed: [EXEC-02, DEEP-02]
completed: 2026-04-09
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 09-2026-04-09T08-46-33
generated_at: 2026-04-09T08:46:33Z
---

# Phase 9 Plan 01 Summary

**Linux now proves the deeper owned runtime slice through the same public labels, with explicit runtime and test-only exception boundaries**

## Accomplishments

- Confirmed `./prusa build --platform linux` builds the deepened `//src:PrusaSlicer` target.
- Confirmed `./prusa test --platform linux` passes the bounded suite including the owned CLI regression test.
- Split the Linux exception story so Catch2 is test-only instead of implicitly part of the runtime bridge.
