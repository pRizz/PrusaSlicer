# Phase 1 Candidate Scorecard

**Phase:** 01 - Evaluate Build-System Fit  
**Date:** 2026-04-04  
**Status:** Decision-ready with Linux blocker evidence

## Evidence Summary

### Bazel

- Tool availability: `npx -y @bazel/bazelisk version` succeeded and provided Bazel 9.0.1.
- Prototype shape: `MODULE.bazel` + `BUILD.bazel` under `prototypes/bazel/`.
- Real command attempted: `npx -y @bazel/bazelisk build //:prusaslicer_cli_eval`
- Result after prototype blocker fixes: Bazel analyzed the target graph and reached real compilation of `src/CLI/Setup.cpp` and `src/CLI/Run.cpp`.
- First meaningful failure:
  - missing `boost/nowide/cstdlib.hpp`
  - missing `../PrusaSlicer.hpp` include resolution in the prototype target shape
- Linux core-test command attempted: `npx -y @bazel/bazelisk test //:libslic3r_core_eval_test`
- Linux core-test failure:
  - missing `catch2/catch_test_macros.hpp`
- Interpretation: Bazel reached the real source layer, but only after explicit module/rule wiring and with clear dependency/include-model pressure showing up immediately.

### Meson + Ninja

- Tool availability: system Python blocked `pip --user`, so Meson was installed via a local venv under the phase sandbox. A Linux rerun also required `ninja-build` in the container environment.
- Prototype shape: `meson.build` under `prototypes/meson/`.
- Real commands attempted:
  - `./.venv/bin/meson setup builddir`
  - `./.venv/bin/meson compile -C builddir prusaslicer_cli_eval`
  - `./.venv/bin/meson test -C builddir libslic3r_core_eval_test`
- Result after prototype symlink fix: Meson configured successfully and reached real compilation of `src/PrusaSlicer.cpp`, `src/CLI/Run.cpp`, and `src/CLI/Setup.cpp`.
- First meaningful failure:
  - missing `boost/nowide/args.hpp`
  - missing `boost/nowide/cstdlib.hpp`
  - missing generated `libslic3r_version.h`
- Linux core-test failure:
  - missing `catch2/catch_test_macros.hpp`
- Interpretation: Meson reached the same real source pressure with less build-definition friction, but the dependency and generated-header story is still substantial.

## Hard-gate outcomes

| Hard Gate | Bazel | Meson + Ninja | Notes |
|-----------|-------|---------------|-------|
| Linux app proof | Fail | Fail | Both candidates were executed in a Linux container against the agreed slice and failed on concrete dependency/include-model blockers |
| Linux core test proof | Fail | Fail | Both candidates reached the representative Linux core test target and failed on concrete missing test/dependency closure |
| macOS smoke-build path | Pass | Pass | Both candidates reached real source compilation attempts on macOS |
| Editor metadata without legacy build | Fail | Pass | Bazel tooling proof used a concrete compile-commands extractor path, but it failed under the current Bazel 9 prototype with a `py_binary` tooling integration error |
| Format/lint command surface | Partial | Pass | Bazel has a concrete `clang-format` command path, but `clang-tidy` remains blocked by missing metadata output and missing local binary |
| Contributor-facing command clarity | Pass | Pass | Both have explicit commands documented in `prototypes/README.md` |
| Scope discipline | Pass | Pass | Both prototypes stayed inside the agreed Phase 1 boundary |

## Weighted score results

### Raw Scores

| Dimension | Weight | Bazel | Meson + Ninja | Notes |
|-----------|--------|-------|---------------|-------|
| Reliability | 30 | 5.0 | 3.5 | Bazel’s graph and Bzlmod model align more strongly with the repo’s repeatability goal |
| Contributor UX | 20 | 3.0 | 4.0 | Meson is simpler to bring up and reason about locally |
| Developer ergonomics | 20 | 3.0 | 4.0 | Meson has the easier path to `compile_commands.json`; Bazel likely needs extra tooling |
| CI and platform fit | 15 | 4.5 | 3.5 | Bazel’s command model maps cleanly to explicit CI targeting once established |
| Dependency model quality | 10 | 5.0 | 3.5 | Bzlmod is stronger for explicit, pinned, source-oriented dependency ownership |
| Maintenance burden | 5 | 2.5 | 3.5 | Meson has the lower day-1 build-rule burden; Bazel carries more rule and bridge pressure |

### Weighted Totals

| Candidate | Weighted Score | Interpretation |
|-----------|----------------|----------------|
| Bazel | 3.98 | Stronger long-term fit under the project’s stated priorities, even though the Linux prototype still fails |
| Meson + Ninja | 3.75 | Better short-term ergonomics, but still weaker on the highest-weighted long-term dimensions |

## Candidate Comparison Notes

### Bazel strengths

- Best match for the project’s top-ranked goal: reliability and repeatability.
- Strongest dependency model for replacing opaque CMake/discovery behavior with explicit ownership.
- Cleanest long-term story for CI command shape and one authoritative graph.
- Linux execution now shows the prototype reaches the real app/test slice before failing, so the remaining blocker is explicit rather than hypothetical.

### Bazel weaknesses

- Higher authoring friction in the prototype itself.
- Bazel's selected compile-commands path failed under the current prototype and remains an explicit contributor-UX risk.
- Likely higher bridge pressure in early migration work.
- Linux proof still fails on unresolved dependency/include closure in the current shallow prototype.

### Meson strengths

- Faster path to real compilation attempts in a small prototype.
- Better immediate contributor UX and editor ergonomics.
- Lower build-definition burden for a brownfield C++ codebase.
- After installing `ninja-build`, Linux execution also reached the real app/test slice rather than stopping at environment setup.

### Meson weaknesses

- Weaker long-term dependency ownership story than Bazel for this project.
- Less aligned with the repo’s stated emphasis on explicit reproducibility.
- More likely to preserve a “good local build, weaker global build graph” shape.
- Linux proof still fails on concrete dependency/generated-header closure rather than clearing the agreed proof bar.

## Decision Input

The weighted score still favors **Bazel** under the project’s locked priorities, even though Meson is the easier Phase 1 prototype and remains the more credible fallback if Bazel later proves too painful in real migration work.

The hard-gate record is no longer incomplete. Linux app-build and Linux core-test proof were both executed in a Linux container, and both candidates failed on explicit blockers. Bazel tooling viability is also no longer a vague concern: the chosen metadata path was executed and failed with a concrete integration error, while the formatting command surface is real and the lint path remains blocked by missing metadata plus missing local tooling.

## Commands Run

### Bazel

```bash
cd .planning/phases/01-evaluate-build-system-fit/prototypes/bazel
npx -y @bazel/bazelisk version
npx -y @bazel/bazelisk build //:prusaslicer_cli_eval
npx -y @bazel/bazelisk test //:libslic3r_core_eval_test
npx -y @bazel/bazelisk run :refresh_compile_commands -- //:prusaslicer_cli_eval //:libslic3r_core_eval_test
```

**Tooling outcomes:**
- `refresh_compile_commands` failed with `no native function or rule 'py_binary'`
- `xcrun clang-format --dry-run --Werror src/CLI/Run.cpp` ran and surfaced current formatting drift
- `clang-tidy` was not present on the host, so lint execution was not demonstrated

### Meson

```bash
cd .planning/phases/01-evaluate-build-system-fit/prototypes/meson
python3 -m venv .venv
./.venv/bin/pip install meson==1.10.0
./.venv/bin/meson setup builddir
./.venv/bin/meson compile -C builddir prusaslicer_cli_eval
./.venv/bin/meson test -C builddir libslic3r_core_eval_test
```
