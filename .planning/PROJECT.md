# PrusaSlicer Build Stack Modernization

## What This Is

This project delivered a Bazel-first authoritative build and tooling path for PrusaSlicer on Linux and macOS. The shipped v1.0 work replaced the old “choose between competing primary workflows” state with one documented command surface, one authoritative CI path, and one maintained contributor guide, while keeping the migration honestly bounded to the proven CLI/config slice instead of pretending whole-repo parity already exists.

PrusaSlicer remains the same brownfield C++ desktop application. The work shipped here is infrastructure and contributor-surface modernization: build orchestration, dependency policy, CI, developer tooling, and the minimum source seams required to prove the new path against the real codebase.

## Core Value

Maintainers and contributors can build, test, and work on PrusaSlicer through a simple, repeatable, authoritative toolchain on Linux and macOS.

## Current State

- **Shipped milestone:** `v1.0 Authoritative Build Path` on 2026-04-09
- **Completed milestone work:** `v1.1 Slice Deepening` planned phases finished on 2026-04-09 and are ready for archival
- **Authoritative local front door:** `./prusa build`, `./prusa test`, `./prusa fmt`, `./prusa lint`, `./prusa compdb`
- **Authoritative CI/docs:** `Authoritative Bazel CI` and `doc/Build and Tooling - Bazel.md`
- **Proven product slice:** `//src:PrusaSlicer` and `//tests/libslic3r:config_test` on macOS and Linux/arm64
- **Known bounded edges:** explicit unsupported-path runtime handoff, compat shim, vendor/system-library bridges, and intentionally bounded formatting/lint/test coverage

## Current Milestone: v1.1 Slice Deepening

**Goal:** Deepen the Bazel-owned product slice enough to retire the highest-value temporary execution bridges without widening scope into Windows or packaging.

**Target features:**
- Replace the current runtime handoff from `//src:PrusaSlicer` to the legacy locally built binary
- Deepen the Bazel-owned CLI/core path beyond the current `--help` and config-oriented proof slice
- Retire or materially narrow the highest-value temporary dependency bridges while keeping the same authoritative command surface
- Preserve one shared public label shape across macOS and Linux as ownership deepens

## Requirements

### Validated

- ✓ Bazel was evaluated against Meson + Ninja with explicit criteria before long-term migration work proceeded — v1.0
- ✓ Linux and macOS now have one authoritative build/test/tooling command surface instead of competing primary workflows — v1.0
- ✓ The bounded `PrusaSlicer` CLI/config slice is proven on macOS and Linux/arm64 through Bazel labels that maintainers can reproduce — v1.0
- ✓ Dependency ownership, bridge inventory, and system-library exceptions are explicit and reviewable instead of hidden in legacy side effects — v1.0
- ✓ Contributor workflows for test, format, lint, editor metadata, CI, and documentation now point at the Bazel-first path — v1.0
- ✓ A first non-help CLI workflow (`--save` with optional `--load`) now runs on macOS through Bazel-owned source without legacy `execv` handoff — Phase 7
- ✓ The primary Bazel runtime entrypoint now uses `src/PrusaSlicer.cpp`, and the broad macOS runtime lib bundle has been replaced with explicit imported artifacts — Phase 8
- ✓ The deeper owned slice now proves on Linux too, with separate runtime and test-only system-library exceptions — Phase 9
- ✓ Remaining deep-slice bridges are now tracked with explicit owner and retirement criteria, and the authoritative Bazel docs close the milestone honestly — Phase 10

### Active

- [ ] Retire the remaining unsupported `//src:PrusaSlicer` runtime handoff paths so the authoritative path executes a deeper Bazel-owned slice directly
- [ ] Deepen the Bazel-owned CLI/core slice beyond the current `--help` and config-only proof boundaries
- [ ] Replace the remaining highest-value temporary dependency bridges for the deeper slice with Bazel-owned or imported artifacts
- [ ] Keep the same authoritative public labels and `./prusa` command surface across macOS and Linux while the slice deepens

### Out of Scope

- New slicer end-user features — this project remains build/tooling/CI migration work
- Pretending whole-repo parity already exists — the shipped milestone is intentionally bounded and documents its edges
- Permanent dual maintenance of CMake and Bazel as equal primary workflows — tracked temporary overlap is acceptable, permanent split authority is not
- Windows as a first-class target in this milestone — still deferred until the deeper Linux/macOS slice is more fully owned
- Release packaging migration in this milestone — still deferred until the owned runtime slice is deeper and more stable

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

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition**:
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone**:
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

## Future Directions

- Add Windows as a first-class authoritative build target once the deeper Linux/macOS slice is stable.
- Move release packaging onto the authoritative build path after the runtime slice is more fully owned.
- Tighten validation coverage, including Nyquist artifacts, without reopening shipped milestone scope.

---
*Last updated: 2026-04-09 after Phase 10 completion*
