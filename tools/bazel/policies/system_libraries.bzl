"""Central registry for Bazel system-library exceptions.

Phase 2 default:
- Source-fetched dependencies are preferred.
- System-library exceptions require explicit approval here.
- Historical CMake/Linux dynamic-link behavior does not automatically carry over.
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
        name = "boost_headers",
        allowed_platforms = ["macOS"],
        scope = "//src:PrusaSlicer Wave 1 binary-boundary proof",
        rationale = "PrusaSlicer.cpp requires Boost.Nowide headers before the proof slice can cross the binary boundary; Bazel consumes them through the local repository @boost_headers_macos.",
        lifetime = "temporary",
    ),
]
