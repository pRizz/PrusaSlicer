"""Bounded dependency metadata for the Phase 3 proof slice."""

# The first Wave 1 proof owns only the Bazel binary boundary and one narrow
# seam. The only approved system-level header dependency at this point is Boost
# on macOS so `src/PrusaSlicer.cpp` can compile.
PROOF_SLICE_COPTS = [
    "-Isrc",
    "-Ibuild/src/libslic3r",
]
