# Phase 1 Comparison Runbook

**Phase:** 01 - Evaluate Build-System Fit  
**Date:** 2026-04-04  
**Status:** Ready for candidate execution

## Purpose

This runbook defines the exact proof scope for comparing Bazel against Meson + Ninja in Phase 1. It translates the evaluation framework into a concrete, repeatable comparison that Plan 01-02 can execute without reopening scope or decision rules.

## Representative proof slice

Phase 1 must use the smallest slice that still reflects the real PrusaSlicer product shape.

### In scope

- `src/PrusaSlicer.cpp`
- `src/CLI/`
- `src/libslic3r/`
- one representative core test suite under `tests/`

### Recommended target focus

- Use the main `PrusaSlicer` application target shape as the app-oriented comparison anchor.
- Prefer a CLI-first path within that target shape before trying to represent the full GUI surface.
- Use one core test suite that exercises real repo structure rather than toy code. `tests/libslic3r/` is the first-choice representative suite because it touches the core slicing library and existing test wiring.

## Linux proof

Each candidate must produce the following Linux-side evidence:

1. A real app-oriented build path for the representative slice.
2. At least one core test target running through the candidate path.
3. Clear local commands that a contributor can follow without consulting the legacy build.
4. Enough evidence to score reliability, contributor UX, dependency pressure, and maintenance cost.

### Linux proof evidence checklist

- candidate command(s) used
- files or build definitions created
- target selected for the app-oriented proof
- test target selected
- outcome of build
- outcome of test
- notes on dependency friction or bridge pressure
- notes on diagnostics and contributor clarity

## macOS smoke-build

Phase 1 does not require full macOS parity. It does require a credible macOS smoke-build check.

Acceptable macOS smoke-build evidence:
- documented candidate commands,
- target viability assessment against the selected slice,
- environment or toolchain notes,
- and a clear pass/fail/uncertain conclusion.

The macOS check must be concrete enough to influence the final decision. It cannot be hand-waved as “probably fine.”

## Contributor workflows to compare

The comparison must explicitly cover:
- build command surface,
- core test execution,
- `clangd` or equivalent editor metadata path,
- formatting command surface,
- lint command surface,
- and contributor-facing onboarding clarity.

If a candidate makes one of these materially weaker, that must show up in the scorecard and hard-gate review.

## CI command shape

Phase 1 does not require a fully landed CI workflow, but it does require the exact CI command shape.

### CI command shape requirements

- Linux job commands must be written explicitly.
- macOS smoke-build commands must be written explicitly.
- Commands must mirror the local contributor commands where possible.
- Any missing CI preconditions must be called out as gaps, not implied away.

## Candidate execution sequence

For each candidate:

1. Establish the prototype sandbox or build definition slice for the representative proof target.
2. Attempt the Linux app-oriented proof.
3. Attempt the Linux core test proof.
4. Document editor metadata viability.
5. Document format/lint command viability.
6. Record macOS smoke-build check details.
7. Map the evidence back to the weighted scorecard and hard gates.

Do not interleave candidate conclusions before both candidates have been evaluated against the same runbook.

## Evidence recording rules

- Record the same categories of evidence for Bazel and Meson + Ninja.
- If evidence is missing, mark it as missing or uncertain instead of assuming success.
- If bridge mechanisms are needed, record where and why.
- If a candidate only works with a toy slice, treat that as insufficient proof rather than partial success.

## Deferred from Phase 1

The following are explicitly out of scope and must not be pulled into the candidate comparison as required proof:

- packaging parity
- Windows support
- full third-party dependency migration
- full GUI parity
- removal of CMake from the repo

These can influence notes and tradeoffs, but they are not required proof items for Phase 1 completion.

## Anti-scope guardrails

Stop and record a boundary breach if the comparison starts depending on:
- migrating broad dependency sets that belong in Phase 3,
- release packaging work that belongs later,
- Windows-specific build support,
- or full product-port completeness.

Phase 1 is a decision phase, not a migration phase.

## Plan 01-02 outputs

Plan 01-02 must produce all of the following:

- candidate sandbox artifacts,
- a weighted scorecard for Bazel,
- a weighted scorecard for Meson + Ninja,
- hard-gate outcomes for both candidates,
- a recommendation naming one winner,
- a rejection rationale for the loser,
- a short decision packet,
- and the project-level decision update in `.planning/PROJECT.md`.

## Handoff to Plan 01-02

Plan 01-02 must treat this runbook and the evaluation framework as the execution contract.

It must not:
- redefine the weighted scorecard,
- redefine the hard gates,
- widen the proof scope,
- or silently defer a required proof item.

It may:
- record uncertainties transparently,
- conclude that Bazel loses,
- or conclude that Meson + Ninja wins as the valid fallback outcome.
