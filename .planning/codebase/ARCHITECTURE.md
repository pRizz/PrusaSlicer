# Architecture

**Analysis Date:** 2026-04-03

## Pattern Overview

**Overall:** Cross-platform desktop application with a layered C++ core, CLI front end, and optional wxWidgets GUI.

**Key Characteristics:**
- Single product executable on each platform, with Windows wrapper binaries and symlinked entry names on Unix-like systems.
- The slicing engine is centralized in `libslic3r` and reused by both CLI and GUI flows.
- The GUI is an optional layer enabled by `SLIC3R_GUI`; the CLI can run headless slicing workflows.
- Several helper libraries are split out for narrow concerns such as arrange, sequential decimation, OpenGL preview, and STEP import.

## Layers

**Launch and Platform Layer:**
- Purpose: Start the process, normalize platform quirks, and hand off to CLI or GUI runtime.
- Contains: `src/PrusaSlicer.cpp`, Windows entry shims, platform resource manifests.
- Depends on: CLI layer, `libslic3r`, and GUI init when enabled.
- Used by: The built application entry points.

**Command-Line Layer:**
- Purpose: Parse arguments, load models/configuration, and decide whether to slice or start the GUI.
- Contains: `src/CLI/CLI.hpp`, `src/CLI/Run.cpp`, `src/CLI/Setup.cpp`, `src/CLI/LoadPrintData.cpp`, `src/CLI/ProcessTransform.cpp`, `src/CLI/ProcessActions.cpp`.
- Depends on: `libslic3r`, arrange wrappers, and optional GUI init helpers.
- Used by: `src/PrusaSlicer.cpp`.

**GUI Layer:**
- Purpose: Build the wxWidgets application, create windows, manage user interaction, and host the 3D preview/editor.
- Contains: `src/slic3r/GUI/GUI_App.hpp`, `src/slic3r/GUI/GUI_Init.cpp`, `src/slic3r/GUI/GUI.cpp`, `src/slic3r/GUI/MainFrame.cpp`, `src/slic3r/GUI/Plater.cpp`.
- Depends on: `libslic3r`, `libvgcode`, `slic3r-arrange-wrapper`, wxWidgets, OpenGL, and platform helpers.
- Used by: CLI when `start_gui` is true and by the GUI launcher path.

**Slicing and Geometry Core:**
- Purpose: Provide the actual slicing, mesh processing, G-code generation, support generation, and format import/export logic.
- Contains: `src/libslic3r/**`, especially `src/libslic3r/GCode/*`, `src/libslic3r/Geometry/*`, `src/libslic3r/SLA/*`, `src/libslic3r/Format/*`.
- Depends on: third-party geometry, compression, and build-time dependency packages.
- Used by: CLI, GUI, arrange, and tests.

**Specialized Support Libraries:**
- Purpose: Encapsulate reusable subdomains with narrower APIs.
- Contains: `src/slic3r-arrange`, `src/slic3r-arrange-wrapper`, `src/libseqarrange`, `src/libvgcode`, `src/occt_wrapper`.
- Depends on: `libslic3r` and their own external libraries.
- Used by: GUI, CLI arrange paths, and optional STEP/import features.

## Data Flow

**CLI Invocation Flow:**

1. User runs `PrusaSlicer` or `prusa-slicer`.
2. `src/PrusaSlicer.cpp` forwards to `Slic3r::CLI::run()`.
3. `src/CLI/Setup.cpp` parses flags into `CLI::Data`.
4. `src/CLI/LoadPrintData.cpp` loads model and configuration data into `Model` objects and `DynamicPrintConfig`.
5. `src/CLI/ProcessTransform.cpp` applies transforms and geometry edits.
6. `src/CLI/ProcessActions.cpp` executes export, profile-sharing, or other action-oriented operations.
7. If GUI startup is needed, `src/slic3r/GUI/GUI_Init.cpp` initializes wxWidgets and hands off to `GUI::GUI_App`.

**GUI Startup Flow:**

1. CLI parsing decides `start_gui` or `start_as_gcodeviewer`.
2. `src/slic3r/GUI/GUI_Init.cpp` creates `GUI::GUI_App`.
3. `GUI::GUI_App::OnInit()` builds the main window stack and loads app config.
4. The user interacts with `MainFrame`, `Plater`, dialogs, and gizmos.
5. Background jobs and preview updates call back into `libslic3r` and `libvgcode`.

**State Management:**
- Runtime state is mostly in memory and owned by the app object graph.
- Persistent state is external to the codebase in app config, profiles, projects, and imported/exported files.
- The CLI path is intentionally transient and returns exit codes instead of maintaining process state.

## Key Abstractions

**`libslic3r` Engine:**
- Purpose: Core slicing and geometry model.
- Examples: `Model`, `Print`, `PrintObject`, `Flow`, `TriangleMesh`, `GCodeWriter`.
- Pattern: Domain library with many focused modules and shared data types.

**`CLI::Data`:**
- Purpose: Aggregates command-line input into config groups and file lists.
- Examples: `input_config`, `overrides_config`, `transform_config`, `actions_config`.
- Pattern: Parse-result object passed through the CLI pipeline.

**`GUI_App`:**
- Purpose: Owns app lifecycle, localization, OpenGL, single-instance behavior, and global GUI services.
- Examples: `src/slic3r/GUI/GUI_App.hpp`, `src/slic3r/GUI/GUI_Init.cpp`.
- Pattern: wxWidgets application singleton with service members.

**Arrange wrappers:**
- Purpose: Adapt general packing/arrangement algorithms to PrusaSlicer model and scene types.
- Examples: `src/slic3r-arrange-wrapper/include/arrange-wrapper/SceneBuilder.hpp`, `src/slic3r-arrange-wrapper/src/ModelArrange.cpp`.
- Pattern: Adapter layer over `slic3r-arrange`.

## Entry Points

**Native entry:**
- Location: `src/PrusaSlicer.cpp`
- Triggers: OS process launch.
- Responsibilities: Platform-specific startup, UTF-8 argument handling on Windows, dispatch to `Slic3r::CLI::run()`.

**CLI runner:**
- Location: `src/CLI/Run.cpp`
- Triggers: Application start after argument normalization.
- Responsibilities: Decide GUI vs headless flow, load input data, apply actions, return exit status.

**GUI initialization:**
- Location: `src/slic3r/GUI/GUI_Init.cpp`
- Triggers: GUI-enabled startup path.
- Responsibilities: Create `GUI_App`, check single-instance policy, start wx event loop.

## Error Handling

**Strategy:** Fail fast at the top boundary, propagate exceptions through core code, and convert them to exit codes or message boxes near the entry point.

**Patterns:**
- `src/slic3r/GUI/GUI_Init.cpp` catches `Slic3r::Exception` and `std::exception`, logs, and shows a modal error.
- `src/CLI/Run.cpp` returns nonzero on parse/load/action failures.
- `src/PrusaSlicer.cpp` stays thin and delegates error policy downstream.

## Cross-Cutting Concerns

**Logging:**
- Boost.Log is wired in GUI initialization, with optional file logging via `SLIC3R_LOG_TO_FILE`.
- The GUI also wraps wx logging with `LogGui` in `src/slic3r/GUI/GUI_App.hpp`.

**Validation:**
- Argument and config validation happen at the CLI boundary before slicing work starts.
- Build-time feature flags control platform-specific and optional modules such as GUI, STEP support, and tests.

**Platform behavior:**
- Windows uses wrapper executables and resource manifests from `src/platform/msw`.
- macOS and Linux use symlink and bundle setup in `src/CMakeLists.txt`.
- `src/occt_wrapper/CMakeLists.txt` shows optional STEP/OpenCASCADE integration behind `SLIC3R_ENABLE_FORMAT_STEP`.

*Architecture analysis: 2026-04-03*
*Update when major patterns change*
