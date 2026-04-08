# Authoritative Build and Tooling Workflow

This is the maintained Linux/macOS contributor workflow for PrusaSlicer build,
test, formatting, lint, and editor metadata.

The authoritative commands are the Bazel-first root commands:

```shell
./prusa build --platform <linux|macos>
./prusa test --platform <linux|macos>
./prusa fmt --check
./prusa fmt --fix
./prusa lint
./prusa compdb
```

For Linux/macOS build, test, and tooling changes, this workflow is also what
the `Authoritative Bazel CI` workflow validates in GitHub Actions.

## Linux

Install the current bounded-slice prerequisites:

```shell
sudo apt-get install -y \
  build-essential \
  catch2 \
  clang-format \
  clang-tidy \
  cmake \
  curl \
  git \
  libboost-all-dev \
  libexpat1-dev \
  libpng-dev \
  libtbb-dev \
  ninja-build \
  openjdk-21-jdk \
  pkg-config \
  python3 \
  unzip \
  zip
```

Install `bazelisk` if it is not already on `PATH`, then run:

```shell
./prusa build --platform linux
./prusa test --platform linux
./prusa fmt --check
./prusa lint
./prusa compdb
```

## macOS

Install the current bounded-slice prerequisites:

```shell
brew update
brew install automake cmake git gettext libtool texinfo m4 zlib llvm ninja
brew upgrade automake cmake git gettext libtool texinfo m4 zlib llvm ninja
```

Build the current tracked dependency bridge if it is not already present:

```shell
mkdir -p deps/build
cd deps/build
cmake ..
cmake --build . -j3
cd ../..
```

Then run:

```shell
./prusa build --platform macos
./prusa test --platform macos
./prusa fmt --check
./prusa lint
./prusa compdb
```

Optional cross-check from a macOS host:

```shell
./prusa build --platform linux
./prusa test --platform linux
```

Those Linux commands run inside Docker on macOS and keep the Linux labels
visible without implying host-side cross-compilation.

## Editor Setup

Refresh editor metadata with:

```shell
./prusa compdb
```

This writes:

- `build/compdb/compile_commands.json`

`.clangd` already points editors at `build/compdb`.

Refresh the compile database after:

- changing Bazel BUILD definitions
- moving files into or out of the bounded test/lint surface
- changing compile-affecting flags for the migrated slice

## Current Bounded Scope

The authoritative path today is intentionally bounded.

Product build target:
- `//src:PrusaSlicer`

Authoritative local test suite:
- `//tools/bazel:test_suite`
- `//tests/libslic3r:config_test`
- `//tests/thumbnails:thumbnails_test`

Formatting and lint stay scoped to the Bazel-owned glue and adjacent non-GUI
tests described in [README.md](/Users/peterryszkiewicz/Repos/PrusaSlicer/README.md)
and [tools/bazel/README.md](/Users/peterryszkiewicz/Repos/PrusaSlicer/tools/bazel/README.md).

## Remaining Tracked Exceptions

The authoritative path does not hide the remaining legacy exceptions.

Source of truth:
- [proof_slice_bridges.md](/Users/peterryszkiewicz/Repos/PrusaSlicer/tools/bazel/policies/proof_slice_bridges.md)
- [system_libraries.bzl](/Users/peterryszkiewicz/Repos/PrusaSlicer/tools/bazel/policies/system_libraries.bzl)

Current notable exceptions:
- macOS still relies on the local `deps/build/destdir/usr/local` vendor-tree bridge for the bounded slice.
- Linux still relies on documented system-library exceptions for the bounded slice.
- Broader CTest-only suites and legacy CMake build flows remain available only as tracked exception paths.

## Legacy Exit Policy

- Bazel is authoritative for Linux/macOS build, test, format, lint, and editor-metadata changes.
- New build/test/tooling changes should land in the Bazel path first.
- Legacy CMake and older CI workflows remain only for explicitly tracked exceptions.
- Packaging, Windows, and broader legacy suites are not implied to be authoritative by this guide.

## Legacy References

These older CMake guides remain available only as exception references:

- [How to build - Linux et al.md](/Users/peterryszkiewicz/Repos/PrusaSlicer/doc/How%20to%20build%20-%20Linux%20et%20al.md)
- [How to build - Mac OS.md](/Users/peterryszkiewicz/Repos/PrusaSlicer/doc/How%20to%20build%20-%20Mac%20OS.md)
