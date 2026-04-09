---
phase: 08-deepen-owned-runtime-slice
plan: 01
subsystem: runtime
tags: [bazel, runtime, entrypoint, deps, macos]
requires: []
provides:
  - Real `src/PrusaSlicer.cpp` primary Bazel entrypoint
  - Explicit per-library runtime imports instead of the aggregate vendor-lib bridge
  - Explicit Catch2 test-only deps for the bounded suite
requirements-completed: [BRDG-02, DEEP-01]
completed: 2026-04-09
generated_by: gsd-execute-plan
lifecycle_mode: yolo
phase_lifecycle_id: 08-2026-04-09T07-50-49
generated_at: 2026-04-09T07:50:49Z
---

# Phase 8 Plan 01 Summary

**The Bazel runtime now enters through the real `src/PrusaSlicer.cpp` path, and the macOS runtime dependency bridge is narrowed to explicit imported artifacts**

## Accomplishments

- Replaced the temporary `src/BazelMain.cpp` binary source with `src/PrusaSlicer.cpp`.
- Removed the broad `proof_slice_vendor_libs` runtime dependency from `config_core` in favor of explicit imported libraries.
- Made Catch2 explicit in the test targets that actually need it instead of inheriting it transitively from runtime deps.
