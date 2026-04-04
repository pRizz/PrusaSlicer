# Phase 1 Linux Proof Evidence

**Phase:** 01 - Evaluate Build-System Fit  
**Date:** 2026-04-04  
**Status:** Completed

## Linux environment

- **Execution mode:** Docker container on the current macOS host
- **Container base:** Debian Bookworm
- **Mounted workspace:** `/workspace` → `/Users/peterryszkiewicz/Repos/PrusaSlicer`
- **Representative slice:** `src/PrusaSlicer.cpp`, `src/CLI/Run.cpp`, `src/CLI/Setup.cpp`, and `tests/libslic3r/test_config.cpp`

## Candidate commands

### Bazel command

```bash
cd /workspace/.planning/phases/01-evaluate-build-system-fit/prototypes/bazel
npx -y @bazel/bazelisk version
npx -y @bazel/bazelisk build //:prusaslicer_cli_eval
npx -y @bazel/bazelisk test //:libslic3r_core_eval_test
```

### Meson command

```bash
cd /workspace/.planning/phases/01-evaluate-build-system-fit/prototypes/meson
python3 -m venv .venv
./.venv/bin/pip install meson==1.10.0
./.venv/bin/meson setup builddir
./.venv/bin/meson compile -C builddir prusaslicer_cli_eval
./.venv/bin/meson test -C builddir libslic3r_core_eval_test
```

## Core test target

- **Representative core test target:** `tests/libslic3r/test_config.cpp`
- **Reason:** It stays inside the selected Phase 1 slice and exercises the existing `tests/libslic3r/` proof surface without dragging Phase 1 into broader test-migration work.

## Expected evidence

- Bazel Linux app-build result
- Bazel Linux core-test result
- Meson Linux app-build result
- Meson Linux core-test result
- Exact blocking failures if either candidate cannot satisfy the proof bar

## Results

### Bazel Linux result

- **Environment:** Debian Bookworm container with `nodejs`, `npm`, `python3`, `python3-venv`, `g++`, `make`, and `git`
- **Bazel version command:** `npx -y @bazel/bazelisk version`
- **Result:** Passed and installed Bazel `9.0.1`
- **App proof command:** `npx -y @bazel/bazelisk build //:prusaslicer_cli_eval`
- **App proof outcome:** Reached real source compilation, then failed
- **Observed blockers:**
  - `boost/nowide/cstdlib.hpp` not found from `src/CLI/Setup.cpp`
  - `../PrusaSlicer.hpp` not found from `src/CLI/Run.cpp`
- **Core test command:** `npx -y @bazel/bazelisk test //:libslic3r_core_eval_test`
- **Core test outcome:** Reached test-target compilation, then failed
- **Observed blocker:**
  - `catch2/catch_test_macros.hpp` not found from `tests/libslic3r/test_config.cpp`
- **Interpretation:** The Linux Bazel prototype does exercise the agreed app/test slice. The remaining failures are now concrete dependency/include-model blockers rather than untested uncertainty.

### Meson Linux result

- **Environment:** Debian Bookworm container with `python3`, `python3-venv`, `g++`, `make`, `git`, and `ninja-build`
- **Meson install command:** `./.venv/bin/pip install meson==1.10.0`
- **Meson setup command:** `./.venv/bin/meson setup builddir`
- **Setup outcome:** Passed after installing `ninja-build`
- **App proof command:** `./.venv/bin/meson compile -C builddir prusaslicer_cli_eval`
- **App proof outcome:** Reached real source compilation, then failed
- **Observed blockers:**
  - `boost/nowide/cstdlib.hpp` not found from `src/CLI/Setup.cpp`
  - `libslic3r_version.h` not found from `src/CLI/Run.cpp`
  - `boost/nowide/args.hpp` not found from `src/PrusaSlicer.cpp`
- **Core test command:** `./.venv/bin/meson test -C builddir libslic3r_core_eval_test`
- **Core test outcome:** Reached test-target compilation, then failed
- **Observed blocker:**
  - `catch2/catch_test_macros.hpp` not found from `tests/libslic3r/test_config.cpp`
- **Interpretation:** The Linux Meson prototype also exercises the agreed app/test slice. Its first blocker was environment-level (`ninja-build` missing), which was auto-fixed, after which the prototype exposed the same class of missing dependency/generated-header problems as Bazel.

## Linux proof conclusion

- The Linux proof gap is now closed from an evidence standpoint: both candidates were run against the agreed Linux proof slice and one core Linux test target.
- Neither candidate satisfied the Linux proof bar with the intentionally shallow prototype.
- Both candidates failed for concrete, auditable reasons tied to dependency closure and generated-header/include modeling rather than because the Linux run was never attempted.
- This phase no longer carries missing Linux proof as uncertainty; it now carries explicit Linux blocker evidence for both candidates.

## Notes

- This proof run reuses the Phase 1 prototype sandboxes and does not attempt broader dependency migration, packaging, GUI parity, or Windows work.
- The goal is not “green build at any cost”; it is auditable Linux evidence for both candidates against the same agreed slice.

---
*Phase: 01-evaluate-build-system-fit*
*Linux proof completed: 2026-04-04*
