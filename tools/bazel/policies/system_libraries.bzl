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

# Keep the registry empty until a real exception is approved.
SYSTEM_LIBRARY_EXCEPTIONS = []
