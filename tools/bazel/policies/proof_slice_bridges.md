# Remaining Deep-Slice Bridge Inventory

This file is the source of truth for the remaining bridge and exception
contracts after `v1.1 Slice Deepening` completed its planned implementation
work. The same `//src:PrusaSlicer` label and `./prusa` front door remain
authoritative; any remaining legacy path must be listed here with an explicit
owner and a concrete retirement condition.

| label | kind | scope | reason | owner | retire_when | status |
|-------|------|-------|--------|-------|-------------|--------|
| `//src:PrusaSlicer -> build/src/{Debug/,}PrusaSlicer|prusa-slicer` | binary handoff | macOS, Linux, unsupported export/slice/profile-query paths only | Keeps the unsupported runtime paths explicit while the owned `--help` and `--save [--load ...]` workflows already run through Bazel-owned source behind the same public label | Future deeper CLI/runtime ownership phase | unsupported export, slice, and profile-query paths execute directly from Bazel-owned source | active |
| `//src/libslic3r:config_core -> BazelConfigCompat.cpp bgcode/I18N stubs` | compat shim | macOS, Linux bounded config seam | Keeps binary G-code metadata parsing and GUI-driven translation callbacks out of the bounded config slice while config serialization and INI loading stay exercised | Future config/GCode/I18N slice-deepening phase | the bounded slice owns these call sites directly or a later GCode/I18N migration lands | deferred |
| `//src/libslic3r:config_core -> deps/build/destdir/usr/local/include + explicit Boost/TBB/EXPAT/libpng/zlib imports` | external dependency bridge | macOS runtime slice | Keeps the deepened macOS slice reproducible with explicit per-library imports while the repo still relies on the locally built vendor tree | Future macOS dependency-ownership phase | direct per-library Bazel ownership or a narrower imported-artifact boundary replaces the remaining vendor install dependency | temporary |
| `//src/libslic3r:config_core -> Linux distro packages (Boost/TBB/EXPAT/libpng/zlib)` | system-library bridge | Linux/arm64 runtime slice | Linux proof uses distro runtime libraries because the checked-in vendor archives are macOS arm64 Mach-O artifacts and the deepened slice still needs a bounded Linux runtime bridge | Future Linux dependency-ownership phase | Linux runtime deps move to Bazel-owned or imported Linux vendor artifacts for the same labels | temporary |
| `//tests/libslic3r:config_test + //tests/thumbnails:thumbnails_test -> Linux distro Catch2` | system-library bridge | Linux/arm64 test slice | Linux tests use distro-provided Catch2 explicitly instead of inheriting it through runtime dependency bundles | Future Linux test-dependency ownership phase | Linux test deps move to Bazel-owned or imported Linux Catch2 artifacts | temporary |

## Still Disallowed As "Quick Fixes"

- Bridging a broad prebuilt `libslic3r` subtree
- Bridging `admesh`
- Bridging an opaque pack of internal static libraries
