# Phase 5 Research

## What Exists Today

- The bounded Bazel-first local workflow is real after Phase 4:
  - `./prusa test --platform macos|linux`
  - `./prusa fmt --check|--fix`
  - `./prusa lint`
  - `./prusa compdb`
- The current authoritative local Bazel scope is still intentionally bounded:
  - `//src:PrusaSlicer`
  - `//tools/bazel:test_suite`
  - `//tools/bazel/format:{check,fix}`
  - `//tools/bazel/lint:clang_tidy`
  - `//tools/bazel/compdb:refresh`
- Existing GitHub Actions are all legacy reusable-workflow wrappers under `.github/workflows/` and still point at external CMake-first or packaging-oriented workflows:
  - `build_osx.yml`
  - `build_windows.yml`
  - `build_flatpak.yml`
  - `build_osx_asan.yml`
  - `build_flatpak_asan.yml`
  - `build_nogui.yml`
  - `static_analysis.yml`
- Several of those workflows still run on `push`, which means the repo does not yet have one obvious authoritative CI gate for build/test/tooling changes.
- Contributor docs are split:
  - `README.md` has the current Bazel-first front door and bounded Phase 4 scope.
  - `doc/How to build - Linux et al.md` and `doc/How to build - Mac OS.md` still primarily describe legacy CMake flows, with only a transition note at the top.
  - `.github/CONTRIBUTING.md` does not yet point contributors at the authoritative Bazel workflow.

## Constraints Inherited From Earlier Phases

- The macOS build path still depends on the local `deps/build/destdir/usr/local` vendor tree as a tracked bridge; only the Bazel `BUILD.bazel` files under that tree are committed.
- Linux proof still depends on system-library exceptions for the bounded slice.
- The authoritative local workflow is intentionally bounded and must not be overstated into whole-repo parity.
- The user’s earlier authority-cutoff decisions already lock several behaviors:
  - the new path becomes authoritative only once Linux/macOS builds, core tests, contributor tooling, and CI all work on it
  - legacy stays only for tracked temporary exceptions
  - new build-related changes should land in the new path first

## Implications For Phase 5

- CI must validate the same local Bazel-facing commands contributors use, not a different hidden path.
- Because the current macOS build depends on a local vendor tree, CI likely needs explicit macOS dependency bootstrap or cache restore before running the authoritative Bazel commands.
- Linux CI can likely use distro packages directly, mirroring the current Linux bridge.
- Authority in-repo is mostly established by:
  - which workflows run automatically on `push` and `pull_request`
  - what README and contributor docs call the primary path
  - how explicitly the remaining legacy exceptions are documented
- Branch protection itself cannot be fully enforced from repo files alone, so the repo should make the intended required workflow unambiguous and demote legacy automatic workflows to manual/non-authoritative posture where reasonable.

## Recommended Phase 5 Breakdown

1. Create one authoritative Linux/macOS CI workflow.
- Add one workflow that runs on `push` and `pull_request`.
- Use the same Bazel-facing commands already exposed locally.
- Make Linux and macOS jobs explicit.
- Handle current dependency bootstrap honestly instead of hiding it.

2. Demote legacy automatic workflows.
- Keep out-of-scope packaging/Windows workflows available only as manual or explicitly secondary flows.
- Remove `push` triggers from legacy workflows that would otherwise keep authority ambiguous.

3. Publish one maintained Bazel-first contributor guide.
- Create one guide for Linux/macOS build, test, format, lint, and editor metadata.
- Update README and legacy OS build docs to point at it as the authoritative path.
- Keep legacy docs only as tracked exception references.

4. Define the legacy exit policy in repo docs.
- State that Bazel is authoritative for Linux/macOS build/test/tooling changes.
- State which legacy workflows/docs remain as exceptions.
- Keep bridge and exclusion inventories visible.

## Suggested End-Of-Phase Verification

- Linux CI workflow job runs `./prusa build --platform linux`
- Linux CI workflow job runs `./prusa test --platform linux`
- Linux CI workflow job runs `./prusa fmt --check`
- Linux CI workflow job runs `./prusa lint`
- Linux CI workflow job runs `./prusa compdb`
- macOS CI workflow job runs `./prusa build --platform macos`
- macOS CI workflow job runs `./prusa test --platform macos`
- macOS CI workflow job runs `./prusa fmt --check`
- macOS CI workflow job runs `./prusa lint`
- macOS CI workflow job runs `./prusa compdb`
- `README.md`, `.github/CONTRIBUTING.md`, and one dedicated build/tooling guide all point to the same authoritative Bazel-first workflow
- legacy build docs and legacy workflows are explicitly described as exceptions or manual flows rather than the default gate

## Planning Implication

Phase 5 should stay focused on authority transfer for the already-bounded Linux/macOS Bazel surface. It should not try to solve packaging or Windows CI parity, and it should not hide the current dependency bridges in order to claim a cleaner state than the repo actually has.
