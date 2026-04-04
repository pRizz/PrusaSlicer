# Phase 1 Candidate Scorecard

**Phase:** 01 - Evaluate Build-System Fit  
**Date:** 2026-04-04  
**Status:** Decision-ready with documented uncertainty

## Evidence Summary

### Bazel

- Tool availability: `npx -y @bazel/bazelisk version` succeeded and provided Bazel 9.0.1.
- Prototype shape: `MODULE.bazel` + `BUILD.bazel` under `prototypes/bazel/`.
- Real command attempted: `npx -y @bazel/bazelisk build //:prusaslicer_cli_eval`
- Result after prototype blocker fixes: Bazel analyzed the target graph and reached real compilation of `src/CLI/Setup.cpp` and `src/CLI/Run.cpp`.
- First meaningful failure:
  - missing `boost/nowide/cstdlib.hpp`
  - missing `../PrusaSlicer.hpp` include resolution in the prototype target shape
- Interpretation: Bazel reached the real source layer, but only after explicit module/rule wiring and with clear dependency/include-model pressure showing up immediately.

### Meson + Ninja

- Tool availability: system Python blocked `pip --user`, so Meson was installed via a local venv under the phase sandbox.
- Prototype shape: `meson.build` under `prototypes/meson/`.
- Real commands attempted:
  - `./.venv/bin/meson setup builddir`
  - `./.venv/bin/meson compile -C builddir prusaslicer_cli_eval`
- Result after prototype symlink fix: Meson configured successfully and reached real compilation of `src/PrusaSlicer.cpp`, `src/CLI/Run.cpp`, and `src/CLI/Setup.cpp`.
- First meaningful failure:
  - missing `boost/nowide/args.hpp`
  - missing `boost/nowide/cstdlib.hpp`
  - missing generated `libslic3r_version.h`
- Interpretation: Meson reached the same real source pressure with less build-definition friction, but the dependency and generated-header story is still substantial.

## Hard-gate outcomes

| Hard Gate | Bazel | Meson + Ninja | Notes |
|-----------|-------|---------------|-------|
| Linux app proof | Gap | Gap | Current host is macOS; no Linux execution evidence was produced in this phase run |
| Linux core test proof | Gap | Gap | No Linux test execution evidence was produced in this phase run |
| macOS smoke-build path | Pass | Pass | Both candidates reached real source compilation attempts on macOS |
| Editor metadata without legacy build | Risk | Pass | Bazel likely needs extra compile-database tooling; Meson naturally supports `compile_commands.json` |
| Format/lint command surface | Risk | Pass | Both can expose commands, but Meson’s local tooling shape is simpler and closer to compiler defaults |
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
| Bazel | 3.98 | Stronger long-term fit under the project’s stated priorities |
| Meson + Ninja | 3.75 | Better short-term ergonomics, weaker long-term fit on repeatability and dependency ownership |

## Candidate Comparison Notes

### Bazel strengths

- Best match for the project’s top-ranked goal: reliability and repeatability.
- Strongest dependency model for replacing opaque CMake/discovery behavior with explicit ownership.
- Cleanest long-term story for CI command shape and one authoritative graph.

### Bazel weaknesses

- Higher authoring friction in the prototype itself.
- Weaker editor-metadata path unless extra tooling is adopted.
- Likely higher bridge pressure in early migration work.

### Meson strengths

- Faster path to real compilation attempts in a small prototype.
- Better immediate contributor UX and editor ergonomics.
- Lower build-definition burden for a brownfield C++ codebase.

### Meson weaknesses

- Weaker long-term dependency ownership story than Bazel for this project.
- Less aligned with the repo’s stated emphasis on explicit reproducibility.
- More likely to preserve a “good local build, weaker global build graph” shape.

## Decision Input

The weighted score favors **Bazel** under the project’s locked priorities, even though Meson is the easier Phase 1 prototype and remains the more credible fallback if Bazel later proves too painful in real migration work.

However, the hard-gate record is incomplete because Linux proof and Linux core-test proof were not executed in this macOS environment. That gap must remain explicit in the decision packet.

## Commands Run

### Bazel

```bash
cd .planning/phases/01-evaluate-build-system-fit/prototypes/bazel
npx -y @bazel/bazelisk version
npx -y @bazel/bazelisk build //:prusaslicer_cli_eval
```

### Meson

```bash
cd .planning/phases/01-evaluate-build-system-fit/prototypes/meson
python3 -m venv .venv
./.venv/bin/pip install meson==1.10.0
./.venv/bin/meson setup builddir
./.venv/bin/meson compile -C builddir prusaslicer_cli_eval
```
