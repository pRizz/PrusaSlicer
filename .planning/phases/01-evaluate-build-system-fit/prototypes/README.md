# Phase 1 Prototype Comparison

This directory holds the narrow Phase 1 proof artifacts for comparing Bazel and Meson + Ninja against the same PrusaSlicer slice.

## Proof Intent

The prototypes are not a migration. They are controlled evaluation artifacts for:
- one app-oriented PrusaSlicer target shape,
- one representative core test target shape,
- contributor command surface,
- editor metadata viability,
- and CI command shape.

## Representative Slice

The comparison is anchored to:
- `src/PrusaSlicer.cpp`
- `src/CLI/Run.cpp`
- `src/CLI/Setup.cpp`
- one representative core test suite under `tests/libslic3r/`

The prototypes intentionally avoid full GUI parity, packaging, Windows support, and broad dependency migration.

## Bazel Prototype

Location:
- `prototypes/bazel/MODULE.bazel`
- `prototypes/bazel/BUILD.bazel`

Representative commands:

```bash
cd .planning/phases/01-evaluate-build-system-fit/prototypes/bazel
npx -y @bazel/bazelisk version
npx -y @bazel/bazelisk build //:prusaslicer_cli_eval
npx -y @bazel/bazelisk test //:libslic3r_core_eval_test
```

Editor/tooling notes:
- `clangd` support is expected to require a Bazel-specific compilation database bridge rather than falling out of the build by default.
- Format/lint command shape would likely be explicit wrapper targets or repo scripts rather than native editor-first defaults.
- Phase 1 tooling proof path:

```bash
cd .planning/phases/01-evaluate-build-system-fit/prototypes/bazel
npx -y @bazel/bazelisk run :refresh_compile_commands -- //:prusaslicer_cli_eval //:libslic3r_core_eval_test
xcrun clang-format --dry-run --Werror /Users/peterryszkiewicz/Repos/PrusaSlicer/src/CLI/Run.cpp
```

- Current Phase 1 result: the compile-commands extractor path is concrete but failed under the Bazel 9 prototype because the extractor expected `py_binary` support that was not available in the current setup. Formatting command shape is concrete via `clang-format`; `clang-tidy` remains unproven in this environment.

## Meson Prototype

Location:
- `prototypes/meson/meson.build`

Representative commands:

```bash
cd .planning/phases/01-evaluate-build-system-fit/prototypes/meson
python3 -m pip install --user meson==1.10.0
meson setup builddir
meson compile -C builddir prusaslicer_cli_eval
meson test -C builddir libslic3r_core_eval_test
```

Editor/tooling notes:
- `compile_commands.json` is expected to drop out more naturally from Meson/Ninja.
- Format/lint commands would still need explicit repo documentation, but the editor metadata path is simpler.

## Linux Proof

Minimum acceptable evidence:
- candidate command shape is concrete,
- prototype files reference the agreed slice,
- app-oriented target attempt is documented,
- core test target attempt is documented,
- dependency friction is recorded rather than hidden.

## macOS Smoke-Build

Minimum acceptable evidence:
- command shape is explicit,
- candidate-specific toolchain assumptions are recorded,
- and viability is judged concretely rather than hand-waved.

## Deferred From Phase 1

- full GUI parity
- packaging parity
- Windows support
- full third-party dependency migration
- removal of CMake from the repo
