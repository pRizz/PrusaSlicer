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

Phase 3 starts from a deliberately small Bazel-owned binary boundary:

- `//src:PrusaSlicer`
- one narrow proof-slice bridge if absolutely required
- no broad `libslic3r` or GUI migration in the first step

Owned dependencies for the current proof slice live in
`tools/bazel/deps/proof_slice_deps.bzl`.

Temporary proof-slice bridges live in
`tools/bazel/policies/proof_slice_bridges.md`.

Temporary system-library exceptions for the proof slice are tracked in
`tools/bazel/policies/system_libraries.bzl`.

Current Wave 1 proof result:
- `npx -y @bazel/bazelisk build --config=dev --config=macos //src:PrusaSlicer` succeeds
- `npx -y @bazel/bazelisk run --config=dev --config=macos //src:PrusaSlicer -- --help` succeeds
- The current macOS proof uses a temporary Bazel-only entry shim behind the stable `//src:PrusaSlicer` label to avoid the oversized `libslic3r.h` header fanout in Wave 1

Current Wave 2 seam result:
- `--help` is now served directly by Bazel-owned source behind `//src:PrusaSlicer`
- the remaining runtime handoff is still explicit in `tools/bazel/policies/proof_slice_bridges.md`
- no temporary system-library exception is currently required for this narrowed seam

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
