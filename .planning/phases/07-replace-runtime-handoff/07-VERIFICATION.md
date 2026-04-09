---
phase: 07-replace-runtime-handoff
verified: 2026-04-09T09:05:00Z
status: passed
score: 3/3 must-haves verified
generated_by: gsd-verifier
lifecycle_mode: yolo
phase_lifecycle_id: 07-2026-04-09T07-29-06
generated_at: 2026-04-09T07:29:06Z
lifecycle_validated: true
---

# Phase 7: Replace Runtime Handoff Verification Report

**Phase Goal:** Execute one real non-help PrusaSlicer CLI workflow on macOS through Bazel-owned source while preserving the stable public entry points and narrowing the remaining runtime handoff honestly.  
**Verified:** 2026-04-09T09:05:00Z  
**Status:** passed

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Contributors can run a real non-help CLI workflow through `//src:PrusaSlicer` on macOS without the legacy runtime handoff. | ✓ VERIFIED | Running `bazel-bin/src/PrusaSlicer --save ...` and `bazel-bin/src/PrusaSlicer --load tests/data/test_config/new_from_ini.ini --save ...` succeeds with `BUILD_WORKSPACE_DIRECTORY` pointed at a non-existent path, so the owned save path cannot rely on the legacy `build/src/PrusaSlicer` binary. |
| 2 | The public command surface stays stable while the owned slice deepens. | ✓ VERIFIED | `//src:PrusaSlicer` still builds successfully, `./prusa test --platform macos` now passes with the new CLI regression guard in the bounded suite, and `--help` continues to document the same public label while noting the newly owned `--save` path. |
| 3 | The remaining runtime handoff is narrower and explicitly documented rather than hidden. | ✓ VERIFIED | `tools/bazel/policies/proof_slice_bridges.md` now scopes the legacy runtime handoff to unsupported CLI/runtime paths only, and `tools/bazel/README.md` documents `--save [--load ...]` as the newly owned non-help workflow. |

**Score:** 3/3 truths verified

## Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `src/CLI/BazelOwnedCli.cpp` | Bazel-owned non-help CLI seam | ✓ EXISTS + SUBSTANTIVE | Implements direct `--save` with optional repeated `--load`. |
| `src/CLI/BazelOwnedCliTest.cpp` | Regression guard for the owned seam | ✓ EXISTS + SUBSTANTIVE | Verifies owned save behavior and unsupported-arg fallback. |
| `tools/bazel/BUILD.bazel` | Bounded suite includes new CLI guard | ✓ EXISTS + SUBSTANTIVE | Adds `//src/CLI:bazel_owned_cli_test` to `//tools/bazel:test_suite`. |
| `tools/bazel/policies/proof_slice_bridges.md` | Narrowed handoff scope documented | ✓ EXISTS + SUBSTANTIVE | Records the remaining handoff as unsupported runtime paths only. |
| `tools/bazel/README.md` | Updated proof narrative | ✓ EXISTS + SUBSTANTIVE | Documents the new owned `--save` proof path and verification commands. |

## Verification Commands

- `npx -y @bazel/bazelisk build --config=dev --config=macos //src:PrusaSlicer`
- `npx -y @bazel/bazelisk test --config=dev --config=macos //src/CLI:bazel_owned_cli_test`
- `./prusa test --platform macos`
- `tmpdir=$(mktemp -d); BUILD_WORKSPACE_DIRECTORY="$tmpdir/does-not-exist" "$PWD/bazel-bin/src/PrusaSlicer" --save "$tmpdir/default.ini"`
- `tmpdir=$(mktemp -d); BUILD_WORKSPACE_DIRECTORY="$tmpdir/does-not-exist" "$PWD/bazel-bin/src/PrusaSlicer" --load "$PWD/tests/data/test_config/new_from_ini.ini" --save "$tmpdir/loaded.ini"`
- `tmpdir=$(mktemp -d); BUILD_WORKSPACE_DIRECTORY="$tmpdir/does-not-exist" "$PWD/bazel-bin/src/PrusaSlicer" --help`

## Remaining Explicit Boundaries (Non-Blocking)

- The selected non-help workflow is `--save [--load ...]`; export, slice, and profile-query paths still fall back to the legacy runtime path for now.
- The temporary `src/BazelMain.cpp` entry shim still exists and remains Phase 8 work.
- Linux parity for the deeper owned runtime slice is still Phase 9 work.

## Conclusion

Phase 7 is complete. The first real non-help CLI workflow now runs through Bazel-owned source on macOS behind the stable public label, and the remaining runtime handoff is narrower, explicit, and verified.

---
*Verified: 2026-04-09T09:05:00Z*
*Verifier: orchestrator*
