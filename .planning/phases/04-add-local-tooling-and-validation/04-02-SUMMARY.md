---
phase: 04-add-local-tooling-and-validation
plan: 02
subsystem: infra
tags: [bazel, formatting, lint, compdb, clangd, phase-4]
requires:
  - phase: 04-01
    provides: bounded authoritative Bazel test surface and root test front door
provides:
  - bounded format check/fix workflow through the Bazel path
  - bounded clang-tidy pass through the Bazel path
  - explicit compile database refresh at build/compdb/compile_commands.json plus .clangd integration
affects: [phase-04-verification, phase-05]
tech-stack:
  added: [rules_shell module dep, clang-format wrapper, clang-tidy wrapper, compile_commands refresh script, .clang-tidy, .clangd]
  patterns: [bounded contributor surface, scratch-safe compdb output, explicit scope and deferral documentation]
key-files:
  created:
    - tools/bazel/format/BUILD.bazel
    - tools/bazel/format/clang_format_targets.bzl
    - tools/bazel/format/run_clang_format.sh
    - tools/bazel/lint/BUILD.bazel
    - tools/bazel/lint/clang_tidy_targets.bzl
    - tools/bazel/lint/run_clang_tidy.sh
    - tools/bazel/compdb/BUILD.bazel
    - tools/bazel/compdb/refresh_compile_commands.sh
    - .clang-tidy
    - .clangd
    - .planning/phases/04-add-local-tooling-and-validation/04-02-SUMMARY.md
  modified:
    - MODULE.bazel
    - .bazelrc
    - prusa
    - tools/bazel/BUILD.bazel
    - README.md
    - tools/bazel/README.md
key-decisions:
  - "Keep formatting bounded to the Bazel-owned glue and adjacent non-GUI tests instead of reformatting inherited core translation units."
  - "Use a high-signal clang-tidy surface and defer tests/libslic3r/test_config.cpp because current Catch SCENARIO macro patterns generate compiler diagnostics before the intended lint signal."
  - "Write editor metadata to build/compdb/compile_commands.json so the output stays scratch-safe under the repo's ignored build tree."
requirements-completed: [TOOL-01, TOOL-02, TOOL-03]
completed: 2026-04-07
---

# Phase 4 Plan 02 Summary

**The placeholder local-tooling commands are now real: bounded `fmt`, `lint`, and `compdb` workflows run through the Bazel-first front door**

## Accomplishments

- Replaced the placeholder formatter with `./prusa fmt --check` and `./prusa fmt --fix`, backed by Bazel shell targets and the repo's existing `.clang-format`.
- Added a bounded `./prusa lint` path that runs `clang-tidy` on the Bazel-owned glue plus the thumbnails regression target using Bazel-derived compile flags.
- Added `./prusa compdb`, which refreshes `build/compdb/compile_commands.json`, and added `.clangd` so editors can point at that conventional output path directly.
- Updated the root docs and Bazel tooling docs to make the format/lint/editor scope and deferrals explicit.

## Task Commits

Each task was committed atomically:

1. **Task 1: Replace placeholder formatting with explicit check and fix targets** - `de125468f` (`feat`)
2. **Task 2: Add a bounded high-signal lint path tied to the migrated slice** - `25f789334` (`feat`)
3. **Task 3: Land one explicit editor-metadata refresh path and root editor hints** - `49d055431` (`feat`)

## Verification

- `./prusa fmt --check --dry-run`
- `./prusa fmt --fix --dry-run`
- `./prusa fmt --fix`
- `./prusa fmt --check`
- `./prusa lint --dry-run`
- `./prusa lint`
- `./prusa compdb --dry-run`
- `./prusa compdb`
- `test -f build/compdb/compile_commands.json`
- `test -f .clang-tidy && test -f .clangd`
- `npx -y @bazel/bazelisk query 'set(//tools/bazel/format:all //tools/bazel/lint:all //tools/bazel/compdb:all)'`
- `rg -n "build/compdb/compile_commands\\.json|exclude|defer|bounded|clang-format|clang-tidy|compile_commands|compdb|refresh" README.md tools/bazel/README.md .clang-tidy .clangd prusa`

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Add `rules_shell` so Bazel shell tooling targets can load**
- **Found during:** Task 1
- **Issue:** The new `sh_binary` formatting target could not load because `rules_shell` was not declared in `MODULE.bazel`.
- **Fix:** Added `bazel_dep(name = "rules_shell", version = "0.6.1")`.
- **Files modified:** `MODULE.bazel`
- **Verification:** `npx -y @bazel/bazelisk query //tools/bazel/format:all`
- **Committed in:** `de125468f`

**2. [Rule 3 - Blocking] Repair partially converted top-level Bazel tool aliases**
- **Found during:** Tasks 2 and 3
- **Issue:** Converting the placeholder `fmt`, `lint`, and `compdb` front-door labels left malformed `filegroup`/`alias` mixes in `tools/bazel/BUILD.bazel`.
- **Fix:** Replaced the broken placeholder stubs with clean `alias()` targets for each implemented tooling command.
- **Files modified:** `tools/bazel/BUILD.bazel`
- **Verification:** `npx -y @bazel/bazelisk query 'set(//tools/bazel/format:all //tools/bazel/lint:all //tools/bazel/compdb:all)'`
- **Committed across:** `de125468f`, `25f789334`, `49d055431`

**3. [Rule 3 - Blocking] Shrink the formatter to avoid an oversized inherited core reformat**
- **Found during:** Task 1
- **Issue:** Including `src/libslic3r/{BoundingBox.cpp,Config.cpp,Point.cpp,PrintConfig.cpp}` turned the formatting pass into a large unrelated cleanup.
- **Fix:** Removed those inherited translation units from the bounded formatting surface, restored them, and documented them as explicit exclusions.
- **Files modified:** `tools/bazel/format/clang_format_targets.bzl`, `README.md`, `tools/bazel/README.md`
- **Verification:** `./prusa fmt --check`
- **Committed in:** `de125468f`

**4. [Rule 3 - Blocking] Defer `tests/libslic3r/test_config.cpp` from the first lint surface**
- **Found during:** Task 2
- **Issue:** Catch `SCENARIO` macro patterns in `test_config.cpp` produced compiler diagnostics before the intended high-signal `clang-tidy` checks could run.
- **Fix:** Removed `test_config.cpp` from the lint target list and documented it as an explicit bounded-surface deferral.
- **Files modified:** `tools/bazel/lint/clang_tidy_targets.bzl`, `.clang-tidy`, `README.md`, `tools/bazel/README.md`
- **Verification:** `./prusa lint`
- **Committed in:** `25f789334`

## Resulting Tooling Surface

- Formatting:
  - `./prusa fmt --check`
  - `./prusa fmt --fix`
- Lint:
  - `./prusa lint`
- Editor metadata:
  - `./prusa compdb`
  - `build/compdb/compile_commands.json`
  - `.clangd -> build/compdb`

All three workflows are bounded intentionally to the migrated Bazel slice and adjacent non-GUI tests rather than claiming whole-repo parity.
