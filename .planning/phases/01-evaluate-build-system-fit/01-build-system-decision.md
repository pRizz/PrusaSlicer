# Phase 1 Build-System Decision

**Phase:** 01 - Evaluate Build-System Fit  
**Date:** 2026-04-04  
**Selected candidate:** Bazel  
**Rejected candidate:** Meson + Ninja  
**Fallback candidate:** Meson + Ninja

## Decision

Select **Bazel** as the authoritative build-system target for Phase 2 planning and migration work.

This selection is based on the weighted scorecard defined in `01-candidate-scorecard.md`, not on generic popularity or prior preference. Bazel wins because the project’s highest-ranked priorities are reliability/repeatability and explicit dependency ownership, and Bazel aligns with those better than Meson for a long-lived authoritative build path.

Meson + Ninja remains the explicit fallback if Bazel proves too painful when Phase 2 starts building the real root graph and dependency model.

This is now backed by Linux evidence, not just macOS-only prototype inference. Both Bazel and Meson were executed against the agreed Linux proof slice and both failed on concrete blockers, so the choice is no longer waiting on missing Linux execution. Instead, it reflects a comparison where neither shallow prototype cleared the hard gates, but Bazel still fits the project’s top-weighted long-term criteria better.

## Why Bazel Won

- It scored highest on the weighted criteria that matter most to this project.
- It aligns best with the repo’s need to replace opaque dependency/discovery behavior with an explicit graph.
- Its CI and authoritative-command story fits the roadmap’s end state more directly.
- After prototype blocker fixes, it reached real-source compilation pressure rather than remaining a purely paper comparison.

## Why Meson + Ninja Lost

- Meson was easier to prototype and is stronger on immediate ergonomics, but that did not outweigh Bazel’s advantage on the top-ranked criteria.
- Meson’s dependency model is more practical than CMake’s current state, but still weaker than Bazel’s for the repo’s explicit reproducibility goal.
- Choosing Meson would optimize the early migration path more than the long-term authoritative-build outcome.

## Explicit Uncertainties

This decision is strong enough to guide Phase 2, but it still carries these explicit risks:

- Neither candidate cleared the Linux app-build or Linux core-test proof bar with the intentionally shallow prototype.
- Bazel’s editor-metadata path was attempted through a concrete compile-commands extractor flow and still failed with a `py_binary` integration error under the current Bazel 9 prototype.
- Bazel’s format command shape is concrete, but `clang-tidy` remains unproven because the compile database was not generated and no local `clang-tidy` binary is available.

These are not hidden. The Linux proof gap is now an evidenced failure mode rather than an untested hole, and the Bazel tooling gap is now an evidenced integration problem rather than a vague risk.

## Phase 2 implication

Phase 2 should proceed as a **Bazel-first** root-graph effort with these early confirmation checks:

1. Prove the selected representative slice on Linux.
2. Prove at least one Linux core test target in a way that clears the current dependency/include-model blockers.
3. Resolve the compile-commands / editor-metadata path (`clangd` story) early, because the current prototype still fails there.
4. Reconfirm that bridge pressure is manageable and explicitly tracked.

If Bazel fails those confirmation checks in a way that materially violates the Phase 1 hard gates, the project should pivot to **Meson + Ninja** rather than force Bazel.

## Deferred from Phase 1

- Packaging parity
- Windows support
- Full third-party dependency migration
- Full GUI parity

These remain later-phase work and were not required to make the Phase 1 decision.
