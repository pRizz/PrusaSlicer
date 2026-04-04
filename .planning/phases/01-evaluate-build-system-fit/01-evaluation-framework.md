# Phase 1 Evaluation Framework

**Phase:** 01 - Evaluate Build-System Fit  
**Date:** 2026-04-04  
**Status:** Active evaluation contract

## Purpose

This document defines how PrusaSlicer will evaluate Bazel versus Meson + Ninja for the future authoritative build path. It exists to keep the phase auditable, bounded, and reproducible by a maintainer who was not part of the original discussion.

The framework governs:
- weighted scoring,
- hard gates,
- parity gates,
- the exact definition of authority cutoff,
- and the outputs that must exist before a build-system decision is considered valid.

## Evaluation Goals

This phase is complete only when maintainers can:
- compare Bazel and Meson + Ninja against explicit migration criteria,
- select one authoritative build stack with rationale and rejection criteria,
- and point to written parity gates and authority-cutoff rules that prevent long-term dual-build drift.

## Weighted scorecard

### Priority Order

The scorecard must preserve the locked ranking from Phase 1 context:

1. Reliability and repeatability
2. Contributor UX
3. Maintenance burden
4. CI and platform fit
5. Dependency model quality

### Scoring Method

- Score each candidate on a 1-5 scale for every weighted dimension.
- Multiply raw score by the dimension weight.
- Record both raw score and weighted score.
- A candidate that fails any hard gate is disqualified even if its weighted score would otherwise win.
- Uncertainty must be written down explicitly. Unknowns do not get assumed as positives.

### Scorecard Dimensions

| Dimension | Weight | What it means in PrusaSlicer |
|-----------|--------|------------------------------|
| Reliability | 30 | Consistent command behavior, deterministic graph setup, clear failure modes, and low “works on my machine” risk |
| Contributor UX | 20 | Clear commands, approachable local setup, readable diagnostics, and realistic onboarding for maintainers/contributors |
| Developer ergonomics | 20 | `clangd` viability, format/lint command surface, and editor metadata quality |
| CI and platform fit | 15 | Credible Linux-first proof with macOS smoke-build path and clear CI command shape |
| Dependency model quality | 10 | Explicit, pinned, source-oriented dependency ownership with transparent exceptions |
| Maintenance burden | 5 | Amount of bespoke glue, bridge pressure, and likely long-term ownership cost |

### Score Interpretation

| Weighted result | Meaning |
|-----------------|---------|
| 4.0+ | Strong fit if hard gates pass |
| 3.0-3.9 | Potential fit, requires explicit tradeoff acceptance |
| <3.0 | Weak fit unless exceptional evidence justifies it |

## Hard gates

These are pass/fail. A candidate that fails any of them cannot become the selected authoritative path in Phase 1.

1. **Linux proof:** A real PrusaSlicer app-oriented target path builds on Linux.
2. **Core test proof:** At least one core Linux test target runs on the candidate path.
3. **macOS smoke-build check:** The candidate has a documented and credible macOS smoke-build path.
4. **Editor metadata:** `clangd` or equivalent editor metadata works without relying on the legacy build.
5. **Tooling surface:** Format/lint command shape is documented and credible.
6. **Command clarity:** The candidate has a short contributor-facing note explaining how to use it in this repo.
7. **Scope discipline:** The candidate proof remains inside Phase 1 boundaries and does not require full packaging, Windows, or full dependency migration to look viable.

## Parity Gates

Parity in Phase 1 does not mean full migration. It means the candidate demonstrates enough real product pressure to make the decision meaningful.

Phase 1 parity means:
- one real app-oriented PrusaSlicer slice is used,
- one core test target is exercised,
- Linux is the primary proof platform,
- macOS has at least a smoke-build check,
- editor metadata and format/lint surface are part of the comparison,
- CI command shape is explicit.

Phase 1 parity does **not** require:
- full GUI + CLI product parity,
- packaging parity,
- Windows support,
- or complete third-party dependency ownership.

## Authority cutoff

### Definition of “Authoritative”

The new build path becomes authoritative only when:
- Linux and macOS app builds work on the new path,
- core tests run on the new path,
- contributor tooling works on the new path,
- CI gates build/test/tooling changes through the new path,
- and the documented contributor entry point points at the new path first.

### Legacy Build Policy After Cutoff

After authority transfers:
- legacy build updates are allowed only for explicitly tracked temporary exceptions,
- every exception must name an owner and retirement criteria,
- new build-related changes must land in the new path first,
- and convenience or habit is not a valid reason to keep dual primary authority.

## Candidate Pass/Fail Rules

### Bazel

Bazel wins only if it:
- clears the hard gates,
- achieves the strongest weighted result,
- and does not rely on bridge-heavy scaffolding without a credible retirement path.

### Meson + Ninja

Meson + Ninja wins if Bazel fails the hard gates or if Meson clears them with a stronger overall tradeoff profile for PrusaSlicer.

Meson winning is a **valid success path** for the project. Phase 1 is about selecting the best authoritative future path, not proving Bazel at all costs.

## Evidence Rules

- Every score must cite concrete evidence or a clearly labeled uncertainty.
- Narrative preference is not enough.
- The losing candidate must have explicit rejection rationale.
- The winner must have explicit Phase 2 implications so later work does not reopen the choice casually.

## Plan 01-02 outputs

Plan 01-02 must produce all of the following:
- candidate proof artifacts for both Bazel and Meson + Ninja,
- weighted scorecard results,
- hard-gate pass/fail assessment,
- recommendation for one authoritative winner,
- rejection rationale for the loser,
- Decision packet for future maintainers,
- and the corresponding decision update in `.planning/PROJECT.md`.

## Requirement Mapping

### EVAL-01

This framework defines the criteria and scoring structure that make a candidate comparison possible.

### EVAL-03

This framework defines parity gates, hard gates, and authority-cutoff rules before candidate execution begins.

## Out of Scope for This Framework

- Choosing implementation details for Phase 2 build graph migration
- Packaging parity
- Windows migration
- Full dependency migration
- Full GUI parity

These belong to later phases even if they influence candidate tradeoffs.
