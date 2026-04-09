# PrusaSlicer Build Stack Modernization

## What This Is

This project delivered a Bazel-first authoritative build and tooling path for PrusaSlicer on Linux and macOS. The shipped v1.0 work replaced the old “choose between competing primary workflows” state with one documented command surface, one authoritative CI path, and one maintained contributor guide, while keeping the migration honestly bounded to the proven CLI/config slice instead of pretending whole-repo parity already exists.

PrusaSlicer remains the same brownfield C++ desktop application. The work shipped here is infrastructure and contributor-surface modernization: build orchestration, dependency policy, CI, developer tooling, and the minimum source seams required to prove the new path against the real codebase.

## Core Value

Maintainers and contributors can build, test, and work on PrusaSlicer through a simple, repeatable, authoritative toolchain on Linux and macOS.

## Current State

- **Shipped milestone:** `v1.0 Authoritative Build Path` on 2026-04-09
- **Authoritative local front door:** `./prusa build`, `./prusa test`, `./prusa fmt`, `./prusa lint`, `./prusa compdb`
- **Authoritative CI/docs:** `Authoritative Bazel CI` and `doc/Build and Tooling - Bazel.md`
- **Proven product slice:** `//src:PrusaSlicer` and `//tests/libslic3r:config_test` on macOS and Linux/arm64
- **Known bounded edges:** explicit runtime handoff, entry shim, compat shim, vendor/system-library bridges, and intentionally bounded formatting/lint/test coverage

## Requirements

### Validated

- ✓ Bazel was evaluated against Meson + Ninja with explicit criteria before long-term migration work proceeded — v1.0
- ✓ Linux and macOS now have one authoritative build/test/tooling command surface instead of competing primary workflows — v1.0
- ✓ The bounded `PrusaSlicer` CLI/config slice is proven on macOS and Linux/arm64 through Bazel labels that maintainers can reproduce — v1.0
- ✓ Dependency ownership, bridge inventory, and system-library exceptions are explicit and reviewable instead of hidden in legacy side effects — v1.0
- ✓ Contributor workflows for test, format, lint, editor metadata, CI, and documentation now point at the Bazel-first path — v1.0

### Active

- [ ] Expand the authoritative product slice beyond the bounded CLI/config proof so more of the real application runs without legacy runtime handoff
- [ ] Replace the highest-value temporary bridges and Linux/macOS exception paths with narrower or fully owned Bazel imports
- [ ] Add Windows as a first-class authoritative build target
- [ ] Move release packaging onto the authoritative build path
- [ ] Ratchet bounded formatting/lint/tooling coverage toward broader repository enforcement without drowning in inherited debt

### Out of Scope

- New slicer end-user features — this project remains build/tooling/CI migration work
- Pretending whole-repo parity already exists — the shipped milestone is intentionally bounded and documents its edges
- Permanent dual maintenance of CMake and Bazel as equal primary workflows — tracked temporary overlap is acceptable, permanent split authority is not

## Context

PrusaSlicer is still a large C++17 desktop codebase with shared CLI and GUI flows, substantial `libslic3r` logic, wxWidgets/OpenGL UI layers, and a heavy third-party dependency footprint. The repo now also contains a real Bazel-first operating surface at the root, centralized policy files under `tools/bazel/`, bounded local tooling workflows, and authoritative Linux/macOS CI/doc wiring.

The shipped state is intentionally honest about scope. The migration proved a real product-oriented slice and made the new path authoritative for the supported workflows, but it did not claim that all packaging, GUI/runtime, or legacy-edge behavior is fully ported.

## Constraints

- **Tech stack:** Large existing C++17 desktop codebase with GUI, CLI, geometry-heavy libraries, and many third-party dependencies
- **Platform:** Linux and macOS are authoritative now; Windows remains future work
- **Compatibility:** Preserve existing product behavior closely enough for the authoritative slice to be credible without freezing the migration around obsolete edges
- **Dependency strategy:** Prefer explicit, reproducible ownership and track every exception or temporary bridge in one visible place
- **Scope:** Build, tooling, CI, and migration only; no product-feature expansion

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Include an explicit build-system evaluation phase | Bazel was preferred, but the repo needed a real decision rather than assumption | ✓ Validated in v1.0 |
| Select Bazel as the authoritative build target, with Meson + Ninja as fallback | Bazel best matched repeatability, CI, and long-term authority goals for this repo | ✓ Validated in v1.0 |
| Target Linux and macOS first | This kept the migration tractable while covering the first authoritative platforms | ✓ Validated in v1.0 |
| Use a thin `./prusa` wrapper as the front door | Contributors needed one obvious repo-root command surface without hiding Bazel’s shape completely | ✓ Validated in v1.0 |
| Keep system-library exceptions centralized and explicit | Exceptions were acceptable only if maintainers could name scope, rationale, and retirement conditions | ✓ Validated in v1.0 |
| Prove a bounded CLI/config slice before broader parity | A smaller real slice was more honest and achievable than fake whole-app claims | ✓ Validated in v1.0 |
| Prefer bounded high-signal tooling over broad noisy pseudo-parity | Contributor trust matters more than claiming repo-wide enforcement prematurely | ✓ Validated in v1.0 |
| Make the Bazel path authoritative before whole-repo parity | The repo needed one real source of truth; bounded explicit debt is better than permanent dual authority | ✓ Validated in v1.0 |

## Next Milestone Goals

- Deepen the Bazel-owned product slice enough to retire the current runtime handoff.
- Replace the most expensive or confusing temporary bridges with narrower owned imports.
- Decide how aggressively to pursue Windows and packaging in the next milestone.
- Tighten validation coverage, including Nyquist artifacts, without reopening the shipped v1.0 scope.

---
*Last updated: 2026-04-09 after v1.0 milestone completion*
