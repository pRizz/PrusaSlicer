# Bazel Skeleton Layout

This directory holds the Bazel-owned structural skeleton introduced in Phase 2.

## Purpose

- Make Bazel visibly first-class at the repository root
- Centralize Linux/macOS platform and placeholder toolchain structure
- Centralize system-library exception policy
- Keep the root command surface thin and discoverable through `./prusa`

This directory does **not** imply that the full PrusaSlicer target graph is
already migrated. Full product-target migration remains later-phase work.

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
