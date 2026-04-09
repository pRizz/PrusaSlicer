---
generated_by: gsd-discuss-phase
lifecycle_mode: yolo
phase_lifecycle_id: 08-2026-04-09T07-50-49
generated_at: 2026-04-09T07:50:49Z
---

# Phase 8 Context: Deepen Owned Runtime Slice

## Goal

Move the primary Bazel runtime entrypoint onto `src/PrusaSlicer.cpp` and replace the broad macOS runtime dependency bundle with explicit per-library imports, while keeping the same public labels and bounded test surface intact.

## Decisions

- Use `src/PrusaSlicer.cpp` as the primary Bazel binary source instead of the temporary `src/BazelMain.cpp` shim.
- Replace the aggregated `proof_slice_vendor_libs` runtime dependency bridge with explicit imported Boost/TBB/EXPAT/libpng/zlib artifacts in `config_core`.
- Keep Catch2 explicit and test-scoped rather than dragging it through runtime deps.
- Treat Linux parity as Phase 9 work; Phase 8 is macOS-first slice deepening.
