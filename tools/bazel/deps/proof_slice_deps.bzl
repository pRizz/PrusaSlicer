"""Bounded dependency metadata for the Phase 3 proof slice."""

# The current Phase 3 proof slice owns only a very small Bazel-native CLI help
# seam behind `//src:PrusaSlicer`. It does not yet own a deeper `libslic3r`
# core slice, so the dependency cut line stays intentionally tiny.
PROOF_SLICE_COPTS = [
    "-Isrc",
]
