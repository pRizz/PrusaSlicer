# Bazel Skeleton Layout

This directory holds the Bazel-owned structural skeleton introduced in Phase 2.

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
- `//tests/libslic3r:config_test` passes on macOS and Linux/arm64 against the same `config_core` seam
- `--help` is served directly by Bazel-owned source, while other runtime paths still use the explicit legacy binary handoff in `tools/bazel/policies/proof_slice_bridges.md`
- binary G-code metadata parsing and GUI-driven translation callbacks are explicitly deferred through `src/libslic3r/BazelConfigCompat.cpp`

macOS proof commands:

```shell
npx -y @bazel/bazelisk build --config=dev --config=macos //src:PrusaSlicer
npx -y @bazel/bazelisk test --config=dev --config=macos //tests/libslic3r:config_test
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
./prusa test --dry-run
./prusa fmt --dry-run
./prusa lint --dry-run
./prusa compdb --dry-run
```

Direct Bazel equivalents remain visible through the wrapper output and the
shared `.bazelrc` config names:

- `--config=linux`
- `--config=macos`
- `--config=compdb`

## Policy

System-library exceptions are centralized in
`tools/bazel/policies/system_libraries.bzl`.

The default stance is source-fetched ownership. A system-library exception is
allowed only by explicit registry entry with documented scope, rationale, and
lifetime.
