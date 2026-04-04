# Phase 2 Research Memo

Phase 2 should add only the structural skeleton needed to make Bazel the obvious front door, not a partial port of PrusaSlicer itself.

## Recommended root artifacts

- Add `MODULE.bazel` at the repo root and treat it as the authoritative module boundary; Bazel requires it at the repo root, and module-based dependency management is the current preferred entry point. [Bazel modules](https://bazel.build/external/module), [External dependencies overview](https://bazel.build/docs/bzlmod)
- Add a thin `.bazelrc` for shared configs such as `dev`, `linux`, `macos`, and `clangd`-adjacent settings, because Bazel expects unchanged command options to live there instead of being duplicated in wrappers. [Write bazelrc configuration files](https://bazel.build/run/bazelrc)
- Keep the workspace root package effectively empty; if a root `BUILD.bazel` is needed at all, it should be only for labels that cannot live elsewhere. Bazel docs explicitly recommend leaving the root package empty when possible. [Concepts and terminology](https://docs.bazel.build/versions/main/build-ref.html)
- Create one small root launcher file, preferably `./prusa`, rather than literal `build` or `test` files, because the repo already has a `build/` directory and the launcher can expose subcommands without colliding with that path. This is an inference from the current repo layout.
- Put all Bazel-owned Starlark and policy under a dedicated subtree such as `tools/bazel/`; do not spread platform, toolchain, and policy logic through `src/` or `deps/`.

## Command-surface guidance

- Make the launcher task-oriented: `./prusa build`, `./prusa test`, `./prusa fmt`, `./prusa lint`, and `./prusa compdb`.
- Each subcommand should print or document its direct Bazel equivalent so contributors can drop to `bazel build`, `bazel test`, `bazel run`, or `bazel cquery` when they need to debug the underlying graph.
- The wrappers should be thin config selectors, not a second build DSL. Their job is to pin the repo defaults from `.bazelrc` and keep Bazel visible.
- README or a short build doc should show the wrapper first and the raw Bazel command second, so the authoritatively supported path is obvious but maintainers still see the real invocation.
- `fmt` and `lint` can be documented now even if their backing targets stay shallow placeholders until Phase 4; the important part is that they remain Bazel-shaped from day one.

## Platform/toolchain layout

- Centralize Linux and macOS branching in one obvious Bazel area, ideally `tools/bazel/platforms/` plus `tools/bazel/toolchains/`, and register the real toolchains from `MODULE.bazel`. Bazel's platform docs describe platform selection, toolchain resolution, and the `target_compatible_with` pattern for platform-specific targets. [Platforms](https://bazel.build/docs/platforms), [Migrating to Platforms](https://bazel.build/concepts/platforms-intro)
- Use built-in constraints like `@platforms//os:linux` and `@platforms//os:osx` first; add custom constraints only if the repo needs a semantic axis that the built-ins cannot express.
- Keep platform-specific compatibility checks at the package boundary with `target_compatible_with` or a small number of `select()`s, not inside every downstream target.
- Windows should only appear as a placeholder extension point or constraint stub in this phase, not as active implementation work.

## Exception-policy shape

- Represent system-library exceptions in one central policy file, such as `tools/bazel/policies/system_libraries.bzl`, and have all exceptions flow through that single registry.
- Each exception entry should carry at least the library name, allowed platforms, scope, rationale, and whether it is temporary or expected to remain long term.
- The default rule should be source-fetched ownership, with system libraries allowed only by explicit opt-in. Bazel's external-dependency docs favor explicit repository rules and source-of-truth dependency declarations, which fits a centralized exception registry. [Working with external dependencies](https://bazel.build/docs/external), [Dependency Management](https://bazel.build/basics/dependencies)
- Avoid hiding exceptions in scattered `new_local_repository`, `local_repository`, or ad hoc shell logic; if a system resource is real, it should be named once and reviewed once. [External dependencies overview](https://bazel.build/docs/bzlmod)

## Deferred scope

- Do not migrate the real PrusaSlicer target graph in Phase 2; that belongs to Phase 3.
- Do not move the full third-party dependency inventory yet; Phase 2 only creates the policy and landing zones for later ownership changes.
- Do not solve packaging, release artifacts, or CI wiring yet; those are later phases.
- Do not attempt full `fmt`, `lint`, or editor integration maturity yet; Phase 2 may only establish the command surfaces and the compile-database path needed for later tooling.
- Do not expand Windows beyond a future placeholder.

## Risks to avoid

- Turning the wrapper layer into a second build system, with business logic or target selection encoded in shell scripts.
- Letting Linux/macOS branching leak into `src/` targets or repeated `select()` fragments.
- Allowing system-library exceptions to grow without a registry, rationale, and reviewable scope.
- Creating broad root-package BUILD logic when Bazel recommends leaving the root package empty where possible.
- Using Phase 2 to solve dependency migration or full app bring-up before the skeleton is stable.
- Relying on deprecated `WORKSPACE`-centric instincts when the module boundary and toolchain registration belong in `MODULE.bazel`. [Bazel modules](https://bazel.build/external/module), [Migrating to Platforms](https://bazel.build/concepts/platforms-intro)

## Planning implications

- The Phase 2 definition of done should be "the repo now has a visible Bazel front door, a documented direct-Bazel escape hatch, a centralized platform/toolchain home, and one place to audit system-library exceptions."
- If the launcher name or path needs to change, settle that before other wrappers are added; naming churn will spread into docs and later phases.
- Phase 3 should be able to consume these skeleton artifacts without renaming the command surface or moving policy files again.
