# Phase 3 Research

## Recommended Proof Slice

The best first Phase 3 slice is a CLI-only `PrusaSlicer` build path anchored on `src/PrusaSlicer.cpp`, `src/CLI/*`, and the smallest transitive `src/libslic3r` core set needed to compile and run that binary. Pair it with one representative `tests/libslic3r` target that exercises real core behavior without requiring GUI, packaging, or data-heavy end-to-end setup.

This is the right slice because the repo already describes `libslic3r` as a standalone core library and the CLI as a thin wrapper over it, so it proves the core migration path without forcing the GUI stack into the first real port. It also gives a meaningful signal on header ownership, link ordering, and generated-file handling instead of merely compiling a toy library.

## Likely Dependency Cut Line

Phase 3 should explicitly own only the dependencies that the chosen CLI/core slice actually needs, and no more. The initial owned set should start with the core library inputs already known to matter for this code path: project-local sources plus the direct third-party libraries that the core slice really compiles against, likely including Boost, Eigen, TBB, cereal, libcurl, EXPAT, PNG, and any small utility libraries that are directly imported by the slice.

Everything GUI-shaped should stay bridged for now: wxWidgets, OpenGL/GLEW, desktop-integration glue, and any macOS app-bundle behavior. Optional heavier subsystems such as OpenVDB, OCCT, and packaging-oriented dependencies should also remain deferred unless the selected proof target unexpectedly needs them.

The practical rule is: own the minimum dependency set required to make the proof slice real, then convert a bridge into an owned Bazel module only when the slice proves it is unavoidable. Do not pre-own the whole current dependency surface just because it exists in the repo.

## Generated/Build-Product Needs

Bazel C++ rules require headers to be declared in `hdrs` or `srcs`, and generated files can be consumed directly when they are produced by another rule. For this phase, only bring in generated headers or build products that the proof slice directly includes or links against.

That likely means `version.inc`-style metadata, any config header emitted for the slice, and any small generated source/header pair required by the chosen `tests/libslic3r` target. It does not mean porting the full resource, localization, or packaging generation stack.

The clean model is to make each generated product a first-class Bazel output, then feed it into the owning `cc_library`, `cc_binary`, or `cc_test` target explicitly. Avoid hiding generated products behind broad shell bridges that obscure ownership.

## Platform Rollout Guidance

macOS should remain the immediate proving ground, but the target shape must stay identical on Linux. Use one Bazel-owned label graph and vary implementation details with `select()` or platform constraints, not with separate macOS and Linux target trees.

Bazel documents `select()` as the mechanism for choosing configurable attributes from `config_setting` or constraint matches, and it documents platforms as the way to express host/target differences. That fits this phase well: keep the same target names, same dependency graph, and same success criteria on both platforms, then swap sources, defines, or toolchain details where the platform truly differs.

If a source file or small subsystem is genuinely unavailable on one platform, mark that target with `target_compatible_with` instead of cloning the target graph. That keeps Linux evidence honest while preserving a single migration shape.

## Bridge Inventory Shape

Phase 3 needs one visible bridge inventory, not scattered comments in BUILD files. The inventory should be a small table or structured list with one row per bridge and these fields:

- `label` or `bridge name`
- `kind` (`source`, `generated`, `binary`, `system-library`, or `toolchain`)
- `scope` (`macOS`, `Linux`, or both)
- `reason`
- `owner`
- `retire_when`
- `status`

That shape keeps the bridge discussion reviewable and makes it obvious when a bridge has become permanent by accident. A bridge should default to temporary unless the inventory explicitly says otherwise.

## Deferred Scope

Leave these out of Phase 3 unless they are direct blockers for the selected proof slice:

- GUI target migration
- wxWidgets and OpenGL ownership
- Packaging and app-bundle work
- Full test-suite migration beyond one representative `tests/libslic3r` target
- Editor metadata and lint tooling
- Windows support
- Broad third-party ownership beyond the proof slice

This is the point where scope creep would start distorting the phase into a broad platform port instead of a slice-based build migration.

## Risks To Avoid

- Forking the target shape by platform instead of using one shared label graph
- Owning third-party dependencies before the slice proves they are needed
- Treating generated files as informal build side effects instead of explicit Bazel outputs
- Letting bridge notes live only in prose with no retirement condition
- Pulling GUI or packaging work into the first real core build proof

The main technical trap is under-modeling headers and transitive includes. Bazel’s C++ rules enforce header declaration discipline, so the slice should expose hidden include assumptions early rather than papering over them.

## Planning Implications

Phase 3 should be planned as two tightly coupled workstreams:

1. Bring up the CLI/core proof slice on macOS with one real `PrusaSlicer` target and one real `tests/libslic3r` target.
2. Reproduce the same Bazel-owned target shape on Linux, then turn every remaining blocker into an explicit bridge entry or an owned dependency.

Success should be recorded as a stable, shared slice definition that builds on both platforms, not as a loose statement that “the app mostly builds.” If the slice forces a dependency or generated product into the graph, that item should either enter the owned set or be documented as a temporary bridge with a retirement path.

## Sources

- [PrusaSlicer repository](https://github.com/prusa3d/PrusaSlicer) - states that `libslic3r` is standalone and the CLI is a thin wrapper over it.
- [Bazel C/C++ rules](https://bazel.build/reference/be/c-cpp) - header declaration rules, generated source handling, and `cc_library`/`cc_binary` structure.
- [Bazel common definitions](https://bazel.build/reference/be/common-definitions) - `select()` behavior for configurable attributes.
- [Bazel configurable build attributes](https://bazel.build/versions/8.1.0/docs/configurable-attributes) - `select()` and platform-driven configurability.
- [Bazel platforms](https://bazel.build/docs/platforms) - host/target platform modeling and `target_compatible_with`.
- [Bazel Bzlmod overview](https://bazel.build/docs/bzlmod) - direct-dependency ownership and module-based external dependency management.
- [Bazel module extensions](https://bazel.build/external/extension) - override and injection patterns for temporary dependency bridges.
