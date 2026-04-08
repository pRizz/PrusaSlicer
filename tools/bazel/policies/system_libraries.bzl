"""Central registry for Bazel system-library exceptions.

Phase 2 default:
- Source-fetched dependencies are preferred.
- System-library exceptions require explicit approval here.
- Historical CMake/Linux dynamic-link behavior does not automatically carry over.

Phase 5 note:
- This file remains the source of truth for tracked system-library exceptions
  while the Bazel Linux/macOS path becomes authoritative.
"""

def system_library_exception(
        name,
        allowed_platforms,
        scope,
        rationale,
        lifetime):
    return {
        "name": name,
        "allowed_platforms": allowed_platforms,
        "scope": scope,
        "rationale": rationale,
        "lifetime": lifetime,
    }

SYSTEM_LIBRARY_EXCEPTIONS = [
    system_library_exception(
        name = "phase-03-linux-proof-slice-system-libs",
        allowed_platforms = ["linux-aarch64"],
        scope = [
            "//src:PrusaSlicer",
            "//tests/libslic3r:config_test",
        ],
        rationale = "Linux/arm64 proof uses distro-provided Boost, TBB, EXPAT, libpng, and Catch2 because the checked-in vendor archives under deps/build/destdir/usr/local/lib are macOS arm64 Mach-O artifacts.",
        lifetime = "Retire when the bounded proof slice links against Bazel-owned or imported Linux vendor artifacts instead of distro packages.",
    ),
]
