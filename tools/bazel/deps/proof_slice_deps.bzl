"""Bounded dependency metadata for the Phase 3 proof slice."""

# The current Phase 3 proof slice owns one narrow config-oriented core seam plus
# one representative test target. It still avoids broad GUI/package ownership.
PROOF_SLICE_DIRECT_DEPS = [
    "boost",
    "cereal",
    "catch2",
    "eigen3",
    "localesutils",
    "semver",
]

PROOF_SLICE_COPTS = [
    "-Isrc",
    "-Itests",
]
