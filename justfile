# List the available Bazel convenience recipes.
default:
    @just --list --unsorted

# Show the authoritative `./prusa` command help.
help:
    ./prusa help

# Build the bounded Bazel-owned product slice for the host platform.
build:
    ./prusa build

# Build the bounded Bazel-owned product slice with the macOS config.
build-macos:
    ./prusa build --platform macos

# Build the bounded Bazel-owned product slice with the Linux config.
build-linux:
    ./prusa build --platform linux

# Run the bounded Bazel test suite for the host platform.
test:
    ./prusa test

# Run the bounded Bazel test suite with the macOS config.
test-macos:
    ./prusa test --platform macos

# Run the bounded Bazel test suite with the Linux config.
test-linux:
    ./prusa test --platform linux

# Check formatting for the bounded Bazel-owned surface.
fmt:
    ./prusa fmt --check

# Apply formatting fixes for the bounded Bazel-owned surface.
fmt-fix:
    ./prusa fmt --fix

# Run bounded clang-tidy checks.
lint:
    ./prusa lint

# Refresh the compile database used by clangd.
compdb:
    ./prusa compdb

# Run the maintained macOS proof, including the owned `--save [--load ...]` flow.
proof-macos:
    #!/usr/bin/env bash
    set -euo pipefail
    ./prusa build --platform macos
    ./prusa test --platform macos
    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' EXIT
    BUILD_WORKSPACE_DIRECTORY="$tmpdir/does-not-exist" "$PWD/bazel-bin/src/PrusaSlicer" --save "$tmpdir/default.ini"
    BUILD_WORKSPACE_DIRECTORY="$tmpdir/does-not-exist" "$PWD/bazel-bin/src/PrusaSlicer" --load "$PWD/tests/data/test_config/new_from_ini.ini" --save "$tmpdir/loaded.ini"

# Run the maintained Linux proof on Linux or via Docker from macOS.
proof-linux:
    ./prusa build --platform linux
    ./prusa test --platform linux
