# Phase 1 Linux Proof Evidence

**Phase:** 01 - Evaluate Build-System Fit  
**Date:** 2026-04-04  
**Status:** In progress

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

## Notes

- This proof run reuses the Phase 1 prototype sandboxes and does not attempt broader dependency migration, packaging, GUI parity, or Windows work.
- The goal is not “green build at any cost”; it is auditable Linux evidence for both candidates against the same agreed slice.

---
*Phase: 01-evaluate-build-system-fit*
*Linux proof started: 2026-04-04*
