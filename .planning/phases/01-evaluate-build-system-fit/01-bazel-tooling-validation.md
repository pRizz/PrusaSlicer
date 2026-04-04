# Phase 1 Bazel Tooling Validation

**Phase:** 01 - Evaluate Build-System Fit  
**Date:** 2026-04-04  
**Status:** Completed with explicit remaining risk

## Chosen proof path

The narrowest Bazel-compatible editor-metadata path for this prototype is Hedron's compile-commands extractor on top of the existing Phase 1 Bazel sandbox.

### Metadata command

```bash
cd .planning/phases/01-evaluate-build-system-fit/prototypes/bazel
npx -y @bazel/bazelisk run :refresh_compile_commands -- //:prusaslicer_cli_eval //:libslic3r_core_eval_test
```

**Expected output:** a `compile_commands.json` file for the representative slice, suitable for `clangd`.

## Command surface

### Editor metadata / clangd

- **Command:** `npx -y @bazel/bazelisk run :refresh_compile_commands -- //:prusaslicer_cli_eval //:libslic3r_core_eval_test`
- **metadata result:** Failed
- **blocker:** Hedron's extractor failed under the current Bazel 9 prototype with:
  - `Error: no native function or rule 'py_binary'`
  - target `//:refresh_compile_commands` therefore did not run successfully
- **interpretation:** The Bazel-side metadata path is concrete and reproducible, but not yet validated in this prototype. The remaining risk is no longer vague; it is specifically the extractor/tooling integration path under the current Bazel 9 setup.

### Format command

- **format command:** `xcrun clang-format --dry-run --Werror /Users/peterryszkiewicz/Repos/PrusaSlicer/src/CLI/Run.cpp`
- **format result:** Command exists and runs on the host
- **evidence:** It reported formatting violations in `src/CLI/Run.cpp`, which proves the command surface is concrete even though the file is not currently clean under that formatter.
- **interpretation:** The format path is documented and directly runnable.

### Lint command

- **lint command:** `clang-tidy -p compile_commands.json src/CLI/Run.cpp`
- **lint result:** Not demonstrated
- **blocker:** `clang-tidy` is not present on the host, and the Bazel metadata path did not yet produce `compile_commands.json`
- **interpretation:** The lint command shape is coherent, but the environment + metadata prerequisites remain unresolved in this prototype.

## Overall result

- Bazel tooling validation did **not** clear the Phase 1 contributor-UX risk.
- The risk is now explicit and evidence-based:
  - metadata generation path chosen
  - command attempted
  - failure mode identified
  - formatting command proven
  - lint path still blocked by missing metadata and missing local binary

## Recommendation

- Keep Bazel's editor/tooling status as an explicit **remaining risk** in the Phase 1 scorecard.
- Carry this forward as an early Phase 2 confirmation gate rather than pretending the tooling path is already solved.
- Do not fall back to CMake-generated metadata to paper over the issue; that would invalidate the Phase 1 question this gap plan was meant to answer.

---
*Phase: 01-evaluate-build-system-fit*
*Tooling validation completed: 2026-04-04*
