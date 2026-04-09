# Bazel Skeleton Layout

This directory holds the Bazel-owned structural skeleton introduced in Phase 2.

During Phase 5 authority transfer, this subtree plus
`doc/Build and Tooling - Bazel.md` define the maintained Linux/macOS build,
test, tooling, and exception story for the Bazel path.

## Purpose

- Make Bazel visibly first-class at the repository root
- Centralize Linux/macOS platform and placeholder toolchain structure
- Centralize system-library exception policy
- Keep the root command surface thin and discoverable through `./prusa`

This directory does **not** imply that the full PrusaSlicer target graph is
already migrated. Full product-target migration remains later-phase work.

## Phase 3 Proof Slice

Phase 3 now proves the same bounded Bazel-owned slice on macOS and Linux/arm64:

- `//src:PrusaSlicer`
- `//tests/libslic3r:config_test`
- one shared config-oriented seam in `//src/libslic3r:config_core`
- no broad `libslic3r` or GUI migration in the proof

Owned dependencies for the current proof slice live in
`tools/bazel/deps/proof_slice_deps.bzl`.

Temporary proof-slice bridges live in
`tools/bazel/policies/proof_slice_bridges.md`.

Temporary system-library exceptions for the proof slice are tracked in
`tools/bazel/policies/system_libraries.bzl`.

Current proof status:
- `//src:PrusaSlicer` builds on macOS and Linux/arm64 behind the same public label
- the primary Bazel runtime entrypoint now uses `src/PrusaSlicer.cpp` instead of the temporary `src/BazelMain.cpp` shim
- `//tests/libslic3r:config_test` passes on macOS and Linux/arm64 against the same `config_core` seam
- `--help` and the bounded `--save [--load ...]` workflow are served directly by Bazel-owned source
- unsupported runtime paths still use the explicit narrowed legacy binary handoff in `tools/bazel/policies/proof_slice_bridges.md`
- binary G-code metadata parsing and GUI-driven translation callbacks are explicitly deferred through `src/libslic3r/BazelConfigCompat.cpp`
- macOS runtime imports are now explicit per-library Bazel imports instead of the older aggregate runtime vendor-lib bridge

macOS proof commands:

```shell
npx -y @bazel/bazelisk build --config=dev --config=macos //src:PrusaSlicer
npx -y @bazel/bazelisk test --config=dev --config=macos //src/CLI:bazel_owned_cli_test
npx -y @bazel/bazelisk test --config=dev --config=macos //tests/libslic3r:config_test
tmpdir=$(mktemp -d)
BUILD_WORKSPACE_DIRECTORY="$tmpdir/does-not-exist" "$PWD/bazel-bin/src/PrusaSlicer" --save "$tmpdir/default.ini"
BUILD_WORKSPACE_DIRECTORY="$tmpdir/does-not-exist" "$PWD/bazel-bin/src/PrusaSlicer" --load "$PWD/tests/data/test_config/new_from_ini.ini" --save "$tmpdir/loaded.ini"
```

Linux/arm64 proof commands inside a Linux environment:

```shell
sudo apt-get install -y libboost-all-dev libtbb-dev libexpat1-dev libpng-dev catch2
bazelisk build --config=dev --config=linux //src:PrusaSlicer
bazelisk test --config=dev --config=linux //tests/libslic3r:config_test
```

Linux/arm64 proof command from a macOS host via Docker:

```shell
docker run --rm --platform=linux/arm64 --user 0:0 -v "$PWD:/workspace" -w /workspace ubuntu:24.04 bash -lc '
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get update >/dev/null
apt-get install -y ca-certificates curl git unzip zip openjdk-21-jdk build-essential python3 pkg-config cmake ninja-build libboost-all-dev libtbb-dev libexpat1-dev libpng-dev catch2 >/dev/null
curl -fsSL -o /usr/local/bin/bazelisk https://github.com/bazelbuild/bazelisk/releases/download/v1.22.0/bazelisk-linux-arm64
chmod +x /usr/local/bin/bazelisk
mkdir -p /tmp/codex-home /tmp/bazelroot
HOME=/tmp/codex-home bazelisk --output_user_root=/tmp/bazelroot build --config=dev --config=linux //src:PrusaSlicer
HOME=/tmp/codex-home bazelisk --output_user_root=/tmp/bazelroot test --config=dev --config=linux //tests/libslic3r:config_test
'
```

## Layout

- `BUILD.bazel`
  Root helper package for placeholder front-door labels such as `fmt`, `lint`,
  and `compdb`.
- `platforms/`
  Centralized Linux/macOS platform definitions and future extension points.
- `toolchains/`
  Placeholder toolchain-registration structure for later phases.
- `policies/`
  Centralized build-policy files, including the system-library exception
  registry.

## Front Door

Use the root wrapper first:

```shell
./prusa build --dry-run
./prusa test --platform macos --dry-run
./prusa test --platform linux --dry-run
./prusa fmt --check --dry-run
./prusa fmt --fix --dry-run
./prusa lint --dry-run
./prusa compdb --dry-run
```

Direct Bazel equivalents remain visible through the wrapper output and the
shared `.bazelrc` config names:

- `--config=linux`
- `--config=macos`
- `--config=compdb`

## Phase 4 Test Surface

The current authoritative local Bazel test front door is:

- `//tools/bazel:test_suite`

Its bounded non-GUI contents are:

- `//src/CLI:bazel_owned_cli_test`
- `//tests/libslic3r:config_test`
- `//tests/thumbnails:thumbnails_test`

This is the credible local core test surface for now. It is intentionally not
full CTest parity.

Tracked legacy CTest exceptions still include broader suites such as:

- `tests/fff_print`
- `tests/sla_print`
- `tests/slic3rutils`
- `tests/arrange`
- the larger `tests/libslic3r` CMake suite beyond `config_test`

On macOS, `./prusa test --platform linux` runs the same Bazel suite inside
Docker so the Linux label stays explicit while the project still relies on the
Phase 3 Linux/arm64 containerized proof path.

## Phase 4 Formatting Surface

The current authoritative formatting commands are:

- `./prusa fmt --check`
- `./prusa fmt --fix`

They operate on the bounded Phase 4 C/C++ contributor surface:

- `src/PrusaSlicer.cpp`
- `src/CLI/BazelHandoff.cpp`
- `src/libslic3r/BazelConfigCompat.cpp`
- `tests/libslic3r/BazelCatchMain.cpp`
- `tests/libslic3r/test_config.cpp`
- `tests/thumbnails/BazelCatchMain.cpp`
- `tests/thumbnails/test_thumbnails_ini_string.cpp`
- `tests/thumbnails/test_thumbnails_input_string.cpp`

Tracked formatting exclusions still include:

- `src/libslic3r/BoundingBox.cpp`
- `src/libslic3r/Config.cpp`
- `src/libslic3r/Point.cpp`
- `src/libslic3r/PrintConfig.cpp`
- `tests/fff_print`
- `tests/sla_print`
- `tests/slic3rutils`
- `tests/arrange`
- broader GUI and packaging-heavy source files outside the migrated proof slice

## Phase 4 Lint Surface

The current authoritative lint command is:

- `./prusa lint`

It runs `clang-tidy` on the bounded Bazel-owned contributor surface:

- `src/PrusaSlicer.cpp`
- `src/CLI/BazelHandoff.cpp`
- `src/CLI/BazelOwnedCli.cpp`
- `src/CLI/BazelOwnedCliTest.cpp`
- `src/libslic3r/BazelConfigCompat.cpp`
- `tests/libslic3r/BazelCatchMain.cpp`
- `tests/thumbnails/BazelCatchMain.cpp`
- `tests/thumbnails/test_thumbnails_ini_string.cpp`
- `tests/thumbnails/test_thumbnails_input_string.cpp`

On macOS, the wrapper prefers `clang-tidy` from Homebrew LLVM at
`/opt/homebrew/opt/llvm/bin/clang-tidy`; on Linux it uses `clang-tidy` from
`PATH`.

Tracked lint deferrals currently include:

- broader readability and modernization checks across the legacy tree
- `src/libslic3r/BoundingBox.cpp`
- `src/libslic3r/Config.cpp`
- `src/libslic3r/Point.cpp`
- `src/libslic3r/PrintConfig.cpp`
- `tests/libslic3r/test_config.cpp`
- GUI, packaging, and larger CTest-only suites outside the migrated proof slice

## Phase 4 Editor Metadata

The authoritative metadata refresh command is:

- `./prusa compdb`

It writes the bounded slice compile database to:

- `build/compdb/compile_commands.json`

`.clangd` points editors at `build/compdb`, so contributors only need to rerun
`./prusa compdb` when BUILD targets, source membership, or compile-affecting
flags change for the migrated proof slice.

## Policy

System-library exceptions are centralized in
`tools/bazel/policies/system_libraries.bzl`.

The remaining proof-slice bridge inventory is centralized in
`tools/bazel/policies/proof_slice_bridges.md`.

The default stance is source-fetched ownership. A system-library exception is
allowed only by explicit registry entry with documented scope, rationale, and
lifetime.
