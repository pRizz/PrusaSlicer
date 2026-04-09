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
        name = "phase-09-linux-runtime-system-libs",
        allowed_platforms = ["linux-aarch64"],
        scope = [
            "//src:PrusaSlicer",
        ],
        rationale = "Linux/arm64 runtime proof uses distro-provided Boost, TBB, EXPAT, libpng, and zlib because the checked-in vendor archives under deps/build/destdir/usr/local/lib are macOS arm64 Mach-O artifacts.",
        lifetime = "Retire when the deepened runtime slice links against Bazel-owned or imported Linux vendor artifacts instead of distro packages.",
    ),
    system_library_exception(
        name = "phase-09-linux-test-catch2",
        allowed_platforms = ["linux-aarch64"],
        scope = [
            "//tests/libslic3r:config_test",
            "//tests/thumbnails:thumbnails_test",
        ],
        rationale = "Linux/arm64 tests use distro-provided Catch2 explicitly after the runtime bridge was narrowed so test-only dependencies no longer ride through runtime library bundles.",
        lifetime = "Retire when Linux test targets link against Bazel-owned or imported Catch2 artifacts instead of distro packages.",
    ),
]
