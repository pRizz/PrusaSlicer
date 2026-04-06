# Phase 3 Proof Slice Bridges

| label | kind | scope | reason | owner | retire_when | status |
|-------|------|-------|--------|-------|-------------|--------|
| `//src:PrusaSlicer -> build/src/Debug/PrusaSlicer` | binary handoff | macOS | Keeps the remaining runtime handoff narrow while later Phase 3 waves replace more of the CLI/core path with Bazel-owned source | Bazel migration | `//src:PrusaSlicer` can run the selected proof path without `execv` handoff | active |
| `//src:PrusaSlicer -> src/BazelMain.cpp` | entry shim | macOS | Avoids the oversized `libslic3r/libslic3r.h` header fanout from `src/PrusaSlicer.cpp` while preserving the stable public Bazel label | Bazel migration | a Bazel-owned CLI/core seam can replace the temporary shim without changing the `//src:PrusaSlicer` label | temporary |
| `//src/libslic3r:config_core -> deps/build/destdir/usr/local/include + libbgcode/boost/tbb/Catch2 static libs` | external dependency bridge | macOS | Keeps Wave 3 test pressure bounded to a config-oriented seam while using already-built third-party artifacts instead of migrating the full vendor graph at once | Bazel migration | direct per-lib Bazel ownership or a narrower dependency import replaces the raw include/lib bridge for the proven slice | temporary |

## Not Allowed In Wave 1

- Bridging a broad prebuilt `libslic3r` subtree
- Bridging `admesh`
- Bridging an opaque pack of internal static libraries
