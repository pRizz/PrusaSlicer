---
phase: 08-deepen-owned-runtime-slice
verified: 2026-04-09T09:25:00Z
status: passed
score: 2/2 must-haves verified
generated_by: gsd-verifier
lifecycle_mode: yolo
phase_lifecycle_id: 08-2026-04-09T07-50-49
generated_at: 2026-04-09T07:50:49Z
lifecycle_validated: true
---

# Phase 8: Deepen Owned Runtime Slice Verification Report

**Phase Goal:** Replace the temporary entry shim and pull one high-value dependency bridge into explicit Bazel ownership for the deeper macOS slice.  
**Verified:** 2026-04-09T09:25:00Z  
**Status:** passed

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | The temporary `src/BazelMain.cpp` shim no longer defines the primary execution path. | ✓ VERIFIED | `src/BUILD.bazel` now builds `//src:PrusaSlicer` from `src/PrusaSlicer.cpp`, the old `src/BazelMain.cpp` file is removed, and the out-of-workspace `--save` proof still succeeds through the same public label. |
| 2 | The deepened macOS slice replaced a broad runtime dependency bridge with explicit imported artifacts. | ✓ VERIFIED | `src/libslic3r:config_core` now depends directly on explicit imported Boost/TBB/EXPAT/libpng/zlib archives on macOS instead of the aggregate `proof_slice_vendor_libs` bridge, while Catch2 is now explicit and test-scoped in `tests/libslic3r` and `tests/thumbnails`. |

**Score:** 2/2 truths verified

## Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `src/BUILD.bazel` | Real entrypoint for `//src:PrusaSlicer` | ✓ EXISTS + SUBSTANTIVE | Uses `PrusaSlicer.cpp` as the primary binary source. |
| `src/libslic3r/BUILD.bazel` | Explicit runtime imports instead of broad vendor-lib bridge | ✓ EXISTS + SUBSTANTIVE | Lists per-library imports directly for the macOS runtime slice. |
| `tests/libslic3r/BUILD.bazel` + `tests/thumbnails/BUILD.bazel` | Explicit test-scoped Catch2 deps | ✓ EXISTS + SUBSTANTIVE | Catch2 is now test-only instead of inherited from runtime deps. |
| `tools/bazel/policies/proof_slice_bridges.md` | Retired entry shim and updated dependency-bridge story | ✓ EXISTS + SUBSTANTIVE | Removes the shim from the active bridge inventory and narrows the remaining bridge story. |

## Verification Commands

- `npx -y @bazel/bazelisk build --config=dev --config=macos //src:PrusaSlicer`
- `npx -y @bazel/bazelisk test --config=dev --config=macos //src/CLI:bazel_owned_cli_test //tests/libslic3r:config_test //tests/thumbnails:thumbnails_test`
- `./prusa test --platform macos`
- `tmpdir=$(mktemp -d); BUILD_WORKSPACE_DIRECTORY="$tmpdir/does-not-exist" "$PWD/bazel-bin/src/PrusaSlicer" --save "$tmpdir/default.ini"`

## Remaining Explicit Boundaries (Non-Blocking)

- Unsupported export, slice, and profile-query paths still use the narrowed legacy runtime handoff.
- Linux parity for the deeper owned runtime slice remains Phase 9 work.
- The macOS include bridge is still broad at the header level even though the runtime library bridge is now explicit.

## Conclusion

Phase 8 is complete. The primary Bazel runtime entrypoint is now the real `src/PrusaSlicer.cpp` path, and the macOS runtime dependency bridge is narrower and more explicit than before.

---
*Verified: 2026-04-09T09:25:00Z*
*Verifier: orchestrator*
