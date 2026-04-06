# Phase 3 Proof Slice Bridges

| label | kind | scope | reason | owner | retire_when | status |
|-------|------|-------|--------|-------|-------------|--------|
| `//src:PrusaSlicer -> build/src/{Debug/,}PrusaSlicer|prusa-slicer` | binary handoff | macOS, Linux | Keeps the remaining runtime handoff narrow while later Phase 3 work replaces more of the CLI/core path with Bazel-owned source | Bazel migration | `//src:PrusaSlicer` can run the selected proof path without `execv` handoff | active |
| `//src:PrusaSlicer -> src/BazelMain.cpp` | entry shim | macOS, Linux | Avoids the oversized `libslic3r/libslic3r.h` header fanout from `src/PrusaSlicer.cpp` while preserving the stable public Bazel label | Bazel migration | a Bazel-owned CLI/core seam can replace the temporary shim without changing the `//src:PrusaSlicer` label | temporary |
| `//src/libslic3r:config_core -> BazelConfigCompat.cpp bgcode/I18N stubs` | compat shim | macOS, Linux | Keeps binary G-code metadata parsing and GUI-driven translation callbacks out of the bounded config proof while still allowing config serialization and INI loading to be exercised | Bazel migration | the bounded slice owns these call sites directly or a later GCode/I18N migration lands | deferred |
| `//src/libslic3r:config_core -> deps/build/destdir/usr/local/include + boost/tbb/expat/libpng/Catch2 static libs` | external dependency bridge | macOS | Keeps the config-oriented seam bounded while using the existing macOS vendor install tree instead of migrating the full third-party graph at once | Bazel migration | direct per-lib Bazel ownership or a narrower dependency import replaces the raw include/lib bridge for the proven slice | temporary |
| `//src/libslic3r:config_core -> Linux distro packages (Boost/TBB/EXPAT/libpng/Catch2)` | system-library bridge | Linux/arm64 | Linux proof uses distro packages because the checked-in vendor archives are macOS arm64 Mach-O artifacts and Wave 4 stays inside the bounded proof slice | Bazel migration | Linux proof moves to Bazel-owned or imported Linux vendor artifacts for the same labels | temporary |

## Not Allowed In Wave 1

- Bridging a broad prebuilt `libslic3r` subtree
- Bridging `admesh`
- Bridging an opaque pack of internal static libraries
