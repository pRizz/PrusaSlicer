# Technology Stack

**Analysis Date:** 2026-04-03

## Languages

**Primary:**
- C++17 - All application, GUI, slicing, and test code in `src/` and `tests/`

**Secondary:**
- CMake - Build orchestration, dependency discovery, and presets in `CMakeLists.txt`, `CMakePresets.json`, and `deps/`
- Shell/docs - Build instructions and helper documentation in `doc/` and `deps/README.md`

## Runtime

**Environment:**
- Desktop native application for Windows, macOS, and Linux
- GUI is optional at build time through `SLIC3R_GUI`
- Command-line slicing is supported through the same C++ core

**Package Manager:**
- No language package manager; the build is CMake-first
- Dependency bundle is driven by CMake `ExternalProject` in `deps/README.md`

## Frameworks

**Core:**
- wxWidgets - Desktop GUI toolkit, enabled through `SLIC3R_GUI`
- OpenGL - 3D scene rendering and preview

**Testing:**
- Catch2 3.8 - Unit and integration tests in `tests/CMakeLists.txt`

**Build/Dev:**
- CMake 3.13+ - Top-level build system in `CMakeLists.txt`
- CMake presets - Default static-dependency and shared-dependency build presets in `CMakePresets.json`
- ExternalProject - Used by `deps/` to fetch and build bundled dependencies

## Key Dependencies

**Critical:**
- Boost 1.83+ - Core utility, filesystem, logging, threading, regex, locale, and nowide support
- Eigen3 3.3.7+ - Geometry and numeric computations
- TBB - Parallel execution and task scheduling
- libcurl - HTTP transport for print-host and download/upload flows
- OpenGL / GLEW - GUI rendering path
- cereal - Serialization support

**Infrastructure:**
- EXPAT - XML parsing
- PNG - Image decoding/encoding support
- NLopt 1.4+ - Optimization routines
- OpenVDB 5.0+ - Volumetric data support, including STEP-related workflows when enabled

## Configuration

**Environment:**
- `SLIC3R_STATIC` controls whether static dependencies are preferred
- `SLIC3R_GUI`, `SLIC3R_OPENGL_ES`, `SLIC3R_DESKTOP_INTEGRATION`, and `SLIC3R_ENABLE_FORMAT_STEP` gate major feature groups
- `OPENVDB_FIND_MODULE_PATH` can point CMake at an OpenVDB find-module location
- `WIN10SDK_PATH` is consulted on Windows for STL-fixing support

**Build:**
- `CMakeLists.txt` is the main configuration entry point
- `CMakePresets.json` defines `default`, `no-occt`, and `shareddeps`
- `deps/README.md` documents `-DPrusaSlicer_BUILD_DEPS:BOOL=ON`

## Platform Requirements

**Development:**
- Works across Windows, macOS, and Linux, but dependency availability differs by platform
- Static dependency bundles are the supported path on Linux per `doc/How to build - Linux et al.md`
- macOS build notes call out CMake and wxWidgets compatibility constraints in `doc/How to build - Mac OS.md`

**Production:**
- Distributed as standalone desktop binaries
- Static builds are the default for Apple and MSVC in `CMakeLists.txt`
- Some features, such as STEP support, depend on optional third-party packages like OpenCASCADE/OpenVDB

---

*Stack analysis: 2026-04-03*
*Update after major dependency changes*
