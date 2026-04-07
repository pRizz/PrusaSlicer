# Phase 4 Research

## What Exists Today

- Bazel is already the repo-root front door through [`prusa`](/Users/peterryszkiewicz/Repos/PrusaSlicer/prusa), [`MODULE.bazel`](/Users/peterryszkiewicz/Repos/PrusaSlicer/MODULE.bazel), and [`tools/bazel/BUILD.bazel`](/Users/peterryszkiewicz/Repos/PrusaSlicer/tools/bazel/BUILD.bazel).
- The current Bazel proof slice is still narrow and bounded: [`//src:PrusaSlicer`](/Users/peterryszkiewicz/Repos/PrusaSlicer/src/BUILD.bazel), [`//tests/libslic3r:config_test`](/Users/peterryszkiewicz/Repos/PrusaSlicer/tests/libslic3r/BUILD.bazel), and [`//src/libslic3r:config_core`](/Users/peterryszkiewicz/Repos/PrusaSlicer/src/libslic3r/BUILD.bazel).
- The root wrapper currently exposes `build`, `test`, `fmt`, `lint`, and `compdb`, but `fmt`, `lint`, and `compdb` still point at placeholder `filegroup()` targets.
- Legacy test orchestration still lives in CMake: [`tests/CMakeLists.txt`](/Users/peterryszkiewicz/Repos/PrusaSlicer/tests/CMakeLists.txt), [`tests/libslic3r/CMakeLists.txt`](/Users/peterryszkiewicz/Repos/PrusaSlicer/tests/libslic3r/CMakeLists.txt), and the top-level [`CMakeLists.txt`](/Users/peterryszkiewicz/Repos/PrusaSlicer/CMakeLists.txt) still enable `CTest` and `add_test()`.
- The repo has a root [`clang-format`](/Users/peterryszkiewicz/Repos/PrusaSlicer/.clang-format), but there is no repo-local `.clang-tidy`, no root `.vscode/`, and no dedicated local tooling script tree.
- Current CMake presets only cover configure/build setup; they do not define an authoritative formatting, lint, or editor-metadata workflow, and they do not opt into `CMAKE_EXPORT_COMPILE_COMMANDS`.

## Gaps To Close

- `./prusa test` is still too broad for Phase 4 credibility because it maps to `bazel test --config=dev --config=<platform> //...`; the phase needs a bounded, contributor-usable smoke surface first.
- There is no Bazel-owned implementation behind `fmt`, `lint`, or `compdb`, so the command surface exists only as a shell wrapper and placeholder labels.
- `clangd` support is still unresolved in the repo itself: Phase 1 documented that Hedron's extractor path failed in the Bazel 9 prototype, and there is still no in-repo replacement command or output convention.
- The legacy docs still teach CMake test execution and direct test binaries, so the new path must become the obvious local workflow without erasing the tracked exceptions.
- `clang-tidy` is still not modeled as a concrete repo workflow. The repo has no lint configuration file to anchor a baseline or deferral list.

## Candidate Tools Already Present Or Implied

- `clang-format` is the obvious formatter because the repo already has a canonical style file and Phase 1 confirmed the binary is runnable on the host.
- `clang-tidy` is the obvious first static-analysis tool, but only after the phase defines a bounded compile database and a small warning baseline.
- A Bazel compile database generator remains the main editor-metadata candidate; Phase 1 ruled out the first Hedron prototype, so Phase 4 needs either a working Bazel-native refresh command or a simpler in-tree equivalent.
- `CTest` should remain the legacy escape hatch for tracked exceptions only, not the contributor default.
- Existing Bazel labels can be used as the bounded analysis/test anchors, especially `//tests/libslic3r:config_test` and the current `//src:PrusaSlicer` slice.

## Risks And Constraints Inherited From Phase 3

- The proof slice is still intentionally bounded and does not represent whole-repo parity. Phase 4 must not imply that GUI, packaging, or broad dependency migration are done.
- Linux proof still depends on a temporary system-library bridge for the current slice, recorded in [`tools/bazel/policies/system_libraries.bzl`](/Users/peterryszkiewicz/Repos/PrusaSlicer/tools/bazel/policies/system_libraries.bzl).
- The existing proof-slice bridge inventory in [`tools/bazel/policies/proof_slice_bridges.md`](/Users/peterryszkiewicz/Repos/PrusaSlicer/tools/bazel/policies/proof_slice_bridges.md) is still active, so tooling should not assume the legacy handoff is gone.
- The current platform story is asymmetric in practice even though the labels are shared: macOS is the established proof platform, Linux/arm64 still carries the temporary bridge and packaging assumptions from Phase 3.
- Any formatter or linter scope that tries to cover the whole tree immediately will be noisy because the repo still contains broad legacy directories, generated artifacts, and deferred GUI/packaging surfaces.

## Recommended Phase 4 Breakdown

1. Establish the local test front door first.
- Keep the same Bazel labels on macOS and Linux.
- Promote `//tests/libslic3r:config_test` to the first documented contributor smoke test.
- Add one more bounded core regression target only if it stays non-GUI and cross-platform.
- Keep CTest documented only for tracked exceptions.

2. Replace placeholder formatting with a real check/fix pair.
- Use the repo's existing `.clang-format`.
- Expose explicit `check` and `fix` commands.
- Limit the first pass to the main C/C++ contributor surface and document exclusions up front.

3. Add a small, high-signal lint path.
- Start with the migrated Bazel-owned slice plus a narrow adjacent surface.
- Make failures actionable and keep noisy categories deferred.
- Treat `clang-tidy` as the likely first step, but only if the metadata path is real.

4. Land one obvious editor-metadata refresh command.
- Prefer one conventional output location, likely a repo-root `compile_commands.json` or an equally obvious stable path, that editors can point at directly.
- Make refresh explicit, not magical, and document when contributors need to rerun it.
- Keep the command shape tied to the Bazel-owned slice rather than to the legacy build.

## Suggested End-Of-Phase Verification

- `bazel test --config=dev --config=macos //tests/libslic3r:config_test`
- `bazel test --config=dev --config=linux //tests/libslic3r:config_test`
- `./prusa test --platform macos`
- `./prusa test --platform linux`
- `./prusa fmt --check`
- `./prusa fmt --fix`
- `./prusa lint`
- `./prusa compdb`
- `rg -n "make test|ctest|clangd|compile_commands|clang-tidy|clang-format" README.md doc CMakeLists.txt tests .bazelrc tools/bazel`

## Planning Implication

Phase 4 should be planned as a credibility pass for the contributor workflow, not as CI rollout or final authority transfer. The right success shape is: bounded Bazel tests, bounded formatting, bounded linting, and one obvious metadata refresh command that all work without falling back to legacy build generation.
