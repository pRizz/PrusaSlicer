---
phase: 09-re-establish-linux-parity
verified: 2026-04-09T08:46:33Z
status: passed
score: 2/2 must-haves verified
generated_by: gsd-verifier
lifecycle_mode: yolo
phase_lifecycle_id: 09-2026-04-09T08-46-33
generated_at: 2026-04-09T08:46:33Z
lifecycle_validated: true
---

# Phase 9: Re-establish Linux Parity Verification Report

**Phase Goal:** Prove the deeper owned runtime slice on Linux through the same public labels and keep platform-specific dependency exceptions minimal and explicit.  
**Verified:** 2026-04-09T08:46:33Z  
**Status:** passed

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Contributors can run the same deeper Bazel-owned CLI workflow on Linux through the same public labels. | ✓ VERIFIED | A clean Ubuntu `docker run ... './tools/ci/setup_authoritative_linux.sh && ./prusa build --platform linux && ./prusa test --platform linux'` run succeeded after the Phase 8 entrypoint/dependency changes, proving `//src:PrusaSlicer`, `//src/CLI:bazel_owned_cli_test`, `//tests/libslic3r:config_test`, and `//tests/thumbnails:thumbnails_test` on Linux. |
| 2 | Linux platform-specific dependency exceptions are narrower, explicit, and reproducible. | ✓ VERIFIED | `tools/bazel/policies/system_libraries.bzl` now splits Linux runtime libs and Linux test-only Catch2 into separate exception entries, and the BUILD targets mirror that split explicitly instead of relying on a broader mixed exception bucket. |

**Score:** 2/2 truths verified

## Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `deps/build/destdir/usr/local/lib/BUILD.bazel` | Explicit Linux runtime/test exception targets | ✓ EXISTS + SUBSTANTIVE | Splits Linux runtime libs from Linux test-only Catch2. |
| `tests/libslic3r/BUILD.bazel` + `tests/thumbnails/BUILD.bazel` | Explicit Linux test dependency wiring | ✓ EXISTS + SUBSTANTIVE | Tests now depend on Linux Catch2 explicitly. |
| `tools/bazel/policies/system_libraries.bzl` | Narrow Linux exception registry | ✓ EXISTS + SUBSTANTIVE | Records separate runtime and test Linux exceptions. |
| `tools/bazel/README.md` | Reproducible Linux proof commands | ✓ EXISTS + SUBSTANTIVE | Documents the Linux parity proof against the same public labels. |

## Verification Commands

- `docker run --rm --platform=linux/arm64 --user 0:0 -v "$PWD:/workspace" -w /workspace ubuntu:24.04 bash -lc './tools/ci/setup_authoritative_linux.sh && ./prusa build --platform linux && ./prusa test --platform linux'`
- `./prusa test --platform macos`

## Remaining Explicit Boundaries (Non-Blocking)

- Unsupported export, slice, and profile-query paths still use the narrowed legacy runtime handoff.
- Linux still relies on distro-provided runtime libraries for the deepened slice.
- The remaining milestone work is Phase 10 bridge-inventory and verification closeout.

## Conclusion

Phase 9 is complete. The deeper owned slice now proves on Linux through the same public labels, and the Linux exception story is narrower and more explicit than before.

---
*Verified: 2026-04-09T08:46:33Z*
*Verifier: orchestrator*
