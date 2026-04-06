# Phase 3 Proof Slice Bridges

| label | kind | scope | reason | owner | retire_when | status |
|-------|------|-------|--------|-------|-------------|--------|
| `//src:PrusaSlicer -> build/src/Debug/PrusaSlicer` | binary handoff | macOS | Keeps Wave 1 at a narrow binary boundary while deferring deep CLI/core ownership to later waves | Bazel migration | `//src:PrusaSlicer` can call a Bazel-owned CLI/core implementation without `execv` handoff | temporary |

## Not Allowed In Wave 1

- Bridging a broad prebuilt `libslic3r` subtree
- Bridging `admesh`
- Bridging an opaque pack of internal static libraries
