# Codebase Structure

**Analysis Date:** 2026-04-03

## Directory Layout

```text
PrusaSlicer/
├── CMakeLists.txt           # Top-level build entry and feature switches
├── CMakePresets.json        # Preset build configurations
├── README.md                # Project overview and user-facing summary
├── build-utils/             # Small build-time helpers
├── bundled_deps/           # Vendored dependency sources and patches
├── cmake/                  # Shared CMake modules and platform helpers
├── deps/                   # Dependency build orchestration and cached builds
├── doc/                    # Build docs, localization docs, and maintenance notes
├── resources/              # Runtime assets and localization catalogs
├── sandboxes/              # Experimental standalone targets
├── src/                    # Main application and library code
├── tests/                  # Unit and integration tests plus fixtures
├── build/                  # Local build tree, not source
└── build-default/         # Local build tree, not source
```

## Directory Purposes

**`src/`:**
- Purpose: All production C++ code and per-target CMake files.
- Contains: application launch, CLI, GUI, slicing core, platform shims, and helper libraries.
- Key files: `src/CMakeLists.txt`, `src/PrusaSlicer.cpp`, `src/libslic3r/CMakeLists.txt`, `src/slic3r/CMakeLists.txt`.
- Subdirectories: `CLI/`, `libslic3r/`, `slic3r/`, `slic3r-arrange/`, `slic3r-arrange-wrapper/`, `libseqarrange/`, `libvgcode/`, `occt_wrapper/`, `platform/`, `clipper/`.

**`tests/`:**
- Purpose: Test suites organized by subsystem plus shared fixtures.
- Contains: Catch2-based unit tests, integration tests, and fixture data.
- Key files: `tests/CMakeLists.txt`, `tests/catch_main.hpp`, `tests/test_utils.hpp`.
- Subdirectories: `libslic3r/`, `fff_print/`, `sla_print/`, `arrange/`, `thumbnails/`, `slic3rutils/`, `cpp17/`, `data/`, `example/`.

**`doc/`:**
- Purpose: Build instructions and project documentation.
- Contains: platform build guides, dependency notes, localization guidance, screenshots.
- Key files: `doc/How to build - Linux et al.md`, `doc/How to build - Mac OS.md`, `doc/How to build - Windows.md`, `doc/Dependencies.md`.

**`resources/`:**
- Purpose: Runtime assets shipped with the app.
- Contains: icons, translated `.po`/`.mo` files, template localization catalog.
- Key files: `resources/icons/PrusaSlicer.png`, `resources/localization/PrusaSlicer.pot`.
- Subdirectories: language folders such as `en/`, `de/`, `fr/`, `tr/`, `ko/`.

**`cmake/`:**
- Purpose: Shared build helpers and platform-specific CMake modules.
- Contains: dependency find modules, precompiled-header helpers, OpenVDB helpers, wxWidgets helpers.
- Key files: `cmake/modules/PrecompiledHeader.cmake`, `cmake/modules/FindwxWidgets.cmake`, `cmake/modules/UsewxWidgets.cmake`.

**`bundled_deps/` and `deps/`:**
- Purpose: Third-party source bundles and build orchestration for external dependencies.
- Contains: vendor code, dependency scripts, cached dependency builds.
- Key files: `deps/autobuild.cmake`, dependency-specific package scripts.

**`sandboxes/`:**
- Purpose: Experimental or diagnostic standalone programs.
- Contains: small `main.cpp` entry points and their own `CMakeLists.txt`.
- Key files: `sandboxes/opencsg/main.cpp`, `sandboxes/openvdb/openvdb_example.cpp`, `sandboxes/meshboolean/MeshBoolean.cpp`.

## Key File Locations

**Entry Points:**
- `src/PrusaSlicer.cpp` - Process entry and CLI handoff.
- `src/CLI/Run.cpp` - CLI flow controller.
- `src/slic3r/GUI/GUI_Init.cpp` - GUI startup and wx event loop launch.

**Configuration:**
- `CMakeLists.txt` - Root build configuration and feature toggles.
- `CMakePresets.json` - Preset build settings.
- `version.inc` - Version metadata included by CMake.
- `src/CMakeLists.txt` - Application target wiring.
- `tests/CMakeLists.txt` - Test target wiring.

**Core Logic:**
- `src/libslic3r/` - Slicing engine, geometry, formats, G-code, SLA, support, and utilities.
- `src/slic3r/GUI/` - UI, widgets, dialogs, jobs, and app lifecycle.
- `src/slic3r-arrange/` - Arrange algorithms.
- `src/slic3r-arrange-wrapper/` - App-facing arrange adapters.
- `src/libseqarrange/` - Sequential decimation and related helper library.
- `src/libvgcode/` - G-code preview/rendering library.

**Testing:**
- `tests/libslic3r/` - Core engine tests.
- `tests/fff_print/` - FFF slicing and G-code behavior tests.
- `tests/sla_print/` - SLA support and print behavior tests.
- `tests/arrange/` - Arrange algorithm tests.
- `tests/thumbnails/` - Thumbnail parsing/encoding tests.
- `tests/data/` - Shared fixtures and sample models/configs.

**Documentation:**
- `README.md` - High-level project overview.
- `doc/` - Build and maintenance guides.
- `resources/localization/` - Translation catalogs and generated message files.

## Naming Conventions

**Files:**
- `*.cpp` and `*.hpp` pair modules are the default unit of implementation.
- `*.mm` files are used for Objective-C++ platform glue on macOS.
- `test_*.cpp` names are used for test cases inside suite directories.
- `CMakeLists.txt` is used per target directory.

**Directories:**
- Upper-layer product code is grouped by subsystem, not by technical tier alone.
- Test directories are named by feature or subsystem, such as `fff_print/` and `libslic3r/`.
- Support code for a feature usually lives in a sibling `include/` and `src/` layout, as in `src/slic3r-arrange-wrapper/`.

**Special Patterns:**
- `GUI/` holds the majority of UI code under `src/slic3r/`.
- `GCode/`, `Geometry/`, `SLA/`, and `Format/` under `src/libslic3r/` are domain-specific subtrees.
- `platform/` contains OS-specific packaging and launcher assets.

## Where to Add New Code

**New slicing or geometry logic:**
- Primary code: `src/libslic3r/`
- Tests: `tests/libslic3r/`
- Docs if needed: `doc/`

**New GUI feature:**
- Implementation: `src/slic3r/GUI/`
- Supporting widgets or jobs: `src/slic3r/GUI/Widgets/`, `src/slic3r/GUI/Jobs/`
- Tests: usually behavior-specific tests in `tests/slic3rutils/` or `tests/fff_print/` if the feature touches print flow

**New CLI behavior:**
- Definition: `src/CLI/`
- Entry wiring: `src/CLI/Run.cpp`
- Shared parsing state: `src/CLI/CLI.hpp`

**New arrange-related code:**
- Algorithms: `src/slic3r-arrange/`
- App adapters: `src/slic3r-arrange-wrapper/`
- Tests: `tests/arrange/` and `src/libseqarrange/test/` when relevant

**New platform-specific launcher or packaging work:**
- Windows: `src/platform/msw/`
- macOS: `src/platform/osx/`
- Unix/Linux: `src/platform/unix/`

## Special Directories

**`build/` and `build-default/`:**
- Purpose: Local build outputs and generated artifacts.
- Source: Created by CMake or local build tooling.
- Committed: No, treat as disposable working trees.

**`resources/localization/`:**
- Purpose: Translation source and compiled message catalogs.
- Source: Generated from localization tooling and maintained per language.
- Committed: Yes, because they are runtime assets.

**`tests/data/`:**
- Purpose: Shared fixtures and golden inputs.
- Source: Checked-in models, configs, and SVG/3MF test assets.
- Committed: Yes, used by multiple suites.

*Structure analysis: 2026-04-03*
*Update when directory structure changes*
