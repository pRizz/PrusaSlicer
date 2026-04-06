# Phase 3 Proof Slice Bridges

| label | kind | scope | reason | owner | retire_when | status |
|-------|------|-------|--------|-------|-------------|--------|
| `//src:PrusaSlicer -> build/src/Debug/PrusaSlicer` | binary handoff | macOS | Keeps Wave 1 at a narrow binary boundary while deferring deep CLI/core ownership to later waves | Bazel migration | `//src:PrusaSlicer` can call a Bazel-owned CLI/core implementation without `execv` handoff | active |
| `//src:PrusaSlicer -> src/BazelMain.cpp` | entry shim | macOS | Avoids the oversized `libslic3r/libslic3r.h` header fanout from `src/PrusaSlicer.cpp` while preserving the stable public Bazel label | Bazel migration | a Bazel-owned CLI/core seam can replace the temporary shim without changing the `//src:PrusaSlicer` label | temporary |

## Not Allowed In Wave 1

- Bridging a broad prebuilt `libslic3r` subtree
- Bridging `admesh`
- Bridging an opaque pack of internal static libraries
